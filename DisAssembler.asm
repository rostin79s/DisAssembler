%include "in_out.asm"


section .data
    filename2 db "command.txt",0
    fdin dq 0                       ;file descriptor for input file
    fdout dq 0                      ;fie descriptor for output file


    flaglast dq 0

    reg_bit dq 0
    mem_bit dq 0
    op_num dq 0

    registers db "rax:000 rcx:001 rdx:010 rbx:011 rsp:100 rbp:101 rsi:110 rdi:111 \
    eax:000 ecx:001 edx:010 ebx:011 esp:100 ebp:101 esi:110 edi:111 \
    ax:000 cx:001 dx:010 bx:011 sp:100 bp:101 si:110 di:111 \
    al:000 cl:001 dl:010 bl:011 ah:100 ch:101 dh:110 bh:111 \
    r8:000 r9:001 r10:010 r11:011 r12:100 r13:101 r14:110 r15:111 \
    r8d:000 r9d:001 r10d:010 r11d:011 r12d:100 r13d:101 r14d:110 r15d:111 \
    r8w:000 r9w:001 r10w:010 r11w:011 r12w:100 r13w:101 r14w:110 r15w:111 \
    r8b:000 r9b:001 r10b:010 r11b:011 r12b:100 r13b:101 r14b:110 r15b:111",NL

    registers64 db "rax:0000 rcx:0001 rdx:0010 rbx:0011 rsp:0100 rbp:0101 rsi:0110 rdi:0111 r8:1000 r9:1001 r10:1010 r11:1011 r12:1100 r13:1101 r14:1110 r15:1111",NL
    registers32 db "eax:0000 ecx:0001 edx:0010 ebx:0011 esp:0100 ebp:0101 esi:0110 edi:0111 r8d:1000 r9d:1001 r10d:1010 r11d:1011 r12d:1100 r13d:1101 r14d:1110 r15d:1111",NL
    registers16 db "ax:0000 cx:0001 dx:0010 bx:0011 sp:0100 bp:0101 si:0110 di:0111 r8w:1000 r9w:1001 r10w:1010 r11w:1011 r12w:1100 r13w:1101 r14w:1110 r15w:1111",NL
    registers8 db "al:0000 cl:0001 dl:0010 bl:0011 ah:0100 ch:0101 dh:0110 bh:0111 r8b:1000 r9b:1001 r10b:1010 r11b:1011 r12b:1100 r13b:1101 r14b:1110 r15b:1111",NL

    opcodes db "stc:11111001 clc:11111000 std:11111101 cld:11111100 syscall:0000111100000101 ret:11000011 \
inc:1111111 dec:1111111 neg:1111011 not:1111011 idiv:1111011 imul:1111011,1111011,0000111110101111,0000111110101111 pop:01011,10001111 push:01010,11111111,01101010,01101000 ret:11000010 \
jmp:11101011,11101001,11111111,11111111 call:11101000,11111111,11111111 jrcxz:11100011 mov:1000100,1000101,1000101,1000100,1100011,1011,1100011 \
add:0000000,0000001,0000001,0000000,100000,0000010,100000 adc:0001000,0001001,0001001,0001000,100000,0001010,100000 \
sub:0010100,0010101,0010101,0010100,100000,0010110,100000 sbb:0001100,0001101,0001101,0001100,100000,0001110,100000 \
and:0010000,0010001,0010001,0010000,100000,0010010,100000 or:0000100,0000101,0000101,0000100,100000,0000110,100000 \
xor:0011000,0011001,0011001,0011000,100000,0011010,100000 cmp:0011100,0011100,0011100,0011101,100000,0011110,100000 \
test:1000010,1000010,1111011,1010100,1111011 xchg:1000011,10010,1000011 xadd:000011111100000,000011111100000 \
imul:0000111110101111,0000111110101111 shl:1101000,1101000,1101001,1101001,1100000,1100000 \
shr:1101000,1101000,1101001,1101001,1100000,1100000 bsf:0000111110111100,0000111110111100 bsr:0000111110111101,0000111110111101",NL



    addFamilyValues db "add:000 or:001 adc:010 sbb:011 and:100 sub:101 xor:110 cmp:111",NL
    addFamily db "add adc sub sbb and or xor cmp",NL

    testFamily db "not neg idiv imul test",NL
    testFamilyValues db "test:000 not:010 neg:011 idiv:111 imul:101",NL


    incFamily db "inc dec",NL
    incFamilyValues db "inc:000 dec:001",NL

    pushFamily db "inc dec push",NL
    pushFamilyValues db "inc:000 dec:001 push:110",NL

    shiftFamily db "shr shl",NL
    shiftFamilyValues db "shl:100 shr:101",NL

    

    oneOperandFamily db "inc dec not neg pop push",NL
    twoOperandFamily db "mov add adc sub sbb and or xor cmp bsf bsr test xadd xchg",NL

    one db "0x1",NL

    prefix66 db "01100110",NL
    prefix67 db "01100111",NL

    rexflag dq 0
    rex4 db "0100",NL
    rexw db "0",NL
    r db "0",NL
    x db "0",NL
    b db "0",NL 

    mod1 db "00",NL
    mod2 db "01",NL
    mod3 db "10",NL
    mod4 db "11",NL

    rm1 db "100",NL
    reg1 db "000",NL

    scale1 db "00",NL
    scale2 db "01",NL
    scale3 db "10",NL
    scale4 db "11",NL

    index1 db "100",NL
    base1 db "101",NL

    move db "mov",NL
    i_test db "test",NL
    i_xchg db "xchg",NL
    i_xadd db "xadd",NL
    i_idiv db "idiv",NL
    i_imul db "imul",NL
    shift db "shl shr",NL
    bs db "bsf bsr",NL
    i_ret db "ret",NL
    pp db "push pop",NL
    i_jmp db "jmp",NL
    i_call db "call",NL
    i_jcc db "jcc",NL
    i_jrcxz db "jrcxz",NL




    four db "0100",NL
    six db "0110",NL
    seven db "0111",NL

    space db " ",NL


    mem_byte db "BYTE",NL
    mem_word db "WORD",NL
    mem_dword db "DWORD",NL
    mem_qword db "QWORD",NL
    mem_ptr db "PTR",NL

    zero db "0x0",NL

    scales db "1:00 2:01 4:10 8:11",NL

    i_push db "push",NL

    i_add db "add",NL

    i_neg db "neg",NL
    
    i_mov db "mov",NL

    muldiv db "imul idiv",NL

