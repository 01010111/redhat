package states;

import zero.utilities.Timer;
import haxe.Http;
import lime.net.HTTPRequest;
import haxe.macro.Type.Ref;
import zero.flixel.ui.BitmapText;
import ui.Button;
import ui.TransHori;
import flixel.FlxSprite;

using StringTools;
using haxe.Json;

class Initials extends State {
	
	var index(default, set):Int;
	var initials(default, set):String;
	var allow_input:Bool = true;
	var index_marker:FlxSprite;
	var initial_arr:Array<BitmapText>;

	override function create() {
		super.create();
		bgColor = 0xFF43adaf;

		var bg = new FlxSprite(0,0,Images.title_background__png);
		bg.y = -64;
		add(bg);

		var instructions = new BitmapText({
			graphic: Images.alphabet__png,
			letter_size: FlxPoint.get(8, 8),
			charset: ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789bo_',
			position: FlxPoint.get(32, FlxG.height/2 - 64),
			width: FlxG.width-64,
			align: CENTER,
		});
		instructions.color = 0xFFEE0000;
		add(instructions);
		instructions.text = 'ENTER YOUR INITIALS';

		var rows = [
			['Q','W','E','R','T','Y','U','I','O','P'],
			['A','S','D','F','G','H','J','K','L'],
			['b','Z','X','C','V','B','N','M','_','o'],
		];

		var y = FlxG.height/2 + 48;
		for (row in rows) {
			var x = FlxG.width/2 - (row.length * 12)/2;
			for (i in 0...row.length) {
				var char = row[i];
				var btn = new Button(x, y);
				btn.makeGraphic(11, 11, 0xFFEE0000);
				var glyph = new FlxSprite(x + 2, y + 2);
				glyph.loadGraphic(Images.alphabet__png, true, 8, 8);
				glyph.animation.frameIndex = ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789bo_'.indexOf(char);
				btn.on_click = () -> input(char);
				add(btn);
				add(glyph);
				x += 12;
			}
			y += 12;
		}

		var red_bg = new FlxSprite(FlxG.width/2 - 32, FlxG.height/2 - 24);
		red_bg.makeGraphic(64, 32, 0xFFEE0000);
		add(red_bg);

		initial_arr = [];
		for (i in 0...3) {
			var t = new BitmapText({
				graphic: Images.alphabet__png,
				letter_size: FlxPoint.get(8, 8),
				charset: ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789bo_',
				position: FlxPoint.get(-16 + i * 16, FlxG.height/2 - 12),
				width: FlxG.width,
				align: CENTER,
			});
			t.scale.set(2,2);
			add(t);
			initial_arr.push(t);
		}

		index_marker = new FlxSprite(0, FlxG.height/2);
		index_marker.makeGraphic(16, 2);
		add(index_marker);

		new TransHori(this, IN);
		index = 0;
		initials = util.GameState.initials.length == 0 ? '   ' : util.GameState.initials;
	}

	function input(s:String) {
		if (!allow_input) return;
		if (s == 'b') {
			index = (index - 1).max(0).floor();
			return;
		}
		if (s == 'o') {
			if (!validate_initials()) {
				var warn = new BitmapText({
					graphic: Images.alphabet__png,
					letter_size: FlxPoint.get(8, 8),
					charset: ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789bo_',
					position: FlxPoint.get(16, FlxG.height-32),
					width: FlxG.width - 32,
					align: CENTER,
				});
				warn.text = 'PLEASE TRY A DIFFERENT NAME';
				warn.flicker(1, 0.1);
				Timer.get(5, () -> warn.kill());
				add(warn);
				return;
			}
			util.GameState.initials = initials;
			util.GameState.save();
			on_submit();
			return;
		}
		if (s == '_') s = ' ';
		Sounds.play(Audio.select__mp3, 0.5);
		
		initial_arr[index].text = s;
		initials = '${initial_arr[0].text}${initial_arr[1].text}${initial_arr[2].text}';
		index = (index + 1).min(2).floor();
	}

	function set_index(v) {
		index_marker.x = v * 16 + FlxG.width/2 - 24;
		return index = v;
	}

	function set_initials(v) {
		for (i in 0...v.length) {
			initial_arr[i].text = v.charAt(i);
		}
		return initials = v;
	}

	function on_submit() {
		allow_input = false;
		trace('submitting score...', { 
			player: util.GameState.player,
			score: util.GameState.hi,
			id: util.GameState.id,
			initials: initials,
		});

		var req = new Http('https://lowdb-leaderboard-demo.glitch.me/post-score');
		req.addHeader('accept', 'application/json');
		req.setParameter('body', {
			player: util.GameState.player,
			score: util.GameState.hi,
			id: util.GameState.id,
			initials: initials,
		}.stringify());
		req.onData = (res) -> {
			trace(res);
			return_to_lb();
		};
		req.onError = (res) -> {
			trace(res);
			return_to_lb('UNABLE TO POST SCORE\n\nPLEASE TRY AGAIN LATER');
		};
		req.request(true);
	}

	function return_to_lb(?msg:String) {
		new TransHori(this, OUT, () -> FlxG.switchState(new Leaderboard(msg)));
		Sounds.play(Audio.posi__mp3, 0.5);
	}

	function validate_initials() {
		return !blacklist.contains(initials);
	}

}

var blacklist = [
	'FAG',
	'NIG',
	'NGR',
	'FUK',
	'CUM',
	'KKK',
	'FUX',
	'FGT',
	'ASS',
	'SEX',
];