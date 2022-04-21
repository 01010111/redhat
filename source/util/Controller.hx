package util;

class Controller {
	
	public static var left(get, never):Bool;
	public static var right(get, never):Bool;
	public static var any(get, never):Bool;

	static var deadzone = 48;

	static function get_left() {
		return 
			FlxG.keys.pressed.LEFT || 
			PLAYER != null && FlxG.mouse.pressed && FlxG.mouse.x < PLAYER.getMidpoint().x - deadzone/2;
			//FlxG.mouse.pressed && FlxG.mouse.x < FlxG.width/2;
		}
		
		static function get_right() {
			return 
			FlxG.keys.pressed.RIGHT ||
			PLAYER != null && FlxG.mouse.pressed && FlxG.mouse.x > PLAYER.getMidpoint().x + deadzone/2;
			//FlxG.mouse.pressed && FlxG.mouse.x > FlxG.width/2;
	}

	static function get_any() {
		return left || right;
	}

}