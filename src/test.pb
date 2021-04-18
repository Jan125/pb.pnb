XIncludeFile "pnb2.pbi"
DisableExplicit

OpenConsole()

Debug "#Test how many times this query can be called per second:"
a = 0
StartTime_Stress = ElapsedMilliseconds()
Repeat
  a+1
  EvalString("(+ (+ 'oh no it ' 'is ') (+ 'spaghetticode ' 'D:') )")
  EndTime_Stress = ElapsedMilliseconds()
Until EndTime_Stress-StartTime_Stress > 1000

EvalString("Debug (+ [Your PC has called the single thread stress test ] ["+Str(a-1)+" ] [times in one second!])")

Debug "#Test if UNICODE works correctly. Should read 'Sigma!' in Greek letters, or, if UNICODE is not supported, '?????!'."
EvalString("Debug [Σιγμα!]")

Debug "#Test multiple parameter returns: Should read 'First -newline- Second -newline- Third -newline- Fourth -newline- Fifth -newline- Sixth -newline- Seventh'."
EvalString("Debug ([First] [Second]) ([Third] [Fourth] [Fifth]) [Sixth] ([Seventh])")

Debug "#Test if everything is dissolved in order: Should read 'oh no it is spaghetticode D:'."
EvalString("Debug (+ (+ 'oh no it ' 'is ') (+ 'spaghetticode ' 'D:'))")

Debug "#Integer test, multiple parameters: Should read '15', '-2', '-1'."
EvalString("Debug (+ 1 2 3 4 5)")
EvalString("Debug (+ 1 -3)")
EvalString("Debug (- 3 4)")

Debug "#Float test: Should read '3.95' or an approximation."
EvalString("Debug (+ 3.55 0.4)")

Debug "#Self-call test: Should read '9'."
EvalString("Eval [Debug (+ 3 3 3)]")

Debug "#Storage test: Should read '50', 'owo', 'test', 'of', 'multiline!'."
EvalString("Set [Variable] 50")
EvalString("Debug (Get [Variable])")
EvalString("Set [Variable] [owo]")
EvalString("Debug (Get [Variable])")
EvalString("Set [Variable] [test] [of] [multiline!]")
EvalString("Debug (Get [Variable])")

Debug "#If-condition branching test: Should read 'It works!', 'If: 1!', 'This should show!'."
EvalString("If (+ 300 -2) Do (Debug 'It works!')")
EvalString("If (1) Do (Debug 'If: 1!')")
EvalString("If (0) Do (Debug [This shouldn't show.])")
EvalString("If (0) Do (Debug [This should also not show.]) Else Do (Debug [This should show!])")

Debug "#Select-condition branching test: Should read 'Select is 2.'."
EvalString("Select (2) Case (1) Do (Debug 'Select is 1.') Case (2) Do (Debug 'Select is 2.') Default Do (Debug 'Select is none.')")

Debug "#For-loop test: Should read '7'."
EvalString("For (7) Do (Set [ForVar] (+ (Get [ForVar]) 1))")
EvalString("Debug (Get [ForVar])")

Debug "#While-Test: Should read 3 'NooooOo!'."
EvalString("Set [WhileTest] 3")
EvalString("While (Get [WhileTest]) Do ((Debug [NooooOo!]) (Set [WhileTest] (- (Get [WhileTest]) 1)) )")

Debug "#Until-Test: Should read 4 'Yes!'."
EvalString("Set [UntilTest] 0")
EvalString("Until (= (Get [UntilTest]) 4) Do ((Debug [Yes!]) (Set [UntilTest] (+ (Get [UntilTest]) 1)) )")

Debug "#Macro/As test: Should read 3 'Incrementing...', 'Reached it!'"
EvalString("Function (Testmacro) Do ((Debug [Incrementing...]) (Set Macro (+ (Get Macro) 1)) (If (= (Get Macro) 3) Do (Debug [Reached it!]) Else Do (Testmacro)) )")
EvalString("Testmacro")

Debug "#Macro/As multiple parameters test: Should read 'FirstString -newline- SecondString'."
EvalString("Function (Testmacro) Do ([FirstString] ([SecondString]))")
EvalString("Debug (Testmacro)")

Debug "#Macro/As function test: Should read 'Reverse Order'."
EvalString("Function (Testmacro) Do (Debug (+ ee [ ] dd)) With (dd ee)")
EvalString("Testmacro Order Reverse")

Debug "#Macro/As function parameter test: Should read 'Order is Reversed'."
EvalString("Function (Testmacro) Do (+ ff [ ] ee [ ] dd) With (dd ee ff)")
EvalString("Debug (Testmacro Reversed is Order)")

End
; IDE Options = PureBasic 5.46 LTS (Windows - x86)
; CursorPosition = 16
; FirstLine = 4
; EnableUnicode
; EnableXP