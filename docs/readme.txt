Prefix Notation Basic
Language Specification

Index:
1.) Preamble
2.) Syntax
    2.1 - Basic Structure
    2.2 - Types
    2.3 - Conditions
    2.4 - Functions
    2.5 - Matrix
3.) Command Reference
    3.1 - Basic feature set
        3.1.1 - Basic
        3.1.2 - Functions
        3.1.3 - Variables
        3.1.4 - List Manipulation
        3.1.5 - Type Manipulation
        3.1.6 - Arithmetic
        3.1.7 - Logic
        3.1.8 - Memory
        3.1.9 - DLL
        
1.) Preamble
PNB is supposed to be an easy to learn mix of a LISP like structure and BASIC commands.
The precompiled DLLs expose two evaluation functions:
Pointer->StringW(2 byte) EvalString(Pointer->StringW(2 byte))
with an STDCALL (x86) or FASTCALL (x64) convention,
and
Pointer->StringW(2 byte) _EvalString(Pointer->StringW(2 byte))
with an CDECL (x86) or FASTCALL (x64) convention.

Added to that are two functions to toggle binary float returns:
Int32->Void EnableBinary(Int32)
with an STDCALL (x86) or FASTCALL (x64) convention,
and
Int64->Void _EnableBinary(Int64)
with an CDECL (x86) or FASTCALL (x64) convention.

The standard AttachProcess and DetachProcess procedures are available and should be called automatically.

2.) Syntax
2.1 - Basic Structure
The basic structure of PNB is the List.
Every command string is translated into a List that contains Commands, Parameters, and Sublists.
In a given List, Commands are always the first Element.

As an example:
(+ 1 2)
would see + as the command, with 1 and 2 as the parameters.
It would evaluate to 3.

Sublists in a given List will be evaluated first in standard syntax.
The return values will be used in place of them for List higher in the hierarchy.

As an example:
(+ (* 2 3) 8)
would first execute (* 2 3), evaluating it to 6.
The resulting List would look like this:
(+ 6 8)
which would evaluate to 14.

Lists are evaluated left to right, with the most parenthesized Expression being evaluated first.
As an example:
(A (B (C)) ((D) E))
Would resolve the List in the following order:
(A B C ((D) E))
(A B C (D E))
(A (B C) ((D) E))
(A B C D E)
A B C D E


2.2 - Types
PNB has the following types:
-UByte (8 bit unsigned integer)
-Character (8/16 bit unsigned integer, depending on compiler Unicode switch)
-UWord (16 bit unsigned integer)
-Byte (8 bit signed integer)
-Word (16 bit signed integer)
-Integer (32/64 bit signed integer, depending on compiler bitness)
-Long (32 bit signed integer)
-Epic (64 bit signed integer, used when integer input is 11 characters or longer, or 0x hex input is 11 characters or longer, or 0b binary input is 35 characters or longer)
-Pointer (32/64 bit signed integer, depending on compiler bitness)
-Float (32 bit single precision floating point number)
-Double (64 bit single precision floating point number, used when float input is 12 characters or longer)
-String (8/16 bit character strings, depending on compiler Unicode switch)

