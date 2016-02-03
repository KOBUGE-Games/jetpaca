
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var unlocked=false

func _on_enter_screen():
	if (not unlocked):
		get_node("anim").play("lock_closed")

func _on_exit_screen():
	if (not unlocked):
		get_node("anim").stop()
		
func unlock():
	get_node("anim").play("lock_opening")
	unlocked=true
	
func set_index(idx):
	get_node("lock/keyhole").set_frame(idx)
	
		

func _ready():
	# Initalization here
	pass


