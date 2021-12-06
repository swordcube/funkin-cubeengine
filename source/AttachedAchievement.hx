package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class AttachedAchievement extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var imagePath:String;
	public var folderPath:String = "";
	public var daValue:Bool = false;
	public var daValueOld:Bool = false;
	public var unlocked:Bool = false;
	
	public function new(x:Float = 0, y:Float = 0, unlocked:Bool = false, folderPath:String = "", imagePath:String = "") {
		super(x, y);
		this.unlocked = unlocked;
		this.folderPath = folderPath;
		this.imagePath = imagePath;

		//loadGraphic(Paths.image(folderPath + '/award_' + imagePath));
		//offset.set(65, 70);
		playAnim(unlocked);

		setGraphicSize(Std.int(width * 0.7));
		updateHitbox();
		antialiasing = GamePrefs.antialiasing;
	}
	
	public function playAnim(unlockedGamering:Bool)
	{
		if(unlockedGamering)
		{
			loadGraphic(Paths.image('awards' + folderPath + '/award_' + imagePath));

		} else {
			loadGraphic(Paths.image('awards/award_Locked'));
		}
	}

	override function update(elapsed:Float) {
		if (sprTracker != null)
			setPosition(sprTracker.x - 130, sprTracker.y + 25);
			
		if (daValueOld != unlocked) {
			playAnim(unlocked);
			daValueOld = unlocked;
		}
		
		antialiasing = GamePrefs.antialiasing;

		super.update(elapsed);
	}
}
