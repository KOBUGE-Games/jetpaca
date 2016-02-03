
extends "res://enemies/enemy.gd"

# member variables here, example:
# var a=2
# var b="textvar"

const FOLLOW_SPEED=450
const FOLLOW_ACCEL=2.5
const TURN_SPEED=5

export(bool) var seek_heat=true

func set_seek_heat(seek):
	seek_heat=seek

func _integrate_forces(state):

	var lv=state.get_linear_velocity()
	var vel =lv.length()
	var cc=get_closest_character()
	var t = state.get_transform()	
	if (cc and seek_heat):

		if (cc.is_jetpack_on()):
			var cvec=(cc.get_global_pos() - t.get_origin()).normalized()
			var lvec= -t[0].normalized()
			var vel=lv.length()
			var a = atan2(lvec.tangent().dot(cvec),lvec.dot(cvec))
			t=t.rotated(a*state.get_step()*TURN_SPEED)
			state.set_transform(t)


	vel+=FOLLOW_ACCEL
	if (vel>FOLLOW_SPEED):
		vel=FOLLOW_SPEED
	lv=-t[0].normalized()*vel		
	state.set_linear_velocity(lv)
	state.set_angular_velocity(0)
		
	if (state.get_contact_count()): #explode at first contact
		for i in range(state.get_contact_count()):
			var co = state.get_contact_collider_object(i)
			if (co):
				co.call("attacked",self)
			
			
		explode()
		
	


func _on_enter_screen():
	set_mode(MODE_RIGID)
	get_node("particles").set_emitting(true)


func _on_exit_screen():
	#set_mode(MODE_STATIC)
	#get_node("particles").set_emitting(false)
	
	queue_free()
	
	pass



func _ready():
	# Initalization here
	set_can_sleep(false)
	


