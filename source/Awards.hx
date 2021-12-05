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
	public static var awardsStuff:Array<Dynamic> = [
		[
			"Freaky on a Friday Night", // Name
			"Play the game on a friday night.", // Description
			"FridayNightPlay", // Internal Name
			"FridayNightPlay", // Tag
			"/misc", // Folder Path
		],

		[
			"Beginners Luck", // Name
			"Beat Week 1 with no misses.", // Description
			"Week1", // Internal Name
			"Week1", // Tag
			"/weeks", // Folder Path
		],
		
		[
			"Trick or Treat", // Name
			"Beat Week 2 with no misses.", // Description
			"Week2", // Internal Name
			"Week2", // Tag
			"/weeks", // Folder Path
		],
		
		[
			"Bullet Dodger", // Name
			"Beat Week 3 with no misses.", // Description
			"Week3", // Internal Name
			"Week3", // Tag
			"/weeks", // Folder Path
		],
		
		[
			"Lady Killer", // Name
			"Beat Week 4 with no misses.", // Description
			"Week4", // Internal Name
			"Week4", // Tag
			"/weeks", // Folder Path
		],
		
		[
			"Christmas Morning", // Name
			"Beat Week 5 with no misses.", // Description
			"Week5", // Internal Name
			"Week5", // Tag
			"/weeks", // Folder Path
		],
		
		[
			"Highscore", // Name
			"Beat Week 6 with no misses.", // Description
			"Week6", // Internal Name
			"Week6", // Tag
			"/weeks", // Folder Path
		],	
		
		[
			"Get Good", // Name
			"Beat a song with accuracy lower than 20%.", // Description
			"GetGood", // Internal Name
			"GetGood", // Tag
			"/misc", // Folder Path
		],
		
		[
			"Danger Zone", // Name
			"Beat a song with health lower than 20%.", // Description
			"DangerZone", // Internal Name
			"DangerZone", // Tag
			"/misc", // Folder Path
		],
		
		[
			"osu!mania player", // Name
			"Beat a song with 100% accuracy.", // Description
			"OsuManiaPlayer", // Internal Name
			"OsuManiaPlayer", // Tag
			"/misc", // Folder Path
		],
		
		// BULLSHIT SPECIFIC TO WHATEVER OS YOU'RE USING I THINK IDFK WHAT I'M DOING
		// TOASTER AWARD YEYE
		
		#if windows
		[
			"Bloatware", // Name
			"Why does Windows come with so much bloatware??\nThe speed is unbearable..", // Description
			"toasterWindows", // Internal Name
			"Toaster", // Tag
			"/misc/toaster", // Folder Path
		],
		#end
		
		#if mac
		[
			"Money Waster", // Name
			"Why do you spend this much money on a PC..\nIs this a 2009 MacBook from EBay?!", // Description
			"toasterMac", // Internal Name
			"toaster", // Tag
			"/misc/toaster", // Folder Path
		],
		#end
		
		#if linux
		[
			"Stop Breaking Your System", // Name
			"How do you break your system this bad so fast?!\nYou made your system run like shit!", // Description
			"toasterLinux", // Internal Name
			"Toaster", // Tag
			"/misc/toaster", // Folder Path
		],
		#end
		
		/*[
			"Gaming with a Toaster", // Name
			"Please just get a new pc....", // Description
			"toasterGeneric", // Internal Name
			"Toaster", // Tag
			"/misc/toaster", // Folder Path
		],*/
		
		[
			"Double Sided", // Name
			"Beat a song by only pressing 2 of your keybinds.", // Description
			"DoubleSided", // Internal Name
			"DoubleSided", // Tag
			"/misc", // Folder Path
		],
		
		[
			"Debugger", // Name
			"Beat \"Test\" from the chart editor.", // Description
			"Debugger", // Internal Name
			"Debugger", // Tag
			"/misc", // Folder Path
		],
		
		[
			"Master Debugger", // Name
			"Beat \"Test\" from the chart editor and get no misses.", // Description
			"MasterDebugger", // Internal Name
			"MasterDebugger", // Tag
			"/misc", // Folder Path
		],
	];
	
	// -- VARIABLES --
	public static var AwardFridayNight:Bool = false;
	public static var AwardWeek1:Bool = false;
	public static var AwardWeek2:Bool = false;
	public static var AwardWeek3:Bool = false;
	public static var AwardWeek4:Bool = false;
	public static var AwardWeek5:Bool = false;
	public static var AwardWeek6:Bool = false;
	public static var AwardGetGood:Bool = false;
	public static var AwardDangerZone:Bool = false;
	public static var AwardOsuManiaPlayer:Bool = false;
	public static var AwardIsToaster:Bool = false;
	public static var AwardDoubleSided:Bool = false;
	public static var AwardDebugger:Bool = false;
	public static var AwardMasterDebugger:Bool = false;

	public static function loadAwards()
	{
		if(FlxG.save.data.AwardFridayNight != null) {
			AwardFridayNight = FlxG.save.data.AwardFridayNight;
		}
		
		if(FlxG.save.data.AwardWeek1 != null) {
			AwardWeek1 = FlxG.save.data.AwardWeek1;
		}
		
		if(FlxG.save.data.AwardWeek2 != null) {
			AwardWeek2 = FlxG.save.data.AwardWeek2;
		}
		
		if(FlxG.save.data.AwardWeek3 != null) {
			AwardWeek3 = FlxG.save.data.AwardWeek3;
		}
		
		if(FlxG.save.data.AwardWeek4 != null) {
			AwardWeek4 = FlxG.save.data.AwardWeek4;
		}
		
		if(FlxG.save.data.AwardWeek5 != null) {
			AwardWeek5 = FlxG.save.data.AwardWeek5;
		}
		
		if(FlxG.save.data.AwardWeek6 != null) {
			AwardWeek6 = FlxG.save.data.AwardWeek6;
		}
		
		if(FlxG.save.data.AwardGetGood != null) {
			AwardGetGood = FlxG.save.data.AwardGetGood;
		}
		
		if(FlxG.save.data.AwardDangerZone != null) {
			AwardDangerZone = FlxG.save.data.AwardDangerZone;
		}
		
		if(FlxG.save.data.AwardOsuManiaPlayer != null) {
			AwardOsuManiaPlayer = FlxG.save.data.AwardOsuManiaPlayer;
		}
		
		if(FlxG.save.data.AwardIsToaster != null) {
			AwardIsToaster = FlxG.save.data.AwardIsToaster;
		}
		
		if(FlxG.save.data.AwardDoubleSided != null) {
			AwardDoubleSided = FlxG.save.data.AwardDoubleSided;
		}
		
		if(FlxG.save.data.AwardDebugger != null) {
			AwardDebugger = FlxG.save.data.AwardDebugger;
		}
		
		if(FlxG.save.data.AwardMasterDebugger != null) {
			AwardDebugger = FlxG.save.data.AwardMasterDebugger;
		}
	}
	
	public static function saveAwards()
	{
		//save your awards shit!
		FlxG.save.data.AwardFridayNight = AwardFridayNight;
		FlxG.save.data.AwardWeek1 = AwardWeek1;
		FlxG.save.data.AwardWeek2 = AwardWeek2;
		FlxG.save.data.AwardWeek3 = AwardWeek3;
		FlxG.save.data.AwardWeek4 = AwardWeek4;
		FlxG.save.data.AwardWeek5 = AwardWeek5;
		FlxG.save.data.AwardWeek6 = AwardWeek6;
		FlxG.save.data.AwardGetGood = AwardGetGood;
		FlxG.save.data.AwardDangerZone = AwardDangerZone;
		FlxG.save.data.AwardOsuManiaPlayer = AwardOsuManiaPlayer;
		FlxG.save.data.AwardIsToaster = AwardIsToaster;
		FlxG.save.data.AwardDoubleSided = AwardDoubleSided;
		FlxG.save.data.AwardDebugger = AwardDebugger;
		FlxG.save.data.AwardMasterDebugger = AwardMasterDebugger;
		
		//save the shit!
		FlxG.save.flush();
	}
}
