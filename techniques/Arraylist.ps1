$lazyList = New-Object System.Collections.ArrayList
$lazyList.Add("a")
$lazyList.Add("c")
$lazyList.Add("b")
$lazyList #returns a c b
 
$lazyList.Sort()
$lazyList #returns a b c
 
$lazyList.Reverse()
$lazyList #returns c b a
 
$lazyList.Remove("a")
$lazyList #returns c b
 
<#
Arrays become slow and require a lot of resources if they get too large. ArrayLists handle large amounts of data much better. Additionally, they allow you to delete individual elements.
 
Note: You can store elements of different types in an ArrayList. For example, $lazyList.Add(1), $lazyList.Add(“one”) works. –> ArrayLists are not type-safe!
 
This can lead to unexpected errors. For example, sorting can only work if the type is same (for instance, int or string).
#>