Internal types that are used for program flow:
-List (Only contains subelements)
-Name (Subtype of String)
-Command (Subtype of Name, added to each first element of a list that does not conform to other types.

The lexer searches for the following elements:
-List           = Everything in (Parentheses) will create a List type element. This does not apply to parentheses inside Strings.
-Integer/Epic   = Everything starting with numbers, +, and -, without any decimal . in them. Hex input via 0x and binary input via 0b are supported.
-Float/Double   = Everything starting with numbers, +, and -, containing a decimal. The decimal is only allowed to exist once.
-String         = Everything encased in 'quotes', "double quotes", and [square brackets].
-Command        = Everything that does not fit other criteria, but is the first element. These elements also get the Name type.
-Name           = Everything that does not fit any other criteria.

You can convert normal types liberally with built-in commands.
Command and List behave differently, see their respective entries under Command Reference.


2.3 - Conditons
Conditons break up the syntax a bit.
They are executed before evaluating Sublists.
Each work slightly different.

As an example:
(If (A) Do (B) ElseIf (C) Do (D) Else Do (E))
In this case, If evaluates the Expression (A).
If (A) is True, (B) will be executed.
If (A) were False, then (B) would be skipped, and (C) will be evaluated.
If (C) is True, (D) will be executed.
If (C) is False, then (E) will be executed.
If can have multiple cases. Only the first positive boolean is executed.
ElseIf and Else are optional.

(Select (A) Case (B) Do (C) Default Do (D))
It evaluates (A).
Then it evaluates (B).
It then compares the return value of (A) to (B). If they match, then (C) is executed.
If none of the cases are a match, (D) is executed.
Select can have multiple cases. Only the first match is executed.
Default is optional.

(While (A) Do (B))
It evaluates (A) for each cycle.
If (A) is a positive boolean, it will evaluate (B).
It then repeats the cycle, checking (A) again.
Once (A) is no longer a positive boolean, While will not cycle again.

(Until (A) Do (B))
It evaluates (B).
It then evaluates (A).
Until (A) is a positive boolean, it will cycle.

(For (A) Do (B))
It evaluates (A).
It then repeats (B) return-value-of-(A)-times.


2.4 - Functions
Functions can be used to compact code, make it more versatile, and enable recursion.

As an example:
Function (A) Do (B C D) With (C D) As (E F)
will add a function entry called (A) that will run (B C D), with C and D replaced by parameters.
If parameters are underloaded, they will be replaced by the default parameters.
(A 1 2)
will be replaced to
(B 1 2)
while the call
(A 3)
will be replaced to
(A 3 F)
because of default parameters being defined.

If there are either more or less parameters than intended, the function will not register.
If the amount of default parameters is not equal to the amount of parameters, the function will not register.
If default parameters are defined, less parameters in calls can be be used.

Defined functions can be found under the keyword Functions.

B can not be a parameter.
To enable code injection, use this syntax:
Function (A) Do (Command B C D) With (B C D)

To remove a function, declare it as
Function (A) Do ()
OR
Unfunction A

Anonymous functions can be called with the syntax
Lambda Do (A B C) With (B C) As (1 2)

Note: Replacing parameters in all functions are done in order, and can replace previously replaced parameters as well.
Lambda Do (X Y Z) With (X Y Z) As (Y Z 1)
would yield
(1 1 1)


2.5 - Matrix
The Matrix command shuffles and if requested evaluates lists.
It can be used to quickly define vector additions and the such.
( Matrix Do + With (A B C) With (D E F) ) = ( (+ A D) (+ B E) (+ C F) )

Listed elements are applied verbatim in their dimension.
( Matrix (A) (1 2) ) = ( (A 1) (2) )

Atoms are applied over the whole length.
( Matrix A (1 2) ) = ( (A 1) (A 2) )

Lists not prefixed with Do or With are evaluated before being matrixed.
( Matrix (+ 1 2) (3 4) ) = ( Matrix (3) (3 4) ) = ( (3 3) (4) )

Lists and elements prefixed with Do will not be evaluated beforehand, and will instead be applied as a command.
( Matrix Do * 2 (3 2 1) ) = ( 6 4 2 )
( Matrix Do (* + -) 3 3 ) = ( 9 6 0 )

Lists prefixed with With will not be evaluated beforehand nor be applied as a command, but otherwise treated as normal.


3.) Command Reference

3.1 - Basic Feature Set
This is the minimum required feature set for PNB.


3.1.1 - Basic
These commands provide basic functionality that does not fit anywhere else.

Eval, Evaluate
    Takes:      String0, String1, ..., StringN
    Returns:    None
    This command executes every PNB query in the input strings.
    This command is code injecting and thus vulnerable to attacks by design.
    
Out, Output
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    None
    This command discards every input if run outside of the debug environment.
    Otherwise, it returns each parameter in the debug window.
    
Err, Error
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    None
    This command discards every input if run outside of the debug environment.
    Otherwise, it returns each parameter in the debug window.
    
Dbg, Debug
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    None
    This command discards every input if run outside of the debug environment.
    Otherwise, it returns each parameter in the debug window.
    
