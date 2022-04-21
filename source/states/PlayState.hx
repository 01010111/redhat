package states;

import zero.flixel.ui.BitmapText;
import objects.Background.BackGround;
import zero.utilities.Vec2;
import particles.CubeParticle;
import objects.Cube;
import particles.Puff;
import particles.Elec;
import zero.flixel.ec.ParticleEmitter;
import flixel.FlxSprite;
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

	public var player:Player;
	var platforms:PlatformManager;

	public var elecs = new ParticleEmitter(() -> new Elec());
	public var puffs = new ParticleEmitter(() -> new Puff());
	public var powerups = new ParticleEmitter(() -> new Cube());
	public var cube_particles = new ParticleEmitter(() -> new CubeParticle());

	var score_text:BitmapText;
	var score(default, set) = 0;

	override function create() {
		bgColor = 0xFFdbf0f7;
		FlxG.camera.flash(0xFFdbf0f7, 0.2);
		add(new BackGround());
		add(cube_particles);
		add(player = new Player(FlxG.width/2, FlxG.height - 43, 3.get_random().floor(), Math.random() > 0.5, Math.random() > 0.5, Math.random() > 0.5));
		add(puffs);
		add(platforms = new PlatformManager());
		add(powerups);
		add(elecs);
		FlxG.camera.pixelPerfectRender = true;
		add(score_text = new BitmapText({
			position: FlxPoint.get(0, 16),
			align: CENTER,
			width: FlxG.width,
			graphic: Images.alphabet__png,
			letter_size: FlxPoint.get(8, 8),
			charset: ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
			scroll_factor: FlxPoint.get(0,0),
			letter_spacing: -1,
		}));
		score_text.color = 0xFFEE0000;
		score_text.text = '0';
	}

	override function update(e:Float) {
		super.update(e);
		FlxG.collide(platforms, player, collide_platform);
		FlxG.overlap(powerups, player, get_powerup);
		FlxG.camera.setScrollBoundsRect(0, FlxG.camera.scroll.y, FlxG.width, FlxG.height + 32, true);
		score = player.y.map(FlxG.height - 43, FlxG.height - 43 - 16, 0, 1).floor();
	}

	function collide_platform(p:Platform, o:Player) {
		switch p.type {
			case NORMAL:
				o.jump();
			case GROUND:
				if (o.state == NORMAL) o.jump(GROUND_MULTIPLIER);
			case CLOUD:
				if (p.available) {
					p.animation.play('play');
					p.available = false;
					p.acceleration.y = -CLOUD_DEPRESS_SPEED * 2;
					p.velocity.y = o.velocity.y = CLOUD_DEPRESS_SPEED;
					puffs.fire({ position: p.getMidpoint(), velocity: FlxPoint.get(-100, 0) });
					puffs.fire({ position: p.getMidpoint(), velocity: FlxPoint.get(100, 0) });
					Timer.get(0.5, () -> {
						o.jump(CLOUD_MULTIPLIER);
						for (i in 0...8) {
							puffs.fire({
								position: p.getMidpoint().add(12.get_random(-12)),
								velocity: FlxPoint.get(0, -240.get_random(100)),
								data: { frame: 6.get_random().floor() }
							});
						}
						p.kill();
					});
				}
			case HAZARD:
				o.state = DEAD;
				o.electric = true;
		}
	}

	function get_powerup(powerup:Cube, player:Player) {
		player.powerup_timer = POWERUP_TIME;
		for (i in 0...6) {
			var v = Vec2.get(150, 0);
			v.angle = i * 360/6;
			cube_particles.fire({
				position: powerup.getMidpoint(),
				velocity: FlxPoint.get(v.x, v.y),
			});
			v.put();
		}
		powerup.kill();
	}

	function set_score(v:Int) {
		if (v <= score) return score;
		score_text.text = '$v';
		return score = v;
	}

}