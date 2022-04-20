package states;

import flixel.addons.ui.FlxButtonPlus;
import flixel.FlxSprite;
import zero.flixel.states.State;

class TitleScreen extends State {

	override function create() {
		super.create();
		var background = new FlxSprite(0,0,Images.background1__png);
		var title_graphic = new FlxSprite(0,0,Images.background1__png);
		var play_button = new FlxButtonPlus(0,0,start_game);
	}

	function start_game() {
		
	}
	
}