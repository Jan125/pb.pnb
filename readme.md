```
Prefix Notation Basic

This is a language specification, as well as reference library.

The provided library has the publicly exposed EvalString function as stdcall (x86) or fastcall (x64) with a parameter that takes a pointer to an unicode string, returning a volatile pointer to an unicode string.
_EvalString is the cdecl (x86) or fastcall (x64) alternative.
For returning numbers binary 0x[hex] format, see the publicly exposed EnableBinary and _EnableBinary functions, that take a signed 32/64 bit integer depending on bitness, returning a void 32/64 bit integer depending on bitness, following the same calling convention scheme as EvalString.

For language reference, see \docs\readme.txt
