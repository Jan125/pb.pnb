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
UnitTest("Matrix without parameters",
         "(Matrix)",
         "")

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

