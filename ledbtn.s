/*******************************************************************************
File name       : IO.s
Description     : A push button scanner than turns on the LED
Author          : Ahmad Sebak    
Created         : 
Revision History

*******************************************************************************/

  MODULE        WK_6    /* The module name */
  PUBLIC ioscan         /* Make function name visible to linker               */


  SECTION `.rodata`:CONST:REORDER:NOROOT(2)
  DATA

PORTA           equ     0x40020000      ;; Starting address for GPIOA
PORTC           equ     0x40020800      ;; Starting address for GPIOC

IDR             equ     0x10            ;; Address Offset for IDR
BSRR            equ     0x18            ;; Address Offset for BSRR

PORTA_BSRR      equ     PORTA + BSRR    ;; This is the address for BSRR on PORTA
PORTC_IDR       equ     PORTC + IDR     ;; This is the address for Input register, on PORTC

INPUT_MASK      equ     0x00002000      ;; 1 << 13 (pin 13 for Push Button)
LED_ON_MASK     equ     0x00000020      ;; 1 << 5  (pin 5 for setting LED)
LED_OFF_MASK    equ     0x00200000      ;; 1 << 21 (pin 5 for resetting LED)


  /* Tells the linker the section name : memory type : fragment (align)       */
  SECTION `.text`:CODE:NOROOT(2) 
  THUMB                 /* Mode control directive                             */
  
/*******************************************************************************
Function Name   : ioscan
Description     : Scans the user button, and lights the LED if pressed.
C Prototype     : void ioscan(void)
                :
Parameters      :
Return value    : None
Registers Used  :
              R0: Scratch
              R1: Scratch
              R2: PORTA_BSRR
              R3: PORTC_IDR                        
*******************************************************************************/

ioscan:
  LDR R1,=PORTC_IDR       ;; Load PORTC_IDR into R1
  LDR R2,=PORTA_BSRR      ;; Load PORTA_BSRR into R2

  LDR R0,[R1]             ;; Load contents of PORTC_IDR into R0
  LDR R1,=INPUT_MASK      ;; Load INPUT_MASK into R1
  CMP R0,R1               ;; Compare R0 AND R1
  BLT LED_ON              ;; Branch if LED should be on.
  
  LDR R0,=LED_OFF_MASK    ;; Load LED_OFF_MASK to R0
  LDR R3,=PORTA_BSRR
  STR R0,[R3]             ;; Store mask (R0) to PORTA_BSRR address loaded into R3
  B io_exit               ;; Exit routine
  
LED_ON:
  LDR R0,=LED_ON_MASK     ;; Load LED_ON_MASK to R0
  LDR R3,=PORTA_BSRR
  STR R0,[R3]             ;; Store mask (R0) to PORTA_BSRR address loaded into R3
io_exit:
  MOV pc,lr               ;; Exit routine
  END  
                 