section .bss
    filename resb 100

    binary resb 400
    command resb 100
    operand1 resb 50
    operand2 resb 50
    memory resb 50
    binmem resb 100         ;this is part of binary for our memory
    instruction resb 10
    opcode resb 17
    modrm resb 9
    regcode resb 5

    w resb 2
    s resb 2


    mod resb 3 
    reg resb 4
    rm resb 4

    scale resb 3
    sc resb 2
    index resb 4
    base resb 4

    register resb 5
    opsize resb 6

    data resb 50
    disp resb 50
    hex resb 50

    regi resb 4

section .text
    global _start 


%macro init 0
    ; mov byte [prefix],0xA
    ; mov byte [rex],0xA
    mov byte [opcode],0xA
    ; mov byte [modrm],0xA
    ; mov byte [sib],0xA
    ; mov byte [displacement],0xA
    ; mov byte [data],0xA

    mov qword [reg_bit],32
    mov qword [mem_bit],64
    mov qword [rexflag],0
    mov byte [rexw],'0'
    mov byte [r],'0'
    mov byte [x],'0'
    mov byte [b],'0'
%endmacro


%macro dummy 1
    push rax
    mov rax,%1
    call writeNum
    call newLine
    pop rax
%endmacro

%macro write 1
    push rax
    mov rax,%1
    call writeNum
    call newLine
    pop rax
%endmacro

;print strings that end with newline
%macro print 1              
    push rax
    push rsi

    mov rax,0
    mov rsi,%1
%%body_print:
    mov al,[rsi]
    call putc
    cmp al,0xA
    je %%end_print
    inc rsi
    jmp %%body_print
%%end_print:
    pop rsi
    pop rax

%endmacro

;gets length of memory and stores it in rax
%macro len 1
    push rsi

    mov rax,0
    mov rsi,%1
%%body_len:
    mov bl,byte [rsi]
    cmp bl,0xA
    je %%end_len
    inc rax
    inc rsi
    jmp %%body_len

%%end_len:
    pop rsi
%endmacro


%macro member 2
    push rbx
    push rsi
    push rdi

    mov rax,0
    mov rsi,%1      ;our instruction
    mov rdi,%2      ;our list
%%start_m:

    mov bl,[rsi]
    cmp bl,0xA
    je %%equal_m
    cmp bl,[rdi]
    jne %%next_m
    inc rsi
    inc rdi
    jmp %%start_m
%%next_m:
    inc rdi
    cmp byte [rdi],0x20
    je %%reset_m
    cmp byte [rdi],0xA
    je %%end_m
    jmp %%next_m
%%reset_m:
    inc rdi
    mov rsi,%1
    jmp %%start_m
%%equal_m:
    mov rax,1
%%end_m:
    pop rdi
    pop rsi 
    pop rbx
%endmacro



%macro search 4
    push rbx 
    push rcx 
    push r8 
    push rsi
    push rdi 

    mov rax,0
    mov rsi,%1      ;we want to search this
    mov rdi,%3      ;the dictionary we search in
    mov rcx,%2      ;size of the thing we want to search

    mov rbx,%4      ;result we want
    mov r8,0        ;return index
%%inst_s:
    mov al,[rdi]
    cmp al,0xA
    je %%notfound_s
    cmp al,':'
    je %%next_s
    mov [rbx],al
    inc rdi
    inc rbx
    jmp %%inst_s

%%next_s:
    mov byte [rbx],0xA
    inc rdi
%%match_s:
    mov al,[rsi]
    cmp rcx,0
    je %%check_s
    cmp al,[rdi]
    jne %%next2_s
    inc rsi
    inc rdi
    dec rcx
    jmp %%match_s
