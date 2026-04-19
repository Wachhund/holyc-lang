#include "testhelper.HC"

F64 IdentityF64(F64 x)
{
  return x;
}

I64 IdentityI64(I64 x)
{
  return x;
}

I32 Main()
{
  "Test - bitcast<Type> operator:\n";
  I32 tests = 10, correct = 0;

  /* AC-1: I64 bits -> F64 (3.14 = 0x40091EB851EB851F = 4614253070214989087) */
  I64 pi_bits = 4614253070214989087;
  F64 f = bitcast<F64>(pi_bits);
  U8 fbuf[64];
  snprintf(fbuf, sizeof(fbuf), "%.2f", f);
  if (!StrCmp(fbuf, "3.14")) correct++;
  else "\033[0;31mAC-1 FAILED\033[0;0m: bitcast<F64>(pi_bits) => %s\n", fbuf;

  /* AC-2: F64 -> I64 bits */
  F64 pi = 3.14;
  I64 bits = bitcast<I64>(pi);
  if (bits == 4614253070214989087) correct++;
  else "\033[0;31mAC-2 FAILED\033[0;0m: bitcast<I64>(3.14) => %d\n", bits;

  /* AC-3: bitcast as function argument */
  I64 arg_bits = 4614253070214989087;
  F64 result = IdentityF64(bitcast<F64>(arg_bits));
  snprintf(fbuf, sizeof(fbuf), "%.2f", result);
  if (!StrCmp(fbuf, "3.14")) correct++;
  else "\033[0;31mAC-3 FAILED\033[0;0m: IdentityF64(bitcast<F64>(...)) => %s\n", fbuf;

  /* AC-4: bitcast with U8* (pointer from integer) */
  U8 *ptr = bitcast<U8*>(pi_bits);
  I64 ptr_val = bitcast<I64>(ptr);
  if (ptr_val == pi_bits) correct++;
  else "\033[0;31mAC-4 FAILED\033[0;0m: pointer round-trip => %d\n", ptr_val;

  /* AC-7: Normal postfix cast still does value conversion (no regression).
   * Note: I64->F64 cast is a known pre-existing compiler bug, so we test
   * I64->I8 downcast instead to verify cast<> still works. */
  I64 big = 0x6F6C6C6568;
  I8 ch = cast<I8>(big);
  if (ch == 'h') correct++;
  else "\033[0;31mAC-7 FAILED\033[0;0m: cast<I8> downcast broken\n";

  /* AC-8: bitcast<F64>(3) is NOT 3.0 (it's the float whose bits are 0x3) */
  I64 small = 3;
  F64 not_three = bitcast<F64>(small);
  snprintf(fbuf, sizeof(fbuf), "%.1f", not_three);
  if (StrCmp(fbuf, "3.0")) correct++;
  else "\033[0;31mAC-8 FAILED\033[0;0m: bitcast<F64>(3) should not be 3.0\n";

  /* Round-trip: bitcast<I64>(bitcast<F64>(x)) == x */
  I64 original = 123456789;
  I64 roundtrip = bitcast<I64>(bitcast<F64>(original));
  if (roundtrip == original) correct++;
  else "\033[0;31mRound-trip FAILED\033[0;0m: %d != %d\n", roundtrip, original;

  /* Conditional with bitcast (no ternary available yet) */
  I64 cond = 1;
  I64 a_bits = 4614253070214989087;
  I64 b_bits = 4607182418800017408; /* 1.0 */
  F64 ternary_result;
  if (cond) ternary_result = bitcast<F64>(a_bits);
  else      ternary_result = bitcast<F64>(b_bits);
  snprintf(fbuf, sizeof(fbuf), "%.2f", ternary_result);
  if (!StrCmp(fbuf, "3.14")) correct++;
  else "\033[0;31mTernary FAILED\033[0;0m: got %s\n", fbuf;

  /* F64 -> I64 -> F64 round-trip */
  F64 e = 2.71828;
  F64 e_roundtrip = bitcast<F64>(bitcast<I64>(e));
  snprintf(fbuf, sizeof(fbuf), "%.5f", e_roundtrip);
  if (!StrCmp(fbuf, "2.71828")) correct++;
  else "\033[0;31mF64 round-trip FAILED\033[0;0m: got %s\n", fbuf;

  /* bitcast with I64 result passed to function */
  F64 val = 1.5;
  I64 fn_result = IdentityI64(bitcast<I64>(val));
  F64 back = bitcast<F64>(fn_result);
  snprintf(fbuf, sizeof(fbuf), "%.1f", back);
  if (!StrCmp(fbuf, "1.5")) correct++;
  else "\033[0;31mFn-arg FAILED\033[0;0m: got %s\n", fbuf;

  PrintResult(correct, tests);
  return correct != tests;
}
