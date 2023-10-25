class_name State
extends Node

# barebones base state; inherit for other player states

@export var id := ""
var host

func _ready():
	id = name.to_lower()

func set_host(host_to_set):
	host = host_to_set

func _enter_state(body, state_machine):
	pass
	
func _tick_state(body, state_machine, delta):
	
	pass

func _exit_state(body, state_machine):
	pass
