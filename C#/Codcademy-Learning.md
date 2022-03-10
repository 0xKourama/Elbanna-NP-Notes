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