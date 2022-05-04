package states;

import js.Browser;
import ui.MuteBtn;
import ui.Transition;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import zero.utilities.Ease;
import zero.utilities.Tween;
import zero.utilities.Timer;
import flixel.group.FlxGroup;
import ui.Button;
import flixel.FlxSprite;


class Instructions extends State {

	var background:FlxSprite;
	var clouds:FlxTypedGroup<FlxSprite>;
	var title_graphic:FlxSprite;
	var redhat_logo:FlxSprite;

	var play_button:Button;
	var confirm_button:Button;

	override function create() {
		super.create();

		util.GameState.tut = true;
		util.GameState.save();

		bgColor = 0xFFaedcdd;

		background = new FlxSprite(0,0,Images.title_background__png);
		clouds = new FlxTypedGroup();
		title_graphic = new FlxSprite(0,-12,Images.instructions_level_up_logo__png);
		play_button = new ui.Button(FlxG.width/2 - 33,FlxG.height/2+24);
		play_button.loadGraphic(Images.instructions_got_it_button__png, true, 66, 17);
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

		var mobile = js.Browser.navigator.userAgent.contains('Mobile');
		var instructions = new FlxSprite(0,0,mobile ? Images.instructions_text_mobile__png : Images.instructions_text__png);
		instructions.screenCenter();
		instructions.x = instructions.x.floor();
		instructions.y = instructions.y.floor();
		add(instructions);
		
		add(new MuteBtn());

		new Transition(this, IN);
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
		Sounds.play(Audio.posi__mp3, 0.5);
		play_button.flicker(0.25, 0.05, false, true, (_) -> play_button.kill());
		play_button.interactive = false;
		new Transition(this, OUT, () -> Timer.get(0.25, () -> FlxG.switchState(new states.PlayState())));
	}

	override function update(dt:Float) {
		super.update(dt);
		for (cloud in clouds) if (cloud.x < -cloud.width) cloud.setPosition(FlxG.width, FlxG.height * 0.66.get_random(0.33));
	}
	
}