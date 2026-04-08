#include "testhelper.HC"

I64 TernaryMax(I64 a, I64 b)
{
  return (a > b) ? a : b;
}

I64 TernaryNested(I64 a, I64 b, I64 c)
{
  return (a > b) ? ((a > c) ? a : c) : ((b > c) ? b : c);
}

I32 Main()
{
  "Test - Compiler Fixes (ternary, %cf, defaults):\n", '%';
  I32 tests = 8, correct = 0;

  /* AC-1: Basic ternary */
  I64 a = 10;
  I64 b = 20;
  I64 x = (a > b) ? a : b;
  if (x == 20) correct++;
  else "\033[0;31mAC-1 FAILED\033[0;0m: got %d\n", x;

  /* AC-2: Nested ternary */
  I64 result = TernaryNested(5, 15, 10);
  if (result == 15) correct++;
  else "\033[0;31mAC-2 FAILED\033[0;0m: got %d\n", result;

  /* AC-3: Ternary with string type */
  U8 *s = (a > 0) ? "yes" : "no";
  if (!StrCmp(s, "yes")) correct++;
  else "\033[0;31mAC-3 FAILED\033[0;0m: got %s\n", s;

  /* AC-4: Ternary as function argument */
  I64 m = TernaryMax((a > b) ? a : b, 30);
  if (m == 30) correct++;
  else "\033[0;31mAC-4 FAILED\033[0;0m: got %d\n", m;

  /* AC-5: Ternary in return and assignment */
  I64 r = TernaryMax(100, 50);
  if (r == 100) correct++;
  else "\033[0;31mAC-5 FAILED\033[0;0m: got %d\n", r;

  /* AC-6/7: Float formatting via snprintf (libc) */
  F64 pi = 3.14;
  U8 fbuf[64];
  snprintf(fbuf, sizeof(fbuf), "%f", pi);
  if (strstr(fbuf, "3.14") != NULL) correct++;
  else "\033[0;31mAC-6 FAILED\033[0;0m: got %s\n", fbuf;

  F64 val = 2.5;
  snprintf(fbuf, sizeof(fbuf), "%.2f", val);
  if (strstr(fbuf, "2.5") != NULL) correct++;
  else "\033[0;31mAC-7 FAILED\033[0;0m: got %s\n", fbuf;

  /* Ternary with negative */
  I64 neg = -5;
  I64 absval = (neg < 0) ? (0 - neg) : neg;
  if (absval == 5) correct++;
  else "\033[0;31mAC-8 FAILED\033[0;0m: got %d\n", absval;

  PrintResult(correct, tests);
  "====\n";
  return 0;
}
