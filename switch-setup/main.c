#include <stdio.h>
#include <xcore/channel.h>

#define ITERATIONS 10

void main_tile0(chanend_t c)
{
  int result = 0;
  
  printf("Tile 0: Result %d\n", result);

  chan_out_word(c, ITERATIONS);
  result = chan_in_word(c);

  printf("Tile 0: Result %d\n", result);
}

void main_tile1(chanend_t c)
{
  int iterations = chan_in_word(c);

  int accumulation = 0;

  for (int i = 0; i < iterations; i++)
  {
    accumulation += i;
    printf("Tile 1: Iteration %d Accumulation: %d\n", i, accumulation);
  }

  chan_out_word(c, accumulation);
}