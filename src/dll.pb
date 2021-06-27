XIncludeFile "pnb.pbi"

CompilerIf #PB_Compiler_ExecutableFormat = #PB_Compiler_DLL And #PB_Compiler_Thread = 1
  ProcedureDLL AttachProcess(Instance)
    PNB::MutexFuncMap = CreateMutex()
    PNB::MutexVarMap = CreateMutex()
  EndProcedure
  
  ProcedureDLL DetachProcess(Instance)
    FreeMutex(PNB::MutexFuncMap)
    FreeMutex(PNB::MutexVarMap)
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

ProcedureDLL.i EnableBinaryFloat(Toggle.i)
  PNB::nListEnableBinaryFloat(Toggle)
EndProcedure
ProcedureCDLL.i _EnableBinaryFloat(Toggle.i)
  PNB::nListEnableBinaryFloat(Toggle)
EndProcedure