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

class GameplaySubState extends MusicBeatSubstate
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
		['Toggle Outdated Warning', "When enabled, The game will let you know when\nyour version is outdated."],
		['Ghost Tapping', "When disabled, Pressing a note that isn't there will result\nin a miss."],
		['Downscroll', "Moves the notes down to the bottom of the screen.\nEnabling this is up to your preference."],
		['Middlescroll', "Moves the notes to the the middle of the screen.\nEnabling this is up to your preference."],
		['Hit Sounds', "When enabled, a sound will play when you hit a note."],
		['Framerate', "Changes how fast or slow the game itself runs."],
		['Note Offset', "Changes how early or late your notes appear."],
		['Arrow Underlay', "When enabled, A black background will show behind your arrows.\nThis can help with focus."],
		['Underlay Opacity', "Change the opacity of the Arrow Underlay using LEFT & RIGHT."],
		['Scroll Speed', "Change how fast or slow your arrows go using LEFT & RIGHT.\n1 = The speed becomes dependent on the chart."],
		/*['number test', "press left & right to change\nthis is for testing only"],
		['checkbox test', "press enter to toggle\nthis is for testing only"],*/
	];
	
	var noCheckboxOptions:Array<String> = [
		//put shit here if it shouldn't have a checkbox
		//put the option name only, nothing else
		//'number test',
		'Underlay Opacity',
		'Scroll Speed',
		'Framerate',
		'Note Offset',
	];

	override function create()
	//public function new()
	{
		var title:String = 'Gameplay Settings';
		
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
					case 'Toggle Outdated Warning':
						GamePrefs.toggleOutdatedWarning = !GamePrefs.toggleOutdatedWarning;
						
					case 'Ghost Tapping':
						GamePrefs.ghostTapping = !GamePrefs.ghostTapping;
						
					case 'Downscroll':
						GamePrefs.downscroll = !GamePrefs.downscroll;
						
					case 'Middlescroll':
						GamePrefs.middlescroll = !GamePrefs.middlescroll;
						
					case 'Hit Sounds':
						GamePrefs.hitSounds = !GamePrefs.hitSounds;
						
					// framerate would be here but isn't because it isn't a checkbox.
				
					case 'Arrow Underlay':
						GamePrefs.arrowUnderlay = !GamePrefs.arrowUnderlay;
						
					// underlay opacity would be here but isn't because it isn't a checkbox.
				
					// scroll speed would be here but isn't because it isn't a checkbox.
						
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
					case 'Framerate':
						GamePrefs.framerate += add;
						if(GamePrefs.framerate < 60) GamePrefs.framerate = 60;
						if(GamePrefs.framerate > 240) GamePrefs.framerate = 240;
						
						if(GamePrefs.framerate > FlxG.drawFramerate) {
							FlxG.updateFramerate = GamePrefs.framerate;
							FlxG.drawFramerate = GamePrefs.framerate;
						} else {
							FlxG.drawFramerate = GamePrefs.framerate;
							FlxG.updateFramerate = GamePrefs.framerate;
						}
						
					case 'Underlay Opacity':
						GamePrefs.underlayOpacity += add/20;
						
						if(GamePrefs.underlayOpacity < 0.1) {
							GamePrefs.underlayOpacity = 0.7;
							GamePrefs.arrowUnderlay = false;
						}
						if(GamePrefs.underlayOpacity > 1) GamePrefs.underlayOpacity = 1;
						
					case 'Scroll Speed':
						GamePrefs.scrollSpeed += add/10;
						if(GamePrefs.scrollSpeed < 1) GamePrefs.scrollSpeed = 1;
						if(GamePrefs.scrollSpeed > 10) GamePrefs.scrollSpeed = 10;
						
					case 'Note Offset':
						GamePrefs.noteOffset += add/10;
						if(GamePrefs.noteOffset < 0) GamePrefs.noteOffset = 0;
						if(GamePrefs.noteOffset > 999) GamePrefs.noteOffset = 999;
						
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
					case 'Toggle Outdated Warning':
						daValue = GamePrefs.toggleOutdatedWarning;
						
					case 'Ghost Tapping':
						daValue = GamePrefs.ghostTapping;
						
					case 'Downscroll':
						daValue = GamePrefs.downscroll;
						
					case 'Middlescroll':
						daValue = GamePrefs.middlescroll;
						
					case 'Hit Sounds':
						daValue = GamePrefs.hitSounds;
						
					case 'Arrow Underlay':
						daValue = GamePrefs.arrowUnderlay;
						
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
					case 'Framerate':
						daText = GamePrefs.framerate+"";
						
					case 'Underlay Opacity':
						daText = FlxMath.roundDecimal(GamePrefs.underlayOpacity, 2)+"";
					
					case 'Scroll Speed':
						daText = FlxMath.roundDecimal(GamePrefs.scrollSpeed, 2)+"";
						
					case 'Note Offset':
						daText = FlxMath.roundDecimal(GamePrefs.noteOffset, 2)+"";
						
					case 'number test':
						daText = FlxMath.roundDecimal(GamePrefs.numberTest, 2)+"";
				}
				var lastTracker:FlxSprite = text.sprTracker;
				text.sprTracker = null;
				text.changeText(daText);
				text.sprTracker = lastTracker;
			}
		}
	}
}
