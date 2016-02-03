# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends "res://enemies/enemy.gd"

# member variables here, example:
# var a=2
# var b="textvar"

const STATUS_IDLE=0
const STATUS_ATTACK=1
const STATUS_FLIPPING=2
const STATUS_TIRED=3
const STATUS_DAMAGED=4
const STATUS_DEAD=5

var tired_time=2.0
var idle_time=2.0
var idle_countdown=0.0

var tired_countdown=0.0

var status=STATUS_IDLE

var energy = 1

var anim=""
var siding_left=true

func takes_damage():
	return status!=STATUS_ATTACK and status!=STATUS_DAMAGED and status !=STATUS_DEAD

func inflicts_damage():
	return false

func attacked(bywho):
	if (status==STATUS_IDLE):
		get_node("sprites/Rib/Chest/shield_orientation/ArmFG/ForearmFG/HandFG/Shield/fire").set_emitting(true)
		anim="attack"
		status=STATUS_ATTACK
		get_node("anim").play("block")
		get_node("anim").queue("attack")
	elif (energy>1):
		status=STATUS_DAMAGED
		get_node("anim").play("take_damage")
		anim="take_damage"
		energy-=1
	else:
		status=STATUS_DEAD
		get_node("anim").play("death")
		anim="death"

		


var alpacas=[]
var others=[]

func _on_body_enter(body):
	if (body extends preload("res://player/alpaca.gd")):
		alpacas.push_back(body)
	elif (body extends RigidBody):
		others.push_back(body)
		

func _on_body_exit(body):
	if (body extends preload("res://player/alpaca.gd")):
		alpacas.erase(body)
	elif (body extends RigidBody):
		others.erase(body)
		

func _on_damage_enter(body):
	if (body extends preload("res://player/alpaca.gd")):
		body.hit_begin()
	body.set_linear_velocity( (body.get_global_pos() - get_global_pos()).normalized()*700 )
		

func _on_damage_exit(body):
	if (body extends preload("res://player/alpaca.gd")):
		body.hit_end()

func _do_flip():
	siding_left=!siding_left
	var scale
	if (siding_left):
		scale=Vector2(1,1)
	else:
		scale=Vector2(-1,1)
	get_node("sprites").set_scale(scale)

func _integrate_forces(state):

	var lv = state.get_linear_velocity()
	var new_anim=""

	var fixed_pos = true

	if (status==STATUS_IDLE):
		
		new_anim="idle"
		
		idle_countdown-=state.get_step()
		
		if (alpacas.size() or others.size()):
		
			var attacking=false
			
			for a in alpacas:
				if (a.is_attacking()):
					attacking=true
					var attackvec = (state.get_transform().get_origin() - a.get_global_pos()).normalized()
					
					var anglefix = -PI*0.5
					if (not siding_left):
						anglefix=-anglefix
					get_node("sprites/Rib/Chest/shield_orientation").set_rot(atan2(attackvec.x,attackvec.y)+anglefix)
					idle_countdown=1.0
					
			if (not attacking and idle_countdown<0):
				status=STATUS_ATTACK
				new_anim="attack"
			get_node("sprites/Rib/Chest/shield_orientation").set_rot(0)
		else:
		
			var cc = get_closest_character()
			if ((cc.get_global_pos().x < get_global_pos().x) != siding_left):
				status=STATUS_FLIPPING
				new_anim="flipping"
				
			

			
			
	elif (status==STATUS_ATTACK):
		new_anim="attack"
		if (not get_node("anim").is_playing()):
			status=STATUS_TIRED
			tired_countdown=tired_time
	elif (status==STATUS_TIRED):
		tired_countdown-=state.get_step()
		if (tired_countdown<0):
			status=STATUS_IDLE
			idle_countdown=idle_time
		new_anim="tired"
	elif (status==STATUS_FLIPPING):
		if (!get_node("anim").is_playing()):
			status=STATUS_IDLE
	elif (status==STATUS_DAMAGED):
		if (!get_node("anim").is_playing()):
			status=STATUS_IDLE
	elif (status==STATUS_DEAD):
		if (!get_node("anim").is_playing()):
			queue_free()
			
	if (fixed_pos):
		var lvlen = lv.length()
		if (lvlen):
			var lvn = lv.normalized()
			lvlen -= state.get_step()*1000.0
			if (lvlen<0):
				lvlen=0
			lv = lvn * lvlen
			
	
	
	state.set_linear_velocity(lv)
	if (new_anim!=anim):
		get_node("anim").play(new_anim)
		anim=new_anim

func _ready():
	# Initalization here
#	var snode = get_node("sprites/Rib/Chest/ArmBG/ForearmBG/HandBG/Sword/damager/sword_solid").get_node()
#	Physics2DServer.body_add_collision_exception(get_body(),snode.get_body())
	pass


