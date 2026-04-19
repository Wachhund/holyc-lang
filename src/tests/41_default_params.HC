#include "testhelper.HC"

I64 Add(I64 a, I64 b=10);
I64 Add(I64 a, I64 b) { return a + b; }

I64 Mul(I64 a, I64 b=3);
I64 Mul(I64 a, I64 b=3) { return a * b; }

I64 Sum3(I64 a, I64 b=2, I64 c=3);
I64 Sum3(I64 a, I64 b, I64 c) { return a + b + c; }

I64 Combo(I64 a, I64 b=20, I64 c=30);
I64 Combo(I64 a, I64 b, I64 c) { return a + b + c; }

I32 Main()
{
  "Test - Default parameters (proto->def merge):\n";
  I32 tests = 7, correct = 0;

  /* AC-1: Default in proto only */
  if (Add(5) == 15) correct++;
  else "\033[0;31mAC-1a FAILED\033[0;0m: Add(5)=%d\n", Add(5);
  if (Add(5, 20) == 25) correct++;
  else "\033[0;31mAC-1b FAILED\033[0;0m: Add(5,20)=%d\n", Add(5, 20);

  /* AC-2: Defaults in both */
  if (Mul(4) == 12) correct++;
  else "\033[0;31mAC-2a FAILED\033[0;0m: Mul(4)=%d\n", Mul(4);
  if (Mul(4, 5) == 20) correct++;
  else "\033[0;31mAC-2b FAILED\033[0;0m: Mul(4,5)=%d\n", Mul(4, 5);

  /* AC-3: Multiple defaults */
  if (Sum3(1) == 6) correct++;
  else "\033[0;31mAC-3a FAILED\033[0;0m: Sum3(1)=%d\n", Sum3(1);
  if (Sum3(1, 10, 100) == 111) correct++;
  else "\033[0;31mAC-3b FAILED\033[0;0m: Sum3(1,10,100)=%d\n", Sum3(1, 10, 100);

  /* AC-4: Skipped params */
  if (Combo(1,,5) == 26) correct++;
  else "\033[0;31mAC-4 FAILED\033[0;0m: Combo(1,,5)=%d\n", Combo(1,,5);

  PrintResult(correct, tests);
  "====\n";
  return 0;
}
