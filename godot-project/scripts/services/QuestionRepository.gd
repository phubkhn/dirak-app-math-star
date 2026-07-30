extends Node

# Loads and validates res://data/questions.math.vi.json (FR-06, DATA-01..07).
# Falls back to a small built-in safe set if validation fails (FR-10, DATA-06).

const DATA_PATH := "res://data/questions.math.vi.json"
const QUESTIONS_PER_GATE := 10
const ADDITION_PER_GATE := 5
const SUBTRACTION_PER_GATE := 5
const MAX_CONSECUTIVE_REGROUP := 3

var all_questions: Array = []
var data_load_failed := false
var load_error_message := ""

var _used_ids: Dictionary = {} # "<difficulty>_<operation>" -> Array[String]

const FALLBACK_QUESTIONS := [
	{"id": "FALLBACK-ADD-1", "operation": "addition", "difficulty": 1, "operand_a": 2, "operand_b": 3, "operator": "+", "prompt": "Tính: 2 + 3 = ?", "answer": 5, "requires_regrouping": false, "hint": "Đếm thêm 3.", "explanation": "2 + 3 = 5."},
	{"id": "FALLBACK-ADD-2", "operation": "addition", "difficulty": 1, "operand_a": 4, "operand_b": 5, "operator": "+", "prompt": "Tính: 4 + 5 = ?", "answer": 9, "requires_regrouping": false, "hint": "Đếm thêm 5.", "explanation": "4 + 5 = 9."},
	{"id": "FALLBACK-ADD-3", "operation": "addition", "difficulty": 1, "operand_a": 6, "operand_b": 7, "operator": "+", "prompt": "Tính: 6 + 7 = ?", "answer": 13, "requires_regrouping": true, "hint": "Cộng hàng đơn vị trước.", "explanation": "6 + 7 = 13."},
	{"id": "FALLBACK-ADD-4", "operation": "addition", "difficulty": 1, "operand_a": 8, "operand_b": 4, "operator": "+", "prompt": "Tính: 8 + 4 = ?", "answer": 12, "requires_regrouping": true, "hint": "Cộng hàng đơn vị trước.", "explanation": "8 + 4 = 12."},
	{"id": "FALLBACK-ADD-5", "operation": "addition", "difficulty": 1, "operand_a": 10, "operand_b": 9, "operator": "+", "prompt": "Tính: 10 + 9 = ?", "answer": 19, "requires_regrouping": false, "hint": "Đếm thêm 9.", "explanation": "10 + 9 = 19."},
	{"id": "FALLBACK-SUB-1", "operation": "subtraction", "difficulty": 1, "operand_a": 5, "operand_b": 2, "operator": "-", "prompt": "Tính: 5 - 2 = ?", "answer": 3, "requires_regrouping": false, "hint": "Đếm bớt 2.", "explanation": "5 - 2 = 3."},
	{"id": "FALLBACK-SUB-2", "operation": "subtraction", "difficulty": 1, "operand_a": 9, "operand_b": 4, "operator": "-", "prompt": "Tính: 9 - 4 = ?", "answer": 5, "requires_regrouping": false, "hint": "Đếm bớt 4.", "explanation": "9 - 4 = 5."},
	{"id": "FALLBACK-SUB-3", "operation": "subtraction", "difficulty": 1, "operand_a": 12, "operand_b": 5, "operator": "-", "prompt": "Tính: 12 - 5 = ?", "answer": 7, "requires_regrouping": true, "hint": "Mượn 1 chục.", "explanation": "12 - 5 = 7."},
	{"id": "FALLBACK-SUB-4", "operation": "subtraction", "difficulty": 1, "operand_a": 11, "operand_b": 6, "operator": "-", "prompt": "Tính: 11 - 6 = ?", "answer": 5, "requires_regrouping": true, "hint": "Mượn 1 chục.", "explanation": "11 - 6 = 5."},
	{"id": "FALLBACK-SUB-5", "operation": "subtraction", "difficulty": 1, "operand_a": 10, "operand_b": 3, "operator": "-", "prompt": "Tính: 10 - 3 = ?", "answer": 7, "requires_regrouping": true, "hint": "Mượn 1 chục.", "explanation": "10 - 3 = 7."},
]


func _ready() -> void:
	_load_and_validate()


