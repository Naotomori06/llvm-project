//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <string>

// void resize(size_type n, charT c); // constexpr since C++20

#include <string>
#include <stdexcept>
#include <cassert>

#include "test_macros.h"
#include "min_allocator.h"

template <class S>
TEST_CONSTEXPR_CXX20 void test(S s, typename S::size_type n, typename S::value_type c, S expected) {
  if (n <= s.max_size()) {
    s.resize(n, c);
    LIBCPP_ASSERT(s.__invariants());
    assert(s == expected);
  }
#ifndef TEST_HAS_NO_EXCEPTIONS
  else if (!TEST_IS_CONSTANT_EVALUATED) {
    try {
      s.resize(n, c);
      assert(false);
    } catch (std::length_error&) {
      assert(n > s.max_size());
    }
  }
#endif
}

template <class S>
TEST_CONSTEXPR_CXX20 void test_string() {
  test(S(), 0, 'a', S());
  test(S(), 1, 'a', S("a"));
  test(S(), 10, 'a', S(10, 'a'));
  test(S(), 100, 'a', S(100, 'a'));
  test(S("12345"), 0, 'a', S());
  test(S("12345"), 2, 'a', S("12"));
  test(S("12345"), 5, 'a', S("12345"));
  test(S("12345"), 15, 'a', S("12345aaaaaaaaaa"));
  test(S("12345678901234567890123456789012345678901234567890"), 0, 'a', S());
  test(S("12345678901234567890123456789012345678901234567890"), 10, 'a', S("1234567890"));
  test(S("12345678901234567890123456789012345678901234567890"),
       50,
       'a',
       S("12345678901234567890123456789012345678901234567890"));
  test(S("12345678901234567890123456789012345678901234567890"),
       60,
       'a',
       S("12345678901234567890123456789012345678901234567890aaaaaaaaaa"));
  test(S(), S::npos, 'a', S("not going to happen"));
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
