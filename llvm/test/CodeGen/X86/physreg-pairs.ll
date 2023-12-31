; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=i386-unknown-linux-gnu -o - %s | FileCheck %s

; To match GCC's behavior in assigning 64-bit values to a 32-bit
; register, we bind the a subsequence of 2 registers starting with the
; explicitly given register from the following sequence: EAX, EDX,
; ECX, EBX, ESI, EDI, EBP, ESP, to the value. There is no wrapping
; from the sequence, so this will fail given ESP.

define dso_local i64 @test_eax(i64 %in) local_unnamed_addr nounwind {
; CHECK-LABEL: test_eax:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl $-1985229329, %eax # imm = 0x89ABCDEF
; CHECK-NEXT:    movl $19088743, %edx # imm = 0x1234567
; CHECK-NEXT:    #APP
; CHECK-NEXT:    movl %eax, %eax
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    addl $3, %eax
; CHECK-NEXT:    movl %eax, %edx
; CHECK-NEXT:    sarl $31, %edx
; CHECK-NEXT:    retl
entry:
  %0 = tail call i64 asm sideeffect "mov $1, $0", "=r,{eax},~{dirflag},~{fpsr},~{flags}"(i64 81985529216486895)
  %conv = trunc i64 %0 to i32
  %add = add nsw i32 %conv, 3
  %conv1 = sext i32 %add to i64
  ret i64 %conv1
}

define dso_local i64 @test_edx(i64 %in) local_unnamed_addr nounwind {
; CHECK-LABEL: test_edx:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl $-1985229329, %edx # imm = 0x89ABCDEF
; CHECK-NEXT:    movl $19088743, %ecx # imm = 0x1234567
; CHECK-NEXT:    #APP
; CHECK-NEXT:    movl %edx, %eax
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    addl $3, %eax
; CHECK-NEXT:    movl %eax, %edx
; CHECK-NEXT:    sarl $31, %edx
; CHECK-NEXT:    retl
entry:
  %0 = tail call i64 asm sideeffect "mov $1, $0", "=r,{edx},~{dirflag},~{fpsr},~{flags}"(i64 81985529216486895)
  %conv = trunc i64 %0 to i32
  %add = add nsw i32 %conv, 3
  %conv1 = sext i32 %add to i64
  ret i64 %conv1
}

define dso_local i64 @test_ecx(i64 %in) local_unnamed_addr nounwind {
; CHECK-LABEL: test_ecx:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %ebx
; CHECK-NEXT:    movl $-1985229329, %ecx # imm = 0x89ABCDEF
; CHECK-NEXT:    movl $19088743, %ebx # imm = 0x1234567
; CHECK-NEXT:    #APP
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    addl $3, %eax
; CHECK-NEXT:    movl %eax, %edx
; CHECK-NEXT:    sarl $31, %edx
; CHECK-NEXT:    popl %ebx
; CHECK-NEXT:    retl
entry:
  %0 = tail call i64 asm sideeffect "mov $1, $0", "=r,{ecx},~{dirflag},~{fpsr},~{flags}"(i64 81985529216486895)
  %conv = trunc i64 %0 to i32
  %add = add nsw i32 %conv, 3
  %conv1 = sext i32 %add to i64
  ret i64 %conv1
}

define dso_local i64 @test_ebx(i64 %in) local_unnamed_addr nounwind {
; CHECK-LABEL: test_ebx:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %ebx
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:    movl $-1985229329, %ebx # imm = 0x89ABCDEF
; CHECK-NEXT:    movl $19088743, %esi # imm = 0x1234567
; CHECK-NEXT:    #APP
; CHECK-NEXT:    movl %ebx, %eax
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    addl $3, %eax
; CHECK-NEXT:    movl %eax, %edx
; CHECK-NEXT:    sarl $31, %edx
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    popl %ebx
; CHECK-NEXT:    retl
entry:
  %0 = tail call i64 asm sideeffect "mov $1, $0", "=r,{ebx},~{dirflag},~{fpsr},~{flags}"(i64 81985529216486895)
  %conv = trunc i64 %0 to i32
  %add = add nsw i32 %conv, 3
  %conv1 = sext i32 %add to i64
  ret i64 %conv1
}

define dso_local i64 @test_esi(i64 %in) local_unnamed_addr nounwind {
; CHECK-LABEL: test_esi:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %edi
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:    movl $-1985229329, %esi # imm = 0x89ABCDEF
; CHECK-NEXT:    movl $19088743, %edi # imm = 0x1234567
; CHECK-NEXT:    #APP
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    addl $3, %eax
; CHECK-NEXT:    movl %eax, %edx
; CHECK-NEXT:    sarl $31, %edx
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    popl %edi
; CHECK-NEXT:    retl
entry:
  %0 = tail call i64 asm sideeffect "mov $1, $0", "=r,{esi},~{dirflag},~{fpsr},~{flags}"(i64 81985529216486895)
  %conv = trunc i64 %0 to i32
  %add = add nsw i32 %conv, 3
  %conv1 = sext i32 %add to i64
  ret i64 %conv1
}

define dso_local i64 @test_edi(i64 %in) local_unnamed_addr nounwind {
; CHECK-LABEL: test_edi:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %ebp
; CHECK-NEXT:    pushl %edi
; CHECK-NEXT:    movl $-1985229329, %edi # imm = 0x89ABCDEF
; CHECK-NEXT:    movl $19088743, %ebp # imm = 0x1234567
; CHECK-NEXT:    #APP
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    addl $3, %eax
; CHECK-NEXT:    movl %eax, %edx
; CHECK-NEXT:    sarl $31, %edx
; CHECK-NEXT:    popl %edi
; CHECK-NEXT:    popl %ebp
; CHECK-NEXT:    retl
entry:
  %0 = tail call i64 asm sideeffect "mov $1, $0", "=r,{edi},~{dirflag},~{fpsr},~{flags}"(i64 81985529216486895)
  %conv = trunc i64 %0 to i32
  %add = add nsw i32 %conv, 3
  %conv1 = sext i32 %add to i64
  ret i64 %conv1
}

define dso_local i64 @test_ebp(i64 %in) local_unnamed_addr nounwind {
; CHECK-LABEL: test_ebp:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %ebp
; CHECK-NEXT:    movl $-1985229329, %ebp # imm = 0x89ABCDEF
; CHECK-NEXT:    movl $19088743, %esp # imm = 0x1234567
; CHECK-NEXT:    #APP
; CHECK-NEXT:    movl %ebp, %eax
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    addl $3, %eax
; CHECK-NEXT:    movl %eax, %edx
; CHECK-NEXT:    sarl $31, %edx
; CHECK-NEXT:    popl %ebp
; CHECK-NEXT:    retl
entry:
  %0 = tail call i64 asm sideeffect "mov $1, $0", "=r,{ebp},~{dirflag},~{fpsr},~{flags}"(i64 81985529216486895)
  %conv = trunc i64 %0 to i32
  %add = add nsw i32 %conv, 3
  %conv1 = sext i32 %add to i64
  ret i64 %conv1
}