%%next2_s:
    cmp byte [rdi],','
    je %%next3_s
    cmp byte [rdi],' '
    je %%next4_s
    cmp byte [rdi],0xA
    je %%notfound_s
    inc rdi
    jmp %%next2_s
%%next3_s:
    inc rdi
    inc r8
    mov rsi,%1
    mov rcx,%2
    jmp %%match_s
%%next4_s:
    mov r8,0
    inc rdi
    mov rsi,%1
    mov rcx,%2
    mov rbx,%4
    jmp %%inst_s

%%check_s:
    cmp byte [rdi],','
    je %%end_s
    cmp byte [rdi],' '
    je %%end_s
    cmp byte [rdi],0xA
    je %%end_s
    jmp %%next2_s 
%%notfound_s:
    mov r8,-1
%%end_s:
    mov rax,r8          ;rax returns index of string found
    pop rdi 
    pop rsi 
    pop r8 
    pop rcx
    pop rbx

%endmacro


%macro copy 3
    push rax
    push rcx 
    push rsi 
    push rdi 
    
    mov rsi,%1
    mov rdi,%3
    mov rcx,%2
%%body_c:
    cmp rcx,0
    je %%end_c
    mov al,[rsi]
    mov [rdi],al
    inc rsi 
    inc rdi
    dec rcx
    jmp %%body_c
%%end_c:
    mov byte [rdi],0xA

    pop rdi 
    pop rsi 
    pop rcx
    pop rax

%endmacro


%macro compare 2
    push rbx
    push rsi
    push rdi
    mov rax,0
    mov rsi,%1
    mov rdi,%2
%%body_compare:
    mov bl,[rdi]
    cmp bl,0xA
    je %%equal_compare
    cmp bl,[rsi]
    jne %%end_compare
    inc rsi
    inc rdi
    jmp %%body_compare
%%equal_compare:
    mov rax,1
%%end_compare:
    pop rdi
    pop rsi
    pop rbx

%endmacro

; this macro gets reg code and reg_bit or mem_bit and returns the register in register
%macro getregister 2
    push rax

    mov rax,%2
    
    cmp rax,8
    je %%eight_gr
    cmp rax,16
    je %%sixteen_gr
    cmp rax,32
    je %%thirtytwo_gr
    cmp rax,64
    je %%sixtyfour_gr

%%eight_gr:
    search %1,4,registers8,register
    jmp %%end_gr
%%sixteen_gr:
    search %1,4,registers16,register
    jmp %%end_gr
%%thirtytwo_gr:
    search %1,4,registers32,register
    jmp %%end_gr
%%sixtyfour_gr:
    search %1,4,registers64,register
    jmp %%end_gr
%%end_gr:
    pop rax
%endmacro


; this macro uses reg_bit and sets operation size (DWORD QWORD etc) in opsize variable.
%macro operationSize 0
    push rax
    
    mov rax,[reg_bit]
    cmp rax,8
    je %%byte_os
    cmp rax,16
    je %%word_os
    cmp rax,32
    je %%dword_os
    cmp rax,64
    je %%qword_os
%%byte_os:
    copy mem_byte,4,opsize
    jmp %%end_os
%%word_os:
    copy mem_word,4,opsize
    jmp %%end_os
%%dword_os:
    copy mem_dword,5,opsize
    jmp %%end_os
%%qword_os:
    copy mem_qword,5,opsize
    jmp %%end_os
%%end_os:
    pop rax


%endmacro

%macro binToHex 1
    push rax
    push rbx
    push rcx
    push rdx
    push r8
    push rsi
    push rdi

    mov rsi,%1
    mov rdi,%1
%%start_bTH:
    cmp byte [rsi],0xA
    je %%end_bTH
    mov rax,8
    mov rbx,2
    mov rcx,4
    mov r8,0
%%loop_bTH:
    cmp rcx,0
    je %%after_bTH
    mov dl,[rsi]
    cmp dl,'1'
    je %%add_bTH
    jmp %%next_bTH
%%add_bTH:
    add r8,rax
%%next_bTH:
    dec rcx
    mov rdx,0
    div rbx
    inc rsi
    jmp %%loop_bTH
%%after_bTH:
    cmp r8,10
    jl %%digit_bTH
    add r8,87
    mov byte [rdi],r8b
    inc rdi
    jmp %%start_bTH
%%digit_bTH:
    add r8,48
    mov byte [rdi],r8b
    inc rdi
    jmp %%start_bTH
%%end_bTH:
    mov byte [rdi],0xA
    pop rdi
    pop rsi
    pop r8
    pop rdx 
    pop rcx 
    pop rbx 
    pop rax 
%endmacro

;gets data or disp and stores it in hex
%macro dispdata 1
    push rax
    push rcx
    push rdx
    push rsi
    push rdi

    binToHex %1

    mov rsi,%1


    len rsi
    add rsi,rax
    mov rdi,hex
    mov byte [rdi],'0'
    mov byte [rdi+1],'x'
    add rdi,2
    mov rcx,0
    mov rdx,0
