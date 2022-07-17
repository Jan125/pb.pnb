XIncludeFile "pnb.pbi"
DisableExplicit

String.s = ""

;-General test cases
String = PNB::nListEvalString("(First Second Third Fourth Fifth)")
If String <> "First Second Third Fourth Fifth"
  Debug "Unit Test Failed: Parameter return"
  Debug "Should be: First Second Third Fourth Fifth"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

String = PNB::nListEvalString("(First (Second Third) (Fourth (Fifth)))")
If String <> "First Second Third Fourth Fifth"
  Debug "Unit Test Failed: Parameter return with nested lists"
  Debug "Should be: First Second Third Fourth Fifth"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

String = PNB::nListEvalString("([Σιγμα!])")
If String <> "[Σιγμα!]"
  Debug "Unit Test Failed: Parameter return with unicode string"
  Debug "Should be: [Σιγμα!]"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

String = PNB::nListEvalString("()")
If String <> ""
  Debug "Unit Test Failed: Nothing return"
  Debug "Should be: (None)"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

;-Element test cases
String = PNB::nListEvalString("(Element 3 First Second Third Fourth Fifth)")
If String <> "Third"
  Debug "Unit Test Failed: Element selection"
  Debug "Should be: Third"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

String = PNB::nListEvalString("(Element -2 First Second Third Fourth Fifth)")
If String <> ""
  Debug "Unit Test Failed: Element selection underflow"
  Debug "Should be: (None)"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

String = PNB::nListEvalString("(Element 7 First Second Third Fourth Fifth)")
If String <> ""
  Debug "Unit Test Failed: Element selection overflow"
  Debug "Should be: (None)"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

String = PNB::nListEvalString("(Element All First Second Third Fourth Fifth)")
If String <> "First Second Third Fourth Fifth"
  Debug "Unit Test Failed: Element selection all returned"
  Debug "Should be: First Second Third Fourth Fifth"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

String = PNB::nListEvalString("(Element)")
If String <> ""
  Debug "Unit Test Failed: Element selection no parameters"
  Debug "Should be: (None)"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

String = PNB::nListEvalString("(Element All)")
If String <> ""
  Debug "Unit Test Failed: Element selection no parameters with all returned"
  Debug "Should be: (None)"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

String = PNB::nListEvalString("(Element 0)")
If String <> ""
  Debug "Unit Test Failed: Element selection no parameters with index 0 returned"
  Debug "Should be: (None)"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

;-Discard test cases
String = PNB::nListEvalString("(Discard First Second Third Fourth Fifth)")
If String <> ""
  Debug "Unit Test Failed: Discard with parameters"
  Debug "Should be: (None)"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

String = PNB::nListEvalString("(Discard)")
If String <> ""
  Debug "Unit Test Failed: Discard without parameters"
  Debug "Should be: (None)"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

;-Invert test cases
String = PNB::nListEvalString("(Invert First Second Third Fourth Fifth)")
If String <> "Fifth Fourth Third Second First"
  Debug "Unit Test Failed: Invert with parameters"
  Debug "Should be: Fifth Fourth Third Second First"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

String = PNB::nListEvalString("(Invert)")
If String <> ""
  Debug "Unit Test Failed: Invert with parameters"
  Debug "Should be: (None)"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

;-Size test cases
String = PNB::nListEvalString("(Size First Second Third Fourth Fifth)")
If String <> "5"
  Debug "Unit Test Failed: Size without parameters"
  Debug "Should be: 0"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

String = PNB::nListEvalString("(Size)")
If String <> "0"
  Debug "Unit Test Failed: Size without parameters"
  Debug "Should be: 0"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

;-Offset test cases
String = PNB::nListEvalString("(Offset 2 3)")
CompilerSelect #PB_Compiler_Processor
  CompilerCase #PB_Processor_x64
    If String <> "16"
      Debug "Unit Test Failed: Offset with word and integer 64 bit"
      Debug "Should be: 16"
      Debug "Is: "+String
      CallDebugger
    EndIf
  CompilerDefault
    If String <> "8"
      Debug "Unit Test Failed: Offset with word and integer 32 bit"
      Debug "Should be: 8"
      Debug "Is: "+String
      CallDebugger
    EndIf
CompilerEndSelect
String = ""

