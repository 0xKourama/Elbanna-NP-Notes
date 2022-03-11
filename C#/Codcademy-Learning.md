# General
*.NET generally refers to the family of programs and commands that let you make applications with C#*

# building websites:
ASP.NET

# apps that can be built using C#
1. Websites
2. Mobile apps
3. Video games
4. Augmented and virtual reality (AR and VR)
5. Back-end services
6. Desktop applications

# Code location:
`Program.cs`

# printing to console:
`Console.WriteLine()`

# reading from console:
`string input = Console.ReadLine();`

# Program skeleton
```
using System;

namespace GettingInput
{
  class Program
  {
    static void Main()
    {
      Console.WriteLine("How old are you?");
      string input = Console.ReadLine();
      Console.WriteLine($"You are {input} years old!");
    }
  }
}
```

# running interactive code
`dotnet run`

# Single line comment
`//`

# Multiline comment
`/* */`

# Use of comments:
1. provide context for the written code
2. improve code readability
3. debugging code

------------------------------------------------------------------------

# Data Types and variables:
## int
whole numbers, like: 1, -56, 948

## double
decimal numbers, like: 239.43909, -660.01

## char
single characters, like: “a”, “&”, “£”

## string
string of characters, like: “dog”, “hello world”

## bool
boolean values, like: true or false

# Variable declaration:
`string countryName = "Netherlands";`

# Adding variables into strings
`string age = 50;`
`Console.WriteLine($"You are {input} years old!");`

# Variable naming style:
camelCase

# Mandatory Syntax Punctuation
- Semicolon
- Casing in both classes and functions (ex: `console.writeline()` won't work. it has to be `Console.WriteLine()`)
- foreach loop variable has to be a defined data type

# Data type conversions:
*we can implicitly convert when the conversion doesn't create data loss. ex: from int to double. Not the other way around*
## implicit conversion:
`string myNumber = 5;`
`doulbe myDouble = myNumber;`

## Explicit conversion:
`double myDouble = 3.2;`
`int myInt = (int)myDouble;`
or
`int myInt = Convert.ToInt32(myDouble);`

