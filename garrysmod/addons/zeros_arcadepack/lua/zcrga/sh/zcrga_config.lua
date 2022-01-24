zcrga = zcrga || {}
zcrga.config = zcrga.config || {}

// Version 1.0.4
////////////////////////////////////////////////////////////////////////////////
// Developed by ZeroChain:
// http://steamcommunity.com/id/zerochain/

// If you wish to contact me:
// clemensproduction@gmail.com

////////////////////////////////////////////////////////////////////////////////
//////////////BEFORE YOU START BE SURE TO READ THE README.TXT///////////////////
////////////////////////////////////////////////////////////////////////////////

// General
///////////////////////
// This is used for making sure the right functions are used
zcrga.config.MoneyType = "DarkRP"
// Currently available:
// "DarkRP" is used for the DarkRP GameMode and all that derieve from it
// "BaseWars" is used for the BaseWars GameMode
// "PointShop01" uses points from Pointshop01 instaead of cash (Adjust the Prizes and PlayPrice so players dont gets 1000 of Points!)
// "PointShop02" uses points from Pointshop02 instaead of cash (Adjust the Prizes and PlayPrice so players dont gets 1000 of Points!)

// The Currency
zcrga.config.Currency = "$"

// These Ranks are allowed do use the save command  !savecoinpusher
zcrga.config.allowedRanks = {
	"superadmin",
	"owner"
}

// Do we want FastDL or the Workshop for downloading the Content
zcrga.config.EnableResourceAddfile = false

// This disables the music of the machine
zcrga.config.NoMusic = true

// This disables the music the machine plays when the players wins a Prize
zcrga.config.NoWinMusic = false

// How long after a Players last interaction before other people can play with the Machine again
zcrga.config.PlayerCoolDown = 10
///////////////////////

///// Lockpick

// Can a Player Lockpick the machines?
zcrga.config.CanBeLockPicked = true

// How long does it take do lockpick the machine?
zcrga.config.LockPickTime = 6 // seconds

// How big is the chance of the player getting cash if the lockpick is completed
zcrga.config.LockPick_WinChance = 0.3 //30%

// How much of the money inside the machine is the Player receiving
zcrga.config.LockPick_WinAmount = 0.6 //60%

// This is the Police Team on the Server, if no Player with that Team on the Server then nobody can lockpick the Machine
// *Note Leave Empty to disable this check
zcrga.config.TEAM_POLICE = {"Civil Protection", "Swat"}

/////


///// Economy
// Do we want the machine do start empty or with a random amount?
zcrga.config.StartEmpty = false

// How big is the chance that we win at all
zcrga.config.WinChance = 0.25 //25%
//*Note* This this sets the basic WinChance, if there is less then a third of Money in the machine then the player wont win at all

// How much does it cost do play the game
zcrga.config.PlayPrice = 1000

// This is the amount at which the chance of wining is very high because the machine is very full
zcrga.config.TriggerAmount = 30000

// This is the WinChance if the Machine gets very full
zcrga.config.TriggerChance = 0.9 // 90% Chance of wining big

// There are currently 3 pize amounts do win, You can change its amount and WinChance but dont add more items do the list
zcrga.config.Prize = {
	[1] = {
		Name = "Small Prize",
		Amount = 1000,
		WinChance = 60, //% How big is the chance of getting a small Prize
	},
	[2] = {
		Name = "Medium Prize",
		Amount = 6000,
		WinChance = 30,
	},
	[3] = {
		Name = "Big Prize",
		Amount = 10000,
		WinChance = 10,
	},

}
///////////////////////
