
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var active=false



func lock(pos):

	set_pos(pos)
	if(not active):
		get_node("anim").play("lock")
		get_node("anim").queue("rotate")
		active=true
	
func unlock():

	if(active):
		get_node("anim").play("unlock")
		active=false


func _ready():
	# Initalization here
	pass


