#ifndef __my_if_h__
#include <xccompat.h>

#ifdef __XC__
interface my_if {
  void f(int x, int y);
  void g(int z);
};
#endif

/* These wrappers are for calling client interface functions from C */

void my_if_f(CLIENT_INTERFACE(my_if, i), int x, int y);
void my_if_g(CLIENT_INTERFACE(my_if, i), int z);


#endif
