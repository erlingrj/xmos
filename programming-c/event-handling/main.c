#include <platform.h>
#include <xcore/port.h>
#include <xcore/select.h>

int main(void)
{
  port_t button_port = XS1_PORT_4D,
         led_port = XS1_PORT_4C;

  port_enable(button_port);
  port_enable(led_port);

  SELECT_RES(
    CASE_THEN(button_port, on_button_change))
  {
  on_button_change: {
    unsigned long button_state = port_in(button_port);
    port_set_trigger_in_not_equal(button_port, button_state);
    port_out(led_port, ~button_state & 0x1);
    continue;
  }
  }

  port_disable(led_port);
  port_disable(button_port);
}