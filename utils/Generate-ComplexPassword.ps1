param(
    $Count,
    $MinimumLength = 15,
    $MaximumLength = 20
)

#arrays to randomize from
$Alphabet      = 'abcdefghijklmnopqrstuvwxyz'
$Chars_lower   = $Alphabet.ToCharArray()
$Chars_Upper   = $Alphabet.ToUpper().ToCharArray()
$Numbers       = '012345679'.ToCharArray()
$Special_Chars = '!@#$%^&*'.ToCharArray()

if(!$Count){$Count = 1}
1..$Count | ForEach-Object {
    #generate a random length
    $Random_length = Get-Random -Minimum $MinimumLength -Maximum ($MaximumLength + 1)

    #initialize password as an array
    $password = @()

    1..$Random_length | % {

        #for the first 4 iterations, add one of each array i.e. add one lowercase, one uppercase, one number & one special character
        #to the password so it conforms to password complexity rules
        #then start selecting a random character to add to password
        if($_ -lt 5){$Random_array = $_                              }
        else        {$Random_array = Get-Random -Minimum 1 -Maximum 5}

        switch($Random_array){
            1{$Chosen_array = $Chars_Lower  }
            2{$Chosen_array = $Chars_Upper  }
            3{$Chosen_array = $Numbers      }
            4{$Chosen_array = $Special_Chars}
        }

        $password += $Chosen_array[$(Get-Random -Minimum 0 -Maximum $Chosen_array.Count)]
    }

    #shuffle the final password and turn it into a string
    $password = ($password | Sort-Object {Get-Random}) -join ''

    if($password.Length -lt 10){$color = 'Red'}
    elseif($password.Length -lt 15){$color = 'Yellow'}
    else{$color = 'Green'}

    write-host 'Password: ' -NoNewline
    write-host $password -ForegroundColor $color
}