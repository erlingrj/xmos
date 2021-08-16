#include <platform.h>
#include <ethernet.h>

port p_eth_rxclk = XS1_PORT_1J;
port p_eth_rxd = XS1_PORT_4E;
port p_eth_txd = XS1_PORT_4F;
port p_eth_rxdv = XS1_PORT_1K;
port p_eth_txen = XS1_PORT_1L;
port p_eth_txclk = XS1_PORT_1I;
port p_eth_rxerr = XS1_PORT_1P;
port p_eth_timing = XS1_PORT_8C;
clock eth_rxclk = XS1_CLKBLK_1;
clock eth_txclk = XS1_CLKBLK_2;


int make_ethernet_frame(unsigned char data[n],
                        unsigned n,
                        unsigned char eth_packet[ETHERNET_MAX_PACKET_SIZE],
                        const unsigned char src_mac_addr[MACADDR_NUM_BYTES],
                        const unsigned char dest_mac_addr[MACADDR_NUM_BYTES])
{
    for (int i = 0; i<6; i++) {
        eth_packet[i] = dest_mac_addr[i];
        eth_packet[i + 6] = src_mac_addr[i];
    }

    eth_packet[12]= 0x08;
    eth_packet[13] = 0x00;

    for (int i = 0; i<n; i++) {
        eth_packet[14 + i] = data[i];
    }


    return 14+n;

}



void application(client ethernet_cfg_if i_cfg,
                client ethernet_rx_if i_rx,
                client ethernet_tx_if i_tx
                )
{
    ethernet_macaddr_filter_t macaddr_filter;
    size_t index = i_rx.get_index();
    for (int i = 0; i < MACADDR_NUM_BYTES; i++)
    {
        macaddr_filter.addr[i] = i;
    }
        
    i_cfg.add_macaddr_filter(index, 0, macaddr_filter);
    

    unsigned char payload[11] = {'H','E','L','L','O',' ','W','O','R','L','D'};
    unsigned char dest_mac[6] = {6,9,6,9,6,9};
    unsigned char src_mac[6] = {9,6,9,6,9,6};

    uint8_t packet[ETHERNET_MAX_PACKET_SIZE];
    
 
    int len = make_ethernet_frame(payload, 11, packet,dest_mac, src_mac);


    while (1) { 
        i_tx.send_packet(packet, len, ETHERNET_ALL_INTERFACES);
        }
    }


int main()
{

    ethernet_cfg_if i_cfg[1];
    ethernet_rx_if i_rx[1];
    ethernet_tx_if i_tx[1];
    par {
        mii_ethernet_mac(i_cfg, 1, i_rx, 1, i_tx, 1,
            p_eth_rxclk, p_eth_rxerr, p_eth_rxd, p_eth_rxdv,
            p_eth_txclk, p_eth_txen, p_eth_txd, p_eth_timing,
            eth_rxclk, eth_txclk, 1600);
        
        application(i_cfg[0], i_rx[0], i_tx[0]);
        
        }
    return 0;
}