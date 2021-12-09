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

class CreditsState extends MusicBeatState
{
	public static var menuBG:FlxSprite;
	public static var descText:FlxText;
	public static var descBox:FlxSprite;
	private var grpText:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	public static var daDesc:String = '';
	public static var intendedColor:Int;
	public static var colorTween:FlxTween;
	public static var curSelected:Int = 1;
	
	// for title type
	// type / title
	
	// for credit type
	// type / icon / title / desc / color / link
	
	public static var creditsStuff:Array<Dynamic> = [
		["The Funkin' Crew"],
		["Ninjamuffin99", "ninjamuffin99", "Programmer of Friday Night Funkin'", 'F73838', 'https://twitter.com/swordcube', "base-game/"],
		["PhantomArcade", "phantomarcade", "Animator of Friday Night Funkin'", 'FFBB1B', 'https://twitter.com/swordcube', "base-game/"],
		["evilsk8r", "evilsk8r", "Artist of Friday Night Funkin", '53E52C', 'https://twitter.com/swordcube', "base-game/"],
		["KawaiSprite", "kawaisprite", "Musician of Friday Night Funkin'", '6475F3', 'https://twitter.com/swordcube', "base-game/"],
		[""],
		["Cube Engine Team"],
		["swordcube", "swordcube", "Programmer of Cube Engine", '6475F3', 'https://twitter.com/swordcube', "cube-team/"],
		["Raf", "raf", "Added Middlescroll and Note Splashes", '38261B', 'https://twitter.com/swordcube', "cube-team/"],
		["Vienna", "vienna", "Suggested the health percentage at the top of\nthe health bar thingy", 'E6B04C', 'https://twitter.com/swordcube', "cube-team/"],
	];
	
	override function create()
	//public function new()
	{
		var title:String = 'Credits';

		// menu bg
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = GamePrefs.antialiasing;
		add(menuBG);
		
		grpText = new FlxTypedGroup<Alphabet>();
		add(grpText);
		
		curSelected = 1;
		
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var titleText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false, null);
			titleText.isMenuItem = true;
			titleText.screenCenter(X);
			titleText.yAdd -= 70;
			if(isSelectable) {
				titleText.x -= 70;
			}
			titleText.forceX = titleText.x;
			//titleText.yMult = 90;
			titleText.targetY = i;
			grpText.add(titleText);
			
			if(isSelectable) {
				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][5] + creditsStuff[i][1]);
				icon.xAdd = titleText.width + 10;
				icon.sprTracker = titleText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
				
				if(curSelected == -1) curSelected = i;
			}
		}
		
		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);
		
		menuBG.color = getCurrentBGColor();
		intendedColor = menuBG.color;
		
		changeSelection();
		
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}
		if(controls.ACCEPT) {
			CoolUtil.browserLoad(creditsStuff[curSelected][4]);
		}
		super.update(elapsed);
	}
	
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int = getCurrentBGColor();
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

		var bullShit:Int = 0;

		for (item in grpText.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}
		descText.text = creditsStuff[curSelected][2];
	}
	
	function getCurrentBGColor() {
		var bgColor:String = creditsStuff[curSelected][3];
		bgColor = '0xFF' + bgColor;
		return Std.parseInt(bgColor);
	}
	
	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
