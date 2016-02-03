
class Enemy extends RigidBody2D {


	function get_closest_character() {

		local clist = get_scene().get_nodes_in_group("character")
		local d = 1.0e10
		local retc=null
		for(local i=0;i<clist.len();i++) {
			
			local ld =  (get_global_pos()-clist[i].get_global_pos()).length()
			if (ld<d) {
				retc=clist[i]
				d=ld
			}
		}

		return retc
	}


	function hit_character(character) {
		
		print("Hit Character!");
	}


	constructor() {
		RigidBody2D.constructor()

	}
}


return Enemy