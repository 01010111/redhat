package objects;

import zero.utilities.Tween;
import zero.utilities.Vec2;
import zero.utilities.Timer;
import flixel.FlxObject;
import util.Controller;
import flixel.FlxSprite;

class Player extends FlxSprite {

	public var powerup_timer:Float = 0;
	public var state(default, set):PlayerState = IDLE;
	public var electric:Bool = false;

	var elec_timer:Float = 0;
	
	public function new(x, y, player:Int, hat:Bool, shirt:Bool, pants:Bool) {
		super(x, y);
		loadGraphic('assets/images/player.png', true, 32, 48);
		var variant = 0;
		if (hat) variant += 3;
		if (shirt) variant += 6;
		if (pants) variant += 12;
		variant += player * 24;
		acceleration.y = 600;
		this.make_anchored_hitbox(8, 32);
		this.set_facing_flip_horizontal(true);
		maxVelocity.set(MAX_SPEED, MAX_FALL);
		drag.x = DRAG;
		animation.add('jump', [1 + variant]);
		animation.add('fall', [2 + variant]);
		animation.add('crouch', [0 + variant]);
	}

	override function update(elapsed:Float) {
		controls();
		animations();
		camera_checks();
		powerup_update(elapsed);
		super.update(elapsed);
		if (electric && (elec_timer -= elapsed) <= 0) {
			elec_timer = ELECTRICITY_TIME;
			PLAYSTATE.elecs.fire({ position: FlxPoint.get(x - 2 + 12.get_random(), y - 2 + 34.get_random()) });
		}
	}

	function controls() {
		switch state {
			case IDLE:
				if (Controller.any) {
					state = NORMAL;
					jump(GROUND_MULTIPLIER);
				}
			case NORMAL:
				// set acceleration
				if (isTouching(FlxObject.FLOOR)) velocity.x = 0;
				acceleration.x = 0;
				if (Controller.left && !isTouching(FlxObject.FLOOR)) acceleration.x -= ACCELERATION_AMT;
				if (Controller.right && !isTouching(FlxObject.FLOOR)) acceleration.x += ACCELERATION_AMT;
				// lock to screen
				if (x <= 0) {
					x = 0;
					acceleration.x = acceleration.x.max(0);
					velocity.x = velocity.x.max(0);
				}
				if (x + width >= FlxG.width) {
					acceleration.x = acceleration.x.min(0);
					velocity.x = velocity.x.min(0);
				}
			case DEAD:
				acceleration.x = velocity.x = 0;
		}
	}

	function animations() {
		var a = '';
		if (touching & FlxObject.FLOOR > 0) a = 'crouch';
		else a = velocity.y > 0 ? 'fall' : 'jump';
		if (state == DEAD) return;
		animation.play(a);
		if (acceleration.x != 0) facing = acceleration.x < 0 ? FlxObject.LEFT : FlxObject.RIGHT;
	}

	function camera_checks() {
		var sp = getScreenPosition();
		var t = FlxG.camera.scroll.y;
		t = t.min(t + sp.y + height - FlxG.height * 0.5);
		sp.put();
		FlxG.camera.scroll.y += (t - FlxG.camera.scroll.y) * 0.25;
		if (y - 64 > FlxG.camera.scroll.y + FlxG.height && state != DEAD) {
			Sounds.play(Audio.fall__mp3, 0.25);
			state = DEAD;
		}
	}

	var i = 0;

	function powerup_update(dt:Float) {
		if (powerup_timer <= 0) return;
		powerup_timer -= dt;
		if (powerup_timer < 2 && !this.isFlickering()) this.flicker(2, 0.08);
		i++;
		if (i % 10 == 0) {
			var p = Vec2.get(x + width/2, y + height/2);
			var o = Vec2.get(24.get_random());
			o.angle = 360.get_random();
			p += o;
			o.put();
			PLAYSTATE.cube_particles.fire({ position: p.to_flxpoint() });
		}
		if (powerup_timer > 0) return;
	}

	public function jump(mult:Float = 1) {
		var force:Float = JUMP_FORCE * mult;
		if (powerup_timer > 0) force *= POWERUP_MULTIPLIER;
		velocity.y = -force;
	}

	function set_state(s:PlayerState) {
		if (s == state) return s;
		switch s {
			case IDLE:
			case NORMAL:
			case DEAD: 
				Timer.get(1, PLAYSTATE.game_over);
				loadGraphic(Images.playershocked__png, true, 21, 37);
				this.make_anchored_hitbox(8, 32);
				animation.add('shock', [1,2,0,1,0], 15);
				animation.play('shock');
		}
		return state = s;
	}

}

enum PlayerState {
	IDLE;
	NORMAL;
	DEAD;
}

var instance(get, never):Player;
function get_instance() {
	if (PLAYSTATE == null) return null;
	return PLAYSTATE.player;
}