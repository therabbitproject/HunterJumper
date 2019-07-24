# Obstacle spawner.

extends Timer

# List of possible obstacles.
var spawn_obstacles = [
    preload("res://packed/obstacles/low_obstacle.tscn"),
    preload("res://packed/obstacles/high_obstacle.tscn"),    
]

# Obstacle initial position.
var _obstacle_x = 1000
var _obstacle_y = 515

var _last_obstacle = null

func _ready():
    connect("timeout",self,"_on_timeout")

func _on_timeout():
    # Do not spawn obstacles when jumper is not running. 
    if (get_node("../jumper").speed == 0):
        return

    # Randomly skip spawning.
    if (rand_range(0, 1) == 1):
        return

    # Randomly spawn an obstacle.
    var r = rand_range(0, spawn_obstacles.size())
    var obstacle = spawn_obstacles[r].instance()

    # Make sure not to overlap obstacles.
    var s = obstacle.get_node("Sprite")
    var d = s.get_texture().get_size()
    if (_last_obstacle != null):
        var p = _last_obstacle.get_global_position()
        if (p.x >= _obstacle_x - d.x):
            return

    # Place the obstacle and add to scene.
    obstacle.set_global_position(Vector2(_obstacle_x, _obstacle_y))
    get_parent().add_child(obstacle)
    _last_obstacle = obstacle
