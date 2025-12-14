extends Node2D

@onready var camera_2d: Camera2D = $Camera2D

# Puzzle 0
@onready var button_0: Node2D = $Puzzle0/Button0
@onready var platform_0: StaticBody2D = $Puzzle0/Platform0
@onready var platform_1: StaticBody2D = $Puzzle0/Platform1

# Puzzle 1
@onready var button_1: Node2D = $Puzzle1/Button1
@onready var platform_2: StaticBody2D = $Puzzle1/Platform2
@onready var platform_3: StaticBody2D = $Puzzle1/Platform3
@onready var platform_4: StaticBody2D = $Puzzle1/Platform4
@onready var platform_5: StaticBody2D = $Puzzle1/Platform5
@onready var platform_6: StaticBody2D = $Puzzle1/Platform6

# Puzzle 2
@onready var button_2: Node2D = $Puzzle2/Button2
@onready var platform_7: StaticBody2D = $Puzzle2/Platform7

# Puzzle 3
@onready var button_3: Node2D = $Puzzle3/Button3
@onready var platform_8: StaticBody2D = $Puzzle3/Platform8


# Variables
var player: Node2D = null
var initial_camera_y: float = 0.0  # Store initial camera Y position
var camera_follow_speed: float = 5.0  # Higher = faster follow
var target_camera_y: float = 0.0

func _ready() -> void:
	# --------------------------------------------------------
	# Initialize platforms to disabled state at start
	# --------------------------------------------------------
	print("Level 1: Handling platforms at start")
	platform_0.disable()
	platform_1.disable()
	platform_2.disable()
	platform_3.disable()
	platform_4.disable()
	platform_5.disable()
	platform_6.disable()
	platform_7.enable()
	platform_8.enable()
	
	# --------------------------------------------------------
	# Wait a moment for player to be spawned by Main.gd
	# --------------------------------------------------------
	await get_tree().process_frame
	await get_tree().process_frame  # Wait 2 frames to be sure
	
	
	
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
	# Update camera position to follow player horizontally immediately
	# but with smooth delayed vertical following
	# --------------------------------------------------------
	if player:
		var player_pos = player.global_position
		
		# Immediate horizontal following
		var camera_x = player_pos.x
		
		# Smooth delayed vertical following
		target_camera_y = player_pos.y
		var current_camera_y = camera_2d.global_position.y
		var new_camera_y = lerp(current_camera_y, target_camera_y, camera_follow_speed * delta)
		
		camera_2d.global_position = Vector2(camera_x, new_camera_y)

func _on_button_0_button_turned_on() -> void:
	# --------------------------------------------------------
	# Toggle platforms when button is activated
	# --------------------------------------------------------
	print("BUTTON PRESSED! Toggling platforms")
	platform_0.toggle()
	platform_1.toggle()
	


func _on_button_1_button_turned_on() -> void:
	# --------------------------------------------------------
	# Toggle platforms when button is activated
	# --------------------------------------------------------
	print("BUTTON PRESSED! Toggling platforms")
	platform_2.toggle()
	platform_3.toggle()
	platform_4.toggle()
	platform_5.toggle()
	platform_6.toggle()


func _on_button_2_button_turned_on() -> void:
	# --------------------------------------------------------
	# Toggle platform when button is activated
	# --------------------------------------------------------
	print("BUTTON PRESSED! Toggling platform")
	platform_7.toggle()
	


func _on_button_3_button_turned_on() -> void:
	# --------------------------------------------------------
	# Toggle platform when button is activated
	# --------------------------------------------------------
	print("BUTTON PRESSED! Toggling platform")
	platform_8.toggle()
