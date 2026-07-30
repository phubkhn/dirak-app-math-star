extends Node

# Ephemeral cross-scene state for the current play session.
# (Persistent progress lives in ProgressService; this is just in-memory routing/session data.)

const LEVEL_THEMES := [
	"Bầu trời quê em", "Bầu trời quê em", "Bầu trời quê em",
	"Đại dương vui nhộn", "Đại dương vui nhộn", "Đại dương vui nhộn",
	"Khu rừng sắc màu", "Khu rừng sắc màu", "Khu rừng sắc màu",
	"Vũ trụ ngôi sao",
]
const LEVEL_COUNT := 10

var current_level_id := 1

# Quiz session
var quiz_set: Array = []
var quiz_index := 0
var first_attempt_score := 0
var review_list: Array = []

var pending_fallback_return_scene := "res://scenes/map/Map.tscn"


func difficulty_for_level(level_id: int) -> int:
	if level_id <= 3:
		return 1
	if level_id <= 6:
		return 2
	return 3


func theme_for_level(level_id: int) -> String:
	return LEVEL_THEMES[clamp(level_id - 1, 0, LEVEL_THEMES.size() - 1)]


func start_quiz_session() -> void:
	quiz_set = QuestionRepository.build_quiz_set(difficulty_for_level(current_level_id))
	quiz_index = 0
	first_attempt_score = 0
	review_list = []
