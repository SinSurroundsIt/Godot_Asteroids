extends TextureRect

@onready var play_button: Button = get_node("MainMenuButtons/PanelContainer/MarginContainer/VBoxContainer/PlayButton")
@onready var settings_button: Button = get_node("MainMenuButtons/PanelContainer/MarginContainer/VBoxContainer/SettingsButton")
@onready var quit_button: Button = get_node("MainMenuButtons/PanelContainer/MarginContainer/VBoxContainer/QuitButton")

@onready var main_menu_buttons: CenterContainer = get_node("MainMenuButtons")
@onready var settings_menu: CenterContainer = get_node("SettingsMenu")

var current_scene = null
var s = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	s = ResourceLoader.load("res://Scenes/level.tscn")
	
	play_button.pressed.connect(_Play_Game)
	settings_button.pressed.connect(_Settings_Menu)
	quit_button.pressed.connect(get_tree().quit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _Play_Game():
	call_deferred("_Call_Deferred_Switch_Scene")

func _Settings_Menu():
	main_menu_buttons.visible = false
	settings_menu.visible = true

func _Call_Deferred_Switch_Scene():
	current_scene.queue_free()
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
