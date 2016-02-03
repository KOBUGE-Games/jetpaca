
extends "res://enemies/enemy.gd"

# member variables here, example:
# var a=2
# var b="textvar"


const STATUS_PREPARE = 0
const STATUS_SPITTING = 1 
const STATUS_STOPPED_SPITTING = 2
const STATUS_WAITING_SEEDS = 3
const STATUS_IDLE = 4

var active_seeds=0
var timeout=0.0

var status = STATUS_IDLE

const SPIT_TIME = 2
const STOP_SPIT_TIME = 1
const SPIT_INTERVAL = 0.1

var spores = []

var spit_timeout=0

func _seed_died():
	active_seeds-=1

func _process(delta):


	if (status==STATUS_IDLE):
	
		var cc = get_closest_character()
		if (cc):
			var gt = get_global_transform()
			var ct = cc.get_global_transform()
			var dp = -gt[1].dot((ct.get_origin() - gt.get_origin()).normalized())
			var d = ct.get_origin().distance_to(gt.get_origin())
			
			if (dp > 0.2 and d < 500):
				status=STATUS_PREPARE
				spores=[]
				timeout=SPIT_TIME
				spit_timeout=SPIT_INTERVAL
				get_node("anim").play("2opening")
				get_node("anim").queue("3opened")
				
	elif (status==STATUS_PREPARE):

		if (get_node("anim").get_current_animation()=="3opened"):
			status=STATUS_SPITTING
	elif (status==STATUS_SPITTING):
	
		timeout-=delta
		spit_timeout-=delta
		while(spit_timeout<0):
			spit_timeout+=SPIT_INTERVAL
			print("SPIT!!")
			var s = preload("res://enemies/spore.xml")
			var sp = s.instance()
			sp.set_pos( get_node("shooter").get_global_pos() )
			sp.connect("exit_scene",self,"_seed_died")
			var outvec = -get_global_transform()[1] 
			outvec = Matrix32().rotated( (randf() *2.0 -1.0)*PI*0.5 ).xform(outvec)
			
			sp.set_linear_velocity( outvec * (200.0+400*randf()) )
			get_parent().add_child(sp)
			spores.push_back(sp)
			active_seeds+=1
			
		if (timeout<0):
			status=STATUS_STOPPED_SPITTING
			timeout=STOP_SPIT_TIME

	elif (status==STATUS_STOPPED_SPITTING):

		timeout-=delta
		if (timeout<0):
			status=STATUS_WAITING_SEEDS
			for x in spores:
				x.activate() # activate all spores
			get_node("anim").play("4closing")
			get_node("anim").queue("1closed")
								
	elif (status==STATUS_WAITING_SEEDS):	
		if (active_seeds==0):
			status=STATUS_IDLE
				
	


func _on_enter_screen():

	get_node("anim").set_active(true)
	set_process(true)


func _on_exit_screen():

	get_node("anim").set_active(false)
	set_process(false)


func _ready():
	# Initalization here
	get_node("anim").play("1closed")
	get_node("anim").set_active(false)
	pass

