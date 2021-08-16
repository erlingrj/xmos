// Copyright (c) 2014-2017, XMOS Ltd, All rights reserved
#include <xs1.h>
#include <platform.h>
#include <print.h>
#include <string.h>
#include <xscope.h>
#include "gpio.h"
#include "gptp.h"
#include "ethernet.h"
#include "smi.h"

on tile[1]: rgmii_ports_t rgmii_ports = RGMII_PORTS_INITIALIZER; // Fixed RGMII ports on Tile 1
on tile[1]: port p_smi_mdio = XS1_PORT_1C;
on tile[1]: port p_smi_mdc = XS1_PORT_1D;
on tile[1]: port p_eth_reset = XS1_PORT_4A;


[[combinable]]
void ar8035_phy_driver(client interface smi_if smi,
                client interface ethernet_cfg_if eth)
{
  ethernet_link_state_t link_state = ETHERNET_LINK_DOWN;
  ethernet_speed_t link_speed = LINK_1000_MBPS_FULL_DUPLEX;
  const int phy_reset_delay_ms = 1;
  const int link_poll_period_ms = 1000;
  const int phy_address = 0x4;
  timer tmr, tmr2;
  int t, t2;
  tmr :> t;
  tmr2 :> t2;
  p_eth_reset <: 0;
  delay_milliseconds(phy_reset_delay_ms);
  p_eth_reset <: 0xf;

  eth.set_ingress_timestamp_latency(0, LINK_1000_MBPS_FULL_DUPLEX, 200);
  eth.set_egress_timestamp_latency(0, LINK_1000_MBPS_FULL_DUPLEX, 200);

  eth.set_ingress_timestamp_latency(0, LINK_100_MBPS_FULL_DUPLEX, 350);
  eth.set_egress_timestamp_latency(0, LINK_100_MBPS_FULL_DUPLEX, 350);

  while (smi_phy_is_powered_down(smi, phy_address));

  // Disable smartspeed
  smi.write_reg(phy_address, 0x14, 0x80C);
  // Disable hibernation
  smi.write_reg(phy_address, 0x1D, 0xB);
  smi.write_reg(phy_address, 0x1E, 0x3C40);
  // Disable smart EEE
  smi.write_reg(phy_address, 0x0D, 3);
  smi.write_reg(phy_address, 0x0E, 0x805D);
  smi.write_reg(phy_address, 0x0D, 0x4003);
  smi.write_reg(phy_address, 0x0E, 0x1000);
  // Disable EEE auto-neg advertisement
  smi.write_reg(phy_address, 0x0D, 7);
  smi.write_reg(phy_address, 0x0E, 0x3C);
  smi.write_reg(phy_address, 0x0D, 0x4003);
  smi.write_reg(phy_address, 0x0E, 0);

  smi_configure(smi, phy_address, LINK_1000_MBPS_FULL_DUPLEX, SMI_ENABLE_AUTONEG);
  // Periodically check the link status
  while (1) {
    select {
    case tmr when timerafter(t) :> t:
      ethernet_link_state_t new_state = smi_get_link_state(smi, phy_address);
      // Read AR8035 status register bits 15:14 to get the current link speed
      if (new_state == ETHERNET_LINK_UP) {
        link_speed = (ethernet_speed_t)(smi.read_reg(phy_address, 0x11) >> 14) & 3;
      }
      if (new_state != link_state) {
        link_state = new_state;
        eth.set_link_state(0, new_state, link_speed);
      }
      t += link_poll_period_ms * XS1_TIMER_KHZ;
      break;
    }
  }
}

enum mac_rx_lp_clients {
  MAC_TO_PTP = 0,
  NUM_ETH_TX_LP_CLIENTS
};

enum mac_tx_lp_clients {
  PTP_TO_MAC = 0,
  NUM_ETH_RX_LP_CLIENTS
};

enum mac_cfg_clients {
  MAC_CFG_TO_PHY_DRIVER = 0,
  MAC_CFG_PTP,
  NUM_ETH_CFG_CLIENTS
};


enum ptp_chans {
  PTP_TO_TALKER = 0,
  PTP_TO_1722_1,
  NUM_PTP_CHANS
};


int main(void)
{
  // Ethernet interfaces and channels
  ethernet_cfg_if i_eth_cfg[NUM_ETH_CFG_CLIENTS];
  ethernet_rx_if i_eth_rx_lp[NUM_ETH_RX_LP_CLIENTS];
  ethernet_tx_if i_eth_tx_lp[NUM_ETH_TX_LP_CLIENTS];
  streaming chan c_eth_rx_hp;
  streaming chan c_eth_tx_hp;
  smi_if i_smi;
  streaming chan c_rgmii_cfg;

  // PTP channels
  chan c_ptp[NUM_PTP_CHANS];

  par
  {
    on tile[1]: rgmii_ethernet_mac(i_eth_rx_lp, NUM_ETH_RX_LP_CLIENTS,
                                   i_eth_tx_lp, NUM_ETH_TX_LP_CLIENTS,
                                   c_eth_rx_hp, c_eth_tx_hp,
                                   c_rgmii_cfg,
                                   rgmii_ports,
                                   ETHERNET_DISABLE_SHAPER);

    on tile[1].core[0]: rgmii_ethernet_mac_config(i_eth_cfg, NUM_ETH_CFG_CLIENTS, c_rgmii_cfg);
    on tile[1].core[0]: ar8035_phy_driver(i_smi, i_eth_cfg[MAC_CFG_TO_PHY_DRIVER]);

    on tile[1]: [[distribute]] smi(i_smi, p_smi_mdio, p_smi_mdc);

    on tile[0]: ptp_server(
        i_eth_rx_lp[MAC_TO_PTP],
        i_eth_tx_lp[PTP_TO_MAC],
        i_eth_cfg[MAC_CFG_PTP],
        c_ptp,
        NUM_PTP_CHANS,
        PTP_GRANDMASTER_CAPABLE);
    }
  return 0;
}
