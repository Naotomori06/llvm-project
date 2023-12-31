//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <string>

// we get this comparison "for free" because the string implicitly converts to the string_view

#include <string>
#include <cassert>

#include "test_macros.h"
#include "min_allocator.h"

template <class S, class SV>
TEST_CONSTEXPR_CXX20 void test(SV lhs, const S& rhs, bool x) {
  assert((lhs != rhs) == x);
}

template <class S>
TEST_CONSTEXPR_CXX20 void test_string() {
  typedef std::string_view SV;
  test(SV(""), S(""), false);
  test(SV(""), S("abcde"), true);
  test(SV(""), S("abcdefghij"), true);
  test(SV(""), S("abcdefghijklmnopqrst"), true);
  test(SV("abcde"), S(""), true);
  test(SV("abcde"), S("abcde"), false);
  test(SV("abcde"), S("abcdefghij"), true);
  test(SV("abcde"), S("abcdefghijklmnopqrst"), true);
  test(SV("abcdefghij"), S(""), true);
  test(SV("abcdefghij"), S("abcde"), true);
  test(SV("abcdefghij"), S("abcdefghij"), false);
  test(SV("abcdefghij"), S("abcdefghijklmnopqrst"), true);
  test(SV("abcdefghijklmnopqrst"), S(""), true);
  test(SV("abcdefghijklmnopqrst"), S("abcde"), true);
  test(SV("abcdefghijklmnopqrst"), S("abcdefghij"), true);
  test(SV("abcdefghijklmnopqrst"), S("abcdefghijklmnopqrst"), false);
}

TEST_CONSTEXPR_CXX20 bool test() {
  test_string<std::string>();
#if TEST_STD_VER >= 11
  test_string<std::basic_string<char, std::char_traits<char>, min_allocator<char>>>();
#endif

  return true;
}

int main(int, char**) {
  test();
#if TEST_STD_VER > 17
  static_assert(test());
#endif

  return 0;
}
