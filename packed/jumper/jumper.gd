# Jumper.

extends RigidBody2D

# State.
var speed
var _speed
var _jumping
var _jump_height
var _jump_dir
var _jump_y
var _current_frame
var _frame_advance_counter
var _active
var _obstacle

# Constants.
var _max_speed
var _speed_delta
var _width
var _height
var _origin_x
var _origin_y
var _max_jump_height
var _jump_speed
var _standing_frame
var _jumping_up_frame
var _jumping_down_frame
var _running_first_frame
var _running_last_frame
var _running_current_frame
var _frame_advance_threshold

# Initialize.
func _ready():
    _max_speed = 100000
    _speed_delta = 10000
    var s = get_node("Sprite")
    var d = s.get_texture().get_size()
    _width = d.x / s.hframes
    _height = d.y / s.vframes
    var p = get_global_position()
    _origin_x = p.x
    _origin_y = p.y
    _max_jump_height = 150
    _jump_speed = 200
    _standing_frame = 1
    _jumping_up_frame = 11
    _jumping_down_frame = 11
    _running_first_frame = 8
    _running_last_frame = 11
    _frame_advance_threshold = 1500
    connect("body_entered", self, "_on_body_entered")
    set_process_input(true)
    reset()

# Reset.
func reset():
    speed = 0
    _speed = 0
    _jumping = false
    _jump_height = 0
    _jump_dir = 0
    _jump_y = 0
    var p = Vector2(_origin_x, _origin_y)
    set_global_position(p)
    _current_frame = _standing_frame
    var s = get_node("Sprite")
    s.set_frame(_current_frame)
    _running_current_frame = _running_first_frame
    _frame_advance_counter = 0
    _active = true
    set_process(true)

# Input event.
func _input(event):

    # Mouse input?
    var valid_input = false
    if ((event is InputEventMouseButton) and event.is_pressed() and not event.is_echo()):
        valid_input = true
        
    # Touch input?
    if((event is InputEventScreenTouch) and event.is_pressed() and not event.is_echo()):
        valid_input = true

    # Valid input?
    if (valid_input):

        if (_active):

            if (!_jumping):
                
                # If input behind then slowing down.
                if (event.position.x < _origin_x - _width):
                    if (event.position.y > _origin_y - _height):
                        _speed -= _speed_delta
                        if (_speed < 0):
                            _speed = 0
                            
                # If input in front then speeding up.
                elif (event.position.x > _origin_x):
                    if (event.position.y > _origin_y - _height):
                        _speed += _speed_delta
                        if (_speed > _max_speed):
                            _speed = _max_speed
                            
                # If input above then jumping.
                # Jump height depends on height of input.
                elif (event.position.y < _origin_y - _height):
                    _jumping = true
                    _jump_height = (_origin_y - _height) - event.position.y
                    if (_jump_height > _max_jump_height):
                        _jump_height = _max_jump_height
                    _jump_dir = 0
                    _jump_y = 0
        else:
        
            # Remove colliding obstacle and restart game.
            get_parent().remove_child(_obstacle)
            reset()

# Update jumper.
func _process(delta):

    # Scale to game speed.
    speed = _speed * delta
    
    # Do the action.
    if (_jumping):

        # Jumping.        
        # Going up?
        if (_jump_dir == 0):
            _current_frame = _jumping_up_frame
            _jump_y += _jump_speed * delta

            # Starting down?
            if (_jump_y >= _jump_height):
                _jump_y = _jump_height
                _jump_dir = 1
        else:
             # Going down.
            _current_frame = _jumping_down_frame
            _jump_y -= _jump_speed * delta
            
            # Landed?
            if (_jump_y <= 0):
                _jumping = false
                _jump_y = 0

    else:

        if (speed == 0):
            # Standing still.
            _current_frame = _standing_frame
        else:
            # Running.
            _current_frame = _running_current_frame
            _frame_advance_counter += speed
            if (_frame_advance_counter >= _frame_advance_threshold):
                _frame_advance_counter = 0
                _running_current_frame += 1
                if (_running_current_frame > _running_last_frame):
                    _running_current_frame = _running_first_frame

    var p = get_global_position()
    p = Vector2(p.x, _origin_y - _jump_y)
    set_global_position(p)
    var s = get_node("Sprite")
    s.set_frame(_current_frame)

# Collision.
func _on_body_entered(other):
    if(other.is_in_group("obstacle")):
        speed = 0
        _speed = 0
        set_process(false)
        other.hit_by_jumper()
        _obstacle = other
        _active = false
