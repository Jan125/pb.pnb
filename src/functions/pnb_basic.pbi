Procedure PNB_Eval(List nList.nList())
  Protected NewList cList1.nList()
  Protected NewList cList2.nList()
  
  ForEach nList()
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_STRING
        nListPNBTonList(cList1(), nList()\s)
        DeleteElement(nList())
        nListEval(cList1())
        MergeLists(cList1(), cList2())
        ClearList(cList1())
      Default
        DeleteElement(nList())
    EndSelect
  Next
  MergeLists(cList2(), nList())
  
EndProcedure

Procedure PNB_Wait(List nList.nList())
  ForEach nList()
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_UBYTE
        Delay(nList()\a)
      Case #PNB_TYPE_BYTE
        Delay(nList()\b)
      Case #PNB_TYPE_CHARACTER
        Delay(nList()\c)
      Case #PNB_TYPE_DOUBLE
        Delay(nList()\d)
      Case #PNB_TYPE_FLOAT
        Delay(nList()\f)
      Case #PNB_TYPE_INTEGER
        Delay(nList()\i)
      Case #PNB_TYPE_LONG
        Delay(nList()\l)
      Case #PNB_TYPE_EPIC
        Delay(nList()\q)
      Case #PNB_TYPE_UWORD
        Delay(nList()\u)
      Case #PNB_TYPE_WORD
        Delay(nList()\w)
    EndSelect
    DeleteElement(nList())
  Next
  
EndProcedure

