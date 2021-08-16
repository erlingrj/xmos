#include <stdio.h>
#include <xcore/port.h>


int main(void)
{
    port_t button_port = XS1_PORT_4D, led_port = XS1_PORT_4C;

    port_enable(button_port); port_enable(led_port);

    while(1)
    {
        uint32_t button_state = port_in(button_port);
        port_set_trigger_in_not_equal(button_port, button_state);
        port_out(led_port, ~button_state & 0x01);
    }

    port_disable(button_port); port_disable(led_port);
}