extends ColorRect

@onready var animator: AnimationPlayer = get_node("AnimationPlayer")
@onready var resume_button: Button = get_node("CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton")
@onready var quit_button: Button = get_node("CenterContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton")

func _ready() -> void:
	resume_button.pressed.connect(Unpause)
	quit_button.pressed.connect(get_tree().quit)
	Events.game_state_changed.connect(_Game_State_Update)
	print(animator)
	
func _Game_State_Update(paused: bool):
	if paused == true: Pause()
	else: Unpause() 

func Unpause():
	animator.play("Unpause")
	get_tree().paused = false
	
func Pause():
	animator.play("Pause")
	get_tree().paused = true
