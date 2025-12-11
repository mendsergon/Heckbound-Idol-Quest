extends Node2D

# ------------------------
# Signal emitted when button is turned on
# ------------------------
signal button_turned_on

# ------------------------
# Button state tracking
# ------------------------
var is_on: bool = false

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var interaction_area: Area2D = $InteractionArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# --------------------------------------------------------
	# Set initial sprite to "off" state
	# --------------------------------------------------------
	sprite_2d.play("Off")
	is_on = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_interaction_area_interacted() -> void:
	# --------------------------------------------------------
	# Toggle button state between on and off
	# --------------------------------------------------------
	if not is_on:
		# --------------------------------------------------------
		# Set to "on" state and emit signal
		# --------------------------------------------------------
		sprite_2d.play("On")
		is_on = true
		emit_signal("button_turned_on")
	else:
		# --------------------------------------------------------
		# Set back to "off" state
		# --------------------------------------------------------
		sprite_2d.play("Off")
		is_on = false


# --------------------------------------------------------
# Function to manually reset button to off state if needed
# --------------------------------------------------------
func reset_button() -> void:
	sprite_2d.play("Off")
	is_on = false
