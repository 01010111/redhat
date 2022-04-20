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
		loadGraphic(Images.platform__png);
	}
}

class HazardPlatform extends Platform {
	public function new() {
		super();
		type = HAZARD;
		loadGraphic(Images.shocker_plain__png);
		trace(Images.shocker_plain__png);
		//animation.add('play', [0,1], 15);
		//animation.play('play');
		//this.make_and_center_hitbox(26, 5);
	}
	var elec_timer:Float = 0;
	override function update(elapsed:Float) {
		super.update(elapsed);
		if ((elec_timer -= elapsed) <= 0) {
			elec_timer = ELECTRICITY_TIME;
			PLAYSTATE.elecs.fire({ position: FlxPoint.get(x + width.get_random(), y + height.get_random()) });
		}
	}
}

class CloudPlatform extends Platform {
	static var i = 0;
	public function new() {
		super();
		type = CLOUD;
		loadGraphic(i % 3 == 0 ? Images.cloud2__png : Images.cloud1__png, true, 28, 18);
		animation.add('play', [1,2,2,3], 24, false);
		animation.add('idle', [0]);
		this.make_anchored_hitbox(26, 5);
		i++;
	}

	override function spawn(x:Float, y:Float, moving:Bool) {
		super.spawn(x, y, moving);
		animation.play('idle');
	}
}

class Ground extends Platform {
	public function new() {
		super();
		type = GROUND;
		makeGraphic(FlxG.width, 11, 0x00FF004D);
		reset(0, FlxG.height - 11);
	}
}

class PlatformManager extends FlxTypedGroup<Platform> {
	
	var top:Platform;
	var gap:Float = 32;
	var y:Float = FlxG.height - 112;

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
					PLAYSTATE.powerups.fire({ position: FlxPoint.get(platform.x + platform.width/2 - 6, platform.y - 24) });
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