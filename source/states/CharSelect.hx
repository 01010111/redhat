package states;

import zero.utilities.Timer;
import zero.utilities.Tween;
import flixel.util.FlxAxes;
import ui.Button;
import flixel.FlxSprite;
import zero.flixel.states.State;

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
		add(instructions);

		illustrations = new FlxSprite(0, 32);
		illustrations.loadGraphic(Images.outfit_sprites__png, true, 144, 120);
		add(illustrations);

		player_select = new FlxSprite(0, 152);
		player_select.loadGraphic(Images.player_select__png, true, 144, 66);
		add(player_select);

		p1_select = new Button(12, 170);
		p1_select.makeGraphic(38, 38, 0x00FF004D);
		add(p1_select);

		p2_select = new Button(53, 170);
		p2_select.makeGraphic(38, 38, 0x00FF004D);
		add(p2_select);

		p3_select = new Button(94, 170);
		p3_select.makeGraphic(38, 38, 0x00FF004D);
		add(p3_select);

		p1_select.on_click = () -> {
			illustrations.animation.frameIndex = 0;
			player_select.animation.frameIndex = 0;
			util.GameState.player = 0;
		}
		p2_select.on_click = () -> {
			illustrations.animation.frameIndex = 8;
			player_select.animation.frameIndex = 1;
			util.GameState.player = 1;
		}
		p3_select.on_click = () -> {
			illustrations.animation.frameIndex = 16;
			player_select.animation.frameIndex = 2;
			util.GameState.player = 2;
		}

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
	}

	function outfit_select() {
		confirm_btn.interactive = false;
		confirm_btn.flicker(0.25,0.05,false,true,(_)->{
			instructions.loadGraphic(Images.product_build_your_player__png);
			instructions.screenCenter(FlxAxes.X);
			player_select.kill();
			p1_select.kill();
			p2_select.kill();
			p3_select.kill();
			
			var do_you_own = new FlxSprite(0, 152, Images.product_do_you_use__png);
			do_you_own.screenCenter(FlxAxes.X);
			add(do_you_own);

			for (i in 0...3) {
				var product_bar = new Button(11, 162 + i * 18);
				product_bar.loadGraphic(Images.product_bar__png, true, 122, 16);
				add(product_bar);
				product_bar.on_click = () -> {
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
					f += util.GameState.player * 8;
					illustrations.animation.frameIndex = f;
				}
			}

			jump_btn = new Button(0, FlxG.height - 27);
			jump_btn.loadGraphic(Images.product_jump_in_button__png, true, 72, 17);
			jump_btn.animation.add('flicker', [0,1,0,1,0], 15, false);
			jump_btn.screenCenter(flixel.util.FlxAxes.X);
			jump_btn.on_hover = () -> jump_btn.animation.play('flicker');
			jump_btn.on_click = () -> go_to_game();
			add(jump_btn);
		});
	}

	function go_to_game() {
		jump_btn.interactive = false;
		var slide = new FlxSprite(0, FlxG.height);
		slide.makeGraphic(FlxG.width, FlxG.height, 0xffee0000);
		add(slide);
		Tween.tween(slide, 0.2, { y: 0 }, { on_complete: () -> {
			Timer.get(0.25, () -> FlxG.switchState(new PlayState()));
		}});
	}

}