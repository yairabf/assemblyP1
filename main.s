.section        .rodata
strlength:      .string "%d"
strscan:        .string "%s"
pStringLengths: .string ""
.align 8                        # Align address to multiple of 8
.L10:
.quad .L50 # Case 50: loc_A
.quad .L51 # Case 51:loc_def
.quad .L52 # Case 52: loc_B
.quad .L53 # Case 53: loc_C
.quad .L54 # Case 54: loc_D
.quad .L55 # Case 55: loc_def
.text
.global main
.type   main, @function
main:
    pushq   %rbp                #push rbp into the stack
    pushq   %r12                #this fleaq -100(%rdi),%rsi # Compute xi = x-100

    ### scanning the size of the string ###
    subq    $4,%rsp             # resizing the stack by 4 to hold the int
    movq    %rsp, %rsi;         # sotre the current location of the stack in rsi
    movq    $strlength, %rdi    #store %d in rdi
    movq    $0,%rax             #set rax to 0

    call    scanf               #call scanf

    # change the size of the length we received to been represented on 1 byte
    movzbq  (%rsp), %r12        #store in   form of one byte
    addq    $4, %rsp            #resize the stack to original szie befor calling scanf
    subq    %r12, %rsp          #adding place for the string according the length
    subq    $1, %rsp            #add one place for the '/0'

    # scan the string
    movq    %rsp, %rsi          # store the location of the stack into rsi
    movq    $strscan, %rdi      # sotre the %s into rdi
    movq    $0, %rax            # set rax to 0

    call    scanf               # call scanf

    # storing the size of the string and the address of the first pString
    subq    $1, %rsp            # add place for the size of the first string
    movb    %r12b, (%rsp)       # store the size of the string in the stack
    movq    %rsp, %r13          # store the address of the first pString

    # scanning the second pString
    ### scanning the size of the string ###
    subq    $4,%rsp             #resizing the stack by 4 to hold the int
    movq    %rsp, %rsi;         #sotre the current location of the stack in rsi
    movq    $strlength, %rdi    #store %d in rdi
    movq    $0,%rax             #set rax to 0

    call    scanf               #call scanf

    # change the size of the length we received to been represented on 1 byte
    movzbq  (%rsp), %r12        #store in   form of one byte
    addq    $4, %rsp            #resize the stack to original szie befor calling scanf
    subq    %r12, %rsp          #adding place for the string according the length
    subq    $1, %rsp            #add one place for the '/0'

    # scan the string
    movq    %rsp, %rsi          # store the location of the stack into rsi
    movq    $strscan, %rdi      # sotre the %s into rdi
    movq    $0, %rax            # set rax to 0

    call    scanf               # call scanf
f
    # storing the size of the string and the address of the second pString
    subq    $1, %rsp            # add place for the size of the second string
    movb    %r12b, (%rsp)       # store the size of the string in the stack
    movq    %rsp, %r14          # store the address of the second pString

    leaq -100(%rdi),%rsi # Compute xi = x-100
    cmpq $4,%rsi # Compare xi:4
    ja .l55 # if >, goto default-case
    jmp *.L10(,%rsi,8) #
    L50:

    ret