%%body_dd:
    cmp rsi,%1
    je %%hex_dd
    cmp byte [rsi-2],'0'
    je %%zero_dd
    mov rdx,-1
    jmp %%else_dd
%%checkzero_dd:
    cmp rcx,0
    je %%removezero_dd
    jmp %%else_dd
%%removezero_dd:
    mov al,[rsi-1]
    mov [rdi],al
    add rdi,1
    sub rsi,2
    mov rcx,-1
    jmp %%body_dd

%%else_dd:
    mov al,[rsi-2]
    mov [rdi],al 
    mov al,[rsi-1]
    mov [rdi+1],al 
    add rdi,2 
    sub rsi,2
    mov rcx,-1
    jmp %%body_dd

%%zero_dd:
    cmp byte [rsi-1],'0'
    je %%doublezero_dd
    mov rdx,-1
    jmp %%checkzero_dd

%%doublezero_dd:
    sub rsi,2
    jmp %%body_dd
%%hex_dd:
    cmp rdx,0
    je %%setzero_dd
    jmp %%else2_dd
%%setzero_dd:
    mov byte [rdi],'0'
    inc rdi
    jmp %%else2_dd

%%else2_dd:
    mov byte [rdi],0xA
    pop rdi
    pop rsi 
    pop rdx
    pop rcx 
    pop rax





%endmacro



readname:
    push rax
    push rsi

    mov rsi,filename
body_rd:
    call getc
    cmp rax,0xA
    je end_rd
    mov [rsi],al
    inc rsi
    jmp body_rd
end_rd:
    mov byte [rsi],0

    pop rsi
    pop rax
    ret


_start:
    call rostin
_exit:
    mov rax,60
    xor rdi,rdi
    syscall

rostin:
    call readname

    mov rax,2
    mov rdi,filename
    mov rsi,O_RDWR
    syscall                         ;open input file
    mov [fdin],rax

    mov rax,85
    mov rdi,filename2
    mov rsi,sys_IRUSR | sys_IWUSR
    syscall                         ;open output file
    mov [fdout],rax 

    call readInput

    mov rax,3
    mov rdi,[fdin]                  ;close input file
    syscall

    mov rax,3
    mov rdi,[fdout]                 ;close output file
    syscall

    ret


readInput:
    mov rbx,binary
bodyrI:
    mov rax,0
    mov rdi,[fdin]
    mov rsi,rbx
    mov rdx,1
    syscall

    cmp rax,rdx
    jl endOfFile


    cmp byte [rbx],0xA             ;if newline then we have read a line. end of our command is the newline character
    je executeBinary

    inc rbx

    jmp bodyrI


executeBinary:
    call parse
    mov rbx,binary
    jmp bodyrI

endOfFile:
    mov byte [rbx],0xA          ;add newline to the end of the last command
    call parse
    ret
;this function parses our binary input and outputs the assembly command
parse:
    init
    mov rsi,binary

    compare rsi,six

    cmp rax,1
    je prefix_p
    jmp rex_p

prefix_p:
    add rsi,4
    compare rsi,seven
    cmp rax,1
    je prefix67_p
    compare rsi,six
    cmp rax,1
    je prefix66_p
    jmp notprefix_p
prefix67_p:
    mov qword [mem_bit],32
    add rsi,4
    compare rsi,six
    cmp rax,1
    je prefix6766_p
    jmp rex_p
prefix66_p:
    mov qword [reg_bit],16
    add rsi,4
    jmp rex_p
prefix6766_p:
    mov qword [reg_bit],16
    add rsi,8
    jmp rex_p

notprefix_p:
    sub rsi,4
    jmp rex_p

rex_p:
    compare rsi,four
    cmp rax,1
    je rexbits_p
    jmp opcode_p
rexbits_p:
    add rsi,4
    copy rsi,1,rexw
    add rsi,1
    copy rsi,1,r
    add rsi,1
    copy rsi,1,x
    add rsi,1
    copy rsi,1,b 
    add rsi,1

    cmp byte [rexw],'1'
    je rex64_p
    jmp opcode_p
rex64_p:
    mov qword [reg_bit],64
    jmp opcode_p
    


opcode_p:

    call findOpcode


instruction_p:
    ; print instruction
    ; print rsi
    ; write [op_num]

    cmp byte [rsi],0xA
    je opcodeEnd_p
    
    
    copy rsi,2,mod
    add rsi,2
    copy rsi,3,reg
    add rsi,3
    copy rsi,3,rm
    sub rsi,5

    compare instruction,i_neg
    cmp rax,1
    je testfamily_p
    jmp elsetestfamily_p
testfamily_p:
    search reg,3,testFamilyValues,instruction
    compare instruction,i_test
    cmp rax,1
    je testreg_p
    jmp elsetestfamily_p
testreg_p:
    mov qword [op_num],2
elsetestfamily_p:


    member instruction,oneOperandFamily
    cmp rax,1
    je oneOperand_p

    compare instruction,i_ret
    cmp rax,1
    je ret_p

    member instruction,twoOperandFamily
    cmp rax,1
    je twoOperand_p

    member instruction,shiftFamily
    cmp rax,1
    je shift_p

    member instruction,muldiv
    cmp rax,1
    je muldiv_p

