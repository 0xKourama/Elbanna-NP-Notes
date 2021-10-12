# Basic syntax:
`@{ Name = '';  Expression = {}}`

# Execution between parenthesis:
`Get-ChildItem |  Select-Object -Property Name,Directory,@{ Name = 'FromComputer'; Expression = {  hostname }}`

# Using the pipeline to refrence objections:
`Get-ChildItem |  Select-Object -Property Name,Directory,@{ Name = 'FromComputer'; Expression = {  hostname }},@{Name = 'WithParens';Expression = {"( $($_.Name) )"}}`