package;

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

class AwardsState extends MusicBeatState
{
	private static var curSelected:Int = -1;
	public static var menuBG:FlxSprite;
	public static var descText:FlxText;
	public static var descBox:FlxSprite;
	public static var intendedColor:Int;
	public static var colorTween:FlxTween;
	private var checkboxGroup:FlxTypedGroup<AttachedAchievement>;
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var checkboxNumber:Array<Int> = [];
	private var checkboxArray:Array<AttachedAchievement> = [];
	var daValue:Bool = false;
	var daDesc:String = '';
	var newColor:Int = 0;
	
	// the options for da menu
	var options:Array<Dynamic> = [];

	override function create()
	//public function new()
	{
		var title:String = 'Awards';
		
		Awards.loadAwards();
		
		// menu bg
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = GamePrefs.antialiasing;
		add(menuBG);
		
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		checkboxGroup = new FlxTypedGroup<AttachedAchievement>();
		add(checkboxGroup);
		
		curSelected = -1;
		
		for (i in 0...Awards.awardsStuff.length)
		{
			if(Awards.awardsStuff[i][5] == false || Awards.awardsStuff[i][5] == true && Awards.awardsUnlocked[i] == true) {
				var optionText:Alphabet = new Alphabet(0, 70 * i, Awards.awardsStuff[i][0], false, false, null);
				optionText.isMenuItem = true;
				optionText.x += 300;
				/*optionText.forceX = 300;
				optionText.yMult = 90;*/
				optionText.xAdd = 200;
				optionText.targetY = i;
				grpOptions.add(optionText);
				
				//reloadValues();
				
				var checkbox:AttachedAchievement = new AttachedAchievement(optionText.x - 105, optionText.y, false, Awards.awardsStuff[i][4], Awards.awardsStuff[i][2]);
				checkbox.sprTracker = optionText;
				checkboxNumber.push(i);
				checkboxArray.push(checkbox);
				checkbox.ID = i;
				checkboxGroup.add(checkbox);
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
		
		menuBG.color = 0xFF2e2f30;
		intendedColor = menuBG.color;
		
		changeSelection(1);
		
		super.create();
	}

	var nextAccept:Int = 5;
	var holdTime:Float = 0;
	var allowAwardsCheat:Bool = true;
	
	override function update(elapsed:Float)
	{
		menuBG.antialiasing = GamePrefs.antialiasing;
		
		if (controls.BACK) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.switchState(new MainMenuState());
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}
		
		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}
		
		if (FlxG.keys.justPressed.SPACE && allowAwardsCheat) {
			if(Awards.awardsUnlocked[checkboxNumber[curSelected]] == true) {
				Awards.awardsUnlocked[checkboxNumber[curSelected]] = false;
			} else {
				Awards.awardsUnlocked[checkboxNumber[curSelected]] = true;
			}
			changeSelection();
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
	
	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		
		if(curSelected < 0)
			curSelected = grpOptions.members.length - 1;
			
		if(curSelected > grpOptions.members.length - 1)
			curSelected = 0;
			
		if(Awards.awardsUnlocked[checkboxNumber[curSelected]] == true) {
			newColor = getCurrentBGColor();
		} else {
			newColor = 0xFF2e2f30;
		}
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(menuBG, 1, menuBG.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}
			
		daDesc = Awards.awardsStuff[checkboxNumber[curSelected]][1];
		
		var bullShit:Int = 0;

		for (item in grpOptions.members) {
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
			var checkbox:AttachedAchievement = checkboxArray[i];
			if(checkbox != null) {
				daValue = Awards.awardsUnlocked[checkboxNumber[i]];
				checkboxGroup.members[i].unlocked = daValue;
			}
		}
	}
	
	function getCurrentBGColor() {
		var bgColor:Int = Awards.awardsStuff[checkboxNumber[curSelected]][6];
		return /*Std.parseInt(*/bgColor/*)*/;
	}
}
