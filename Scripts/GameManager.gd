extends Node

@export var lives: int

@onready var ship_tscn = preload("res://Scenes/ship.tscn")
@onready var project_resolution:Vector2 = get_viewport().content_scale_size

var player_ship: Ship

var _score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.game_state_changed.connect(_Pause_Check)
	Events.new_lives.emit(lives)
	Events.update_score.emit(_score)
	Events.player_died.connect(_Player_Died)
	Events.asteroid_destroyed.connect(_Destroyed_Asteroid)
	player_ship = _Spawn_Player()
	Events.new_player_ship.emit(player_ship)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_released("menu"):
		if !get_tree().paused:
			Events.game_state_changed.emit(true)
		else:
			Events.game_state_changed.emit(false)


func _Pause_Check(state: bool):
	if state == true:
		print("Game State: Paused")
	else:
		print("Game State: Playing")

func _Destroyed_Asteroid(size: int, _position: Vector2, _velocity: Vector2):
	if size == 3:
		_Update_Score(1)
	elif size == 2:
		_Update_Score(2)
	else:
		_Update_Score(3)

func _Update_Score(mod: int):
	_score += mod
	Events.update_score.emit(_score)

func _Player_Died():
	_Update_Lives(-1)
	if lives > 0:
		Events.set_spawn_safety.emit(true)
		var respawn_timer: Timer = Timer.new()
		add_child(respawn_timer)
		respawn_timer.wait_time = 3.0
		respawn_timer.one_shot = true
		respawn_timer.timeout.connect(_Respawn)
		respawn_timer.start()


func _Update_Lives(mod: int):
	if lives > 0:
		lives += mod
		Events.new_lives.emit(lives)
	if lives == 0:
		_Game_Over()

func _Spawn_Player() -> Ship:
	var ship = ship_tscn.instantiate()
	call_deferred("add_child", ship)
	var spawn_point: Vector2 = Vector2(project_resolution.x / 2, project_resolution.y / 2)
	ship.position = spawn_point
	return ship
	
func _Respawn():
		player_ship = _Spawn_Player()
		Events.new_player_ship.emit(player_ship)
		Events.set_spawn_safety.emit(false)

func _Game_Over():
	pass
