EnableExplicit

Procedure.i CountCommented(String.s, Start.i)
  
  Protected Finish.i = Len(String)
  Protected Depth.i
  Protected Index.i
  
  If PeekC(@String+Start*SizeOf(Character)) <> Asc(";")
    ProcedureReturn 0
  EndIf
  
  Repeat
    Index+1
    Select PeekC(@String+Start*SizeOf(Character)+Index*SizeOf(Character))
      Case Asc(";")
        Break
    EndSelect
  Until Start+Index > Finish
  
  ProcedureReturn Index
  
EndProcedure

Procedure.i CountApostrophed(String.s, Start.i)
  
  Protected Finish.i = Len(String)
  Protected Depth.i
  Protected Index.i
  
  If PeekC(@String+Start*SizeOf(Character)) <> Asc(";")
    ProcedureReturn 0
  EndIf
  
  Repeat
    Index+1
    Select PeekC(@String+Start*SizeOf(Character)+Index*SizeOf(Character))
      Case Asc("'")
        Break
    EndSelect
  Until Start+Index > Finish
  
  ProcedureReturn Index
  
EndProcedure

Procedure.i CountQuoted(String.s, Start.i)
  
  Protected Finish.i = Len(String)
  Protected Depth.i
  Protected Index.i
  
  If PeekC(@String+Start*SizeOf(Character)) <> 34
    ProcedureReturn 0
  EndIf
  
  Repeat
    Index+1
    Select PeekC(@String+Start*SizeOf(Character)+Index*SizeOf(Character))
      Case 34
        Break
    EndSelect
  Until Start+Index > Finish
  
  ProcedureReturn Index
  
EndProcedure

Procedure.i CountBracketed(String.s, Start.i)
  
  Protected Finish.i = Len(String)
  Protected Depth.i = 1
  Protected Index.i
  
  If PeekC(@String+Start*SizeOf(Character)) <> Asc("[")
    ProcedureReturn 0
  EndIf
  
  Repeat
    Index+1
    Select PeekC(@String+Start*SizeOf(Character)+Index*SizeOf(Character))
      Case Asc("[")
        Depth = Depth+1
      Case Asc("]")
        Depth = Depth-1
    EndSelect
  Until Depth = 0 Or Start+Index > Finish
  
  ProcedureReturn Index
  
EndProcedure

Procedure.i CountParenthesized(String.s, Start.i)
  
  Protected Finish.i = Len(String)
  Protected Depth.i = 1
  Protected Index.i
  
  If PeekC(@String+Start*SizeOf(Character)) <> Asc("(")
    ProcedureReturn 0
  EndIf
  
  Repeat
    Index+1
    Select PeekC(@String+Start*SizeOf(Character)+Index*SizeOf(Character))
      Case Asc(";")
        Index + CountCommented(String, Start+Index)
      Case Asc("'")
        Index + CountApostrophed(String, Start+Index)
      Case 34
        Index + CountQuoted(String, Start+Index)
      Case Asc("[")
        Index + CountBracketed(String, Start+Index)
      Case Asc("(")
        Depth = Depth+1
      Case Asc(")")
        Depth = Depth-1
    EndSelect
  Until Depth = 0 Or Start+Index > Finish
  
  ProcedureReturn Index
  
EndProcedure


