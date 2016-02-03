
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"

var checked=false

func _on_body_enter(body):
	
	if (not checked and body extends preload("res://player/alpaca.gd")):
		get_node("anim").play("checked")
		get_node("tune").play()
		checked=true
		var gd = get_tree().get_root().get_node("game_data")
		gd.current_checkpoint=get_path()
		var cw = gd.current_world
		cw.large_fruits=[]
		body.restore_life(2)
#		gd.current_world.large_fruits=[] bug
		
		# save the amount of large fruits collected
		for x in gd.current_large_fruits: 
			cw.large_fruits.push_back(x)
		

func _ready():
	# Initalization here
	pass


