extends "res://scenes/player/player_base_state.gd"


func _enter_state(host, state_machine):
	host.velocity = Vector2.ZERO
	host.is_dead = true
	if host.is_current:
		# death animation?
		SignalBus.player_died.emit()
		host.animation_player.play("death")
	else:
		host.animation_player.play("death_clone")

# disable all forms of movement
func walk(delta):
	pass

func jump(delta):
	pass

func crouch(delta):
	pass

func clone(delta):
	pass

func apply_gravity(delta):
	pass

