extends RigidBody2D


const DROP_NONE=0
const DROP_HEART=1
const DROP_KEY1=2
const DROP_KEY2=3
const DROP_KEY3=4



export(int,"None","Heart","Key1","Key2","Key3") var drop=DROP_NONE
var explosion = null

func inflicts_damage():
	return true

func takes_damage():
	return false

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
	
func explode():
	hide()
	queue_free()
	var n = explosion.instance()
	get_parent().add_child(n)
	n.set_global_transform(get_global_transform())
	n.explode()
	if (drop):
		
		var dropscene=null
		if (drop==DROP_HEART):
			dropscene = preload("res://player/heart.xml").instance()
		elif (drop==DROP_KEY1):
			dropscene = preload("res://interaction/key.xml").instance()
			dropscene.key_index=0
		elif (drop==DROP_KEY2):
			dropscene = preload("res://interaction/key.xml").instance()
			dropscene.key_index=1
		elif (drop==DROP_KEY3):
			dropscene = preload("res://interaction/key.xml").instance()
			dropscene.key_index=2
			
		get_parent().call_deferred("add_child", dropscene )
		dropscene.set_global_transform(get_global_transform())
	
func _on_enter_screen():
	pass

func _on_exit_screen():
	pass

func _enter_tree():

	explosion = preload("res://enemies/explosion.xml")
	var c = VisibilityNotifier2D.new()
	c.connect("enter_screen",self,"_on_enter_screen")
	c.connect("exit_screen",self,"_on_exit_screen")
	add_child(c)
	
