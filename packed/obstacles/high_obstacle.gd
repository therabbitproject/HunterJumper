# High obstacle.

extends RigidBody2D

var _jumper = null

func _ready():
    _jumper = get_node("../jumper")
    add_to_group("obstacle")
    set_process(true)

func _process(delta):
    var pos = get_global_position()
    pos.x = pos.x - _jumper.speed * delta
    set_global_position(pos)

func hit_by_jumper():
    set_process(false)
