package ui;

import zero.utilities.Timer;
import zero.utilities.Ease;
import zero.utilities.Tween;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

class TransHori extends FlxTypedGroup<FlxSprite> {
	
	public function new(parent:FlxGroup, state:TransHoriState, ?on_complete:Void -> Void) {
		super();
		parent.add(this);
		var startx = switch state {
			case OUT:FlxG.width;
			case IN:0;
		}
		var endx = switch state {
			case OUT:0;
			case IN:-FlxG.width;
		}
		var ease = switch state {
			case OUT:Ease.sineOut;
			case IN:Ease.sineIn;
		}
		for (i in 0...6) {
			var spr = new FlxSprite(startx, i * FlxG.height/6);
			spr.scrollFactor.set();
			spr.makeGraphic(FlxG.width, (FlxG.height/6).ceil(), 0xFFEE0000);
			add(spr);
			Tween.tween(spr, 0.25, { x: endx }, { ease: ease, delay: i * 0.1 });
		}
		Timer.get(0.75, on_complete != null ? on_complete : kill);
	}

}

enum TransHoriState {
	IN;
	OUT;
}