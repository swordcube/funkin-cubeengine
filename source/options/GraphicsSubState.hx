package options;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

class GraphicsSubState extends MusicBeatSubstate
{
	private static var curSelected:Int = -1;
	public static var menuBG:FlxSprite;
	public static var descText:FlxText;
	public static var descBox:FlxSprite;
	private var checkboxGroup:FlxTypedGroup<Checkbox>;
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var checkboxNumber:Array<Int> = [];
	private var checkboxArray:Array<Checkbox> = [];
	private var textNumber:Array<Int> = [];
	private var grpTexts:FlxTypedGroup<AttachedText>;
	var daValue:Bool = false;
	var daDesc:String = '';
	
	// the options for da menu
	var options:Array<Dynamic> = [
		//Slot 1 - Option Name
		//Slot 2 - Option Description
		['Flashing Lights', "When enabled, Flashing lights from places like menus,\nand gameplay should be gone."],
		['Low Quality', "When enabled, Some background elements will disappear.\nYou can get a performance boost with this."],
		['Anti-Aliasing', "When disabled, The game will run smoother, but the sprites\nwill look less smooth."],
		['Optimization', "When enabled, The background and characters will disappear.\nYou will get a huge performance boost from this."],
		['Toggle FPS Counter', "When disabled, The FPS Counter at the top left will disappear."],
		['Note Splashes', "When enabled, A special effect will play when you hit a \"Sick!\" note."],
		['Custom Note Skin', "When enabled, You can change the look of your notes in the\nNote Skin menu."],
		['Camera Zooms', "When enabled, the camera will zoom to the beat of the song."],
		/*['number test', "press left & right to change\nthis is for testing only"],
		['checkbox test', "press enter to toggle\nthis is for testing only"],*/
	];
	
	var noCheckboxOptions:Array<String> = [
		//put shit here if it shouldn't have a checkbox
		//put the option name only, nothing else
		//'number test',
	];

	override function create()
	//public function new()
	{
		var title:String = 'Graphics Settings';
		
		// menu bg
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = GamePrefs.antialiasing;
		add(menuBG);
		
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		grpTexts = new FlxTypedGroup<AttachedText>();
		add(grpTexts);

		checkboxGroup = new FlxTypedGroup<Checkbox>();
		add(checkboxGroup);
		
		curSelected = -1;
		
		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 70 * i, options[i][0], false, false, null);
			optionText.isMenuItem = true;
			optionText.x += 300;
			/*optionText.forceX = 300;
			optionText.yMult = 90;*/
			optionText.xAdd = 200;
			optionText.targetY = i;
			grpOptions.add(optionText);
			
			reloadValues();
			
			var useCheckbox:Bool = true;
			for (j in 0...noCheckboxOptions.length) {
				if(options[i][0] == noCheckboxOptions[j]) {
					useCheckbox = false;
					break;
				}
			}

