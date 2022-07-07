Procedure PNB_Set(List nList.nList())
  Protected RSTR.s
  
  If NextElement(nList())
    If nList()\Flags & #PNB_TYPE_NAME
      RSTR = nList()\s
      DeleteElement(nList())
      If RSTR = "All"
        If NextElement(nList())
          If nList()\Flags & #PNB_TYPE_NAME
            If nList()\s = "Clear"
              CompilerIf #PB_Compiler_Thread = 1
                LockMutex(MutexVarMap)
              CompilerEndIf
              ClearMap(Memory())
              ClearList(nList())
              CompilerIf #PB_Compiler_Thread = 1
                UnlockMutex(MutexVarMap)
              CompilerEndIf
            EndIf
          EndIf
        Else
          CompilerIf #PB_Compiler_Thread = 1
            LockMutex(MutexVarMap)
          CompilerEndIf
          ClearMap(Memory())
          ClearList(nList())
          CompilerIf #PB_Compiler_Thread = 1
            UnlockMutex(MutexVarMap)
          CompilerEndIf
        EndIf
      Else
        CompilerIf #PB_Compiler_Thread = 1
          LockMutex(MutexVarMap)
        CompilerEndIf
        AddMapElement(Memory(), RSTR)
        If ListSize(nList())
          ForEach nList()
            AddElement(Memory()\nList())
            Memory()\nList() = nList()
            DeleteElement(nList())
          Next
          
        Else
          DeleteMapElement(Memory(), RSTR)
          ClearList(nList())
        EndIf
        CompilerIf #PB_Compiler_Thread = 1
          UnlockMutex(MutexVarMap)
        CompilerEndIf
      EndIf
    Else
      ClearList(nList())
    EndIf
  Else
    ClearList(nList())
  EndIf
  
EndProcedure

Procedure PNB_Get(List nList.nList())
  Protected NewList cList1.nList()
  Protected NewList cList2.nList()
  
  ForEach nList()
    If nList()\Flags & #PNB_TYPE_NAME
      CompilerIf #PB_Compiler_Thread = 1
        LockMutex(MutexVarMap)
      CompilerEndIf
      If FindMapElement(Memory(), nList()\s)
        CopyList(Memory()\nList(), cList1())
        MergeLists(cList1(), cList2())
      Else
        ResetMap(Memory())
      EndIf
      DeleteElement(nList())
      CompilerIf #PB_Compiler_Thread = 1
        UnlockMutex(MutexVarMap)
      CompilerEndIf
    Else
      ClearList(nList())
    EndIf
  Next
  MergeLists(cList2(), nList())
  
EndProcedure

Procedure PNB_Take(List nList.nList())
  Protected NewList cList1.nList()
  
  ForEach nList()
    If nList()\Flags & #PNB_TYPE_NAME
      CompilerIf #PB_Compiler_Thread = 1
        LockMutex(MutexVarMap)
      CompilerEndIf
      If FindMapElement(Memory(), nList()\s)
        MergeLists(Memory()\nList(), cList1())
        DeleteMapElement(Memory())
      Else
        ResetMap(Memory())
      EndIf
      CompilerIf #PB_Compiler_Thread = 1
        UnlockMutex(MutexVarMap)
      CompilerEndIf
      DeleteElement(nList())
    EndIf
  Next
  MergeLists(cList1(), nList())
  
EndProcedure

Procedure PNB_Remove(List nList.nList())
  ForEach nList()
    If nList()\Flags & #PNB_TYPE_NAME
      If nList()\s = "All"
        CompilerIf #PB_Compiler_Thread = 1
          LockMutex(MutexVarMap)
        CompilerEndIf
        ClearMap(Memory())
        ClearList(nList())
        CompilerIf #PB_Compiler_Thread = 1
          UnlockMutex(MutexVarMap)
        CompilerEndIf
      Else
        CompilerIf #PB_Compiler_Thread = 1
          LockMutex(MutexVarMap)
        CompilerEndIf
        If FindMapElement(Memory(), nList()\s)
          DeleteMapElement(Memory())
        Else
          ResetMap(Memory())
        EndIf
        CompilerIf #PB_Compiler_Thread = 1
          UnlockMutex(MutexVarMap)
        CompilerEndIf
      EndIf
      DeleteElement(nList())
    EndIf
  Next
  
