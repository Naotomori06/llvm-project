// REQUIRES: arm-registered-target
// RUN: %clang_cc1 %s -emit-llvm -triple arm-apple-darwin -o - | FileCheck %s

int test (void *src) {
  register int w0 asm ("0");
  // CHECK: call i32 asm "ldr $0, [$1]", "={r0}{{.*}}(ptr
  asm ("ldr %0, [%1]": "=r" (w0): "r" (src));
  return w0;
}
