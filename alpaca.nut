
class Alpaca extends RigidBody2D {

	// member variables here, example:
	// a=2
	// b="textvar"

	jpart_names=["body/culete/over/rocket_fg/jetpack_a","body/culete/rocket_bg/jetpack_b"]
	colors_full=[Color(1,1,0.34,1),Color(0.96,0.28,0,1),Color(0.39,0.39,0.39),Color(0,0,0,0)]
	colors_empty=[Color(0.2,0.2,0.2,1),Color(0.1,0.1,0.1,0),Color(0,0,0,0),Color(0,0,0,0)]


	fruit_count=0
	large_fruit_count=0

	/////////////////////////

	prev_jetpack_on=false
	
	sliding_left=0
	sliding_right=0
	sliding_from_left=0
	sliding_from_right=0

	moving_left=false;
	moving_right=false;
	attack_begin=false
	touch_left=-1
	touch_right=-1
	FLY_UP_TRESHOLD=10
	walk_max_speed=200
	walk_accel=300
	walk_deaccel=600	
	jpvoice=null
	
	airborne_time=1000
	jetpack_max_fuel=10.0
	jetpack_fuel=5.0
	jetpack_refuel_speed=0.5
	jetpack_floor_refuel_speed=15.0
	jetpack_off_time=1000
	anim=""
	
	extra_fly_anim_min_speed=650
	extra_fall_anim_min_speed=350
	
	siding_left=false
	
	FLY_FORCE=400
	ATTACK_SPEED=650
	ATTACK_DURATION=2
	ATTACK_PREPARE_DURATION=0.3
	attack_time=0
	ATTACK_SLIDE_TRESHOLD=50
	
	function _integrate_forces(state) {


		{
			local interp_coef=4*state.get_step()
			sliding_from_left=Math.lerp(sliding_from_left,sliding_left,interp_coef)
			sliding_from_right=Math.lerp(sliding_from_right,sliding_right,interp_coef)
		}

		local new_anim=""
		local new_siding_left=siding_left

		
		local found_floor=false
		local floor_index=0
		for(local i=0;i<state.get_contact_count();i++) {
			local n = state.get_contact_local_normal(i)
			if (n.y< -0.707) {
				found_floor=true
				floor_index=i
				break
			}
		}
		
		if (found_floor)
			airborne_time=0

		
		local on_floor = airborne_time < 0.30
		airborne_time+=state.get_step();

//		print(on_floor)		

		

		
		local lv = state.get_linear_velocity()
		
		if (on_floor || (!moving_left && !moving_right)) {	

			local refuel_speed=on_floor ? jetpack_floor_refuel_speed : jetpack_refuel_speed
			jetpack_fuel+=state.get_step()*refuel_speed
			if (jetpack_fuel>=jetpack_max_fuel) {
				jetpack_fuel=jetpack_max_fuel
			}
					
		}
		

		if (attack_begin) {

			if (!on_floor && attack_time==0) {

				get_node("animation").play("attack1_start")
				get_node("animation").queue("attack2_dive_loop")
				anim="attack2_dive_loop"
				attack_time=ATTACK_DURATION
				//lv.y=ATTACK_SPEED
			}

			attack_begin=false
		}

		if (attack_time>0) {

			if (on_floor) {				
	 			attack_time=0
				local collider = state.get_contact_collider_object(floor_index)
				print("Attacked stuff!",collider)
				if (collider)
					collider.call("attacked",this)
			} else {
				local td = ATTACK_DURATION - ATTACK_PREPARE_DURATION
				local can_begin = attack_time > td
				attack_time-=state.get_step()
				if (attack_time <=td) {
					lv.y=ATTACK_SPEED	
				}
				if (attack_time<0) {
					attack_time=0
				}
			}
		}

		

		
	
		local jetpack_on = false

		if (attack_time==0 && (!on_floor && (moving_left || moving_right)) || (moving_left && moving_right) ) {
			
			local force = Vector2()
			if (moving_left && moving_right)
				force=Vector2(0,-1)
			else if (moving_left)
				force=Vector2(-1,0).normalized()
			else if (moving_right)
				force=Vector2(1,0).normalized()
				
				      
			local desired_fuel=state.get_step()
			if (jetpack_fuel < desired_fuel)
				desired_fuel=jetpack_fuel
	
			lv+=force*desired_fuel*FLY_FORCE
			jetpack_fuel-=desired_fuel		
			jetpack_on=true
			jetpack_off_time=0
			
			local sanim=0
								
			if (lv.normalized().y< -0.707 && lv.y < -extra_fly_anim_min_speed) {
				
				new_anim="fly_up"
			} else {
				if (lv.x > extra_fly_anim_min_speed)
					sanim=1
				else if (lv.x < -extra_fly_anim_min_speed)
					sanim=-1
				
				if (siding_left)
					sanim=-sanim
					
				if (sanim==-1)
					new_anim="fly_back"
				else if (sanim==1)
					new_anim="fly_front"
				else
					new_anim="hover"
			}
			
		} else if (on_floor) {
			
			jetpack_off_time=0
			if (moving_left && !moving_right) {
			
				if (lv.x > -walk_max_speed) 						
					lv.x+=-walk_accel*state.get_step()
				else
					lv.x+=walk_accel*state.get_step()							
				
			} else	if (moving_right && !moving_left) {				
			
				if (lv.x < walk_max_speed) 						
					lv.x+=walk_accel*state.get_step()
				else
					lv.x+=-walk_accel*state.get_step()							
				
			} else {
				//go towards 0
				local sg=0
				if (lv.x<0)
					sg=-1
				else if (lv.x>0)
					sg=1
				local speed = Math.abs(lv.x)
				
				speed-=walk_deaccel*state.get_step()
				if (speed<0)
					speed=0
				lv.x=speed*sg
				
			}
			
			if (Math.abs(lv.x)>0.1) {
			
				new_anim="walk"
				if (lv.x>0)
					new_siding_left=false
				else
					new_siding_left=true
			} else {
				new_anim="idle"
			}
			
			

		} else if (attack_time>0) {

			new_anim="attack2_dive_loop"
			jetpack_on=true
		} else {
			
			jetpack_off_time+=state.get_step()
			if (jetpack_off_time>1.5 && lv.y > extra_fall_anim_min_speed)
				new_anim="fall"
		}


		local jf = jetpack_fuel / jetpack_max_fuel

		for(local i=0;i<2;i++) {		

			local p = get_node(jpart_names[i])		
			local v = Math.pow(jf,0.3)
			p.set_emitting(jetpack_on)
			p.set_initial_velocity(lv*0.3)
			for(local j=0;j<4;j++) {
				local c = colors_empty[j].linear_interpolate(colors_full[j],v)
				p.set_color_phase_color(j,c)
			}
			
		}

		get_node("hud/base/fuel/amount").set_value(jf)

		if (jetpack_on && jpvoice!=null) {

			local ps = jf * 0.1
			local v = Math.pow(jf,0.3)
			local lp = Math.lerp(1000.0,18000.0,v)
			get_node("jetpack_sound").set_pitch_scale(jpvoice,0.9+ps);
//			print("LPF: ",lp)
//			get_node("jetpack_sound").set_filter(jpvoice,SamplePlayer.FILTER_LOWPASS,lp,0.5,1);
		}
		
		if (new_anim!=anim) {
		
			anim=new_anim
			get_node("animation").play(anim)
		}
		
		if (new_siding_left!=siding_left) {
			
			siding_left=new_siding_left;
			get_node("body").set_scale( Vector2( siding_left?-1:1,1) )
		}
		
		state.set_linear_velocity(lv)

		if (prev_jetpack_on!=jetpack_on) {

			if (jetpack_on) {
			
				if (on_floor) {

					jpvoice=get_node("jetpack_sound").play("jetpack_intro")
				} else {

					jpvoice=get_node("jetpack_sound").play("jetpack")
				}

			} else {

				get_node("jetpack_sound").stop_all()
				jpvoice=null
			}
		}

		prev_jetpack_on=jetpack_on
		
	
	}
	
