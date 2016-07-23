# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends RigidBody2D

const CONTROL_TAP = 1
const CONTROL_FULL = 2

const FLY_FORCE = 400
const HIT_INVINCIBILITY_TIME = 3
const MAX_ENERGY = 2

const ATTACK_SPEED = 950
const ATTACK_DURATION = 0.7 # 0.8
const ATTACK_PREPARE_DURATION = 0.15
const ATTACK_SLIDE_TRESHOLD = 50
const ATTACK_TIME_TRESHOLD = 0.4

const enemy_class = preload("res://enemies/enemy.gd")

var jpart_names = ["body/culete/rocket_fg/jetpack_a", "body/culete/rocket_bg/jetpack_b"]
var jpart_atk = "body/culete/rocket_fg/jetpack_atk"

var control_mode = CONTROL_TAP

var moving_left = false
var moving_right = false
var attack_begin = false

var airborne_time = 1000

var anim = ""
var attack_anim = ""
var fruit_count = 0
var big_coins = []

var prev_jpa_emitting = false

var walk_max_speed = 350
var walk_accel = 500
var walk_deaccel = 800
var dead = false

var jetpack_off_time = 1000

var extra_fly_anim_min_speed = 650
var side_fly_anim_min_speed = 100
var side_flip_anim_min_speed = 300
var extra_fall_anim_min_speed = 350

var siding_left = false

var jetpack_ignited = false
var jetpack_ignited_time = 0.0
var prev_jetpack_ignited = false

var jetpack_thrust = false
var jpvoice = null

var prev_jetpack_on_fire = false

var invincibility = 0
var hit_count = 0
var hit_frame = false
var energy = 2

var can_jetpack = true

var attack_time = 0
var attack_enemy = null

var prev_closest_enemy = false
var closest_enemy = null
var closest_enemy_pos = Vector2()

var slide_1 = Vector2()
var slide_1_time = 0.0

var slide_2 = Vector2()
var slide_2_time = 0.0

var touch_left = -1
var touch_right = -1

var camera_h_ofs = 0
var camera_v_ofs = 0

var attack_vector = Vector2()

var prev_floor_speed = Vector2()
var prev_floor = false

var crosshair = null

var enemies_to_attack = []

var flipping = false
var do_change_flipping = false

func _attack_area_enter(body):
	print("ENTER BODY?")
	if body extends enemy_class:
		enemies_to_attack.push_back(body)
		print("ENTER BODY!")
	else:
		print("NO!: ", body.get_type(), " - ", body.get_path())

func _attack_area_exit(body):
	print("EXIT BODY?")
	if body extends enemy_class:
		enemies_to_attack.erase(body)
		print("EXIT BODY!")

func _do_flip():
	do_change_flipping = true

func is_jetpack_on():
	return jetpack_ignited

func _update_siding():
	var scale = Vector2(1, 1)
	if siding_left:
		scale.x = -scale.x

	get_node("body").set_scale( scale )