Procedure.i StringToTriList(List Base.TriList(), String.s)
  
  Protected Start.i
  Protected Finish.i = Len(String)
  Protected Index.i
  
  Protected Flags.i
  
  While Index < Finish
    Select PeekC(@String+Index*SizeOf(Character))
      Case Asc(";") ;Block comments; will be ignored.
        Start = Index
        Index + CountCommented(String, Start)
        
        
      Case Asc("'") ;'Apostrophed expressions' are counted as strings. Brackets will be ignored.
        Start = Index
        Index + CountApostrophed(String, Start)
        
        If Not ListSize(Base()) Or Base()\Flags <> #PNB_TYPE_NONE
          AddElement(Base())
        EndIf
        
        Base()\Data = AllocateMemory((Index-Start-1)*SizeOf(Character)+SizeOf(Character))
        PokeS(Base()\Data, PeekS(@String+Start*SizeOf(Character)+SizeOf(Character), Index-Start-1))
        
        Base()\Flags | #PNB_TYPE_STRING
        Flags | #PNB_TYPE_STRING
        
        
      Case 34 ;"Quoted expressions" are counted as strings, too.
        Start = Index
        Index + CountQuoted(String, Start)
        
        If Not ListSize(Base()) Or Base()\Flags <> #PNB_TYPE_NONE
          AddElement(Base())
        EndIf
        
        Base()\Data = AllocateMemory((Index-Start-1)*SizeOf(Character)+SizeOf(Character))
        PokeS(Base()\Data, PeekS(@String+Start*SizeOf(Character)+SizeOf(Character), Index-Start-1))
        
        Base()\Flags | #PNB_TYPE_STRING
        Flags | #PNB_TYPE_STRING
        
        
      Case Asc("[") ;[Hard bracketed expressions] are an alternative to apostrophes and quotes.
        Start = Index
        Index + CountBracketed(String, Start)
        
        If Not ListSize(Base()) Or Base()\Flags <> #PNB_TYPE_NONE
          AddElement(Base())
        EndIf
        
        Base()\Data = AllocateMemory((Index-Start-1)*SizeOf(Character)+SizeOf(Character))
        PokeS(Base()\Data, PeekS(@String+Start*SizeOf(Character)+SizeOf(Character), Index-Start-1))
        
        Base()\Flags | #PNB_TYPE_STRING
        Flags | #PNB_TYPE_STRING
        
        
      Case Asc("(") ;Find (bracketed expressions), pass them, get the return value, then evaluate again.
        Start = Index
        Index + CountParenthesized(String, Start)
        
        If Not ListSize(Base()) Or Base()\Flags <> #PNB_TYPE_NONE
          AddElement(Base())
        EndIf
        
        Base()\Flags | #PNB_TYPE_LIST | StringToTriList(Base()\Child(), PeekS(@String+Start*SizeOf(Character)+SizeOf(Character), Index-Start-1))
        Flags | #PNB_TYPE_SUBLIST
        
        
      Case Asc(" "), 9, 13, 10 ;Ignore spaces, tabs, carriage returns (CR), and line feeds (LF).
        
      Default               ;Anything else, preferably commands.
        Start = Index
        
        Repeat
          Index+1
          Select PeekC(@String+(Index*SizeOf(Character)))
            Case Asc(" ")
              Break
            Case 9 ;tab
              Break
            Case 13, 10 ;CR LF
              Break
            Case Asc("("), Asc(")")
              Break
            Case Asc("[")
              Break
            Case Asc(";")
              Break
          EndSelect
        Until Index > Finish
        
        If Not ListSize(Base()) Or Base()\Flags <> #PNB_TYPE_NONE
          AddElement(Base())
        EndIf
        
        Base()\Data = AllocateMemory((Index-Start)*SizeOf(Character)+SizeOf(Character))
        PokeS(Base()\Data, PeekS(@String+Start*SizeOf(Character), Index-Start))
        
        Select PeekC(@String+Start*SizeOf(Character))
          Case 48 To 57, 43, 45 ; Numbers, plus, minus, and decimal
            Select PeekC(@String+Start*SizeOf(Character))
              Case 43, 45
                If Index-Start = 1
                  If Not ListIndex(Base())
                    Base()\Flags | #PNB_TYPE_COMMAND | #PNB_TYPE_NAME
                    Flags | #PNB_TYPE_COMMAND | #PNB_TYPE_NAME
                  Else
                    Base()\Flags | #PNB_TYPE_NAME
                    Flags | #PNB_TYPE_NAME
                  EndIf
                  Continue
                EndIf
            EndSelect
            
            If FindString(PeekS(@String+Start*SizeOf(Character), Index-Start), ".")
              If Len(StringField(PeekS(@String+Start*SizeOf(Character), Index-Start), 2, ".")) < 15
                Base()\Data = AllocateMemory(SizeOf(Float))
                PokeF(Base()\Data, ValF(PeekS(@String+Start*SizeOf(Character), Index-Start)))
                Base()\Flags | #PNB_TYPE_FLOAT
                Flags | #PNB_TYPE_FLOAT
              Else
                Base()\Data = AllocateMemory(SizeOf(Double))
                PokeF(Base()\Data, ValD(PeekS(@String+Start*SizeOf(Character), Index-Start)))
                Base()\Flags | #PNB_TYPE_FLOAT
                Flags | #PNB_TYPE_FLOAT
              EndIf
            Else
              If PeekS(Base()\Data, 2) = "0x"
                If MemoryStringLength(Base()\Data) < 11
                  Base()\Data = AllocateMemory(SizeOf(Integer))
                  PokeI(Base()\Data, Val("$"+PeekS(@String+(Start+2)*SizeOf(Character), Index-Start-2)))
                  Base()\Flags | #PNB_TYPE_INTEGER
                  Flags | #PNB_TYPE_INTEGER
                Else
                  Base()\Data = AllocateMemory(SizeOf(Quad))
                  PokeQ(Base()\Data, Val("$"+PeekS(@String+(Start+2)*SizeOf(Character), Index-Start-2)))
                  Base()\Flags | #PNB_TYPE_EPIC
                  Flags | #PNB_TYPE_EPIC
                EndIf
              ElseIf PeekS(Base()\Data, 2) = "0b"
                If MemoryStringLength(Base()\Data) < 35
                  Base()\Data = AllocateMemory(SizeOf(Integer))
                  PokeI(Base()\Data, Val("%"+PeekS(@String+(Start+2)*SizeOf(Character), Index-Start-2)))
                  Base()\Flags | #PNB_TYPE_INTEGER
                  Flags | #PNB_TYPE_INTEGER
                Else
                  Base()\Data = AllocateMemory(SizeOf(Quad))
                  PokeI(Base()\Data, Val("%"+PeekS(@String+(Start+2)*SizeOf(Character), Index-Start-2)))
                  Base()\Flags | #PNB_TYPE_EPIC
                  Flags | #PNB_TYPE_EPIC
                EndIf
              Else
                If MemoryStringLength(Base()\Data) < 12
                  Base()\Data = AllocateMemory(SizeOf(Integer))
                  PokeI(Base()\Data, Val(PeekS(@String+Start*SizeOf(Character), Index-Start)))
                  Base()\Flags | #PNB_TYPE_INTEGER
                  Flags | #PNB_TYPE_INTEGER
                Else
                  Base()\Data = AllocateMemory(SizeOf(Quad))
                  PokeQ(Base()\Data, Val(PeekS(@String+Start*SizeOf(Character), Index-Start)))
                  Base()\Flags | #PNB_TYPE_EPIC
                  Flags | #PNB_TYPE_EPIC
                EndIf
              EndIf
            EndIf
          Default
            If Not ListIndex(Base())
              Base()\Flags | #PNB_TYPE_COMMAND | #PNB_TYPE_NAME
              Flags | #PNB_TYPE_COMMAND | #PNB_TYPE_NAME
            Else
              Base()\Flags | #PNB_TYPE_NAME
              Flags | #PNB_TYPE_NAME
            EndIf
        EndSelect
        
        Index-1
        
    EndSelect
    Index+1
  Wend
  
  ProcedureReturn Flags
  
