extends Node2D

const TILEMAP_W = 64
const TILEMAP_H = 64

onready var line: Line2D = $Line2D
onready var tilemap: TileMap = $TileMap
onready var player: PhysicsBody2D = $Player
onready var zombie: PhysicsBody2D = $Zombie

var pathfinder: AStar2D = AStar2D.new()
var player_tile: int = 0


func serialise_coord(x: int, y: int) -> int:
	return y * TILEMAP_W + x


func get_tile(object: PhysicsBody2D) -> int:
	var v: Vector2 = object.global_position / 64
	return serialise_coord(floor(v.x), floor(v.y))


func _ready() -> void:
	for y in range(TILEMAP_H):
		for x in range(TILEMAP_W):
			var cell = tilemap.get_cell(x, y)

			if cell != 0:
				continue

			var current = serialise_coord(x, y)
			pathfinder.add_point(current, Vector2(x * 64 + 32, y * 64 + 32))


			if x > 0:
				var connection = serialise_coord(x - 1, y + 0)
				if pathfinder.has_point(connection):
					pathfinder.connect_points(current, connection)

			if y > 0:
				var connection = serialise_coord(x + 0, y - 1)
				if pathfinder.has_point(connection):
					pathfinder.connect_points(current, connection)


func _process(delta: float) -> void:
	var new_player_tile = get_tile(player)
	if player_tile != new_player_tile:
		player_tile = new_player_tile
		zombie.path_dirty = true
	process_zombie(zombie)


func order_zombie_to_attack(target: PhysicsBody2D) -> void:
	var p1: int = pathfinder.get_closest_point(zombie.global_position)
	var p2: int = pathfinder.get_closest_point(target.global_position)
	zombie.path = pathfinder.get_point_path(p1, p2)
	line.points = zombie.path


func process_zombie(zombie: PhysicsBody2D) -> void:
	if not zombie.path:
		order_zombie_to_attack(player)


func _unhandled_input(event: InputEvent) -> void:
	pass

