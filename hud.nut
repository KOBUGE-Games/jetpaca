
class Hud extends ReferenceFrame {

	// member variables here, example:
	// a=2
	// b="textvar"
	
	function hint_show(text) {
		get_node("anim").get_animation("fadein").track_set_key_value(0,1,text)
		get_node("anim").play("fadein")
	}

	function hint_hide() {
		get_node("anim").play("fadeout")
	}

	constructor() {
		ReferenceFrame.constructor() //always call parent constructor first
		//initialization here
	}
}


return Hud // main class must be returned
