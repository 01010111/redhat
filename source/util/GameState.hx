package util;

import lime.media.howlerjs.Howl;
import states.TitleScreen;
import lime.media.howlerjs.Howler;
import flixel.util.FlxSave;
using Math;

var player:Int = 0;
var hat:Bool = false;
var shirt:Bool = false;
var pants:Bool = false;
var hi:Int = 0;
var tut:Bool = false;
var id:Int;
var initials:String;
var muted(default, set):Bool = false;

var save_data:FlxSave;

function save() {
	bind();
	save_data.data.player = player;
	save_data.data.hat = hat;
	save_data.data.shirt = shirt;
	save_data.data.pants = pants;
	save_data.data.hi = hi;
	save_data.data.tut = tut;
	save_data.data.id = id;
	save_data.data.initials = initials;
	save_data.data.muted = muted;
	save_data.flush();
}

function load() {
	bind();
	if (save_data.data == null) return init();
	player = save_data.data.player != null ? save_data.data.player : 0;
	hat = save_data.data.hat != null ? save_data.data.hat : false;
	shirt = save_data.data.shirt != null ? save_data.data.shirt : false;
	pants = save_data.data.pants != null ? save_data.data.pants : false;
	hi = save_data.data.hi != null ? save_data.data.hi : 0;
	tut = save_data.data.tut != null ? save_data.data.tut : false;
	id = save_data.data.id != null ? save_data.data.id : (Math.random() * 2147483647).floor();
	initials = save_data.data.initials != null ? save_data.data.initials : '';
	muted = save_data.data.muted != null ? save_data.data.muted : false;
	save();
}

function bind() {
	if (save_data != null) return;
	save_data = new FlxSave();
	save_data.bind('level-up-league');
}

function init() {
	player = 0;
	hat = false;
	shirt = false;
	pants = false;
	hi = 0;
	tut = false;
	id = (Math.random() * 2147483647).floor();
	initials = '';
	muted = false;
	save();
}

function set_muted(b) {
	muted = b;
	if (music != null) music.mute(b);
	save();
	return muted;
}

var music:Howl;