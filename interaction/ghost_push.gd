extends "enemies/enemy.gd"

# member variables here, example:
# var a=2
# var b="textvar"



const MODE_GRAB=0
const MODE_DIRECTED=1
const MODE_STOP=2

export(int,"grab","directed","stop") var boost_mode=0
export var boost_value=1300

var disabled=false
var incount=0
	
func _on_timeout():
	disabled=false

func _on_push_enter(body):

	if (body extends RigidBody2D):
		if (boost_mode==MODE_DIRECTED):
			body.set_linear_velocity( get_global_transform()[0]*boost_value )
			if (body extends preload("res://player/alpaca.gd")):			
					body.cancel_attack()
			disabled=true
			get_node("timer").start()
			get_node("particles").set_emitting(true)
		elif (boost_mode==MODE_STOP):
		
			body.set_linear_velocity( Vector2() )
			if (body extends preload("res://player/alpaca.gd")):			
				body.cancel_attack()
			incount+=1
			if (incount==1):
				disabled=true
			

func _on_push_exit(body):

	if (boost_mode==MODE_STOP and body extends RigidBody2D):
		incount-=1
		if (incount==0):
			disabled=false #get_node("timer").start()

func inflicts_damage():
	return false

func takes_damage():
	return !disabled

		
func _ready():
	# Initalization here
	pass
