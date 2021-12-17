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
	public static var flashingLightsWarning:Bool = true; //Flashing Lights Warning, can't be changed through normal means
	public static var flashingLights:Bool = true; //Flashing Lights
	public static var lowQuality:Bool = false; //Low Quality
	public static var antialiasing:Bool = true; //Anti-Aliasing
	public static var optimization:Bool = false; //Optimization Mode
	public static var toggleFPS:Bool = true; //Toggle FPS Counter
	public static var noteSplashes:Bool = true; //Note Splashes
	public static var cameraZooms:Bool = true; //Camera Zooms
	public static var opponentArrowOpacity:Float = 1; //Opponent Arrow Opacity
	
	// -- GAMEPLAY CATEGORY --
	public static var toggleOutdatedWarning:Bool = true; //Toggle Outdated Warning
	public static var ghostTapping:Bool = true; //Ghost Tapping
	public static var downscroll:Bool = false; //Downscroll
	public static var middlescroll:Bool = false; //Middlescroll
	public static var hitSounds:Bool = false; //Hit Sounds but legacy
	
	public static var selectedHitsound:Int = 0; //Hit Sound but like you can change it :hue:
	
	public static var selectableHitsounds:Array<Dynamic> = [ // Selectable Hitsounds
		// Format: File Name, Display Name
		['None', 'None'],
		['osu!', 'osu!'],
		['Tap', 'Tap'],
		['VineBoom', 'Vine Boom'],
	];
	
	public static var framerate:Int = 60; //Framerate
	public static var noteOffset:Float = 0; //Note Offset
	public static var arrowUnderlay:Bool = false; //Arrow Underlay
	public static var underlayOpacity:Float = 0.7; //Underlay Opacity
	public static var scrollSpeed:Float = 1; //Scroll Speed
	public static var songTimeBar:Bool = true; //Song Time Bar
	
	// -- OTHER SHITS --
	public static var noteShit:Array<Dynamic> = [  //Custom Note Shit
		[[0, 0, 0], 'NOTE'], //left
		[[0, 0, 0], 'NOTE'], //down
		[[0, 0, 0], 'NOTE'], //up
		[[0, 0, 0], 'NOTE']  //right
	]; 
	
	// -- TESTING SHIT --
	public static var checkboxTest:Bool = false;
	public static var numberTest:Float = 1;
	
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
		if(FlxG.save.data.flashingLightsWarning != null) {
			flashingLightsWarning = FlxG.save.data.flashingLightsWarning;
		}
		
		if(FlxG.save.data.flashingLights != null) {
			flashingLights = FlxG.save.data.flashingLights;
		}
		
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
		
		if(FlxG.save.data.hitSounds != null) {
			hitSounds = FlxG.save.data.hitSounds;
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
		
		if(FlxG.save.data.noteOffset != null) {
			noteOffset = FlxG.save.data.noteOffset;
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
		
		if(FlxG.save.data.songTimeBar != null) {
			songTimeBar = FlxG.save.data.songTimeBar;
		}

		if(FlxG.save.data.opponentArrowOpacity != null) {
			opponentArrowOpacity = FlxG.save.data.opponentArrowOpacity;
		}
		
		//other
		if(FlxG.save.data.noteShit != null) {
			noteShit = FlxG.save.data.noteShit;
		}
		if(FlxG.save.data.selectedHitsound != null) {
			selectedHitsound = FlxG.save.data.selectedHitsound;
		}
		
		// load volume lol
		if(FlxG.save.data.volume != null) {
			FlxG.sound.volume = FlxG.save.data.volume;
		}
		if (FlxG.save.data.mute != null) {
			FlxG.sound.muted = FlxG.save.data.mute;
		}
		
		// load controls!!!!
		
		var save:FlxSave = new FlxSave();
		save.bind('controls', 'ninjamuffin99');
		if(save != null && save.data.customControls != null) {
			reloadControls(save.data.customControls);
		}
	}
	
	public static function saveSettings()
	{
		//save your save data shit!
		//-- GRAPHICS SHIT --
		FlxG.save.data.flashingLightsWarning = flashingLightsWarning;
		FlxG.save.data.flashingLights = flashingLights;
		FlxG.save.data.lowQuality = lowQuality;
		FlxG.save.data.antialiasing = antialiasing;
		FlxG.save.data.optimization = optimization;
		FlxG.save.data.toggleFPS = toggleFPS;
		FlxG.save.data.noteSplashes = noteSplashes;
		FlxG.save.data.cameraZooms = cameraZooms;
		//-- GAMEPLAY SHIT --
		FlxG.save.data.toggleOutdatedWarning = toggleOutdatedWarning;
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.downscroll = downscroll;
		FlxG.save.data.middlescroll = middlescroll;
		FlxG.save.data.hitSounds = hitSounds;
		FlxG.save.data.framerate = framerate;
		FlxG.save.data.noteOffset = noteOffset;
		FlxG.save.data.arrowUnderlay = arrowUnderlay;
		FlxG.save.data.underlayOpacity = underlayOpacity;
		FlxG.save.data.scrollSpeed = scrollSpeed;
		FlxG.save.data.songTimeBar = songTimeBar;
		FlxG.save.data.opponentArrowOpacity = opponentArrowOpacity;
		
		FlxG.save.data.noteShit = noteShit;
		FlxG.save.data.selectedHitsound = selectedHitsound;

		//save the shit!
		FlxG.save.flush();
		
		//save controls or something!
		var save:FlxSave = new FlxSave();
		save.bind('controls', 'ninjamuffin99'); //Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		save.data.customControls = lastControls;
		save.flush();
		FlxG.log.add("Settings saved!");
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
