extends Node2D

# Created File

# Branched Fork

var note = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_instrument(0, 2)
	

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# setting instrument as Piano
func set_instrument(channel, instrument):
	var midi_event = InputEventMIDI.new()
	midi_event.channel = 0
	midi_event.message = MIDI_MESSAGE_PROGRAM_CHANGE
	midi_event.instrument = instrument
	$MidiPlayer.receive_raw_midi_message(midi_event)

# note playing function
func play_note(note):
	var m = InputEventMIDI.new()
	m.message = MIDI_MESSAGE_NOTE_ON
	m.pitch = note
	m.velocity = 100
	m.channel = 0		
	$MidiPlayer.receive_raw_midi_message(m)	

func _input(event):
	if Input.is_key_pressed(KEY_A):
		note = 52
	elif Input.is_key_pressed(KEY_S):
		note = 53
	elif Input.is_key_pressed(KEY_E):
		note = 54
	elif Input.is_key_pressed(KEY_D):
		note = 55
	elif Input.is_key_pressed(KEY_R):
		note = 56
	elif Input.is_key_pressed(KEY_F):
		note = 57
	elif Input.is_key_pressed(KEY_T):
		note = 58
	elif Input.is_key_pressed(KEY_G):
		note = 59
	elif Input.is_key_pressed(KEY_H):
		note = 60
	elif Input.is_key_pressed(KEY_U):
		note = 61
	elif Input.is_key_pressed(KEY_J):
		note = 62
	elif Input.is_key_pressed(KEY_I):
		note = 63
	elif Input.is_key_pressed(KEY_K):
		note = 64
	elif Input.is_key_pressed(KEY_L):
		note = 65
	elif Input.is_key_pressed(KEY_P):
		note = 66
	elif Input.is_key_pressed(KEY_SEMICOLON):
		note = 67
	
	print(note)
