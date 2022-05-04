package ui;

import lime.media.howlerjs.Howl;
import zero.utilities.Timer;
import zero.utilities.Ease;
import zero.utilities.Tween;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class LeveledUp extends flixel.group.FlxTypedGroup<FlxSprite> {
	
	public function new() {
		super();

		if (!util.GameState.muted) {
			util.GameState.music.mute(true);
			new Howl({
				src: ['assets/audio/levelup.mp3'],
				loop: false,
				autoplay: true
			});
			Timer.get(4, () -> {
				util.GameState.music.mute(false);
				util.GameState.music.fade(0, 1, 1);
			});
		}

		for (i in 0...4) {
			var stripe = new FlxSprite(FlxG.width, FlxG.height - 64 + i * 8);
			stripe.makeGraphic(FlxG.width, 8, 0xd0ee0000);
			stripe.scrollFactor.set();
			add(stripe);
			Tween.tween(stripe, 0.2, { x: 0 }, { ease: Ease.sineOut, delay: i * 0.1 });
			Timer.get(2, () -> Tween.tween(stripe, 0.2, { x: -FlxG.width }, { ease: Ease.sineIn, delay: i * 0.1 }));
		}

		var text = new FlxSprite(FlxG.width, FlxG.height - 64, Images.leveledup__png);
		text.scrollFactor.set();
		add(text);

		Tween.tween(text, 0.2, { x: 0 }, { ease: Ease.sineOut, delay: 0.4 });
		Timer.get(1.8, () -> Tween.tween(text, 0.2, { x: -FlxG.width }, { ease: Ease.sineIn }));

		Timer.get(3, kill);

		FlxG.state.add(this);
	}

}