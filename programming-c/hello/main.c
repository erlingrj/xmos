#include <stdio.h>
#include <xcore/parallel.h>


DECLARE_JOB(say_hello, (int));
void say_hello(int my_id)
{
    printf("Hello from %d\n", my_id);
}


int main(void)
{
    PAR_JOBS(
        PJOB(say_hello, (0)),
        PJOB(say_hello, (1))
    );
}