// RUN: rm -rf %t
// RUN: rm -rf %t-saved
// RUN: mkdir %t-saved

// Initial module build
// RUN: %clang_cc1 -fmodules -fimplicit-module-maps -fbuiltin-headers-in-system-modules \
// RUN:     -fmodules-cache-path=%t -fdisable-module-hash -isystem %S/Inputs/System/usr/include \
// RUN:     -fsyntax-only %s -verify
// RUN: cp %t/cstd.pcm %t-saved/cstd.pcm

// Even with -Werror don't rebuild a system module
// RUN: %clang_cc1 -fmodules -fimplicit-module-maps -fbuiltin-headers-in-system-modules \
// RUN:     -fmodules-cache-path=%t -fdisable-module-hash -isystem %S/Inputs/System/usr/include \
// RUN:     -fsyntax-only %s -verify -Werror
// RUN: diff %t/cstd.pcm %t-saved/cstd.pcm

// Unless -Wsystem-headers is on
// RUN: %clang_cc1 -fmodules -fimplicit-module-maps -fbuiltin-headers-in-system-modules \
// RUN:     -fmodules-cache-path=%t -fdisable-module-hash -isystem %S/Inputs/System/usr/include \
// RUN:     -fsyntax-only %s -verify -Werror=unused -Wsystem-headers
// RUN: not diff %t/cstd.pcm %t-saved/cstd.pcm

// expected-no-diagnostics
@import cstd;
