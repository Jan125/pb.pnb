XIncludeFile "pnb.pbi"
DisableExplicit



OpenConsole()

Procedure UnitTest(Name.s, Query.s, Expected.s)
  Protected Response.s
  Response = PNB::nListEvalString(Query)
  If Response <> Expected
    Debug "Unit Test Failed: "+Name
    If Expected <> ""
      Debug "Should be: "+Expected
    Else
      Debug "Should be: (None)"
    EndIf
    Debug "Is: "+Response
    CallDebugger
  EndIf
  ProcedureReturn
EndProcedure


;-General test cases
UnitTest("Parameter Return",
         "(First Second Third Fourth Fifth)",
         "First Second Third Fourth Fifth")

UnitTest("Parameter return with nested lists",
         "(First (Second Third) (Fourth (Fifth)))",
         "First Second Third Fourth Fifth")

UnitTest("Parameter return with unicode string",
         "([Σιγμα!])",
         "[Σιγμα!]")

UnitTest("Nothing return",
         "()",
         "")


;-Matrix test cases
UnitTest("Matrix one dimension test",
         "(Matrix (A) (1))",
         "A 1")

UnitTest("Matrix two dimension test",
         "(Matrix (A B) (1 2))",
         "A 1 B 2")

UnitTest("Matrix three dimension test",
         "(Matrix (A B C) (1 2 3))",
         "A 1 B 2 C 3")

UnitTest("Matrix four dimension test",
         "(Matrix (A B C D) (1 2 3 4))",
         "A 1 B 2 C 3 D 4")

UnitTest("Matrix five dimension test",
         "(Matrix (A B C D E) (1 2 3 4 5))",
         "A 1 B 2 C 3 D 4 E 5")

UnitTest("Matrix one field test",
         "(Matrix (A B))",
         "A B")

UnitTest("Matrix two field test",
         "(Matrix (A B) (1 2))",
         "A 1 B 2")

UnitTest("Matrix three field test",
         "(Matrix (A B) (1 2) (X Y))",
         "A 1 X B 2 Y")

UnitTest("Matrix four field test",
         "(Matrix (A B) (1 2) (X Y) (8 9))",
         "A 1 X 8 B 2 Y 9")

UnitTest("Matrix same-length list test",
         "(Matrix (A B) (1 2))",
         "A 1 B 2")

UnitTest("Matrix differing-length list test",
         "(Matrix (A) (1 2))",
         "A 1 2")

UnitTest("Matrix atom test",
         "(Matrix A (1 2))",
         "A 1 A 2")

UnitTest("Matrix calculation test",
         "(Matrix Do + 3 (1 2))",
         "4 5")

UnitTest("Matrix preemptive evaluation test",
         "(Matrix Do (+ 3 4) (+ 1 6)",
         "7 3 4")


;--Flow control
;-If test cases
UnitTest("If true test",
         "(If (1) Do ([If is 1.]))",
         "[If is 1.]")

UnitTest("If false test",
         "(If (0) Do ([This should not show.]))",
         "")

UnitTest("If empty = false test",
         "(If () Do ([This should not show.]))",
         "")

UnitTest("If evaluation = true test",
         "(If (+ 1 1) Do ([This should show.]))",
         "[This should show.]")

UnitTest("If evaluation = false test",
         "(If (- 1 1) Do ([This should not show.]))",
         "")

UnitTest("If negative = true test",
         "(If (-5) Do ([This should show.]))",
         "[This should show.]")

UnitTest("If true else test",
         "(If (1) Do ([This should show.]) Else Do ([This should not show.]))",
         "[This should show.]")

UnitTest("If false else test",
         "(If (0) Do ([This should not show.]) Else Do ([This should show.]))",
         "[This should show.]")

UnitTest("If true elseif false test",
         "(If (1) Do ([This should show.]) ElseIf (0) Do ([This is false.]))",
         "[This should show.]")

UnitTest("If true elseif true test",
         "(If (1) Do ([This should show.]) ElseIf (1) Do ([This is overridden.]))",
         "[This should show.]")

UnitTest("If false elseif true test",
         "(If (0) Do ([This should not show.]) ElseIf (1) Do ([This is now true.]))",
         "[This is now true.]")

UnitTest("If false elseif false test",
         "(If (0) Do ([This should not show.]) ElseIf (0) Do ([This is NOT true.]))",
         "")

UnitTest("If false elseif false else test",
         "(If (0) Do ([This should not show.]) ElseIf (0) Do ([This is NOT true.]) Else Do ([This is the last option.]))",
         "[This is the last option.]")

UnitTest("If false dual else test",
         "(If (0) Do ([This should not show.]) Else Do ([Valid.]) Else ([Illegal.]))",
         "[Valid.]")


