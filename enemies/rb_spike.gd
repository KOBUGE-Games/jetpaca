
extends RigidBody2D



# member variables here, example:
# var a=2
# var b="textvar"


func _on_body_enter( body ):
	if (body extends preload("res://player/alpaca.gd")):
		body.hit_begin()

func _on_body_exit( body ):
	if (body extends preload("res://player/alpaca.gd")):
		body.hit_end()


func _ready():
	# Initalization here
	pass



