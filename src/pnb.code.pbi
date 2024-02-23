EnableExplicit

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

Procedure.i TypePriority(Flags.i)
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


Procedure.i FreeTriList(List Base.TriList(), Type.i)
  Select Type
    Case #PB_List_After
      PreviousElement(Base())
      
      While NextElement(Base())
        If Base()\Data
          FreeMemory(Base()\Data)
        EndIf
        FreeTriList(Base()\Child(), #PB_List_Last)
        DeleteElement(Base())
      Wend
      
      
    Case #PB_List_Before
      If Base()\Data
        FreeMemory(Base()\Data)
      EndIf
      FreeTriList(Base()\Child(), #PB_List_Last)
      DeleteElement(Base())
      
      While PreviousElement(Base())
        If Base()\Data
          FreeMemory(Base()\Data)
        EndIf
        FreeTriList(Base()\Child(), #PB_List_Last)
        DeleteElement(Base())
      Wend
      
      
    Case #PB_List_First
      If Base()\Data
        FreeMemory(Base()\Data)
      EndIf
      FreeTriList(Base()\Child(), #PB_List_Last)
      DeleteElement(Base())
      
      
    Case #PB_List_Last
      ForEach Base()
        If Base()\Data
          FreeMemory(Base()\Data)
        EndIf
        FreeTriList(Base()\Child(), #PB_List_Last)
        DeleteElement(Base())
      Next
      
      
  EndSelect
  
EndProcedure

Procedure.i CompareTriList(List List1.TriList(), List List2.TriList())
  PushListPosition(List1())
  PushListPosition(List2())
  
  ResetList(List2())
  
  If ListSize(List1()) = ListSize(List2())
    ForEach List1()
      NextElement(List2())
      
      If List1()\Flags = List2()\Flags
        Select TypePriority(List1()\Flags)
          Case #PNB_TYPE_LIST
            If Not CompareTriList(List1()\Child(), List2()\Child())
              PopListPosition(List1())
              PopListPosition(List2())
              ProcedureReturn 0
            EndIf
            
          Case #PNB_TYPE_NAME
            If PeekS(List1()\Data) <> PeekS(List2()\Data)
              PopListPosition(List1())
              PopListPosition(List2())
              ProcedureReturn 0
            EndIf
            
          Case #PNB_TYPE_STRING
            If PeekS(List1()\Data) <> PeekS(List2()\Data)
              PopListPosition(List1())
              PopListPosition(List2())
              ProcedureReturn 0
            EndIf
            
          Case #PNB_TYPE_POINTER
            If PeekI(List1()\Data) <> PeekI(List2()\Data)
              PopListPosition(List1())
              PopListPosition(List2())
              ProcedureReturn 0
            EndIf
            
          Case #PNB_TYPE_DOUBLE
            If PeekD(List1()\Data) <> PeekD(List2()\Data)
              PopListPosition(List1())
              PopListPosition(List2())
              ProcedureReturn 0
            EndIf
            
          Case #PNB_TYPE_FLOAT
            If PeekF(List1()\Data) <> PeekF(List2()\Data)
              PopListPosition(List1())
              PopListPosition(List2())
              ProcedureReturn 0
            EndIf
            
          Case #PNB_TYPE_EPIC
            If PeekQ(List1()\Data) <> PeekQ(List2()\Data)
              PopListPosition(List1())
              PopListPosition(List2())
              ProcedureReturn 0
            EndIf
            
          Case #PNB_TYPE_INTEGER
            If PeekI(List1()\Data) <> PeekI(List2()\Data)
              PopListPosition(List1())
              PopListPosition(List2())
              ProcedureReturn 0
            EndIf
            
          Case #PNB_TYPE_LONG
            If PeekL(List1()\Data) <> PeekL(List2()\Data)
              PopListPosition(List1())
              PopListPosition(List2())
              ProcedureReturn 0
            EndIf
            
          Case #PNB_TYPE_WORD
            If PeekW(List1()\Data) <> PeekW(List2()\Data)
              PopListPosition(List1())
              PopListPosition(List2())
              ProcedureReturn 0
            EndIf
            
          Case #PNB_TYPE_BYTE
            If PeekB(List1()\Data) <> PeekB(List2()\Data)
              PopListPosition(List1())
              PopListPosition(List2())
              ProcedureReturn 0
            EndIf
            
          Case #PNB_TYPE_UWORD
            If PeekU(List1()\Data) <> PeekU(List2()\Data)
              PopListPosition(List1())
              PopListPosition(List2())
              ProcedureReturn 0
            EndIf
            
          Case #PNB_TYPE_CHARACTER
            If PeekC(List1()\Data) <> PeekC(List2()\Data)
              PopListPosition(List1())
              PopListPosition(List2())
              ProcedureReturn 0
            EndIf
            
          Case #PNB_TYPE_UBYTE
            If PeekA(List1()\Data) <> PeekA(List2()\Data)
              PopListPosition(List1())
              PopListPosition(List2())
              ProcedureReturn 0
            EndIf
            
          Default
            PopListPosition(List1())
            PopListPosition(List2())
            ProcedureReturn 0
            
        EndSelect
      Else
        PopListPosition(List1())
        PopListPosition(List2())
        ProcedureReturn 0
      EndIf
    Next
    
    ProcedureReturn 1
    
  Else
    PopListPosition(List1())
    PopListPosition(List2())
    ProcedureReturn 0
  EndIf
  
EndProcedure

Procedure.i EvalTriList(List Base.TriList())
  
  Protected Type.s
  
  If FirstElement(Base())
    ;--Preprocess
    If Base()\Flags & (#PNB_TYPE_COMMAND | #PNB_TYPE_NAME)
      If Base()\Data
        Select PeekS(Base()\Data)
          Case "If"
            
            If NextElement(Base()) And ;Requires a List (Condition)
               Base()\Flags & #PNB_TYPE_LIST And 
               ListSize(Base()\Child()) And
               NextElement(Base()) And ;Requires a Name = Do
               Base()\Flags & #PNB_TYPE_NAME And
               PeekS(Base()\Data) = "Do" And 
               NextElement(Base()) And ;Requires a List (Function)
               Base()\Flags & #PNB_TYPE_LIST And
               ListSize(Base()\Child())
              
              While NextElement(Base())
                If Base()\Flags & #PNB_TYPE_NAME
                  Select PeekS(Base()\Data)
                    Case "ElseIf"
                      If NextElement(Base()) And ;Requires a List (Condition)
                         Base()\Flags & #PNB_TYPE_LIST And 
                         ListSize(Base()\Child()) And
                         NextElement(Base()) And ;Requires a Name = Do
                         Base()\Flags & #PNB_TYPE_NAME And
                         PeekS(Base()\Data) = "Do" And 
                         NextElement(Base()) And ;Requires a List (Function)
                         Base()\Flags & #PNB_TYPE_LIST And
                         ListSize(Base()\Child())
                        Continue
                      Else
                        FreeTriList(Base(), #PB_List_Last)
                        Break
                      EndIf
                      
                    Case "Else"
                      If NextElement(Base()) And ;Requires a Name = Do
                         Base()\Flags & #PNB_TYPE_NAME And
                         PeekS(Base()\Data) = "Do" And 
                         NextElement(Base()) And ;Requires a List (Function)
                         Base()\Flags & #PNB_TYPE_LIST And
                         ListSize(Base()\Child())
                        
                        If NextElement(Base())
                          FreeTriList(Base(), #PB_List_Last)
                          Break
                        Else
                          Break
                        EndIf
                      Else
                        FreeTriList(Base(), #PB_List_Last)
                        Break
                      EndIf
                    Default
                      FreeTriList(Base(), #PB_List_Last)
                      Break
                  EndSelect
                Else
                  FreeTriList(Base(), #PB_List_Last)
                  Break
                EndIf
              Wend
            Else
              FreeTriList(Base(), #PB_List_Last)
            EndIf
            
            If FirstElement(Base())
              FreeTriList(Base(), #PB_List_First) ;If
              NextElement(Base())
              EvalTriList(Base()\Child())
              If ListSize(Base()\Child())
                ForEach Base()\Child()
                  Select TypePriority(Base()\Child()\Flags)
                    Case #PNB_TYPE_NAME
                      If Not Bool(PeekS(Base()\Child()\Data))
                        FreeTriList(Base()\Child(), #PB_List_Last)
                        Break
                      EndIf
                      
                    Case #PNB_TYPE_STRING
                      If Not Bool(PeekS(Base()\Child()\Data))
                        FreeTriList(Base()\Child(), #PB_List_Last)
                        Break
                      EndIf
                      
                    Case #PNB_TYPE_POINTER
                      If Not PeekI(Base()\Child()\Data)
                        FreeTriList(Base()\Child(), #PB_List_Last)
                        Break
                      EndIf
                      
                    Case #PNB_TYPE_DOUBLE
                      If Not PeekD(Base()\Child()\Data)
                        FreeTriList(Base()\Child(), #PB_List_Last)
                        Break
                      EndIf
                      
                    Case #PNB_TYPE_FLOAT
                      If Not PeekF(Base()\Child()\Data)
                        FreeTriList(Base()\Child(), #PB_List_Last)
                        Break
                      EndIf
                      
                    Case #PNB_TYPE_EPIC
                      If Not PeekQ(Base()\Child()\Data)
                        FreeTriList(Base()\Child(), #PB_List_Last)
                        Break
                      EndIf
                      
                    Case #PNB_TYPE_INTEGER
                      If Not PeekI(Base()\Child()\Data)
                        FreeTriList(Base()\Child(), #PB_List_Last)
                        Break
                      EndIf
                      
                    Case #PNB_TYPE_LONG
                      If Not PeekL(Base()\Child()\Data)
                        FreeTriList(Base()\Child(), #PB_List_Last)
                        Break
                      EndIf
                      
                    Case #PNB_TYPE_WORD
                      If Not PeekW(Base()\Child()\Data)
                        FreeTriList(Base()\Child(), #PB_List_Last)
                        Break
                      EndIf
                      
                    Case #PNB_TYPE_BYTE
                      If Not PeekB(Base()\Child()\Data)
                        FreeTriList(Base()\Child(), #PB_List_Last)
                        Break
                      EndIf
                      
                    Case #PNB_TYPE_UWORD
                      If Not PeekU(Base()\Child()\Data)
                        FreeTriList(Base()\Child(), #PB_List_Last)
                        Break
                      EndIf
                      
                    Case #PNB_TYPE_CHARACTER
                      If Not PeekC(Base()\Child()\Data)
                        FreeTriList(Base()\Child(), #PB_List_Last)
                        Break
                      EndIf
                      
                    Case #PNB_TYPE_UBYTE
                      If Not PeekA(Base()\Child()\Data)
                        FreeTriList(Base()\Child(), #PB_List_Last)
                        Break
                      EndIf
                      
                    Default
                      FreeTriList(Base()\Child(), #PB_List_Last)
                      Break
                  EndSelect
                Next
                
                If ListSize(Base()\Child())
                  FreeTriList(Base(), #PB_List_First) ;Condition
                  NextElement(Base())
                  FreeTriList(Base(), #PB_List_First) ;Do
                  NextElement(Base())
                  If NextElement(Base())
                    FreeTriList(Base(), #PB_List_After) ;Rest of the List
                    LastElement(Base())
                  EndIf
                  EvalTriList(Base()\Child())
                  MergeLists(Base()\Child(), Base(), #PB_List_After)
                  FreeTriList(Base(), #PB_List_First) ;Function after evaluation
                  
                Else
                  FreeTriList(Base(), #PB_List_First) ;Condition
                  NextElement(Base())
                  FreeTriList(Base(), #PB_List_First) ;Do
                  NextElement(Base())
                  FreeTriList(Base(), #PB_List_First) ;Function
                  While NextElement(Base())
                    Select PeekS(Base()\Data)
                      Case "ElseIf"
                        FreeTriList(Base(), #PB_List_First) ;ElseIf
                        NextElement(Base())
                        EvalTriList(Base()\Child())
                        If ListSize(Base()\Child())
                          ForEach Base()\Child()
                            Select TypePriority(Base()\Child()\Flags)
                              Case #PNB_TYPE_NAME
                                If Not Bool(PeekS(Base()\Child()\Data))
                                  FreeTriList(Base()\Child(), #PB_List_Last)
                                  Break
                                EndIf
                                
                              Case #PNB_TYPE_STRING
                                If Not Bool(PeekS(Base()\Child()\Data))
                                  FreeTriList(Base()\Child(), #PB_List_Last)
                                  Break
                                EndIf
                                
                              Case #PNB_TYPE_POINTER
                                If Not PeekI(Base()\Child()\Data)
                                  FreeTriList(Base()\Child(), #PB_List_Last)
                                  Break
                                EndIf
                                
                              Case #PNB_TYPE_DOUBLE
                                If Not PeekD(Base()\Child()\Data)
                                  FreeTriList(Base()\Child(), #PB_List_Last)
                                  Break
                                EndIf
                                
                              Case #PNB_TYPE_FLOAT
                                If Not PeekF(Base()\Child()\Data)
                                  FreeTriList(Base()\Child(), #PB_List_Last)
                                  Break
                                EndIf
                                
                              Case #PNB_TYPE_EPIC
                                If Not PeekQ(Base()\Child()\Data)
                                  FreeTriList(Base()\Child(), #PB_List_Last)
                                  Break
                                EndIf
                                
                              Case #PNB_TYPE_INTEGER
                                If Not PeekI(Base()\Child()\Data)
                                  FreeTriList(Base()\Child(), #PB_List_Last)
                                  Break
                                EndIf
                                
                              Case #PNB_TYPE_LONG
                                If Not PeekL(Base()\Child()\Data)
                                  FreeTriList(Base()\Child(), #PB_List_Last)
                                  Break
                                EndIf
                                
                              Case #PNB_TYPE_WORD
                                If Not PeekW(Base()\Child()\Data)
                                  FreeTriList(Base()\Child(), #PB_List_Last)
                                  Break
                                EndIf
                                
                              Case #PNB_TYPE_BYTE
                                If Not PeekB(Base()\Child()\Data)
                                  FreeTriList(Base()\Child(), #PB_List_Last)
                                  Break
                                EndIf
                                
                              Case #PNB_TYPE_UWORD
                                If Not PeekU(Base()\Child()\Data)
                                  FreeTriList(Base()\Child(), #PB_List_Last)
                                  Break
                                EndIf
                                
                              Case #PNB_TYPE_CHARACTER
                                If Not PeekC(Base()\Child()\Data)
                                  FreeTriList(Base()\Child(), #PB_List_Last)
                                  Break
                                EndIf
                                
                              Case #PNB_TYPE_UBYTE
                                If Not PeekA(Base()\Child()\Data)
                                  FreeTriList(Base()\Child(), #PB_List_Last)
                                  Break
                                EndIf
                                
                              Default
                                FreeTriList(Base()\Child(), #PB_List_Last)
                                Break
                            EndSelect
                          Next
                          
                          If ListSize(Base()\Child())
                            FreeTriList(Base(), #PB_List_First) ;Condition
                            NextElement(Base())
                            FreeTriList(Base(), #PB_List_First) ;Do
                            NextElement(Base())
                            If NextElement(Base())
                              FreeTriList(Base(), #PB_List_After) ;Rest of the List
                              LastElement(Base())
                            EndIf
                            EvalTriList(Base()\Child())
                            MergeLists(Base()\Child(), Base(), #PB_List_After)
                            FreeTriList(Base(), #PB_List_First)
                            Break
                          Else
                            FreeTriList(Base(), #PB_List_First) ;Condition
                            NextElement(Base())
                            FreeTriList(Base(), #PB_List_First) ;Do
                            NextElement(Base())
                            FreeTriList(Base(), #PB_List_First) ;Function
                            Continue
                          EndIf
                        EndIf
                      Case "Else"
                        FreeTriList(Base(), #PB_List_First) ;Else
                        NextElement(Base())
                        FreeTriList(Base(), #PB_List_First) ;Do
                        NextElement(Base())
                        EvalTriList(Base()\Child())
                        MergeLists(Base()\Child(), Base(), #PB_List_After)
                        FreeTriList(Base(), #PB_List_First)
                        Break
                        
                    EndSelect
                    
                  Wend
                EndIf
              EndIf
              ProcedureReturn
            Else
              ProcedureReturn
            EndIf
            
            
          Case "Select"
            If NextElement(Base()) And ;Requires a List (Condition)
               Base()\Flags & #PNB_TYPE_LIST And 
               ListSize(Base()\Child())
              
              While NextElement(Base())
                If Base()\Flags & #PNB_TYPE_NAME
                  Select PeekS(Base()\Data)
                    Case "Case"
                      If NextElement(Base()) And ;Requires a List (Condition)
                         Base()\Flags & #PNB_TYPE_LIST And 
                         ListSize(Base()\Child()) And
                         NextElement(Base()) And ;Requires a Name = Do
                         Base()\Flags & #PNB_TYPE_NAME And
                         PeekS(Base()\Data) = "Do" And 
                         NextElement(Base()) And ;Requires a List (Function)
                         Base()\Flags & #PNB_TYPE_LIST And
                         ListSize(Base()\Child())
                      Else
                        FreeTriList(Base(), #PB_List_Last)
                        Break
                      EndIf
                      
                    Case "Default"
                      If NextElement(Base()) And ;Requires a Name = Do
                         Base()\Flags & #PNB_TYPE_NAME And
                         PeekS(Base()\Data) = "Do" And 
                         NextElement(Base()) And ;Requires a List (Function)
                         Base()\Flags & #PNB_TYPE_LIST And
                         ListSize(Base()\Child())
                        If NextElement(Base())
                          FreeTriList(Base(), #PB_List_Last)
                          Break
                        Else
                          Break
                        EndIf
                      Else
                        FreeTriList(Base(), #PB_List_Last)
                        Break
                      EndIf
                    Default
                      FreeTriList(Base(), #PB_List_Last)
                      Break
                      
                  EndSelect
                Else
                  FreeTriList(Base(), #PB_List_Last)
                  Break
                EndIf
              Wend
            Else
              FreeTriList(Base(), #PB_List_Last)
            EndIf
            
            If FirstElement(Base())
              ;--Todo - Select - Case
              FreeTriList(Base(), #PB_List_Last)
              ProcedureReturn
            Else
              ProcedureReturn
            EndIf
            
            
          Case "While"
            If NextElement(Base()) And ;Requires a List (Condition)
               Base()\Flags & #PNB_TYPE_LIST And 
               ListSize(Base()\Child()) And
               NextElement(Base()) And ;Requires a Name = Do
               Base()\Flags & #PNB_TYPE_NAME And
               PeekS(Base()\Data) = "Do" And 
               NextElement(Base()) And ;Requires a List (Function)
               Base()\Flags & #PNB_TYPE_LIST And
               ListSize(Base()\Child())
            Else
              FreeTriList(Base(), #PB_List_Last)
            EndIf
            
            If FirstElement(Base())
              ;--Todo - While
              FreeTriList(Base(), #PB_List_Last)
              ProcedureReturn
            Else
              ProcedureReturn
            EndIf
            
            
          Case "Until"
            If NextElement(Base()) And ;Requires a List (Condition)
               Base()\Flags & #PNB_TYPE_LIST And 
               ListSize(Base()\Child()) And
               NextElement(Base()) And ;Requires a Name = Do
               Base()\Flags & #PNB_TYPE_NAME And
               PeekS(Base()\Data) = "Do" And 
               NextElement(Base()) And ;Requires a List (Function)
               Base()\Flags & #PNB_TYPE_LIST And
               ListSize(Base()\Child())
            Else
              FreeTriList(Base(), #PB_List_Last)
            EndIf
            
            If FirstElement(Base())
              ;--Todo - Until
              FreeTriList(Base(), #PB_List_Last)
              ProcedureReturn
            Else
              ProcedureReturn
            EndIf
            
            
          Case "For"
            If NextElement(Base()) And ;Requires a List (Condition)
               Base()\Flags & #PNB_TYPE_LIST And 
               ListSize(Base()\Child()) And
               NextElement(Base()) And ;Requires a Name = Do
               Base()\Flags & #PNB_TYPE_NAME And
               PeekS(Base()\Data) = "Do" And 
               NextElement(Base()) And ;Requires a List (Function)
               Base()\Flags & #PNB_TYPE_LIST And
               ListSize(Base()\Child())
            Else
              FreeTriList(Base(), #PB_List_Last)
            EndIf
            
            If FirstElement(Base())
              ;--Todo - While
              FreeTriList(Base(), #PB_List_Last)
              ProcedureReturn
            Else
              ProcedureReturn
            EndIf
            
            
          Case "Function"
            If NextElement(Base()) And ;Requires a List (Condition)
               (Base()\Flags &~ #PNB_TYPE_COMMAND) = (#PNB_TYPE_LIST | #PNB_TYPE_NAME) And 
               ListSize(Base()\Child()) And
               NextElement(Base()) And ;Requires a Name = Do
               Base()\Flags & #PNB_TYPE_NAME And
               PeekS(Base()\Data) = "Do" And 
               NextElement(Base()) And ;Requires a List (Function)
               Base()\Flags & #PNB_TYPE_LIST And
               ListSize(Base()\Child())
              
              If NextElement(Base())
                If Base()\Flags & #PNB_TYPE_NAME And ;Requires a Name = With
                   PeekS(Base()\Data) = "With" And
                   NextElement(Base()) And
                   (Base()\Flags &~ #PNB_TYPE_COMMAND) = (#PNB_TYPE_LIST | #PNB_TYPE_NAME) And
                   ListSize(Base()\Child())
                  
                  If NextElement(Base())
                    If Base()\Flags & #PNB_TYPE_NAME And 
                       PeekS(Base()\Data) = "As" And 
                       NextElement(Base()) And
                       Base()\Flags & #PNB_TYPE_LIST And
                       ListSize(Base()\Child())
                      
                      If NextElement(Base())
                        FreeTriList(Base(), #PB_List_Last)
                      EndIf
                    Else
                      FreeTriList(Base(), #PB_List_Last)
                    EndIf
                  EndIf
                Else
                  FreeTriList(Base(), #PB_List_Last)
                EndIf
              EndIf
            Else
              FreeTriList(Base(), #PB_List_Last)
            EndIf
            
            If FirstElement(Base())
              ;Placeholder
              FreeTriList(Base(), #PB_List_Last)
              ProcedureReturn
              ;--Todo - Function
            Else
              ProcedureReturn
            EndIf
            
          Case "Lambda"
            If NextElement(Base()) And ;Requires a Name = Do
               Base()\Flags & #PNB_TYPE_NAME And
               PeekS(Base()\Data) = "Do" And 
               NextElement(Base()) And ;Requires a List (Function)
               Base()\Flags & #PNB_TYPE_LIST And
               ListSize(Base()\Child())
              
              If NextElement(Base())
                If Base()\Flags & #PNB_TYPE_NAME And ;Requires a Name = With
                   PeekS(Base()\Data) = "With" And
                   NextElement(Base()) And
                   (Base()\Flags &~ #PNB_TYPE_COMMAND) = (#PNB_TYPE_LIST | #PNB_TYPE_NAME) And
                   ListSize(Base()\Child())
                  
                  If NextElement(Base())
                    If Base()\Flags & #PNB_TYPE_NAME And 
                       PeekS(Base()\Data) = "As" And 
                       NextElement(Base()) And
                       Base()\Flags & #PNB_TYPE_LIST And
                       ListSize(Base()\Child())
                      
                      If NextElement(Base())
                        FreeTriList(Base(), #PB_List_Last)
                      EndIf
                    Else
                      FreeTriList(Base(), #PB_List_Last)
                    EndIf
                  EndIf
                Else
                  FreeTriList(Base(), #PB_List_Last)
                EndIf
              EndIf
            Else
              FreeTriList(Base(), #PB_List_Last)
            EndIf
            
            If FirstElement(Base())
              ;Placeholder
              FreeTriList(Base(), #PB_List_Last)
              ProcedureReturn
              ;--Todo - Function
            Else
              ProcedureReturn
            EndIf
            
          Case "List"
          Case "Fork"
          Case "Fetch"
            
          Case "Command"
          Case "Matrix"
            
        EndSelect
      EndIf
    EndIf
    
    
    ;--Split and Eval
    ForEach Base()
      If Base()\Flags & #PNB_TYPE_LIST 
        If ListSize(Base()\Child())
          EvalTriList(Base()\Child())
          MergeLists(Base()\Child(), Base(), #PB_List_After)
        EndIf
        FreeTriList(Base(), #PB_List_First)
      EndIf
    Next
    
  EndIf
  
  
EndProcedure



Procedure EvalTriListFork(List Base.TriList())
  
  
EndProcedure

Procedure.s EvalString(String.s)
  Protected NewList Base.TriList()
  Protected ReturnString.s
  
  StringToTriList(Base(), String)
  EvalTriList(Base()) 
  ReturnString = TriListToString(Base(), 1)
  FreeTriList(Base(), #PB_List_Last)
  ProcedureReturn ReturnString
EndProcedure