shift_p:
    search reg,3,shiftFamilyValues,instruction
    cmp qword [op_num],0
    je shift0_p
    cmp qword [op_num],4
    je shift4_p
shift0_p:
    compare mod,mod4
    cmp rax,1
    je shiftreg_p
    jmp shiftmem_p
shift4_p:
    compare mod,mod4
    cmp rax,1
    je shiftregdata_p
    jmp shiftmemdata_p
shiftreg_p:
    mov r9,regcode
    copy b,1,r9 
    inc r9 
    copy rm,3,r9 
    getregister regcode,qword [reg_bit]
    len register
    copy register,rax,operand1
    mov byte [operand2],'1'
    mov byte [operand2+1],0xA
    jmp elsetwoOperand_p

shiftmem_p:
    len rsi 
    copy rsi,rax,binmem
    call getmemory
    len memory
    copy memory,rax,operand1
    mov byte [operand2],'1'
    mov byte [operand2+1],0xA
    jmp elsetwoOperand_p

shiftregdata_p:
    mov r9,regcode
    copy b,1,r9 
    inc r9 
    copy rm,3,r9 
    getregister regcode,qword [reg_bit]
    len register
    copy register,rax,operand1

    add rsi,8
    len rsi
    print rsi
    copy rsi,rax,data
    dispdata data
    len hex
    copy hex,rax,operand2
    jmp elsetwoOperand_p
shiftmemdata_p:
    len rsi 
    sub rax,8
    copy rsi,rax,binmem
    add rsi,8
    call getmemory
    len memory
    copy memory,rax,operand1

    len rsi
    copy rsi,rax,data
    dispdata data
    len hex
    copy hex,rax,operand2

    jmp elsetwoOperand_p

muldiv_p:
    cmp qword [op_num],0
    je muldiv0_p
    cmp qword [op_num],2
    je muldiv2_p
muldiv0_p:
    compare mod,mod4
    cmp rax,1
    je muldivreg_p
    jmp muldivmem_p
muldiv2_p:
    compare mod,mod4
    cmp rax,1
    je mulregreg_p
    jmp mulregmem_p

muldivreg_p:
    mov r9,regcode
    copy b,1,r9 
    inc r9 
    copy rm,3,r9 
    getregister regcode,qword [reg_bit]
    len register
    copy register,rax,operand1
    jmp elseoneOperand_p

muldivmem_p:
    len rsi 
    copy rsi,rax,binmem
    call getmemory
    len memory
    copy memory,rax,operand1
    jmp elseoneOperand_p
mulregreg_p:
    mov r9,regcode
    copy r,1,r9 
    inc r9 
    copy reg,3,r9 
    getregister regcode,qword [reg_bit]
    len register
    copy register,rax,operand1

    mov r9,regcode
    copy b,1,r9 
    inc r9 
    copy rm,3,r9 
    getregister regcode,qword [reg_bit]
    len register
    copy register,rax,operand2

    jmp elsetwoOperand_p
mulregmem_p:
    mov r9,regcode
    copy r,1,r9 
    inc r9 
    copy reg,3,r9 
    getregister regcode,qword [reg_bit]
    len register
    copy register,rax,operand1

    len rsi 
    copy rsi,rax,binmem
    call getmemory
    len memory
    copy memory,rax,operand2

    jmp elsetwoOperand_p



twoOperand_p:
    cmp qword [op_num],0
    je reg_p 
    cmp qword [op_num],1
    je regmem_p
    cmp qword [op_num],4
    je data_p
    cmp qword [op_num],5
    je regdataalt_p
    compare instruction,i_test
    cmp rax,1
    je test_p
data_p:
    compare mod,mod4
    cmp rax,1
    je regdata_p
    jmp memdata_p
test_p:
    cmp qword [op_num],3
    je regdataalt_p
    cmp qword [op_num],2
    je testmod_p
testmod_p:
    compare mod,mod4
    cmp rax,1
    je regdata_p 
    jmp memdata_p

regdata_p:

    compare instruction,i_add
    cmp rax,1
    je addreg_p
    jmp notaddreg_p
addreg_p:
    search reg,3,addFamilyValues,instruction
notaddreg_p:
    mov r9,regcode
    copy b,1,r9
    inc r9 
    copy rm,3,r9
    getregister regcode,qword [reg_bit]
    len register
    copy register,rax,operand1

    add rsi,8
    print rsi
    len rsi
    copy rsi,rax,data
    dispdata data
    print hex
    len hex
    copy hex,rax,operand2
    jmp elsetwoOperand_p


regdataalt_p:
    compare instruction,i_mov
    cmp rax,1
    je movdataalt_p
    jmp adddataalt_p
movdataalt_p:
    mov r9,regcode
    copy b,1,r9
    inc r9
    copy regi,3,r9
    getregister regcode,qword [reg_bit]
    jmp dataalt_p
