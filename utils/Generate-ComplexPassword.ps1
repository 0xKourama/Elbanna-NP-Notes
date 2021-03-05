param($Count)

#arrays to randomize from
$Alphabet      = 'abcdefghijklmnopqrstuvwxyz'
$Chars_lower   = $Alphabet.ToCharArray()
$Chars_Upper   = $Alphabet.ToUpper().ToCharArray()
$Numbers       = '012345679'.ToCharArray()
$Special_Chars = '!@#$%^&*'.ToCharArray()

#configure min and max password length
$Password_length_Min = 15
$Password_length_Max = 20

1..$Count | ForEach-Object {
    #generate a random length
    $Random_length = Get-Random -Minimum $Password_length_Min -Maximum ($Password_length_Max + 1)

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

    write-host 'Password: ' -NoNewline
    write-host $password -ForegroundColor Green
}