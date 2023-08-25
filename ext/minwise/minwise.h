#ifndef MINWISE_H
#define MINWISE_H 1

#include <stdint.h>
#include "ruby.h"

uint64_t randr(uint64_t min, uint64_t max, uint64_t seed);
uint32_t fnv1a(char *str);
void minhash(const uint32_t* set, const size_t set_len, uint32_t* hash, const size_t hash_len, uint64_t seed);

#endif /* MINWISE_H */
