extends Sprite

onready var _jumper = get_node("../jumper")

var _xpos = 0

func _ready():
    set_process(true)

func _process(delta):
    _xpos += _jumper.speed * delta
    set_region_rect(Rect2(_xpos,0,960,540))
