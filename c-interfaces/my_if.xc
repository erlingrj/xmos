#include <my_if.h>

void my_if_f(CLIENT_INTERFACE(my_if, i), int x, int y)
{
  i.f(x,y);
}

void my_if_g(CLIENT_INTERFACE(my_if, i), int z)
{
  i.g(z);
}
