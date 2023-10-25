extends "res://scenes/player/player_base_state.gd"

func _enter_state(host, state_machine):
	host.animation_player.play("jump")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _tick_state(host, state_machine, delta):
	if host.is_on_floor():
		host.state_machine.set_state(host, "idle")
	tick_movement(delta)

func walk(delta):
	pass
func crouch(delta):
	pass
func jump(delta):
	pass
