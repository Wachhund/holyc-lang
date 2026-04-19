#include "testhelper.HC"

I32 Main()
{
  "Test - Compiler Fixes (float formatting, defaults):\n";
  I32 tests = 3, correct = 0;

  // Float formatting via snprintf (libc) — validates PROJ-4/5 codegen
  F64 pi = 3.14;
  U8 fbuf[64];
  snprintf(fbuf, sizeof(fbuf), "%f", pi);
  if (strstr(fbuf, "3.14") != NULL) correct++;
  else "\033[0;31mTest 1 FAILED\033[0;0m: got %s\n", fbuf;

  F64 val = 2.5;
  snprintf(fbuf, sizeof(fbuf), "%.2f", val);
  if (strstr(fbuf, "2.5") != NULL) correct++;
  else "\033[0;31mTest 2 FAILED\033[0;0m: got %s\n", fbuf;

  // Negative handling with subtraction (no ternary used)
  I64 neg = -5;
  I64 absval;
  if (neg < 0) absval = 0 - neg;
  else absval = neg;
  if (absval == 5) correct++;
  else "\033[0;31mTest 3 FAILED\033[0;0m: got %d\n", absval;

  PrintResult(correct, tests);
  return correct != tests;
}
