extends Control

const TOTAL_QUESTIONS := 10
const PASS_THRESHOLD := 8
const CORRECT_PHRASES := ["Chính xác!", "Giỏi lắm!", "Tuyệt vời!"]

@onready var progress_box: HBoxContainer = %ProgressBox
@onready var count_label: Label = %CountLabel
@onready var equation_label: Label = %EquationLabel
@onready var speak_btn: Button = %SpeakButton
@onready var answer_label: Label = %AnswerLabel
@onready var feedback_label: Label = %FeedbackLabel
@onready var feedback_explain: Label = %FeedbackExplain
@onready var keypad: GridContainer = %Keypad
@onready var submit_btn: Button = %SubmitButton
@onready var exit_btn: Button = %ExitButton

@onready var exit_backdrop: Control = %ExitBackdrop
@onready var exit_cancel_btn: Button = %ExitCancelButton
@onready var exit_confirm_btn: Button = %ExitConfirmButton

@onready var quiz_body: Control = %QuizBody
@onready var result_panel: Control = %ResultPanel
@onready var result_title: Label = %ResultTitle
@onready var result_score: Label = %ResultScore
@onready var result_stars: Label = %ResultStars
@onready var result_next: Label = %ResultNext
@onready var result_review_list: Label = %ResultReviewList
@onready var result_primary_btn: Button = %ResultPrimaryButton
@onready var result_secondary_btn: Button = %ResultSecondaryButton
@onready var fallback_overlay: Control = %FallbackOverlay

var current_digits := ""
var attempt_number := 1
var awaiting_continue := false
var _retry_clear_timer: SceneTreeTimer


func _ready() -> void:
	exit_btn.pressed.connect(func(): exit_backdrop.show())
	exit_cancel_btn.pressed.connect(func(): exit_backdrop.hide())
	exit_confirm_btn.pressed.connect(func():
		exit_backdrop.hide()
		get_tree().change_scene_to_file("res://scenes/map/Map.tscn")
	)
	speak_btn.pressed.connect(_on_speak)

	for key_btn in keypad.get_children():
		if key_btn is Button:
			key_btn.pressed.connect(_on_key_pressed.bind(key_btn))

	result_panel.hide()
	quiz_body.show()
	if GameState.quiz_set.is_empty():
		GameState.start_quiz_session()
	_load_question()

	# DES-11: real data-fallback path. If QuestionRepository failed to validate
	# questions.math.vi.json at startup, it already fell back to a safe default
	# set — this just surfaces that to the child briefly, per screen-flow.md's
	# DES-06 -> DES-11 -> DES-06 edge, then continues automatically.
	if QuestionRepository.data_load_failed:
		fallback_overlay.show()
		get_tree().create_timer(1.2).timeout.connect(func():
			fallback_overlay.hide()
		)


func _render_progress() -> void:
	for i in range(progress_box.get_child_count()):
		var dot: Panel = progress_box.get_child(i)
		if i < GameState.quiz_index:
			dot.self_modulate = Color(0.098, 0.478, 0.29)
		elif i == GameState.quiz_index:
			dot.self_modulate = Color(0.098, 0.435, 0.686)
		else:
			dot.self_modulate = Color(0.91, 0.933, 0.953)
	count_label.text = "Câu %d/%d" % [GameState.quiz_index + 1, TOTAL_QUESTIONS]


func _load_question() -> void:
	if _retry_clear_timer:
		_retry_clear_timer = null
	var q: Dictionary = GameState.quiz_set[GameState.quiz_index]
	equation_label.text = "%d %s %d = ?" % [int(q.operand_a), q.operator, int(q.operand_b)]
	current_digits = ""
	attempt_number = 1
	awaiting_continue = false
	answer_label.text = " "
	answer_label.remove_theme_color_override("font_color")
	feedback_label.text = ""
	feedback_explain.text = ""
	_set_keypad_enabled(true)
	submit_btn.text = "Trả lời"
	_render_progress()


func _set_keypad_enabled(enabled: bool) -> void:
	for key_btn in keypad.get_children():
		if key_btn is Button:
			key_btn.disabled = not enabled


func _on_key_pressed(btn: Button) -> void:
	var key: String = btn.get_meta("key", "")
	if awaiting_continue:
		if key == "submit":
			_advance_after_reveal()
		return

	if key == "delete":
		current_digits = current_digits.substr(0, max(0, current_digits.length() - 1))
		_update_answer_display()
	elif key == "submit":
		_submit_answer()
	else:
		if current_digits.length() >= 3:
			return
		current_digits += key
		_update_answer_display()


func _update_answer_display() -> void:
	answer_label.text = current_digits if current_digits.length() > 0 else " "


