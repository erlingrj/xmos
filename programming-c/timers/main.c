#include <stdio.h>
#include "xcore/hwtimer.h"


int main(void)
{
    hwtimer_t timer = hwtimer_alloc();
    printf("TS=%ld\n", hwtimer_get_time(timer));
    hwtimer_delay(timer, 100);
    printf("TS=%ld\n", hwtimer_get_time(timer));

    hwtimer_free(timer);

    return 0;
}