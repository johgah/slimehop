extends "res://scenes/player/player_base_state.gd"

func _enter_state(host, state_machine):
	host.animation_player.play("walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _tick_state(host, state_machine, delta):
	if host.velocity.x == 0:
		host.state_machine.set_state(host, "idle")

	tick_movement(delta)
