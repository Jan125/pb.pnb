Procedure PNB_Load(List nList.nList())
  Protected RINT.i
  
  Protected NewList cList1.nList()
  ForEach nList()
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_NAME, #PNB_TYPE_STRING
        RINT = OpenLibrary(#PB_Any, nList()\s)
        DeleteElement(nList())
        If RINT
          AddElement(cList1())
          cList1()\i = RINT
          cList1()\Flags | #PNB_TYPE_INTEGER
        EndIf
      Default
        DeleteElement(nList())
    EndSelect
  Next
  MergeLists(cList1(), nList())
  
EndProcedure

Procedure PNB_Release(List nList.nList())
  ForEach nList()
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_POINTER
        CloseLibrary(nList()\p)
      Case #PNB_TYPE_EPIC
        CloseLibrary(nList()\q)
      Case #PNB_TYPE_INTEGER
        CloseLibrary(nList()\i)
      Case #PNB_TYPE_LONG
        CloseLibrary(nList()\l)
      Case #PNB_TYPE_WORD
        CloseLibrary(nList()\w)
      Case #PNB_TYPE_UWORD
        CloseLibrary(nList()\u)
      Case #PNB_TYPE_CHARACTER
        CloseLibrary(nList()\c)
      Case #PNB_TYPE_BYTE
        CloseLibrary(nList()\b)
      Case #PNB_TYPE_UBYTE
        CloseLibrary(nList()\a)
    EndSelect
    DeleteElement(nList())
  Next
  
EndProcedure


Procedure PNB_Examine(List nList.nList())
  Protected RINT.i
  
  Protected NewList cList1.nList()
  If NextElement(nList())
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_POINTER
        RINT = nList()\p
        DeleteElement(nList())
      Case #PNB_TYPE_EPIC
        RINT = nList()\q
        DeleteElement(nList())
      Case #PNB_TYPE_INTEGER
        RINT = nList()\i
        DeleteElement(nList())
      Case #PNB_TYPE_LONG
        RINT = nList()\l
        DeleteElement(nList())
      Case #PNB_TYPE_WORD
        RINT = nList()\w
        DeleteElement(nList())
      Case #PNB_TYPE_UWORD
        RINT = nList()\u
        DeleteElement(nList())
      Case #PNB_TYPE_CHARACTER
        RINT = nList()\c
        DeleteElement(nList())
      Case #PNB_TYPE_BYTE
        RINT = nList()\b
        DeleteElement(nList())
      Case #PNB_TYPE_UBYTE
        RINT = nList()\a
        DeleteElement(nList())
      Default
        ClearList(nList())
    EndSelect
    
    ForEach nList()
      Select nListGetHighestType(nList()\Flags)
        Case #PNB_TYPE_NAME, #PNB_TYPE_STRING
          AddElement(cList1())
          cList1()\i = GetFunction(RINT, nList()\s)
          cList1()\Flags | #PNB_TYPE_INTEGER
      EndSelect
      DeleteElement(nList())
    Next
  Else
    ClearList(nList())
  EndIf
  MergeLists(cList1(), nList())
  
EndProcedure

Procedure PNB_Call(List nList.nList())
  Protected ParameterLength.l
  
  Protected Dim *Parameter(19)
  
  Protected NewList *PointerList()
  
  Protected BitStoreShort.l
  Protected BitStoreLong.q
  Protected Library.i
  Protected FunctionName.s
  
  If NextElement(nList())
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_NAME, #PNB_TYPE_STRING
        Select nList()\s
          Case "None"
            FunctionType = #PNB_TYPE_NONE
          Case "Name"
            FunctionType = #PNB_TYPE_NAME
          Case "String"
            FunctionType = #PNB_TYPE_STRING
          Case "Pointer"
            FunctionType = #PNB_TYPE_POINTER
          Case "Double"
            FunctionType = #PNB_TYPE_DOUBLE
          Case "Float"
            FunctionType = #PNB_TYPE_FLOAT
          Case "Epic"
            FunctionType = #PNB_TYPE_EPIC
          Case "Integer"
            FunctionType = #PNB_TYPE_INTEGER
          Case "Long"
            FunctionType = #PNB_TYPE_LONG
          Case "Word"
            FunctionType = #PNB_TYPE_WORD
          Case "Byte"
            FunctionType = #PNB_TYPE_BYTE
          Case "UWord"
            FunctionType = #PNB_TYPE_UWORD
          Case "Character"
            FunctionType = #PNB_TYPE_CHARACTER
          Case "UByte"
            FunctionType = #PNB_TYPE_UBYTE
        EndSelect
        DeleteElement(nList())
      Default
        ClearList(nList())
        ProcedureReturn
    EndSelect
  Else
    ClearList(nList())
    ProcedureReturn
  EndIf
  If NextElement(nList())
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_POINTER
        Library = nList()\p
        DeleteElement(nList())
      Case #PNB_TYPE_EPIC
        Library = nList()\q
        DeleteElement(nList())
      Case #PNB_TYPE_INTEGER
        Library = nList()\i
        DeleteElement(nList())
      Case #PNB_TYPE_LONG
        Library = nList()\l
        DeleteElement(nList())
      Case #PNB_TYPE_WORD
        Library = nList()\w
        DeleteElement(nList())
      Case #PNB_TYPE_UWORD
        Library = nList()\u
        DeleteElement(nList())
      Case #PNB_TYPE_CHARACTER
        Library = nList()\c
        DeleteElement(nList())
      Case #PNB_TYPE_BYTE
        Library = nList()\b
        DeleteElement(nList())
      Case #PNB_TYPE_UBYTE
        Library = nList()\a
        DeleteElement(nList())
      Default
        ClearList(nList())
        ProcedureReturn
    EndSelect
  Else
    ClearList(nList())
    ProcedureReturn
  EndIf
  
  If NextElement(nList())
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_NAME, #PNB_TYPE_STRING
        FunctionName = nList()\s
        DeleteElement(nList())
      Default
        ClearList(nList())
    EndSelect
  Else
    ClearList(nList())
    ProcedureReturn
  EndIf
  
  ForEach nList()
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_NAME
        AddElement(*PointerList())
        *PointerList() = AllocateMemory(StringByteLength(nList()\s)+SizeOf(Character))
        PokeS(*PointerList(), nList()\s)
        *Parameter(ParameterLength) = *PointerList()
        ParameterLength + 1
      Case #PNB_TYPE_STRING
        AddElement(*PointerList())
        *PointerList() = AllocateMemory(StringByteLength(nList()\s)+SizeOf(Character))
        PokeS(*PointerList(), nList()\s)
        *Parameter(ParameterLength) = *PointerList()
        ParameterLength + 1
      Case #PNB_TYPE_POINTER
        *Parameter(ParameterLength) = nList()\p
        ParameterLength + 1
      Case #PNB_TYPE_DOUBLE
        CompilerSelect #PB_Compiler_Processor
          CompilerCase #PB_Processor_x64
            *Parameter(ParameterLength) = PeekQ(@nList()\d)
            ParameterLength + 1
          CompilerCase #PB_Processor_x86
            *Parameter(ParameterLength) = PeekL(@nList()\d)
            *Parameter(ParameterLength+1) = PeekL(@nList()\d+4)
            ParameterLength + 2
        CompilerEndSelect
      Case #PNB_TYPE_FLOAT
        ParameterLength + 1
      Case #PNB_TYPE_EPIC
        CompilerSelect #PB_Compiler_Processor
          CompilerCase #PB_Processor_x64
            *Parameter(ParameterLength) = nList()\q
            ParameterLength + 1
          CompilerCase #PB_Processor_x86
            *Parameter(ParameterLength) = PeekL(@nList()\q)
            *Parameter(ParameterLength+1) = PeekL(@nList()\q+4)
            ParameterLength + 2
        CompilerEndSelect
      Case #PNB_TYPE_INTEGER
        *Parameter(ParameterLength) = nList()\i
        ParameterLength + 1
      Case #PNB_TYPE_LONG
        *Parameter(ParameterLength) = nList()\l
        ParameterLength + 1
      Case #PNB_TYPE_WORD
        *Parameter(ParameterLength) = nList()\w
        ParameterLength + 1
      Case #PNB_TYPE_BYTE
        *Parameter(ParameterLength) = nList()\b
        ParameterLength + 1
      Case #PNB_TYPE_UWORD
        *Parameter(ParameterLength) = nList()\u
        ParameterLength + 1
      Case #PNB_TYPE_CHARACTER
        *Parameter(ParameterLength) = nList()\c
        ParameterLength + 1
      Case #PNB_TYPE_UBYTE
        *Parameter(ParameterLength) = nList()\a
        ParameterLength + 1
    EndSelect
    DeleteElement(nList())
  Next
  
  If ParameterLength > 20
    ClearList(nList())
    ForEach *PointerList()
      FreeMemory(*PointerList())
      DeleteElement(*PointerList())
    Next
    ProcedureReturn
  EndIf
  
  Select ParameterLength
    Case 0
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName)
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName)
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName)
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName)
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName)
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName)
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName)
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName)
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName)
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName)
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName)
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName)
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 1
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName, *Parameter(0))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName, *Parameter(0))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName, *Parameter(0))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName, *Parameter(0))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName, *Parameter(0))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName, *Parameter(0))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName, *Parameter(0))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName, *Parameter(0))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName, *Parameter(0))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 2
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 3
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 4
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 5
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 6
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 7
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 8
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 9
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 10
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 11
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 12
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 13
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 14
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 15
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 16
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 17
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 18
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 19
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 20
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
  EndSelect
  
  ForEach *PointerList()
    FreeMemory(*PointerList())
    DeleteElement(*PointerList())
  Next
  
