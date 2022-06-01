package states;

import ui.MuteBtn;
import ui.Transition;
import zero.utilities.Timer;
import zero.utilities.Tween;
import flixel.util.FlxAxes;
import ui.Button;
import flixel.FlxSprite;


class CharSelect extends State {

	var instructions:FlxSprite;
	var illustrations:FlxSprite;
	var player_select:FlxSprite;
	var p1_select:Button;
	var p2_select:Button;
	var p3_select:Button;
	var bottom_bar:FlxSprite;
	var confirm_btn:Button;
	var jump_btn:Button;
	
	override function create() {
		super.create();

		bgColor = 0xFFe4f3f4;
		FlxG.camera.flash(0xFFe4f3f4, 0.2);
		
		instructions = new FlxSprite(0, 12, Images.player_select_your_player__png);
		instructions.screenCenter(FlxAxes.X);
		instructions.x = instructions.x.round();
		add(instructions);

		illustrations = new FlxSprite(0, 32);
		illustrations.loadGraphic(Images.outfit_sprites__png, true, 144, 120);
		add(illustrations);

		player_select = new FlxSprite(FlxG.width/2 - 60, 152);
		player_select.loadGraphic(Images.player_select__png, true, 120, 64);
		add(player_select);

		p1_select = new Button(FlxG.width/2 - 60, 152);
		p1_select.makeGraphic(120, 15, 0x00FF004D);
		add(p1_select);

		p2_select = new Button(FlxG.width/2 - 60, 174);
		p2_select.makeGraphic(120, 15, 0x00FF004D);
		add(p2_select);

		p3_select = new Button(FlxG.width/2 - 60, 196);
		p3_select.makeGraphic(120, 15, 0x00FF004D);
		add(p3_select);

		var select = (i, b = true) -> {
			if (b) Sounds.play(Audio.select__mp3, 0.5);
			illustrations.animation.frameIndex = i * 8;
			player_select.animation.frameIndex = i;
			util.GameState.persona = i;
		}

		p1_select.on_click = () -> select(0);
		p2_select.on_click = () -> select(1);
		p3_select.on_click = () -> select(2);
		
		select(util.GameState.persona, false);

		bottom_bar = new FlxSprite(0, FlxG.height - 37);
		bottom_bar.makeGraphic(FlxG.width, 37, 0xFFaedcdd);
		add(bottom_bar);

		confirm_btn = new Button(0, FlxG.height - 27);
		confirm_btn.loadGraphic(Images.player_confirm_button__png, true, 72, 17);
		confirm_btn.animation.add('flicker', [0,1,0,1,0], 15, false);
		confirm_btn.screenCenter(flixel.util.FlxAxes.X);
		confirm_btn.on_hover = () -> confirm_btn.animation.play('flicker');
		confirm_btn.on_click = () -> outfit_select();
		add(confirm_btn);

		add(new MuteBtn());
	}

	function outfit_select() {
		Sounds.play(Audio.posi__mp3, 0.5);
		confirm_btn.interactive = false;
		confirm_btn.flicker(0.25,0.05,false,true,(_)->{
			instructions.loadGraphic(Images.product_build_your_player__png);
			instructions.screenCenter(FlxAxes.X);
			instructions.x = instructions.x.round();
			player_select.kill();
			p1_select.kill();
			p2_select.kill();
			p3_select.kill();
			
			var do_you_own = new FlxSprite(0, 152, Images.product_do_you_use__png);
			do_you_own.screenCenter(FlxAxes.X);
			add(do_you_own);

			var prods = [];
			for (i in 0...3) {
				var product_bar = new Button(11, 162 + i * 17);
				product_bar.loadGraphic(Images.product_bar__png, true, 122, 16);
				add(product_bar);
				var play_sound = false;
				product_bar.on_click = () -> {
					if (play_sound) Sounds.play(Audio.select__mp3, 0.5);
					product_bar.animation.frameIndex = product_bar.animation.frameIndex == 0 ? 1 : 0;
					switch i {
						case 0: util.GameState.hat = product_bar.animation.frameIndex == 1;
						case 1: util.GameState.shirt = product_bar.animation.frameIndex == 1;
						case 2: util.GameState.pants = product_bar.animation.frameIndex == 1;
					}
					var f = 0;
					if (util.GameState.hat) f += 1;
					if (util.GameState.shirt) f += 2;
					if (util.GameState.pants) f += 4;
					f += util.GameState.persona * 8;
					illustrations.animation.frameIndex = f;
				}
				switch i {
					case 0: if (util.GameState.hat) product_bar.on_click();
					case 1: if (util.GameState.shirt) product_bar.on_click();
					case 2: if (util.GameState.pants) product_bar.on_click();
				}
				play_sound = true;
				prods.push(product_bar);
			}

			var product_type = new FlxSprite(28, 164, Images.products_type__png);
			add(product_type);

			jump_btn = new Button(0, FlxG.height - 27);
			jump_btn.loadGraphic(Images.product_jump_in_button__png, true, 72, 17);
			jump_btn.animation.add('flicker', [0,1,0,1,0], 15, false);
			jump_btn.screenCenter(flixel.util.FlxAxes.X);
			jump_btn.on_hover = () -> jump_btn.animation.play('flicker');
			jump_btn.on_click = () -> {
				go_to_game();
				for (p in prods) p.interactive = false;
			}
			add(jump_btn);
		});
	}

	function go_to_game() {
		Sounds.play(Audio.posi__mp3, 0.5);
		util.GameState.save();
		jump_btn.interactive = false;
		new Transition(this, OUT, () -> Timer.get(0.25, () -> FlxG.switchState(util.GameState.tut ? new PlayState() : new states.Instructions())));
	}

}