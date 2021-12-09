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
		false
	];
	
	// -- THE SHIT --
	public static var awardsStuff:Array<Dynamic> = [
		["Freaky on a Friday Night", 	"Play the game on a friday night.", 						"FridayNightPlay", 	"FridayNightPlay", 	"/misc", 			false],
		["Beginners Luck", 				"Beat Week 1 with no misses.", 								"Week1", 			"Week1", 			"/weeks", 			false],
		["Trick or Treat", 				"Beat Week 2 with no misses.", 								"Week2", 			"Week2", 			"/weeks", 			false],
		["Bullet Dodger", 				"Beat Week 3 with no misses.", 								"Week3", 			"Week3", 			"/weeks", 			false],
		["Lady Killer", 				"Beat Week 4 with no misses.", 								"Week4", 			"Week4", 			"/weeks", 			false],
		["Christmas Morning", 			"Beat Week 5 with no misses.", 								"Week5", 			"Week5", 			"/weeks", 			false],
		["Highscore", 					"Beat Week 6 with no misses.", 								"Week6", 			"Week6", 			"/weeks", 			false],	
		["Get Good", 					"Beat a song with accuracy lower than 20%.", 				"GetGood", 			"GetGood", 			"/misc", 			false],
		["Danger Zone", 				"Beat a song with health lower than 20%.", 					"DangerZone", 		"DangerZone", 		"/misc", 			false],
		["osu!mania player", 			"Beat a song with 100% accuracy.", 							"OsuManiaPlayer", 	"OsuManiaPlayer", 	"/misc", 			false],
		["Double Sided", 				"Beat a song by only pressing 2 of your keybinds.", 		"DoubleSided", 		"DoubleSided", 		"/misc", 			false],
		["Debugger", 					"Beat \"Test\" from the chart editor.", 					"Debugger", 		"Debugger", 		"/misc", 			true],
		["Master Debugger", 			"Beat \"Test\" from the chart editor and get no misses.", 	"MasterDebugger", 	"MasterDebugger", 	"/misc", 			true],
		["One small issue...", 			"127.0.0.1\ni have ur ip adress be scared", 				"IPAddress", 		"IPAddress", 		"/misc", 			true]
		#if windows
		,["Bloatware", 					"Why does Windows come with so much bloatware??", 			"toasterWindows", 	"Toaster", 			"/misc/toaster", 	false]
		#elseif mac
		,["Money Waster", 				"Is this a 2009 MacBook from EBay?!", 						"toasterMac", 		"Toaster", 			"/misc/toaster", 	false]
		#elseif linux 
		,["Stop Breaking Your System", 	"How do you break your system this bad so fast?!", 			"toasterLinux", 	"Toaster", 			"/misc/toaster", 	false]
		#end
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
