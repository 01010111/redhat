# Level Up League

Created by [Will Blanton](http://twitter.com/x01010111) at [Mobelux](http://mobelux.com) with art by [Jude Buffum](https://judebuffum.com/) in conjunction with [Wildfire](https://wildfireideas.com/) and [Red Hat](https://www.redhat.com/en).

An endless jumper made in Haxe using Haxeflixel for web!

## Build instructions

Download Haxe 4.2.3 from the [haxe website](https://haxe.org/download/version/4.2.3/)

After installing haxe, use haxelib to install dependencies using haxelib in a terminal:

```
haxelib install lime
haxelib install openfl
haxelib install flixel
haxelib git zerolib-flixel https://github.com/01010111/zerolib-flixel
haxelib run lime setup flixel
haxelib run lime setup
```

After running all of the above, open the root folder in a terminal and run `lime build html5`, when the build is complete, the game will be playable at `./release/html5/bin/index.html`

## Gameplay

For quick and easy tweaks to gameplay, check out `util/Constants.hx`

To tweak the player character further, check out `objects/Player.hx`

If you want to tweak the platform spawning behavior, check out the `PlatformManager` class in `objects/Platform.hx`