adddataalt_p:
    mov r9,regcode
    mov byte [r9],'0'
    mov byte [r9+1],'0'
    mov byte [r9+2],'0'
    mov byte [r9+3],'0'
    getregister regcode,qword [reg_bit]
    jmp dataalt_p

dataalt_p:
    len register 
    copy register,rax,operand1
    len rsi
    copy rsi,rax,data
    dispdata data
    len hex
    copy hex,rax,operand2
    jmp elsetwoOperand_p


memdata_p:
    compare instruction,i_add
    cmp rax,1
    je addmem_p
    jmp notaddmem_p
addmem_p:
    search reg,3,addFamilyValues,instruction

    cmp byte [s],'1'
    je s1div_p
    jmp s0div_p
s1div_p:
    mov r15,8
    jmp elsediv2_p
s0div_p:
    jmp notaddmem_p
notaddmem_p:
    cmp qword [reg_bit],64
    je div2_p
    mov r15,[reg_bit]
    jmp elsediv2_p
div2_p:
    mov rax,qword [reg_bit]
    mov rbx,2
    mov rdx,0
    div rbx
    mov r15,rax
elsediv2_p:
    len rsi
    sub rax,r15
    copy rsi,rax,binmem
    add rsi,rax
    call getmemory
    len memory
    copy memory,rax,operand1

    len rsi
    copy rsi,rax,data
    dispdata data
    len hex
    copy hex,rax,operand2
    jmp elsetwoOperand_p





reg_p:
    compare mod,mod4
    cmp rax,1
    je regreg_p
    jmp memreg_p
regreg_p:
    member instruction,bs
    cmp rax,1
    je bsregreg_p
    jmp elseregreg_p
bsregreg_p:
    mov r9,regcode 
    copy r,1,r9
    inc r9
    copy reg,3,r9
    getregister regcode,qword [reg_bit]
    len register
    copy register,rax,operand1

    mov r9,regcode
    copy b,1,r9
    inc r9
    copy rm,3,r9
    getregister regcode,qword [reg_bit]
    len register
    copy register,rax,operand2
    jmp elsetwoOperand_p

elseregreg_p:
    mov r9,regcode 
    copy r,1,r9
    inc r9
    copy reg,3,r9
    getregister regcode,qword [reg_bit]
    len register
    copy register,rax,operand2

    mov r9,regcode
    copy b,1,r9
    inc r9
    copy rm,3,r9
    getregister regcode,qword [reg_bit]
    len register
    copy register,rax,operand1
    jmp elsetwoOperand_p

memreg_p:
    member instruction,bs
    cmp rax,1
    je bsregmem_p
    jmp elsememreg_p
bsregmem_p:
    mov r9,regcode
    copy r,1,r9
    inc r9 
    copy reg,3,r9 
    getregister regcode,qword [reg_bit]
    len register
    copy register,rax,operand1

    len rsi
    copy rsi,rax,binmem
    call getmemory
    len memory
    copy memory,rax,operand2
    jmp elsetwoOperand_p
elsememreg_p:
    mov r9,regcode
    copy r,1,r9
    inc r9 
    copy reg,3,r9 
    getregister regcode,qword [reg_bit]
    len register
    copy register,rax,operand2

    len rsi
    copy rsi,rax,binmem
    call getmemory
    len memory
    copy memory,rax,operand1
    jmp elsetwoOperand_p


regmem_p:
    mov r9,regcode
    copy r,1,r9 
    inc r9 
    copy reg,3,r9
    getregister regcode,qword [reg_bit]
    len register
    copy register,rax,operand1
    
    len rsi
    copy rsi,rax,binmem
    call getmemory
    len memory
    copy memory,rax,operand2
    jmp elsetwoOperand_p

elsetwoOperand_p:
    mov r9,command
    len instruction
    copy instruction,rax,r9
    add r9,rax 
    mov byte [r9],' '
    inc r9
    len operand1
    copy operand1,rax,r9
    add r9,rax
    mov byte [r9],','
    inc r9
    len operand2
    copy operand2,rax,r9
    
    jmp end_p



ret_p:
    mov r9,command
    len instruction
    copy instruction,rax,r9
    add r9,rax
    mov byte [r9],' '
    inc r9
    
    len rsi
    copy rsi,rax,disp
    dispdata disp
    len hex
    copy hex,rax,r9
    jmp end_p

opcodeEnd_p:
    member instruction,pp       ;push or pop with register operand
    cmp rax,1
    je ppregister_p
    compare instruction,i_xchg
    cmp rax,1
    je xchgregister_p
    jmp zeroOperands_p
xchgregister_p:
    mov rbx,regcode
    copy b,1,rbx
    inc rbx
    copy reg,3,rbx
    getregister regcode,qword [reg_bit]
    len register
    copy register,rax,operand1

    mov rbx,regcode
    mov byte [rbx],'0'
    mov byte [rbx+1],'0'
    mov byte [rbx+2],'0'
    mov byte [rbx+3],'0'
    getregister regcode,qword [reg_bit]
    len register
    copy register,rax,operand2
    jmp elsetwoOperand_p
