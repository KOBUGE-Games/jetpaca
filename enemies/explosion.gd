
extends Particles2D

# member variables here, example:
# var a=2
# var b="textvar"

func _on_timeout():
	queue_free()

func explode():
	set_emitting(true)
	get_node("player").play("magic_explosion")
	get_node("timer").start()
	print("GO KABOOM")

func _ready():
	# Initalization here
	pass