			if(useCheckbox) {
				var checkbox:Checkbox = new Checkbox(optionText.x - 105, optionText.y, daValue == true);
				checkbox.sprTracker = optionText;
				checkboxNumber.push(i);
				checkboxArray.push(checkbox);
				checkbox.ID = i;
				checkboxGroup.add(checkbox);
			} else {
				optionText.x -= 80;
				optionText.xAdd -= 80;
				var valueText:AttachedText = new AttachedText('0', optionText.width + 80);
				valueText.sprTracker = optionText;
				valueText.copyAlpha = true;
				valueText.ID = i;
				grpTexts.add(valueText);
				textNumber.push(i);
			}
		}

		descBox = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		descBox.alpha = 0.6;
		add(descBox);
		
		var titleText:Alphabet = new Alphabet(0, 0, title, true, false, 0, 0.6);
		titleText.x += 60;
		titleText.y += 40;
		titleText.alpha = 0.4;
		add(titleText);

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);
		
		changeSelection(1);
		
		super.create();
	}

	var nextAccept:Int = 5;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		menuBG.antialiasing = GamePrefs.antialiasing;
	
		if (controls.BACK) {
			GamePrefs.saveSettings();
			close();
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}
		
		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}
		
		var useCheckbox = true;
		for (i in 0...noCheckboxOptions.length) {
			if(options[curSelected][0] == noCheckboxOptions[i]) {
				useCheckbox = false;
				break;
			}
		}
		
		if(useCheckbox) {
			if (controls.ACCEPT && nextAccept <= 0) {
				switch(options[curSelected][0]) {
					case 'Flashing Lights':
						GamePrefs.flashingLights = !GamePrefs.flashingLights;	
			
					case 'Low Quality':
						GamePrefs.lowQuality = !GamePrefs.lowQuality;
						
					case 'Anti-Aliasing':
						GamePrefs.antialiasing = !GamePrefs.antialiasing;
						
						for (item in grpOptions) {
							item.antialiasing = GamePrefs.antialiasing;
						}
						for (i in 0...checkboxGroup.members.length) {
							checkboxGroup.members[i].antialiasing = GamePrefs.antialiasing;
						}
						OptionsState.menuBG.antialiasing = GamePrefs.antialiasing;
						
					case 'Optimization':
						GamePrefs.optimization = !GamePrefs.optimization;
						
					case 'Toggle FPS Counter':
						GamePrefs.toggleFPS = !GamePrefs.toggleFPS;
						if(Main.fpsVar != null)
							Main.fpsVar.visible = GamePrefs.toggleFPS;
						
					case 'Note Splashes':
						GamePrefs.noteSplashes = !GamePrefs.noteSplashes;
						
					case 'Custom Note Skin':
						GamePrefs.customNoteSkin = !GamePrefs.customNoteSkin;
						
					case 'Camera Zooms':
						GamePrefs.cameraZooms = !GamePrefs.cameraZooms;
						
					case 'checkbox test':
						GamePrefs.checkboxTest = !GamePrefs.checkboxTest;
				}
				FlxG.sound.play(Paths.sound('scrollMenu'));
				reloadValues();
			}
		} else {
			if(controls.UI_LEFT || controls.UI_RIGHT) {
				var add:Int = controls.UI_LEFT ? -1 : 1;
				if(holdTime > 0.5 || controls.UI_LEFT_P || controls.UI_RIGHT_P)
				switch(options[curSelected][0]) {
					case 'number test':
						GamePrefs.numberTest += add;
						if(GamePrefs.numberTest < 1) GamePrefs.numberTest = 1;
						if(GamePrefs.numberTest > 99) GamePrefs.numberTest = 99;
				}
				reloadValues();
				
				if(holdTime <= 0) FlxG.sound.play(Paths.sound('scrollMenu'));
				holdTime += elapsed;
			} else {
				holdTime = 0;
			}
		}
		
		descText.text = daDesc;
		
		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		
		descBox.setPosition(descText.x - 10, descText.y - 10);
		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
		
		reloadValues();
		super.update(elapsed);
	}
	
	function changeSelection(change:Int)
	{
		curSelected += change;
		
		if(curSelected < 0)
			curSelected = options.length - 1;
			
		if(curSelected > options.length - 1)
			curSelected = 0;
			
		daDesc = options[curSelected][1];
		
		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
			}
		}
		
		for (item in grpTexts.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
			}
		}
		
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
	
	function reloadValues()
	{
		for (i in 0...checkboxArray.length) {
			var checkbox:Checkbox = checkboxArray[i];
			if(checkbox != null) {
				daValue = false;
				switch(options[checkboxNumber[i]][0])
				{
					case 'Flashing Lights':
						daValue = GamePrefs.flashingLights;
						
					case 'Low Quality':
						daValue = GamePrefs.lowQuality;
						
					case 'Anti-Aliasing':
						daValue = GamePrefs.antialiasing;
						
					case 'Optimization':
						daValue = GamePrefs.optimization;
						
					case 'Toggle FPS Counter':
						daValue = GamePrefs.toggleFPS;
						
					case 'Note Splashes':
						daValue = GamePrefs.noteSplashes;
						
					case 'Custom Note Skin':
						daValue = GamePrefs.customNoteSkin;
						
					case 'Camera Zooms':
						daValue = GamePrefs.cameraZooms;
						
					case 'checkbox test':
						daValue = GamePrefs.checkboxTest;
				}
				checkboxGroup.members[i].daValue = daValue;
			}
		}
		
		for (i in 0...grpTexts.members.length) {
			var text:AttachedText = grpTexts.members[i];
			if(text != null) {
				var daText:String = '';
				switch(options[textNumber[i]][0])
				{
					case 'number test':
						daText = GamePrefs.numberTest+"";
				}
				var lastTracker:FlxSprite = text.sprTracker;
				text.sprTracker = null;
				text.changeText(daText);
				text.sprTracker = lastTracker;
			}
		}
	}
}
