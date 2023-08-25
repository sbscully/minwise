#include "minwise.h"

void minhash(const uint32_t* set, const size_t set_len, uint32_t* hash, const size_t hash_len, uint64_t seed) {
  const uint64_t p = 4294967311; // first prime greater than UINT32_MAX
  uint64_t a, b;
  uint32_t x, h;

  for (size_t i = 0; i < hash_len; i++) {
    a = randr(0, p, seed + i);
    a = (a / 2) * 2 - 1; // must be odd
    b = randr(0, p, a);

    h = UINT32_MAX;
    for (size_t j = 0; j < set_len; j++) {
      x = (uint32_t)(((a * set[j] + b) % p) % UINT32_MAX);

      if (x < h) {
        h = x;
      }
    }

    hash[i] = h;
  }
}
