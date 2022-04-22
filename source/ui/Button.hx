package ui;

import zero.utilities.Vec2;
import zero.utilities.Rect;
import flixel.FlxSprite;

class Button extends FlxSprite {

	public var interactive:Bool = true;

	public var on_hover:Void -> Void;
	public var on_out:Void -> Void;
	public var on_click:Void -> Void;

	public var verbose = false;

	var hovered(default, set):Bool = false;

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (!interactive) return;
		var sp = getScreenPosition();
		var r = Rect.get(sp.x, sp.y, width, height);
		sp.put();
		var mp = Vec2.get(FlxG.mouse.screenX, FlxG.mouse.screenY);
		if (verbose) trace(r, mp, r.contains_point(mp));
		hovered = r.contains_point(mp);
		r.put();
		mp.put();
		if (hovered && FlxG.mouse.justPressed && on_click != null) on_click(); 
	}

	function set_hovered(v:Bool) {
		if (hovered == v) return hovered;
		if (v && on_hover != null) on_hover();
		if (!v && on_out != null) on_out();
		return hovered = v;
	}

}