; 8. Se dau cuvintele A si B. Sa se obtina cuvântul C:
;    - bitii 0-5 ai lui C coincid cu bitii 0-5 ai lui B
;    - bitii 6-12 ai lui C coincid cu bitii 3-9 ai lui A
;    - bitii 13-15 ai lui C coincid cu bitii 0-2 ai lui A

; cuvantul C : a2a1a0a9.a8a7a6a5.a4a3b5b4.b3b2b1b0

ASSUME ds:data_, cs:code_

data_ SEGMENT
        a dw 0a5c3h
        b dw 0ce39h
        c dw 0
        count db 0
data_ ENDS

code_ SEGMENT
start:
        mov ax, data_
        mov ds, ax
        
        mov ax, a   ; ax = 0000.00a9a8.a7a6a5a4.a3a2a1a0
        mov cx, 0   ; cx = 0000.0000.0000.0000
        shr ax, 1   ; ax = 0000.000a9.a8a7a6a5.a4a3a2a1 si CF = a0
        rcr cl, 1   ; cl = a0000.0000
        shr ax, 1   ; ax = 0000.0000.a9a8a7a6.a5a4a3a2 si CF = a1
        rcr cl, 1   ; cl = a1a000.0000
        shr ax, 1   ; ax = 0000.0000.0a9a8a7.a6a5a4a3 si CF = a2
        rcr cl, 1   ; cl = a2a1a00.0000
        shr cl, 5   ; cl = 0000.0a2a1a0
        
        mov dx, b   ; dx = 0000.0000.00b5b4.b3b2b1b0
        mov bx, 0   ; bx = 0000.0000.0000.0000
        
        loop1:
                cmp count, 6
                jne continua1
                je stop1
                
                        continua1:
                                shr dx, 1
                                rcr bx, 1
                                add count, 1
                                jmp loop1
                        stop1:
                                mov count, 0
                                
        ; bx = b5b4b3b2.b1b000.0000.0000
        
        loop2: 
                cmp count, 7
                jne continua2
                je stop2
                
                        continua2:
                                shr ax, 1
                                rcr bx, 1
                                add count, 1
                                jmp loop2
                                
                        stop2:
                                mov count, 0
                                
        
        ; bx = a9a8a7a6.a5a4a3b5.b4b3b2b1.b0000
        
        loop3:
                cmp count, 3
                jne continua3
                je stop3
                
                        continua3:
                                shr cl, 1
                                rcr bx, 1
                                add count, 1
                                jmp loop3
                        stop3:
                                mov count, 0
        
        ; bx = a2a1a0a9.a8a7a6a5.a4a3b5b4.b3b2b1b0
        
        mov c, bx       ; c = a2a1a0a9.a8a7a6a5.a4a3b5b4.b3b2b1b0
        
        mov ax, 4C00h
        int 21
        
code_ ENDS
end start