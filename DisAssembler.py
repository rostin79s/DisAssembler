
hexa={'0':'0000' , '1':'0001' , '2':'0010' , '3':'0011' , '4':'0100' , '5':'0101' , '6':'0110' , '7':'0111' , '8':'1000' , '9':'1001' , 'a':'1010' , 'b':'1011' , 'c':'1100' , 'd':'1101' , 'e':'1110' , 'f':'1111'}
test={}
instructions={  
                "syscall":'0000111100000101',
                "stc":'11111001',
                "clc":'11111000',
                "std":'11111101',
                "cld":'11111100',
                "ret":['11000011','11000010'],

                "mov":['1000100','1000101','1000101','1000100','1100011','1011','1100011','1010000'],
                "add":['0000000','0000001','0000001','0000000','100000','0000010','100000'],
                "adc":['0001000','0001001','0001001','0001000','100000','0001010','100000'],
                "sub":['0010100','0010101','0010101','0010100','100000','0010110','100000'],
                "sbb":['0001100','0001101','0001101','0001100','100000','0001110','100000'],
                "and":['0010000','0010001','0010001','0010000','100000','0010010','100000'],
                "or":['0000100','0000101','0000101','0000100','100000','0000110','100000'],
                "xor":['0011000','0011001','0011001','0011000','100000','0011010','100000'],
                "cmp":['0011100','0011101','0011100','0011101','100000','0011110','100000'],

                "test":['1000010','1000010','1111011','1010100','1111011'],
                "xchg":['1000011','10010','1000011'],
                "xadd":['000011111100000','000011111100000'],

                "imul":['1111011','1111011','0000111110101111','0000111110101111'],
                "idiv":['1111011','1111011'],

                "shl":['1101000','1101000','1101001','1101001','1100000','1100000'],
                "shr":['1101000','1101000','1101001','1101001','1100000','1100000'],

                "bsf":['0000111110111100','0000111110111100'],
                "bsr":['0000111110111101','0000111110111101'],

                "jmp":['11101011','11101001','11111111','11111111'],
                "jcc":['0111','000011111000'],
                "jrcxz":['11100011'],
                "call":['11101000','11111111','11111111'],

                "inc":['1111111','1111111'],
                "dec":['1111111','1111111'],
                "neg":['1111011','1111011'],
                "not":['1111011','1111011'],
                "push":['01010','11111111','01101010','01101000'],
                "pop":['01011','10001111']
              }


registers={
            "8":{
                "al":'0000' , "cl":'0001' , "dl":'0010' , "bl":'0011' , "ah":'0100' , "ch":'0101' , "dh":'0110' , "bh": '0111' ,
                "r8b":'1000' , "r9b":'1001' , "r10b":'1010' , "r11b":'1011' , "r12b":'1100' , "r13b":'1101' , "r14b":'1110' ,
                "r15b":'1111'
                },

            "16":{
                "ax":'0000' , "cx":'0001' , "dx":'0010' , "bx":'0011' , "sp":'0100' , "bp":'0101' , "si":'0110' , "di": '0111' ,
                "r8w":'1000' , "r9w":'1001' , "r10w":'1010' , "r11w":'1011' , "r12w":'1100' , "r13w":'1101' , "r14w":'1110' ,
                "r15w":'1111'
                },

            "32":{
                "eax":'0000' , "ecx":'0001' , "edx":'0010' , "ebx":'0011' , "esp":'0100' , "ebp":'0101' , "esi":'0110' , "edi": '0111' ,
                "r8d":'1000' , "r9d":'1001' , "r10d":'1010' , "r11d":'1011' , "r12d":'1100' , "r13d":'1101' , "r14d":'1110' ,
                "r15d":'1111' ,
                },

            "64":{
                "rax":'0000' , "rcx":'0001' , "rdx":'0010' , "rbx":'0011' , "rsp":'0100' , "rbp":'0101' , "rsi":'0110' , "rdi": '0111' ,
                "r8":'1000' , "r9":'1001' , "r10":'1010' , "r11":'1011' , "r12":'1100' , "r13":'1101' , "r14":'1110' ,
                "r15":'1111'
                },
            }


reg_value={'000':'add' , '001':'or' , '010':'adc' , '011':'sbb' , '100':'and' , '101':'sub' , '110':'xor' , '111':'cmp' , 
}

reg_one_value={'000':'inc' , '001':'dec' , '010':'not' , '011':'neg'}

