#include <msp430.h>
#include <libemb/serial/serial.h>
#include <libemb/conio/conio.h>

int main(void) {
    WDTCTL  = WDTPW | WDTHOLD;
    BCSCTL1 = CALBC1_1MHZ;
    DCOCTL  = CALDCO_1MHZ;

    P1DIR  |= BIT0;

    serial_init(9600);

    for (;;) {
        P1OUT ^= BIT0;
        cio_printf("%s\n\r", "Hello, World!");
        __delay_cycles(500000);
    }

    return 0;
}

