package states;

import lime.media.howlerjs.Howl;
import ui.MuteBtn;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import zero.utilities.Ease;
import zero.utilities.Tween;
import zero.utilities.Timer;
import flixel.group.FlxGroup;
import ui.Button;
import flixel.FlxSprite;


class TitleScreen extends State {

	var background:FlxSprite;
	var clouds:FlxTypedGroup<FlxSprite>;
	var title_graphic:FlxSprite;
	var redhat_logo:FlxSprite;

	var play_button:Button;
	var confirm_button:Button;

	override function create() {
		super.create();

		util.GameState.load();

		FlxG.camera.flash(0xFFe4f3f4, 0.2);

		bgColor = 0xFFaedcdd;

		background = new FlxSprite(0,0,Images.title_background__png);
		clouds = new FlxTypedGroup();
		title_graphic = new FlxSprite(0,0,Images.title_level_up_logo__png);
		play_button = new ui.Button(FlxG.width/2 - 26,FlxG.height/2+24);
		play_button.loadGraphic(Images.title_start_button__png, true, 53, 17);
		play_button.animation.add('flicker', [0,1,0,1,0], 15, false);
		redhat_logo = new FlxSprite(0,0,Images.title_red_hat_logo__png);

		make_clouds();

		background.scrollFactor.set(0,0.5);

		play_button.on_hover = () -> play_button.animation.play('flicker');
		play_button.on_click = () -> go_to_next();

		add(background);
		add(clouds);
		add(title_graphic);
		add(play_button);
		add(redhat_logo);
		add(new MuteBtn());
	}

	function make_clouds() {
		for (i in 0...3) {
			var cloud = new FlxSprite(i * 64, FlxG.height * 0.66.get_random(0.33), Images.title_cloud_small__png);
			cloud.scrollFactor.set(1, 0.6);
			cloud.alpha = 0.25;
			cloud.velocity.x = -10;
			clouds.add(cloud);
			cloud.offset.y = cloud.height/2;
		}
		for (i in 0...2) {
			var cloud = new FlxSprite(i * 80 + 32, FlxG.height * 0.66.get_random(0.4), Images.title_cloud_medium__png);
			cloud.scrollFactor.set(1, 0.7);
			cloud.alpha = 0.25;
			cloud.velocity.x = -15;
			clouds.add(cloud);
			cloud.offset.y = cloud.height/2;
		}
		var cloud = new FlxSprite(64.get_random(12), FlxG.height * 0.6.get_random(0.4), Images.title_cloud_large__png);
		cloud.scrollFactor.set(1, 0.8);
		cloud.alpha = 0.25;
		cloud.velocity.x = -20;
		clouds.add(cloud);
		cloud.offset.y = cloud.height/2;
	}

	function go_to_next() {
		if (util.GameState.music == null) {
			util.GameState.music = new lime.media.howlerjs.Howl({
				src: ['assets/audio/music.ogg', 'assets/audio/music.mp3'],
				loop: true,
				autoplay: true,
				mute: util.GameState.muted,
			});
		}
		play_button.flicker(0.25, 0.05, false, true, (_) -> play_button.kill());
		play_button.interactive = false;
		Tween.tween(camera.scroll, 1.5, { y: -FlxG.height*1.25 }, { ease: Ease.sineIn, on_complete: () -> {
			FlxG.switchState(new CharSelect());
		}});
		Timer.get(1, () -> FlxG.camera.fade(0xFFe4f3f4, 0.5));
		Sounds.play(Audio.posi__mp3, 0.5);
	}

	override function update(dt:Float) {
		super.update(dt);
		for (cloud in clouds) if (cloud.x < -cloud.width) cloud.setPosition(FlxG.width, FlxG.height * 0.66.get_random(0.33));
		#if debug
		if (FlxG.keys.justPressed.I) util.GameState.init();
		#end
	}
	
}