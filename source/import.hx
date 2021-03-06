// Statics
import states.PlayState.instance as PLAYSTATE;
import objects.Player.instance as PLAYER;
import util.Constants;

// Utilities
import util.AssetPaths;
import util.Sounds;

// Frequent Usage
import flixel.FlxG;
import flixel.math.FlxPoint;

// Extensions
using Math;
using Std;
using flixel.util.FlxSpriteUtil;
using zero.extensions.Tools;
using zero.flixel.extensions.FlxObjectExt;
using zero.flixel.extensions.FlxPointExt;
using zero.flixel.extensions.FlxSpriteExt;
using zero.flixel.extensions.FlxTilemapExt;
using zero.utilities.EventBus;

#if OGMO
using zero.utilities.OgmoUtils;
using zero.flixel.utilities.FlxOgmoUtils;
#end