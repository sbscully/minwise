#ifndef MINWISE_H
#define MINWISE_H 1

#include <stdint.h>
#include "ruby.h"

uint64_t randr(uint64_t min, uint64_t max, uint64_t seed);
uint32_t fnv1a(char *str);

#endif /* MINWISE_H */
