class_name Player

extends CharacterBody2D

# since we're uncertain about the size of graphics rn, i'm gonna base this off of Untitled Roguelike Platformer so that it's easier to adjust the values once we have it dialed in :P

const TILE_SIZE := 32
const SPEED = 5 * TILE_SIZE
const AIR_SPEED = 4 * TILE_SIZE

const JUMP_TIME := 0.35
const APEX_RANGE := 180
const MAX_JUMP_HEIGHT = 2 * TILE_SIZE
const MIN_JUMP_HEIGHT = 1 * TILE_SIZE

var GRAVITY := 0.0
var MAX_JUMP_POWER := 0.0
var MIN_JUMP_POWER := 0.0

var dir := 1
var is_current := true
var is_dead := false

@onready var state_machine = $StateMachine
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite
@onready var camera = $CameraFollower/Camera2D
@onready var players_array = get_parent() # players should ALWAYS be in "Players" node on the level scene!
@onready var raycast = $RayCast2D

func _ready():
	camera._set_limits()
	GRAVITY = 2 * MAX_JUMP_HEIGHT / pow(JUMP_TIME, 2)
	MAX_JUMP_POWER = -sqrt(2 * GRAVITY * MAX_JUMP_HEIGHT)
	MIN_JUMP_POWER = -sqrt(2 * GRAVITY * MIN_JUMP_HEIGHT)
	state_machine.set_state(self, "idle")

func _physics_process(delta):
	$CanvasLayer/Label.set_text("Velocity: %s\nState: %s\nGravity: %f\nFriction: %f" % [velocity, state_machine.current_state.id, state_machine.current_state.get_gravity(), state_machine.current_state.get_friction()])
	state_machine.tick_states(self, delta)
	move_and_slide()
	$RayCast2D/Label.set_text(str(raycast.is_colliding()))

func _on_main_death_finish():
	get_tree().reload_current_scene()

func _on_clone_death_finish():
	SignalBus.player_delete.emit()
