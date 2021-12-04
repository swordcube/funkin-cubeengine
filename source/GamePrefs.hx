package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

class GamePrefs
{
	// -- GRAPHICS CATEGORY --
	public static var lowQuality:Bool = false; //Low Quality
	public static var antialiasing:Bool = true; //Anti-Aliasing
	public static var optimization:Bool = false; //Optimization Mode
	public static var toggleFPS:Bool = true; //Toggle FPS Counter
	public static var noteSplashes:Bool = true; //Note Splashes
	public static var customNoteSkin:Bool = false; //Custom Note Skin
	public static var cameraZooms:Bool = true; //Camera Zooms
	
	// -- GAMEPLAY CATEGORY --
	public static var toggleOutdatedWarning:Bool = true; //Toggle Outdated Warning
	public static var ghostTapping:Bool = true; //Ghost Tapping
	public static var downscroll:Bool = true; //Downscroll
	public static var middlescroll:Bool = true; //Middlescroll
	public static var framerate:Int = 60; //Framerate
	public static var arrowUnderlay:Bool = false; //Arrow Underlay
	public static var underlayOpacity:Float = 0.7; //Underlay Opacity
	public static var scrollSpeed:Float = 1; //Scroll Speed
	
	// -- TESTING SHIT --
	public static var checkboxTest:Bool = false;
	public static var numberTest:Float = 1;
	
	// when adding a description, it MUST be in the same order as the variables.
	public static var graphicsDescriptions:Array<String> =
	[
		// -- GRAPHICS CATEGORY --
		"When enabled, Some background elements will disappear.\nYou can get a performance boost with this.", //Low Quality Desc
		"When enabled, The game will run smoother, but the sprites will\nlook less smooth.", //Anti-Aliasing Desc
		"When enabled, The background and characters will disappear.\nYou will get a huge performance boost from this.", //Optimization Desc
		"When disabled, The FPS Counter at the top left will disappear.", //6 - Toggle FPS Counter Desc
		"When enabled, A special effect will play when you hit a \"Sick!\" note.", //Note Splashes Desc
		"When enabled, You can change the look of your notes in the\nNote Skin menu.", //Custom Note Skin Desc
		"When enabled, the camera will zoom to the beat of the song.", //Camera Zooms Desc
	];
	
	public static var gameplayDescriptions:Array<String> =
	[
		// -- GAMEPLAY CATEGORY --
		"When enabled, The game will let you know when\nyour version is outdated.", //Toggle Outdated Warning Desc
		"When disabled, Pressing a note that isn't there will result\nin a miss.", //Ghost Tapping Desc
		"Moves the notes down to the bottom of the screen.\nEnabling this is up to your preference.", //Downscroll Desc
		"Moves the notes down to the middle of the screen.\nEnabling this is up to your preference.", //Middlescroll Desc
		"When enabled, A black background will show behind your arrows.\nThis can help with focus.", //Arrow Underlay Desc
		"Change the opacity of the Arrow Underlay using LEFT & RIGHT.", //Underlay Opacity Desc
		"Change how fast or slow your arrows go using LEFT & RIGHT.\n1 = The speed becomes dependent on the chart.", //Scroll Speed Desc
	];
	
	public static var defaultKeys:Array<FlxKey> = [
		A, LEFT,			//Note Left
		S, DOWN,			//Note Down
		W, UP,				//Note Up
		D, RIGHT,			//Note Right

		A, LEFT,			//UI Left
		S, DOWN,			//UI Down
		W, UP,				//UI Up
		D, RIGHT,			//UI Right

		R, NONE,			//Reset
		SPACE, ENTER,		//Accept
		BACKSPACE, ESCAPE,	//Back
		ENTER, ESCAPE		//Pause
	];
	//Every key has two binds, these binds are defined on defaultKeys! If you want your control to be changeable, you have to add it on ControlsSubState (inside OptionsState)'s list
	public static var keyBinds:Array<Dynamic> = [
		//Key Bind, Name for ControlsSubState
		[Control.NOTE_LEFT, 'Left'],
		[Control.NOTE_DOWN, 'Down'],
		[Control.NOTE_UP, 'Up'],
		[Control.NOTE_RIGHT, 'Right'],

		[Control.UI_LEFT, 'Left '],		//Added a space for not conflicting on ControlsSubState
		[Control.UI_DOWN, 'Down '],		//Added a space for not conflicting on ControlsSubState
		[Control.UI_UP, 'Up '],			//Added a space for not conflicting on ControlsSubState
		[Control.UI_RIGHT, 'Right '],	//Added a space for not conflicting on ControlsSubState

		[Control.RESET, 'Reset'],
		[Control.ACCEPT, 'Accept'],
		[Control.BACK, 'Back'],
		[Control.PAUSE, 'Pause']
	];
	public static var lastControls:Array<FlxKey> = defaultKeys.copy();
	
