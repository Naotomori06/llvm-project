// RUN: %clang_cc1 -triple x86_64-apple-darwin10 -emit-llvm %s -o - | FileCheck %s

#pragma GCC diagnostic ignored "-Wincompatible-ms-struct"
#define ATTR __attribute__((__ms_struct__))

struct ATTR VBase {
  virtual void foo() = 0;
};

struct ATTR Base : virtual VBase {
  virtual void bar() = 0;
};

struct ATTR Derived : Base {
  Derived();
  void foo();
  void bar();
  int value;
};

// CHECK: [[DERIVED:%.*]] = type <{ [[BASE:%.*]], i32, [4 x i8] }>
// CHECK: [[BASE]] = type { [[VBASE:%.*]] }
// CHECK: [[VBASE]] = type { ptr }

// CHECK: define{{.*}} void @_ZN7DerivedC2Ev
// CHECK:   [[SELF:%.*]] = load ptr
// CHECK:   call void @_ZN4BaseC2Ev(ptr {{[^,]*}} [[SELF]], ptr
// CHECK:   [[T0:%.*]] = getelementptr inbounds {{.*}} [[SELF]], i32 0, i32 1
// CHECK:   store i32 20, ptr [[T0]],
Derived::Derived() : value(20) {}
