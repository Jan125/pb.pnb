XIncludeFile "pnb.pbi"

CompilerIf #PB_Compiler_ExecutableFormat = #PB_Compiler_DLL And #PB_Compiler_Thread = 1
  ProcedureDLL AttachProcess(Instance)
    PNB::MutexFunMap = CreateMutex()
    PNB::MutexVarMap = CreateMutex()
    PNB::MutexMemMap = CreateMutex()
  EndProcedure
  
  ProcedureDLL DetachProcess(Instance)
    FreeMutex(PNB::MutexFunMap)
    FreeMutex(PNB::MutexVarMap)
    FreeMutex(PNB::MutexMemMap)
  EndProcedure
CompilerEndIf

ProcedureDLL.s EvalString(String.s)
  CompilerIf #PB_Compiler_ExecutableFormat = #PB_Compiler_DLL
    Global ReturnString.s
  CompilerElse
    Protected ReturnString.s
  CompilerEndIf
  ReturnString = PNB::nListEvalString(String)
  ProcedureReturn ReturnString
EndProcedure
ProcedureCDLL.s _EvalString(String.s)
  CompilerIf #PB_Compiler_ExecutableFormat = #PB_Compiler_DLL
    Global ReturnString.s
  CompilerElse
    Protected ReturnString.s
  CompilerEndIf
  ReturnString = PNB::nListEvalString(String)
  ProcedureReturn ReturnString
EndProcedure

ProcedureDLL.i EnableBinary(Toggle.i)
  PNB::nListEnableBinary(Toggle)
EndProcedure
ProcedureCDLL.i _EnableBinary(Toggle.i)
  PNB::nListEnableBinary(Toggle)
EndProcedure