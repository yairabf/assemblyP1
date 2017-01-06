.section        .rodata
strlength:      .string "%d"
strscan:        .string "%s"

.text
.global main
.type   main, @function
main:
    movq %rsp, %rbp #for correct debugging
    pushq   %rbp                # push rbp into the stack
    pushq   %r12                #
    movq    %rsp, %rbp          # saving the location of the start of the stack

    # scanning the size of the string ###
    subq    $4,%rsp             # resizing the stack by 4 to hold the int
    movq    %rsp, %rsi;         # sotre the current location of the stack in rsi
    movq    $strlength, %rdi    # store %d in rdi
    movq    $0,%rax             # set rax to 0
    call    scanf               # call scanf

    # change the size of the length we received to been represented on 1 byte
    movzbq  (%rsp), %r12        # store in   form of one byte
    addq    $4, %rsp            # resize the stack to original szie befor calling scanf
    subq    %r12, %rsp          # adding place for the string according the length
    subq    $1, %rsp            # add one place for the '/0'

    # scan the string
    movq    %rsp, %rsi          # store the location of the stack into rsi
    movq    $strscan, %rdi      # sotre the %s into rdi
    movq    $0, %rax            # set rax to 0
    call    scanf               # call scanf

    # storing the size of the string and the address of the first pString #
    subq    $1, %rsp            # add place for the size of the first string
    movb    %r12b, (%rsp)       # store the size of the string in the stack
    movq    %rsp, %r13          # store the address of the first pString

    # scanning the second pString
    # scanning the size of the string #
    subq    $4,%rsp             # resizing the stack by 4 to hold the int
    movq    %rsp, %rsi;         # sotre the current location of the stack in rsi
    movq    $strlength, %rdi    # store %d in rdi
    movq    $0,%rax             # set rax to 0
    call    scanf               # call scanf

    # change the size of the length we received to been represented on 1 byte #
    movzbq  (%rsp), %r12        # store in   form of one byte
    addq    $4, %rsp            # resize the stack to original szie befor calling scanf
    subq    %r12, %rsp          # adding place for the string according the length
    subq    $1, %rsp            # add one place for the '/0'

    # scan the string
    movq    %rsp, %rsi          # store the location of the stack into rsi
    movq    $strscan, %rdi      # sotre the %s into rdi
    movq    $0, %rax            # set rax to 0
    call    scanf               # call scanf

    # storing the size of the string and the address of the second pString
    subq    $1, %rsp            # add place for the size of the second string
    movb    %r12b, (%rsp)       # store the size of the string in the stack
    movq    %rsp, %r14          # store the address of the second pString

    ## scanning the number of operation ##
    subq    $4,%rsp             # resizing the stack by 4 to hold the int
    movq    %rsp, %rsi          # sotre the current location of the stack in rsi
    movq    $strlength, %rdi    # store %d in rdi
    movq    $0,%rax             # set rax to 0
    call    scanf               # call scanf
    movzbq  (%rsp), %rdi
    addq    $4, %rsp
    movq    %r13, %rsi
    movq    %r14, %rdx
    movq    $0, %rax
    call    run_func
    movq    %rbp, %rsp          # cleaning the stack
    popq    %r12
    popq    %rbp                # poping rbpcon
    ret
