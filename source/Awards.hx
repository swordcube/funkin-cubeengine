package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;

using StringTools;

class Awards
{
	// -- VARIABLES --
	public static var awardsUnlocked = [
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false,
	];
	
	// -- THE SHIT --
	public static var awardsStuff:Array<Dynamic> = [
		["Freaky on a Friday Night", 	"Play the game on a friday night.", 						"FridayNightPlay", 	"FridayNightPlay", 	"/misc", 			true, 0xFFeb9e34],
		["Beginners Luck", 				"Beat Week 1 with no misses.", 								"Week1", 			"Week1", 			"/weeks", 			false, 0xFFaf66ce],
		["Trick or Treat", 				"Beat Week 2 with no misses.", 								"Week2", 			"Week2", 			"/weeks", 			false, 0xFFd57e00],
		["Bullet Dodger", 				"Beat Week 3 with no misses.", 								"Week3", 			"Week3", 			"/weeks", 			false, 0xFFb7d855],
		["Lady Killer", 				"Beat Week 4 with no misses.", 								"Week4", 			"Week4", 			"/weeks", 			false, 0xFFd8558e],
		["Christmas Morning", 			"Beat Week 5 with no misses.", 								"Week5", 			"Week5", 			"/weeks", 			false, 0xFFaf66ce],
		["Highscore", 					"Beat Week 6 with no misses.", 								"Week6", 			"Week6", 			"/weeks", 			false, 0xFFeb9e34],	
		["Get Good", 					"Beat a song with accuracy lower than 20%.", 				"GetGood", 			"GetGood", 			"/misc", 			false, 0xFFeb9e34],
		["Danger Zone", 				"Beat a song with health lower than 20%.", 					"DangerZone", 		"DangerZone", 		"/misc", 			false, 0xFFeb9e34],
		["osu!mania player", 			"Beat a song with 100% accuracy.", 							"OsuManiaPlayer", 	"OsuManiaPlayer", 	"/misc", 			false, 0xFFeb9e34],
		["Double Sided", 				"Beat a song by only pressing 2 of your keybinds.", 		"DoubleSided", 		"DoubleSided", 		"/misc", 			false, 0xFFeb9e34],
		["Debugger", 					"Beat \"Test\" from the chart editor.", 					"Debugger", 		"Debugger", 		"/misc", 			true, 0xFFeb9e34],
		["Master Debugger", 			"Beat \"Test\" from the chart editor and get no misses.", 	"MasterDebugger", 	"MasterDebugger", 	"/misc", 			true, 0xFFeb9e34],
		#if windows
		["Bloatware", 					"Either you have a shit load of startup programs\nOr it's the bloatware that's slowing you down.", 			"toasterWindows", 	"Toaster", 			"/misc/toaster", 	false, 0xFFe33b3b],
		#elseif mac
		["Money Waster", 				"Is this a 2009 MacBook from EBay?!", 						"toasterMac", 		"Toaster", 			"/misc/toaster", 	false, 0xFFb2b4b8],
		#elseif linux 
		["2009 Laptop", 	"You have to be running Linux on a 2009 laptop\nto get to this point.", 			"toasterLinux", 	"Toaster", 			"/misc/toaster", 	false, 0xFF1b1c1c],
		#else
		["Toaster PC", 	"Please...\nPlease just get a new PC...", 			"toasterGeneric", 	"Toaster", 			"/misc/toaster", 	false, 0xFFb2b4b8],
		#end
		["One small issue...", 			"127.0.0.1\ni have ur ip adress be scared", 				"IPAddress", 		"IPAddress", 		"/misc", 			true, 0xFFeb9e34],
	];

	public static function loadAwards()
	{
		if(FlxG.save.data.awardsUnlocked != null) {
			awardsUnlocked = FlxG.save.data.awardsUnlocked;
		}
	}
	
	public static function saveAwards()
	{
		FlxG.save.data.awardsUnlocked = awardsUnlocked;
		FlxG.save.flush();
	}
}