func _integrate_forces(state):
	if dead:
		return
	var new_anim = ""

	var found_floor=false
	var floor_index=0

	slide_1_time += state.get_step()
	slide_2_time += state.get_step()

	var floor_normal = Vector2()
	var attacked_target = null
	for i in range(state.get_contact_count()):
		var co = state.get_contact_collider_object(i)
		if co and co extends enemy_class and co.inflicts_damage():
			hit_frame = true

		var n = state.get_contact_local_normal(i)

		if attack_time > 0 and co and co extends RigidBody2D and attack_vector.dot(n) < -0.707:
			attacked_target = co

		if n.y < -0.707:
			found_floor = true
			floor_index = i
			floor_normal = n
			break

	# Closest Enemy (for aiming)
	closest_enemy = null
	var closest_enemy_dist = 0
	var pos = state.get_transform().get_origin()

	for e in enemies_to_attack:
		if not e.takes_damage():
			continue
		var epos = e.get_global_pos()
		var d = epos.distance_to(pos)
		if not closest_enemy or d < closest_enemy_dist:
			closest_enemy = e
			closest_enemy_dist = d
			closest_enemy_pos = epos

	if closest_enemy:
		crosshair.lock(closest_enemy_pos)
	else:
		crosshair.unlock()

	if found_floor:
		airborne_time = 0

	var on_floor = airborne_time < 0.30
	airborne_time += state.get_step()

	var lv = state.get_linear_velocity()

	if prev_floor:
		lv -= prev_floor_speed
		prev_floor = false

	var step = state.get_step()

	if attack_begin:
		attack_enemy = null
		if attack_time == 0:
			attack_time = ATTACK_DURATION
			jetpack_ignited = true
			if closest_enemy:
				attack_vector = (closest_enemy.get_global_transform().get_origin() - state.get_transform().get_origin()).normalized()
				print("AVECTOR: ", attack_vector)
				attack_enemy = weakref(closest_enemy) # saved for later retarget
			else:
				attack_enemy = null
				attack_vector = Vector2(0, 1)
			if attack_vector.dot(Vector2(0, 1)) > PI/4.0: # Down
				get_node("animation").play("attack_down_1start")
				anim = "attack_down_2loop"
			elif attack_vector.dot(Vector2(0, -1)) > PI/4.0: # Up
				get_node("animation").play("attack_up_1start")
				anim = "attack_up_2loop"
			else:
				var frontvec
				if siding_left:
					frontvec = Vector2(-1, 0)
				else:
					frontvec = Vector2(1, 0)

				if attack_vector.dot(frontvec) > PI/4.0: # Front
					get_node("animation").play("attack_front_1start")
					anim = "attack_front_2loop"
				else: # Back
					if not flipping:
						get_node("animation").play("flip_attack")
						anim = "attack_front_2loop"
						flipping = true

			get_node("animation").queue(anim)
			attack_anim = anim

		attack_begin = false

	var jetpack_on_fire = false

	if attack_time > 0:
		if attacked_target:
			attack_time=0
			if attacked_target extends enemy_class and attacked_target.takes_damage():
				hit_frame = false
				lv = attack_vector*(-50)
				var enmvec = (attacked_target.get_global_transform().get_origin() - state.get_transform().get_origin()).normalized()*40.0

				attacked_target.call("attacked", self)
				get_node("starhit").set_pos(enmvec)
				get_node("starhit").set_emitting(true)
				get_node("event_sounds").play("attack")
				get_node("camera_animation").play("shake")

				new_anim = "hover"

		elif false and on_floor:
			attack_time = 0
			pass # not?
		else:
			jetpack_on_fire = true
			var td = ATTACK_DURATION - ATTACK_PREPARE_DURATION
			var can_begin = attack_time > td
			attack_time -= step
			if attack_time <= td:
				if attack_enemy:
					if attack_enemy:
						var ae = attack_enemy.get_ref()
						if ae:
							attack_vector = (ae.get_global_transform().get_origin() - state.get_transform().get_origin()).normalized()
						attack_enemy = null

				var attack_dir = attack_vector # (ae.get_global_pos() - pos).normalized()
				print(attack_dir)
				lv = attack_dir * ATTACK_SPEED

			if attack_time < 0:
				attack_time = 0
			anim = attack_anim
	else:
		attack_enemy = null

	var jetpack_thrust = false

	var accel_x = 0.0
	var ac = Input.get_accelerometer()
	if false and ac!=Vector3():
		ac = ac.normalized()
		var av = ac.y
		var sgn = sign(av)
		var v = abs(av)
		if v < 0.10:
			v = 0.0
		else:
			v = 1.0
		accel_x = v*sgn
		print(accel_x)

	if not jetpack_ignited and moving_left and moving_right:
		if can_jetpack:
			jetpack_ignited = true
		if on_floor:
			if can_jetpack:
				lv.y = -100
			else:
				lv.y = -250

	if not jetpack_ignited:
		if can_jetpack:
			lv.y += 300.0*state.get_step()
		else:
			lv.y += 600.0*state.get_step()

	var can_thrust = jetpack_ignited and (moving_left or moving_right)

	if attack_time == 0 and can_thrust:
		jetpack_on_fire = true

		var force = Vector2()

		if moving_left and moving_right:
			force = Vector2(0, -1)
			if lv.y > 0:
				force *= 2.0
		elif moving_left:
			force = Vector2(-1, 0).normalized()
			if lv.x > 0:
				force *= 2.0
		elif moving_right:
			force = Vector2(1, 0).normalized()
			if lv.x < 0:
				force *= 2.0

		lv += force*step*FLY_FORCE

		if lv.normalized().y < -0.707 and lv.y < -extra_fly_anim_min_speed:
			new_anim = "fly_up"
		else:
			if not flipping:
				var v = lv.x
				if siding_left:
					v = -v

				if v > extra_fly_anim_min_speed:
					new_anim = "fly_front_2"
				elif v > side_fly_anim_min_speed:
					new_anim = "fly_front"
				elif v > -side_fly_anim_min_speed:
					new_anim = "hover"
				elif v > -side_flip_anim_min_speed:
					new_anim = "fly_back"
				else:
					print("GO FLIP!!!")
					get_node("animation").play("flip_air")
					get_node("animation").queue("fly_front")
					anim = "fly_front"
					new_anim = "fly_front"
					flipping = true
			else:
				new_anim = "fly_front"

	elif on_floor:
		jetpack_off_time = 0
		jetpack_ignited = false

		if moving_left and !moving_right:
			if lv.x > -walk_max_speed:
				lv.x += -walk_accel*step
			else:
				lv.x += walk_accel*step

		elif moving_right and !moving_left:
			if lv.x < walk_max_speed:
				lv.x += walk_accel*step
			else:
				lv.x += -walk_accel*step

		else: # go towards 0
			var sg = 0
			if lv.x < 0:
				sg = -1
			elif lv.x > 0:
				sg = 1
			var speed = abs(lv.x)

			speed -= walk_deaccel*step
			if speed < 0:
				speed = 0
			lv.x = speed*sg

		if abs(lv.x) > 0.1:
			new_anim = "walk"

			if not flipping:
				if (moving_right and lv.x > 0 and siding_left) or (moving_left and lv.x < 0 and not siding_left):
					get_node("animation").play("flip")
					get_node("animation").queue("walk")
					anim = "walk"
					flipping = true

		else:
			if not flipping:
				new_anim = "idle"
			else:
				new_anim = "walk"

	elif attack_time > 0:
		new_anim = attack_anim
	else:
		if not jetpack_ignited:
			if moving_left and !moving_right:
				if lv.x > -walk_max_speed:
					lv.x += -walk_accel*step
				else:
					lv.x += walk_accel*step

			elif moving_right and !moving_left:
				if lv.x < walk_max_speed:
					lv.x += walk_accel*step
				else:
					lv.x += -walk_accel*step

		jetpack_off_time += step
		if jetpack_off_time > 1.5 and lv.y > extra_fall_anim_min_speed:
			new_anim = "fall"

	for i in range(2):
		var p = get_node(jpart_names[i])
		p.set_emitting(jetpack_ignited)
		if can_thrust:
			p.set_param(Particles2D.PARAM_SPREAD, 10)
			p.set_param(Particles2D.PARAM_LINEAR_VELOCITY, 130)
			p.set_self_opacity(1.0)
		else:
			p.set_param(Particles2D.PARAM_SPREAD, 80)
			p.set_param(Particles2D.PARAM_LINEAR_VELOCITY, 50)
			p.set_self_opacity(0.35)

		p.set_initial_velocity(lv)
		var p2 = get_node(jpart_names[i] + "f")
		p2.set_emitting(can_thrust and jetpack_ignited)

	if new_anim!=anim:
		anim = new_anim
		get_node("animation").play(anim)

	if do_change_flipping:
		siding_left = not siding_left
		do_change_flipping = false
		flipping = false
		_update_siding()

	if flipping:
		var an = get_node("animation").get_current_animation()
		if an != "flip" and an != "flip_air" and an != "flip_attack":
			siding_left = not siding_left
			_update_siding()
			flipping = false
			do_change_flipping = false

	if found_floor:
		prev_floor = true
		prev_floor_speed = state.get_contact_collider_velocity_at_pos(floor_index)
		prev_floor_speed.y = 0
		lv += prev_floor_speed

	state.set_linear_velocity(lv)

	if prev_jetpack_ignited != jetpack_ignited:
		if jetpack_ignited:
			jpvoice = get_node("jetpack_sound").play("jetpack")
			get_node("jetpack_sound").set_pitch_scale(jpvoice, 1.0 + lv.length()/800.0)
			get_node("jetpack_sound").set_volume(jpvoice, 0.3)
		else:
			get_node("jetpack_sound").stop_all()
			jpvoice = null
	else:
		if jetpack_ignited:
			if jetpack_on_fire:
				if not prev_jetpack_on_fire:
					get_node("jetpack_sound").stop_all()
					jpvoice = get_node("jetpack_sound").play("jetpack")
					get_node("jetpack_sound").set_volume(jpvoice, 0.3)
			else:
				get_node("jetpack_sound").set_volume(jpvoice, 0.1)

			get_node("jetpack_sound").set_pitch_scale(jpvoice, 1.0 + lv.length()/800.0)

	if jetpack_ignited:
		jetpack_ignited_time += state.get_step()
	else:
		jetpack_ignited_time = 0.0

	if prev_jpa_emitting != attack_time > 0:
		prev_jpa_emitting = attack_time > 0
		get_node(jpart_atk).set_emitting(prev_jpa_emitting)

	prev_jetpack_ignited = jetpack_ignited
	prev_jetpack_on_fire = jetpack_on_fire


