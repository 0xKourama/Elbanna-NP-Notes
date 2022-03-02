#$male_names = Get-Content
#$female_names = Get-Content

$common_abd_first_names = @(
    'Abdallah'
    'AbdelRahman'
)

$index = 1

foreach($mf in $male_names){
    foreach($ml in $male_names){
        if($mf -eq $ml){}
        elseif($mf.StartsWith("El") -eq $true){}
        elseif($mf.StartsWith("Abd") -and $ml.StartsWith("Abd")){}
        elseif($mf.StartsWith("Abd") -and $common_abd_first_names -notcontains $mf){}
        elseif($mf.StartsWith("El") -or $mf.StartsWith("Al") -and !$mf.StartsWith("Aly") -and !$mf.StartsWith("Ali")){}
        else{
            Write-Host -ForegroundColor Cyan "[$index] [*] Crossing $mf with $ml"
            #"$mf$ml" >> list.txt
            #"$mf.$ml" >> list.txt
            $username = "$(($mf.toCharArray())[0])$ml"
            if($username.Length -le 15){
                $username >> C:\Users\MGabr\Desktop\list.txt
            }
            #"$(($mf.toCharArray())[0]).$ml" >> list.txt
            $index++    
        }
    }
}