inf={"reg_bit":[] , "mem_bit":-1 , "data":[] , "rex_bits":'0000' , "inst":'' , "code":-1 , "reg":'' , 's':''}

op_size={8:"BYTE" , 16:"WORD" , 32:"DWORD" , 64:"QWORD"}

def main():
    exp=input().lower()
    command=disassemble(exp)
    print(command)

def disassemble(exp):
    result=""
    i=prefix(exp)
    exp=exp[i:]

    i=rex(exp)
    exp=exp[i:]
    
    i=opcode(exp)         #inst is our instruction. code is the state of our instruction. i is the end bit of opocode.
    result=inf["inst"]
    i=rest_opcode(exp,i)
    exp=exp[i:]
    if exp=='':
        return result

    registerbit()


    res=instruction(exp)
    result=inf["inst"]+' '
    result+=res
    return result



def instruction(exp):
    result=""
    modrm=hex_binary(exp[0:2])
    mod=modrm[0:2]
    reg=modrm[2:5]
    rm=modrm[5:8]
    reg_bit=str(inf["reg_bit"])
    rex=inf["rex_bits"]

    if inf["inst"]=="test" and inf["code"]==2 and reg!="000":           #confliction for test and imul(idiv) and not and neg
        if reg=="111":
            inf["inst"]="idiv"
        elif reg=="101":
            inf["inst"]="imul"
        else:                               #not and neg
            inf["inst"]=reg_one_value[reg]
        inf["code"]=0












    
    if inf["inst"]=="mov" or inf["inst"]=="add" or inf["inst"]=="adc" or inf["inst"]=="sub" or inf["inst"]=="sbb"\
        or inf["inst"]=="and" or inf["inst"]=="or" or inf["inst"]=="xor" or inf["inst"]=="cmp" or inf["inst"]=="bsf"\
        or inf["inst"]=="bsr" or inf["inst"]=="test" or inf["inst"]=="xadd" or inf["inst"]=="xchg":
                
        if inf["code"]==0 and mod=="11":      #reg,reg
            r=rex[0]
            b=rex[2]
            reg=r+reg
            rm=b+rm
            for key,value in registers[reg_bit].items():
                if value==rm:
                    temp1=key
                if value==reg:
                    temp2=key
                    
            if inf["inst"]=="bsf" or inf["inst"]=="bsr":
                result+=temp2+','+temp1
            else:
                result+=temp1+','+temp2
        
        elif inf["code"]==1:    #mem to reg
            r=rex[0]
            reg=r+reg
            for key,value in registers[reg_bit].items():
                if value==reg:
                    temp1=key
            result+=temp1+','
            res=memory(exp)
            result+=res


        elif inf["code"]==0 and mod!="11":    #reg to mem
            r=rex[0]
            reg=r+reg
            register=register_search(reg, reg_bit)
            res=memory(exp)
            if inf["inst"]=="bsf" or inf["inst"]=="bsr":
                result+=register+','+res
            else:
                result+=res+','+register


        elif (inf["code"]==4 and mod=="11") or (inf["code"]==2 and inf["inst"]=="test" and mod=="11"):                  #imm to reg
            b=rex[2]

            if inf["inst"]=="add":
                inf["inst"]=reg_value[reg]
            rm=b+rm
            result+=register_search(rm, reg_bit)+','+data(exp[2:])

        elif inf["code"]==5 or (inf["code"]==3 and inf["inst"]=="test"):                                #imm to reg(alternate for mov) or imm to al,ax,eax (add and family)
            if inf["inst"]=="mov":
                b=rex[2]
                reg=inf["reg"]
                reg=b+reg
                result+=register_search(reg, reg_bit)+','+data(exp)

            else:                                           # add and family
                reg="0000"
                result+=register_search(reg, reg_bit)+','+data(exp)


        elif (inf["code"]==4 and mod!="11") or (inf["code"]==2 and inf["inst"]=="test" and mod!="11"):                  #imm to memory 
            reg_bit=int(reg_bit)

            if inf["inst"]=="add":
                inf["inst"]=reg_value[reg]

            if reg_bit==64:
                i=int(reg_bit/8)
            else:
                i=int(reg_bit/4)
            d=exp[-i:]
            exp=exp[0:-i]

            res=memory(exp[0:])
            result+=res+','+data(d)

        return result











    elif inf["inst"]=="dec" or inf["inst"]=="inc" or inf["inst"]=="neg" or inf["inst"]=="not" or inf["inst"]=="push"\
        or inf["inst"]=="pop":

        code=inf["code"]

        if inf["inst"]=="inc":
            if reg!="000":
                inf["inst"]="dec"


        if code==0 and mod=="11":           #reg 
            b=rex[2]
            rm=b+rm
            result+=register_search(rm, reg_bit)
        elif code==0 and mod!="11":         #mem
            res=memory(exp)
            result+=res
        return result


    # elif inf["inst"]=="call" or inf["inst"]=="jmp" or inf["inst"][0]=="jcc":

    elif inf["inst"]=="ret":
        result+=data(exp)
        return result
        
    elif inf["inst"]=="shr" or inf["inst"]=="shl":
        if reg=="100":
            inf["inst"]="shl"
        else:
            inf["inst"]="shr"
        code=inf["code"]

        if code==0 and mod=="11":               #reg,1
            b=rex[2]
            rm=b+rm
            result+=register_search(rm,reg_bit)+','+'1'

        elif code==0 and mod!="11":             #mem,1
            res=memory(exp)
            result+=res+','+'1'
            
        elif code==4 and mod=="11":             #reg,imm
            b=rex[2]
            rm=b+rm
            d=exp[-2:]
            result+=register_search(rm,reg_bit)+','+data(d)
        elif code==4 and mod!="11":             #mem,imm
            d=exp[-2:]
            exp=exp[0:-2]
            res=memory(exp)
            result+=res+','+data(d)
        
        return result


    elif inf["inst"]=="imul" or inf["inst"]=="idiv":
        code=inf["code"]
        if code==0 and mod=="11":       #  one operand register for imul and idiv
            b=rex[2]
            rm=b+rm
            result+=register_search(rm, reg_bit)
        elif code==0 and mod!="11":     # one operand memory for imul and idiv
            result+=memory(exp)

        elif code==2 and mod=="11":     #reg,reg
            r=rex[0]
            b=rex[2]
            reg=r+reg
            rm=b+rm
            for key,value in registers[reg_bit].items():
                if value==rm:
                    temp1=key
                if value==reg:
                    temp2=key
            result+=temp2+','+temp1

        elif code==2 and mod!="11":     #reg,mem
            r=rex[0]
            reg=r+reg
            for key,value in registers[reg_bit].items():
                if value==reg:
                    temp1=key
            result+=temp1+','
            res=memory(exp)
            result+=res
        
        return result



