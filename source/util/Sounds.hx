package util;

import lime.media.howlerjs.Howl;
import flixel.system.FlxAssets;

class Sounds {

	public static function play(sound:FlxSoundAsset, vol:Float = 1) {
		if (util.GameState.muted) return;
		new Howl({
			src: [sound],
			volume: vol,
			loop: false,
			autoplay: true
		});
	}

}