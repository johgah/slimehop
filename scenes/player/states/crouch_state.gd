extends "res://scenes/player/player_base_state.gd"

func _enter_state(host, state_machine):
	host.animation_player.play("crouch")

func _tick_state(host, state_machine, delta):
	if Input.is_action_just_released("player_down"):
		host.state_machine.set_state(host, "idle")
	tick_movement(delta)

func walk(delta):
	host.velocity.x = move_toward(host.velocity.x, 0, host.SPEED) * delta