;--List manipulation
;-Element test cases
UnitTest("Element selection",
         "(Element 3 First Second Third Fourth Fifth)",
         "Third")

UnitTest("Element selection underflow",
         "(Element -2 First Second Third Fourth Fifth)",
         "")

UnitTest("Element selection overflow",
         "(Element 7 First Second Third Fourth Fifth)",
         "")

UnitTest("Element selection all return",
         "(Element All First Second Third Fourth Fifth)",
         "First Second Third Fourth Fifth")

UnitTest("Element selection no parameters",
         "(Element)",
         "")

UnitTest("Element selection no list all return",
         "(Element All)",
         "")

UnitTest("Element selection no list index 0 return",
         "(Element 0)",
         "")


;-Discard test cases
UnitTest("Discard with parameters",
         "(Discard First Second Third Fourth Fifth)",
         "")

UnitTest("Discard without parameter",
         "(Discard)",
         "")


;-Invert test cases
UnitTest("Invert with parameters",
         "(Invert First Second Third Fourth Fifth)",
         "Fifth Fourth Third Second First")

UnitTest("Invert without parameters",
         "(Invert)",
         "")


;-Size test cases
UnitTest("Size with parameters",
         "(Size First Second Third Fourth Fifth)",
         "5")

UnitTest("Size without parameters",
         "(Size)",
         "0")


;--Type Maniputation
;-Offset test cases
CompilerSelect #PB_Compiler_Processor
  CompilerCase #PB_Processor_x64
    UnitTest("Offset with integer (64 bit)",
             "(Offset 2 3)",
             "16")
  CompilerDefault
    UnitTest("Offset with integer (32 bit)",
             "(Offset 2 3)",
             "8")
CompilerEndSelect

UnitTest("Offset with word and byte",
         "(Offset (Byte 2) (Word 3 4))",
         "5")

CompilerSelect #PB_Compiler_Unicode
  CompilerCase 1
    UnitTest("Offset with string - Unicode",
             "(Offset [This is a test.])",
             "30")
  CompilerDefault
    UnitTest("Offset with string - ASCII",
             "(Offset [This is a test.])",
             "15")
CompilerEndSelect

UnitTest("Offset without parameters",
         "(Offset)",
         "0")


;-Split test cases
UnitTest("Split with string",
         "(Split [This should be split.])",
         "84 104 105 115 32 115 104 111 117 108 100 32 98 101 32 115 112 108 105 116 46")

UnitTest("Split with multiple strings",
         "(Split [1] [2])",
         "49 50")

UnitTest("Split with non-supported type",
         "(Split 55.5)",
         "")

UnitTest("Split without parameters",
         "(Split)",
         "")


;-Fuse test cases
UnitTest("Fuse with parameters",
         "(Fuse 84 104 105 115 32 115 104 111 117 108 100 32 98 101 32 102 117 115 101 100 46)",
         "[This should be fused.]")

UnitTest("Fuse with semi-supported type (float)",
         "(Fuse 55.5)",
         "[8]")

UnitTest("Fuse with non-supported type (string)",
         "(Fuse [Test.])",
         "[Test.]")

UnitTest("Fuse without parameters",
         "(Fuse)",
         "[]")


