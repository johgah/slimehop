extends "res://scenes/player/player_base_state.gd"

func _enter_state(host, state_machine):
	host.animation_player.play("idle")
	host.velocity = Vector2.ZERO
	pass

func _tick_state(host, state_machine, delta):
	if Input.is_action_just_released("player_clone"):
		SignalBus.player_clone.emit()
		host.state_machine.set_state(host, "idle")
		pass
	pass

func walk(delta):
	pass

func jump(delta):
	pass

func crouch(delta):
	pass

func clone(delta):
	pass
