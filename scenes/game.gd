extends Node2D

# Sounds.
var _gallop_sound_file = "res://assets/sounds/galloping.wav"
var _boing_sound_file = "res://assets/sounds/boing.wav"
var _whinny_sound_file = "res://assets/sounds/whinny.wav"
var gallop_sound
var boing_sound
var whinny_sound

func _ready():
    # Load sounds.
    gallop_sound = AudioStreamPlayer.new()
    self.add_child(gallop_sound)
    gallop_sound.stream = load(_gallop_sound_file)
    boing_sound = AudioStreamPlayer.new()
    self.add_child(boing_sound)
    boing_sound.stream = load(_boing_sound_file)
    whinny_sound = AudioStreamPlayer.new()
    self.add_child(whinny_sound)
    whinny_sound.stream = load(_whinny_sound_file)