3.1.2 - Functions
    
    
3.1.3 - Variables
These commands enable variable declarations.
    
Variables
    Takes:      None
    Returns:    Name0, Name1, ..., NameN
    Returns all currently defined variable names.
    
Set
    Takes:      Name, Parameter0, Parameter1, ..., ParameterN
    Returns:    Nothing
    Creates a new variable entry under the given name.
    This variable entry is a value snapshot of the rest of the list.
    (Set A 1 2 3) would create the list snapshot (1 2 3) for variable name A.
    If you want to clear a variable, call it as
    (Set A)
    
Get
    Takes:      Name0, Name1, ..., NameN
    Returns:    List snapshot under given names.
    Creates a new list entry and gets the list snapshot under the given names, in order.
    
Take
    Takes:      Name0, Name1, ..., NameN
    Returns:    List snapshot under given names.
    Creates a new list entry and gets the list snapshot under the given names, in order. Removes variable.
    
Remove
    Takes:      Name0, Name1, ..., NameN
    Returns:    Nothing
    Removes variables.
    
Reverse
    Takes:      Name0, Name1, ..., NameN
    Returns:    Nothing
    Inverts variables. (1 2 3) will become (3 2 1).
    
Cycle
    Takes:      Name0, Name1, ..., NameN
    Returns:    Parameter0, Parameter1, ..., ParameterN
    Copies parameters from beginning of variables and returns them. Puts the first element of the variable to end of the variable.
    
Recycle
    Takes:      Name0, Name1, ..., NameN
    Returns:    Parameter0, Parameter1, ..., ParameterN
    Copies parameters from end of variables and returns them. Puts the last element of the variable to beginning of the variable.
    
Push
    Takes:      Name, Parameter0, Parameter1, ..., ParameterN
    Returns:    Nothing
    Appends parameters to beginning of variable.
    
Pop
    Takes:      Name0, Name1, ..., NameN
    Returns:    Parameter0, Parameter1, ..., ParameterN
    Removes parameters from beginning of variables and returns them.
    
Inspect
    Takes:      Name0, Name1, ..., NameN
    Returns:    Parameter0, Parameter1, ..., ParameterN
    Copies parameters from beginning of variables and returns them.
    
Bury
    Takes:      Name, Parameter0, Parameter1, ..., ParameterN
    Returns:    Nothing
    Appends parameters to end of variable.
    
Dig
    Takes:      Name0, Name1, ..., NameN
    Returns:    Parameter0, Parameter1, ..., ParameterN
    Removes parameters from end of variables and returns them.
    
Detect
    Takes:      Name0, Name1, ..., NameN
    Returns:    Parameter0, Parameter1, ..., ParameterN
    Copies parameters from end of variables and returns them.
    
    
3.1.4 - List Manipulation
These commands manipulate the state of the list.

Fork
    Takes:      List0, List1, ..., ListN
    Returns:    Nothing
    All Lists are handled in their own thread.
    Return values are not handled.
    Execution of subsequent commands does not halt.
    
Fetch
    Takes:      List0, List1, ..., ListN
    Returns:    List0, List1, ..., ListN
    All Lists are handled in their own thread.
    Return values are returned to their original position.
    Execution of subsequent commands is suspended until all Lists have been evaluated.
    
Command
    Takes:      Command, Parameter0, Parameter1, ..., ParameterN
    Returns:    Everything that the command would return.
    This command takes the first element of the list and treats it as a command.
    It is executed like a normal command, with the rest of the list being used as parameters.
    This command is by design unsafe.
    
List
    Takes:      Everything
    Returns:    Everything
    This command is implemented as an evaluation stop.
    Everything after it will not be evaluated and is returned as is.
    
Element
    Takes:      Integer, Parameter0, Parameter1, ..., ParameterN OR Name = All, Parameter0, Parameter1, ..., ParameterN
    Returns:    Parameter[Integer] OR everything
    This command returns the list element at the place that the integer defines.
    The first element index is 1.
    
Discard
    Takes:      Everything
    Returns:    Nothing
    This command discards every value in the list.
    Sublists are still evaluated before they are discarded.
    
