Prefix Notation Basic
Language Specification

Index:
1.) Preamble
2.) Syntax
    2.1 - Basic Structure
    2.2 - Types
    2.3 - Conditions
    2.4 - Functions
3.) Command Reference
    3.1 - Basic feature set
        3.1.1 - Basic
        3.1.2 - List Manipulation
        3.1.3 - Type Manipulation
        3.1.4 - Variables
        3.1.5 - Arithmetic
        3.1.6 - Logic
    
1.) Preamble
PNB is supposed to be an easy to learn mix of a LISP like structure and BASIC commands.


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
(A (B C) ((D) E))
(A B C ((D) E))
(A B C (D E))
(A B C D E)
A B C D E


2.2 - Types
PNB has the following types:
-Int (32/64 bit signed integer)
-Float (32 bit single precision floating point number)
-String (8/16 bit character strings)

Internal types that are used for program flow:
-List (Only contains subelements)
-Name (Subtype of String)

The lexer searches for the following elements:
-List       = Everything in (Parentheses) will create a List type element. This does not apply to parentheses inside Strings.
-Int        = Everything starting with numbers, +, and -, without any decimal . in them.
-Float      = Everything starting with numbers, +, -, and decimal . . The decimal is only allowed to exist once.
-String     = Everything encased in 'quotes', "double quotes", and [square brackets].
-Command    = Everything that does not fit other criteria, but is the first element. These elements also get the Name type.
-Name       = Everything that does not fit any other criteria.

You can convert Int, Float, String, and Name liberally with built-in commands.
Command and List behave differently, see their respective entries in Command Reference.


2.3 - Conditons
Conditons break up the syntax a bit.
They are executed before evaluating Sublists.
Each work slightly different.

As an example:
(If (A) Do (B) ElseIf (C) Do (D) Else Do (E))
In this case, If evaluates the Expression (A).
If (A) is True If, (B) will be executed.
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
Function (A) Do (B C D) With (C D)
will add a function entry called (A) that will run (B C D), with C and D replaced by parameters.
(A 1 2)
will be replaced to
(B 1 2)

Additonal parameters are discarded.
If there are less parameters than intended, blanks are deleted.
By default, B can not be a parameter.
To enable code injection, use this syntax:
Function (A) Do (Command B C D) With (B C D)

To remove a function, declare it as
Function (A) Do (Clear)
OR
Function (A) Do ()

To clear all function, declare it as
Function (All) Do (Clear)
OR
Function (All) Do ()


3.) Command Reference

3.1 - Basic Feature Set
This is the minimum required feature set for PNB.


3.1.1 - Basic
These commands provide basic functionality that does not fit anywhere else.

Eval
    Takes:      String0, String1, ..., StringN
    Returns:    None
    This command executes every PNB query in the input strings.
    This command is code injecting and thus vulnerable to attacks by design.
    
Debug
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    None
    This command discards every input if run outside of the debug environment.
    Otherwise, it returns each parameter in the debug window.
    
    
3.1.2 - List Manipulation
These commands manipulate the state of the list.

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
    Takes:      Integer, Parameter0, Parameter1, ..., ParameterN
    Returns:    Parameter[Integer] OR everything
    This command returns the list element at the place that the integer defines.
    The first element index is 0.
    If the index is less than 0, everything is returned.
    
Discard
    Takes:      Everything
    Returns:    Nothing
    This command discards every value in the list.
    Sublists are still evaluated before they are discarded.
    
    
3.1.3 - Type Manipulation
These commands convert between types.
    
Type
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    String0, String1, ..., StringN
    Returns the type of each element as string.
    Possible return values: List, Command, Name, String, Float, Integer.
    
<Type>
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Integer0, Integer1, ..., IntegerN
    Everything is converted to <Type>.
    Accepted names are Name, String, Pointer, Double, Float, Epic, Integer, Long, Word, Byte, UWord, Character, UByte.
    
Force<Type>
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Integer0, Integer1, ..., IntegerN
    Everything is cast to <Type>.
    No conversion is done. You can treat Float as Long with this.
    Accepted names are Name, String, Pointer, Double, Float, Epic, Integer, Long, Word, Byte, UWord, Character, UByte.
    
    
3.1.4 - Variables
These commands enable variable declarations.
    
Set
    Takes:      Name, Parameter0, Parameter1, ..., ParameterN
    Returns:    Nothing
    Creates a new variable entry under the given name.
    This variable entry is a value snapshot of the rest of the list.
    (Set A 1 2 3) would create the list snapshot (1 2 3) for variable name A.
    If you want to clear a variable, call it as
    Set A Clear
    OR
    Set A
    If you want to clear all variables, call them as
    Set All Clear
    OR
    Set All
    
Get
    Takes:      Name0, Name1, ..., NameN
    Returns:    List snapshot under given names.
    Creates a new list entry and gets the list snapshot under the given names, in order.
    
Push
    Takes:      Name, Parameter0, Parameter1, ..., ParameterN
    Returns:    Nothing
    Appends parameters to end of variable.
    
Pop
    Takes:      Name0, Name1, ..., NameN
    Returns:    Parameter0, Parameter1, ..., ParameterN
    Removes parameters from end of variables and returns them.
    
Bury
    Takes:      Name, Parameter0, Parameter1, ..., ParameterN
    Returns:    Nothing
    Appends parameters to beginning of variable.
    
Dig
    Takes:      Name0, Name1, ..., NameN
    Returns:    Parameter0, Parameter1, ..., ParameterN
    Removes parameters from start of variables and returns them.
    
Dig
    Takes:      Name0, Name1, ..., NameN
    Returns:    Integer0, Integer1, ..., IntegerN
    Returns size count of each variable.
    
    
3.1.5 - Arithmetic
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
    
Asr, >>
    Takes:      Integer0, Integer1, ..., IntegerN
    Returns:    Integer
    Performs arithmetic shift right operations on the first integer, for every integer.
    
Asl, <<
    Takes:      Integer0, Integer1, ..., IntegerN
    Returns:    Integer
    Performs arithmetic shift left operations on the first integer, for every integer.
    
Sin
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Float0, Float1, ..., FloatN
    Calculates the sine for each value in degrees.
    
ASin
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Float0, Float1, ..., FloatN
    Calculates the arcsine for each value in degrees.
    
Cos
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Float0, Float1, ..., FloatN
    Calculates the cosine for each value in degrees.
    
ACos
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Float0, Float1, ..., FloatN
    Calculates the arccosine for each value in degrees.
    
Tan
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Float0, Float1, ..., FloatN
    Calculates the tangens for each value in degrees.
    
ATan
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Float0, Float1, ..., FloatN
    Calculates the arcustangens for each value in degrees.
    
Up
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Float0, Float1, ..., FloatN
    Rounds the given value up.
    
Down
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Float0, Float1, ..., FloatN [Double if Parameter is Double]
    Rounds the given value down.
    
Round
    Takes:      Parameter0, Parameter1, ..., ParameterN
    Returns:    Float0, Float1, ..., FloatN [Double if Parameter is Double]
    Rounds the given value to the nearest full value.
    
    
Ran, Rand
    Takes:      Nothing OR IntegerRange OR IntegerRange0, IntegerRange1
    Returns:    Integer
    Returns a random integer.
    With no parameters, it is between (2^31-1)-2^30 and -2^30.
    With one parameter, it is between 0 and IntegerRange.
    With two parameters, it is between both.
    
    
3.1.6 - Logic
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
    