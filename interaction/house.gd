
extends StaticBody2D

# member variables here, example:
# var a=2
# var b="textvar"

func _on_enter_screen():
	get_node("parts").set_emitting(true)

func _on_exit_screen():
	get_node("parts").set_emitting(false)

func _ready():
	# Initalization here
	pass


