extends Node2D

@onready var camera_2d: Camera2D = $Camera2D
@onready var button_0: Node2D = $Button0
@onready var platform_0: StaticBody2D = $Platform0
@onready var platform_1: StaticBody2D = $Platform1

# Variables
var player: Node2D = null
var initial_camera_y: float = 0.0  # Store initial camera Y position

func _ready() -> void:
	# --------------------------------------------------------
	# Initialize platforms to disabled state at start
	# --------------------------------------------------------
	print("Level 1: Disabling platforms at start")
	platform_0.disable()
	platform_1.disable()
	
	# --------------------------------------------------------
	# Wait a moment for player to be spawned by Main.gd
	# --------------------------------------------------------
	await get_tree().process_frame
	await get_tree().process_frame  # Wait 2 frames to be sure
	
	# --------------------------------------------------------
	# Store initial camera Y position
	# --------------------------------------------------------
	initial_camera_y = camera_2d.global_position.y
	
	# --------------------------------------------------------
	# Find the player that was spawned into this level
	# --------------------------------------------------------
	find_player_and_attach_camera()
	

func find_player_and_attach_camera():
	# --------------------------------------------------------
	# 1. Look for player in the scene tree
	# --------------------------------------------------------
	var world = get_parent()
	if world:
		for child in world.get_children():
			if "Player" in child.name or "player" in child.name.to_lower():
				player = child
				print("Found player in level: ", player.name)
				break
	
	# --------------------------------------------------------
	# 2. If found, make camera active
	# --------------------------------------------------------
	if player:
		camera_2d.make_current()
		print("Camera following player horizontally")
	else:
		print("ERROR: Could not find player in level!")


func _process(delta: float) -> void:
	# --------------------------------------------------------
	# Update camera position to follow player horizontally only
	# --------------------------------------------------------
	if player:
		var player_pos = player.global_position
		camera_2d.global_position = Vector2(player_pos.x, initial_camera_y)

func _on_button_0_button_turned_on() -> void:
	# --------------------------------------------------------
	# Toggle platforms when button is activated
	# --------------------------------------------------------
	print("BUTTON PRESSED! Toggling platforms")
	platform_0.toggle()
	platform_1.toggle()
	