Invert
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    ParameterN, ..., Parameter1, Parameter0
    Inverts order of list elements.
    (Invert 1 2 3) will become (3 2 1).
    
Size
    Takes:      Everything
    Returns:    Integer
    Returns the total size of the list.
    
Offset
    Takes:      Everything
    Returns:    Integer
    Returns total memory offset of all variables. Names return the length of their types instead.
    
    
3.1.5 - Type Manipulation
These commands convert between types.
    
Split
    Takes:      String0, String1, ..., StringN
    Returns:    Character0, Character1, ..., CharacterN 
    Combines a list of strings into character values.
    
Fuse
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    String
    Combines a list of parameters into a string.
    
Type
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    String0, String1, ..., StringN
    Returns the type of each element as string.
    Possible return values: List, Command, Name, String, Float, Integer.
    
<Type>
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    <Type>0, <Type>1, ..., <Type>N
    Everything is converted to <Type>.
    Accepted types are Name, String, Pointer, Double, Float, Epic, Integer, Long, Word, Byte, UWord, Character, UByte.
    Note that if <Type> is Pointer, everything is allocated to a memory address. This memory address must be freed with Free to stop memory leaks.
    If a Parameter is a Pointer, the program will read the memory from the pointer's address. Memory is not freed after usage.
    
Force<Type>
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    <Type>0, <Type>1, ..., <Type>N
    Everything is cast to <Type>.
    No conversion is done. You can treat Float as Long with this.
    Accepted types are Name, String, Pointer, Double, Float, Epic, Integer, Long, Word, Byte, UWord, Character, UByte.
    
    

    
3.1.6 - Arithmetic
Mathematics.
    
Add, +
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Result
    Depending on total list function type, with first types taking precedence over later ones:
    Combines strings, returns string.
    Adds floats, returns float.
    Adds integers, returns integer.
    
Sub, -
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Result
    Depending on total list function type, with first types taking precedence over later ones:
    Removes strings from first string, returns string.
    Subtracts floats from first float, returns float. If only one parameter is parsed, return its inversion.
    Subtracts integers from first integer, returns integer. If only one parameter is parsed, return its inversion.
    
Mul, *
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Result
    Depending on total list function type, with first types taking precedence over later ones:
    Multiplies floats, returns float.
    Multiplies integers, returns integer.
    
Div, /
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Result
    Depending on total list function type, with first types taking precedence over later ones:
    Divides first float by floats, returns float.
    Divides first integer by integers, returns integer.
    
Pow, ^
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Result
    Depending on total list function type, with first types taking precedence over later ones:
    Exponates first float by floats, returns float.
    Exponates first integer by integers, returns integer.
    
Mod, %
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Result
    Depending on total list function type, with first types taking precedence over later ones:
    Modulos first float by floats, returns float.
    Modulos first integer by integers, returns integer.
    
Sign, +-, -+
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Result0, Result1, ..., ResultN
    Depending on total list function type, with first types taking precedence over later ones:
    Return the sign of every float as float.
    Return the sign of every integer as integer.
    
Abs, _
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Result0, Result1, ..., ResultN
    Depending on total list function type, with first types taking precedence over later ones:
    Return the absolute value of every float as float.
    Return the absolute value of every integer as integer.
    
ASR, >>
    Takes:      Integer0, Integer1, ..., IntegerN
    Returns:    Integer
    Performs arithmetic shift right operations on the first integer, for every integer.
    
ASL, <<
    Takes:      Integer0, Integer1, ..., IntegerN
    Returns:    Integer
    Performs arithmetic shift left operations on the first integer, for every integer.
    
Sin
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Float0, Float1, ..., FloatN
    Calculates the sine for each value in degrees.
    
ASn, ASin
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Float0, Float1, ..., FloatN
    Calculates the arcsine for each value in degrees.
    
Cos
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Float0, Float1, ..., FloatN
    Calculates the cosine for each value in degrees.
    
ACs, ACos
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Float0, Float1, ..., FloatN
    Calculates the arccosine for each value in degrees.
    