; 
; ;-Stress test
; Debug "#Test how many times this query can be called per second:"
; DisableDebugger
; a = 0
; StartTime_Stress = ElapsedMilliseconds()
; Repeat
;   a+1
;   PNB::nListEvalString("(+ (+ 'This is the ' 'stress ') (+ 'test of this' ' program.'))")
;   EndTime_Stress = ElapsedMilliseconds()
; Until EndTime_Stress-StartTime_Stress > 1000
; EnableDebugger
; PNB::nListEvalString("Debug (+ [Your PC has called the single thread stress test ] ["+Str(a-1)+" ] [times in one second!])")
; 
; 
; Debug "#Test if everything is dissolved in order: Should read 'This is the stress test of this program.'"
; PNB::nListEvalString("Debug (+ (+ 'This is the ' 'stress ') (+ 'test of this' ' program.'))")
; 
; Debug "#Integer test, multiple parameters: Should read '15', '-2', '-1'."
; PNB::nListEvalString("Debug (+ 1 2 3 4 5)")
; PNB::nListEvalString("Debug (+ 1 -3)")
; PNB::nListEvalString("Debug (- 3 4)")
; 
; Debug "#Float test: Should read '3.95' or an approximation."
; PNB::nListEvalString("Debug (+ 3.55 0.4)")
; 
; Debug "#Self-call test: Should read '9'."
; PNB::nListEvalString("Eval [Debug (+ 3 3 3)]")
; 
; Debug "#Storage test: Should read '50', 'this', 'test', 'of', 'multiline!'."
; PNB::nListEvalString("Set Variable 50")
; PNB::nListEvalString("Debug (Get Variable)")
; PNB::nListEvalString("Set Variable [this]")
; PNB::nListEvalString("Debug (Get Variable)")
; PNB::nListEvalString("Set Variable [test] [of] [multiline!]")
; PNB::nListEvalString("Debug (Get Variable)")
; 
; Debug "#Select-condition branching test: Should read 'Select is 2.', 'Select is 1.', 'Select is none.'"
; PNB::nListEvalString("Select (2) Case (1) Do (Debug 'Select is NOT 1.') Case (2) Do (Debug 'Select is 2.') Default Do (Debug 'Select is NOT none.')")
; PNB::nListEvalString("Select (1) Case (1) Do (Debug 'Select is 1.') Case (2) Do (Debug 'Select is NOT 2.')")
; PNB::nListEvalString("Select (5) Case (1) Do (Debug 'Select is NOT 1.') Case (2) Do (Debug 'Select is NOT 2.') Default Do (Debug 'Select is none.')")
; 
; Debug "#For-loop test: Should read '7'."
; PNB::nListEvalString("For (7) Do (Set ForVar (+ (Get ForVar) 1))")
; PNB::nListEvalString("Debug (Get ForVar)")
; 
; Debug "#While-Test: Should read 3 'NooooOo!'."
; PNB::nListEvalString("Set WhileTest 3")
; PNB::nListEvalString("While (Get WhileTest) Do ((Debug [NooooOo!]) (Set WhileTest (- (Get WhileTest) 1)) )")
; 
; Debug "#Until-Test: Should read 4 'Yes!'."
; PNB::nListEvalString("Set UntilTest 0")
; PNB::nListEvalString("Until (= (Get UntilTest) 4) Do ((Debug [Yes!]) (Set UntilTest (+ (Get UntilTest) 1)) )")
; 
; Debug "#Macro/As test: Should read 3 'Incrementing...', 'Reached it!'"
; PNB::nListEvalString("Function (Testmacro) Do ((Debug [Incrementing...]) (Set Macro (+ (Get Macro) 1)) (If (= (Get Macro) 3) Do (Debug [Reached it!]) Else Do (Testmacro)) )")
; PNB::nListEvalString("Testmacro")
; 
; Debug "#Macro/As multiple parameters test: Should read 'FirstString', 'SecondString'."
; PNB::nListEvalString("Function (Testmacro) Do ([FirstString] ([SecondString]))")
; PNB::nListEvalString("Debug (Testmacro)")
; 
; Debug "#Macro/As function test: Should read 'Reverse Order'."
; PNB::nListEvalString("Function (Testmacro) Do (Debug (+ ee [ ] dd)) With (dd ee)")
; PNB::nListEvalString("Testmacro Order Reverse")
; 
; Debug "#Macro/As function parameter test: Should read 'Order is Reversed'."
; PNB::nListEvalString("Function (Testmacro) Do (+ ff [ ] ee [ ] dd) With (dd ee ff)")
; PNB::nListEvalString("Debug (Testmacro Reversed is Order)")
; 
; Debug "#Macro/As function default parameter test: Should read 'Defined', 'Undefined'."
; PNB::nListEvalString("Function (Testmacro) Do (dd ee) With (dd ee) As (Undefined Undefined)")
; PNB::nListEvalString("Debug (Testmacro Defined)")
; 
; Debug "#Macro/As function parameter underload test: Should not be registered and return as list. Should read 'Testmacro', 'This'."
; PNB::nListEvalString("Function (Testmacro) Do (+ dd ee) With (dd ee) As (Undefined)")
; PNB::nListEvalString("Debug (Testmacro This)")
; 
; Debug "#Memory test. Should read 'This is a string.', '33.3' or an approximation, '240'."
; PNB::nListEvalString("Set A (Allocate 100)")
; PNB::nListEvalString("Poke (Get A) [This is a string.] (UByte 0)")
; PNB::nListEvalString("Debug (Peek (Get A) String)")
; PNB::nListEvalString("Poke (Get A) 33.3")
; PNB::nListEvalString("Debug (Peek (Get A) Float)")
; PNB::nListEvalString("Poke (Get A) 240")
; PNB::nListEvalString("Debug (Peek (Get A) Integer)")
; PNB::nListEvalString("Free All")
; 
; PNB::nListEvalString("(Invoke Void (Examine (Load user32.dll) MessageBoxW) 0 'This is the message.' 'This is the title.' 0)")
; 
; 
; End
