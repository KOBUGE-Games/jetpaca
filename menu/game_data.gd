
extends Node

# member variables here, example:
# var a=2
# var b="textvar"

class LevelInfo:

	var id=Vector2()
	var large_fruits=[false,false,false]
	var max_fruit=0
	var preview_path=""
	var path=""
	var enabled=true
	
	
var last_level=0
var last_world=1
var levels=[]

func get_level(id):
	for x in levels:
		if (x.id==id):
			return x
	return null
	

var current_checkpoint=""
var current_world=null
var current_large_fruits=[false,false,false]
var current_keys=[false,false,false]

var life_count=5

func make_world_current(path):
	for x in levels:
		if (x.path==path):
			current_world=x
			return
	print("Warning: World not found in list: ",path)
	current_world = LevelInfo.new()
	current_world.path=path
	

func game_over():
	life_count=5
	stage_clear()
	
func stage_clear():
	life_count=5
	current_checkpoint=""
	current_world=null
	current_large_fruits=[]
	current_keys=[false,false,false]
	
	

func _init():
	# Initalization here
	
	var ld = ResourceLoader.load("res://stages/stage_list.gd").get_stage_list()
	for x in ld:
		var li = LevelInfo.new()
		li.id=x.id
		li.path=x.path+".xml"
		li.preview_path=x.path+".png"
		if (li.id==Vector2(2,1)):
			li.enabled=true
		else:
			li.enabled=true
		levels.push_back(li)		
		print("Level: ",li.id," path: ",li.path)

	
	#get_tree().set_singleton("game_data",self)


