# 305263501 Yair Abramovitch
# i received help from ariel cohen and chaim rubinstien #
.section .rodata

#case51
old: .string "%c"
new: .string "%c"
invalidInput: .string "invalid input!\n"
#defaultcase
invalidEvent: .string "invalid option!\n"

.text
.globl pstrlen
  .type  pstrlen, @function
pstrlen:
  movzbq    (%rdi), %rax       # the return value will be the value that is at the first byte of the start of the pstring
  ret

.globl replaceChar
  .type  replaceChar, @function
  # the function receives two char, old and new and iterate the pString and replace every appearance #
  # of the old char by the new char #
  replaceChar:
  pushq   %r12                    # we're backuping r12 for saving him and usign it later
  pushq   %r13                    # we're backuping r13 for saving him and usign it later
  pushq   %r14                    # we're backuping r14 for saving him and usign it later
  pushq   %r15                    # we're backuping r15 for saving him and usign it later
  movq    %rdi, %r12              # storing the address of pString into r12
  movb    (%r12), %r13b           # sotring into r13b the size of the string so we can iterate it
  addq    $1, %r12                # point to the first char of the string
  movb    %sil, %r14b             # store the old char into r14b
  movb    %dl, %r15b              # store the new char into r15b

  .iterateToNextCahr:             # in this lable we do the checks we need for each iteration
  subq    $1, %r14                # update the counter by decreasing it
  cmpb    %r14b, (%r12)           # check if the chars are equales
  je      .switchChars            # if the cahrs are equales, we do the swich
  cmpq    $0, %r13                # if the arn't equals we check if we got to the end of the loop
  jle     .doneIterating          # if we at the end of loop, we go and return from the function
  incq    %r12                    # if current char of string .globl replaceChar

  .switchCahrs:                   # in this lable we do the swich
  movb    %r15b, (%r12)           # replacing the current char by the new char
  incq    %r12                    # we point to the next char of the string for the next check
  jmp     .iterateToNextCahr      # iterate the next char

  .doneIterating:
  popq   %r15                     # pop r12 to clean the stack
  popq   %r14                     # pop r12 to clean the stack
  popq   %r13                     # pop r12 to clean the stack
  popq   %r12                     # pop r12 to clean the stack
  ret

  # The function receives two indexes and and create new sub string that start
  # from the first index and ends in the second #
.globl pstrijcpy
  .type  pstrijcpy, @function
pstrijcpy:
   pushq  %r12	                  # we're backuping r12 for saving him and usign it late
   pushq  %r13		                # we're backuping r13 for saving him and usign it late
   movq   %rdi, %r12		          # for restore to rdi
   addq   $1, %rdi                # now rdi point on the string of pstring1
   addq   %rdx, %rdi              # rdi now point at the start place to swap char
   addq   $1, %rsi                # now rdi point on the string of pstring2
   addq   %rdx, %rsi              # rsi now point at the start place to swap char

  # check if valid:
  movzbq  (%r12), %r8			        # the pstr1 length in r8
  movzbq  (%r13), %r9			        # the pstr2 length in r9

  cmpq    %rdx, %r8               # i>pstr1 length
  jl      .invalidInput
  cmpq    %rcx, %r8               # j>pstr1 length
  jl      .invalidInput
  cmpq    %rdx, %r9               # i>pstr2 length
  jl      .invalidInput
  cmpq    %rcx, %r9               # j>pstr2 length
  jl      .invalidInput

.startLoop:
   cmpb   %dl, %cl                # j => i go to change char else goto end case
   jge    .changeNextChar
   jmp    .end                    # if we end to change the right indexes end func

.changeNextChar:
   movb   (%rsi), %r8b            # get the byte into cl->rcx
   movb   %r8b, (%rdi)            # put cl into the current byte of rdi
   addq   $1, %rdx                # i++
   addq   $1, %rdi                # get to next char
   addq   $1, %rsi                # get to next char
   jmp    .startLoop              # and go again to start of the loop

.invalidInput:
  movq    $invalid, %rdi          # print the error
  movq    $0, %rax
  call    printf
  popq    %r13
  popq    %r12
  ret

