extends PhysicsBody2D


onready var sprite = @"Sprite"


var path_dirty: bool = true setget set_path_dirty
var path: PoolVector2Array = PoolVector2Array() setget set_path
var speed: float = 100

func _ready():
	pass


func _process(delta: float) -> void:
	move_along_path(speed * delta)


func move_along_path(distance: float) -> void:
	for node in path:
		var distance_to_next: float = position.distance_to(path[0])
		var direction_to_next: Vector2 = (position - path[0]).normalized()
		if distance > distance_to_next:
			distance -= distance_to_next
			position = node
			if path_dirty:
				path.resize(0)
				break
			path.remove(0)
		else:
			position = position.linear_interpolate(node, distance / distance_to_next)
			break


func set_path_dirty(value: bool) -> void:
	path_dirty = value


func set_path(value: PoolVector2Array) -> void:
	if not value:
		return
	value.remove(0)
	path = value
