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

using StringTools;

class NoteColorsSubState extends MusicBeatSubstate
{
	private var curSelected:Int = 0;
	private var funnyNotes:FlxTypedGroup<FlxSprite>;
	private var skin:String = 'NOTE';
	private var menuBG:FlxSprite;
	private var comedyArrows:FlxSprite;
	private var descText:FlxText;
	private var colorTextFunny:Alphabet;
	private var colorTextNum1:Alphabet;
	private var colorTextNum2:Alphabet;
	private var colorTextNum3:Alphabet;
	private var shaderArray:Array<ColorSwap> = [];
	
	private var noteSelectedInt = 0;
	var stupidState:String = 'ChooseNote';
	var pissFard:Int = 0;
	var daDesc:String = '';
	//private var notesY:Float = 160;
	
	override function create()
	{
		// menu bg
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = GamePrefs.antialiasing;
		add(menuBG);
		
		comedyArrows = new FlxSprite().loadGraphic(Paths.image('funnyUpDownArrows'));
		comedyArrows.antialiasing = GamePrefs.antialiasing;
		comedyArrows.screenCenter(Y);
		add(comedyArrows);
		
		funnyNotes = new FlxTypedGroup<FlxSprite>();
		add(funnyNotes);
		
		for (i in 0...4) {
			var note:FlxSprite = new FlxSprite(1, 1);
			note.frames = Paths.getSparrowAtlas('noteskins/' + skin + '_assets');
			switch(i) {
				case 0:
					note.animation.addByPrefix('idle', 'purple0');
				case 1:
					note.animation.addByPrefix('idle', 'blue0');
				case 2:
					note.animation.addByPrefix('idle', 'green0');
				case 3:
					note.animation.addByPrefix('idle', 'red0');
			}
			note.animation.play('idle');
			note.antialiasing = GamePrefs.antialiasing;
			note.screenCenter(Y);
			funnyNotes.add(note);	
			
			var newShader:ColorSwap = new ColorSwap();
			note.shader = newShader.shader;
			newShader.hue = GamePrefs.noteShit[i][0][0] / 360;
			newShader.saturation = GamePrefs.noteShit[i][0][1] / 100;
			newShader.brightness = GamePrefs.noteShit[i][0][2] / 100;
			shaderArray.push(newShader);
		}
		
		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);
		
		colorTextFunny = new Alphabet(0, 20, "Hue     Sat     Brt", false, false, 0, 0.6);
		colorTextFunny.screenCenter(X);
		add(colorTextFunny);
		
		colorTextNum1 = new Alphabet(0, 80, "0", false, false, 0, 1);
		colorTextNum1.screenCenter(X);
		colorTextNum1.x -= 175;
		colorTextNum1.forceX = colorTextNum1.x;
		add(colorTextNum1);
		
		colorTextNum2 = new Alphabet(0, 80, "0", false, false, 0, 1);
		colorTextNum2.screenCenter(X);
		add(colorTextNum2);
		
		colorTextNum3 = new Alphabet(0, 80, "0", false, false, 0, 1);
		colorTextNum3.screenCenter(X);
		colorTextNum3.x += 175;
		colorTextNum3.forceX = colorTextNum3.x;
		add(colorTextNum3);
		
		changeArrowSelection(0);
		
