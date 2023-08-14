#include "minwise.h"

VALUE rb_mMinwise;

RUBY_FUNC_EXPORTED void
Init_minwise(void)
{
  rb_mMinwise = rb_define_module("Minwise");
}
