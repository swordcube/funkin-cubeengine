package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class NoteSplash extends FlxSprite
{
	private var idleAnim:String;
	private var textureLoaded:String = null;

	public function new(x:Float = 0, y:Float = 0, note:Int = 0) {
		super(x, y);

		var skin:String = 'noteSplashes';

		loadAnims(skin);

		setupNoteSplash(x, y, note);
		antialiasing = GamePrefs.antialiasing;
	}

	public function setupNoteSplash(x:Float, y:Float, note:Int = 0, texture:String = null) {
		setPosition(x - Note.swagWidth * 0.95, y - Note.swagWidth);
		alpha = 0.6;

		if(texture == null) {
			texture = 'noteSplashes';
		}

		if(textureLoaded != texture) {
			loadAnims(texture);
		}
		offset.set(-20, -10);

		var animNum:Int = FlxG.random.int(1, 2);
		animation.play('note' + note + '-' + animNum, true);
		if(animation.curAnim != null)animation.curAnim.frameRate = 24 + FlxG.random.int(-2, 2);
	}

	function loadAnims(skin:String) {
		frames = Paths.getSparrowAtlas(skin);
		for (i in 1...3) {
			animation.addByPrefix("note1-" + i, "note impact 1 blue", 24, false);
			animation.addByPrefix("note2-" + i, "note impact 1 green", 24, false);
			animation.addByPrefix("note0-" + i, "note impact 1 purple", 24, false);
			animation.addByPrefix("note3-" + i, "note impact 1 red", 24, false);
		}
	}

	override function update(elapsed:Float) {
		if(animation.curAnim != null)if(animation.curAnim.finished) kill();

		super.update(elapsed);
	}
}
