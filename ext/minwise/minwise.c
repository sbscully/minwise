#include "minwise.h"

static VALUE mMinwise;
static VALUE cMinwiseMinhash;

static VALUE c_minhash(VALUE self, VALUE rb_set, VALUE rb_hash_len, VALUE rb_hash_seed) {
  Check_Type(rb_set, T_ARRAY);

  size_t rb_set_len = RARRAY_LEN(rb_set);
  size_t c_hash_len = NUM2SIZET(rb_hash_len);
  uint64_t c_hash_seed = NUM2ULONG(rb_hash_seed);

  uint32_t *c_set = (uint32_t *)malloc(rb_set_len * sizeof(uint32_t));
  for (size_t i = 0; i < rb_set_len; i++) {
    c_set[i] = NUM2UINT(rb_ary_entry(rb_set, i));
  }

  uint32_t *c_hash = (uint32_t *)malloc(c_hash_len * sizeof(uint32_t));
  minhash(c_set, rb_set_len, c_hash, c_hash_len, c_hash_seed);

  VALUE rb_hash = rb_ary_new_capa(c_hash_len);
  for (size_t i = 0; i < c_hash_len; i++) {
    rb_ary_store(rb_hash, i, UINT2NUM(c_hash[i]));
  }

  free(c_set);
  free(c_hash);

  return rb_hash;
}

static VALUE c_tokenize(VALUE self, VALUE rb_string, VALUE rb_shingle_size) {
  char *c_string = StringValueCStr(rb_string);
  size_t c_string_len = RSTRING_LEN(rb_string);
  size_t c_shingle_size = NUM2SIZET(rb_shingle_size);

  if (c_string_len <= c_shingle_size) {
    VALUE rb_tokens = rb_ary_new_capa(1);
    rb_ary_store(rb_tokens, 0, UINT2NUM(fnv1a(c_string)));

    return rb_tokens;
  }

  size_t rb_tokens_len = c_string_len - c_shingle_size + 1;
  VALUE rb_tokens = rb_ary_new_capa(rb_tokens_len);

  char buffer[c_shingle_size + 1];
  for (size_t i = 0; i < rb_tokens_len; i++) {
    for (size_t j = 0; j < c_shingle_size; j++) {
      buffer[j] = c_string[i + j];
    }
    buffer[c_shingle_size + 1] = 0;

    rb_ary_store(rb_tokens, i, UINT2NUM(fnv1a(buffer)));
  }

  return rb_tokens;
}

RUBY_FUNC_EXPORTED void
Init_minwise(void)
{
  mMinwise = rb_define_module("Minwise");
  cMinwiseMinhash = rb_define_class_under(mMinwise, "Minhash", rb_cObject);

  rb_define_singleton_method(cMinwiseMinhash, "__hash", c_minhash, 3);
  rb_define_singleton_method(cMinwiseMinhash, "__tokenize", c_tokenize, 2);
}
