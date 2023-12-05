extends ColorRect

@onready var animator: AnimationPlayer = get_node("AnimationPlayer")
@onready var resume_button: Button = get_node("CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton")
@onready var menu_button: Button = get_node("CenterContainer/PanelContainer/MarginContainer/VBoxContainer/MenuButton")
@onready var quit_button: Button = get_node("CenterContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton")

var current_scene = null
var s = null

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	s = ResourceLoader.load("res://Scenes/main_menu.tscn")
	
	resume_button.pressed.connect(Unpause)
	menu_button.pressed.connect(_To_Main_Menu)
	quit_button.pressed.connect(get_tree().quit)
	Events.game_state_changed.connect(_Game_State_Update)
	Unpause()
	
func _Game_State_Update(paused: bool):
	if paused == true: Pause()
	else: Unpause() 

func Unpause():
	animator.play("Unpause")
	print("Unpause")
	get_tree().paused = false
	
func Pause():
	animator.play("Pause")
	print("Pause")
	get_tree().paused = true
	
func _To_Main_Menu():
	print("To Main Menu")
	Unpause()
	call_deferred("_Call_Deferred_Switch_Scene")

func _Call_Deferred_Switch_Scene():
	current_scene.queue_free()
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	current_scene.request_ready()