EndProcedure
Procedure PNB_CallC(List nList.nList())
  Protected ParameterLength.l
  
  Protected Dim *Parameter(19)
  
  Protected NewList *PointerList()
  
  Protected BitStoreShort.l
  Protected BitStoreLong.q
  Protected Library.i
  Protected FunctionName.s
  
  If NextElement(nList())
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_NAME, #PNB_TYPE_STRING
        Select nList()\s
          Case "None"
            FunctionType = #PNB_TYPE_NONE
          Case "Name"
            FunctionType = #PNB_TYPE_NAME
          Case "String"
            FunctionType = #PNB_TYPE_STRING
          Case "Pointer"
            FunctionType = #PNB_TYPE_POINTER
          Case "Double"
            FunctionType = #PNB_TYPE_DOUBLE
          Case "Float"
            FunctionType = #PNB_TYPE_FLOAT
          Case "Epic"
            FunctionType = #PNB_TYPE_EPIC
          Case "Integer"
            FunctionType = #PNB_TYPE_INTEGER
          Case "Long"
            FunctionType = #PNB_TYPE_LONG
          Case "Word"
            FunctionType = #PNB_TYPE_WORD
          Case "Byte"
            FunctionType = #PNB_TYPE_BYTE
          Case "UWord"
            FunctionType = #PNB_TYPE_UWORD
          Case "Character"
            FunctionType = #PNB_TYPE_CHARACTER
          Case "UByte"
            FunctionType = #PNB_TYPE_UBYTE
        EndSelect
        DeleteElement(nList())
      Default
        ClearList(nList())
        ProcedureReturn
    EndSelect
  Else
    ClearList(nList())
    ProcedureReturn
  EndIf
  If NextElement(nList())
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_POINTER
        Library = nList()\p
        DeleteElement(nList())
      Case #PNB_TYPE_EPIC
        Library = nList()\q
        DeleteElement(nList())
      Case #PNB_TYPE_INTEGER
        Library = nList()\i
        DeleteElement(nList())
      Case #PNB_TYPE_LONG
        Library = nList()\l
        DeleteElement(nList())
      Case #PNB_TYPE_WORD
        Library = nList()\w
        DeleteElement(nList())
      Case #PNB_TYPE_UWORD
        Library = nList()\u
        DeleteElement(nList())
      Case #PNB_TYPE_CHARACTER
        Library = nList()\c
        DeleteElement(nList())
      Case #PNB_TYPE_BYTE
        Library = nList()\b
        DeleteElement(nList())
      Case #PNB_TYPE_UBYTE
        Library = nList()\a
        DeleteElement(nList())
      Default
        ClearList(nList())
        ProcedureReturn
    EndSelect
  Else
    ClearList(nList())
    ProcedureReturn
  EndIf
  
  If NextElement(nList())
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_NAME, #PNB_TYPE_STRING
        FunctionName = nList()\s
        DeleteElement(nList())
      Default
        ClearList(nList())
    EndSelect
  Else
    ClearList(nList())
    ProcedureReturn
  EndIf
  
  ForEach nList()
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_NAME
        AddElement(*PointerList())
        *PointerList() = AllocateMemory(StringByteLength(nList()\s)+SizeOf(Character))
        PokeS(*PointerList(), nList()\s)
        *Parameter(ParameterLength) = *PointerList()
        ParameterLength + 1
      Case #PNB_TYPE_STRING
        AddElement(*PointerList())
        *PointerList() = AllocateMemory(StringByteLength(nList()\s)+SizeOf(Character))
        PokeS(*PointerList(), nList()\s)
        *Parameter(ParameterLength) = *PointerList()
        ParameterLength + 1
      Case #PNB_TYPE_POINTER
        *Parameter(ParameterLength) = nList()\p
        ParameterLength + 1
      Case #PNB_TYPE_DOUBLE
        CompilerSelect #PB_Compiler_Processor
          CompilerCase #PB_Processor_x64
            *Parameter(ParameterLength) = PeekQ(@nList()\d)
            ParameterLength + 1
          CompilerCase #PB_Processor_x86
            *Parameter(ParameterLength) = PeekL(@nList()\d)
            *Parameter(ParameterLength+1) = PeekL(@nList()\d+4)
            ParameterLength + 2
        CompilerEndSelect
      Case #PNB_TYPE_FLOAT
        ParameterLength + 1
      Case #PNB_TYPE_EPIC
        CompilerSelect #PB_Compiler_Processor
          CompilerCase #PB_Processor_x64
            *Parameter(ParameterLength) = nList()\q
            ParameterLength + 1
          CompilerCase #PB_Processor_x86
            *Parameter(ParameterLength) = PeekL(@nList()\q)
            *Parameter(ParameterLength+1) = PeekL(@nList()\q+4)
            ParameterLength + 2
        CompilerEndSelect
      Case #PNB_TYPE_INTEGER
        *Parameter(ParameterLength) = nList()\i
        ParameterLength + 1
      Case #PNB_TYPE_LONG
        *Parameter(ParameterLength) = nList()\l
        ParameterLength + 1
      Case #PNB_TYPE_WORD
        *Parameter(ParameterLength) = nList()\w
        ParameterLength + 1
      Case #PNB_TYPE_BYTE
        *Parameter(ParameterLength) = nList()\b
        ParameterLength + 1
      Case #PNB_TYPE_UWORD
        *Parameter(ParameterLength) = nList()\u
        ParameterLength + 1
      Case #PNB_TYPE_CHARACTER
        *Parameter(ParameterLength) = nList()\c
        ParameterLength + 1
      Case #PNB_TYPE_UBYTE
        *Parameter(ParameterLength) = nList()\a
        ParameterLength + 1
    EndSelect
    DeleteElement(nList())
  Next
  
  If ParameterLength > 20
    ClearList(nList())
    ForEach *PointerList()
      FreeMemory(*PointerList())
      DeleteElement(*PointerList())
    Next
    ProcedureReturn
  EndIf
  
  Select ParameterLength
    Case 0
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName)
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName)
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName)
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName)
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName)
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName)
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName)
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName)
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName)
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName)
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName)
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName)
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 1
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName, *Parameter(0))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName, *Parameter(0))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName, *Parameter(0))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName, *Parameter(0))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName, *Parameter(0))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName, *Parameter(0))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName, *Parameter(0))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName, *Parameter(0))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName, *Parameter(0))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 2
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 3
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 4
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 5
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 6
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 7
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 8
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 9
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 10
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 11
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 12
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 13
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 14
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 15
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 16
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 17
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 18
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 19
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 20
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunction(Library, FunctionName, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
  EndSelect
  
  ForEach *PointerList()
    FreeMemory(*PointerList())
    DeleteElement(*PointerList())
  Next
  
EndProcedure
Procedure PNB_Invoke(List nList.nList())
  Protected ParameterLength.l
  
  Protected Dim *Parameter(19)
  
  Protected NewList *PointerList()
  
  Protected BitStoreShort.l
  Protected BitStoreLong.q
  Protected *FunctionAddress
  
  If NextElement(nList())
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_NAME, #PNB_TYPE_STRING
        Select nList()\s
          Case "None"
            FunctionType = #PNB_TYPE_NONE
          Case "Name"
            FunctionType = #PNB_TYPE_NAME
          Case "String"
            FunctionType = #PNB_TYPE_STRING
          Case "Pointer"
            FunctionType = #PNB_TYPE_POINTER
          Case "Double"
            FunctionType = #PNB_TYPE_DOUBLE
          Case "Float"
            FunctionType = #PNB_TYPE_FLOAT
          Case "Epic"
            FunctionType = #PNB_TYPE_EPIC
          Case "Integer"
            FunctionType = #PNB_TYPE_INTEGER
          Case "Long"
            FunctionType = #PNB_TYPE_LONG
          Case "Word"
            FunctionType = #PNB_TYPE_WORD
          Case "Byte"
            FunctionType = #PNB_TYPE_BYTE
          Case "UWord"
            FunctionType = #PNB_TYPE_UWORD
          Case "Character"
            FunctionType = #PNB_TYPE_CHARACTER
          Case "UByte"
            FunctionType = #PNB_TYPE_UBYTE
        EndSelect
        DeleteElement(nList())
      Default
        ClearList(nList())
        ProcedureReturn
    EndSelect
  Else
    ClearList(nList())
    ProcedureReturn
  EndIf
  If NextElement(nList())
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_POINTER
        *FunctionAddress = nList()\p
        DeleteElement(nList())
      Case #PNB_TYPE_EPIC
        *FunctionAddress = nList()\q
        DeleteElement(nList())
      Case #PNB_TYPE_INTEGER
        *FunctionAddress = nList()\i
        DeleteElement(nList())
      Case #PNB_TYPE_LONG
        *FunctionAddress = nList()\l
        DeleteElement(nList())
      Case #PNB_TYPE_WORD
        *FunctionAddress = nList()\w
        DeleteElement(nList())
      Case #PNB_TYPE_UWORD
        *FunctionAddress = nList()\u
        DeleteElement(nList())
      Case #PNB_TYPE_CHARACTER
        *FunctionAddress = nList()\c
        DeleteElement(nList())
      Case #PNB_TYPE_BYTE
        *FunctionAddress = nList()\b
        DeleteElement(nList())
      Case #PNB_TYPE_UBYTE
        *FunctionAddress = nList()\a
        DeleteElement(nList())
      Default
        ClearList(nList())
        ProcedureReturn
    EndSelect
  Else
    ClearList(nList())
    ProcedureReturn
  EndIf
  ForEach nList()
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_NAME
        AddElement(*PointerList())
        *PointerList() = AllocateMemory(StringByteLength(nList()\s)+SizeOf(Character))
        PokeS(*PointerList(), nList()\s)
        *Parameter(ParameterLength) = *PointerList()
        ParameterLength + 1
      Case #PNB_TYPE_STRING
        AddElement(*PointerList())
        *PointerList() = AllocateMemory(StringByteLength(nList()\s)+SizeOf(Character))
        PokeS(*PointerList(), nList()\s)
        *Parameter(ParameterLength) = *PointerList()
        ParameterLength + 1
      Case #PNB_TYPE_POINTER
        *Parameter(ParameterLength) = nList()\p
        ParameterLength + 1
      Case #PNB_TYPE_DOUBLE
        CompilerSelect #PB_Compiler_Processor
          CompilerCase #PB_Processor_x64
            *Parameter(ParameterLength) = PeekQ(@nList()\d)
            ParameterLength + 1
          CompilerCase #PB_Processor_x86
            *Parameter(ParameterLength) = PeekL(@nList()\d)
            *Parameter(ParameterLength+1) = PeekL(@nList()\d+4)
            ParameterLength + 2
        CompilerEndSelect
      Case #PNB_TYPE_FLOAT
        ParameterLength + 1
      Case #PNB_TYPE_EPIC
        CompilerSelect #PB_Compiler_Processor
          CompilerCase #PB_Processor_x64
            *Parameter(ParameterLength) = nList()\q
            ParameterLength + 1
          CompilerCase #PB_Processor_x86
            *Parameter(ParameterLength) = PeekL(@nList()\q)
            *Parameter(ParameterLength+1) = PeekL(@nList()\q+4)
            ParameterLength + 2
        CompilerEndSelect
      Case #PNB_TYPE_INTEGER
        *Parameter(ParameterLength) = nList()\i
        ParameterLength + 1
      Case #PNB_TYPE_LONG
        *Parameter(ParameterLength) = nList()\l
        ParameterLength + 1
      Case #PNB_TYPE_WORD
        *Parameter(ParameterLength) = nList()\w
        ParameterLength + 1
      Case #PNB_TYPE_BYTE
        *Parameter(ParameterLength) = nList()\b
        ParameterLength + 1
      Case #PNB_TYPE_UWORD
        *Parameter(ParameterLength) = nList()\u
        ParameterLength + 1
      Case #PNB_TYPE_CHARACTER
        *Parameter(ParameterLength) = nList()\c
        ParameterLength + 1
      Case #PNB_TYPE_UBYTE
        *Parameter(ParameterLength) = nList()\a
        ParameterLength + 1
    EndSelect
    DeleteElement(nList())
  Next
  
  If ParameterLength > 20
    ClearList(nList())
    ForEach *PointerList()
      FreeMemory(*PointerList())
      DeleteElement(*PointerList())
    Next
    ProcedureReturn
  EndIf
  
  Select ParameterLength
    Case 0
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress)
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress)
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress)
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress)
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress)
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress)
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress)
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress)
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress)
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress)
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress)
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress)
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 1
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress, *Parameter(0))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress, *Parameter(0))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress, *Parameter(0))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress, *Parameter(0))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress, *Parameter(0))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress, *Parameter(0))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress, *Parameter(0))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress, *Parameter(0))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress, *Parameter(0))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 2
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 3
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 4
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 5
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 6
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 7
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 8
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 9
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 10
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 11
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 12
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 13
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 14
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 15
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 16
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 17
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 18
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 19
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 20
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
  EndSelect
  
  ForEach *PointerList()
    FreeMemory(*PointerList())
    DeleteElement(*PointerList())
  Next
  
