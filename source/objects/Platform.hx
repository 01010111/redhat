package objects;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxPath;
import flixel.FlxSprite;

class Platform extends FlxSprite {
	
	public var type:PlatformType;
	public var available:Bool;

	public function new() {
		super();
		allowCollisions = 0x0100;
		exists = false;
		immovable = true;
	}

	public function spawn(x:Float, y:Float, moving:Bool) {
		reset(x, y);
		available = true;
		if (moving) {
			path = new FlxPath().start(
				[
					FlxPoint.get(width/2, y + height/2),
					FlxPoint.get(FlxG.width - width/2, y + height/2)
				],
				PLATFORM_MOVE_SPEEDS.get_random(),
				FlxPath.YOYO
			);
		}
		else if (path != null && path.active) path.cancel();
		velocity.set();
		acceleration.set();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (y > FlxG.camera.scroll.y + FlxG.height + 64) kill();
	}

}

class NormalPlatform extends Platform {
	public function new() {
		super();
		type = NORMAL;
		makeGraphic(26, 5, 0xFF0080FF);
	}
}

class HazardPlatform extends Platform {
	public function new() {
		super();
		type = HAZARD;
		makeGraphic(26, 5, 0xFFFF004D);
	}
}

class CloudPlatform extends Platform {
	public function new() {
		super();
		type = CLOUD;
		makeGraphic(26, 16, 0xFF808080);
		this.make_anchored_hitbox(26, 5);
	}
}

class Ground extends Platform {
	public function new() {
		super();
		type = GROUND;
		makeGraphic(FlxG.width, 11, 0xFFFF004D);
		reset(0, FlxG.height - 11);
	}
}

class PlatformManager extends FlxTypedGroup<Platform> {
	
	var top:Platform;
	var gap:Float = 32;
	var y:Float = FlxG.height - 64;

	var spawn_types:Array<PlatformSpawn> = [
		NORMAL,
		NORMAL,
		NORMAL,
		NORMAL,
		NORMAL,
		NORMAL,
		NORMAL,
		NORMAL,
		NORMAL,
		NORMAL,
		NORMAL,
		NORMAL,
		NORMAL,
		NORMAL,
		NORMAL,
		NORMAL,
		NORMAL_MOVING,
		NORMAL_MOVING,
		NORMAL_MOVING,
		NORMAL_MOVING,
		NORMAL_HAZARD,
		NORMAL_HAZARD,
		NORMAL_HAZARD,
		NORMAL_HAZARD,
		NORMAL_POWERUP,
		NORMAL_POWERUP,
		CLOUD,
		CLOUD,
		CLOUD,
		CLOUD,
		CLOUD,
		CLOUD,
		CLOUD,
		CLOUD,
	];

	var pool:Map<PlatformType, Array<Platform>> = [
		NORMAL => [],
		CLOUD => [],
		HAZARD => [],
	];

	public function new() {
		super();
		add(new Ground());
		spawn();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (top != null && top.y > FlxG.camera.scroll.y - FlxG.height) spawn();
	}

	function spawn() {
		var n = 0;
		for (i in 0...16) {
			var type = spawn_types.get_random();
			
			switch type {
				case NORMAL:
					var platform = get(NORMAL);
					platform.spawn((FlxG.width - platform.width).get_random(0), y, false);
					top = platform;		
				case NORMAL_HAZARD:
					var platform = get(NORMAL);
					platform.spawn((FlxG.width - platform.width).get_random(0), y, false);
					top = platform;
					var hazard = get(HAZARD);
					hazard.spawn((FlxG.width - platform.width).get_random(0), y - gap/2, Math.random() > 0.75);
				case NORMAL_MOVING:
					var platform = get(NORMAL);
					platform.spawn((FlxG.width - platform.width).get_random(0), y, true);
					top = platform;		
				case NORMAL_POWERUP:
					var platform = get(NORMAL);
					platform.spawn((FlxG.width - platform.width).get_random(0), y, false);
					top = platform;		
				case CLOUD:
					var platform = get(CLOUD);
					platform.spawn((FlxG.width - platform.width).get_random(0), y, false);
					top = platform;		
			}

			y -= gap;
			n++;
			if (n % 4 == 0) gap = (gap + 1).min(96);
		}
		for (i in 0...2) spawn_types.remove(NORMAL);
	}

	function get(type:PlatformType) {
		for (platform in pool[type]) if (!platform.exists) return platform;
		switch type {
			case NORMAL:
				var platform = new NormalPlatform();
				add(platform);
				pool[type].push(platform);
				return platform;
			case CLOUD:
				var platform = new CloudPlatform();
				add(platform);
				pool[type].push(platform);
				return platform;
			case HAZARD:
				var platform = new HazardPlatform();
				add(platform);
				pool[type].push(platform);
				return platform;
			case GROUND:
		}
		return null;
	}

}

enum PlatformType {
	NORMAL;
	GROUND;
	CLOUD;
	HAZARD;
}

enum PlatformSpawn {
	NORMAL;
	NORMAL_HAZARD;
	NORMAL_MOVING;
	NORMAL_POWERUP;
	CLOUD;
}