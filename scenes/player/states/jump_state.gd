extends "res://scenes/player/player_base_state.gd"

# JUMP STATE

var initial_velocity = 0.0

func _enter_state(host, state_machine):
	initial_velocity = host.velocity.x
	horizontal_flip = false
	host.animation_player.play("jump")

func _tick_state(host, state_machine, delta):
	if host.is_on_floor():
		host.state_machine.set_state(host, "idle")
	
	if Input.is_action_just_released("player_jump"):
		if host.velocity.y < host.MIN_JUMP_POWER:
			host.velocity.y = host.MIN_JUMP_POWER
	tick_movement(delta)

func get_friction():
	if host.velocity.y > -host.APEX_RANGE and host.velocity.y < 0:
		return host.SPEED
	else:
		return host.AIR_SPEED

func get_gravity():
	if host.velocity.y > -host.APEX_RANGE and host.velocity.y < 0 and Input.is_action_pressed("player_jump"):
		return host.GRAVITY * 0.65
	else:
		return host.GRAVITY
