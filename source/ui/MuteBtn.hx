package ui;

import lime.media.howlerjs.Howler;

class MuteBtn extends Button {

	public function new() {
		super(4, 4);
		loadGraphic(Images.mutebtn__png, true, 16, 9);
		animation.frameIndex = util.GameState.muted ? 1 : 0;
		on_click = () -> {
			util.GameState.muted = !util.GameState.muted;
			animation.frameIndex = util.GameState.muted ? 1 : 0;
			Sounds.play(Audio.select__mp3, 0.5);
		}
		scrollFactor.set();
	}

}