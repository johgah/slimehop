class_name Door

extends StaticBody2D

# Vars
@export var id : int # id exported for easy adjustment
@onready var animation = $AnimationPlayer # for animation playing

# manage colors
@export var blue = true
@onready var BLUE = preload("res://assets/images/mechanics/BlueBlock.png")
@onready var RED = preload("res://assets/images/mechanics/RedBlock.png")

# Connect button signals to respective methods
func _ready():
	# manage colors
	if blue:
		$Sprite2D.set_deferred("texture", BLUE)
	else:
		$Sprite2D.set_deferred("texture", RED)
	
	# Connect signals
	SignalBus.button_on.connect(open)
	SignalBus.button_off.connect(close)

# Open door if received activator id matches self.id
func open(activator_id):
	# Ignore if ids don't match
	if activator_id != id:
		return
	
	# Play open animation
	# Animation player handles visibility/collision
	animation.play("open")
	
	# output
	print("door \"", self.name, "\" id:", id, " opened")

# Close door if received activator id matches self.id
func close(activator_id):
	# Ignore if ids don't match
	if activator_id != id:
		return
	
	# Play close animation
	# Animation player handles visibility/collision
	animation.play("close")
	
	# output
	print("door \"", self.name, "\" id:", id, " closed")

func _init(args := {}):
	if !args.is_empty():
		if args.has("blue"):
			blue = args.blue
		if args.has("id"):
			id = args.id
		
