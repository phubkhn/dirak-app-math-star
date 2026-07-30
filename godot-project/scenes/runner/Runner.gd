extends Control

const LANE_X := [176.0, 480.0, 784.0]
const SHIP_Y := 300.0
const JUMP_Y := 190.0

@onready var ship: ColorRect = %Ship
@onready var star_count_label: Label = %StarCountLabel
@onready var hit_flash: Label = %HitFlash
@onready var playfield: Control = %Playfield

@onready var lane_left_btn: Button = %LaneLeftButton
@onready var jump_btn: Button = %JumpButton
@onready var lane_right_btn: Button = %LaneRightButton
@onready var goto_quiz_btn: Button = %GotoQuizButton
@onready var pause_btn: Button = %PauseButton

@onready var tutorial_overlay: Control = %TutorialOverlay
@onready var tutorial_step1: Control = %TutorialStep1
@onready var tutorial_step2: Control = %TutorialStep2
@onready var tutorial_next_btn: Button = %TutorialNextButton
@onready var tutorial_start_btn: Button = %TutorialStartButton

@onready var pause_backdrop: Control = %PauseBackdrop
@onready var pause_main: Control = %PauseMain
@onready var pause_confirm_restart: Control = %PauseConfirmRestart
@onready var resume_btn: Button = %ResumeButton
@onready var restart_btn: Button = %RestartButton
@onready var restart_confirm_btn: Button = %RestartConfirmButton
@onready var restart_cancel_btn: Button = %RestartCancelButton
@onready var pause_to_map_btn: Button = %PauseToMapButton

@onready var obstacles: Array = []
@onready var collectibles: Array = []

var current_lane := 1
var star_count := 0
var _swipe_start := Vector2.ZERO
var _swipe_tracking := false


func _ready() -> void:
	obstacles = [%Obstacle1, %Obstacle2]
	collectibles = [%Collectible1, %Collectible2]

	lane_left_btn.pressed.connect(func(): set_lane(current_lane - 1))
	lane_right_btn.pressed.connect(func(): set_lane(current_lane + 1))
	jump_btn.pressed.connect(_do_jump)
	goto_quiz_btn.pressed.connect(_on_goto_quiz)
	pause_btn.pressed.connect(_open_pause)

	for c in collectibles:
		c.pressed.connect(_on_collectible_pressed.bind(c))
	for o in obstacles:
		o.pressed.connect(_on_obstacle_pressed.bind(o))

	tutorial_next_btn.pressed.connect(_on_tutorial_next)
	tutorial_start_btn.pressed.connect(_on_tutorial_start)

	resume_btn.pressed.connect(func(): pause_backdrop.hide())
	restart_btn.pressed.connect(_show_restart_confirm)
	restart_confirm_btn.pressed.connect(_do_restart)
	restart_cancel_btn.pressed.connect(_hide_restart_confirm)
	pause_to_map_btn.pressed.connect(func():
		pause_backdrop.hide()
		get_tree().change_scene_to_file("res://scenes/map/Map.tscn")
	)

	playfield.gui_input.connect(_on_playfield_input)

	_reset_state()
	if GameState.current_level_id == 1 and not ProgressService.has_played_tutorial:
		_start_tutorial()
	else:
		tutorial_overlay.hide()


func _reset_state() -> void:
	current_lane = 1
	star_count = 0
	_update_star_label()
	_update_ship_position(false)
	for c in collectibles:
		c.visible = true
	for o in obstacles:
		o.modulate = Color(1, 1, 1)


func set_lane(lane: int) -> void:
	current_lane = clamp(lane, 0, 2)
	_update_ship_position(true)


func _update_ship_position(animate: bool) -> void:
	var target_x: float = LANE_X[current_lane] - ship.size.x / 2.0
	if animate:
		var tween := create_tween()
		tween.tween_property(ship, "position:x", target_x, 0.14)
	else:
		ship.position.x = target_x


func _do_jump() -> void:
	var tween := create_tween()
	tween.tween_property(ship, "position:y", JUMP_Y, 0.15)
	tween.tween_property(ship, "position:y", SHIP_Y, 0.2)


func _on_collectible_pressed(c: Button) -> void:
	if not c.visible:
		return
	c.visible = false
	star_count += 1
	_update_star_label()


func _on_obstacle_pressed(o: Button) -> void:
	star_count = max(0, star_count - 1)
	_update_star_label()
	o.modulate = Color(1, 0.6, 0.55)
	hit_flash.modulate.a = 1.0
	var tween := create_tween()
	tween.tween_interval(0.4)
	tween.tween_callback(func():
		o.modulate = Color(1, 1, 1)
		hit_flash.modulate.a = 0.0
	)


func _update_star_label() -> void:
	star_count_label.text = "★ %d" % star_count


func _on_goto_quiz() -> void:
	GameState.start_quiz_session()
	get_tree().change_scene_to_file("res://scenes/quiz/Quiz.tscn")


# ---- Touch swipe/tap gesture support (APP_SPEC FR-02) ----

func _on_playfield_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		var pressed: bool = event.pressed if event is InputEventScreenTouch else event.button_pressed
		var pos: Vector2 = event.position
		if pressed:
			_swipe_start = pos
			_swipe_tracking = true
		elif _swipe_tracking:
			_swipe_tracking = false
			var delta: Vector2 = pos - _swipe_start
			if abs(delta.x) > 60 and abs(delta.x) > abs(delta.y):
				set_lane(current_lane + (1 if delta.x > 0 else -1))
			elif abs(delta.y) < 20 and abs(delta.x) < 20:
				_do_jump()
	elif event is InputEventScreenDrag:
		pass


# ---- Tutorial (DES-03) ----

func _start_tutorial() -> void:
	tutorial_step1.show()
	tutorial_step2.hide()
	tutorial_overlay.show()
	_set_background_inert(true)


func _on_tutorial_next() -> void:
	tutorial_step1.hide()
	tutorial_step2.show()
	tutorial_start_btn.grab_focus()


func _on_tutorial_start() -> void:
	ProgressService.has_played_tutorial = true
	ProgressService.save_progress()
	tutorial_overlay.hide()
	_set_background_inert(false)


func _set_background_inert(is_inert: bool) -> void:
	for node_name in ["HUD", "Playfield", "Controls"]:
		var n := get_node_or_null(node_name)
		if n:
			n.mouse_filter = Control.MOUSE_FILTER_IGNORE if is_inert else Control.MOUSE_FILTER_STOP
			for child in n.get_children():
				if child is Control:
					child.focus_mode = Control.FOCUS_NONE if is_inert else Control.FOCUS_ALL


# ---- Pause (DES-05) ----

func _open_pause() -> void:
	pause_main.show()
	pause_confirm_restart.hide()
	pause_backdrop.show()


func _show_restart_confirm() -> void:
	pause_main.hide()
	pause_confirm_restart.show()
	restart_confirm_btn.grab_focus()


func _hide_restart_confirm() -> void:
	pause_confirm_restart.hide()
	pause_main.show()
	resume_btn.grab_focus()


func _do_restart() -> void:
	_reset_state()
	pause_backdrop.hide()
