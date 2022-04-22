package states;

import zero.flixel.ui.BitmapText;
import ui.Transition;
import ui.Button;
import zero.utilities.Ease;
import zero.utilities.Timer;
import zero.utilities.Tween;
import flixel.FlxSprite;
import flixel.FlxSubState;

class PostGame extends FlxSubState {

	var btns:Array<Button> = [];
	var score:Int;
	var new_hi:Bool;

	public function new(score:Int) {
		if (util.GameState.hi < score) {
			util.GameState.hi = score;
			new_hi = true;
		}
		super();
		this.score = score;
	}
	
	override function create() {
		super.create();
		
		var bg = new FlxSprite(0,0);
		bg.makeGraphic(FlxG.width,FlxG.height,0xFF43adaf);
		bg.drawRect(0,0,FlxG.width, FlxG.height, 0x80000000);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);
		Tween.tween(bg, 1, {alpha:0.8}, {on_complete: () -> {
			for (i in 0...3) {
				var btn = new ui.Button(FlxG.width/2 - 48, FlxG.height + i * 20);
				btn.loadGraphic(Images.postgame_buttons__png, true, 96, 17);
				btn.scrollFactor.set();
				btn.animation.add('play', [0+i*2,1+i*2,0+i*2,1+i*2,0+i*2], 15, false);
				btn.animation.frameIndex = i * 2;
				btn.on_hover = () -> btn.animation.play('play');
				btn.on_click = switch (i) {
					case 0:replay;
					case 1:leaderboard;
					case 2:main_menu;
					default:() -> {}
				}
				Timer.get(i * 0.2, () -> Tween.tween(btn, 0.25, { y: FlxG.height/2 + 32 + i * 20 }, { ease: Ease.sineOut }));
				add(btn);
				btns.push(btn);
			}

			var score_text = new BitmapText({
				charset: ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
				graphic: Images.alphabet__png,
				letter_size: FlxPoint.get(8, 8),
				align: CENTER,
				position: FlxPoint.get(0, 32 + 32),
				width: FlxG.width,
			});
			score_text.text = 'SCORE';
			score_text.color = 0xFFEE0000;
			add(score_text);

			var big_score = new BitmapText({
				charset: '0123456789* ',
				graphic: Images.big_numbers__png,
				letter_size: FlxPoint.get(16,16),
				align: CENTER,
				position: FlxPoint.get(0, 44 + 32),
				width: FlxG.width,
			});
			big_score.text = '$score';
			if (new_hi) big_score.text += '*';
			big_score.color = 0xFFEE0000;
			if (new_hi) Timer.get(0.1, () -> big_score.color = big_score.color == 0xFFFFFFFF ? 0xFFEE0000 : 0xFFFFFFFF, 16);
			add(big_score);

			var hi_text = new BitmapText({
				charset: ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
				graphic: Images.alphabet__png,
				letter_size: FlxPoint.get(8, 8),
				align: CENTER,
				position: FlxPoint.get(0, 72 + 32),
				width: FlxG.width,
				line_spacing: 4
			});
			hi_text.text = 'HISCORE\n${util.GameState.hi}';
			add(hi_text);
		}});
	}

	function replay() {
		disable_btns();
		new Transition(this, OUT, () -> Timer.get(0.25, () -> FlxG.switchState(new PlayState())));
	}

	function leaderboard() {
		disable_btns();
		new Transition(this, OUT, () -> Timer.get(0.25, () -> FlxG.switchState(new Leaderboard())));
	}

	function main_menu() {
		disable_btns();
		FlxG.camera.fade(0xFFe4f3f4, 0.2, false, () -> FlxG.switchState(new TitleScreen()));
	}

	function disable_btns () for (btn in btns) btn.interactive = false;

	override function update(elapsed:Float) {
		super.update(elapsed);
		Tween.update(elapsed);
		Timer.update(elapsed);
	}

}