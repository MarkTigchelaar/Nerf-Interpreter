<array:8
<counter:8
NEWARRAY
iMOVE
array
iPUSHc
0
iMOVE
counter
iPUSHc
1
iPUSHv
array
iARRAPPEND
iPUSHc
2
iPUSHv
array
iARRAPPEND
iPUSHc
3
iPUSHv
array
iARRAPPEND
>loop:iPUSHv
counter
iPUSHv
array
iARRGET
iPUTLN
iPUSHc
1
iPUSHv
counter
iADD
iMOVE
counter
iPUSHv
counter
iPUSHc
2
iJUMPNEQ
loop
HALT