EndProcedure

Procedure.s TriListToString(List Base.TriList(), PrettyPrint.i = 0, Level.i = 0)
  
  Protected String.s
  
  If FirstElement(Base())
    
    Repeat
      
      If Base()\Data
        Select TypePriority(Base()\Flags)
          Case #PNB_TYPE_NAME
            If PrettyPrint
              String+Space(Level)+PeekS(Base()\Data)+#CRLF$
            Else
              String+PeekS(Base()\Data)
            EndIf
            
          Case #PNB_TYPE_STRING
            If PrettyPrint
              String+Space(Level)+"["+PeekS(Base()\Data)+"]"+#CRLF$
            Else
              String+"["+PeekS(Base()\Data)+"]"
            EndIf
            
          Case #PNB_TYPE_POINTER
            If PrettyPrint
              String+Space(Level)+Str(PeekI(Base()\Data))+#CRLF$
            Else
              CompilerSelect #PB_Compiler_Processor
                CompilerCase #PB_Processor_x64
                  String+"(ForcePointer 0x"+RSet(Hex(PeekI(Base()\Data), #PB_Quad), SizeOf(Integer), "0")+")"
                CompilerCase #PB_Processor_x86
                  String+"(ForcePointer 0x"+RSet(Hex(PeekI(Base()\Data), #PB_Long), SizeOf(Integer), "0")+")"
                CompilerDefault
                  CompilerError "ERROR: #PB_Compiler_Processor outside accepted parameters: Should be: (#PB_Processor_x86, #PB_Processor_x64). Is: "+#PB_Compiler_Processor
              CompilerEndSelect
            EndIf
            
          Case #PNB_TYPE_DOUBLE
            If PrettyPrint
              String+Space(Level)+StrD(PeekD(Base()\Data), 19)+#CRLF$
            Else
              String+"(ForceDouble 0x"+RSet(Hex(PeekQ(Base()\Data), #PB_Quad), SizeOf(Double), "0")+")"
            EndIf
            
          Case #PNB_TYPE_FLOAT
            If PrettyPrint
              String+Space(Level)+StrF(PeekF(Base()\Data), 14)+#CRLF$
            Else
              String+"(ForceFloat 0x"+RSet(Hex(PeekL(Base()\Data), #PB_Long), SizeOf(Float), "0")+")"
            EndIf
            
          Case #PNB_TYPE_EPIC
            If PrettyPrint
              String+Space(Level)+Str(PeekQ(Base()\Data))+#CRLF$
            Else
              String+"(ForceEpic 0x"+RSet(Hex(PeekQ(Base()\Data), #PB_Quad), SizeOf(Quad), "0")+")"
            EndIf
            
          Case #PNB_TYPE_INTEGER
            If PrettyPrint
              String+Space(Level)+Str(PeekI(Base()\Data))+#CRLF$
            Else
              CompilerSelect #PB_Compiler_Processor
                CompilerCase #PB_Processor_x64
                  String+"(ForceInteger 0x"+RSet(Hex(PeekI(Base()\Data), #PB_Quad), SizeOf(Integer), "0")+")"
                CompilerCase #PB_Processor_x86
                  String+"(ForceInteger 0x"+RSet(Hex(PeekI(Base()\Data), #PB_Long), SizeOf(Integer), "0")+")"
                CompilerDefault
                  CompilerError "ERROR: #PB_Compiler_Processor outside accepted parameters: Should be: (#PB_Processor_x86, #PB_Processor_x64). Is: "+#PB_Compiler_Processor
              CompilerEndSelect
            EndIf
            
          Case #PNB_TYPE_LONG
            If PrettyPrint
              String+Space(Level)+Str(PeekL(Base()\Data))+#CRLF$
            Else
              String+"(ForceLong 0x"+RSet(Hex(PeekL(Base()\Data), #PB_Long), SizeOf(Long), "0")+")"
            EndIf
            
          Case #PNB_TYPE_WORD
            If PrettyPrint
              String+Space(Level)+Str(PeekW(Base()\Data))+#CRLF$
            Else
              String+"(ForceWord 0x"+RSet(Hex(PeekW(Base()\Data), #PB_Word), SizeOf(Word), "0")+")"
            EndIf
            
          Case #PNB_TYPE_BYTE
            If PrettyPrint
              String+Space(Level)+Str(PeekB(Base()\Data))+#CRLF$
            Else
              String+"(ForceByte 0x"+RSet(Hex(PeekB(Base()\Data), #PB_Byte), SizeOf(Byte), "0")+")"
            EndIf
            
          Case #PNB_TYPE_UWORD
            If PrettyPrint
              String+Space(Level)+Str(PeekU(Base()\Data))+#CRLF$
            Else
              String+"(ForceUWord 0x"+RSet(Hex(PeekU(Base()\Data), #PB_Unicode), SizeOf(Unicode), "0")+")"
            EndIf
            
          Case #PNB_TYPE_CHARACTER
            If PrettyPrint
              String+Space(Level)+Str(PeekC(Base()\Data))+#CRLF$
            Else
              CompilerSelect #PB_Compiler_Unicode
                CompilerCase 1
                  String+"(ForceCharacter 0x"+RSet(Hex(PeekC(Base()\Data), #PB_Unicode), SizeOf(Character), "0")+")"
                CompilerCase 0
                  String+"(ForceCharacter 0x"+RSet(Hex(PeekC(Base()\Data), #PB_Ascii), SizeOf(Character), "0")+")"
                CompilerDefault
                  CompilerError "ERROR: #PB_Compiler_Unicode outside accepted parameters: Should be: (0, 1). Is: "+#PB_Compiler_Unicode
              CompilerEndSelect
            EndIf
            
          Case #PNB_TYPE_UBYTE
            If PrettyPrint
              String+Space(Level)+Str(PeekA(Base()\Data))+#CRLF$
            Else
              String+"(ForceUByte 0x"+RSet(Hex(PeekA(Base()\Data), #PB_Ascii), SizeOf(Ascii), "0")+")"
            EndIf
            
        EndSelect
        
        If Not PrettyPrint
          If ListIndex(Base()) <> ListSize(Base())-1
            String+" "
          EndIf
        EndIf
        
      EndIf
      
      If Base()\Flags & #PNB_TYPE_LIST
        If PrettyPrint
          String+Space(Level)+"("+#CRLF$
          Level+4
        Else
          String+"("
        EndIf
        
        String+TriListToString(Base()\Child(), PrettyPrint, Level)
        
        If PrettyPrint
          Level-4
          String+Space(Level)+")"+#CRLF$
        Else
          PushListPosition(Base())
          If NextElement(Base())
            If NextElement(Base())
              String+") "
            Else
              String+")"
            EndIf
          Else
            String+")"
          EndIf
          PopListPosition(Base())
        EndIf
        
      EndIf
      
      If Not NextElement(Base())
        Break
      EndIf
      
    ForEver
    
  EndIf
  
  If PrettyPrint And Not Level
    ProcedureReturn Trim(Trim(String, #LF$), #CR$)
  Else
    ProcedureReturn String
  EndIf
  
EndProcedure