package ui;

import zero.utilities.Timer;
import zero.utilities.Ease;
import zero.utilities.Tween;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

class Transition extends FlxTypedGroup<FlxSprite> {
	
	public function new(parent:FlxGroup, state:TransitionState, ?on_complete:Void -> Void) {
		super();
		parent.add(this);
		var starty = switch state {
			case OUT:FlxG.height;
			case IN:0;
		}
		var endy = switch state {
			case OUT:0;
			case IN:-FlxG.height;
		}
		var ease = switch state {
			case OUT:Ease.sineOut;
			case IN:Ease.sineIn;
		}
		for (i in 0...4) {
			var spr = new FlxSprite(i * FlxG.width/4, starty);
			spr.scrollFactor.set();
			spr.makeGraphic((FlxG.width/4).ceil(), FlxG.height, 0xFFEE0000);
			add(spr);
			Tween.tween(spr, 0.25, { y: endy }, { ease: ease, delay: i * 0.1 });
		}
		Timer.get(0.55, on_complete != null ? on_complete : kill);
	}

}

enum TransitionState {
	IN;
	OUT;
}