ppregister_p:
    cmp qword [reg_bit],32
    je pp64_p
    jmp nopp64_p
pp64_p:
    mov qword [reg_bit],64
nopp64_p:

    mov rbx,regcode
    copy b,1,rbx
    inc rbx
    copy reg,3,rbx
    getregister regcode,qword [reg_bit]
    mov r9,command
    len instruction
    copy instruction,rax,r9

    add r9,rax
    mov byte [r9],' '
    inc r9
    len register
    copy register,rax,r9
    jmp end_p
    


zeroOperands_p:
    len instruction
    copy instruction,rax,command
    jmp end_p

oneOperand_p:
    compare instruction,i_push
    cmp rax,1
    je datapush_p
    jmp elsedatapush_p
datapush_p:
    mov r9,command
    len instruction
    copy instruction,rax,r9
    add r9,rax
    mov byte [r9],' '
    inc r9

    len rsi
    copy rsi,rax,disp
    dispdata disp
    len hex
    copy hex,rax,r9
    jmp end_p

elsedatapush_p:
    member instruction,testFamily   ;neg or not
    cmp rax,1
    je nn_p
    jmp nnelse_p
nn_p:
    search reg,3,testFamilyValues,instruction
nnelse_p:

    compare mod,mod4
    cmp rax,1
    je regoneOperand_p
    jmp memoneOperand_p



regoneOperand_p:
    member instruction,incFamily
    cmp rax,1
    je increg_p
    jmp incnoreg_p
increg_p:
    search reg,3,incFamilyValues,instruction
incnoreg_p:

    mov r9,regcode
    copy b,1,r9
    add r9,1
    copy rm,3,r9
    getregister regcode,qword [reg_bit]
    len register
    copy register,rax,operand1
    jmp elseoneOperand_p
memoneOperand_p:
    member instruction,pushFamily
    cmp rax,1
    je pushreg_p
    jmp pushnoreg_p
pushreg_p:
    search reg,3,pushFamilyValues,instruction
pushnoreg_p:

    member instruction,pp       ;push or pop
    cmp rax,1
    je pp64mem_p
    jmp ppelse_p
pp64mem_p:
    cmp qword [reg_bit],32
    je ppset64_p
    jmp ppelse_p
ppset64_p:
    mov qword [reg_bit],64
ppelse_p:
    len rsi
    copy rsi,rax,binmem
    call getmemory

    len memory
    copy memory,rax,operand1
    jmp elseoneOperand_p

elseoneOperand_p:
    mov r9,command
    len instruction
    copy instruction,rax,r9
    add r9,rax
    mov byte [r9],' '
    add r9,1
    len operand1
    copy operand1,rax,r9
    jmp end_p


end_p:
    print command
    len command
    inc rax
    mov rdi,[fdout]
    mov rsi,command
    mov rdx,rax
    mov rax,1
    syscall

    ret

;this function finds instruction of opcode and stores it in instruction
findOpcode:
    mov r9,4
search_fo:
    copy rsi,r9,opcode
    search opcode,r9,opcodes,instruction
    cmp rax,-1
    jne found_fo
    inc r9
    jmp search_fo
found_fo:
    mov [op_num],rax
    add rsi,r9

    cmp r9,4
    je regw_fo
    cmp r9,5
    je reg_fo
    cmp r9,6
    je sw_fo
    cmp r9,7
    je w_fo
    cmp r9,8
    je end_fo
    cmp r9,15
    je w2_fo
    cmp r9,16
    je end_fo

regw_fo:
    copy rsi,1,w 
    add rsi,1
    copy rsi,3,regi
    add rsi,3

    cmp byte [w],'0'
    je reg8_fo
    jmp end_fo


reg_fo:
    copy rsi,3,reg 
    add rsi,3
    jmp end_fo

sw_fo:
    copy rsi,1,s 
    add rsi,1 
    copy rsi,1,w 
    add rsi,1 
    cmp byte [w],'0'
    je reg8_fo 
    jmp end_fo

w_fo:
    copy rsi,1,w 
    add rsi,1 
    cmp byte [w],'0'
    je reg8_fo 
    jmp end_fo

w2_fo:
    copy rsi,1,w
    add rsi,1
    cmp byte [w],'0'
    je reg8_fo
    jmp end_fo


reg8_fo:
    mov qword [reg_bit],8
    jmp end_fo

end_fo:
    ret





;this function get binmem as input and outputs memory operand in memory variable
getmemory:
    push rax
    push rbx
    push rsi
    push rdi

    mov rsi,binmem
    mov rdi,memory

    operationSize

    len opsize
    copy opsize,rax,rdi
    add rdi,rax
    copy space,1,rdi
    add rdi,1
    copy mem_ptr,3,rdi
    add rdi,3
    copy space,1,rdi
    add rdi,1
    mov byte [rdi],'['
    add rdi,1


    copy rsi,2,mod
    add rsi,2
    copy rsi,3,reg
    add rsi,3
    copy rsi,3,rm
    add rsi,3

    compare rm,rm1      ;if rm=100 then we have sib
    cmp rax,1
    je sib_gm
    jmp nosib_gm



