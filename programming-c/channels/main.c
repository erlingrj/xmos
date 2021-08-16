#include <stdio.h>
#include <xcore/parallel.h>
#include <xcore/channel.h>


DECLARE_JOB(send, (chanend_t));
void send(chanend_t c)
{
    chan_out_word(c, 0x1234);
    printf("Sender Received %lX\n", chan_in_word(c));
}

DECLARE_JOB(recv, (chanend_t));
void recv(chanend_t c)
{
    uint32_t r = chan_in_word(c);
    printf("Recv Received %lX\n", r);
    chan_out_word(c, r+1);

}



int main(void)
{

    channel_t chan = chan_alloc();
    PAR_JOBS(
        PJOB(send, (chan.end_a)),
        PJOB(recv, (chan.end_b))
    );

    chan_free(chan);
}