String = PNB::nListEvalString("(Offset [This])")
CompilerSelect #PB_Compiler_Unicode
  CompilerCase 1
    If String <> "8"
      Debug "Unit Test Failed: Offset with string - unicode"
      Debug "Should be: 8"
      Debug "Is: "+String
      CallDebugger
    EndIf
  CompilerDefault
    If String <> "4"
      Debug "Unit Test Failed: Offset with string - ascii"
      Debug "Should be: 4"
      Debug "Is: "+String
      CallDebugger
    EndIf
CompilerEndSelect
String = ""

String = PNB::nListEvalString("(Offset)")
If String <> "0"
  Debug "Unit Test Failed: Offset without parameters"
  Debug "Should be: 0"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

;-Split test cases
String = PNB::nListEvalString("(Split [This should be split.])")
If String <> "84 104 105 115 32 115 104 111 117 108 100 32 98 101 32 115 112 108 105 116 46"
  Debug "Unit Test Failed: Split with string"
  Debug "Should be: 84 104 105 115 32 115 104 111 117 108 100 32 98 101 32 115 112 108 105 116 46"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

String = PNB::nListEvalString("(Split [1] [2])")
If String <> "49 50"
  Debug "Unit Test Failed: Split with multiple strings"
  Debug "Should be: 49 50"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

String = PNB::nListEvalString("(Split 55.5)")
If String <> ""
  Debug "Unit Test Failed: Split with non-supported type"
  Debug "Should be: (None)"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

String = PNB::nListEvalString("(Split)")
If String <> ""
  Debug "Unit Test Failed: Split without parameters"
  Debug "Should be: (None)"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

;-Fuse test cases
String = PNB::nListEvalString("(Fuse 84 104 105 115 32 115 104 111 117 108 100 32 98 101 32 115 112 108 105 116 46)")
If String <> "[This should be split.]"
  Debug "Unit Test Failed: Fuse with parameters"
  Debug "Should be: [This should be split.]"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

String = PNB::nListEvalString("(Fuse 55.5)")
If String <> "[8]"
  Debug "Unit Test Failed: Fuse with non-supported type (number)"
  Debug "Should be: [8]"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

String = PNB::nListEvalString("(Fuse [Test.])")
If String <> "[]"
  Debug "Unit Test Failed: Fuse with non-supported type (string)"
  Debug "Should be: []"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

String = PNB::nListEvalString("(Fuse)")
If String <> "[]"
  Debug "Unit Test Failed: Fuse without parameters"
  Debug "Should be: []"
  Debug "Is: "+String
  CallDebugger
EndIf
String = ""

;
;-Stress test
Debug "#Test how many times this query can be called per second:"
DisableDebugger
a = 0
StartTime_Stress = ElapsedMilliseconds()
Repeat
  a+1
  PNB::nListEvalString("(+ (+ 'oh no it ' 'is ') (+ 'spaghetticode ' 'D:') )")
  EndTime_Stress = ElapsedMilliseconds()
Until EndTime_Stress-StartTime_Stress > 1000
EnableDebugger
PNB::nListEvalString("Debug (+ [Your PC has called the single thread stress test ] ["+Str(a-1)+" ] [times in one second!])")


Debug "#Test if everything is dissolved in order: Should read 'oh no it is spaghetticode D:'."
PNB::nListEvalString("Debug (+ (+ 'oh no it ' 'is ') (+ 'spaghetticode ' 'D:'))")

Debug "#Integer test, multiple parameters: Should read '15', '-2', '-1'."
PNB::nListEvalString("Debug (+ 1 2 3 4 5)")
PNB::nListEvalString("Debug (+ 1 -3)")
PNB::nListEvalString("Debug (- 3 4)")

Debug "#Float test: Should read '3.95' or an approximation."
PNB::nListEvalString("Debug (+ 3.55 0.4)")

Debug "#Self-call test: Should read '9'."
PNB::nListEvalString("Eval [Debug (+ 3 3 3)]")

Debug "#Storage test: Should read '50', 'owo', 'test', 'of', 'multiline!'."
PNB::nListEvalString("Set Variable 50")
PNB::nListEvalString("Debug (Get Variable)")
PNB::nListEvalString("Set Variable [owo]")
PNB::nListEvalString("Debug (Get Variable)")
PNB::nListEvalString("Set Variable [test] [of] [multiline!]")
PNB::nListEvalString("Debug (Get Variable)")

