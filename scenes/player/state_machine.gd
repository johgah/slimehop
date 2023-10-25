class_name StateMachine
extends Node

var states = {}

var current_state : State
var host

# Called when the node enters the scene tree for the first time.
func _ready():
	host = get_parent()
	populate_states()
	#print(states)

func tick_states(host, delta):
	# runs every tick, ensures that only the script from the current state runs
	if current_state: # ensure that there is a state set
		current_state._tick_state(host, self, delta)

func set_state(host, next_state_id:String):
	if current_state != null:
		current_state._exit_state(host, self)
	if not states.has(next_state_id):
		printerr("State '%s' does not exist" % next_state_id)
	current_state = states.get(next_state_id)
#	print(current_state)
	current_state.set_host(host)
	current_state._enter_state(host, self)

func populate_states():
	# fill the state array with the children (state) nodes of the state machine
	for state in get_children():
		if state.get_children().size() != 0:
			for child in state.get_children():
				states[child.id] = child
		if "id" in state:
			states[state.id] = state
