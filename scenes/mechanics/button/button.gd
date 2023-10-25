class_name LevelButton

extends StaticBody2D

# Vars
@export var id : int # id exported for easy adjustment
@onready var area = $Area2D # area for button activation detection
@onready var animation = $AnimationPlayer # for animation playing

# manage colors
@export var blue = true
@onready var BLUE = preload("res://assets/images/mechanics/BlueButton.png")
@onready var RED = preload("res://assets/images/mechanics/RedButton.png")

func _ready():
	# manage colors
	if blue:
		$Sprite2D.set_deferred("texture", BLUE)
	else:
		$Sprite2D.set_deferred("texture", RED)
	
	# Connect signals
	SignalBus.clone_deleted.connect(_on_clone_deleted)

# Turn on when something's on the button
func _on_area_2d_body_entered(body):
	on(body)

# Turn off on body exited
func _on_area_2d_body_exited(_body):
	var bodies = get_overlapping_bodies_clean() # get overlapping bodies array
	off(bodies) # call off

# Turn on if new overlapping body isn't self
func on(body):
	if body != self:
		SignalBus.button_on.emit(id)
		animation.play("on")
		print("button \"", name, "\" id:", id, " on")
		print("\tactivated by ", body.name, " ", body)

# Turn off if no overlapping bodies
func off(bodies):
	if len(bodies) == 0:
		SignalBus.button_off.emit(id)
		animation.play("off")
		print("button \"", name, "\" id:", id, " off")
	else:
		print(bodies)

# Get an array of every body overlapping with area, except self
func get_overlapping_bodies_clean():
	# get overlapping bodies array
	var bodies = area.get_overlapping_bodies()
	bodies.erase(self) # remove self from bodies
	return bodies # return

# On clone deleted, turn off, ignoring that deleted body
func _on_clone_deleted(body):
	# get extra clean bodies array
	var bodies = get_overlapping_bodies_clean()
	bodies.erase(body) # make sure to remove deleted clone
	off(bodies) # call off

func _init(args := {}):
	if !args.is_empty():
		if args.has("blue"):
			blue = args.blue
		if args.has("id"):
			id = args.id