nosib_gm:
    mov rbx,regcode
    copy b,1,rbx
    add rbx,1
    copy rm,3,rbx
    getregister regcode,qword [mem_bit]
    len register
    copy register,rax,rdi
    add rdi,rax
    compare mod,mod1
    cmp rax,1
    je base_gm
    jmp basedisp_gm

base_gm:
    jmp end_gm
basedisp_gm:
    len rsi
    copy rsi,rax,disp
    dispdata disp
    mov byte [rdi],'+'
    inc rdi
    len hex
    copy hex,rax,rdi
    add rdi,rax
    jmp end_gm

    

sib_gm:
    copy rsi,2,scale
    add rsi,2
    copy rsi,3,index
    add rsi,3
    copy rsi,3,base
    add rsi,3
    compare mod,mod1
    cmp rax,1
    je nodisp_gm
    jmp yesdisp_gm

nodisp_gm:
    compare scale,scale1
    cmp rax,1
    je nodispnoscale_gm
    jmp nodispyesscale_gm

nodispnoscale_gm:
    len rsi
    cmp rax,0
    je baseindex_gm
    jmp directindex_gm

baseindex_gm:
    mov rbx,regcode
    copy b,1,rbx
    add rbx,1
    copy base,3,rbx
    getregister regcode,qword [mem_bit]

    len register
    copy register,rax,rdi
    add rdi,rax

    mov byte [rdi],'+'
    inc rdi

    mov rbx,regcode
    copy x,1,rbx
    add rbx,1
    copy index,3,rbx
    getregister regcode,qword [mem_bit]

    len register
    copy register,rax,rdi
    add rdi,rax

    mov byte [rdi],'*'
    mov byte [rdi+1],'1'
    add rdi,2

    jmp end_gm



    

directindex_gm:
    compare index,index1
    cmp rax,1
    je direct_gm
    jmp indexscale1_gm

direct_gm:
    len rsi
    copy rsi,rax,disp
    dispdata disp
    len hex
    copy hex,rax,rdi
    add rdi,rax
    jmp end_gm


indexscale1_gm:
    mov rbx,regcode
    copy x,1,rbx
    inc rbx
    copy index,3,rbx
    getregister regcode,qword [mem_bit]

    len register
    copy register,rax,rdi
    add rdi,rax 
    mov byte [rdi],'*'
    mov byte [rdi+1],'1'
    mov byte [rdi+2],'+'
    add rdi,3

    len rsi
    copy rsi,rax,disp
    dispdata disp
    len hex
    copy hex,rax,rdi
    add rdi,rax
    jmp end_gm





nodispyesscale_gm:
    compare base,base1
    cmp rax,1
    je indexscaledisp_gm
    jmp baseindexscale_gm

indexscaledisp_gm:
    mov rbx,regcode
    copy x,1,rbx
    inc rbx
    copy index,3,rbx
    getregister regcode,qword [mem_bit]
    len register
    copy register,rax,rdi
    add rdi,rax
    mov byte [rdi],'*'
    inc rdi
    search scale,2,scales,sc
    copy sc,1,rdi
    inc rdi
    mov byte [rdi],'+'
    inc rdi

    len rsi
    copy rsi,rax,disp
    dispdata disp
    len hex
    copy hex,rax,rdi
    add rdi,rax


    jmp end_gm

baseindexscale_gm:
    mov rbx,regcode
    copy b,1,rbx
    inc rbx
    copy base,3,rbx
    getregister regcode,qword [mem_bit]
    len register
    copy register,rax,rdi
    add rdi,rax
    mov byte [rdi],'+'
    inc rdi

    mov rbx,regcode
    copy x,1,rbx
    inc rbx
    copy index,3,rbx
    getregister regcode,qword [mem_bit]
    len register
    copy register,rax,rdi
    add rdi,rax
    mov byte [rdi],'*'
    inc rdi

    search scale,2,scales,sc
    copy sc,1,rdi
    inc rdi
    jmp end_gm


yesdisp_gm:

    jmp baseindexscaledisp_gm

baseindexscaledisp_gm:
    mov rbx,regcode
    copy b,1,rbx
    inc rbx
    copy base,3,rbx
    getregister regcode,qword [mem_bit]
    len register
    copy register,rax,rdi
    add rdi,rax
    mov byte [rdi],'+'
    inc rdi

    mov rbx,regcode
    copy x,1,rbx
    inc rbx
    copy index,3,rbx
    getregister regcode,qword [mem_bit]
    len register
    copy register,rax,rdi
    add rdi,rax
    mov byte [rdi],'*'
    inc rdi

    search scale,2,scales,sc
    copy sc,1,rdi
    inc rdi
    mov byte [rdi],'+'
    inc rdi

    len rsi
    copy rsi,rax,disp
    dispdata disp
    len hex
    copy hex,rax,rdi
    add rdi,rax

    
    jmp end_gm





end_gm:
    mov byte [rdi],']'
    mov byte [rdi+1],0xA



    pop rdi
    pop rsi 
    pop rbx 
    pop rax


    ret
    