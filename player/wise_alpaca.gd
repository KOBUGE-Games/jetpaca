
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"

export(String) var hint="It's dangerous outside. Take this JetPack."

var side_right = true

func _process(delta):

	var cc = get_closest_character()
	
	if (false and cc):
	
		var looking_right = (cc.get_global_pos().x > get_global_pos().x)
		if (looking_right != side_right):
			side_right=looking_right
			if (side_right):
				get_node("body").set_scale( Vector2(1,1) )
			else:
				get_node("body").set_scale( Vector2(-1,1) )


func get_closest_character():

	var clist = get_tree().get_nodes_in_group("character")
	var d = 1.0e10
	var retc=null
	for c in clist:
		var ld =  (get_global_pos()-c.get_global_pos()).length()
		if (ld<d):
			retc=c
			d=ld
		

	return retc



func _on_body_enter( body ):
	if (body extends preload("res://player/alpaca.gd")):
		get_node("anim").play("rant")
		body.show_hint(hint)


func _on_body_exit( body ):
	if (body extends preload("res://player/alpaca.gd")):
		get_node("anim").play("idle")
		body.hide_hint()


func _on_enter_screen():
	get_node("anim").set_active(true)
	set_process(true)

func _on_exit_screen():
	get_node("anim").set_active(false)
	set_process(false)

func _ready():
	get_node("anim").play("idle")
	get_node("anim").set_active(false)
	# Initalization here
	pass