func _submit_answer() -> void:
	if current_digits.length() == 0:
		return
	var q: Dictionary = GameState.quiz_set[GameState.quiz_index]
	var value := int(current_digits)
	var is_correct: bool = value == int(q.answer)

	if attempt_number == 1:
		ProgressService.record_answer(q.operation, q.requires_regrouping, is_correct)

	if is_correct:
		if attempt_number == 1:
			GameState.first_attempt_score += 1
		answer_label.add_theme_color_override("font_color", Color(0.098, 0.478, 0.29))
		feedback_label.text = "✔ " + CORRECT_PHRASES[randi() % CORRECT_PHRASES.size()]
		feedback_label.add_theme_color_override("font_color", Color(0.098, 0.478, 0.29))
		_set_keypad_enabled(false)
		get_tree().create_timer(0.9).timeout.connect(_next_question)
		return

	if attempt_number == 1:
		attempt_number = 2
		GameState.review_list.append(q)
		answer_label.add_theme_color_override("font_color", Color(0.722, 0.231, 0.369))
		feedback_label.text = "↻ Con thử lại nhé."
		feedback_label.add_theme_color_override("font_color", Color(0.722, 0.231, 0.369))
		current_digits = ""
		_set_keypad_enabled(false)
		_retry_clear_timer = get_tree().create_timer(1.1)
		_retry_clear_timer.timeout.connect(_clear_retry_feedback)
		return

	answer_label.add_theme_color_override("font_color", Color(0.722, 0.231, 0.369))
	feedback_label.text = "i  %d %s %d = %d" % [int(q.operand_a), q.operator, int(q.operand_b), int(q.answer)]
	feedback_label.add_theme_color_override("font_color", Color(0.09, 0.196, 0.302))
	feedback_explain.text = str(q.hint)
	_set_keypad_enabled(false)
	submit_btn.disabled = false
	submit_btn.text = "Tiếp tục"
	awaiting_continue = true


func _clear_retry_feedback() -> void:
	_update_answer_display()
	answer_label.remove_theme_color_override("font_color")
	feedback_label.text = ""
	_set_keypad_enabled(true)


func _advance_after_reveal() -> void:
	submit_btn.text = "Trả lời"
	_next_question()


func _next_question() -> void:
	GameState.quiz_index += 1
	if GameState.quiz_index >= TOTAL_QUESTIONS:
		_finish_quiz()
		return
	_load_question()


func _on_speak() -> void:
	var q: Dictionary = GameState.quiz_set[GameState.quiz_index]
	var op_word := " cộng " if q.operator == "+" else " trừ "
	var text := "Tính %d%s%d" % [int(q.operand_a), op_word, int(q.operand_b)]
	if DisplayServer.tts_is_speaking():
		DisplayServer.tts_stop()
	if DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
		DisplayServer.tts_speak(text, "vi", 80, 1.0, 1.0)


# ---- Results (DES-08/DES-09) ----

func _stars_for_score(score: int) -> int:
	if score >= 10:
		return 3
	if score == 9:
		return 2
	if score == 8:
		return 1
	return 0


func _finish_quiz() -> void:
	quiz_body.hide()
	result_panel.show()
	var score := GameState.first_attempt_score
	if score >= PASS_THRESHOLD:
		_render_pass(score)
	else:
		_render_retry(score)


func _render_pass(score: int) -> void:
	var stars := _stars_for_score(score)
	var level_id := GameState.current_level_id
	ProgressService.record_level_pass(level_id, stars)

	var is_last: bool = level_id >= GameState.LEVEL_COUNT
	result_title.text = "Con đã hoàn thành mọi vùng đất!" if is_last else "Con đã mở màn mới!"
	result_score.text = "%d/10" % score
	result_score.remove_theme_color_override("font_color")
	result_score.add_theme_color_override("font_color", Color(0.098, 0.478, 0.29))
	result_stars.text = "★".repeat(stars) + "☆".repeat(3 - stars)
	result_review_list.hide()

	if is_last:
		result_next.hide()
	else:
		result_next.show()
		result_next.text = "Tiếp theo: Màn %d — %s" % [level_id + 1, GameState.theme_for_level(level_id + 1)]

	result_primary_btn.text = "Về bản đồ"
	result_secondary_btn.hide()
	_connect_once(result_primary_btn, func(): get_tree().change_scene_to_file("res://scenes/map/Map.tscn"))


func _render_retry(score: int) -> void:
	result_title.text = "Con sắp mở được rồi!"
	result_score.text = "%d/10" % score
	result_score.remove_theme_color_override("font_color")
	result_score.add_theme_color_override("font_color", Color(0.09, 0.196, 0.302))
	result_stars.text = ""
	result_next.hide()

	var lines := PackedStringArray()
	for q in GameState.review_list.slice(0, 3):
		lines.append("• %d %s %d = %d" % [int(q.operand_a), q.operator, int(q.operand_b), int(q.answer)])
	result_review_list.text = "\n".join(lines) if lines.size() > 0 else "Không có câu cần xem lại."
	result_review_list.show()

	result_primary_btn.text = "Thử lại"
	result_secondary_btn.text = "Về bản đồ"
	result_secondary_btn.show()
	_connect_once(result_primary_btn, func():
		GameState.start_quiz_session()
		result_panel.hide()
		quiz_body.show()
		_load_question()
	)
	_connect_once(result_secondary_btn, func(): get_tree().change_scene_to_file("res://scenes/map/Map.tscn"))


func _connect_once(btn: Button, callable: Callable) -> void:
	for c in btn.pressed.get_connections():
		btn.pressed.disconnect(c["callable"])
	btn.pressed.connect(callable)
