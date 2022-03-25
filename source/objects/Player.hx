package objects;

import zero.utilities.Timer;
import flixel.FlxObject;
import util.Controller;
import flixel.FlxSprite;

class Player extends FlxSprite {

	public var powerup_timer:Float = 0;
	public var state(default, set):PlayerState = IDLE;
	
	public function new(x, y) {
		super(x, y);
		makeGraphic(8, 32, 0xFF0080FF);
		acceleration.y = 600;
		this.make_anchored_hitbox(8, 32);
		this.set_facing_flip_horizontal(true);
		maxVelocity.set(MAX_SPEED, MAX_FALL);
		drag.x = DRAG;
		animation.add('jump', [0]);
		animation.add('fall', [0]);
		animation.add('crouch', [0]);
		animation.add('die', [0]);
	}

	override function update(elapsed:Float) {
		controls();
		animations();
		camera_checks();
		powerup_timer -= elapsed;
		super.update(elapsed);
	}

	function controls() {
		switch state {
			case IDLE:
				if (Controller.any) {
					state = NORMAL;
					jump();
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
		if (state == DEAD) a = 'die';
		animation.play(a);
		if (acceleration.x != 0) facing = acceleration.x < 0 ? FlxObject.LEFT : FlxObject.RIGHT;
	}

	function camera_checks() {
		var sp = getScreenPosition();
		var t = FlxG.camera.scroll.y;
		t = t.min(t + sp.y + height - FlxG.height * 0.5);
		sp.put();
		FlxG.camera.scroll.y += (t - FlxG.camera.scroll.y) * 0.25;
		if (y - 64 > FlxG.camera.scroll.y + FlxG.height) state = DEAD;
	}

	public function jump(mult:Float = 1) {
		var force:Float = JUMP_FORCE * mult;
		if (powerup_timer > 0) force *= POWERUP_MULTIPLIER;
		velocity.y = -force;
		trace(force);
	}

	function set_state(s:PlayerState) {
		if (s == state) return s;
		switch s {
			case IDLE:
			case NORMAL:
			case DEAD: Timer.get(1, () -> FlxG.resetState());
		}
		return state = s;
	}

}

enum PlayerState {
	IDLE;
	NORMAL;
	DEAD;
}