def memory(exp):
    result=''
    size=len(exp)
    modrm=hex_binary(exp[0:2])
    mod=modrm[0:2]
    reg=modrm[2:5]
    rm=modrm[5:8]
    reg_bit=inf["reg_bit"]
    mem_bit=inf["mem_bit"]
    rex=inf["rex_bits"]
    r=rex[0]
    x=rex[1]
    b=rex[2]
    result+=op_size[reg_bit]+' '+'PTR'+' '+'['

    if rm=="100":       # sib
        sib=hex_binary(exp[2:4])
        scale=sib[0:2]
        index=sib[2:5]
        base=sib[5:8]
        if mod=="00":
            if scale=="00":             # direct addressing or base index.
                d=exp[4:]
                l=len(d)
                if l==8:        # direct addressing or index*1
                    if index=="100":
                        res=data(d)
                        result+=res
                        result+=']'
                        return result
                    else:       # index , scale 1
                        index=x+index
                        bit=get_bit()
                        res=data(d)
                        result+=register_search(index, bit)+'*'+'1'+'+'+'0x0'+']'
                        return result
                else:                   # base index
                    index=x+index
                    base=b+base
                    if mem_bit==32:
                        bit=32
                    else:
                        bit=64
                    result+=register_search(base,bit)+'+'+register_search(index,bit)+'*1'+']'
                    return result


            else:                       # base index scaler or index scale (disp)
                index=x+index
                sc=get_scale(scale)
                bit=get_bit()
                if base=="101":         # index scale 32 disp 0 or index scale disp
                    result+=register_search(index, bit)+'*'+sc
                    d=data(exp[4:])
                    if d=='':
                        result+='+'+'0x0'+']'
                    else:
                        result+='+'+d+']'
                    return result
                else:                   # base index scale that base is not ebp or rbp
                    base=b+base
                    result+=register_search(base, bit)+'+'+register_search(index, bit)+'*'+sc+']'
                    return result
        else:                           #ebp (rbp) index scale | base index scale disp | base index disp
            if scale=="00":             #base index disp
                base=b+base
                index=x+index
                bit=get_bit()
                result+=register_search(base, bit)+'+'+register_search(index, bit)+'*1'
                d=data(exp[4:])
                if d=='':
                    result+=']'
                else:
                    result+='+'+d+']'
                return result
            else:                       # base index scale disp | ebp(rbp) index scale
                base=b+base
                index=x+index
                sc=get_scale(scale)
                bit=get_bit()
                result+=register_search(base,bit)+'+'+register_search(index, bit)+'*'+sc
                d=data(exp[4:])
                if d=='':
                    result+=']'
                else:
                    result+='+'+d+']'
                return result
                

    else:               # no sib. only base or base displacement
        rm=b+rm
        if mem_bit==32:
            bit=32
        else:
            bit=64
        base=register_search(rm,bit)
        result+=base

        if mod=="00":   # only base
            result+=']'
            return result
        else:           # base displacement
            d=data(exp[2:])
            if d=='':
                result+='+'+'0x0'+']'
            else:
                result+='+'+d+']'
            return result


