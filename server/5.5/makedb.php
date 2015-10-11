<?php
// Args: 0 => makedb.php, 1 => "$JOOMLA_DB_HOST", 2 => "$JOOMLA_DB_USER", 3 => "$JOOMLA_DB_PASSWORD", 4 => "$JOOMLA_TEST_APP_NAME", 5 => "JOOMLA_PHP_VERSION", 6 => "JOOMLA_TEST_JOOMLA_VERSIONS", 7 => "JOOMLA_TEST_APP_VERSIONS"
$stderr = fopen('php://stderr', 'w');
fwrite($stderr, "\nEnsuring database is present\n");
if (strpos($argv[1], ':') !== false)
{
	list($host, $port) = explode(':', $argv[1], 2);
}
else
{
	$host = $argv[1];
	$port = 3306;
}
$maxTries = 10;
$try = 0;
do
{
	$try ++;
	$mysql = new mysqli($host, $argv[2], $argv[3], '', (int) $port);
	if ($mysql->connect_error)
	{
		fwrite($stderr, "\nMySQL Connection Error: ({$mysql->connect_errno}) {$mysql->connect_error} ($try/$maxTries)\n");
		if ($try == $maxTries)
		{
			exit(1);
		}
		sleep(3);
	}
}
while ($mysql->connect_error);

$joomlaVersions = explode(',', $argv[6]);

if (strtolower($argv[4]) == 'joomla')
{
	$appVersions = array($argv[6]);
}
else
{
	$appVersions = explode(',', $argv[7]);
}

foreach ($joomlaVersions as $jv)
{

	foreach ($appVersions as $av)
	{
		if (strtolower($argv[4]) == 'joomla')
		{
			$dbName = $argv[4] . '_' . $argv[5] . '_' . $jv;
		}
		else
		{
			$dbName = $argv[4] . '_' . $argv[5] . '_' . $jv . '_' . $av;
		}

		if (!$mysql->query('DROP DATABASE IF EXISTS `' . $mysql->real_escape_string($dbName) . '`'))
		{
			fwrite($stderr, "\nMySQL 'DROP DATABASE' Error: " . $mysql->error . "\n");
			$mysql->close();
			exit(1);
		}
		if (!$mysql->query('CREATE DATABASE IF NOT EXISTS `' . $mysql->real_escape_string($dbName) . '`'))
		{
			fwrite($stderr, "\nMySQL 'CREATE DATABASE' Error: " . $mysql->error . "\n");
			$mysql->close();
			exit(1);
		}
		fwrite($stderr, "\nMySQL Database Created: $dbName\n");
	}
}
$mysql->close();
