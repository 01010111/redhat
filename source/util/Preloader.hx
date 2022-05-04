package util;

import zero.utilities.Rect;
import flash.events.ProgressEvent;
import openfl.display.Sprite;

class Preloader extends flixel.system.FlxBasePreloader {
	
	var bar:Sprite;
	var rect:Rect = Rect.get(46, 116, 51, 6);
	var padding:Int = 2;

	var bar_bg_color:Int = 0xFFFFFF;
	var bar_fg_color:Int = 0xee0000;

	public function new() {
		super(0);
	}

	override function create() {
		super.create();
		var s = new Sprite();
		s.x = rect.x;
		s.y = rect.y;
		s.graphics.beginFill(bar_bg_color);
		s.graphics.drawRect(0, 0, rect.width, rect.height);
		s.graphics.endFill();
		addChild(s);

		bar = new Sprite();
		bar.graphics.beginFill(bar_fg_color);
		bar.x = padding;
		bar.y = padding;
		s.addChild(bar);
	}

	override function onProgress(event:ProgressEvent) {
		super.onProgress(event);
		bar.graphics.drawRect(
			0,
			0,
			(rect.width - padding * 2) * (event.bytesLoaded/event.bytesTotal),
			rect.height - padding * 2
		);
	}

}