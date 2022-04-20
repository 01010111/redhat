package particles;

import zero.utilities.Vec2;
import zero.flixel.ec.ParticleEmitter.FireOptions;
import zero.flixel.ec.components.KillAfterAnimation;
import zero.flixel.ec.ParticleEmitter.Particle;

class CubeParticle extends Particle {
	
	public function new() {
		super();
		loadGraphic(Images.cube_particle__png, true, 16, 16);
		animation.add('play', [0,1,2,3,4,5,6,7,8], 45, false);
		add_component(new KillAfterAnimation());
		this.make_and_center_hitbox(0,0);
	}

	override function fire(options:FireOptions) {
		super.fire(options);
		animation.play('play');
	}

	override function update(dt:Float) {
		super.update(dt);
		var v = Vec2.get(velocity.x, velocity.y);
		v.length *= 0.95;
		velocity.set(v.x, v.y);
		v.put();
	}

}