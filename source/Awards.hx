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
		["Freaky on a Friday Night", "Play the game on a friday night.", "FridayNightPlay", "FridayNightPlay", "/misc"],
		["Beginners Luck", "Beat Week 1 with no misses.", "Week1", "Week1", "/weeks"],
		["Trick or Treat", "Beat Week 2 with no misses.", "Week2", "Week2", "/weeks"],
		["Bullet Dodger", "Beat Week 3 with no misses.", "Week3", "Week3", "/weeks"],
		["Lady Killer", "Beat Week 4 with no misses.", "Week4", "Week4", "/weeks"],
		["Christmas Morning", "Beat Week 5 with no misses.", "Week5", "Week5", "/weeks"],
		["Highscore", "Beat Week 6 with no misses.", "Week6", "Week6", "/weeks"],	
		["Get Good", "Beat a song with accuracy lower than 20%.", "GetGood", "GetGood", "/misc"],
		["Danger Zone", "Beat a song with health lower than 20%.", "DangerZone", "DangerZone", "/misc"],
		["osu!mania player", "Beat a song with 100% accuracy.", "OsuManiaPlayer", "OsuManiaPlayer", "/misc"],
		["Double Sided", "Beat a song by only pressing 2 of your keybinds.", "DoubleSided", "DoubleSided", "/misc"],
		["Debugger", "Beat \"Test\" from the chart editor.", "Debugger", "Debugger", "/misc"],
		["Master Debugger", "Beat \"Test\" from the chart editor and get no misses.", "MasterDebugger", "MasterDebugger", "/misc"],
		#if windows
		["Bloatware", "Why does Windows come with so much bloatware??\nThe speed is unbearable..", "toasterWindows", "Toaster", "/misc/toaster"]
		#end
		#if mac
		["Money Waster", "Why do you spend this much money on a PC..\nIs this a 2009 MacBook from EBay?!", "toasterMac", "Toaster", "/misc/toaster"]
		#end
		#if linux 
		["Stop Breaking Your System", "How do you break your system this bad so fast?!\nYou made your system run like shit!", "toasterLinux", "Toaster", "/misc/toaster"]
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
