#include <platform.h>

extern "C" {

void main_tile0();
void main_tile1();

}


int main(void)
{

par {
  on tile[0]: main_tile0();
  on tile[1]: main_tile1();
}
return 0;
}

