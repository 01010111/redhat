package particles;

import zero.flixel.ec.ParticleEmitter.FireOptions;
import zero.flixel.ec.components.KillAfterAnimation;
import zero.flixel.ec.ParticleEmitter.Particle;

class Elec extends Particle {
	
	public function new() {
		super();
		loadGraphic(Images.electricity__png, true, 16, 16);
		animation.add('0', [0,1,2,3,4,5,6,7], 20, false);
		animation.add('1', [8,9,10,11,12,13,14,15], 20, false);
		animation.add('2', [16,17,18,19,20,21,22,23], 20, false);
		animation.add('3', [24,25,26,27,28,29,30,31], 20, false);
		this.make_and_center_hitbox(0,0);
		add_component(new KillAfterAnimation());
		blend = ADD;
	}

	override function fire(options:FireOptions) {
		super.fire(options);
		animation.play('${4.get_random().floor()}');
		angle = 4.get_random().floor() * 90;
	}

}