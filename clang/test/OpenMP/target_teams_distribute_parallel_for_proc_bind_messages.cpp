// RUN: %clang_cc1 -verify=expected,omp51 -fopenmp -ferror-limit 100 -o - %s -Wuninitialized

// RUN: %clang_cc1 -verify=expected,omp51 -fopenmp-simd -ferror-limit 100 -o - %s -Wuninitialized

// RUN: %clang_cc1 -verify=expected,omp50 -fopenmp -fopenmp-version=50 -ferror-limit 100 -o - %s -Wuninitialized

// RUN: %clang_cc1 -verify=expected,omp50 -fopenmp-simd -fopenmp-version=50 -ferror-limit 100 -o - %s -Wuninitialized

void foo();

template <class T, typename S, int N>
T tmain(T argc, S **argv) {
  T i;
#pragma omp target teams distribute parallel for proc_bind // expected-error {{expected '(' after 'proc_bind'}}
  for (i = 0; i < argc; ++i)
    foo();
#pragma omp target teams distribute parallel for proc_bind( // omp50-error {{expected 'master', 'close' or 'spread' in OpenMP clause 'proc_bind'}} omp51-error {{expected 'master', 'close', 'spread' or 'primary' in OpenMP clause 'proc_bind'}} expected-error {{expected ')'}} expected-note {{to match this '('}}
  for (i = 0; i < argc; ++i)
    foo();
#pragma omp target teams distribute parallel for proc_bind() // omp50-error {{expected 'master', 'close' or 'spread' in OpenMP clause 'proc_bind'}} omp51-error {{expected 'master', 'close', 'spread' or 'primary' in OpenMP clause 'proc_bind'}}
  for (i = 0; i < argc; ++i)
    foo();
#pragma omp target teams distribute parallel for proc_bind(master // expected-error {{expected ')'}} expected-note {{to match this '('}}
  for (i = 0; i < argc; ++i)
    foo();
#pragma omp target teams distribute parallel for proc_bind(close), proc_bind(spread) // expected-error {{directive '#pragma omp target teams distribute parallel for' cannot contain more than one 'proc_bind' clause}}
  for (i = 0; i < argc; ++i)
    foo();
#pragma omp target teams distribute parallel for proc_bind(x) // omp50-error {{expected 'master', 'close' or 'spread' in OpenMP clause 'proc_bind'}} omp51-error {{expected 'master', 'close', 'spread' or 'primary' in OpenMP clause 'proc_bind'}}
  for (i = 0; i < argc; ++i)
    foo();

#pragma omp target teams distribute parallel for proc_bind(master)
  for (i = 0; i < argc; ++i)
    foo();

#pragma omp parallel proc_bind(close)
#pragma omp target teams distribute parallel for proc_bind(spread)
  for (i = 0; i < argc; ++i)
    foo();

  return T();
}

int main(int argc, char **argv) {
  int i;
#pragma omp target teams distribute parallel for proc_bind // expected-error {{expected '(' after 'proc_bind'}}
  for (i = 0; i < argc; ++i)
    foo();
#pragma omp target teams distribute parallel for proc_bind( // omp50-error {{expected 'master', 'close' or 'spread' in OpenMP clause 'proc_bind'}} omp51-error {{expected 'master', 'close', 'spread' or 'primary' in OpenMP clause 'proc_bind'}} expected-error {{expected ')'}} expected-note {{to match this '('}}
  for (i = 0; i < argc; ++i)
    foo();
#pragma omp target teams distribute parallel for proc_bind() // omp50-error {{expected 'master', 'close' or 'spread' in OpenMP clause 'proc_bind'}} omp51-error {{expected 'master', 'close', 'spread' or 'primary' in OpenMP clause 'proc_bind'}}
  for (i = 0; i < argc; ++i)
    foo();
#pragma omp target teams distribute parallel for proc_bind(master // expected-error {{expected ')'}} expected-note {{to match this '('}}
  for (i = 0; i < argc; ++i)
    foo();
#pragma omp target teams distribute parallel for proc_bind(close), proc_bind(spread) // expected-error {{directive '#pragma omp target teams distribute parallel for' cannot contain more than one 'proc_bind' clause}}
  for (i = 0; i < argc; ++i)
    foo();
#pragma omp target teams distribute parallel for proc_bind(x) // omp50-error {{expected 'master', 'close' or 'spread' in OpenMP clause 'proc_bind'}} omp51-error {{expected 'master', 'close', 'spread' or 'primary' in OpenMP clause 'proc_bind'}}
  for (i = 0; i < argc; ++i)
    foo();

#pragma omp target teams distribute parallel for proc_bind(master)
  for (i = 0; i < argc; ++i)
    foo();

#pragma omp parallel proc_bind(close)
#pragma omp target teams distribute parallel for proc_bind(spread)
  for (i = 0; i < argc; ++i)
    foo();
  return tmain<int, char, 3>(argc, argv);
}