func _unhandled_input(event):

	if event.is_echo():
		return
	if event.is_action("quit") and event.is_pressed():
		main.goto_scene("res://menu/stage_select.tscn")

	if event.is_action("jetpack_right"):
		moving_right = event.is_pressed()
	elif event.is_action("jetpack_left"):
		moving_left = event.is_pressed()

	if event.is_action("attack") and !attack_begin and event.is_pressed() and closest_enemy:
		attack_begin = true

	if event.type == InputEvent.SCREEN_TOUCH:

		if control_mode == CONTROL_TAP:
			var mp = get_tree().get_root().get_final_transform().affine_inverse().xform(event.pos)

			if event.pressed:
				if closest_enemy and !attack_begin:
					var aleft = get_node("hud/base/jp_left/attack")
					var aright = get_node("hud/base/jp_right/attack")
					var r = aleft.get_texture().get_size().height*0.9
					#print("R: ", r)
					#print("EP: ", event.pos)
					#print("ARD: ", mp.distance_to(aleft.get_global_pos()), " gp ", aleft.get_global_pos())
					#print("ARD: ", mp.distance_to(aright.get_global_pos()), " gp ", aright.get_global_pos())
					if mp.distance_to(aleft.get_global_pos()) < r or mp.distance_to(aright.get_global_pos()) < r:
						attack_begin = true

				if event.device != 0:
					return

				var left = mp.x < get_viewport_rect().size.x*0.5

				if left and touch_left == -1:
					touch_left = event.index
					moving_left = true

				if !left and touch_right==-1:
					touch_right = event.index
					moving_right = true

				if event.index == 0:
					slide_1 = Vector2()
					slide_1_time = 0.0

				if event.index == 1:
					slide_2 = Vector2()
					slide_2_time = 0.0

			else:
				if touch_left != -1 and touch_left == event.index:
					touch_left = -1
					moving_left = false

				if touch_right != -1 and touch_right == event.index:
					touch_right = -1
					moving_right = false

				if event.index == 0:
					slide_1 = Vector2()
					slide_1_time = 0.0

				if event.index == 1:
					slide_2 = Vector2()
					slide_2_time = 0.0

	if (event.type==InputEvent.SCREEN_DRAG):

		if event.index == 0:
			slide_1 += event.relative_pos

		if event.index == 1:
			slide_2 += event.relative_pos

		if ((slide_1_time <  ATTACK_TIME_TRESHOLD and slide_1.length() > ATTACK_SLIDE_TRESHOLD)
				or (slide_2_time <  ATTACK_TIME_TRESHOLD and slide_2.length() > ATTACK_SLIDE_TRESHOLD)):

			slide_1=Vector2()
			slide_1_time=1
			slide_2=Vector2()
			slide_2_time=1