	function _unhandled_input(event) {

		if (event.is_echo())
			return
		/*if (event.is_action("walk_left"))
			walking_left=event.is_pressed()
		if (event.is_action("walk_right"))
			walking_right=event.is_pressed()*/
		if (event.is_action("jetpack_left")) {
			print("JP LEFT")
			moving_left=event.is_pressed()
		}
		if (event.is_action("jetpack_right")) {
			moving_right=event.is_pressed()
			print("JP RIGHT")
		}

		if (event.is_action("attack") && !attack_begin && event.is_pressed()) {
			attack_begin=true
			//print("ATTACK!")
		}

		if (event.type==InputEvent.SCREEN_TOUCH) {

			local left = event.screen_x < OS.get_video_mode_size().x*0.5

			if (event.screen_pressed) {


				if (left && touch_left==-1) {

					touch_left=event.screen_index
					moving_left=true
					sliding_from_left=event.screen_y*1.0
					sliding_left=sliding_from_left
				}
				if (!left && touch_right==-1) {

					touch_right=event.screen_index
					moving_right=true
					sliding_from_right=event.screen_y*1.0
					sliding_right=sliding_from_right
				}
			} else {


				if (left && touch_left==event.screen_index) {

					touch_left=-1
					moving_left=false
					sliding_left=0
					sliding_from_left=0
				}
				if (!left && touch_right==event.screen_index) {

					touch_right=-1
					moving_right=false
					sliding_right=0
					sliding_from_right=0
				}
			}

		}
		if (event.type==InputEvent.SCREEN_DRAG) {


			if (touch_left!=-1 && event.screen_index==touch_left) {

				sliding_left=event.screen_y
			}

			if (touch_right!=-1 && event.screen_index==touch_right) {

				sliding_right=event.screen_y
			}

			if (touch_left!=-1 && touch_right!=-1) {

				if (sliding_left-sliding_from_left > ATTACK_SLIDE_TRESHOLD && sliding_right-sliding_from_right > ATTACK_SLIDE_TRESHOLD) {

					attack_begin=true
					sliding_from_left=sliding_left
					sliding_from_right=sliding_right
				}
					
				//print("delta left: ",sliding_from_left-sliding_left)
				//print("delta right: ",sliding_from_right-sliding_right)
			}

		}
	}

	function show_hint(text) {
		get_node("hud/base").hint_show(text)
	}
	function hide_hint() {
		get_node("hud/base").hint_hide()
	}

	/////////// API ////////////
	
	
	function clear_status() {
	
		fruit_count=0
		large_fruit_count=0
		
		
	}

	function add_fruit() {
		
		fruit_count++
		get_node("event_sounds").play("fruit")
		get_node("hud/base/fruit_count/amount").set_text(""+fruit_count)
	}
	
	function add_large_fruit() {
	
		large_fruit_count++
	}


	function attempt_damage() {

	}

	constructor() {

		RigidBody2D.constructor() //always call parent constructor first
		//initialization here
	}
}


return Alpaca // main class must be returned