.end:
   movq   %r12, %rdi		          # for convience
   movq   %rdi, %rax              # return value dst
   popq   %r13
   popq   %r12
   ret

.globl swapCase
  .type  swapCase, @function
swapCase:
   movzbq     (%rdi), %r8         # r8 have the length
.getNext:
   subq     $1, %r8               # i--
   addq     $1, %rdi              # rdi point to the next char
   movsbq   (%rdi), %rcx          # put the first byte into rcx
   cmpq     $0, %r8               # compare if continue the loop
   jge      .beforeSwap           # check what to do
   jmp      .endFunc              # out of loop

.beforeSwap:
  cmpq    $122, %rcx
  ja      .getNext                # greater than 122 ascii not swap
  cmpq    $65, %rcx
  jb      .getNext                # less than 65 ascii not swap
  cmpq    $90, %rcx
  ja      .needChaeck             # ccheck if 90-97
  jmp     .swapUpToLower          # from upper to lower case

.needChaeck:
  cmpq    $97, %rcx
  jb      .getNext                # not to swap
  jmp     .swapLowerToUp          # from lower to upper case

.swapUpToLower:
  movsbq    (%rdi), %rdx          # take the first 8 byte to rdx
  addb    $32, %dl                # change the char in the first byte to lower case
  movb    %dl, (%rdi)             # update rdi
  jmp     .getNext
.swapLowerToUp:
  movsbq    (%rdi), %rdx          # take the first 8 byte to rdx
  subb    $32, %dl                # change the char in the first byte to lower case
  movb    %dl, (%rdi)             # update rdi
  jmp     .getNext

.endFunc:
   ret

.globl pstrijcmp
  .type  pstrijcmp, @function
pstrijcmp:
  pushq   %r12                    # we need to backup r12 for saving him
  pushq   %r13                    # we need to backup r13 for saving him
  movzbq    (%rdi), %r12          # get the length of pstr1
  movzbq    (%rsi), %r13          # get the length of pstr2
  addq    $1, %rdi                # get to the start of the string of pstr1
  addq    $1, %rsi                # get to the start of the string of pstr2
  addq    %rdx, %rdi              # rdi point to the start cmp index at the string
  addq    %rdx, %rsi              # rsi point to the start cmp index at the string

  #check if valid:
  cmpq    %rdx, %r12              # i>pstr1 length
  jl      .invalid
  cmpq    %rcx, %r12              # j>pstr1 length
  jl      .invalid
  cmpq    %rdx, %r13              # i>pstr2 length
  jl      .invalid
  cmpq    %rcx, %r13              # j>pstr2 length
  jl      .invalid

.firstCheck:
  cmpq    %rcx, %rdx		          # condition for loop
  jg      .endFunc54		          # end loop
  cmpb    %dl, %cl
  jge     .nextCmp 		            # get to next chars for next check
  jmp     .endFunc54

.nextCmp:
  movq    (%rdi), %r8             # get the first 8 byte of pstr1 into r8
  movq    (%rsi), %r9             # get the first 8 byte of pstar2 into r9
  cmpb    %r8b, %r9b              # compare the bytes
  ja      .pstr1Bigger	          # pstr1 won
  jb      .pstr2Bigger	          # pstr2 won
  addq    $1, %rdx                # i++
  addq    $1, %rdi                # get to next char pstr1
  addq    $1, %rsi                # get to next char pstr2
  jmp     .firstCheck

.pstr1Bigger:
  movq    $-1, %rax               # pstr1>pstr2
  popq    %r13
  popq    %r12
  ret

.pstr2Bigger:
  movq    $1, %rax               # pstr2>pstr1
  popq    %r13
  popq    %r12
  ret

.invalid:
  movq    $invalid, %rdi          # print the error
  movq    $0, %rax
  call    printf
  movq    $-2, %rax               # in that case return value -2
  popq    %r13
  popq    %r12
  ret

.endFunc54:
  movq    $0, %rax                # same same-> value return 0
  popq    %r13
  popq    %r12
  ret