func _load_and_validate() -> void:
	if not FileAccess.file_exists(DATA_PATH):
		_fail("Không tìm thấy tệp câu hỏi tại %s" % DATA_PATH)
		return

	var file := FileAccess.open(DATA_PATH, FileAccess.READ)
	if file == null:
		_fail("Không thể mở tệp câu hỏi.")
		return

	var text := file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(text)
	if parsed == null or not (parsed is Dictionary):
		_fail("Tệp câu hỏi không đúng định dạng JSON.")
		return

	var questions = parsed.get("questions", null)
	if questions == null or not (questions is Array):
		_fail("Không tìm thấy danh sách 'questions' trong tệp.")
		return

	var declared_count = parsed.get("question_count", -1)
	if declared_count != questions.size():
		_fail("question_count (%s) không khớp số câu thực tế (%s)." % [declared_count, questions.size()])
		return

	var seen_ids := {}
	var addition_count := 0
	var subtraction_count := 0

	for q in questions:
		if not (q is Dictionary):
			_fail("Một mục câu hỏi không phải là object hợp lệ.")
			return

		var id = q.get("id", "")
		if id == "" or seen_ids.has(id):
			_fail("ID câu hỏi bị thiếu hoặc trùng lặp: %s" % id)
			return
		seen_ids[id] = true

		var operation = q.get("operation", "")
		var a = q.get("operand_a", null)
		var b = q.get("operand_b", null)
		var answer = q.get("answer", null)
		var difficulty = q.get("difficulty", null)

		if not (a is int or a is float) or not (b is int or b is float) or not (answer is int or answer is float):
			_fail("Toán hạng/đáp án không hợp lệ cho câu %s" % id)
			return
		# JSON.parse_string() always returns numbers as float, so accept float here
		# and require it to be a whole number rather than requiring GDScript `is int`.
		if not (difficulty is int or difficulty is float) or difficulty != round(difficulty) or difficulty < 1 or difficulty > 3:
			_fail("difficulty không hợp lệ cho câu %s" % id)
			return
		difficulty = int(difficulty)

		var expected_answer
		if operation == "addition":
			expected_answer = a + b
			addition_count += 1
		elif operation == "subtraction":
			expected_answer = a - b
			subtraction_count += 1
			if expected_answer < 0:
				_fail("Phép trừ cho kết quả âm ở câu %s" % id)
				return
		else:
			_fail("operation không hợp lệ ('%s') cho câu %s" % [operation, id])
			return

		if expected_answer != answer:
			_fail("Đáp án sai lệch với phép tính ở câu %s (kỳ vọng %s, có %s)" % [id, expected_answer, answer])
			return
		if answer < 0 or answer > 100:
			_fail("Đáp án ngoài phạm vi 0-100 ở câu %s" % id)
			return

	if addition_count != subtraction_count:
		_fail("Số câu cộng (%s) và trừ (%s) không cân bằng." % [addition_count, subtraction_count])
		return

	all_questions = questions
	data_load_failed = false
	load_error_message = ""
	print("QuestionRepository: loaded and validated %d questions." % all_questions.size())


func _fail(message: String) -> void:
	push_warning("QuestionRepository validation failed: %s — using fallback question set." % message)
	data_load_failed = true
	load_error_message = message
	all_questions = FALLBACK_QUESTIONS.duplicate(true)


## Builds one 10-question set (5 addition + 5 subtraction) for the given difficulty (1-3),
## honoring no-repeat-within-session and max-3-consecutive-regrouping rules (APP_SPEC 4.3).
func build_quiz_set(difficulty: int) -> Array:
	var addition_pool := _draw_group(difficulty, "addition", ADDITION_PER_GATE)
	var subtraction_pool := _draw_group(difficulty, "subtraction", SUBTRACTION_PER_GATE)

	var combined := addition_pool + subtraction_pool
	var attempt := _shuffled(combined)
	var guard := 0
	while _has_too_many_consecutive_regroup(attempt) and guard < 20:
		attempt = _shuffled(combined)
		guard += 1
	return attempt


func _draw_group(difficulty: int, operation: String, count: int) -> Array:
	var key := "%d_%s" % [difficulty, operation]
	var candidates := all_questions.filter(func(q): return q.get("difficulty") == difficulty and q.get("operation") == operation)

	if candidates.is_empty():
		# Difficulty not represented (e.g. fallback set) — widen to any difficulty for that operation.
		candidates = all_questions.filter(func(q): return q.get("operation") == operation)

	var used: Array = _used_ids.get(key, [])
	var unused := candidates.filter(func(q): return not used.has(q.get("id")))

	if unused.size() < count:
		# Pool exhausted for this group — clear history and reshuffle (APP_SPEC 4.3).
		used = []
		unused = candidates.duplicate()

	unused = _shuffled(unused)
	var picked: Array = unused.slice(0, min(count, unused.size()))

	for q in picked:
		used.append(q.get("id"))
	_used_ids[key] = used

	return picked


func _shuffled(arr: Array) -> Array:
	var a := arr.duplicate()
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	for i in range(a.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var tmp = a[i]
		a[i] = a[j]
		a[j] = tmp
	return a


func _has_too_many_consecutive_regroup(list: Array) -> bool:
	var streak := 0
	for q in list:
		if q.get("requires_regrouping", false):
			streak += 1
			if streak > MAX_CONSECUTIVE_REGROUP:
				return true
		else:
			streak = 0
	return false


## Called from the Adult Area after an explicit confirmation (APP_SPEC 4.3 last bullet).
func clear_session_history() -> void:
	_used_ids.clear()
