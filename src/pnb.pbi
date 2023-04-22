EnableExplicit
DeclareModule PNB
  CompilerIf #PB_Compiler_Thread = 1
    Global MutexFunMap.i
    Global MutexVarMap.i
    Global MutexMemMap.i
  CompilerEndIf
  Global NewMap *PLIST()
  Declare.s nListEvalString(String.s)
  Declare.i nListEnableBinary(Toggle.i)
EndDeclareModule
Module PNB
  CompilerIf #PB_Compiler_LineNumbering
    Procedure ErrorHandler()
      MessageRequester("Error", ErrorMessage(ErrorCode())+#CRLF$+"File: "+ErrorFile()+#CRLF$+"Line: "+ErrorLine())
    EndProcedure
    
    OnErrorCall(@ErrorHandler())
    
  CompilerEndIf
  
  
  Structure Pointer
    *p
  EndStructure
  
  Structure nList
    List nList.nList()
    Flags.i
    StructureUnion
      a.a
      c.c
      u.u
      b.b
      w.w
      l.l
      i.i
      q.q
      f.f
      d.d
      *p
    EndStructureUnion
    s.s
  EndStructure
  
  Structure nListThread
    List nList.nList()
  EndStructure
  
  Declare.i nListEval(List nList.nList())
  
  Declare.s nListEvalString(String.s)
  Declare.i nListEvalThread(*nList.nListThread)
  Declare.i nListEvalThreadFork(*nList.nListThread)
  Declare.i nListEnableBinary(Toggle.i)
  
  Declare.i CountCommented(String.s, Index.i)
  Declare.i CountApostrophed(String.s, Index.i)
  Declare.i CountQuoted(String.s, Index.i)
  Declare.i CountHardbracketed(String.s, Index.i)
  Declare.i CountBracketed(String.s, Index.i)
  
  Global EnableBinary.i
  
  Procedure.i nListEnableBinary(Toggle.i)
    EnableBinary = Toggle
  EndProcedure
  
  CompilerIf #PB_Compiler_ExecutableFormat = #PB_Compiler_DLL Or #PB_Compiler_Thread = 1
    Global MutexFunMap.i
    Global MutexVarMap.i
    Global MutexMemMap.i
  CompilerEndIf
  
  CompilerIf #PB_Compiler_ExecutableFormat <> #PB_Compiler_DLL And #PB_Compiler_Thread = 1
    MutexFunMap = CreateMutex()
    MutexVarMap = CreateMutex()
    MutexMemMap = CreateMutex()
  CompilerEndIf
  
  Global NewMap Lexicon.nList()
  Global NewMap Param.nList()
  Global NewMap ParamDefault.nList()
  Global NewMap Memory.nList()
  
  EnumerationBinary PNB_TYPE 0
    #PNB_TYPE_NONE
    #PNB_TYPE_LIST = 1
    #PNB_TYPE_COMMAND
    
    
    #PNB_TYPE_UBYTE
    #PNB_TYPE_CHARACTER
    #PNB_TYPE_UWORD
    
    #PNB_TYPE_BYTE
    #PNB_TYPE_WORD
    #PNB_TYPE_LONG
    #PNB_TYPE_INTEGER
    #PNB_TYPE_EPIC
    
    #PNB_TYPE_FLOAT
    #PNB_TYPE_DOUBLE
    
    #PNB_TYPE_POINTER
    
    #PNB_TYPE_STRING
    #PNB_TYPE_NAME
  EndEnumeration
  
  Procedure.i nListGetHighestType(Flags.i)
    If Flags & #PNB_TYPE_LIST
      ProcedureReturn #PNB_TYPE_LIST
    ElseIf Flags & #PNB_TYPE_NAME
      ProcedureReturn #PNB_TYPE_NAME
    ElseIf Flags & #PNB_TYPE_STRING
      ProcedureReturn #PNB_TYPE_STRING
    ElseIf Flags & #PNB_TYPE_POINTER
      ProcedureReturn #PNB_TYPE_POINTER
    ElseIf Flags & #PNB_TYPE_DOUBLE
      ProcedureReturn #PNB_TYPE_DOUBLE
    ElseIf Flags & #PNB_TYPE_FLOAT
      ProcedureReturn #PNB_TYPE_FLOAT
    ElseIf Flags & #PNB_TYPE_EPIC
      ProcedureReturn #PNB_TYPE_EPIC
    ElseIf Flags & #PNB_TYPE_INTEGER
      ProcedureReturn #PNB_TYPE_INTEGER
    ElseIf Flags & #PNB_TYPE_LONG
      ProcedureReturn #PNB_TYPE_LONG
    ElseIf Flags & #PNB_TYPE_WORD
      ProcedureReturn #PNB_TYPE_WORD
    ElseIf Flags & #PNB_TYPE_BYTE
      ProcedureReturn #PNB_TYPE_BYTE
    ElseIf Flags & #PNB_TYPE_UWORD
      ProcedureReturn #PNB_TYPE_UWORD
    ElseIf Flags & #PNB_TYPE_CHARACTER
      ProcedureReturn #PNB_TYPE_CHARACTER
    ElseIf Flags & #PNB_TYPE_UBYTE
      ProcedureReturn #PNB_TYPE_UBYTE
    EndIf
    ProcedureReturn #PNB_TYPE_NONE
  EndProcedure
  
  Procedure.i nListTypeFromList(List nList.nList())
    Protected Flags.i
    If ListSize(nList())
      PushListPosition(nList())
      ForEach nList()
        Flags | nList()\Flags
      Next
      PopListPosition(nList())
    EndIf
    ProcedureReturn Flags
  EndProcedure
  
  Procedure nListConvert(List nList.nList(), DesiredType.i, ConvertPointers.i = 0)
    Protected *PTR
    PushListPosition(nList())
    ForEach nList()
      Select nListGetHighestType(nList()\Flags)
        Case #PNB_TYPE_LIST
          PopListPosition(nList())
          ProcedureReturn
        Case #PNB_TYPE_NAME
          Select DesiredType
            Case #PNB_TYPE_STRING
              nList()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\p = Val("$"+Mid(nList()\s, 2))
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\p = Val("%"+Mid(nList()\s, 2))
              Else
                nList()\p = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\q = Val("$"+Mid(nList()\s, 2))
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\q = Val("%"+Mid(nList()\s, 2))
              Else
                nList()\d = ValD(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_FLOAT
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\l = Val("$"+Mid(nList()\s, 2))
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\l = Val("%"+Mid(nList()\s, 2))
              Else
                nList()\f = ValF(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_EPIC
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\q = Val("$"+Mid(nList()\s, 2))
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\q = Val("%"+Mid(nList()\s, 2))
              Else
                nList()\q = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_INTEGER
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\i = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\i = Val("%"+nList()\s)
              Else
                nList()\i = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_LONG
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\l = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\l = Val("%"+nList()\s)
              Else
                nList()\l = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_WORD
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\w = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\w = Val("%"+nList()\s)
              Else
                nList()\w = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_BYTE
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\b = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\b = Val("%"+nList()\s)
              Else
                nList()\b = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_UWORD
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\u = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\u = Val("%"+nList()\s)
              Else
                nList()\u = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_CHARACTER
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\c = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\c = Val("%"+nList()\s)
              Else
                nList()\c = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_CHARACTER
            Case #PNB_TYPE_UBYTE
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\a = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\a = Val("%"+nList()\s)
              Else
                nList()\a = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_STRING
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_POINTER
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\p = Val("$"+Mid(nList()\s, 2))
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\p = Val("%"+Mid(nList()\s, 2))
              Else
                nList()\p = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\q = Val("$"+Mid(nList()\s, 2))
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\q = Val("%"+Mid(nList()\s, 2))
              Else
                nList()\d = ValD(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_FLOAT
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\l = Val("$"+Mid(nList()\s, 2))
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\l = Val("%"+Mid(nList()\s, 2))
              Else
                nList()\f = ValF(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_EPIC
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\q = Val("$"+Mid(nList()\s, 2))
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\q = Val("%"+Mid(nList()\s, 2))
              Else
                nList()\q = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_INTEGER
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\i = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\i = Val("%"+nList()\s)
              Else
                nList()\i = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_LONG
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\l = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\l = Val("%"+nList()\s)
              Else
                nList()\l = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_WORD
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\w = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\w = Val("%"+nList()\s)
              Else
                nList()\w = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_BYTE
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\b = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\b = Val("%"+nList()\s)
              Else
                nList()\b = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_UWORD
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\u = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\u = Val("%"+nList()\s)
              Else
                nList()\u = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_CHARACTER
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\c = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\c = Val("%"+nList()\s)
              Else
                nList()\c = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_CHARACTER
            Case #PNB_TYPE_UBYTE
              While Left(nList()\s, 1) = "$" Or Left(nList()\s, 1) = "%"
                nList()\s = Mid(nList()\s, 2)
              Wend
              If Left(nList()\s, 2) = "0x"
                nList()\a = Val("$"+nList()\s)
              ElseIf Left(nList()\s, 2) = "0b"
                nList()\a = Val("%"+nList()\s)
              Else
                nList()\a = Val(nList()\s)
              EndIf
              nList()\s = ""
              nList()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_POINTER
          If ConvertPointers
            Select DesiredType
              Case #PNB_TYPE_NAME
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\s = PeekS(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_NAME
              Case #PNB_TYPE_STRING
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\s = PeekS(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_STRING
              Case #PNB_TYPE_DOUBLE
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\d = PeekD(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_DOUBLE
              Case #PNB_TYPE_FLOAT
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\f = PeekF(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_FLOAT
              Case #PNB_TYPE_EPIC
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\q = PeekQ(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_EPIC
              Case #PNB_TYPE_INTEGER
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\i = PeekI(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_INTEGER
              Case #PNB_TYPE_LONG
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\l = PeekL(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_LONG
              Case #PNB_TYPE_WORD
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\w = PeekW(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_WORD
              Case #PNB_TYPE_BYTE
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\b = PeekB(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_BYTE
              Case #PNB_TYPE_UWORD
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\u = PeekU(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_UWORD
              Case #PNB_TYPE_CHARACTER
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\c = PeekC(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_CHARACTER
              Case #PNB_TYPE_UBYTE
                *PTR = nList()\p
                nList()\p = 0
                CompilerIf #PB_Compiler_Thread = 1
                  LockMutex(MutexMemMap)
                CompilerEndIf
                nList()\a = PeekA(*PTR)
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexMemMap)
                CompilerEndIf
                *PTR = 0
                nlist()\Flags = #PNB_TYPE_UBYTE
            EndSelect
          Else
            Select DesiredType
              Case #PNB_TYPE_NAME
                nList()\s = Str(nList()\p)
                nList()\p = 0
                nlist()\Flags = #PNB_TYPE_NAME
              Case #PNB_TYPE_STRING
                nList()\s = Str(nList()\p)
                nList()\p = 0
                nlist()\Flags = #PNB_TYPE_STRING
              Case #PNB_TYPE_DOUBLE
                nList()\d = nList()\p
                nlist()\Flags = #PNB_TYPE_DOUBLE
              Case #PNB_TYPE_FLOAT
                nList()\f = nList()\p
                nlist()\Flags = #PNB_TYPE_FLOAT
              Case #PNB_TYPE_EPIC
                nList()\q = nList()\p
                nlist()\Flags = #PNB_TYPE_EPIC
              Case #PNB_TYPE_INTEGER
                nList()\i = nList()\p
                nlist()\Flags = #PNB_TYPE_INTEGER
              Case #PNB_TYPE_LONG
                nList()\l = nList()\p
                nlist()\Flags = #PNB_TYPE_LONG
              Case #PNB_TYPE_WORD
                nList()\w = nList()\p
                nlist()\Flags = #PNB_TYPE_WORD
              Case #PNB_TYPE_BYTE
                nList()\b = nList()\p
                nlist()\Flags = #PNB_TYPE_BYTE
              Case #PNB_TYPE_UWORD
                nList()\u = nList()\p
                nlist()\Flags = #PNB_TYPE_UWORD
              Case #PNB_TYPE_CHARACTER
                nList()\c = nList()\p
                nlist()\Flags = #PNB_TYPE_CHARACTER
              Case #PNB_TYPE_UBYTE
                nList()\a = nList()\p
                nlist()\Flags = #PNB_TYPE_UBYTE
            EndSelect
          EndIf
        Case #PNB_TYPE_DOUBLE
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\s = StrD(nList()\d, 19)
              nList()\d = 0
              nlist()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_STRING
              nList()\s = StrD(nList()\d, 19)
              nList()\d = 0
              nlist()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              nList()\p = nList()\d
              nlist()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_FLOAT
              nList()\f = nList()\d
              nlist()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_EPIC
              nList()\q = nList()\d
              nlist()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_INTEGER
              nList()\i = nList()\d
              nlist()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_LONG
              nList()\l = nList()\d
              nlist()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_WORD
              nList()\w = nList()\d
              nlist()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_BYTE
              nList()\b = nList()\d
              nlist()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_UWORD
              nList()\u = nList()\d
              nlist()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_CHARACTER
              nList()\c = nList()\d
              nlist()\Flags = #PNB_TYPE_CHARACTER
            Case #PNB_TYPE_UBYTE
              nList()\a = nList()\d
              nlist()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_FLOAT
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\s = StrF(nList()\f, 14)
              nList()\f = 0
              nlist()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_STRING
              nList()\s = StrF(nList()\f, 14)
              nList()\f = 0
              nlist()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              nList()\p = nList()\f
              nlist()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              nList()\d = nList()\f
              nlist()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_EPIC
              nList()\q = nList()\f
              nlist()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_INTEGER
              nList()\i = nList()\f
              nlist()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_LONG
              nList()\l = nList()\f
              nlist()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_WORD
              nList()\w = nList()\f
              nlist()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_BYTE
              nList()\b = nList()\f
              nlist()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_UWORD
              nList()\u = nList()\f
              nlist()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_CHARACTER
              nList()\c = nList()\f
              nlist()\Flags = #PNB_TYPE_CHARACTER
            Case #PNB_TYPE_UBYTE
              nList()\a = nList()\f
              nlist()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_EPIC
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\s = Str(nList()\q)
              nList()\q = 0
              nlist()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_STRING
              nList()\s = Str(nList()\q)
              nList()\q = 0
              nlist()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              nList()\p = nList()\q
              nlist()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              nList()\d = nList()\q
              nlist()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_FLOAT
              nList()\f = nList()\q
              nlist()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_INTEGER
              nList()\i = nList()\q
              nlist()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_LONG
              nList()\l = nList()\q
              nlist()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_WORD
              nList()\w = nList()\q
              nlist()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_BYTE
              nList()\b = nList()\q
              nlist()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_UWORD
              nList()\u = nList()\q
              nlist()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_CHARACTER
              nList()\c = nList()\q
              nlist()\Flags = #PNB_TYPE_CHARACTER
            Case #PNB_TYPE_UBYTE
              nList()\a = nList()\q
              nlist()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_INTEGER
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\s = Str(nList()\i)
              nList()\i = 0
              nlist()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_STRING
              nList()\s = Str(nList()\i)
              nList()\i = 0
              nlist()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              nList()\p = nList()\i
              nlist()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              nList()\d = nList()\i
              nlist()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_FLOAT
              nList()\f = nList()\i
              nlist()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_EPIC
              nList()\q = nList()\i
              nlist()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_LONG
              nList()\l = nList()\i
              nlist()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_WORD
              nList()\w = nList()\i
              nlist()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_BYTE
              nList()\b = nList()\i
              nlist()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_UWORD
              nList()\u = nList()\i
              nlist()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_CHARACTER
              nList()\c = nList()\i
              nlist()\Flags = #PNB_TYPE_CHARACTER
            Case #PNB_TYPE_UBYTE
              nList()\a = nList()\i
              nlist()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_LONG
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\s = Str(nList()\l)
              nList()\l = 0
              nlist()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_STRING
              nList()\s = Str(nList()\l)
              nList()\l = 0
              nlist()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              nList()\p = nList()\l
              nlist()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              nList()\d = nList()\l
              nlist()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_FLOAT
              nList()\f = nList()\l
              nlist()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_EPIC
              nList()\q = nList()\l
              nlist()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_INTEGER
              nList()\i = nList()\l
              nlist()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_WORD
              nList()\w = nList()\l
              nlist()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_BYTE
              nList()\b = nList()\l
              nlist()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_UWORD
              nList()\u = nList()\l
              nlist()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_CHARACTER
              nList()\c = nList()\l
              nlist()\Flags = #PNB_TYPE_CHARACTER
            Case #PNB_TYPE_UBYTE
              nList()\a = nList()\l
              nlist()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_WORD
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\s = Str(nList()\w)
              nList()\w = 0
              nlist()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_STRING
              nList()\s = Str(nList()\w)
              nList()\w = 0
              nlist()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              nList()\p = nList()\w
              nlist()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              nList()\d = nList()\w
              nlist()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_FLOAT
              nList()\f = nList()\w
              nlist()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_EPIC
              nList()\q = nList()\w
              nlist()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_INTEGER
              nList()\i = nList()\w
              nlist()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_LONG
              nList()\l = nList()\w
              nlist()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_BYTE
              nList()\b = nList()\w
              nlist()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_UWORD
              nList()\u = nList()\w
              nlist()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_CHARACTER
              nList()\c = nList()\w
              nlist()\Flags = #PNB_TYPE_CHARACTER
            Case #PNB_TYPE_UBYTE
              nList()\a = nList()\w
              nlist()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_BYTE
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\s = Str(nList()\b)
              nList()\b = 0
              nlist()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_STRING
              nList()\s = Str(nList()\b)
              nList()\b = 0
              nlist()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              nList()\p = nList()\b
              nlist()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              nList()\d = nList()\b
              nlist()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_FLOAT
              nList()\f = nList()\b
              nlist()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_EPIC
              nList()\q = nList()\b
              nlist()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_INTEGER
              nList()\i = nList()\b
              nlist()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_LONG
              nList()\l = nList()\b
              nlist()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_WORD
              nList()\w = nList()\b
              nlist()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_UWORD
              nList()\u = nList()\b
              nlist()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_CHARACTER
              nList()\c = nList()\b
              nlist()\Flags = #PNB_TYPE_CHARACTER
            Case #PNB_TYPE_UBYTE
              nList()\a = nList()\b
              nlist()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_UWORD
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\s = Str(nList()\u)
              nList()\u = 0
              nlist()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_STRING
              nList()\s = Str(nList()\u)
              nList()\u = 0
              nlist()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              nList()\p = nList()\u
              nlist()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              nList()\d = nList()\u
              nlist()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_FLOAT
              nList()\f = nList()\u
              nlist()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_EPIC
              nList()\q = nList()\u
              nlist()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_INTEGER
              nList()\i = nList()\u
              nlist()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_LONG
              nList()\l = nList()\u
              nlist()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_WORD
              nList()\w = nList()\u
              nlist()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_BYTE
              nList()\b = nList()\u
              nlist()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_CHARACTER
              nList()\c = nList()\u
              nlist()\Flags = #PNB_TYPE_CHARACTER
            Case #PNB_TYPE_UBYTE
              nList()\a = nList()\u
              nlist()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_CHARACTER
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\s = Str(nList()\c)
              nList()\c = 0
              nlist()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_STRING
              nList()\s = Str(nList()\c)
              nList()\c = 0
              nlist()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              nList()\p = nList()\c
              nlist()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              nList()\d = nList()\c
              nlist()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_FLOAT
              nList()\f = nList()\c
              nlist()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_EPIC
              nList()\q = nList()\c
              nlist()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_INTEGER
              nList()\i = nList()\c
              nlist()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_LONG
              nList()\l = nList()\c
              nlist()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_WORD
              nList()\w = nList()\c
              nlist()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_BYTE
              nList()\b = nList()\c
              nlist()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_UWORD
              nList()\u = nList()\c
              nlist()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_UBYTE
              nList()\a = nList()\c
              nlist()\Flags = #PNB_TYPE_UBYTE
          EndSelect
        Case #PNB_TYPE_UBYTE
          Select DesiredType
            Case #PNB_TYPE_NAME
              nList()\s = Str(nList()\a)
              nList()\a = 0
              nlist()\Flags = #PNB_TYPE_NAME
            Case #PNB_TYPE_STRING
              nList()\s = Str(nList()\a)
              nList()\a = 0
              nlist()\Flags = #PNB_TYPE_STRING
            Case #PNB_TYPE_POINTER
              nList()\p = nList()\a
              nlist()\Flags = #PNB_TYPE_POINTER
            Case #PNB_TYPE_DOUBLE
              nList()\d = nList()\a
              nlist()\Flags = #PNB_TYPE_DOUBLE
            Case #PNB_TYPE_FLOAT
              nList()\f = nList()\a
              nlist()\Flags = #PNB_TYPE_FLOAT
            Case #PNB_TYPE_EPIC
              nList()\q = nList()\a
              nlist()\Flags = #PNB_TYPE_EPIC
            Case #PNB_TYPE_INTEGER
              nList()\i = nList()\a
              nlist()\Flags = #PNB_TYPE_INTEGER
            Case #PNB_TYPE_LONG
              nList()\l = nList()\a
              nlist()\Flags = #PNB_TYPE_LONG
            Case #PNB_TYPE_WORD
              nList()\w = nList()\a
              nlist()\Flags = #PNB_TYPE_WORD
            Case #PNB_TYPE_BYTE
              nList()\b = nList()\a
              nlist()\Flags = #PNB_TYPE_BYTE
            Case #PNB_TYPE_UWORD
              nList()\u = nList()\a
              nlist()\Flags = #PNB_TYPE_UWORD
            Case #PNB_TYPE_CHARACTER
              nList()\c = nList()\a
              nlist()\Flags = #PNB_TYPE_CHARACTER
          EndSelect
      EndSelect
    Next
    PopListPosition(nList())
    ProcedureReturn
  EndProcedure
  
  Procedure.i nListDelete(List nList.nList(), StringToFind.s)
    Protected Ocurrences.i = 0
    Protected a.i
    ForEach nList()
      If ListSize(nList()\nList())
        a = nListDelete(nList()\nList(), StringToFind)
        Ocurrences = Ocurrences + a
      EndIf
      If nList()\Flags & #PNB_TYPE_NAME
        If nList()\s = StringToFind
          Ocurrences = Ocurrences + 1
          DeleteElement(nList())
        EndIf
      EndIf
    Next
    ProcedureReturn Ocurrences
  EndProcedure
  
  Procedure.i nListReplace(List nList.nList(), StringToFind.s, *Element.nList)
    Protected Ocurrences.i = 0
    Protected a.i
    ForEach nList()
      If ListSize(nList()\nList())
        a = nListReplace(nList()\nList(), StringToFind, *Element)
        Ocurrences = Ocurrences + a
        If a > 0
          nList()\Flags | *Element\Flags
        EndIf
      EndIf
      If nList()\Flags & #PNB_TYPE_NAME
        If nList()\s = StringToFind
          nList()\s = ""
          Ocurrences = Ocurrences + 1
          Select nListGetHighestType(*Element\Flags)
            Case #PNB_TYPE_NAME
              nList()\s = *Element\s
            Case #PNB_TYPE_STRING
              nList()\s = *Element\s
            Case #PNB_TYPE_POINTER
              nList()\p = *Element\p
            Case #PNB_TYPE_DOUBLE
              nList()\d = *Element\d
            Case #PNB_TYPE_FLOAT
              nList()\f = *Element\f
            Case #PNB_TYPE_EPIC
              nList()\q = *Element\q
            Case #PNB_TYPE_INTEGER
              nList()\i = *Element\i
            Case #PNB_TYPE_LONG
              nList()\l = *Element\l
            Case #PNB_TYPE_WORD
              nList()\w = *Element\w
            Case #PNB_TYPE_BYTE
              nList()\b = *Element\b
            Case #PNB_TYPE_UWORD
              nList()\u = *Element\u
            Case #PNB_TYPE_CHARACTER
              nList()\c = *Element\c
            Case #PNB_TYPE_UBYTE
              nList()\a = *Element\a
          EndSelect
          nList()\Flags = *Element\Flags
        EndIf
      EndIf
    Next
    ProcedureReturn Ocurrences
  EndProcedure
  
  
  
  Procedure.i nListCompare(List nList1.nList(), List nList2.nList())
    PushListPosition(nList1())
    PushListPosition(nList2())
    ResetList(nList1())
    ResetList(nList2())
    If ListSize(nList1()) = ListSize(nList2())
      ForEach nList1()
        NextElement(nList2())
        If nListCompare(nList1()\nList(), nList2()\nList())
          If nList1()\Flags <> nList2()\Flags
            PopListPosition(nList1())
            PopListPosition(nList2())
            ProcedureReturn 0
          ElseIf nListGetHighestType(nList1()\Flags) = #PNB_TYPE_STRING Or nListGetHighestType(nList1()\Flags) = #PNB_TYPE_NAME
            If nList1()\s <> nList2()\s
              PopListPosition(nList1())
              PopListPosition(nList2())
              ProcedureReturn 0 
            EndIf
          Else
            Select nListGetHighestType(nList1()\Flags)
              Case #PNB_TYPE_POINTER
                If nList1()\p <> nList2()\p
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
              Case #PNB_TYPE_DOUBLE
                If nList1()\d <> nList2()\d
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
              Case #PNB_TYPE_FLOAT
                If nList1()\f <> nList2()\f
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
              Case #PNB_TYPE_EPIC
                If nList1()\q <> nList2()\q
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
              Case #PNB_TYPE_INTEGER
                If nList1()\i <> nList2()\i
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
              Case #PNB_TYPE_LONG
                If nList1()\l <> nList2()\l
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
              Case #PNB_TYPE_WORD
                If nList1()\w <> nList2()\w
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
              Case #PNB_TYPE_BYTE
                If nList1()\b <> nList2()\b
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
              Case #PNB_TYPE_UWORD
                If nList1()\u <> nList2()\u
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
              Case #PNB_TYPE_CHARACTER
                If nList1()\c <> nList2()\c
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
              Case #PNB_TYPE_UBYTE
                If nList1()\a <> nList2()\a
                  PopListPosition(nList1())
                  PopListPosition(nList2())
                  ProcedureReturn 0 
                EndIf
            EndSelect
            
          EndIf
          
        Else
          PopListPosition(nList1())
          PopListPosition(nList2())
          ProcedureReturn 0
        EndIf
      Next
      PopListPosition(nList1())
      PopListPosition(nList2())
      ProcedureReturn 1
    Else
      PopListPosition(nList1())
      PopListPosition(nList2())
      ProcedureReturn 0
    EndIf
    
    
  EndProcedure
  
  Procedure.i CountCommented(String.s, Start.i)
    Protected Depth.i
    Protected Index.i
    Repeat
      Index+1
      Select Asc(Mid(String, Start+Index, 1))
        Case Asc(";")
          Break
      EndSelect
    Until Start+Index > Len(String)
    ProcedureReturn Index
  EndProcedure
  
  Procedure.i CountApostrophed(String.s, Start.i)
    Protected Depth.i
    Protected Index.i
    Repeat
      Index+1
      Select Asc(Mid(String, Start+Index, 1))
        Case Asc("'")
          Break
      EndSelect
    Until Start+Index > Len(String)
    ProcedureReturn Index
  EndProcedure
  
  Procedure.i CountQuoted(String.s, Start.i)
    Protected Depth.i
    Protected Index.i
    Repeat
      Index+1
      Select Asc(Mid(String, Start+Index, 1))
        Case 34
          Break
      EndSelect
    Until Start+Index > Len(String)
    ProcedureReturn Index
  EndProcedure
  
  Procedure.i CountHardbracketed(String.s, Start.i)
    Protected Depth.i = 1
    Protected Index.i
    Repeat
      Index+1
      Select Asc(Mid(String, Start+Index, 1))
        Case Asc("[")
          Depth = Depth+1
        Case Asc("]")
          Depth = Depth-1
      EndSelect
    Until Depth = 0 Or Start+Index > Len(String)
    ProcedureReturn Index
  EndProcedure
  
  Procedure.i CountBracketed(String.s, Start.i)
    Protected Depth.i = 1
    Protected Index.i
    Repeat
      Index+1
      Select Asc(Mid(String, Start+Index, 1))
        Case Asc(";")
          Index + CountCommented(String, Start+Index)
        Case Asc("'")
          Index + CountApostrophed(String, Start+Index)
        Case 34
          Index + CountQuoted(String, Start+Index)
        Case Asc("[")
          Index + CountHardbracketed(String, Start+Index)
        Case Asc("(")
          Depth = Depth+1
        Case Asc(")")
          Depth = Depth-1
      EndSelect
    Until Depth = 0 Or Start+Index > Len(String)
    ProcedureReturn Index
  EndProcedure
  
  
  Procedure.i nListPNBTonList(List nList.nList(), String.s)
    Protected Start.i
    Protected Index.i
    Protected Depth.i
    
    Start = 1
    Index = 1
    Depth = 0
    
    While Index <= Len(String)
      Select Asc(Mid(String, Index, 1))
        Case Asc(";") ;Block comments; will be ignored.
          Start = Index
          Index + CountCommented(String, Start)
          
        Case Asc("'") ;'Apostrophed expressions' are counted as strings. Brackets will be ignored.
          Start = Index
          Index + CountApostrophed(String, Start)
          
          AddElement(nList())
          nList()\Flags | #PNB_TYPE_STRING
          nList()\s = Mid(String, Start+1, Index-Start-1)
          
        Case 34 ;"Quoted expressions" are counted as strings, too.
          Start = Index
          Index + CountQuoted(String, Start)
          
          AddElement(nList())
          nList()\Flags | #PNB_TYPE_STRING
          nList()\s = Mid(String, Start+1, Index-Start-1)
          
        Case Asc("[") ;[Hard bracketed expressions] are an alternative to apostrophes and quotes.
          Start = Index
          Index + CountHardbracketed(String, Start)
          
          AddElement(nList())
          nList()\Flags | #PNB_TYPE_STRING
          nList()\s = Mid(String, Start+1, Index-Start-1)
          
        Case Asc("(") ;Find (bracketed expressions), pass them, get the return value, then evaluate again.
          Start = Index
          Index + CountBracketed(String, Start)
          
          AddElement(nList())
          nListPNBtonList(nList()\nList(), Mid(String, Start+1, Index-Start-1))
          nList()\Flags | #PNB_TYPE_LIST
          
        Case Asc(" "), 9, 13, 10 ;Ignore spaces, tabs, carriage returns (CR), and line feeds (LF).
          
        Default               ;Anything else, preferably commands.
          Start = Index
          
          Repeat
            Index+1
            Select Asc(Mid(String, Index, 1))
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
          Until Index > Len(String)
          
          AddElement(nList())
          nList()\s = Mid(String, Start, Index-Start)
          
          Select Asc(nList()\s)
            Case 48 To 57, 43, 45 ; Numbers, plus, minus, and decimal
              Select Asc(nList()\s)
                Case 43, 45
                  If Len(nList()\s) = 1
                    If ListIndex(nList()) = 0
                      nList()\Flags | #PNB_TYPE_COMMAND | #PNB_TYPE_NAME
                    Else
                      nList()\Flags | #PNB_TYPE_NAME
                    EndIf
                    Continue
                  EndIf
              EndSelect
              If FindString(nList()\s, ".")
                If Len(StringField(nList()\s, 2, ".")) < 15
                  nList()\f = ValF(nList()\s)
                  nList()\Flags | #PNB_TYPE_FLOAT
                  nList()\s = ""
                Else
                  nList()\f = ValD(nList()\s)
                  nList()\Flags | #PNB_TYPE_DOUBLE
                  nList()\s = ""
                EndIf
              Else
                If Mid(nList()\s, 1, 2) = "0x"
                  If Len(nList()\s) < 11
                    nList()\l = Val("$"+Mid(nList()\s, 3))
                    nList()\Flags | #PNB_TYPE_INTEGER
                    nList()\s = ""
                  Else
                    nList()\q = Val("$"+Mid(nList()\s, 3))
                    nList()\Flags | #PNB_TYPE_EPIC
                    nList()\s = ""
                  EndIf
                ElseIf Mid(nList()\s, 1, 2) = "0b"
                  If Len(nList()\s) < 35
                    nList()\l = Val("%"+Mid(nList()\s, 3))
                    nList()\Flags | #PNB_TYPE_INTEGER
                    nList()\s = ""
                  Else
                    nList()\q = Val("%"+Mid(nList()\s, 3))
                    nList()\Flags | #PNB_TYPE_EPIC
                    nList()\s = ""
                  EndIf
                Else
                  If Len(nList()\s) < 12
                    nList()\l = Val(nList()\s)
                    nList()\Flags | #PNB_TYPE_INTEGER
                    nList()\s = ""
                  Else
                    nList()\q = Val(nList()\s)
                    nList()\Flags | #PNB_TYPE_EPIC
                    nList()\s = ""
                  EndIf
                EndIf
              EndIf
            Default
              If ListIndex(nList()) = 0
                nList()\Flags | #PNB_TYPE_COMMAND | #PNB_TYPE_NAME
              Else
                nList()\Flags | #PNB_TYPE_NAME
              EndIf
          EndSelect
          
          Index = Index-1
          
      EndSelect
      Index = Index+1
    Wend
    ProcedureReturn
  EndProcedure
  
  
  Procedure.s nListPNBToString(List nList.nList(), Binary.i = 0, PrettyPrint.i = 0)
    Protected String.s
    ForEach nList()
      If ListSize(nList()\nList())
        Select PrettyPrint
          Case 0
            String + "("+nListPNBToString(nList()\nList(), Binary)+") "
          Default
            String + #CRLF$ + RSet("", PrettyPrint, Chr(9)) + "(" + #CRLF$ + RSet("", PrettyPrint+1, Chr(9)) + nListPNBToString(nList()\nList(), Binary, PrettyPrint+1) + #CRLF$ + RSet("", PrettyPrint, Chr(9)) + ")" +  #CRLF$ + " "
        EndSelect
      Else
        Select nListGetHighestType(nList()\Flags)
          Case #PNB_TYPE_UBYTE
            If Binary
              String + "(ForceUByte 0x"+Hex(nList()\a, #PB_Ascii)+") "
            Else
              String + Str(nList()\b)+" "
            EndIf
          Case #PNB_TYPE_BYTE
            If Binary
              String + "(ForceByte 0x"+Hex(nList()\b, #PB_Byte)+") "
            Else
              String + Str(nList()\b)+" "
            EndIf
          Case #PNB_TYPE_CHARACTER
            If Binary
              CompilerIf #PB_Compiler_Unicode
                String + "(ForceCharacter 0x"+Hex(nList()\c, #PB_Unicode)+") "
              CompilerElse
                String + "(ForceCharacter 0x"+Hex(nList()\c, #PB_Ascii)+") "
              CompilerEndIf
            Else
              String + Str(nList()\c)+" "
            EndIf
          Case #PNB_TYPE_DOUBLE
            If Binary
              String + "(ForceDouble 0x"+Hex(nList()\q, #PB_Quad)+") "
            Else
              String + StrD(nList()\d, 19)+" "
            EndIf
          Case #PNB_TYPE_FLOAT
            If Binary
              String + "(ForceFloat 0x"+Hex(nList()\l, #PB_Long)+") "
            Else
              String + StrF(nList()\f, 14)+" "
            EndIf
          Case #PNB_TYPE_INTEGER
            If Binary
              CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
                String + "(ForceInteger 0x"+Hex(nList()\q, #PB_Quad)+") "
              CompilerElse
                String + "(ForceInteger 0x"+Hex(nList()\l, #PB_Long)+") "
              CompilerEndIf
            Else
              String + Str(nList()\i)+" "
            EndIf
          Case #PNB_TYPE_LONG
            If Binary
              String + "(ForceLong 0x"+Hex(nList()\l, #PB_Long)+") "
            Else
              String + Str(nList()\l)+" "
            EndIf
          Case #PNB_TYPE_NAME
            String + nList()\s+" "
          Case #PNB_TYPE_POINTER
            If Binary
              CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
                String + "(ForcePointer 0x"+Hex(nList()\p, #PB_Quad)+") "
              CompilerElse
                String + "(ForcePointer 0x"+Hex(nList()\p, #PB_Long)+") "
              CompilerEndIf
            Else
              String + Str(nList()\p)+" "
            EndIf
          Case #PNB_TYPE_EPIC
            If Binary
              String + "(ForceQuad 0x"+Hex(nList()\q, #PB_Quad)+") "
            Else
              String + Str(nList()\q)+" "
            EndIf
          Case #PNB_TYPE_STRING
            String + "["+nList()\s+"] "
          Case #PNB_TYPE_UWORD
            If Binary
              String + "(ForceUWord 0x"+Hex(nList()\u, #PB_Unicode)+") "
            Else
              String + Str(nList()\u)+" "
            EndIf
          Case #PNB_TYPE_WORD
            If Binary
              String + "(ForceWord 0x"+Hex(nList()\w, #PB_Word)+") "
            Else
              String + Str(nList()\w)+" "
            EndIf
        EndSelect
      EndIf
    Next
    If String
      String = Left(String, Len(String)-1)
    EndIf
    
    ProcedureReturn String
  EndProcedure
  
  ;-PNB::Include Files
  XIncludeFile "functions\pnb_basic.pbi"
  XIncludeFile "functions\pnb_listmanipulation.pbi"
  XIncludeFile "functions\pnb_typemanipulation.pbi"
  XIncludeFile "functions\pnb_variables.pbi"
  XIncludeFile "functions\pnb_arithmetic.pbi"
  XIncludeFile "functions\pnb_logic.pbi"
  XIncludeFile "functions\pnb_memory.pbi"
  XIncludeFile "functions\pnb_dll.pbi"
  
  Procedure.i nListEval(List nList.nList())
    Protected CAR.s
    Protected a.i
    Protected b.i
    Protected RBOL.i
    Protected RCNT.i
    Protected RINT.i
    Protected RFLT.f
    Protected RSTR.s
    
    Protected RTYP.i
    
    Protected RASC.a
    Protected RBYT.b
    Protected RCHR.c
    Protected RDBL.d
    Protected RLNG.l
    Protected RQUD.q
    Protected RWRD.w
    Protected RUNI.u
    Protected *RPTR
    
    Protected *TPTR.nListThread
    
    Protected NewList cList1.nList()
    Protected NewList cList2.nList()
    Protected NewList cList3.nList()
    Protected NewList cList4.nList()
    
    
    
    ;-Preprocess
    If FirstElement(nList())
      If nList()\Flags & #PNB_TYPE_LIST = 0
        If nList()\Flags & #PNB_TYPE_COMMAND
          Select nList()\s
            Case "If" ;--If
              RCNT = 0
              ForEach nList()
                If nList()\Flags & #PNB_TYPE_NAME
                  Select nList()\s
                    Case "If", "ElseIf"
                      Select nList()\s ;Check for first run to ensure language specification
                        Case "If"
                          If RCNT <> 0
                            ClearList(nList())
                            Break
                          EndIf
                          RCNT = 1
                        Case "ElseIf"
                          If RCNT <> 1
                            ClearList(nList())
                            Break
                          EndIf
                      EndSelect
                      DeleteElement(nList()) ;Delete the If/ElseIf
                      If NextElement(nList())
                        ;We compare here.
                        If nList()\Flags & #PNB_TYPE_LIST
                          nListEval(nList()\nList())
                          MergeLists(nList()\nList(), cList1(), #PB_List_After)
                        Else
                          ClearList(nList())
                          Break
                        EndIf
                        DeleteElement(nList())
                        If NextElement(nList()) ;This is Do
                          If nList()\Flags & #PNB_TYPE_NAME
                            If nList()\s = "Do"
                              DeleteElement(nList())
                              If NextElement(nList()) ;This is the expression.
                                RBOL = Bool(ListSize(cList1()))
                                ForEach cList1()
                                  Select nListGetHighestType(cList1()\Flags)
                                    Case #PNB_TYPE_UBYTE
                                      RBOL = Bool(RBOL And Bool(cList1()\a))
                                    Case #PNB_TYPE_BYTE
                                      RBOL = Bool(RBOL And Bool(cList1()\b))
                                    Case #PNB_TYPE_CHARACTER
                                      RBOL = Bool(RBOL And Bool(cList1()\c))
                                    Case #PNB_TYPE_DOUBLE
                                      RBOL = Bool(RBOL And Bool(cList1()\d))
                                    Case #PNB_TYPE_FLOAT
                                      RBOL = Bool(RBOL And Bool(cList1()\f))
                                    Case #PNB_TYPE_INTEGER
                                      RBOL = Bool(RBOL And Bool(cList1()\i))
                                    Case #PNB_TYPE_LONG
                                      RBOL = Bool(RBOL And Bool(cList1()\l))
                                    Case #PNB_TYPE_NAME
                                      RBOL = Bool(RBOL And Bool(cList1()\s = "True"))
                                    Case #PNB_TYPE_EPIC
                                      RBOL = Bool(RBOL And Bool(cList1()\q))
                                    Case #PNB_TYPE_STRING
                                      RBOL = Bool(RBOL And Bool(cList1()\s = "True"))
                                    Case #PNB_TYPE_UWORD
                                      RBOL = Bool(RBOL And Bool(cList1()\u))
                                    Case #PNB_TYPE_WORD
                                      RBOL = Bool(RBOL And Bool(cList1()\w))
                                  EndSelect
                                Next
                                ClearList(cList1())
                                If RBOL
                                  If nList()\Flags & #PNB_TYPE_LIST
                                    nListEval(nList()\nList())
                                    MergeLists(nList()\nList(), nList(), #PB_List_Before)
                                    DeleteElement(nList())
                                  Else
                                    ClearList(nList())
                                    Break
                                  EndIf
                                  While NextElement(nList())
                                    DeleteElement(nList())
                                  Wend
                                Else
                                  DeleteElement(nList())
                                EndIf
                              Else
                                ClearList(nList())
                                Break
                              EndIf
                            Else
                              ClearList(nList())
                              Break
                            EndIf
                          Else
                            ClearList(nList())
                            Break
                          EndIf
                        Else
                          ClearList(nList())
                          Break
                        EndIf
                      Else
                        ClearList(nList())
                        Break
                      EndIf
                    Case "Else"
                      DeleteElement(nList())
                      If NextElement(nList()) ; Do
                        If nList()\Flags & #PNB_TYPE_NAME
                          If nList()\s = "Do"
                            DeleteElement(nList())
                            If NextElement(nList()) ;Expression
                              If nList()\Flags & #PNB_TYPE_LIST
                                nListEval(nList()\nList())
                                MergeLists(nList()\nList(), nList(), #PB_List_Before)
                                DeleteElement(nList())
                              Else
                                ClearList(nList())
                                Break
                              EndIf
                              While NextElement(nList())
                                DeleteElement(nList())
                              Wend
                            Else
                              ClearList(nList())
                              Break
                            EndIf
                          Else
                            ClearList(nList())
                          EndIf
                        Else
                          ClearList(nList())
                          Break
                        EndIf
                      Else
                        ClearList(nList())
                        Break
                      EndIf
                  EndSelect
                Else
                  ClearList(nList())
                  Break
                EndIf
              Next
              
              
            Case "Select" ;--Select
              DeleteElement(nList()) ;Free the Select
              If NextElement(nList())
                If nList()\Flags & #PNB_TYPE_LIST
                  nListEval(nList()\nList())
                  MergeLists(nList()\nList(), cList1(), #PB_List_After)
                Else
                  ClearList(nList())
                EndIf
                DeleteElement(nList())
                ForEach nList()
                  If nList()\Flags & #PNB_TYPE_NAME
                    Select nList()\s
                      Case "Case"
                        DeleteElement(nList())
                        If NextElement(nList()) ;Expression
                          If nList()\Flags & #PNB_TYPE_LIST
                            nListEval(nList()\nList())
                            MergeLists(nList()\nList(), cList2(), #PB_List_After)
                          Else
                            ClearList(nList())
                            ClearList(cList2())
                            Break
                          EndIf
                          DeleteElement(nList())
                          If NextElement(nList()) ; do
                            If nList()\Flags & #PNB_TYPE_NAME
                              If nList()\s = "Do"
                                DeleteElement(nList())
                                If NextElement(nList())
                                  If nListCompare(cList1(), cList2())
                                    If nList()\Flags & #PNB_TYPE_LIST
                                      nListEval(nList()\nList())
                                      MergeLists(nList()\nList(), nList(), #PB_List_Before)
                                      DeleteElement(nList())
                                    Else
                                      ClearList(nList())
                                      ClearList(cList2())
                                      Break
                                    EndIf
                                    While NextElement(nList())
                                      DeleteElement(nList())
                                    Wend
                                  Else
                                    DeleteElement(nList())
                                  EndIf
                                Else
                                  ClearList(nList())
                                  ClearList(cList2())
                                  Break
                                EndIf
                              Else
                                ClearList(nList())
                                ClearList(cList2())
                                Break
                              EndIf
                            Else
                              ClearList(nList())
                              ClearList(cList2())
                              Break
                            EndIf
                          Else
                            ClearList(nList())
                            ClearList(cList2())
                            Break
                          EndIf
                        Else
                          ClearList(nList())
                          ClearList(cList2())
                          Break
                        EndIf
                        ClearList(cList2())
                      Case "Default"
                        DeleteElement(nList())
                        If NextElement(nList())
                          If nList()\Flags & #PNB_TYPE_NAME
                            If nList()\s = "Do"
                              DeleteElement(nList()) ;do
                              If NextElement(nList())
                                If nList()\Flags & #PNB_TYPE_LIST
                                  nListEval(nList()\nList())
                                  MergeLists(nList()\nList(), nList(), #PB_List_Before)
                                  DeleteElement(nList())
                                Else
                                  ClearList(nList())
                                  ClearList(cList2())
                                  Break
                                EndIf
                                While NextElement(nList())
                                  DeleteElement(nList())
                                Wend
                              Else
                                ClearList(nList())
                                Break
                              EndIf
                            Else
                              ClearList(nList())  
                            EndIf
                          Else
                            ClearList(nList())
                          EndIf
                        Else
                          ClearList(nList())
                          Break
                        EndIf
                    EndSelect
                  Else
                    ClearList(nList())
                    Break
                  EndIf
                Next
              Else
                ClearList(nList())
              EndIf
              ClearList(cList1())
              
              
            Case "While" ;--While
              DeleteElement(nList()) ;Free the While
              If NextElement(nList());condition
                If nList()\Flags & #PNB_TYPE_LIST
                  AddElement(cList1())
                  cList1() = nList()
                  DeleteElement(nList())
                  If NextElement(nList()) ;do
                    If nList()\Flags & #PNB_TYPE_NAME
                      If nList()\s = "Do"
                        DeleteElement(nList())
                        If NextElement(nList()) ;expression
                          If nList()\Flags & #PNB_TYPE_LIST
                            AddElement(cList2())
                            cList2() = nList()
                            DeleteElement(nList())
                            Repeat
                              AddElement(cList3())
                              cList3() = cList1()
                              If cList3()\Flags & #PNB_TYPE_LIST
                                nListEval(cList3()\nList())
                                MergeLists(cList3()\nList(), cList3(), #PB_List_After)
                                DeleteElement(cList3())
                              EndIf
                              RBOL = Bool(ListSize(cList3()))
                              ForEach cList3()
                                Select nListGetHighestType(cList3()\Flags)
                                  Case #PNB_TYPE_UBYTE
                                    RBOL = Bool(RBOL And Bool(cList3()\a))
                                  Case #PNB_TYPE_BYTE
                                    RBOL = Bool(RBOL And Bool(cList3()\b))
                                  Case #PNB_TYPE_CHARACTER
                                    RBOL = Bool(RBOL And Bool(cList3()\c))
                                  Case #PNB_TYPE_DOUBLE
                                    RBOL = Bool(RBOL And Bool(cList3()\d))
                                  Case #PNB_TYPE_FLOAT
                                    RBOL = Bool(RBOL And Bool(cList3()\f))
                                  Case #PNB_TYPE_INTEGER
                                    RBOL = Bool(RBOL And Bool(cList3()\i))
                                  Case #PNB_TYPE_LONG
                                    RBOL = Bool(RBOL And Bool(cList3()\l))
                                  Case #PNB_TYPE_NAME
                                    RBOL = Bool(RBOL And Bool(cList3()\s = "True"))
                                  Case #PNB_TYPE_EPIC
                                    RBOL = Bool(RBOL And Bool(cList3()\q))
                                  Case #PNB_TYPE_STRING
                                    RBOL = Bool(RBOL And Bool(cList3()\s = "True"))
                                  Case #PNB_TYPE_UWORD
                                    RBOL = Bool(RBOL And Bool(cList3()\u))
                                  Case #PNB_TYPE_WORD
                                    RBOL = Bool(RBOL And Bool(cList3()\w))
                                EndSelect
                              Next
                              ClearList(cList3())
                              AddElement(cList4())
                              cList4() = cList2()
                              If RBOL
                                If cList4()\Flags & #PNB_TYPE_LIST
                                  nListEval(cList4()\nList())
                                  MergeLists(cList4()\nList(), nList(), #PB_List_Before)
                                EndIf
                              Else
                                While NextElement(nList())
                                  DeleteElement(nList())
                                Wend
                                Break
                              EndIf
                              ClearList(cList4())
                            ForEver
                          Else
                            ClearList(nList())
                            ClearList(cList1())
                          EndIf
                        EndIf
                        ClearList(cList1())
                        ClearList(cList2())
                        ClearList(cList3())
                        ClearList(cList4())
                      Else
                        ClearList(nList())
                        ClearList(cList1())
                      EndIf
                    Else
                      ClearList(nList())
                      ClearList(cList1())
                    EndIf
                  Else
                    ClearList(nList())
                    ClearList(cList1())
                  EndIf
                Else
                  ClearList(nList())
                EndIf
              Else
                ClearList(nList())
              EndIf
              
              
            Case "Until" ;--Until
              DeleteElement(nList()) ;Free the Until
              If NextElement(nList());condition
                If nList()\Flags & #PNB_TYPE_LIST
                  AddElement(cList1())
                  cList1() = nList()
                  DeleteElement(nList())
                  If NextElement(nList())
                    If nList()\Flags & #PNB_TYPE_NAME
                      If nList()\s = "Do"
                        DeleteElement(nList())
                        If NextElement(nList()) ;expression
                          If nList()\Flags & #PNB_TYPE_LIST
                            AddElement(cList2())
                            cList2() = nList()
                            DeleteElement(nList())
                            Repeat
                              AddElement(cList4())
                              cList4() = cList2()
                              nListEval(cList4()\nList())
                              MergeLists(cList4()\nList(), nList(), #PB_List_Before)
                              AddElement(cList3())
                              cList3() = cList1()
                              nListEval(cList3()\nList())
                              MergeLists(cList3()\nList(), cList3(), #PB_List_After)
                              DeleteElement(cList3())
                              RBOL = Bool(ListSize(cList3()))
                              ForEach cList3()
                                Select nListGetHighestType(cList3()\Flags)
                                  Case #PNB_TYPE_UBYTE
                                    RBOL = Bool(RBOL And Bool(cList3()\a))
                                  Case #PNB_TYPE_BYTE
                                    RBOL = Bool(RBOL And Bool(cList3()\b))
                                  Case #PNB_TYPE_CHARACTER
                                    RBOL = Bool(RBOL And Bool(cList3()\c))
                                  Case #PNB_TYPE_DOUBLE
                                    RBOL = Bool(RBOL And Bool(cList3()\d))
                                  Case #PNB_TYPE_FLOAT
                                    RBOL = Bool(RBOL And Bool(cList3()\f))
                                  Case #PNB_TYPE_INTEGER
                                    RBOL = Bool(RBOL And Bool(cList3()\i))
                                  Case #PNB_TYPE_LONG
                                    RBOL = Bool(RBOL And Bool(cList3()\l))
                                  Case #PNB_TYPE_NAME
                                    RBOL = Bool(RBOL And Bool(cList3()\s = "True"))
                                  Case #PNB_TYPE_EPIC
                                    RBOL = Bool(RBOL And Bool(cList3()\q))
                                  Case #PNB_TYPE_STRING
                                    RBOL = Bool(RBOL And Bool(cList3()\s = "True"))
                                  Case #PNB_TYPE_UWORD
                                    RBOL = Bool(RBOL And Bool(cList3()\u))
                                  Case #PNB_TYPE_WORD
                                    RBOL = Bool(RBOL And Bool(cList3()\w))
                                EndSelect
                              Next
                              ClearList(cList3())
                              If RBOL
                                While NextElement(nList())
                                  DeleteElement(nList())
                                Wend
                                Break
                              EndIf
                            ForEver
                            ClearList(cList1())
                            ClearList(cList2())
                            ClearList(cList3())
                            ClearList(cList4())
                          Else
                            ClearList(nList())
                            ClearList(cList1())
                          EndIf
                        Else
                          ClearList(nList())
                          ClearList(cList1())
                        EndIf
                      Else
                        ClearList(nList())
                        ClearList(cList1())
                      EndIf
                    Else
                      ClearList(nList())
                      ClearList(cList1())
                    EndIf
                  Else
                    ClearList(nList())
                    ClearList(cList1())
                  EndIf
                Else
                  ClearList(nList())
                EndIf
              Else
                ClearList(nList())
              EndIf
              
              
            Case "For" ;--For
              DeleteElement(nList()) ;Free the For
              If NextElement(nList());count
                If nList()\Flags & #PNB_TYPE_LIST
                  nListEval(nList()\nList())
                  MergeLists(nList()\nList(), cList1(), #PB_List_After)
                  DeleteElement(nList())
                  RINT = 0
                  ForEach cList1()
                    Select nListGetHighestType(cList1()\Flags)
                      Case #PNB_TYPE_UBYTE
                        RINT = RINT + cList1()\a
                      Case #PNB_TYPE_BYTE
                        RINT = RINT + cList1()\b
                      Case #PNB_TYPE_CHARACTER
                        RINT = RINT + cList1()\c
                      Case #PNB_TYPE_DOUBLE
                        RINT = RINT + cList1()\d
                      Case #PNB_TYPE_FLOAT
                        RINT = RINT + cList1()\f
                      Case #PNB_TYPE_INTEGER
                        RINT = RINT + cList1()\i
                      Case #PNB_TYPE_LONG
                        RINT = RINT + cList1()\l
                      Case #PNB_TYPE_EPIC
                        RINT = RINT + cList1()\q
                      Case #PNB_TYPE_UWORD
                        RINT = RINT + cList1()\u
                      Case #PNB_TYPE_WORD
                        RINT = RINT + cList1()\w
                    EndSelect
                  Next
                  ClearList(cList1())
                  If NextElement(nList()) ;do
                    If nList()\Flags & #PNB_TYPE_NAME
                      If nList()\s = "Do"
                        DeleteElement(nList())
                        If NextElement(nList()) ;expression
                          If nList()\Flags & #PNB_TYPE_LIST
                            AddElement(cList2()) 
                            cList2() = nList()
                            DeleteElement(nList())
                            If RINT > 0
                              For RCNT = 1 To RINT
                                AddElement(cList3())
                                cList3() = cList2()
                                nListEval(cList3()\nList())
                                MergeLists(cList3()\nList(), nList(), #PB_List_After)
                                ClearList(cList3())
                              Next
                            EndIf
                            ClearList(cList1())
                            ClearList(cList2())
                            ClearList(cList3())
                          Else
                            ClearList(nList())
                            ClearList(cList1())
                          EndIf
                        Else
                          ClearList(nList())
                          ClearList(cList1())
                        EndIf
                      Else
                        ClearList(nList())
                        ClearList(cList1())
                      EndIf
                    Else
                      ClearList(nList())
                      ClearList(cList1())
                    EndIf
                  Else
                    ClearList(nList())
                    ClearList(cList1())
                  EndIf
                Else
                  ClearList(nList())
                EndIf
              Else
                ClearList(nList())
              EndIf
              
            Case "Function" ;--Function
              DeleteElement(nList()) ;Free the Function
              
              If NextElement(nList())
                If nList()\Flags & #PNB_TYPE_LIST
                  AddElement(cList1()) ;names, aliases
                  cList1() = nList()
                  DeleteElement(nList())
                  If NextElement(nList());do
                    If nList()\Flags & #PNB_TYPE_NAME
                      If nList()\s = "Do"
                        DeleteElement(nList())
                        If NextElement(nList())
                          If nList()\Flags & #PNB_TYPE_LIST
                            AddElement(cList2()) ;core function
                            cList2() = nList()
                            DeleteElement(nList())
                            If NextElement(nList())
                              If nList()\Flags & #PNB_TYPE_NAME
                                If nList()\s = "With"
                                  DeleteElement(nList())
                                  If NextElement(nList())
                                    If nList()\Flags & #PNB_TYPE_LIST
                                      AddElement(cList3()) ;core function
                                      cList3() = nList()
                                      DeleteElement(nList())
                                      If NextElement(nList())
                                        If nList()\Flags & #PNB_TYPE_NAME
                                          If nList()\s = "As"
                                            DeleteElement(nList())
                                            If NextElement(nList())
                                              If nList()\Flags & #PNB_TYPE_LIST
                                                AddElement(cList4()) ;default params
                                                cList4() = nList()
                                                DeleteElement(nList())
                                              Else
                                                ClearList(nList())
                                                ClearList(cList1())
                                                ClearList(cList2())
                                                ClearList(cList3())
                                              EndIf
                                            Else
                                              ClearList(nList())
                                              ClearList(cList1())
                                              ClearList(cList2())
                                              ClearList(cList3())
                                            EndIf
                                          Else
                                            ClearList(nList())
                                            ClearList(cList1())
                                            ClearList(cList2())
                                            ClearList(cList3())
                                          EndIf
                                        Else
                                          ClearList(nList())
                                          ClearList(cList1())
                                          ClearList(cList2())
                                          ClearList(cList3())
                                        EndIf
                                      EndIf
                                      ClearList(nList())
                                    Else
                                      ClearList(nList())
                                      ClearList(cList1())
                                      ClearList(cList2())
                                    EndIf
                                  Else
                                    ClearList(nList())
                                    ClearList(cList1())
                                    ClearList(cList2())
                                  EndIf
                                Else
                                  ClearList(nList())
                                  ClearList(cList1())
                                  ClearList(cList2())
                                EndIf
                              Else
                                ClearList(nList())
                                ClearList(cList1())
                                ClearList(cList2())
                              EndIf
                            EndIf
                            
                            ForEach cList1()\nList()
                              If cList1()\nList()\Flags & #PNB_TYPE_NAME
                                If cList1()\nList()\s = "All"
                                  If FirstElement(cList2()\nList())
                                    If cList2()\nList()\Flags & #PNB_TYPE_NAME
                                      If cList2()\nList()\s = "Clear"
                                        CompilerIf #PB_Compiler_Thread = 1
                                          LockMutex(MutexFunMap)
                                        CompilerEndIf
                                        ClearMap(Lexicon())
                                        ClearMap(Param())
                                        ClearMap(ParamDefault())
                                        CompilerIf #PB_Compiler_Thread = 1
                                          UnlockMutex(MutexFunMap)
                                        CompilerEndIf
                                        Break
                                      Else
                                        Break
                                      EndIf
                                    Else
                                      Break
                                    EndIf
                                  Else
                                    Break
                                  EndIf
                                Else ;normal function declaration
                                  CompilerIf #PB_Compiler_Thread = 1
                                    LockMutex(MutexFunMap)
                                  CompilerEndIf
                                  AddMapElement(Lexicon(), cList1()\nList()\s)
                                  AddMapElement(Param(), cList1()\nList()\s)
                                  AddMapElement(ParamDefault(), cList1()\nList()\s)
                                  If FirstElement(cList2()\nList())
                                    If cList2()\nList()\Flags & #PNB_TYPE_NAME
                                      If cList2()\nList()\s = "Clear"
                                        DeleteMapElement(Lexicon())
                                        DeleteMapElement(Param())
                                        DeleteMapElement(ParamDefault())
                                      Else
                                        If ListSize(cList4())
                                          If ListSize(cList3()\nList()) = ListSize(cList4()\nList())
                                            Lexicon() = cList2()
                                            Param() = cList3()
                                            ParamDefault() = cList4()
                                          Else
                                            DeleteMapElement(Lexicon())
                                            DeleteMapElement(Param())
                                            DeleteMapElement(ParamDefault())
                                            Break
                                          EndIf
                                        Else
                                          Lexicon() = cList2()
                                          If ListSize(cList3())
                                            Param() = cList3()
                                          EndIf
                                        EndIf
                                      EndIf
                                    Else
                                      If ListSize(cList4())
                                        If ListSize(cList3()\nList()) = ListSize(cList4()\nList())
                                          Lexicon() = cList2()
                                          Param() = cList3()
                                          ParamDefault() = cList4()
                                        Else
                                          DeleteMapElement(Lexicon())
                                          DeleteMapElement(Param())
                                          DeleteMapElement(ParamDefault())
                                          Break
                                        EndIf
                                      Else
                                        Lexicon() = cList2()
                                        If ListSize(cList3())
                                          Param() = cList3()
                                        EndIf
                                      EndIf
                                    EndIf
                                  Else
                                    DeleteMapElement(Lexicon())
                                    DeleteMapElement(Param())
                                    DeleteMapElement(ParamDefault())
                                  EndIf
                                  CompilerIf #PB_Compiler_Thread = 1
                                    UnlockMutex(MutexFunMap)
                                  CompilerEndIf
                                EndIf
                              EndIf
                            Next
                            ClearList(nList())
                            ClearList(cList1())
                            ClearList(cList2())
                            ClearList(cList3())
                            ClearList(cList4())
                          Else
                            ClearList(nList())
                            ClearList(cList1())
                          EndIf
                        Else
                          ClearList(nList())
                          ClearList(cList1())
                        EndIf
                      Else
                        ClearList(nList())
                        ClearList(cList1())
                      EndIf
                    Else
                      ClearList(nList())
                      ClearList(cList1())
                    EndIf
                  Else
                    ClearList(nList())
                    ClearList(cList1())
                  EndIf
                Else
                  ClearList(nList())
                EndIf
              Else
                ClearList(nList())
              EndIf
              
              
            Case "List" ;--List
              DeleteElement(nList())
              ProcedureReturn
              
              
            Case "Fork";--Fork
              DeleteElement(nList())
              ForEach nList()
                If nList()\Flags & #PNB_TYPE_LIST
                  *TPTR = AllocateStructure(nListThread)
                  CopyList(nList()\nList(), *TPTR\nList())
                  CreateThread(@nListEvalThreadFork(), *TPTR)
                  DeleteElement(nList())
                Else
                  DeleteElement(nList())
                EndIf
              Next
              ProcedureReturn
              
              
            Case "Fetch";--Fetch
              DeleteElement(nList())
              ForEach nList()
                If nList()\Flags & #PNB_TYPE_LIST
                  AddElement(cList1())
                  cList1()\p = CreateThread(@nListEvalThread(), @nList())
                Else
                  DeleteElement(nList())
                EndIf
              Next
              ForEach cList1()
                WaitThread(cList1()\p)
                DeleteElement(cList1())
              Next
              ForEach nList()
                If nList()\Flags & #PNB_TYPE_LIST
                  MergeLists(nList()\nList(), nList(), #PB_List_After)
                  DeleteElement(nList())
                EndIf
              Next
              ProcedureReturn
              
              
            Case "Command";--Command
              DeleteElement(nList())
              If NextElement(nList()) 
                If nList()\Flags & #PNB_TYPE_LIST
                  nListEval(nList()\nList())
                  MergeLists(nList()\nList(), nList(), #PB_List_After)
                  DeleteElement(nList())
                  If NextElement(nList())
                    nList()\Flags = #PNB_TYPE_COMMAND | #PNB_TYPE_NAME
                  EndIf
                Else
                  nList()\Flags = #PNB_TYPE_COMMAND | #PNB_TYPE_NAME
                EndIf
              EndIf
              
            Case "Matrix";--Matrix
              DeleteElement(nList())
              
              RINT = 0
              
              While NextElement(nList())
                If nList()\Flags & #PNB_TYPE_NAME
                  If nList()\s = "Do"
                    DeleteElement(nList())
                    If NextElement(nList())
                      If nList()\Flags & #PNB_TYPE_LIST
                        If ListSize(nList()\nList()) > RINT
                          RINT = ListSize(nList()\nList())
                        EndIf
                        
                        ForEach nList()\nList()
                          If nList()\nList()\Flags & #PNB_TYPE_NAME
                            nList()\nList()\Flags | #PNB_TYPE_COMMAND
                          EndIf
                        Next
                        nList()\nList()\Flags | #PNB_TYPE_COMMAND
                      Else
                        nList()\Flags | #PNB_TYPE_COMMAND
                        If RINT = 0
                          RINT = 1
                        EndIf
                      EndIf
                    Else
                      Continue
                    EndIf
                  ElseIf nList()\s = "With"
                    DeleteElement(nList())
                    If NextElement(nList())
                      If nList()\Flags & #PNB_TYPE_LIST
                        If ListSize(nList()\nList()) > RINT
                          RINT = ListSize(nList()\nList())
                        EndIf
                      Else
                        nList()\Flags | #PNB_TYPE_COMMAND
                        If RINT = 0
                          RINT = 1
                        EndIf
                      EndIf
                    Else
                      Continue
                    EndIf
                  Else
                    If RINT = 0
                      RINT = 1
                    EndIf
                  EndIf
                ElseIf nList()\Flags & #PNB_TYPE_LIST ;Evaluate all expressions so we do not get unforeseen consequences.
                  nListEval(nList()\nList())
                  If ListSize(nList()\nList()) > RINT
                    RINT = ListSize(nList()\nList())
                  EndIf
                  If ListSize(nList()\nList()) = 0
                    DeleteElement(nList())
                  EndIf
                Else
                  If RINT = 0
                    RINT = 1
                  EndIf
                EndIf
              Wend
              
              For RCNT = 0 To RINT-1
                AddElement(cList1())
                If RBOL
                  cList1()\Flags | #PNB_TYPE_LIST | #PNB_TYPE_COMMAND
                EndIf
                cList1()\Flags | #PNB_TYPE_LIST
              Next
              
              
              ;iterate over every list entry. use nul if list and other lists are larger.
              ;use last known entry on non-list entries for whole expression.
              
              RCNT = 0
              
              For RCNT = 0 To RINT-1
                ResetList(nList())
                AddElement(cList1())
                cList1()\Flags | #PNB_TYPE_LIST
                
                
                ForEach nList()
                  If nList()\Flags & #PNB_TYPE_LIST
                    If RCNT < ListSize(nList()\nList())
                      SelectElement(nList()\nList(), RCNT)
                      AddElement(cList1()\nList())
                      cList1()\nList() = nList()\nList()
                    EndIf
                  Else
                    AddElement(cList1()\nList())
                    cList1()\nList() = nList()
                  EndIf
                  If nList()\Flags & #PNB_TYPE_COMMAND
                    cList1()\Flags | #PNB_TYPE_COMMAND
                  EndIf
                  
                Next
              Next
              ClearList(nList())
              MergeLists(cList1(), nList(), #PB_List_After)
              
              
          EndSelect
        EndIf
      EndIf
    EndIf
    
    
    ;-List split
    ForEach nList()
      If nList()\Flags & #PNB_TYPE_LIST
        If ListSize(nList()\nList())
          nListEval(nList()\nList())
          MergeLists(nList()\nList(), nList(), #PB_List_After)
          DeleteElement(nList())
        Else
          DeleteElement(nList())
        EndIf
      EndIf
    Next
    
    ;-Command eval
    RCNT = 0
    RBOL = 0
    RINT = 0
    RFLT = 0.0
    RSTR = ""
    
    RTYP = 0
    
    RASC = 0
    RBYT = 0
    RCHR = 0
    RDBL = 0.0
    RLNG = 0
    RQUD = 0
    RWRD = 0
    RUNI = 0
    *RPTR = 0
    
    If FirstElement(nList())
      
      If nList()\Flags & #PNB_TYPE_COMMAND
        CAR = nList()\s
        Select CAR
            ;-Basic Set
            ;-#Basic
            ;---Eval
          Case "Eval", "Evaluate"
            DeleteElement(nList())
            PNB_Eval(nList())
            
            ;---Wait
          Case "Wait"
            DeleteElement(nList())
            PNB_Wait(nList())
            
            ;---Output
          Case "Out", "Output"
            DeleteElement(nList())
            PNB_Out(nList())
            
            ;---Error
          Case "Err", "Error"
            DeleteElement(nList())
            PNB_Err(nList())
            
            ;---Debug
          Case "Dbg", "Debug"
            DeleteElement(nList())
            PNB_Dbg(nList())
            
            
            ;-#List Manipulation
            ;---Fork
            ;Case "Fork" is already implemented in a different format in the preprocessing stage.
            
            ;---Fetch
            ;Case "Fetch" is already implemented in a different format in the preprocessing stage.
            
            ;---Command
            ;Case "Command" is already implemented in a different format in the preprocessing stage.
            
            ;---List
            ;Case "List" is already implemented in a different format in the preprocessing stage.
            
            ;---Element
          Case "Element"
            DeleteElement(nList())
            PNB_Element(nList())
            
            ;---Discard
          Case "Discard"
            DeleteElement(nList())
            PNB_Discard(nList())
            
            ;---Invert
          Case "Invert"
            DeleteElement(nList())
            PNB_Invert(nList())
            
            ;---Size
          Case "Size"
            DeleteElement(nList())
            PNB_Size(nList())
            
            ;---Offset
          Case "Offset"
            DeleteElement(nList())
            PNB_Offset(nList())
            
            
            ;-#Type manipulation
            ;---Split
          Case "Split"
            DeleteElement(nList())
            PNB_Split(nList())
            
            ;---Fuse
          Case "Fuse"
            DeleteElement(nList())
            PNB_Fuse(nList())
            
            ;---Type
          Case "Type"
            DeleteElement(nList())
            PNB_Type(nList())
            
            ;---Name
          Case "Name"
            DeleteElement(nList())
            PNB_Name(nList())
            
            ;---String
          Case "String"
            DeleteElement(nList())
            PNB_String(nList())
            
            ;---Pointer
          Case "Pointer"
            DeleteElement(nList())
            PNB_Pointer(nList())
            
            ;---Double
          Case "Double"
            DeleteElement(nList())
            PNB_Double(nList())
            
            ;---Float
          Case "Float"
            DeleteElement(nList())
            PNB_Float(nList())
            
            ;---Epic
          Case "Epic"
            DeleteElement(nList())
            PNB_Epic(nList())
            
            ;---Integer
          Case "Integer"
            DeleteElement(nList())
            PNB_Integer(nList())
            
            ;---Long
          Case "Long"
            DeleteElement(nList())
            PNB_Long(nList())
            
            ;---Word
          Case "Word"
            DeleteElement(nList())
            PNB_Word(nList())
            
            ;---Byte
          Case "Byte"
            DeleteElement(nList())
            PNB_Byte(nList())
            
            ;---UWord
          Case "UWord"
            DeleteElement(nList())
            PNB_UWord(nList())
            
            ;---Character
          Case "Character"
            DeleteElement(nList())
            PNB_Character(nList())
            
            ;---UByte
          Case "UByte"
            DeleteElement(nList())
            PNB_UByte(nList())
            
            ;---ForceName
          Case "ForceName"
            DeleteElement(nList())
            PNB_ForceName(nList())
            
            ;---ForceString
          Case "ForceString"
            DeleteElement(nList())
            PNB_ForceString(nList())
            
            ;---ForcePointer
          Case "ForcePointer"
            DeleteElement(nList())
            PNB_ForcePointer(nList())
            
            ;---ForceDouble
          Case "ForceDouble"
            DeleteElement(nList())
            PNB_ForceDouble(nList())
            
            ;---ForceFloat
          Case "ForceFloat"
            DeleteElement(nList())
            PNB_ForceFloat(nList())
            
            ;---ForceEpic
          Case "ForceEpic"
            DeleteElement(nList())
            PNB_ForceEpic(nList())
            
            ;---ForceInteger
          Case "ForceInteger"
            DeleteElement(nList())
            PNB_ForceInteger(nList())
            
            ;---ForceLong
          Case "ForceLong"
            DeleteElement(nList())
            PNB_ForceLong(nList())
            
            ;---ForceWord
          Case "ForceWord"
            DeleteElement(nList())
            PNB_ForceWord(nList())
            
            ;---ForceByte
          Case "ForceByte"
            DeleteElement(nList())
            PNB_ForceByte(nList())
            
            ;---ForceUWord
          Case "ForceUWord"
            DeleteElement(nList())
            PNB_ForceUWord(nList())
            
            ;---ForceCharacter
          Case "ForceCharacter"
            DeleteElement(nList())
            PNB_ForceCharacter(nList())
            
            ;---ForceUByte
          Case "ForceUByte"
            DeleteElement(nList())
            PNB_ForceUByte(nList())
            
            
            ;-#Variables
            ;---Set
          Case "Set"
            DeleteElement(nList())
            PNB_Set(nList())
            
            ;---Get
          Case "Get"
            DeleteElement(nList())
            PNB_Get(nList())
            
            ;---Take
          Case "Take"
            DeleteElement(nList())
            PNB_Take(nList())
            
            ;---Remove
          Case "Remove"
            DeleteElement(nList())
            PNB_Remove(nList())
            
            ;---Cycle
          Case "Cycle"
            DeleteElement(nList())
            PNB_Cycle(nList())
            
            ;---Reycle
          Case "Recycle"
            DeleteElement(nList())
            PNB_Recycle(nList())
            
            ;---Bury
          Case "Bury"
            DeleteElement(nList())
            PNB_Bury(nList())
            
            ;---Dig
          Case "Dig"
            DeleteElement(nList())
            PNB_Dig(nList())
            
            ;---Detect
          Case "Detect"
            DeleteElement(nList())
            PNB_Detect(nList())
            
            ;---Push
          Case "Push"
            DeleteElement(nList())
            PNB_Push(nList())
            
            ;---Pop
          Case "Pop"
            DeleteElement(nList())
            PNB_Pop(nList())
            
            ;---Inspect
          Case "Inspect"
            DeleteElement(nList())
            PNB_Inspect(nList())
            
            ;---Reverse
          Case "Reverse"
            DeleteElement(nList())
            PNB_Reverse(nList())
            
            
            ;-#Arithmetic
            ;---Add
          Case "+", "Add"
            DeleteElement(nList())
            PNB_Add(nList())
            
            ;---Sub
          Case "-", "Sub"
            DeleteElement(nList())
            PNB_Sub(nList())
            
            ;---Mul
          Case "*", "Mul"
            DeleteElement(nList())
            PNB_Mul(nList())
            
            ;---Div
          Case "/", "Div"
            DeleteElement(nList())
            PNB_Div(nList())
            
            ;---Pow
          Case "^", "Pow"
            DeleteElement(nList())
            PNB_Pow(nList())
            
            ;---Mod
          Case "%", "Mod"
            DeleteElement(nList())
            PNB_Mod(nList())
            
            ;---Sign
          Case "+-", "-+", "Sign"
            DeleteElement(nList())
            PNB_Sign(nList())
            
            ;---Abs
          Case "_", "Abs"
            DeleteElement(nList())
            PNB_Abs(nList())
            
            ;---ASL
          Case "<<", "ASL"
            DeleteElement(nList())
            PNB_ASL(nList())
            
            ;---ASR
          Case ">>", "ASR"
            DeleteElement(nList())
            PNB_ASR(nList())
            
            ;---Sin
          Case "Sin"
            DeleteElement(nList())
            PNB_Sin(nList())
            
            ;---ASn
          Case "ASn", "ASin"
            DeleteElement(nList())
            PNB_ASin(nList())
            
            ;---Cos
          Case "Cos"
            DeleteElement(nList())
            PNB_Cos(nList())
            
            ;---ACs
          Case "ACs", "ACos"
            DeleteElement(nList())
            PNB_ACos(nList())
            
            ;---Tan
          Case "Tan"
            DeleteElement(nList())
            PNB_Tan(nList())
            
            ;---ATn
          Case "ATn", "ATan"
            DeleteElement(nList())
            PNB_ATan(nList())
            
            ;---RUp
          Case "RUp", "RoundUp"
            DeleteElement(nList())
            PNB_RoundUp(nList())
            
            ;---RDn
          Case "RDn", "RoundDown"
            DeleteElement(nList())
            PNB_RoundDown(nList())
            
            ;---RNr
          Case "RNr", "Round", "RoundNearest"
            DeleteElement(nList())
            PNB_RoundNearest(nList())
            
            ;---Sqr
          Case "Sqr", "Square"
            DeleteElement(nList())
            PNB_Square(nList())
            
            ;---Ran
          Case "Ran", "Rand", "Random"
            DeleteElement(nList())
            PNB_Random(nList())
            
            
            ;-#Logic
            ;---Bool
          Case "Bool"
            DeleteElement(nList())
            PNB_Bool(nList())
            
            ;---Eql
          Case "=", "==", "Eql"
            DeleteElement(nList())
            PNB_Eql(nList())
            
            ;---Neq
          Case "<>", "><", "Neq"
            DeleteElement(nList())
            PNB_Neq(nList())
            
            ;---Lss
          Case "<", "Lss"
            DeleteElement(nList())
            PNB_Lss(nList())
            
            ;---Leq
          Case "<=", "=<", "Leq"
            DeleteElement(nList())
            PNB_Leq(nList())
            
            ;---Gtr
          Case ">", "Gtr"
            DeleteElement(nList())
            PNB_Gtr(nList())
            
            ;---Geq
          Case ">=", "=>", "Geq"
            DeleteElement(nList())
            PNB_Geq(nList())
            
            ;---And
          Case "And", "&"
            DeleteElement(nList())
            PNB_And(nList())
            
            ;---bAnd
          Case "bAnd", "b&"
            DeleteElement(nList())
            PNB_bAnd(nList())
            
            ;---Or
          Case "Or", "|"
            DeleteElement(nList())
            PNB_Or(nList())
            
            ;---bOr
          Case "bOr", "b|"
            DeleteElement(nList())
            PNB_bOr(nList())
            
            ;---XOr
          Case "XOr", "!"
            DeleteElement(nList())
            PNB_XOr(nList())
            
            ;---bXOr
          Case "bXOr", "b!"
            DeleteElement(nList())
            PNB_bXOr(nList())
            
            ;---Not  
          Case "Not", "~"
            DeleteElement(nList())
            PNB_Not(nList())
            
            ;---bNot
          Case "bNot", "b~"
            DeleteElement(nList())
            PNB_bNot(nList())
            
            
            ;-#Memory
            ;---Allocate
          Case "Allocate"
            DeleteElement(nList())
            PNB_Allocate(nList())
            
            ;---Free
          Case "Free"
            DeleteElement(nList())
            PNB_Free(nList())
            
            ;---Assert
          Case "Assert"
            DeleteElement(nList())
            PNB_Assert(nList())
            
            ;---Relinquish
          Case "Relinquish"
            DeleteElement(nList())
            PNB_Relinquish(nList())
            
            ;---Poke
          Case "Poke"
            DeleteElement(nList())
            PNB_Poke(nList())
            
            ;---Peek
          Case "Peek"
            DeleteElement(nList())
            PNB_Peek(nList())
            
            
            ;-#DLL
            ;---Load
          Case "Load"
            DeleteElement(nList())
            PNB_Load(nList())
            
            ;---Release
          Case "Release"
            DeleteElement(nList())
            PNB_Release(nList())
            
            ;---Examine
          Case "Examine"
            DeleteElement(nList())
            PNB_Examine(nList())
            
            ;---Call
          Case "Call"
            DeleteElement(nList())
            PNB_Call(nList())
            
            ;---CallC
          Case "CallC"
            DeleteElement(nList())
            PNB_CallC(nList())
            
            ;---Invoke
          Case "Invoke"
            DeleteElement(nList())
            PNB_Invoke(nList())
            
            ;---InvokeC
          Case "InvokeC"
            DeleteElement(nList())
            PNB_InvokeC(nList())
            
            
            ;-#Functions
          Default
            CompilerIf #PB_Compiler_Thread = 1
              LockMutex(MutexVarMap)
            CompilerEndIf
            If FindMapElement(Lexicon(), CAR)
              DeleteElement(nList())
              If FindMapElement(Param(), CAR)
                ResetList(Param()\nList())
              Else
                ResetMap(Param())
              EndIf
              If FindMapElement(ParamDefault(), CAR)
                ResetList(ParamDefault()\nList())
              Else
                ResetMap(ParamDefault())
              EndIf
              
              If ListSize(Param()\nList())
                If ListSize(ParamDefault()\nList());plus default param
                  If ListSize(nList()) <= ListSize(Param()\nList())
                    AddElement(cList1())
                    cList1() = Lexicon()
                    ForEach ParamDefault()\nList()
                      NextElement(Param()\nList())
                      If NextElement(nList())
                        nListReplace(cList1(), Param()\nList()\s, nList())
                        DeleteElement(nList())
                      Else
                        nListReplace(cList1(), Param()\nList()\s, ParamDefault()\nList())
                      EndIf
                    Next
                    CompilerIf #PB_Compiler_Thread = 1
                      UnlockMutex(MutexVarMap)
                    CompilerEndIf
                    ClearList(nList())
                    nListEval(cList1()\nList())
                    MergeLists(cList1()\nList(), nList(), #PB_List_After)
                  Else
                    CompilerIf #PB_Compiler_Thread = 1
                      UnlockMutex(MutexVarMap)
                    CompilerEndIf
                    ClearList(nList())
                  EndIf
                Else ;param list
                  If ListSize(Param()\nList()) = ListSize(nList())
                    AddElement(cList1())
                    cList1() = Lexicon()
                    ForEach Param()\nList()
                      NextElement(nList())
                      nListReplace(cList1(), Param()\nList()\s, nList())
                      DeleteElement(nList())
                    Next
                    CompilerIf #PB_Compiler_Thread = 1
                      UnlockMutex(MutexVarMap)
                    CompilerEndIf
                    ClearList(nList())
                    nListEval(cList1()\nList())
                    MergeLists(cList1()\nList(), nList(), #PB_List_After)
                  Else
                    CompilerIf #PB_Compiler_Thread = 1
                      UnlockMutex(MutexVarMap)
                    CompilerEndIf
                    ClearList(nList())
                  EndIf
                EndIf
              Else
                AddElement(cList1())
                cList1() = Lexicon()  
                CompilerIf #PB_Compiler_Thread = 1
                  UnlockMutex(MutexVarMap)
                CompilerEndIf
                ClearList(nList())
                nListEval(cList1()\nList())
                MergeLists(cList1()\nList(), nList(), #PB_List_After)
              EndIf
            Else
              CompilerIf #PB_Compiler_Thread = 1
                UnlockMutex(MutexVarMap)
              CompilerEndIf
            EndIf
        EndSelect
      Else
      EndIf
    EndIf
    ProcedureReturn
  EndProcedure
  
  Procedure.s nListEvalString(String.s)
    Protected NewList nList.nList()
    Protected ReturnString.s
    nListPNBTonList(nList(), String)
    nListEval(nList())
    ReturnString = nListPNBToString(nList(), EnableBinary)
    ProcedureReturn ReturnString
  EndProcedure
  
  Procedure.i nListEvalThread(*nList.nListThread)
    nListEval(*nList\nList())
  EndProcedure
  
  Procedure.i nListEvalThreadFork(*nList.nListThread)
    nListEval(*nList\nList())
    ClearStructure(*nList, nListThread)
    FreeMemory(*nList)
  EndProcedure
  
EndModule