Tan
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Float0, Float1, ..., FloatN
    Calculates the tangens for each value in degrees.
    
ATn, ATan
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Float0, Float1, ..., FloatN
    Calculates the arcustangens for each value in degrees.
    
RUp, RoundUp
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Float0, Float1, ..., FloatN
    Rounds the given value up.
    
RDn, RoundDown
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Float0, Float1, ..., FloatN [Double if Parameter is Double]
    Rounds the given value down.
    
RNr, RoundNearest
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Float0, Float1, ..., FloatN [Double if Parameter is Double]
    Rounds the given value to the nearest full value.
    
    
Ran, Random
    Takes:      Nothing OR IntegerRange OR IntegerRange0, IntegerRange1
    Returns:    Integer
    Returns a random integer.
    With no parameters, it is between (2^31-1)-2^30 and -2^30.
    With one parameter, it is between 0 and IntegerRange.
    With two parameters, it is between both.
    
    
3.1.7 - Logic
Comparisons and stuff.
    
Bool
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Integer0, Integer1, ..., IntegerN
    Returns the bool as integer for each parameter.
    Return 1 if integer is not 0, if float is not 0, if string is True, if name is True.
    
Eql, =, ==
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Integer
    Return 1 if all entries are equal.
    This works with strings and numbers.
    This is a comparison of both types and contents, Integer 1 and Long/Epic 1 are different.
    
Neq, <>, ><
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Integer
    Return 1 if entries in line are all not equal to the previous.
    This works with strings and numbers.
    This is a comparison of both types and contents, Integer 1 and Long/Epic 1 are different.
    This function will return (<> A B A) as 1.
    This function will return (<> A A B) as 0.
    
Lss, <
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Integer
    Return 1 if entries in line are all less than the following.
    This works with numbers.
    
Leq, <=, =<
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Integer
    Return 1 if entries in line are all less than or equal to the following.
    This works with numbers.
    
Gtr, >
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Integer
    Return 1 if entries in line are all greater than the following.
    This works with numbers.
    
Geq, >=, =>
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Integer
    Return 1 if entries in line are all greater than or equal to the following.
    This works with numbers.
    
And, &
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Integer
    Return 1 if entries in line are all true.
    This works with numbers.
    
bAnd, b&
    Takes:      Integer0, Integer1, ..., IntegerN
    Returns:    Integer
    Performs a bitwise AND with all entries.
    This works with integers only.
    
Or, |
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Integer
    Return 1 if any entries in line are true.
    This works with numbers.
    
bOr, b|
    Takes:      Integer0, Integer1, ..., IntegerN
    Returns:    Integer
    Performs a bitwise OR with all entries.
    This works with integers only.
    
XOr, !
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Integer
    Return 1 if any entries in line are true, but not all at the same time.
    This works with numbers.
    
bXOr, b!
    Takes:      Integer0, Integer1, ..., IntegerN
    Returns:    Integer
    Performs a bitwise XOR with all entries.
    This works with integers only.
    
Not, ~
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Integer0, Integer1, ..., IntegerN
    Return the boolean inverse (1 to 0, 0 to 1) for each entry.
    This works with numbers.
    
bNot, b~
    Takes:      Integer0, Integer1, ..., IntegerN
    Returns:    Integer0, Integer1, ..., IntegerN
    Performs a bitwise NOT with all entries.
    This works with integers only.
    
    
3.1.8 - Memory
This is for memory management.
By design, there are no error handlers for memory functions.
You can edit memory addresses passed from outside, but no bounds check is done.
Using these functions improperly can lead to crashes.
    
Allocate
    Takes:      Value0, Value1, ..., ValueN
    Returns:    Pointer1, Pointer1, ..., PointerN
    Allocates memory areas in the size of Value.
    These memory areas have to be freed to prevent memory leaks.
    
Free
    Takes:      Pointer0, Pointer1, ..., PointerN OR NameN=All
    Returns:    None
    Frees specific memory areas, OR frees all memory areas defined by the program.
    Externally passed memory is not freed with All.
    Freeing externally passed memory may result in problems.
    
