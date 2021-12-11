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

class NoteSkinSubState extends MusicBeatSubstate
{
    private var curSelected:Int = 0;
    private var typeSelected:Int = 0;
    private var skinShit:Array<Int> = [
        CoolUtil.noteskins.indexOf(GamePrefs.noteShit[0][1]),
        CoolUtil.noteskins.indexOf(GamePrefs.noteShit[1][1]),
        CoolUtil.noteskins.indexOf(GamePrefs.noteShit[2][1]),
        CoolUtil.noteskins.indexOf(GamePrefs.noteShit[3][1])
    ];
    private var funnyNotes:FlxTypedGroup<FlxSprite>;
    var menuBG:FlxSprite;
    var awwowsUwU:FlxSprite;
    
    override function create()
    {
        for (i in skinShit) {
            if (i == null) {
                skinShit[i] = 0;
            }
        }
        // menu bg
        menuBG = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
        menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
        menuBG.updateHitbox();
        menuBG.screenCenter();
        menuBG.antialiasing = GamePrefs.antialiasing;
        add(menuBG);

        awwowsUwU = new FlxSprite().loadGraphic(Paths.image('awwows'));

        
        funnyNotes = new FlxTypedGroup<FlxSprite>();
        add(funnyNotes);
        
        for (i in 0...4) {
            var note:FlxSprite = new FlxSprite(1, 1);
            note.frames = Paths.getSparrowAtlas('noteskins/' + GamePrefs.noteShit[i][1] + '_assets');
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
            note.y = 550;
            funnyNotes.add(note);    
        }
        changeSelection();
    }

    override function update(elapsed:Float)
    {
        if (controls.BACK) {
            close();
            FlxG.sound.play(Paths.sound('cancelMenu'));
        }
		if (controls.UI_UP_P) {
			changeSkin(1);
		}
		if (controls.UI_DOWN_P) {
			changeSkin(-1);
		}
		if (controls.UI_LEFT_P) {
			changeSelection(-1);
		}
		if (controls.UI_RIGHT_P) {
			changeSelection(1);
		}

        for (i in 0...funnyNotes.length) {
            var item = funnyNotes.members[i];
            item.x = (135 * i) + 375;
            item.setGraphicSize(Std.int(item.width * 0.8));
        }

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
        for (i in 0...funnyNotes.length) {
			var item = funnyNotes.members[i];
			if (curSelected == i) {
				item.y = FlxMath.lerp(item.y, 350, lerpVal);
			} else {
				item.y = FlxMath.lerp(item.y, 400, lerpVal);
			}
		}

        super.update(elapsed);
    }

	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = GamePrefs.noteShit.length-1;
		if (curSelected >= GamePrefs.noteShit.length)
			curSelected = 0;

		/*for (i in 0...grpNumbers.length) {
			var item = grpNumbers.members[i];
			item.alpha = 0.6;
			if ((curSelected * 3) + typeSelected == i) {
				item.alpha = 1;
			}
		}*/
		for (i in 0...funnyNotes.length) {
			var item = funnyNotes.members[i];
			item.alpha = 0.6;
			item.scale.set(1, 1);
			if (curSelected == i) {
				item.alpha = 1;
				item.scale.set(1.2, 1.2);
				//hsvText.setPosition(item.x + hsvTextOffsets[0], item.y - hsvTextOffsets[1]);
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function changeSkin(change:Int = 0) {
		skinShit[curSelected] += change;
		if (skinShit[curSelected] < 0)
			skinShit[curSelected] = CoolUtil.noteskins.length-1;
		if (skinShit[curSelected] >= CoolUtil.noteskins.length)
			skinShit[curSelected] = 0;

        funnyNotes.members[curSelected].frames = Paths.getSparrowAtlas('noteskins/' + CoolUtil.noteskins[skinShit[curSelected]] + '_assets');
        funnyNotes.members[curSelected].animation.addByPrefix('0', 'purple0');
        funnyNotes.members[curSelected].animation.addByPrefix('1', 'blue0');
        funnyNotes.members[curSelected].animation.addByPrefix('2', 'green0');
        funnyNotes.members[curSelected].animation.addByPrefix('3', 'red0');
        funnyNotes.members[curSelected].animation.play(curSelected + '');
        GamePrefs.noteShit[curSelected][1] = CoolUtil.noteskins[skinShit[curSelected]];

		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}