func _restart():
	get_node("../..").restart()

func _process(delta):
	if (hit_frame or hit_count > 0) and invincibility == 0 and energy > 0:
		# character was hit!
		energy -= 1
		get_node("hud/base").set_energy(energy)
		if energy == 0: # you lose, player
			dead = true
			game_data.life_count -= 1
			set_mode(MODE_STATIC)
			get_node("restart_wait").start()
			get_node("animation").play("death")
		else:
			invincibility = HIT_INVINCIBILITY_TIME

	if invincibility > 0:
		invincibility -= delta
		if invincibility <= 0:
			invincibility = 0
			get_node("body").show()
		else:
			if fmod(invincibility, 0.05) < 0.025:
				get_node("body").show()
			else:
				get_node("body").hide()

	hit_frame = false

	# Compensate attack shape transform
	var attack_area_offset = get_global_pos() - get_node("camera").get_camera_screen_center()

	# Adjust camera
	var lv = get_linear_velocity()

	var camera_adj_speed = 0.7
	if abs(lv.x) > 300:
		camera_adj_speed = 1.2

	if siding_left:
		if camera_h_ofs > -1:
			var rem = camera_h_ofs*0.5 + 0.5
			camera_h_ofs -= delta*camera_adj_speed*rem
	else:
		if camera_h_ofs < 1:
			var rem = -camera_h_ofs*0.5 + 0.5
			camera_h_ofs += delta*camera_adj_speed*rem

	get_node("camera").set_h_offset(camera_h_ofs)

	# Vertical camera adjust code
	var camera_adj_vspeed = 1.2
	var camera_vtarget = 0.0
	if lv.y > 400:
		camera_vtarget = 1
	elif lv.y < -400:
		camera_vtarget = -1
	else:
		camera_vtarget = 0.0

	if camera_v_ofs < camera_vtarget:
		camera_v_ofs = min(camera_v_ofs + camera_adj_vspeed*delta, camera_vtarget)
	elif camera_v_ofs > camera_vtarget:
		camera_v_ofs = max(camera_v_ofs - camera_adj_vspeed*delta, camera_vtarget)

	get_node("camera").set_v_offset(camera_v_ofs)

	var cenemy = closest_enemy != null
	if cenemy != prev_closest_enemy:
		if cenemy:
			get_node("hud/base/attack_glow").play("glow")
		else:
			get_node("hud/base/attack_glow").play("noglow")
	prev_closest_enemy = cenemy

