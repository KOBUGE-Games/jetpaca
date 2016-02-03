
extends StaticBody2D

# member variables here, example:
# var a=2
# var b="textvar"

const TYPE_MISSILE=0
const TYPE_SEEKER=1
const TYPE_BUBBLE=2

export(int) var interval=2.0
export(int) var max_alive=4
export(int,"missile","heatseeker","bubbles") var type=0


func _killed_one():
	alive-=1

var alive=0

func _on_timeout():

	get_node("anim").play("firing")
	get_node("anim").queue("idle")

func fire():

	print("TIMEOUT")
	get_node("timer").set_wait_time(interval)
	get_node("timer").start()

	if (alive>=max_alive):
		return
	
	var t = get_global_transform()
	var s
	var dir = -t[0]
	var pos = get_node("cannon_sprites_r90/cannon_rotation/body_orientation/missile2d").get_global_pos()
	var ofs = 0
	
	if (type==TYPE_SEEKER or type==TYPE_MISSILE):
		s=preload("res://enemies/heatseeker.xml").instance()
		s.set_rot( t.get_rotation() ) 
		s.set_seek_heat(type==TYPE_SEEKER)
	elif (type==TYPE_BUBBLE):
		s=preload("res://interaction/bubble.xml").instance()
		ofs=128
		
	var p=get_parent()
	while(p extends CanvasItem):
		p=get_parent()
		
	s.set_pos(pos+dir*ofs)
	p.add_child(s)
	s.connect("exit_scene",self,"_killed_one")
	alive+=1
	



func _on_enter_screen():
	get_node("timer").set_wait_time(interval)
	get_node("timer").start()
	get_node("anim").set_active(true)

func _on_exit_screen():
	get_node("timer").stop()
	get_node("anim").set_active(false)


func _ready():
	# Initalization here
	get_node("anim").play("idle")
	get_node("anim").set_active(false)
	pass


