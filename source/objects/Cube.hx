package objects;

import zero.utilities.Vec2;
import zero.flixel.ec.ParticleEmitter.FireOptions;
import zero.flixel.ec.ParticleEmitter.Particle;

class Cube extends Particle {
	
	public var state:CubeState;
	public var parent:Player;
	public var target:Vec2 = Vec2.get();

	var t = 0.0;

	public function new() {
		super();
		loadGraphic(Images.cube_sheet__png, true, 14, 16);
		animation.add('rotate', [0,1,2,3,4,5,6,7], 10);
		this.make_and_center_hitbox(12, 12);
	}

	override function fire(options:FireOptions) {
		super.fire(options);
		animation.play('rotate');
		state = PICKUP;
		target.set(x, y);
		t = 0;
	}

	public function pickup(parent:Player) {
		kill();
		parent.powerup_timer = POWERUP_TIME;
		return;
		this.parent = parent;
		//parent.cube = this;
		var m = parent.getMidpoint();
		target.set(m.x, m.y);
		parent.powerup_timer = POWERUP_TIME - 2;
		state = ACTIVE;
		t = 0;
	}

	override function update(dt:Float) {
		super.update(dt);
		switch state {
			case PICKUP: pickup_update(dt);
			case ACTIVE: active_update(dt);
		}
	}

	function pickup_update(dt:Float) {
		if (y > FlxG.camera.scroll.y + FlxG.height + 64) kill();
	}

	function active_update(dt:Float) {
		t += dt * 5;
		target.x = parent.x + parent.width/2 + t.sin() * 32;
		target.y = parent.y + 6;
		x += (target.x - width/2 - x) * 0.25;
		y += (target.y - y) * 0.1;
	}

}

enum CubeState {
	PICKUP;
	ACTIVE;
}