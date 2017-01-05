# 305263501 Yair Abramovitch
# i received help from ariel cohen and chaim rubinstien #
.section .rodata

#case51
old: .string "%c\n"
new: .string "%c\n"
invalidInput: .string "invalid input!\n"
#defaultcase
invalidEvent: .string "invalid option!\n"

.text
.globl pstrlen
  .type  pstrlen, @function
pstrlen:
  movzbq    (%rdi), %rax     # the return value will be the value that is at the first byte of the start of the pstring
  ret

.globl replaceChar
  .type  replaceChar, @function
  # the function receives two char, old and new and iterate the pString and replace every appearance #
  # of the old char by the new char #
  replaceChar:
  pushq   %r12               # we're backuping r12 for saving him and usign it later
  pushq   %r13               # we're backuping r13 for saving him and usign it later
  pushq   %r14               # we're backuping r14 for saving him and usign it later
  pushq   %r15               # we're backuping r15 for saving him and usign it later
  movq    %rdi, %r12         # storing the address of pString into r12
  movb    (%r12), %r13b      # sotring into r13b the size of the string so we can iterate it
  addq    $1, %r12           # point to the first char of the string
  movb    %sil, %r14b        # store the old char into r14b
  movb    %dl, %r15b         # store the new char into r15b

  .iterateToNextCahr:        # in this lable we do the checks we need for each iteration
  subq    $1, %r14           # update the counter by decreasing it
  cmpb    %r14b, (%r12)      # check if the chars are equales
  je      .switchChars       # if the cahrs are equales, we do the swich
  cmpq    $0, %r13           # if the arn't equals we check if we got to the end of the loop
  jle     .doneIterating     # if we at the end of loop, we go and return from the function
  incq    %r12               # if current char of string .globl replaceChar

  .switchCahrs:              # in this lable we do the swich
  movb    %r15b, (%r12)      # replacing the current char by the new char
  incq    %r12               # we point to the next char of the string for the next check
  jmp     .iterateToNextCahr # iterate the next char

  .doneIterating:
  popq   %r15                # pop r12 to clean the stack
  popq   %r14                # pop r12 to clean the stack
  popq   %r13                # pop r12 to clean the stack
  popq   %r12                # pop r12 to clean the stack
  ret

  # The function receives two indexes and and create new sub string that start
  # from the first index and ends in the second #
.globl pstrijcpy
  .type  pstrijcpy, @function
pstrijcpy:
  pushq  %r12	               # we're backuping r12 for saving him and usign it late
  pushq  %r13		             # we're backuping r13 for saving him and usign it late
  movq   %rdi, %r12		       # we backup the destanation pString so we can resotre it later
  addq   $1, %rdi            # set rdi to point the strat of the destanation string
  addq   %rdx, %rdi          # change rdi to points on the start index
  addq   $1, %rsi            # set rsi to point the strat of the source string
  addq   %rdx, %rsi          # change rsi to points on the start index

  # check if the start and the end indexes are valid and in the size of the string length ##
  movzbq  (%r12), %r9		     # store the length of the destanation string in r8
  movzbq  (%r13), %r10	     # store the length of rhe source string in r9
  cmpq    %rdx, %r9          # if the start index bigger than destanation length
  jl      .invalidInput      # print error massage
  cmpq    %rcx, %r9          # if the end index bigger than destanation length
  jl      .invalidInput      # print error massage
  cmpq    %rdx, %r10         # if the start index bigger than source length
  jl      .invalidInput      # print error massage
  cmpq    %rcx, %r10         # if the end index bigger than source length
  jl      .invalidInput      # print error massage

.copyLoop:
  cmpb   %dl, %cl            # while start index lesser than the end index
  jge    .copyChar           # copy the current char from source to destanation
  jmp    .end                # if we finished copy the strings

.copyChar:
  movb   (%rsi), %r8b        # store the currnet pointed char of the source string in r8b
  movb   %r8b, (%rdi)        # copy it to the currnet location of the destanation string
  addq   $1, %rdx            # increase the start index by 1
  addq   $1, %rdi            # move to the next char in the destanation string
  addq   $1, %rsi            # move to the next char in the source string
  jmp    .copyLoop           # continue the copy loop

.invalidInput:
  movq    $invalid, %rdi     # store the error massage in rdi
  movq    $0, %rax           # set rax to 0
  call    printf             # call printf
  popq    %r13               # pop r13 to claen the stack
  popq    %r12               # pop r12 to claen the stack
  ret

.end:
  movq   %r12, %rdi		       # store the modified string into rdi
  movq   %rdi, %rax          # return the modified string
  popq   %r13                # pop r13 to claen the stack
  popq   %r12                # pop r12 to claen the stack
  ret

# The function receives pString and changes all the it's lower case into upper #
# case and all it's upper case into lower #
.globl swapCase
  .type  swapCase, @function
