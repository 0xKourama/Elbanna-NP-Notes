## bash automatic variables
| Variable Name | Description |
| ----------- | ----------- |
| $0 | The name of the Bash script |
| $1 - $9 | The first 9 arguments to the Bash script |
| $# | Number of arguments passed to the Bash script |
| $@ | All arguments passed to the Bash script |
| $? | The exit status of the most recently run process |
| $$ | The process ID of the current script |
| $USER | The username of the user running the script |
| $HOSTNAME | The hostname of the machine |
| $RANDOM | A random number |
| $LINENO | The current line number in the script |

---

## variables
```bash
first_name=Omni
last_name=Slash
user=$(whoami)
```

---

## reading user input
```bash
echo "What's your name?"
read name
echo "Hi $name"
```

--- 

## flow control
### example #1: if/then
```bash
read -p "What is your age: " age
if [ $age -lt 21 ]
then
	echo "you can't have a driver's license yet"
fi
```
### example #2: if/elif/else
```bash
read -p "What is your age: " age
if [ $age -lt 21 ]
then
	echo "you can't have a driver's license yet"
elif [ $age -gt 80 ]
then
	echo "Don't drive old man!"
else
	echo "Welcome to the test"
fi
```
---

## important operators

| Operator | Description: Expression True if… |
| ------ | ----- |
| !EXPRESSION | The EXPRESSION is false. |
| -n | STRING STRING length is greater than zero |
| -z | STRING The length of STRING is zero (empty) |
| STRING1 != STRING2 | STRING1 is not equal to STRING2 |
| STRING1 = STRING2 | STRING1 is equal to STRING2 |
| INTEGER1 -eq INTEGER2 | INTEGER1 is equal to INTEGER2 |
| INTEGER1 -ne INTEGER2 | INTEGER1 is not equal to INTEGER2 |
| INTEGER1 -gt INTEGER2 | INTEGER1 is greater than INTEGER2 |
| INTEGER1 -lt INTEGER2 | INTEGER1 is less than INTEGER2 |
| INTEGER1 -ge INTEGER2 | INTEGER1 is greater than or equal to INTEGER 2 |
| INTEGER1 -le INTEGER2 | INTEGER1 is less than or equal to INTEGER 2 |
| -d FILE | FILE exists and is a directory |
| -e FILE | FILE exists |
| -r FILE | FILE exists and has read permission |
| -s FILE | FILE exists and it is not empty |
| -w FILE | FILE exists and has write permission |
| -x FILE | FILE exists and has execute permission |

---

## boolean operators

```bash
read -p "Enter a username: " user
grep $user /etc/passwd && echo "$user found!" || echo "$user not found
```

---

## for loops
```bash
for ip in $(seq 1 254); do echo 10.10.10.$ip; done
```
**OR**
```bash
for ip in {1..254}; do echo 10.10.10.$ip; done
```

---

## while loops

```bash
counter=1
while [ $counter -lt 10 ]
do
	echo "10.10.10.$counter"
	((counter++))
done
```

---

## functions
### normal function declaration and call
```bash
get_a_random_number() {
	echo $RANDOM	
}
get_a_random_number
```
### function with a return value
```bash
return_a_random_number() {
	return $RANDOM	
}
return_a_random_number
echo "return value: $?"
```
### output:
```bash
./func.sh 
return value: 11
```