package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var ver = EngineStuff.engineVersion;
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Your version of Cube Engine is outdated!\nYour version is "
			+ ver
			+ " while the most recent version is "
			+ TitleState.updateVersion
			+ "!\nPress ENTER to go to the download, or ESCAPE to ignore this."
			+ "\nYou can disable this screen in the Options menu.",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER)
		{
			CoolUtil.browserLoad("https://github.com/swordcube/funkin-cubeengine/releases");
			//FlxG.openURL("https://ninja-muffin24.itch.io/funkin");
		}
		if (FlxG.keys.justPressed.ESCAPE)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
