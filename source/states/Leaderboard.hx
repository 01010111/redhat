package states;

import ui.Transition;
import flixel.FlxSprite;
import zero.flixel.states.State;

class Leaderboard extends State {
	
	override function create() {
		super.create();
		bgColor = 0xFF43adaf;

		var bg = new FlxSprite(0,0,Images.title_background__png);
		bg.y = -64;
		add(bg);
		
		var placeholder = new FlxSprite(0,0,Images.leaderboard_placeholder__png);
		add(placeholder);
		
		var menu_btn = new ui.Button(FlxG.width/2 - 48, FlxG.height - 32);
		menu_btn.loadGraphic(Images.postgame_buttons__png, true, 96, 17);
		menu_btn.animation.frameIndex = 4;
		menu_btn.animation.add('play', [4,5,4,5,4], 15, false);
		menu_btn.on_hover = () -> menu_btn.animation.play('play');
		menu_btn.on_click = () -> {
			menu_btn.interactive = false;
			FlxG.camera.fade(0xFFe4f3f4, 0.2, false, () -> FlxG.switchState(new TitleScreen()));
		}
		add(menu_btn);

		new Transition(this, IN);
	}

}