bLogs.Config.MySQL = {} local MySQL = bLogs.Config.MySQL

--[[

	This should be pretty self explanatory.

	WARNING: Don't use "localhost"! It doesn't work with Garry's Mod!
	         Use 127.0.0.1 instead.

	If your user account doesn't have a password (not recommended) leave the Password
	field blank.

]]

MySQL.Enabled  = false
MySQL.Host     = ""
MySQL.Username = ""
MySQL.Password = ""
MySQL.Database = ""
MySQL.Port     = 3306
MySQL.ServerID = "Server 1" -- This must be unique to the server to uniquely identify it.