# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends "res://enemies/enemy.gd"

const FLUFF_AIR_FRICTION = 100
const FLUFF_TYPE_SLEEPY = 0
const FLUFF_TYPE_FOLLOW = 1
const FLUFF_TYPE_FAST_FOLLOW = 2
const FLUFF_FOLLOW_MAX_VEL = 64
const FLUFF_FAST_FOLLOW_MAX_VEL = 264
const FLUFF_FOLLOW_DISTANCE = 600

const SLEEP_TIME = 2.5
const SLEEP_RANDOM_TIME = 1.5
const FOLLOW_TIME = 7.0
const ATTACK_TIME = 4.0
const SPIKE_BAN_TIME = 3.0

export(int, "sleepy", "follow", "follow_fast") var fluff_type = 0
export var doing_damage = false

var colors = [Color(0.85, 0.5, 0.85), Color(0.85, 0.85, 0.5), Color(0.5, 0.85, 0.85)]

var sleeping = true
var action_time = 0.3 # Be more reactive to wake up

var disabled = true
var current_anim = ""
var eyes = null
var spiked = false

var spikes_banned = 0

var dead = false

var spiked_count = 0

func _on_body_enter_spikes(body):
	set_linear_velocity(get_linear_velocity()) # Wake up
	if body extends preload("res://player/alpaca.gd"):
		spiked_count += 1

func _on_body_exit_spikes(body):
	if body extends preload("res://player/alpaca.gd"):
		spiked_count -= 1

func inflicts_damage():
	return doing_damage

func _enter_tree():
	#set_can_sleep(fluff_type == FLUFF_TYPE_SLEEPY) # Oh, the irony!
	eyes = get_node("base_sclera/Position2D")
	get_node("anim").play("sleep_loop")
	get_node("anim").set_active(false)
	var c = colors[fluff_type]
	c.r *= 0.3
	c.g *= 0.3
	c.b *= 0.3
	#get_node("smoke").set_color_phase_color(1, c)
	get_node("base_sclera/Position2D/pupils").set_modulate(colors[fluff_type])
	c = colors[fluff_type]
	c.a *= 0.6
	#get_node("smoke").set_color_phase_color(2, c)
	sleeping = true

func takes_damage():
	return not doing_damage and not dead #not get_node("spike_area").is_monitoring_enabled()

func attacked(bywho):
	if not takes_damage() or dead:
		return
	dead = true
	get_node("anim").play("die")
	Physics2DServer.body_add_collision_exception(get_rid(), bywho.get_rid())

func damage_end():
	explode()

func _integrate_forces(state):
	if disabled or dead:
		return

	var cc = null
	var cvec = null
	var cdist = 0.0
	if not sleeping and eyes:
		cc = get_closest_character()
		if cc:
			var gpos = cc.get_global_pos()
			var origin = state.get_transform().get_origin()
			cdist = gpos.distance_to(origin)
			cvec = (gpos - origin).normalized()
			eyes.set_pos(cvec*4)

	var new_anim = "awake_loop"
	var lv = state.get_linear_velocity()

	if sleeping:
		var v = lv.length()
		v -= state.get_step()*FLUFF_AIR_FRICTION
		if v < 0:
			v = 0
		lv = lv.normalized()*v

		if fluff_type != FLUFF_TYPE_SLEEPY:
			action_time -= state.get_step()
			if action_time < 0:
#				print("FOLLOW BEGIN")
				action_time = FOLLOW_TIME
				get_node("anim").play("awake_loop")
				sleeping = false

	else:
		action_time -= state.get_step()

		if cc:
			if not spiked and cdist > FLUFF_FOLLOW_DISTANCE:
				var v = lv.length()
				v -= state.get_step()*FLUFF_AIR_FRICTION
				if v < 0:
					v = 0
				lv = lv.normalized()*v
			else:
				var strength = 40
				var lvl = lv.length()
				var maxvel
				if fluff_type == FLUFF_TYPE_FAST_FOLLOW:
					maxvel = FLUFF_FAST_FOLLOW_MAX_VEL
				else:
					maxvel = FLUFF_FOLLOW_MAX_VEL
				if spiked or lvl < maxvel:
					var newvel = lvl + state.get_step()*strength
					lv = lv.normalized().linear_interpolate(cvec, state.get_step()*20).normalized()*newvel

#		print("spiked: ",spiked," scount ",spiked_count)
		if not spiked and spiked_count and spikes_banned <= 0:
			#print("SPIKIED")
			get_node("anim").play("spike_burst")
			get_node("anim").queue("awake_loop")
			spiked = true
			action_time = ATTACK_TIME
		if spikes_banned > 0:
			spikes_banned -= state.get_step()

		if action_time < 0 and get_node("anim").get_current_animation() != "spike_burst":
			#print("SWITCH TO SLEEP")
			if spiked:
				get_node("anim").play("spike_retract")
				spiked = false
				action_time = FOLLOW_TIME
				get_node("anim").queue("awake_loop")
				spikes_banned = SPIKE_BAN_TIME
			else:
				action_time = SLEEP_TIME + rand_range(0, SLEEP_RANDOM_TIME)

				get_node("anim").play("to_sleep")
				get_node("anim").queue("sleep_loop")
				sleeping = true
				spikes_banned = 0

	state.set_linear_velocity(lv)

func _on_body_enter(body_id, body):
	if body extends preload("res://player/alpaca.gd"):
		body.hit_begin()

func _on_body_exit(body_id, body):
	if body extends preload("res://player/alpaca.gd"):
		body.hit_end()

func _on_enter_screen():
	set_mode(MODE_CHARACTER)
	disabled = false
	current_anim = ""
#	get_node("smoke").set_emitting(true)
	get_node("anim").set_active(true)

func _on_exit_screen():
	set_mode(MODE_STATIC)
	disabled = true
	get_node("anim").set_active(false)
	#get_node("smoke").set_emitting(false)
