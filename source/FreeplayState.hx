package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import lime.app.Application;
import lime.media.openal.AL;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import openfl.utils.Future;
import openfl.media.Sound;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;
	var curSpeed:Float = 1;

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var speedText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	var bg:FlxSprite;
	var bg2:FlxSprite;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		curPlaying = false;
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			songs.push(new SongMetadata(initSonglist[i], 1, 'gf', [0xA5004D]));
		}

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		// when mod support comes this code will go burn in hell

		if (StoryMenuState.weekUnlocked[1] || isDebug)
			addWeek(['Bopeebo', 'Fresh', 'Dad Battle'], 1, ['dad'], [[0xaf66ce]]);

		if (StoryMenuState.weekUnlocked[2] || isDebug)
			addWeek(['Spookeez', 'South', 'Monster'], 2, ['spooky', 'spooky', 'monster'], [[0xb4b4b4, 0xd57e00], [0xb4b4b4, 0xd57e00], [0xf3ff6e]]);

		if (StoryMenuState.weekUnlocked[3] || isDebug)
			addWeek(['Pico', 'Philly', 'Blammed'], 3, ['pico'], [[0xb7d855]]);

		if (StoryMenuState.weekUnlocked[4] || isDebug)
			addWeek(['Satin Panties', 'High', 'Milf'], 4, ['mom'], [[0xd8558e]]);

		if (StoryMenuState.weekUnlocked[5] || isDebug)
			addWeek(['Cocoa', 'Eggnog', 'Winter Horrorland'], 5, ['parents', 'parents', 'monster'], [[0xaf66ce, 0xd8558e], [0xaf66ce, 0xd8558e], [0xf3ff6e]]);

		if (StoryMenuState.weekUnlocked[6] || isDebug)
			addWeek(['Senpai', 'Roses', 'Thorns'], 6, ['senpai-pixel', 'senpai-pixel', 'spirit-pixel'], [[0xffaa6f], [0xffaa6f], [0xff3c6e]]);

		// LOAD MUSIC

		// LOAD CHARACTERS

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = GamePrefs.antialiasing;
		add(bg);
		bg2 = new FlxSprite().loadGraphic(Paths.image('menuDesatGradient'));
		bg2.antialiasing = GamePrefs.antialiasing;
		add(bg2);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 102, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);
		
		speedText = new FlxText(scoreText.x + 50, diffText.y + 36, 0, "", 24);
		speedText.font = scoreText.font;
		speedText.alignment = CENTER;
		add(speedText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */
		 
		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
		#if PRELOAD_ALL
		var leText:String = "Press SPACE to listen to the song | Press RESET to reset score/accuracy";
		#else
		var leText:String = "Press RESET to reset score/accuracy";
		#end
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, 18);
		text.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);
		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, bgColors:Array<Int>)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, bgColors));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>, bgColors:Array<Dynamic>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num], bgColors[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	var instPlaying:Int = -1;
	private static var vocals:FlxSound = null;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = 'PERSONAL BEST: ' + lerpScore;
		positionHighscore();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var leftP = controls.UI_LEFT_P;
		var rightP = controls.UI_RIGHT_P;
		var shift = FlxG.keys.pressed.SHIFT;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		
		curSpeed = FlxMath.roundDecimal(curSpeed, 2);
		
		#if !sys
		curSpeed = 1;
		#end

		if(curSpeed < 0.5)
			curSpeed = 0.5;
			
		#if sys
		speedText.text = "Speed: " + curSpeed + " (R+SHIFT)";
		#else
		speedText.text = "";
		#end
		
		speedText.x = scoreText.x + (scoreText.width / 2) - (speedText.width / 2);

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.UI_LEFT_P && !shift)
			changeDiff(-1);
		else if (controls.UI_LEFT_P && shift)
		{
			curSpeed -= 0.05;

			#if cpp
			@:privateAccess
			{
				if(FlxG.sound.music.active && FlxG.sound.music.playing && curPlaying)
					lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, curSpeed);
	
				if (vocals.playing && curPlaying)
					lime.media.openal.AL.sourcef(vocals._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, curSpeed);
			}
			#end
		}
			
		if (controls.UI_RIGHT_P && !shift)
			changeDiff(1);
		else if (controls.UI_RIGHT_P && shift)
		{
			curSpeed += 0.05;

			#if cpp
			@:privateAccess
			{
				if(FlxG.sound.music.active && FlxG.sound.music.playing && curPlaying)
					lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, curSpeed);
	
				if (vocals.playing && curPlaying)
					lime.media.openal.AL.sourcef(vocals._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, curSpeed);
			}
			#end
		}

		if(FlxG.keys.justPressed.R  && shift)
		{
			curSpeed = 1;

			#if cpp
			@:privateAccess
			{
				if(FlxG.sound.music.active && FlxG.sound.music.playing && curPlaying)
					lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, curSpeed);
	
				if (vocals.playing && curPlaying)
					lime.media.openal.AL.sourcef(vocals._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, curSpeed);
			}
			#end
		}

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		#if PRELOAD_ALL
		if(space && instPlaying != curSelected)
		{
			curPlaying = true;
			destroyFreeplayVocals();
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			if (PlayState.SONG.needsVoices)
				vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
			else
				vocals = new FlxSound();

			FlxG.sound.list.add(vocals);
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
			vocals.play();
			vocals.persist = true;
			vocals.looped = true;
			vocals.volume = 0.7;
			instPlaying = curSelected;
			
			#if cpp
			@:privateAccess
			{
				if(FlxG.sound.music.active && FlxG.sound.music.playing)
					lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, curSpeed);
	
				if(vocals.active && vocals.playing)
					lime.media.openal.AL.sourcef(vocals._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, curSpeed);
			}
			#end
		}
		else #end if (accepted)
		{
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName.toLowerCase());
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;
			PlayState.songMultiplier = curSpeed;
			PlayState.menuStartedFrom = "Freeplay";

			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState());
			
			FlxG.sound.music.volume = 0;
					
			destroyFreeplayVocals();
		}
		
		bg.color = songs[curSelected].bgColors[0];
		if (songs[curSelected].bgColors[1] != 0) {
			bg2.color = songs[curSelected].bgColors[1];
		} else {
			bg2.color = songs[curSelected].bgColors[0];
		}

		super.update(elapsed);
	}
	
	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "EASY";
			case 1:
				diffText.text = 'NORMAL';
			case 2:
				diffText.text = "HARD";
		}
		
		var funnyDiffTextGaming:String = diffText.text;
		
		diffText.text = '< ' + funnyDiffTextGaming + ' >';
		positionHighscore();
	}

	function changeSelection(change:Int = 0)
	{
		/*#if !switch
		NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');*/
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
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
	
	private function positionHighscore() {
		scoreText.x = FlxG.width - scoreText.width - 6;

		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var bgColors:Array<Int> = [0xFFFFFF];

	public function new(song:String, week:Int, songCharacter:String, bgColors:Array<Int>)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.bgColors = bgColors;
	}
}
