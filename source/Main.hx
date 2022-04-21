package;

import states.*;
import zero.utilities.Tween;
import openfl.display.Sprite;
import flixel.FlxGame;
import zero.utilities.ECS;
import zero.utilities.Timer;
import zero.utilities.SyncedSin;
import zero.flixel.input.FamiController;
#if PIXEL_PERFECT
import flixel.FlxG;
import flixel.system.FlxAssets.FlxShader;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
#end

class Main extends Sprite
{
	static var WIDTH:Int = 144;
	static var HEIGHT:Int = 256;

	public function new()
	{
		super();
		addChild(new FlxGame(WIDTH, HEIGHT, TitleScreen, 1, 60, 60, true));
		((?dt:Dynamic) -> {
			Timer.update(dt);
			Tween.update(dt);
		}).listen('preupdate');
		#if PIXEL_PERFECT
		//FlxG.game.setFilters([new ShaderFilter(new FlxShader())]);
		//FlxG.game.stage.quality = StageQuality.LOW;
		//FlxG.resizeWindow(FlxG.stage.stageWidth, FlxG.stage.stageHeight);
		#end
		FlxG.mouse.useSystemCursor = true;
	}
}