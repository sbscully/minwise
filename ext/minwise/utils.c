#include "minwise.h"

uint64_t randr(uint64_t min, uint64_t max, uint64_t seed) {
  // xorshift*
  uint64_t x = seed + 1; // must not be zero
  x ^= x >> 12;
  x ^= x << 25;
  x ^= x >> 27;
  x *= 0x2545F4914F6CDD1DULL;

  return (uint64_t)(min + (double)x / UINT64_MAX * (max - min));
}

uint32_t fnv1a(char *str) {
  uint32_t hash = 0x811c9dc5;
  unsigned char *s = (unsigned char *)str;

  while (*s) {
    hash ^= (uint32_t)*s++;
    hash *= 0x01000193;
  }

  return hash;
}
