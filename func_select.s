# 305263501 Yair Abramovitch
.section .rodata
.align 8
.casef:
  .quad .opp50
  .quad .opp51
  .quad .opp52
  .quad .opp53
  .quad .opp54
  .quad .oppdef

# case50 - print the pStrings lengths #
outputstring:  .string "%s"
opp50outPut:   .string "first pstring length: %d, second pstring length: %d"

# case51 - replacing old char by new onwe #
char:           string "%c"
opp51outPut:   .string "old char: %c, new char: %c, first string: %s, second string: %s\n"

# case52 - copy sub string of the pString #
startIndex:    .string "%d"
endIndex:      .string "%d"
opp52outPut:   .string "length: %d, string: %s\n"

# case53 replace uppercase to lowercase and the oppsite the pStrings lengths #
opp53outPut:   .string "length: %d, string: %s\n"

# case54 compare lexicographically the two pStrings and print the result #
opp54outPut:   .string "compare result: %d\n"
invalidOutPut: .string "invalid input!\n"

# defaultcase #
oppInvalid:    .string "invalid option!\n"

.data
.globl run_func
.type   run_func, @function

run_func:
# jump table-switch case
  leaq    -50(%rdi), %rdi      # get the right case
  cmpq    $4, %rdi             # check if we have valid mission if not go to default if<=4
  ja      .oppdef              # goto defaulf case
  jmp     *.casef(,%rdi,8)     # goto to the right case by jumping 8*(the case)

.opp50:
  movq    %rsi, %rdi           # store the first pstring to rdi
  movq    $0, %rax             # set rax to 0
  call    pstrlen              # call pstrlen function
  movq    %rax, %r12           # store the length of the second string into r12
  movq    %rdx, %rdi           # store the second pstring to rdi
  movq    $0, %rax             # set rax to 0
  call    pstrlen              # call pstrlen function
  movq    %rax, %r13           # store the length of the second string into r13
  movq    $opp50outPut, %rdi   # store opp50 format into rdi
  movq    %r8, %rsi            # first length into rsi
  movq    %r9, %rdx            # second length into rdx
  movq    $0, %rax             # set rax to 0
  call    printf               # print the lengths of the two pstrings
  ret

.opp51:
  pushq   %r12                 # backuping r12 for saving him and usign it later
  pushq   %r13                 # backuping r13 for saving him and usign it later
  pushq   %r14                 # backuping r14 for saving him and usign it later
  pushq   %r15                 # backuping r15 for saving him and usign it later
  movq    %rsi, %r12           # backup the first pstring in r12
  movq    %rdx, %r13           # backup the second pstring in r13

# sacn the old cahr that we wnat to replace #
  subq    $1, %rsp             # increase the stack space by 1 fot the first char
  movq    %rsp, %rsi           # store the location of the stack into rsi
  movq    $char, %rdi          # store the %c into rdi
  movq    $0, %rax             # set rax to 0
  call    scanf                # get dummy \n
  movb   (%rsp), %r14b         # convert the char into 8 bits place

# sacn the new cahr that we wnat to replace #
  subq    $1, %rsp             # increase the stack space by 1 for the second char
  movq    %rsp, %rsi           # store the location of the stack into rsi
  movq    $char, %rdi          # store the %c into rdi
  movq    $0, %rax             # set rax to 0
  call    scanf                # call scanf and receives the char
  movb    (%rsp), %r15b        # convert the char into 8 bits place

# sending the two pStrings and the two chars to replaceChar function #
# sending the first pString #
  movq    %r12, %rdi           # sotre the first pstring into rdi
  movb    %r14b, %sil          # store the old char in the second argument
  movb    %r15b, %dl           # store the new char in the third argument
  movq    $0, %rax             # set rax to 0
  call    replaceChar          # call replaceChar function

# sending the second pString #
  movq    %r13, %rdi           # sotre the second pstring into rdi
  movb    %r14b, %sil          # store the old char in the second argument
  movb    %r15b, %dl           # store the new char in the third argument
  movq    $0, %rax             # set rax to 0
  call    replaceChar          # call replaceChar function

# printing the opperation output #
  addq    $1, %r12             # we want only the string of pstring1
  addq    $1, %r13             # we want only the string of pstring2
  movq    $opp51outPut, %rdi   # format into rdi
  movb    %r14b, %sil          # old char into the second parameter
  movb    %r15b, %dl           # new char to the third parameter
  movq    %r12, %rcx           # string1 into the 4 parameter
  movq    %r13, %r8            # string2 into the 5 parameter
  call    printf

  #  addq    $4, %rsp             #
  popq    %r15                 # pop r15 for cleaning the stack
  popq    %r14                 # pop r14 for cleaning the stack
  popq    %r13                 # pop r13 for cleaning the stack
  popq    %r12                 # pop r12 for cleaning the stack
  ret

