XIncludeFile "pnb.pbi"

DisableExplicit
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

Debug "#Test if UNICODE works correctly. Should read 'Sigma!' in Greek letters, or, if UNICODE is not supported, '?????!'."
PNB::nListEvalString("Debug [Σιγμα!]")

Debug "#Test multiple parameter returns: Should read 'First', 'Second', 'Third', 'Fourth', 'Fifth', 'Sixth', 'Seventh'."
PNB::nListEvalString("Debug ([First] [Second]) ([Third] [Fourth] [Fifth]) [Sixth] ([Seventh])")

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



; Debug "#Beer song time!"
; CompilerSelect #PB_Compiler_Unicode
;   CompilerCase 1
;     PNB::nListEvalString(PeekS(?Beer, -1, #PB_UTF8))
;   CompilerDefault
;     PNB::nListEvalString(PeekS(?Beer, -1, #PB_Ascii))
; CompilerEndSelect
; 
; Debug "#Fibonacci calculation! This may take a while."
; CompilerSelect #PB_Compiler_Unicode
;   CompilerCase 1
;     PNB::nListEvalString(PeekS(?Fibonacci, -1, #PB_UTF8))
;   CompilerDefault
;     PNB::nListEvalString(PeekS(?Fibonacci, -1, #PB_Ascii))
; CompilerEndSelect

End
; 
; DataSection
;   Beer:
;   IncludeBinary "..\scripts\beer.pnb"
;   Data.c 0 ;Null terminator.
; EndDataSection
; 
; DataSection
;   Fibonacci:
;   IncludeBinary "..\scripts\fibonacci.pnb"
;   Data.c 0 ;Null terminator.
; EndDataSection