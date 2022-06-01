package states;

import haxe.Http;
import ui.TransHori;
import ui.Button;
import flixel.group.FlxGroup;
import zero.utilities.Timer;
import zero.flixel.ui.BitmapText;
import ui.MuteBtn;
import ui.Transition;
import flixel.FlxSprite;


class Leaderboard extends State {

	var lb_bars:Array<LeaderboardBar> = [];
	var entries:Array<LBEntry>;

	public function new(?msg:String) {
		super();
		if (msg != null) Timer.get(2, () -> show_msg(msg));
	}
	
	override function create() {
		super.create();
		bgColor = 0xFF43adaf;

		var bg = new FlxSprite(0,0,Images.title_background__png);
		bg.y = -64;
		add(bg);

		for (i in 0...10) {
			var bar = new LeaderboardBar(16, 24 + i * 16);
			lb_bars.push(bar);
			add(bar);
		}
		
		var menu_btn = new ui.Button(FlxG.width/2 - 48, FlxG.height - 32);
		menu_btn.loadGraphic(Images.postgame_buttons__png, true, 96, 17);
		menu_btn.animation.frameIndex = 4;
		menu_btn.animation.add('play', [4,5,4,5,4], 15, false);
		menu_btn.on_hover = () -> menu_btn.animation.play('play');
		add(menu_btn);
		
		var myscore_bg = new FlxSprite(16, 200);
		myscore_bg.makeGraphic(79, 15, 0xFFEE0000);
		add(myscore_bg);

		var myscore_initials = new BitmapText({
			graphic: Images.alphabet__png,
			letter_size: FlxPoint.get(8, 8),
			charset: ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
			position: FlxPoint.get(20, 204),
			width: 71,
			align: LEFT,
		});
		myscore_initials.text = util.GameState.initials;
		add(myscore_initials);
		
		var myscore_score = new BitmapText({
			graphic: Images.alphabet__png,
			letter_size: FlxPoint.get(8, 8),
			charset: ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
			position: FlxPoint.get(20, 204),
			width: 71,
			align: RIGHT,
		});
		myscore_score.text = parse_score(util.GameState.hi);
		add(myscore_score);
		
		var post_btn = new Button(96, 200);
		post_btn.loadGraphic(Images.post_btn__png, true, 32, 15);
		post_btn.animation.add('play', [0,1,0,1,0], 15, false);
		post_btn.on_hover = () -> post_btn.animation.play('play');
		add(post_btn);

		menu_btn.on_click = () -> {
			Sounds.play(Audio.posi__mp3, 0.5);
			menu_btn.interactive = false;
			post_btn.interactive = false;
			FlxG.camera.fade(0xFFe4f3f4, 0.2, false, () -> FlxG.switchState(new TitleScreen()));
		}
		post_btn.on_click = () -> {
			Sounds.play(Audio.posi__mp3, 0.5);
			post_btn.interactive = false;
			menu_btn.interactive = false;
			new TransHori(this, OUT, () -> FlxG.switchState(new Initials()));
		}
		
		add(new MuteBtn());

		new Transition(this, IN);

		get_entries();
	}

	function get_entries() {
		var req = new Http('https://levelup-leaderboard.glitch.me/scores');
		req.onError = (err) -> {
			trace(err);
			show_msg('UNABLE TO CONNECT TO LEADERBOARD\n\nPLEASE TRY AGAIN LATER');
		}
		req.onData = (res) -> {
			entries = haxe.Json.parse(res);
			populate_board();
		};
		req.request();
		return;
	}

	function populate_board() {
		if (entries.length != 10) return;
		for (i in 0...10) {
			Timer.get(i * 0.01, () -> {
				var entry = entries[i];
				var bar = lb_bars[i];
				bar.set_data(i + 1, entry);
			});
		}
	}

	function show_msg(msg:String) {
		var msg_bg = new FlxSprite(16, 24);
		msg_bg.makeGraphic(112, 160);
		msg_bg.drawRect(2, 2, 108, 156, 0xFFEE0000);
		add(msg_bg);

		var msg_text = new BitmapText({
			position: FlxPoint.get(16 + 8, 24 + 8),
			width: 112 - 16,
			align: LEFT,
			graphic: Images.alphabet__png,
			letter_size: FlxPoint.get(8, 8),
			charset: ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
		});
		msg_text.text = msg;
		add(msg_text);
		return;
		Timer.get(4, () -> {
			msg_bg.kill();
			msg_text.kill();
		});
	}

}

typedef LBEntry = {
	initials:String,
	persona:Int,
	products:Int,
	score:Int,
	id:Int,
}

class LeaderboardBar extends flixel.group.FlxGroup {

	var bg:FlxSprite;
	var icon:FlxSprite;
	var place_text:BitmapText;
	var initials_text:BitmapText;
	var score_text:BitmapText;
	
	public function new(x, y) {
		super();

		bg = new FlxSprite(x, y);
		bg.makeGraphic(112, 16, 0x00FFFFFF);
		bg.drawRect(0, 0, 15, 15, 0xFFEE0000);
		bg.drawRect(16, 0, 15, 15, 0xFFEE0000);
		bg.drawRect(32, 0, 80, 15, 0xFFEE0000);

		icon = new FlxSprite(x + 16, y);
		icon.loadGraphic(Images.lb_profiles__png, true, 15, 15);
		icon.animation.frameIndex = 3;

		var opt = {
			graphic: Images.alphabet__png,
			letter_size: FlxPoint.get(8, 8),
			charset: ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
		}
		place_text = new BitmapText(opt);
		initials_text = new BitmapText(opt);
		score_text = new BitmapText(opt);

		place_text.y = initials_text.y = score_text.y = y + 3;
		place_text.x = x;
		initials_text.x = x + 36;
		score_text.x = x + 32;

		place_text.set_field_width(16);
		initials_text.set_field_width(24);
		score_text.set_field_width(76);

		place_text.alignment = CENTER;
		initials_text.alignment = LEFT;
		score_text.alignment = RIGHT;

		add(bg);
		add(icon);
		add(place_text);
		add(initials_text);
		add(score_text);
	}

	public function set_data(place:Int, data:LBEntry) {
		place_text.text = '$place';
		initials_text.text = data.initials;
		score_text.text = parse_score(data.score);
		icon.animation.frameIndex = data.persona;
		if (data.id == util.GameState.id) initials_text.flicker(5, 0.1);
	}

	
}

function parse_score(score:Int):String {
	if (score >= 999999999) return '0';
	if (score >= 10000000) return '${Math.round(score/1000000)}M';
	if (score >= 100000) return '${Math.round(score/1000)}K';
	return '$score';
}