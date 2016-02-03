
extends "res://enemies/enemy.gd"

# member variables here, example:
# var a=2
# var b="textvar"


const STATUS_CREATED = 1
const STATUS_SPIKY = 2
const STATUS_DYING = 3

const SPIKY_TIME = 10
const SPIKY_RAND_TIME = 2
const DYING_TIME = 2

const AIR_FRICTION = 150
const STOP_FRICTION = 300

var status = STATUS_CREATED
var timeout=2
const FALL_SPEED = 1400

var spr=null

func activate():

	if (status==STATUS_CREATED):
		status=STATUS_SPIKY
		timeout=SPIKY_TIME+randf()*SPIKY_RAND_TIME
		get_node("anim").play("spike")
		get_node("anim").queue("fall")


func inflicts_damage():
	return spr.get_frame()==2

func _integrate_forces(state):

	
	timeout-=state.get_step()
	
	if (status==STATUS_CREATED):
	
		var lv = state.get_linear_velocity()
		var v = lv.length()
		v -= state.get_step()*AIR_FRICTION
		if (v<0):
			v=0
		lv = lv.normalized()*v
		state.set_linear_velocity(lv)
			
	elif (status==STATUS_SPIKY):
	
		
		var lv = state.get_linear_velocity()
		var v = lv.length()
		v -= state.get_step()*STOP_FRICTION
		if (v<0):
			v=0
		lv = lv.normalized()*v
		lv.y=FALL_SPEED*state.get_step()		
		state.set_linear_velocity(lv)
		
		if (timeout<0):
			status=STATUS_DYING
			timeout=DYING_TIME
			get_node("anim").play("dissolve")
			
	elif (status==STATUS_DYING):
	
		var so = timeout/DYING_TIME

		spr.set_self_opacity(so)
		if (timeout<0):
			queue_free()
			
		
		

	


func _ready():
	# Initalization here
	spr=get_node("sprite")
	pass