		super.create();
	}

	var nextAccept:Int = 5;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (controls.BACK) {
			stupidState = 'ChooseNote';
			close();
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}
		
		if (controls.UI_LEFT_P) {
			switch(stupidState)
			{
				case 'ChooseNote':
					changeArrowSelection(-1);
				case 'ChooseColor':
					changeHSVSelection(-1);
			}
		}
		
		if (controls.UI_RIGHT_P) {
			switch(stupidState)
			{
				case 'ChooseNote':
					changeArrowSelection(1);
				case 'ChooseColor':
					changeHSVSelection(1);
			}
		}
		
		if (controls.UI_LEFT || controls.UI_RIGHT) {
			var add:Int = controls.UI_LEFT ? -1 : 1;
			if(holdTime > 0.5 || controls.UI_LEFT_P || controls.UI_RIGHT_P)
			switch(stupidState)
			{
				case 'ModifyColor':
					changeHSV(add);
			}
			
			if(holdTime <= 0) FlxG.sound.play(Paths.sound('scrollMenu'));
			holdTime += elapsed;	
		} else {
			holdTime = 0;
		}
		
		if (controls.ACCEPT && nextAccept <= 0) {
			switch(stupidState)
			{
				case 'ChooseNote':
					stupidState = 'ChooseColor';
					FlxG.sound.play(Paths.sound('confirmMenu'));
					
				case 'ChooseColor':
					stupidState = 'ModifyColor';
					changeArrowSelection(0, true);
					FlxG.sound.play(Paths.sound('confirmMenu'));
					
				case 'ModifyColor':
					stupidState = 'ChooseNote';
					changeArrowSelection(0);
					FlxG.sound.play(Paths.sound('confirmMenu'));
			}
		}
		
		for (i in 0...funnyNotes.length) {
			var item = funnyNotes.members[i];
			item.x = (135 * i) + 375;
			item.setGraphicSize(Std.int(item.width * 0.8));
			item.color = FlxColor.fromHSB(GamePrefs.noteShit[i][0][0]/360, GamePrefs.noteShit[i][0][1]/100, (GamePrefs.noteShit[i][0][2]+100)/100, 1);
		}
		
		comedyArrows.visible = false;
		
		colorTextNum1.changeText(GamePrefs.noteShit[curSelected][0][0]+"", 0);
		colorTextNum2.changeText(GamePrefs.noteShit[curSelected][0][1]+"", 0);
		colorTextNum3.changeText(GamePrefs.noteShit[curSelected][0][2]+100+"", 0);
		
		colorTextNum1.alpha = 1;
		colorTextNum2.alpha = 1;
		colorTextNum3.alpha = 1;
		
		switch(stupidState)
		{
			case 'ChooseNote':
				descText.text = 'Select a note to modify by pressing LEFT or RIGHT.\nThen press ACCEPT.';
				comedyArrows.visible = true;
				
			case 'ChooseColor':
				descText.text = 'Select which HSB value to modify by pressing LEFT or RIGHT.\nThen press ACCEPT to start modifying.';
				colorTextNum1.alpha = (pissFard == 0 ? 1 : 0.6);
				colorTextNum2.alpha = (pissFard == 1 ? 1 : 0.6);
				colorTextNum3.alpha = (pissFard == 2 ? 1 : 0.6);
				
			case 'ModifyColor':
				descText.text = 'Press LEFT or RIGHT to modify the value.\nThen press ACCEPT to finish.';
				colorTextNum1.alpha = (pissFard == 0 ? 1 : 0.6);
				colorTextNum2.alpha = (pissFard == 1 ? 1 : 0.6);
				colorTextNum3.alpha = (pissFard == 2 ? 1 : 0.6);
				
			default:
				descText.text = '';
		}
		
		comedyArrows.x = funnyNotes.members[curSelected].x + 35;
		
		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		
		super.update(elapsed);
	}
	
	function changeArrowSelection(change:Int, ?hellTime:Bool)
	{
		curSelected += change;
		
		if(curSelected < 0)
			curSelected = funnyNotes.members.length - 1;
			
		if(curSelected > funnyNotes.members.length - 1)
			curSelected = 0;
			
		var bullShit:Int = 0;

		for (item in funnyNotes.members) {
			item.alpha = 0.6;
			if(hellTime != null && hellTime) item.alpha = 0;
			if (curSelected == bullShit) {
				item.alpha = 1;
			}
			bullShit++;
		}
		
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
	
	function changeHSVSelection(change:Int)
	{
		pissFard += change;
		
		if(pissFard < 0)
			pissFard = 2;
			
		if(pissFard > 2)
			pissFard = 0;

		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
	
	function changeHSV(change:Int)
	{
		GamePrefs.noteShit[curSelected][0][pissFard] += change;
			
		shaderArray[curSelected].hue = GamePrefs.noteShit[curSelected][0][0] / 360;
		shaderArray[curSelected].saturation = GamePrefs.noteShit[curSelected][0][1] / 100;
		shaderArray[curSelected].brightness = GamePrefs.noteShit[curSelected][0][2] / 100;
		
		if(GamePrefs.noteShit[curSelected][0][0] < 0)
			GamePrefs.noteShit[curSelected][0][0] = 0;
		if(GamePrefs.noteShit[curSelected][0][0] > 360)
			GamePrefs.noteShit[curSelected][0][0] = 360;

		if(GamePrefs.noteShit[curSelected][0][1] < 0)
			GamePrefs.noteShit[curSelected][0][1] = 0;
		if(GamePrefs.noteShit[curSelected][0][1] > 100)
			GamePrefs.noteShit[curSelected][0][1] = 100;

		if(GamePrefs.noteShit[curSelected][0][2] < -100)
			GamePrefs.noteShit[curSelected][0][2] = -100;
		if(GamePrefs.noteShit[curSelected][0][2] > 0)
			GamePrefs.noteShit[curSelected][0][2] = 0;
	}
}
