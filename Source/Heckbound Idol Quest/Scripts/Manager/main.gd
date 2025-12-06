extends Node2D

# ------------------------------------------
# Node references (assigned after scene loads)
# ------------------------------------------
var world: Node2D
var canvas_layer: CanvasLayer
var ui: Control
var audio_player: AudioStreamPlayer2D

# Pointer to whichever scene is currently active
var current_scene: Node = null

# List of levels — expandable later
var LEVELS = [
	"res://Scenes/Levels/Hell/Level_1.tscn"
]

# Paths to external scenes
var MAIN_MENU_PATH = "res://Scenes/UI/MainMenu.tscn"
var PLAYER_PATH = "res://Scenes/Characters/Player.tscn"


func _ready() -> void:
	# --------------------------------------------------------
	# 1. Wait one frame so nodes in Main.tscn are fully loaded
	# --------------------------------------------------------
	await get_tree().process_frame
	
	# --------------------------------------------------------
	# 2. Print all direct children for debugging
	# --------------------------------------------------------
	print("DIRECT CHILDREN OF MAIN NODE:")
	for i in range(get_child_count()):
		var child = get_child(i)
		print("  Index ", i, ": ", child.name, " (", child.get_class(), ")")
	
	# --------------------------------------------------------
	# 3. Fetch stored child nodes (World, UI layer, etc.)
	# --------------------------------------------------------
	world = get_node_or_null("World")
	canvas_layer = get_node_or_null("CanvasLayer")
	
	# Fetch UI under CanvasLayer
	if canvas_layer:
		ui = get_node_or_null("CanvasLayer/UI")
	else:
		ui = null
		
	audio_player = get_node_or_null("AudioStreamPlayer2D")
	
	# Debug print of found nodes
	print("\nFound nodes after search:")
	print("World: ", world)
	print("CanvasLayer: ", canvas_layer)
	print("UI: ", ui)
	print("AudioPlayer: ", audio_player)
	
	# --------------------------------------------------------
	# 4. If UI is missing, create a placeholder so game doesn't break
	# --------------------------------------------------------
	if not ui and canvas_layer:
		print("Creating temporary UI node")
		ui = Control.new()
		ui.name = "UI"
		canvas_layer.add_child(ui)
		ui.size = Vector2(1920, 1080)
	
	# --------------------------------------------------------
	# 5. Load the Main Menu as the first screen
	# --------------------------------------------------------
	if ui:
		load_main_menu()
	else:
		print("Failed to find or create UI node")


func load_main_menu() -> void:
	# --------------------------------------------------------
	# 1. Remove any currently loaded scene (level or menu)
	# --------------------------------------------------------
	if current_scene:
		current_scene.queue_free()

	# --------------------------------------------------------
	# 2. Instance the main menu under the UI layer
	# --------------------------------------------------------
	var menu_scene = load(MAIN_MENU_PATH).instantiate()
	ui.add_child(menu_scene)
	current_scene = menu_scene

	print("MainMenu loaded successfully")


func start_game() -> void:
	# --------------------------------------------------------
	# 1. Remove the current scene (menu)
	# --------------------------------------------------------
	if current_scene:
		current_scene.queue_free()
		current_scene = null

	# --------------------------------------------------------
	# 2. Load the first level in LEVELS[]
	# --------------------------------------------------------
	load_level(0)


func load_level(index: int) -> void:
	# --------------------------------------------------------
	# 1. Prevent loading invalid level index
	# --------------------------------------------------------
	if index < 0 or index >= LEVELS.size():
		print("Invalid level index")
		return

	# --------------------------------------------------------
	# 2. Load the level and add it inside World node
	# --------------------------------------------------------
	var level_scene = load(LEVELS[index]).instantiate()
	world.add_child(level_scene)
	current_scene = level_scene

	# --------------------------------------------------------
	# 3. Load and spawn the Player inside the World
	# --------------------------------------------------------
	var player_instance = load(PLAYER_PATH).instantiate()
	world.add_child(player_instance)

	print("Level ", index + 1, " loaded")