Procedure PNB_Out(List nList.nList())
  Protected RINT.i
  
  ForEach nList()
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_UBYTE
        If GetStdHandle_(#STD_OUTPUT_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), Str(nList()\a)+#CRLF$, Len(Str(nList()\a)+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_BYTE
        If GetStdHandle_(#STD_OUTPUT_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), Str(nList()\b)+#CRLF$, Len(Str(nList()\b)+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_CHARACTER
        If GetStdHandle_(#STD_OUTPUT_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), Str(nList()\c)+#CRLF$, Len(Str(nList()\c)+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_DOUBLE
        If GetStdHandle_(#STD_OUTPUT_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), StrD(nList()\d, 19)+#CRLF$, Len(StrD(nList()\d, 19)+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_FLOAT
        If GetStdHandle_(#STD_OUTPUT_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), StrF(nList()\f, 14)+#CRLF$, Len(StrF(nList()\f, 14)+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_INTEGER
        If GetStdHandle_(#STD_OUTPUT_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), Str(nList()\i)+#CRLF$, Len(Str(nList()\i)+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_LONG
        If GetStdHandle_(#STD_OUTPUT_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), Str(nList()\l)+#CRLF$, Len(Str(nList()\l)+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_NAME
        If GetStdHandle_(#STD_OUTPUT_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), nList()\s+#CRLF$, Len(nList()\s+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_POINTER
        If GetStdHandle_(#STD_OUTPUT_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), Str(nList()\p)+#CRLF$, Len(Str(nList()\p)+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_EPIC
        If GetStdHandle_(#STD_OUTPUT_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), Str(nList()\q)+#CRLF$, Len(Str(nList()\q)+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_STRING
        If GetStdHandle_(#STD_OUTPUT_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), nList()\s+#CRLF$, Len(nList()\s+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_UWORD
        If GetStdHandle_(#STD_OUTPUT_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), Str(nList()\u)+#CRLF$, Len(Str(nList()\u)+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_WORD
        If GetStdHandle_(#STD_OUTPUT_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_OUTPUT_HANDLE), Str(nList()\w)+#CRLF$, Len(Str(nList()\w)+#CRLF$), @RINT, 0)
        EndIf
    EndSelect
    DeleteElement(nList())
  Next
  
EndProcedure

Procedure PNB_Err(List nList.nList())
  Protected RINT.i
  Protected ColorF.i
  Protected ColorB.i
  Protected lpConsoleScreenBufferInfo.CONSOLE_SCREEN_BUFFER_INFO
  
  GetConsoleScreenBufferInfo_(GetStdHandle_(#STD_ERROR_HANDLE), @lpConsoleScreenBufferInfo)
  SetConsoleTextAttribute_(GetStdHandle_(#STD_ERROR_HANDLE), #FOREGROUND_RED|#FOREGROUND_INTENSITY)
  
  ForEach nList()
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_UBYTE
        If GetStdHandle_(#STD_ERROR_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), Str(nList()\a)+#CRLF$, Len(Str(nList()\a)+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_BYTE
        If GetStdHandle_(#STD_ERROR_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), Str(nList()\b)+#CRLF$, Len(Str(nList()\b)+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_CHARACTER
        If GetStdHandle_(#STD_ERROR_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), Str(nList()\c)+#CRLF$, Len(Str(nList()\c)+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_DOUBLE
        If GetStdHandle_(#STD_ERROR_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), StrD(nList()\d, 19)+#CRLF$, Len(StrD(nList()\d, 19)+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_FLOAT
        If GetStdHandle_(#STD_ERROR_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), StrF(nList()\f, 14)+#CRLF$, Len(StrF(nList()\f, 14)+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_INTEGER
        If GetStdHandle_(#STD_ERROR_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), Str(nList()\i)+#CRLF$, Len(Str(nList()\i)+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_LONG
        If GetStdHandle_(#STD_ERROR_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), Str(nList()\l)+#CRLF$, Len(Str(nList()\l)+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_NAME
        If GetStdHandle_(#STD_ERROR_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), nList()\s+#CRLF$, Len(nList()\s+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_POINTER
        If GetStdHandle_(#STD_ERROR_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), Str(nList()\p)+#CRLF$, Len(Str(nList()\p)+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_EPIC
        If GetStdHandle_(#STD_ERROR_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), Str(nList()\q)+#CRLF$, Len(Str(nList()\q)+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_STRING
        If GetStdHandle_(#STD_ERROR_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), nList()\s+#CRLF$, Len(nList()\s+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_UWORD
        If GetStdHandle_(#STD_ERROR_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), Str(nList()\u)+#CRLF$, Len(Str(nList()\u)+#CRLF$), @RINT, 0)
        EndIf
      Case #PNB_TYPE_WORD
        If GetStdHandle_(#STD_ERROR_HANDLE)
          WriteConsole_(GetStdHandle_(#STD_ERROR_HANDLE), Str(nList()\w)+#CRLF$, Len(Str(nList()\w)+#CRLF$), @RINT, 0)
        EndIf
    EndSelect
    DeleteElement(nList())
  Next
  
  SetConsoleTextAttribute_(GetStdHandle_(#STD_ERROR_HANDLE), lpConsoleScreenBufferInfo\wAttributes)
  
EndProcedure

Procedure PNB_Dbg(List nList.nList())
  Protected RINT.i
  ForEach nList()
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_UBYTE
        CompilerIf #PB_Compiler_Debugger
          Debug nList()\a
        CompilerEndIf
      Case #PNB_TYPE_BYTE
        CompilerIf #PB_Compiler_Debugger
          Debug nList()\b
        CompilerEndIf
      Case #PNB_TYPE_CHARACTER
        CompilerIf #PB_Compiler_Debugger
          Debug nList()\c
        CompilerEndIf
      Case #PNB_TYPE_DOUBLE
        CompilerIf #PB_Compiler_Debugger
          Debug nList()\d
        CompilerEndIf
      Case #PNB_TYPE_FLOAT
        CompilerIf #PB_Compiler_Debugger
          Debug nList()\f
        CompilerEndIf
      Case #PNB_TYPE_INTEGER
        CompilerIf #PB_Compiler_Debugger
          Debug nList()\i
        CompilerEndIf
      Case #PNB_TYPE_LONG
        CompilerIf #PB_Compiler_Debugger
          Debug nList()\l
        CompilerEndIf
      Case #PNB_TYPE_NAME
        CompilerIf #PB_Compiler_Debugger
          Debug nList()\s
        CompilerEndIf
      Case #PNB_TYPE_POINTER
        CompilerIf #PB_Compiler_Debugger
          Debug nList()\p
        CompilerEndIf
      Case #PNB_TYPE_EPIC
        CompilerIf #PB_Compiler_Debugger
          Debug nList()\q
        CompilerEndIf
      Case #PNB_TYPE_STRING
        CompilerIf #PB_Compiler_Debugger
          Debug nList()\s
        CompilerEndIf
      Case #PNB_TYPE_UWORD
        CompilerIf #PB_Compiler_Debugger
          Debug nList()\u
        CompilerEndIf
      Case #PNB_TYPE_WORD
        CompilerIf #PB_Compiler_Debugger
          Debug nList()\w
        CompilerEndIf
    EndSelect
    DeleteElement(nList())
  Next
  
EndProcedure
