<?php
define('CONST_Postgresql_Version', getenv('POSTGRES_VERSION'));
define('CONST_Postgis_Version', getenv('POSTGIS_VERSION'));
define('CONST_Website_BaseURL', '/');
define('CONST_Replication_Url', getenv('REPLICATION_URL'));
define('CONST_Replication_Update_Interval', getenv('REPLICATION_UPDATE_INTERVAL'));  // How often upstream publishes diffs
define('CONST_Replication_Recheck_Interval', getenv('REPLICATION_RECHECK_INTERVAL'));   // How long to sleep if no update found yet
define('CONST_Pyosmium_Binary', '/usr/local/bin/pyosmium-get-changes');
$database_url = getenv('DATABASE_URL');
$re = '/(?<driver>[a-z]+):\/\/(?<user>[a-z]+)@(?<host>[0-9.]+)(?::(?<port>[0-9]+))?\/(?<database>[^\/]+)/m';
preg_match($re, $database_url, $db);
$db['port'] = empty($db['port']) ? '5432' : $db['port'];
if ($db['driver'] != 'postgresql')
	throw new Exception('Only PostgreSQL is supported!');
$pg_pass = file_get_contents(getenv('POSTGRES_SECRET_FILE'));
$db_dsn = sprintf('pgsql:host=%s;port=%s;user=%s;password=%s;dbname=%s', $db['host'], $db['port'], $db['user'], $pg_pass, $db['database']);

define('CONST_Database_DSN', $db_dsn);
if (getenv('DATABASE_MODULE_PATH') !== FALSE && !empty(getenv('DATABASE_MODULE_PATH')))
	define('CONST_Database_Module_Path', getenv('DATABASE_MODULE_PATH'));