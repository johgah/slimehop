extends "res://scenes/player/player_base_state.gd"

func _enter_state(host, state_machine):
	host.animation_player.play("idle")
	pass

func _tick_state(host, state_machine, delta):
	if host.is_on_floor() and host.velocity.x != 0:
		host.state_machine.set_state(host, "walk")
	tick_movement(delta)