EndProcedure

Procedure PNB_Cycle(List nList.nList())
  Protected NewList cList1.nList()
  
  ForEach nList()
    CompilerIf #PB_Compiler_Thread = 1
      LockMutex(MutexVarMap)
    CompilerEndIf
    If nList()\Flags & #PNB_TYPE_NAME
      If FindMapElement(Memory(), nList()\s)
        If FirstElement(Memory()\nList())
          AddElement(cList1())
          cList1() = Memory()\nList()
          MoveElement(Memory()\nList(), #PB_List_Last)
        EndIf
      Else
        ResetMap(Memory())
      EndIf
    Else
      CompilerIf #PB_Compiler_Thread = 1
        UnlockMutex(MutexVarMap)
      CompilerEndIf
      ClearList(nList())
      ClearList(cList1())
      Break
    EndIf
    CompilerIf #PB_Compiler_Thread = 1
      UnlockMutex(MutexVarMap)
    CompilerEndIf
    DeleteElement(nList())
  Next
  MergeLists(cList1(), nList())
  
EndProcedure

Procedure PNB_Bury(List nList.nList())
  Protected NewList cList1.nList()
  
  If NextElement(nList())
    If nList()\Flags & #PNB_TYPE_NAME
      AddElement(cList1())
      cList1() = nList()
      DeleteElement(nList())
      CompilerIf #PB_Compiler_Thread = 1
        LockMutex(MutexVarMap)
      CompilerEndIf
      If Not FindMapElement(Memory(), cList1()\s)
        AddMapElement(Memory(), cList1()\s)
      EndIf
      MergeLists(nList(), Memory()\nList())
      CompilerIf #PB_Compiler_Thread = 1
        UnlockMutex(MutexVarMap)
      CompilerEndIf
      ClearList(cList1())
    Else
      ClearList(nList())
    EndIf
  Else
    ClearList(nList())
  EndIf
  
EndProcedure

Procedure PNB_Dig(List nList.nList())
  Protected NewList cList1.nList()
  
  ForEach nList()
    CompilerIf #PB_Compiler_Thread = 1
      LockMutex(MutexVarMap)
    CompilerEndIf
    If nList()\Flags & #PNB_TYPE_NAME
      If FindMapElement(Memory(), nList()\s)
        If LastElement(Memory()\nList())
          AddElement(cList1())
          cList1() = Memory()\nList()
          DeleteElement(Memory()\nList())
          If Not ListSize(Memory()\nList())
            DeleteMapElement(Memory())
          EndIf
        EndIf
      Else
        ResetMap(Memory())
      EndIf
    Else
      CompilerIf #PB_Compiler_Thread = 1
        UnlockMutex(MutexVarMap)
      CompilerEndIf
      ClearList(nList())
      ClearList(cList1())
      Break
    EndIf
    CompilerIf #PB_Compiler_Thread = 1
      UnlockMutex(MutexVarMap)
    CompilerEndIf
    DeleteElement(nList())
  Next
  MergeLists(cList1(), nList())
  
EndProcedure

Procedure PNB_Detect(List nList.nList())
  Protected NewList cList1.nList()
  
  ForEach nList()
    CompilerIf #PB_Compiler_Thread = 1
      LockMutex(MutexVarMap)
    CompilerEndIf
    If nList()\Flags & #PNB_TYPE_NAME
      If FindMapElement(Memory(), nList()\s)
        If LastElement(Memory()\nList())
          AddElement(cList1())
          cList1() = Memory()\nList()
        EndIf
      Else
        ResetMap(Memory())
      EndIf
    Else
      CompilerIf #PB_Compiler_Thread = 1
        UnlockMutex(MutexVarMap)
      CompilerEndIf
      ClearList(nList())
      ClearList(cList1())
      Break
    EndIf
    CompilerIf #PB_Compiler_Thread = 1
      UnlockMutex(MutexVarMap)
    CompilerEndIf
    DeleteElement(nList())
  Next
  MergeLists(cList1(), nList())
  
EndProcedure

Procedure PNB_Push(List nList.nList())
  Protected NewList cList1.nList()
  
  If NextElement(nList())
    If nList()\Flags & #PNB_TYPE_NAME
      AddElement(cList1())
      cList1() = nList()
      DeleteElement(nList())
      CompilerIf #PB_Compiler_Thread = 1
        LockMutex(MutexVarMap)
      CompilerEndIf
      If Not FindMapElement(Memory(), cList1()\s)
        AddMapElement(Memory(), cList1()\s)
      EndIf
      MergeLists(nList(), Memory()\nList(), #PB_List_First)
      CompilerIf #PB_Compiler_Thread = 1
        UnlockMutex(MutexVarMap)
      CompilerEndIf
      ClearList(cList1())
    Else
      ClearList(nList())
    EndIf
  Else
    ClearList(nList())
  EndIf
  
EndProcedure

Procedure PNB_Pop(List nList.nList())
  Protected NewList cList1.nList()
  
  ForEach nList()
    CompilerIf #PB_Compiler_Thread = 1
      LockMutex(MutexVarMap)
    CompilerEndIf
    If nList()\Flags & #PNB_TYPE_NAME
      If FindMapElement(Memory(), nList()\s)
        If FirstElement(Memory()\nList())
          AddElement(cList1())
          cList1() = Memory()\nList()
          DeleteElement(Memory()\nList())
          If Not ListSize(Memory()\nList())
            DeleteMapElement(Memory())
          EndIf
        EndIf
      Else
        ResetMap(Memory())
      EndIf
    Else
      CompilerIf #PB_Compiler_Thread = 1
        UnlockMutex(MutexVarMap)
      CompilerEndIf
      ClearList(nList())
      ClearList(cList1())
      Break
    EndIf
    CompilerIf #PB_Compiler_Thread = 1
      UnlockMutex(MutexVarMap)
    CompilerEndIf
    DeleteElement(nList())
  Next
  MergeLists(cList1(), nList())
  
EndProcedure

Procedure PNB_Inspect(List nList.nList())
  Protected NewList cList1.nList()
  
  ForEach nList()
    CompilerIf #PB_Compiler_Thread = 1
      LockMutex(MutexVarMap)
    CompilerEndIf
    If nList()\Flags & #PNB_TYPE_NAME
      If FindMapElement(Memory(), nList()\s)
        If FirstElement(Memory()\nList())
          AddElement(cList1())
          cList1() = Memory()\nList()
        EndIf
      Else
        ResetMap(Memory())
      EndIf
    Else
      CompilerIf #PB_Compiler_Thread = 1
        UnlockMutex(MutexVarMap)
      CompilerEndIf
      ClearList(nList())
      ClearList(cList1())
      Break
    EndIf
    CompilerIf #PB_Compiler_Thread = 1
      UnlockMutex(MutexVarMap)
    CompilerEndIf
    DeleteElement(nList())
  Next
  MergeLists(cList1(), nList())
  
EndProcedure

Procedure PNB_Reverse(List nList.nList())
  Protected NewList cList1.nList()
  
  ForEach nList()
    CompilerIf #PB_Compiler_Thread = 1
      LockMutex(MutexVarMap)
    CompilerEndIf
    If nList()\Flags & #PNB_TYPE_NAME
      If FindMapElement(Memory(), nList()\s)
        ForEach Memory()\nList()
          InsertElement(cList1())
          cList1() = Memory()\nList()
        Next
        ClearList(Memory()\nList())
        MergeLists(cList1(), Memory()\nList())
      Else
        ResetMap(Memory())
      EndIf
    Else
      CompilerIf #PB_Compiler_Thread = 1
        UnlockMutex(MutexVarMap)
      CompilerEndIf
      ClearList(nList())
      ClearList(cList1())
      Break
    EndIf
    CompilerIf #PB_Compiler_Thread = 1
      UnlockMutex(MutexVarMap)
    CompilerEndIf
    DeleteElement(nList())
  Next
  
EndProcedure
