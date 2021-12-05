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
	private var checkboxGroup:FlxTypedGroup<AttachedAchievement>;
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var checkboxNumber:Array<Int> = [];
	private var checkboxArray:Array<AttachedAchievement> = [];
	var daValue:Bool = false;
	var daDesc:String = '';
	
	// the options for da menu
	var options:Array<Dynamic> = [];

	override function create()
	//public function new()
	{
		var title:String = 'Awards';
		
		Awards.loadAwards();
		
		// menu bg
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
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
			var optionText:Alphabet = new Alphabet(0, 70 * i, Awards.awardsStuff[i][0], false, false, null);
			optionText.isMenuItem = true;
			optionText.x += 300;
			/*optionText.forceX = 300;
			optionText.yMult = 90;*/
			optionText.xAdd = 200;
			optionText.targetY = i;
			grpOptions.add(optionText);
			
			reloadValues(i);
			
			var checkbox:AttachedAchievement = new AttachedAchievement(optionText.x - 105, optionText.y, daValue, Awards.awardsStuff[i][4], Awards.awardsStuff[i][2]);
			checkbox.sprTracker = optionText;
			checkboxNumber.push(i);
			checkboxArray.push(checkbox);
			checkbox.ID = i;
			checkboxGroup.add(checkbox);
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
			Awards.saveAwards();
			FlxG.switchState(new MainMenuState());
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}
		
		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}
		
		descText.text = daDesc;
		
		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		
		descBox.setPosition(descText.x - 10, descText.y - 10);
		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
		
		//reloadValues();
		super.update(elapsed);
	}
	
	function changeSelection(change:Int)
	{
		curSelected += change;
		
		if(curSelected < 0)
			curSelected = Awards.awardsStuff.length - 1;
			
		if(curSelected > Awards.awardsStuff.length - 1)
			curSelected = 0;
			
		daDesc = Awards.awardsStuff[curSelected][1];
		
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
	
	function reloadValues(funnyNumber:Int)
	{
		for (i in 0...checkboxArray.length) {
				daValue = false;
				switch(Awards.awardsStuff[funnyNumber][3]) //uses the tag
				{
					case 'FridayNightPlay':
						daValue = Awards.AwardFridayNight;

					case 'Week1':
						daValue = Awards.AwardWeek1;
						
					case 'Week2':
						daValue = Awards.AwardWeek2;

					case 'Week3':
						daValue = Awards.AwardWeek3;
						
					case 'Week4':
						daValue = Awards.AwardWeek4;

					case 'Week5':
						daValue = Awards.AwardWeek5;
						
					case 'Week6':
						daValue = Awards.AwardWeek6;

					case 'GetGood':
						daValue = Awards.AwardGetGood;
						
					case 'DangerZone':
						daValue = Awards.AwardDangerZone;

					case 'OsuManiaPlayer':
						daValue = Awards.AwardOsuManiaPlayer;
						
					case 'Toaster':
						daValue = Awards.AwardIsToaster;
						
					case 'DoubleSided':
						daValue = Awards.AwardDoubleSided;

					case 'Debugger':
						daValue = Awards.AwardDebugger;
						
					case 'MasterDebugger':
						daValue = Awards.AwardMasterDebugger;				
				}
				checkboxGroup.members[i].daValue = daValue;
		}
	}
}