Assert
    Takes:      Pointer0, Pointer1, ..., PointerN
    Returns:    None
    Adds pointers to the auto-free list.
    
Relinquish
    Takes:      Pointer0, Pointer1, ..., PointerN
    Returns:    None
    Removes pointers from the auto-free list.
    
Poke
    Takes:      Pointer, Parameter0 OR Pointer0, Parameter1 OR Pointer1, ..., ParameterN OR PointerN
    Returns:    None
    Writes parameters of their respective types into the address at pointer, incrementing the address with each entry by the size of the type.
    Strings are pushed as 16bit per character in unicode mode, 8bit otherwise.
    Strings are null-terminated.
    If a Pointer is specified as write object, it will write the whole block size from the address. This only works for managed Pointer blocks.
    
Peek
    Takes:      Pointer, Name0=<Type> OR Pointer0, Name1=<Type> OR Pointer1, ..., NameN=<Type> OR PointerN
    Returns:    <Type>0, <Type>1, ..., <TypeN>
    Reads parameters of their respective types, incrementing the address with each entry by the size of the type.
    Strings are read as 16bit per character in unicode mode, 8bit otherwise.
    Strings must be null-terminated.
    If a Pointer is specified as read object, it will read the whole block size from the address. This only works for managed Pointer blocks.
    
    
3.1.9 - DLL
This is for loading and calling DLLs.
By design, there are no error handlers for DLL functions.
Using these functions improperly can lead to crashes.
This function set is by design unsafe.
Currently only available for x86 due to fastcall being a crime.
Notes on x86 calling conventions:
-Pointer, Integer, Long, Word, Byte, UWord, Character, UByte:
    Are passed as 4 byte onto the stack.
    Returned via EAX.
-Name, String:
    Are passed as Pointers onto the stack.
    Memory is allocated until end of function, then freed.
    Returned is an address via EAX that is immediately read.
-Epic:
    Are passed as two 4 byte onto the stack by being split in the middle.
    Returned via EAX:EDX.
-Float:
    Are passes as 4 byte onto the stack.
    Returned via FSTP dword[memory].
-Double:
    Are passed as two 4 byte onto the stack by being split in the middle.
    Returned via FSTP qword[memory].
A maximum of 20 stack parameters (4x20 = 80 bytes on x86) can be passed.

Load
    Takes:      Name0/String0, Name1/String0, ..., NameN/StringN
    Returns:    Integer0, Integer1, ..., IntegerN
    Loads a library. Name/String has to be a path to the library.
    ONLY ONE LIBRARY CAN BE LOADED PER PATH. If multiple instances are required, copy library into different files.
    
Release
    Takes:      Parameter0, Parameter1, ..., ParameterN EXCEPT Name/String/Double/Float
    Returns:    None
    Closes libraries specified by the parameters.
    
Examine
    Takes:      Library(Pointer/Epic/Integer/Long/Word/Byte/UWord/Character/UByte), FunctionName0(Name/String), FunctionName1(Name/String), ... FunctionNameN(Name/String)
    Returns:    Pointer0, Pointer1, ... PointerN
    Returns the addresses of functions.
    
Invoke/InvokeC
    Takes:      <Type>(Name/String) OR None(Name/String), FunctionAddress(Pointer/Epic/Integer/Long/Word/Byte/UWord/Character/UByte), Parameter0, Parameter1, ..., ParameterN
    Returns:    <Type> or None
    The C variant calls the function as cdecl. Otherwise, stdcall is used.
    A maximum of 80 bytes can be passed.
    Everything under 4 bytes is passed as 4 bytes.
    Under x64, the minimum pass is 8 bytes.
    
Call/CallC
    Takes:      <Type>(Name/String) OR None(Name/String), Library(Pointer/Epic/Integer/Long/Word/Byte/UWord/Character/UByte), FunctionName(Name/String), Parameter0, Parameter1, ..., ParameterN
    Returns:    <Type> or None
    The C variant calls the function as cdecl. Otherwise, stdcall is used.
    A maximum of 80 bytes can be passed.
    Everything under 4 bytes is passed as 4 bytes.
    Under x64, the minimum pass is 8 bytes.
    