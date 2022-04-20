package objects;

import flixel.addons.display.FlxBackdrop;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

class BackGround extends FlxGroup {
	
	public function new() {
		super();

		var bg1 = new FlxSprite(0, FlxG.height - 100, Images.background3__png);
		var bg2 = new FlxSprite(0, FlxG.height - 110, Images.background2__png);
		var bg3 = new FlxSprite(0, FlxG.height - 63, Images.background1__png);
		
		bg1.scrollFactor.set(1, 0.6);
		bg2.scrollFactor.set(1, 0.8);
		bg3.scrollFactor.set(1, 1);
		
		var clouds = new FlxBackdrop(Images.bigcloud_bg__png, 0, 0.6, true, true);
		clouds.velocity.x = 8;

		add(bg1);
		add(clouds);
		add(bg2);
		add(bg3);
	}

}