class_name WorldNavigationRegion extends NavigationRegion2D


# A change arrived while a bake was running; bake again once it finishes.
var _is_dirty: bool = false


func _ready():
	bake_finished.connect(_on_bake_finished)
	bake_navigation_polygon()

# Runtime obstacles call this when their footprint changes. Requests coalesce
# so at most one bake is in flight.
func request_rebake() -> void:
	if is_baking():
		_is_dirty = true
		return
	bake_navigation_polygon()

func _on_bake_finished() -> void:
	if _is_dirty:
		_is_dirty = false
		bake_navigation_polygon()