func _level_end():
	get_node("../..").level_end()

func end_level(next):
	game_data.get_level(next).enabled = true
	set_mode(MODE_STATIC)
	get_node("level_end_wait").start()

func hit_begin():
	hit_count += 1
	hit_frame = true

func hit_end():
	hit_count -= 1

func add_fruit():
	fruit_count += 1
	get_node("hud/base").set_fruit_count(fruit_count)

func add_key(idx):
	game_data.current_keys[idx] = true
	get_node("hud/base").update_keys()

func add_big_coin(idx):
	big_coins.push_back(idx)
	get_node("hud/base").set_big_coin_on(idx)

func restore_life(amount):
	energy += amount
	if energy > MAX_ENERGY:
		energy = MAX_ENERGY

	get_node("hud/base").set_energy(energy)

func _ready():
	var cp = game_data.current_checkpoint
	if cp:
		print(cp)
		cp = get_node(cp)
		print(cp)
		if cp:
			set_global_transform(cp.get_global_transform())

	crosshair = ResourceLoader.load("res://hud/crosshair.tscn").instance()
	get_node("../..").call_deferred("add_child", crosshair)
	get_node("attack_area").get_shape(0).set_extents(OS.get_video_mode_size() / 2)

func show_hint(hint):
	get_node("hud/base").hint_show(hint)

func hide_hint():
	get_node("hud/base").hint_hide()

func is_attacking():
	return attack_time > 0

func cancel_attack():
	attack_time = 0

func _init():
	set_process(true)
	set_process_unhandled_input(true)
