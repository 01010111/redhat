package util;

class Controller {
	
	public static var left(get, never):Bool;
	public static var right(get, never):Bool;
	public static var any(get, never):Bool;

	static function get_left() {
		return FlxG.keys.pressed.LEFT;
	}

	static function get_right() {
		return FlxG.keys.pressed.RIGHT;
	}

	static function get_any() {
		return left || right;
	}

}