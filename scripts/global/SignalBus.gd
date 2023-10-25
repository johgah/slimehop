extends Node

# Signals for player
signal player_clone()
signal player_swap(player : Player)
signal player_delete()
signal player_died()
signal clone_deleted(player : Player)

# Signals for buttons
signal button_on(id : int)
signal button_off(id : int)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
