# 1. create the user
`adduser mynewuser`

# 2. set the password
`passwd mynewuser`

# 3. start visudo (vi text editor)
`visudo`

# 4. find the below line:
```
## Allow root to run any commands anywhere
root ALL=(ALL) ALL
```

# 5. add a similar line for the new user
```
## Allow root to run any commands anywhere
root ALL=(ALL) ALL
mynewuser ALL=(ALL) ALL
```

# 6. save the file and exit
`:wq`