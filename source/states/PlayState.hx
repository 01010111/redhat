package states;

import zero.utilities.Timer;
import objects.Platform;
import objects.Player;
import zero.flixel.states.State;

class PlayState extends State
{

	public static var instance:PlayState;
	public function new() {
		super();
		instance = this;
	}

	var player:Player;
	var platforms:PlatformManager;

	override function create() {
		bgColor = 0xFFE0F0FF;
		add(player = new Player(FlxG.width/2, FlxG.height - 64));
		add(platforms = new PlatformManager());
		FlxG.camera.pixelPerfectRender = true;
	}

	override function update(e:Float) {
		super.update(e);
		FlxG.collide(platforms, player, collide_platform);
		FlxG.camera.setScrollBoundsRect(0, FlxG.camera.scroll.y, FlxG.width, FlxG.height, true);
	}

	function collide_platform(p:Platform, o:Player) {
		switch p.type {
			case NORMAL:
				o.jump();
			case GROUND:
				if (o.state == NORMAL) o.jump();
			case CLOUD:
				if (p.available) {
					p.available = false;
					p.acceleration.y = 100;
					Timer.get(0.5, () -> {
						o.jump(CLOUD_MULTIPLIER);
						p.kill();
					});
				}
			case HAZARD:
				o.state = DEAD;
		}
	}

}