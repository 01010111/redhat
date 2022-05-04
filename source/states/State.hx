package states;

import zero.utilities.Tween;
import zero.utilities.Timer;

class State extends zero.flixel.states.State {
	
	public function new() {
		Timer.cancel_all();
		super();
	}

}