def get_bit():
    mem_bit=inf["mem_bit"]
    if mem_bit==32:
        bit=32
    else:
        bit=64
    return bit

def get_scale(scale):
    if scale=="01":
        return '2'
    elif scale=="10":
        return '4'
    elif scale=="11":
        return '8'

def data(d):
    i=0
    res=''
    while i+2<=len(d):
        temp=d[i:i+2]
        if temp=='00':
            break
        else:
            res=temp+res
        i+=2
    if res=='':
        return res
    if res[0]=='0':
        res=res[1:]
    res='0x'+res
    return res


def rest_opcode(exp,i):
    exp=hex_binary(exp)
    if i==4:
        w=exp[4]
        if w=='1':
            inf["reg_bit"].append(-8)
        else:
            inf["reg_bit"].append(8)
        reg=exp[5:8]
        inf["reg"]=reg

    elif i==5:
        reg=exp[5:8]
        inf["reg"]=reg


    elif i==6:
        s=exp[6]
        w=exp[7]
        if w=='1':
            inf["reg_bit"].append(-8)
        else:
            inf["reg_bit"].append(8)
        inf["s"]='1'

    elif i==7:
        w=exp[7]
        if w=='1':
            inf["reg_bit"].append(-8)
        else:
            inf["reg_bit"].append(8)

    elif i==8:
        inf["reg_bit"].append(-1)

    else:
        return 4

    return 2


def register_search(r,bit):
    for key,value in registers[str(bit)].items():
        if value==r:
            return key



def opcode(exp):
    size=len(exp)
    binary=hex_binary(exp)
    for i in range(4,17):
        b=binary[0:i]
        for key, value in instructions.items():
            if isinstance(value,list):
                for j in range(0,len(value)):
                    if value[j]==b:
                        inf["inst"]=key
                        inf["code"]=j
                        return i
            else:
                if value==b:
                    inf["inst"]=key
                    inf["code"]=-1
                    return i



def rex(exp):
    if exp[0]!='4':
        i=0
        inf["reg_bit"].append(-64)
        return i
    i=2
    rex_bits=hex_binary(exp[1])
    if rex_bits[0]=='1':
        reg_bit=64
    else:
        reg_bit=-64
    inf["reg_bit"].append(reg_bit)
    inf["rex_bits"]=rex_bits[1:]
    return i
    

def prefix(exp):
    if exp[0:2]=='67' and exp[2:4]=='66':
        mem_bit=32
        reg_bit=16
        i=4
    elif exp[0:2]=='67':
        mem_bit=32
        reg_bit=-16
        i=2
    elif exp[0:2]=='66':
        reg_bit=16
        mem_bit=-32
        i=2
    else:
        reg_bit=-16
        mem_bit=-32
        i=0
    inf["reg_bit"].append(reg_bit)
    inf["mem_bit"]=mem_bit
    return i


def registerbit():
    for i in inf["reg_bit"]:
        if i>0:
            inf["reg_bit"]=i
            return
    x=[-64,-32,-16,-8]
    for i in x:
        if i not in inf["reg_bit"]:
            inf["reg_bit"]=abs(i)
            return


def hex_binary(h):
    size=len(h)
    result=""
    for i in range(size):
        result+=hexa[h[i]]
    return result

if __name__=="__main__":
    main()