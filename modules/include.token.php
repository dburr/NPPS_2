<?php
/*
 * Null Pointer Private Server
 * Token-related functions, for login.
 */

/* Creates token */
function token_generate(): string
{
	static $valid_strs = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
	$token_length = random_int(80, 90);
	$token_ret = [];
	
	token_invalidate();
	
	for($i = 0; $i < $token_length; $i++)
		$token_ret[] = $valid_strs[random_int(0, 61)];
	
	return implode('', $token_ret);
}

/* Check if token is there */
function token_exist($token): bool
{
	token_invalidate();
	
	if($token == NULL) return false;
	
	foreach(npps_query("SELECT token FROM `logged_in`") as $value)
		if(strcmp($value['token'], $token) == 0)
			return true;
	
	return false;
}

/* Kick players not logged in for more than 3 days */
function token_invalidate()
{
	global $UNIX_TIMESTAMP;
	$token_expire = npps_config('AUTO_LOGOFF_SECONDS');
	
	foreach(npps_query('SELECT * FROM `logged_in`') as $value)
	{
		if(($UNIX_TIMESTAMP - $value['last_activity_time']) > $token_expire)
			npps_query('DELETE FROM `logged_in` WHERE last_activity_time = ?', 'i', $value[3]);
	}
}

/* Forcefully destroy the token */
function token_destroy(string $token)
{
	npps_query('DELETE FROM `logged_in` WHERE token = ?', 's', $token);
}

function token_pseudo_unit_own_id(string $token): int
{
	$pseudo_curnum = npps_query('SELECT pseudo_unit_own_id FROM `logged_in` WHERE token = ?', 's', $token)[0]['pseudo_unit_own_id'];
	
	npps_query('UPDATE `logged_in` SET pseudo_unit_own_id = pseudo_unit_own_id - 1 WHERE token = ?', 's', $token);
	
	return $pseudo_curnum;
}
