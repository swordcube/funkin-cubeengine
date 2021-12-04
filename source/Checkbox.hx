package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Checkbox extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var daValue:Bool = false;
	public var daValueOld:Bool = false;
	public var copyAlpha:Bool = true;
	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	
	public function new(x:Float = 0, y:Float = 0, ?checked = false) {
		super(x, y);

		frames = Paths.getSparrowAtlas('checkbox_assets');
		animation.addByPrefix("unchecked", "unchecked", 24, false);
		animation.addByPrefix("checked", "checked anim0", 24, false);
		animation.addByPrefix("no", "no", 24, false);

		antialiasing = GamePrefs.antialiasing;
		setGraphicSize(Std.int(0.5 * width));
		updateHitbox();

		daValue = checked;
		daValueOld = checked;
		playAnim(daValue ? 'checked' : 'unchecked');
	}

	public function playAnim(name:String)
	{
		switch(name)
		{
			case 'checked':
				animation.play('checked', true);
				offset.set(65, 70);

			case 'unchecked':
				animation.play('unchecked', true);
				offset.set(60, 45);
		}
	}
	
	override function update(elapsed:Float) {
		if (sprTracker != null) {
			setPosition(sprTracker.x - 130 + offsetX, sprTracker.y + 30 + offsetY);
			if(copyAlpha) {
				alpha = sprTracker.alpha;
			}
		}
		
		if (daValueOld != daValue) {
			playAnim(daValue ? 'checked' : 'unchecked');
			daValueOld = daValue;
		}
		
		antialiasing = GamePrefs.antialiasing;
		
		super.update(elapsed);
	}
}
