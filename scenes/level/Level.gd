extends Node2D

@onready var player_scene = preload("res://scenes/player/player.tscn")

@onready var objects = {
	"blue_switch": {
		"scene": preload("res://scenes/mechanics/button/button.tscn"),
		"args": {"blue": true, "id": 0, "offset_y": 16}
		},
	"blue_block": {
		"scene": preload("res://scenes/mechanics/door/door.tscn"), 
		"args": {"blue": true, "id": 0}
		},
	"red_switch": {
		"scene": preload("res://scenes/mechanics/button/button.tscn"), 
		"args": {"blue": false, "offset_y": 16, "id": 1}
		},
	"red_block": {
		"scene": preload("res://scenes/mechanics/door/door.tscn"), 
		"args": {"blue": false, "id": 1}
		},
}

@onready var players_array = $Players
@onready var tilemap = $TileMap
var current_player = null
var clone_player = null
var clone_cooldown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	current_player = $Players/Player
	SignalBus.player_clone.connect(_on_player_cloned)
	SignalBus.player_swap.connect(_on_player_changed)
	SignalBus.player_delete.connect(_on_player_delete)
	SignalBus.player_died.connect(_on_player_died)
	initialize_tiles()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	# 	TEST FOR DEATH BEHAVIOR, REMOVE LATER!!
#	if Input.is_action_just_pressed("player_down") and Input.is_action_pressed("restart"):
#		current_player.state_machine.set_state(current_player, "death")
#	elif Input.is_action_just_pressed("player_up") and Input.is_action_pressed("restart") and clone_player != null:
#		clone_player.state_machine.set_state(clone_player, "death")

	if Input.is_action_just_pressed("restart"):
		current_player.state_machine.set_state(current_player, "death")
		
	if current_player != null:
		$CanvasLayer/Label.set_text("current: %s (%s)\nclone: %s (%s)" % [current_player, current_player.is_current, clone_player, (clone_player.is_current if clone_player != null else "n/a")])
	pass

func _on_player_cloned():
	if !current_player.raycast.is_colliding():
		var new_player = player_scene.instantiate()
		new_player.is_current = false
		players_array.add_child(new_player)
		new_player.position.y = current_player.position.y - (current_player.TILE_SIZE)
		new_player.position.x = current_player.position.x
		new_player.state_machine.set_state(new_player, "dummy")
		if !Input.is_action_pressed("player_up"):
			print(current_player.dir)
			new_player.velocity.x = (current_player.TILE_SIZE * 4) * current_player.dir
			new_player.velocity.y = current_player.MIN_JUMP_POWER
		else:
			new_player.velocity.y = current_player.MAX_JUMP_POWER
		clone_player = new_player
		
		clone_player.sprite.modulate.a = 0.45
		pass

func _on_player_changed(player : Player):
	if player == current_player and !clone_player.is_dead: # check if the primary player node sent the signal
		var save_player = current_player
		current_player = clone_player
		clone_player = save_player
		
		# DOING IT THIS WAY IS VERY IMPORTANT APPARENTLY
		current_player.set_deferred("is_current", true)
		current_player.sprite.modulate.a = 1.0
		current_player.camera.enabled = true
			
		clone_player.set_deferred("is_current", false)
		clone_player.sprite.modulate.a = 0.45
		clone_player.camera.enabled = false

func _on_player_delete():
	if clone_player != null:
		clone_player.queue_free()
		SignalBus.clone_deleted.emit(clone_player)
		clone_player = null

func _on_player_died():
	if clone_player != null:
		clone_player.state_machine.set_state(clone_player, "death")

func initialize_tiles():
	# layer 1 = objects
	var tiles = {
		"blue_switch": Vector2(0,0),
		"blue_block": Vector2(2,0), 	# i have no clue why these have to be swapped
		"red_switch": Vector2(1,1),
		"red_block": Vector2(0,2)		# the other one that has to be swapped
	}
	var objs = tilemap.get_used_cells_by_id(1)
	for obj in objs:
		var tile : Vector2 = tilemap.get_cell_atlas_coords(1, obj)
		var corresponding_tile = tiles.find_key(tile)
#		print(tile)
#		print(tiles.find_key(tile))
		if(corresponding_tile):
			replace_tile_with_scene(1, obj, corresponding_tile)
	pass

func replace_tile_with_scene(layer : int, coords : Vector2, scene_name):
	var obj_entry = objects[scene_name]
	var new_obj = obj_entry.scene.instantiate()
	var args = false
	
	if obj_entry.has("args"):
		args = true
		if new_obj.has_method("_init"):
			new_obj._init(obj_entry.args)
	
	add_child(new_obj)
	new_obj.position = tilemap.map_to_local(coords)
	if args:
		if obj_entry.args.has("offset_y"):
			new_obj.position.y = new_obj.position.y + obj_entry.args.offset_y
	tilemap.set_cell(layer, coords, -1)