swapCase:
   movzbq     (%rdi), %r8    # store the length of the string in r8
.iterateToNext:
   subq     $1, %r8          # decreasing the counter of the iteration
   addq     $1, %rdi         # change rdi to points the next char
   movsbq   (%rdi), %rcx     # store the char into rcx
   cmpq     $0, %r8          # checks if the loop ended
   jge      .charCheck       # checks if the current char is a letter
   jmp      .endOfLoop       # end the loop and return from the function

.charCheck:
  cmpq    $122, %rcx         # check if the ascii value of the current char is greater than 122
  ja      .iterateToNext     # if the ascii value is bigger,we don't switch
  cmpq    $65, %rcx          # check if the ascii value of the current char is lesser than 65
  jb      .iterateToNext     # if the ascii value is lesser,we don't switch
  cmpq    $90, %rcx          # check if the ascii value of the current char is greater than 90
  jb      .range90to97       # check if the ascii value is between 90-97
  jmp     .UpperToLower      # from upper to lower case

.range90to97:
  cmpq    $97, %rcx          # check if the ascii value of the current char is less than 97
  jb      .iterateToNext     # if the ascii value is between 90-97 we don't swap
  jmp     .LowerToUpper      # swithc from lowercase to uppercase

.UppperToLower:
  movsbq  (%rdi), %rdx       # store the currnet char in rdx
  addb    $32, %dl           # switch the char in the first byte to lower case
  movb    %dl, (%rdi)        # srotre the changed char back into the string
  jmp     .iterateToNext     # iterate next

.LowerToUpper:
  movsbq  (%rdi), %rdx       # store the currnet char in rdx
  subb    $32, %dl           # switch the char in the first byte to upper case
  movb    %dl, (%rdi)        # srotre the changed char back into the string
  jmp     .iterateToNext     # iterate next

.endOfLoop:
  ret                        # return from the function

# The function compare lexicographically the two string and return -1 if the fist #
# string is geater 0 if they're equales and 1 if the second string is greater #
.globl pstrijcmp
  .type  pstrijcmp, @function
pstrijcmp:
  pushq   %r12               # we're backuping r12 for saving him and usign it later
  pushq   %r13               # we're backuping r13 for saving him and usign it later
  movzbq  (%rdi), %r12       # sotre the length of the first string in r12
  movzbq  (%rsi), %r13       # store the length of the second string in r13
  addq    $1, %rdi           # points to the start of the string of pstr1
  addq    $1, %rsi           # points to the start of the string of pstr2
  addq    %rdx, %rdi         # rdi point to the start cmp index at the string
  addq    %rdx, %rsi         # rsi point to the start cmp index at the string

  # check if the indexes are valid #
  cmpq    %rdx, %r12         # if start index bigger than the first string length
  jl      .invalidindex      # print error massage
  cmpq    %rcx, %r12         # if end index bigger than the first string length
  jl      .invalidindex      # print error massage
  cmpq    %rdx, %r13         # if start index bigger than the second string length
  jl      .invalidindex      # print error massage
  cmpq    %rcx, %r13         # if end index bigger than the second string length
  jl      .invalidindex      # print error massage

.loopIteration:
  cmpq    %rcx, %rdx		     # check if the loop has been finished
  jg      .endFunc54		     # if it did, end the loop
  cmpb    %dl, %cl
  jge     .nextCmp 		       # get to next chars for next check
  jmp     .endFunc54

.nextCmp:
  movq    (%rdi), %r8        # srote the current chat of the first stting into r8
  movq    (%rsi), %r9        # srote the current chat of the second stting into r9
  cmpb    %r8b, %r9b         # compare the chars
  ja      .string1Bigger     # if the char of the first string is biiger
  jb      .string2Bigger     # if the char of the second string is biiger
  addq    $1, %rdx           # increase the counter
  addq    $1, %rdi           # move to the next char of the first string
  addq    $1, %rsi           # move to the next char of the second string
  jmp     .loopIteration     # continue the loop

.string1Bigger:
  movq    $-1, %rax          # if the first string bigger than the second we store -1 in rax
  popq    %r13               # pop r13 to claen the stack
  popq    %r12               # pop r12 to claen the stack
  ret

.string2Bigger:
  movq    $1, %rax           # if the second string bigger than the first we store -1 in rax
  popq    %r13               # pop r13 to claen the stack
  popq    %r12               # pop r12 to claen the stack
  ret

.invalidindex:
  movq    $invalid, %rdi     # store the error massage in rdi
  movq    $0, %rax           # set rax to 0
  call    printf             # call printf
  movq    $-2, %rax          # in that case return value -2
  popq    %r13               # pop r13 to claen the stack
  popq    %r12               # pop r12 to claen the stack
  ret

.endFunc54:
  movq    $0, %rax           # if the strings are equal we return 0
  popq    %r13               # pop r13 to claen the stack
  popq    %r12               # pop r12 to claen the stack
  ret
