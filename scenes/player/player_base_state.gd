extends State

### PLAYER BASE STATE ###
# We put code here that can be reused or overwritten across different states, reducing the amount of duplicate code.

@export var can_walk = true
@export var can_jump = true
@export var walk_anim = true
@export var horizontal_flip = true
@export var can_clone = true

func _enter_state(body, state_machine):
	pass

func _tick_state(body, state_machine, delta):
	tick_movement(delta)

func tick_movement(delta):
	# these functions can be overwritten in inherited states
	walk(delta)
	jump(delta)
	crouch(delta)
	clone(delta)
	apply_gravity(delta)

func walk(delta):
	var direction = Input.get_axis("player_left", "player_right")
	if direction != 0:
		host.dir = direction
	if direction and can_walk:
		host.velocity.x = direction * get_friction()
		if horizontal_flip:
			match int(direction):
				-1:
					host.sprite.flip_h = 1
				1:
					host.sprite.flip_h = 0
	else:
		host.velocity.x = move_toward(host.velocity.x, 0, get_friction()) * delta

func jump(delta):
	if Input.is_action_just_pressed("player_jump") and host.is_on_floor():
		host.velocity.y = host.MAX_JUMP_POWER
		host.state_machine.set_state(host, "jump")

func crouch(delta):
	if Input.is_action_just_pressed("player_down") and host.is_on_floor():
		host.state_machine.set_state(host, "crouch")

func clone(delta):
	# Clone
	if can_clone and host.is_current:
		if Input.is_action_just_pressed("player_clone") and host.is_on_floor():
			if get_tree().get_nodes_in_group("players").size() == 1:
				host.state_machine.set_state(host, "clone")
			else:
				SignalBus.player_swap.emit(host)
		# Kill
		if Input.is_action_just_pressed("player_delete") and host.is_current:
			SignalBus.player_delete.emit()

func get_gravity():
	return host.GRAVITY

func get_friction():
	return host.SPEED

func apply_gravity(delta):
	if not host.is_on_floor():
		host.velocity.y += get_gravity() * delta
