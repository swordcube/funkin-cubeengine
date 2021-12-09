package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<Dynamic> = [
		['Resume', 'Exits the pause menu.'],
		['Restart Song', 'Restarts the song.\nAlso resets your misses and accuracy.'],
		['Toggle Practice Mode', 'When enabled, You cannot get blueballed.'],
		['Botplay', 'When enabled, The song gets played for you.'],
		['Exit to menu', 'Exits to Story Mode/Freeplay/Main Menu.'],
	];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var practiceText:FlxText;
	var botplayText:FlxText;
	var descText:FlxText;

	public function new(x:Float, y:Float)
	{
		super();

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);
		
		var blueballedText:FlxText = new FlxText(20, 15 + 64, 0, "", 32);
		blueballedText.text = "Blueballed: " + PlayState.deathCounter;
		blueballedText.scrollFactor.set();
		blueballedText.setFormat(Paths.font('vcr.ttf'), 32);
		blueballedText.updateHitbox();
		add(blueballedText);
		
		practiceText = new FlxText(20, 15 + 101, 0, "PRACTICE MODE", 32);
		practiceText.scrollFactor.set();
		practiceText.setFormat(Paths.font('vcr.ttf'), 32);
		practiceText.x = FlxG.width - (practiceText.width + 20);
		practiceText.updateHitbox();
		practiceText.visible = PlayState.practiceMode;
		add(practiceText);
		
		botplayText = new FlxText(20, FlxG.height - 40, 0, "BOTPLAY", 32);
		botplayText.scrollFactor.set();
		botplayText.setFormat(Paths.font('vcr.ttf'), 32);
		botplayText.x = FlxG.width - (botplayText.width + 20);
		botplayText.updateHitbox();
		botplayText.visible = PlayState.botplay;
		add(botplayText);

		blueballedText.alpha = 0;
		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		blueballedText.x = FlxG.width - (blueballedText.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(blueballedText, {alpha: 1, y: blueballedText.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i][0], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();
		
		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected][0];

			switch (daSelected)
			{
				case "Resume":
					close();
					
				case "Restart Song":
					FlxG.resetState();
					
				case "Toggle Practice Mode":
					PlayState.practiceMode = !PlayState.practiceMode;
					PlayState.usedPracticeMode = true; // makes it so if you've toggled practice mode, your score won't submit
					practiceText.visible = PlayState.practiceMode;
					
				case "Botplay":
					PlayState.botplay = !PlayState.botplay;
					PlayState.usedBotplay = true; // makes it so if you've toggled botplay, your score won't submit
					botplayText.visible = PlayState.botplay;
					
				case "Exit to menu":
				
				switch (PlayState.menuStartedFrom) // go back to the menu you came from when you started a song
				{
					case "StoryMode":
						FlxG.switchState(new StoryMenuState());
					case "Freeplay":
						FlxG.switchState(new FreeplayState());
					case "MainMenu":
						FlxG.switchState(new MainMenuState());
				}
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
		
		descText.text = menuItems[curSelected][1];
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
