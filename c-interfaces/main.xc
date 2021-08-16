#include <my_if.h>
#include <print.h>
extern void c_code(client interface my_if i);

void task1(server interface my_if i)
{
  while (1) {
    select {
    case i.f(int x, int y):
      printintln(x);
      printintln(y);
      break;
    case i.g(int z):
      printintln(z);
      break;
    }
  }
}

int main() {
  interface my_if i;
  par {
    c_code(i);
    task1(i);
  }
  return 0;
}