.opp52:
  pushq   %r12                 # backuping r12 for saving him and usign it later
  pushq   %r13                 # backuping r13 for saving him and usign it later
  pushq   %r14                 # backuping r14 for saving him and usign it later
  pushq   %r15                 # backuping r15 for saving him and usign it later
  movq    %rsi, %r12           # store the first pstring
  movq    %rdx, %r13           # store the second pstring

  subq    $4, %rsp             # increase the stack space for the strat index
  movq    %rsp, %rsi           # store the address of the current stack location in rsi
  movq    $startIndex, %rdi    # store the %d in rdi
  movq    $0, %rax
  call    scanf                # call scanf to receives the first index
  movzbq  (%rsp), %r14         # convert and store the index in form of 1 byte of in r14b
  addq    $4, %rsp             # rsp back to his place
  subq    $4, %rsp             # get place for the second int
  movq    %rsp, %rsi           # rsi will get the address of rsp
  movq    $endIndex, %rdi      # get the format into rdi
  movq    $0, %rax
  call    scanf                # call scanf with format and place for int
  movzbq  (%rsp), %r15         # put only the first byte of the int in r15b
  addq    $4, %rsp             # rsp back to his place
  movq    %r12, %rdi           # pstring1 into rdi
  movq    %r13, %rsi           # pstring2 into rsi
  movzbq  %r14b, %rdx          # we put only the last byte into dl->rdx
  movzbq  %r15b, %rcx          # we put only the last byte into cl->rcx
  movq    $0, %rax
  call    pstrijcpy
  movq    $format52, %rdi      # format into rdi
  movzbq  (%r12), %rsi         # the length into rsi
  addq    $1, %r12             # point onlt to the string
  movq    %r12, %rdx           # get the string into parameter for printf
  movq    $0, %rax
  call    printf
  movq    $format52, %rdi      # format into rdi
  movzbq  (%r13), %rsi         # the length into rsi
  addq    $1, %r13             # point onlt to the string
  movq    %r13, %rdx           # get the string into parameter for printf
  movq    $0, %rax
  call    printf
  popq    %r15                 # pop r15 for cleaning the stack
  popq    %r14                 # pop r14 for cleaning the stack
  popq    %r13                 # pop r13 for cleaning the stack
  popq    %r12                 # pop r12 for cleaning the stack

.case53:
  pushq   %r12                 # we need to backup r12 for saving him
  pushq   %r13                 # we need to backup r13 for saving him
  movq    %rsi, %r12           # save the first pstring
  movq    %rdx, %r13           # save the second pstring
  movq    %rsi, %rdi           # put the first pstring as the first parameter of the function
  movq    $0, %rax
  call    swapCase
  movq    %r13, %rdi           # put the second pstring as the first parameter of the function
  movq    $0, %rax
  call    swapCase
  movq    $format53, %rdi      # format into rdi
  movzbq  (%r12), %rsi         # the length into rsi
  addq    $1, %r12             # point only to the string
  movq    %r12, %rdx           # get the string into parameter for printf
  movq    $0, %rax
  call    printf
  movq    $format53, %rdi      # format into rsi
  movzbq  (%r13), %rsi         # the length into rsi
  addq    $1, %r13             # point only to the string
  movq    %r13, %rdx           # get the string into parameter for printf
  movq    $0, %rax
  call    printf
  popq    %r13                 # we need to backup r12 for saving him
  popq    %r12                 # we need to backup r13 for saving him
  ret
.case54:
  pushq   %r12                 # we need to backup r12 for saving him
  pushq   %r13                 # we need to backup r13 for saving him
  pushq   %r14                 # we need to backup r14 for saving him
  pushq   %r15                 # we need to backup r15 for saving him
  movq    %rsi, %r12           # save the first pstring
  movq    %rdx, %r13           # save the second pstring
  subq    $4, %rsp             # get place for the int
  movq    %rsp, %rsi           # rsi will get the address of rsp
  movq    $startIndex, %rdi    # get the format into rdi
  movq    $0, %rax
  call    scanf                # call scanf with format and place for int
  movzbq  (%rsp), %r14         # put only the first byte of the int in r14b
  addq    $4, %rsp             # rsp back to his place
  subq    $4, %rsp             # get place for the second int
  movq    %rsp, %rsi           # rsi will get the address of rsp
  movq    $endIndex, %rdi      # get the format into rdi
  movq    $0, %rax
  call    scanf                # call scanf with format and place for int
  movzbq  (%rsp), %r15         # put only the first byte of the int in r15b
  addq    $4, %rsp             # rsp back to his place
  movq    %r12, %rdi           # pstring1 into rdi
  movq    %r13, %rsi           # pstring2 into rsi
  movzbq  %r14b, %rdx          # we put only the last byte into dl->rdx
  movzbq  %r15b, %rcx          # we put only the last byte into cl->rcx
  call    pstrijcmp
  movq    %rax, %rsi
  movq    $format54, %rdi
  movq    $0, %rax
  call    printf
  popq    %r12                 # we need to restore r12 for saving him
  popq    %r13                 # we need to restore r13 for saving him
  popq    %r14                 # we need to restore r14 for saving him
  popq    %r15                 # we need to restore r15 for saving him
  ret

.casedef:
  movq    $oppInvalid, %rdi
  call    printf
  ret
