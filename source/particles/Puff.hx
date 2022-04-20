package particles;

import zero.flixel.ec.ParticleEmitter.FireOptions;
import zero.flixel.ec.components.KillAfterAnimation;
import zero.flixel.ec.ParticleEmitter.Particle;

class Puff extends Particle {
	
	public function new() {
		super();
		loadGraphic(Images.cloud_particle__png, true, 12, 12);
		animation.add('play', [0,1,2,3,4,5,6,7,8], 24, false);
		add_component(new KillAfterAnimation());
		this.make_and_center_hitbox(0,0);
		drag.set(DRAG, DRAG);
	}

	override function fire(options:FireOptions) {
		super.fire(options);
		if (options.data == null) options.data = { frame: 0 };
		else if (options.data.frame == null) options.data.frame = 0;
		animation.play('play', true, false, options.data.frame);
	}

}