EndProcedure
Procedure PNB_InvokeC(List nList.nList())
  Protected ParameterLength.l
  
  Protected Dim *Parameter(19)
  
  Protected NewList *PointerList()
  
  Protected BitStoreShort.l
  Protected BitStoreLong.q
  Protected *FunctionAddress
  
  If NextElement(nList())
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_NAME, #PNB_TYPE_STRING
        Select nList()\s
          Case "None"
            FunctionType = #PNB_TYPE_NONE
          Case "Name"
            FunctionType = #PNB_TYPE_NAME
          Case "String"
            FunctionType = #PNB_TYPE_STRING
          Case "Pointer"
            FunctionType = #PNB_TYPE_POINTER
          Case "Double"
            FunctionType = #PNB_TYPE_DOUBLE
          Case "Float"
            FunctionType = #PNB_TYPE_FLOAT
          Case "Epic"
            FunctionType = #PNB_TYPE_EPIC
          Case "Integer"
            FunctionType = #PNB_TYPE_INTEGER
          Case "Long"
            FunctionType = #PNB_TYPE_LONG
          Case "Word"
            FunctionType = #PNB_TYPE_WORD
          Case "Byte"
            FunctionType = #PNB_TYPE_BYTE
          Case "UWord"
            FunctionType = #PNB_TYPE_UWORD
          Case "Character"
            FunctionType = #PNB_TYPE_CHARACTER
          Case "UByte"
            FunctionType = #PNB_TYPE_UBYTE
        EndSelect
        DeleteElement(nList())
      Default
        ClearList(nList())
        ProcedureReturn
    EndSelect
  Else
    ClearList(nList())
    ProcedureReturn
  EndIf
  If NextElement(nList())
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_POINTER
        *FunctionAddress = nList()\p
        DeleteElement(nList())
      Case #PNB_TYPE_EPIC
        *FunctionAddress = nList()\q
        DeleteElement(nList())
      Case #PNB_TYPE_INTEGER
        *FunctionAddress = nList()\i
        DeleteElement(nList())
      Case #PNB_TYPE_LONG
        *FunctionAddress = nList()\l
        DeleteElement(nList())
      Case #PNB_TYPE_WORD
        *FunctionAddress = nList()\w
        DeleteElement(nList())
      Case #PNB_TYPE_UWORD
        *FunctionAddress = nList()\u
        DeleteElement(nList())
      Case #PNB_TYPE_CHARACTER
        *FunctionAddress = nList()\c
        DeleteElement(nList())
      Case #PNB_TYPE_BYTE
        *FunctionAddress = nList()\b
        DeleteElement(nList())
      Case #PNB_TYPE_UBYTE
        *FunctionAddress = nList()\a
        DeleteElement(nList())
      Default
        ClearList(nList())
        ProcedureReturn
    EndSelect
  Else
    ClearList(nList())
    ProcedureReturn
  EndIf
  ForEach nList()
    Select nListGetHighestType(nList()\Flags)
      Case #PNB_TYPE_NAME
        AddElement(*PointerList())
        *PointerList() = AllocateMemory(StringByteLength(nList()\s)+SizeOf(Character))
        PokeS(*PointerList(), nList()\s)
        *Parameter(ParameterLength) = *PointerList()
        ParameterLength + 1
      Case #PNB_TYPE_STRING
        AddElement(*PointerList())
        *PointerList() = AllocateMemory(StringByteLength(nList()\s)+SizeOf(Character))
        PokeS(*PointerList(), nList()\s)
        *Parameter(ParameterLength) = *PointerList()
        ParameterLength + 1
      Case #PNB_TYPE_POINTER
        *Parameter(ParameterLength) = nList()\p
        ParameterLength + 1
      Case #PNB_TYPE_DOUBLE
        CompilerSelect #PB_Compiler_Processor
          CompilerCase #PB_Processor_x64
            *Parameter(ParameterLength) = PeekQ(@nList()\d)
            ParameterLength + 1
          CompilerCase #PB_Processor_x86
            *Parameter(ParameterLength) = PeekL(@nList()\d)
            *Parameter(ParameterLength+1) = PeekL(@nList()\d+4)
            ParameterLength + 2
        CompilerEndSelect
      Case #PNB_TYPE_FLOAT
        ParameterLength + 1
      Case #PNB_TYPE_EPIC
        CompilerSelect #PB_Compiler_Processor
          CompilerCase #PB_Processor_x64
            *Parameter(ParameterLength) = nList()\q
            ParameterLength + 1
          CompilerCase #PB_Processor_x86
            *Parameter(ParameterLength) = PeekL(@nList()\q)
            *Parameter(ParameterLength+1) = PeekL(@nList()\q+4)
            ParameterLength + 2
        CompilerEndSelect
      Case #PNB_TYPE_INTEGER
        *Parameter(ParameterLength) = nList()\i
        ParameterLength + 1
      Case #PNB_TYPE_LONG
        *Parameter(ParameterLength) = nList()\l
        ParameterLength + 1
      Case #PNB_TYPE_WORD
        *Parameter(ParameterLength) = nList()\w
        ParameterLength + 1
      Case #PNB_TYPE_BYTE
        *Parameter(ParameterLength) = nList()\b
        ParameterLength + 1
      Case #PNB_TYPE_UWORD
        *Parameter(ParameterLength) = nList()\u
        ParameterLength + 1
      Case #PNB_TYPE_CHARACTER
        *Parameter(ParameterLength) = nList()\c
        ParameterLength + 1
      Case #PNB_TYPE_UBYTE
        *Parameter(ParameterLength) = nList()\a
        ParameterLength + 1
    EndSelect
    DeleteElement(nList())
  Next
  
  If ParameterLength > 20
    ClearList(nList())
    ForEach *PointerList()
      FreeMemory(*PointerList())
      DeleteElement(*PointerList())
    Next
    ProcedureReturn
  EndIf
  
  Select ParameterLength
    Case 0
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress)
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress)
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress)
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress)
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress)
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress)
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress)
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress)
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress)
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress)
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress)
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress)
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 1
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress, *Parameter(0))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress, *Parameter(0))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress, *Parameter(0))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress, *Parameter(0))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress, *Parameter(0))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress, *Parameter(0))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress, *Parameter(0))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress, *Parameter(0))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress, *Parameter(0))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 2
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 3
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 4
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 5
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 6
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 7
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 8
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 9
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 10
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 11
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 12
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 13
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 14
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 15
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 16
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 17
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 18
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 19
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
    Case 20
      Select FunctionType
        Case #PNB_TYPE_NONE
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          
        Case #PNB_TYPE_NAME
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19)))
          nList()\Flags | #PNB_TYPE_NAME
          
        Case #PNB_TYPE_STRING
          AddElement(nList())
          nList()\s = PeekS(CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19)))
          nList()\Flags | #PNB_TYPE_STRING
          
        Case #PNB_TYPE_POINTER
          AddElement(nList())
          nList()\p = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_POINTER
          
        Case #PNB_TYPE_DOUBLE
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          !fstp qword[p.v_BitStoreLong]
          nList()\d = PeekD(@BitStoreLong)
          nList()\Flags | #PNB_TYPE_DOUBLE
          
        Case #PNB_TYPE_FLOAT
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          !fstp dword[p.v_BitStoreShort]
          nList()\f = PeekF(@BitStoreShort)
          nList()\Flags | #PNB_TYPE_FLOAT
          
        Case #PNB_TYPE_EPIC
          AddElement(nList())
          CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          !mov dword [p.v_BitStoreLong],eax
          !mov dword [p.v_BitStoreLong+4],edx
          nList()\q = BitStoreLong
          nList()\Flags | #PNB_TYPE_EPIC
          
        Case #PNB_TYPE_INTEGER
          AddElement(nList())
          nList()\i = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_INTEGER
          
        Case #PNB_TYPE_LONG
          AddElement(nList())
          nList()\l = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_LONG
          
        Case #PNB_TYPE_WORD
          AddElement(nList())
          nList()\w = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_WORD
          
        Case #PNB_TYPE_BYTE
          AddElement(nList())
          nList()\b = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_BYTE
          
        Case #PNB_TYPE_UWORD
          AddElement(nList())
          nList()\u = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_UWORD
          
        Case #PNB_TYPE_CHARACTER
          AddElement(nList())
          nList()\c = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_CHARACTER
          
        Case #PNB_TYPE_UBYTE
          AddElement(nList())
          nList()\a = CallCFunctionFast(*FunctionAddress, *Parameter(0), *Parameter(1), *Parameter(2), *Parameter(3), *Parameter(4), *Parameter(5), *Parameter(6), *Parameter(7), *Parameter(8), *Parameter(9), *Parameter(10), *Parameter(11), *Parameter(12), *Parameter(13), *Parameter(14), *Parameter(15), *Parameter(16), *Parameter(17), *Parameter(18), *Parameter(19))
          nList()\Flags | #PNB_TYPE_UBYTE
          
      EndSelect
  EndSelect
  
  ForEach *PointerList()
    FreeMemory(*PointerList())
    DeleteElement(*PointerList())
  Next
  
EndProcedure