	public static function loadSettings()
	{
		//load in your save data shit!
		// -- GRAPHICS SHIT --
		if(FlxG.save.data.lowQuality != null) {
			lowQuality = FlxG.save.data.lowQuality;
		}
		
		if(FlxG.save.data.antialiasing != null) {
			antialiasing = FlxG.save.data.antialiasing;
		}
		
		if(FlxG.save.data.optimization != null) {
			optimization = FlxG.save.data.optimization;
		}
		
		if(FlxG.save.data.toggleFPS != null) {
			toggleFPS = FlxG.save.data.toggleFPS;
			if(Main.fpsVar != null) {
				Main.fpsVar.visible = toggleFPS;
			}
		}
		
		if(FlxG.save.data.noteSplashes != null) {
			noteSplashes = FlxG.save.data.noteSplashes;
		}
		
		if(FlxG.save.data.customNoteSkin != null) {
			customNoteSkin = FlxG.save.data.customNoteSkin;
		}
		
		if(FlxG.save.data.cameraZooms != null) {
			cameraZooms = FlxG.save.data.cameraZooms;
		}
		// -- GAMEPLAY SHIT --
		if(FlxG.save.data.toggleOutdatedWarning != null) {
			toggleOutdatedWarning = FlxG.save.data.toggleOutdatedWarning;
		}
		
		if(FlxG.save.data.ghostTapping != null) {
			ghostTapping = FlxG.save.data.ghostTapping;
		}
		
		if(FlxG.save.data.downscroll != null) {
			downscroll = FlxG.save.data.downscroll;
		}
		
		if(FlxG.save.data.middlescroll != null) {
			middlescroll = FlxG.save.data.middlescroll;
		}
		
		if(FlxG.save.data.framerate != null) {
			framerate = FlxG.save.data.framerate;
			if(framerate > FlxG.drawFramerate) {
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			} else {
				FlxG.drawFramerate = framerate;
				FlxG.updateFramerate = framerate;
			}
		}
		
		if(FlxG.save.data.arrowUnderlay != null) {
			arrowUnderlay = FlxG.save.data.arrowUnderlay;
		}
		
		if(FlxG.save.data.underlayOpacity != null) {
			underlayOpacity = FlxG.save.data.underlayOpacity;
		}
		
		if(FlxG.save.data.scrollSpeed != null) {
			scrollSpeed = FlxG.save.data.scrollSpeed;
		}	
		
		// load volume lol
		if(FlxG.save.data.volume != null) {
			FlxG.sound.volume = FlxG.save.data.volume;
		}
		if (FlxG.save.data.mute != null) {
			FlxG.sound.muted = FlxG.save.data.mute;
		}
	}
	
	public static function saveSettings()
	{
		//save your save data shit!
		//-- GRAPHICS SHIT --
		FlxG.save.data.lowQuality = lowQuality;
		FlxG.save.data.antialiasing = antialiasing;
		FlxG.save.data.optimization = optimization;
		FlxG.save.data.toggleFPS = toggleFPS;
		FlxG.save.data.noteSplashes = noteSplashes;
		FlxG.save.data.customNoteSkin = customNoteSkin;
		FlxG.save.data.cameraZooms = cameraZooms;
		//-- GAMEPLAY SHIT --
		FlxG.save.data.toggleOutdatedWarning = toggleOutdatedWarning;
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.downscroll = downscroll;
		FlxG.save.data.middlescroll = middlescroll;
		FlxG.save.data.framerate = framerate;
		FlxG.save.data.arrowUnderlay = arrowUnderlay;
		FlxG.save.data.underlayOpacity = underlayOpacity;
		FlxG.save.data.scrollSpeed = scrollSpeed;
		
		//save the shit!
		FlxG.save.flush();
		
		//save controls or something!
		var save:FlxSave = new FlxSave();
		save.bind('controls', 'ninjamuffin99');
		if(save != null && save.data.customControls != null) {
			reloadControls(save.data.customControls);
		}
	}
	
	public static function reloadControls(newKeys:Array<FlxKey>) {
		GamePrefs.removeControls(GamePrefs.lastControls);
		GamePrefs.lastControls = newKeys.copy();
		GamePrefs.loadControls(GamePrefs.lastControls);
	}

	private static function removeControls(controlArray:Array<FlxKey>) {
		for (i in 0...keyBinds.length) {
			var controlValue:Int = i*2;
			var controlsToRemove:Array<FlxKey> = [];
			for (j in 0...2) {
				if(controlArray[controlValue+j] != NONE) {
					controlsToRemove.push(controlArray[controlValue+j]);
				}
			}
			if(controlsToRemove.length > 0) {
				PlayerSettings.player1.controls.unbindKeys(keyBinds[i][0], controlsToRemove);
			}
		}
	}
	private static function loadControls(controlArray:Array<FlxKey>) {
		for (i in 0...keyBinds.length) {
			var controlValue:Int = i*2;
			var controlsToAdd:Array<FlxKey> = [];
			for (j in 0...2) {
				if(controlArray[controlValue+j] != NONE) {
					controlsToAdd.push(controlArray[controlValue+j]);
				}
			}
			if(controlsToAdd.length > 0) {
				PlayerSettings.player1.controls.bindKeys(keyBinds[i][0], controlsToAdd);
			}
		}
	}
}