Debug "#If-condition branching test: Should read 'It works!', 'If: 1!', 'This should show!'."
PNB::nListEvalString("If (+ 300 -2) Do (Debug 'It works!')")
PNB::nListEvalString("If (1) Do (Debug 'If: 1!')")
PNB::nListEvalString("If (0) Do (Debug [This shouldn't show.])")
PNB::nListEvalString("If (0) Do (Debug [This should also not show.]) Else Do (Debug [This should show!])")

Debug "#Select-condition branching test: Should read 'Select is 2.', 'Select is 1.', 'Select is none.'"
PNB::nListEvalString("Select (2) Case (1) Do (Debug 'Select is NOT 1.') Case (2) Do (Debug 'Select is 2.') Default Do (Debug 'Select is NOT none.')")
PNB::nListEvalString("Select (1) Case (1) Do (Debug 'Select is 1.') Case (2) Do (Debug 'Select is NOT 2.')")
PNB::nListEvalString("Select (5) Case (1) Do (Debug 'Select is NOT 1.') Case (2) Do (Debug 'Select is NOT 2.') Default Do (Debug 'Select is none.')")

Debug "#For-loop test: Should read '7'."
PNB::nListEvalString("For (7) Do (Set ForVar (+ (Get ForVar) 1))")
PNB::nListEvalString("Debug (Get ForVar)")

Debug "#While-Test: Should read 3 'NooooOo!'."
PNB::nListEvalString("Set WhileTest 3")
PNB::nListEvalString("While (Get WhileTest) Do ((Debug [NooooOo!]) (Set WhileTest (- (Get WhileTest) 1)) )")

Debug "#Until-Test: Should read 4 'Yes!'."
PNB::nListEvalString("Set UntilTest 0")
PNB::nListEvalString("Until (= (Get UntilTest) 4) Do ((Debug [Yes!]) (Set UntilTest (+ (Get UntilTest) 1)) )")

Debug "#Macro/As test: Should read 3 'Incrementing...', 'Reached it!'"
PNB::nListEvalString("Function (Testmacro) Do ((Debug [Incrementing...]) (Set Macro (+ (Get Macro) 1)) (If (= (Get Macro) 3) Do (Debug [Reached it!]) Else Do (Testmacro)) )")
PNB::nListEvalString("Testmacro")

Debug "#Macro/As multiple parameters test: Should read 'FirstString', 'SecondString'."
PNB::nListEvalString("Function (Testmacro) Do ([FirstString] ([SecondString]))")
PNB::nListEvalString("Debug (Testmacro)")

Debug "#Macro/As function test: Should read 'Reverse Order'."
PNB::nListEvalString("Function (Testmacro) Do (Debug (+ ee [ ] dd)) With (dd ee)")
PNB::nListEvalString("Testmacro Order Reverse")

Debug "#Macro/As function parameter test: Should read 'Order is Reversed'."
PNB::nListEvalString("Function (Testmacro) Do (+ ff [ ] ee [ ] dd) With (dd ee ff)")
PNB::nListEvalString("Debug (Testmacro Reversed is Order)")

Debug "#Macro/As function default parameter test: Should read 'Defined', 'Undefined'."
PNB::nListEvalString("Function (Testmacro) Do (dd ee) With (dd ee) As (Undefined Undefined)")
PNB::nListEvalString("Debug (Testmacro Defined)")

Debug "#Macro/As function parameter underload test: Should not be registered and return as list. Should read 'Testmacro', 'This'."
PNB::nListEvalString("Function (Testmacro) Do (+ dd ee) With (dd ee) As (Undefined)")
PNB::nListEvalString("Debug (Testmacro This)")

Debug "#Memory test. Should read 'This is a string.', '33.3' or an approximation, '240'."
PNB::nListEvalString("Set A (Allocate 100)")
PNB::nListEvalString("Poke (Get A) [This is a string.] (UByte 0)")
PNB::nListEvalString("Debug (Peek (Get A) String)")
PNB::nListEvalString("Poke (Get A) 33.3")
PNB::nListEvalString("Debug (Peek (Get A) Float)")
PNB::nListEvalString("Poke (Get A) 240")
PNB::nListEvalString("Debug (Peek (Get A) Integer)")
PNB::nListEvalString("Free All")

PNB::nListEvalString("(Invoke Void (Examine (Load user32.dll) MessageBoxW) 0 '*Steals a dragon tail*' '>:I' 0)")

End
