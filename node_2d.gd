extends Node2D


var note = 0
var pattern = [[],[],[]]
var iteration = 0
var replaying_active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_instrument(0, 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Replay_Current.button_pressed:
		replaying_active = true
		if len(pattern[iteration]) == 0:
			play_note(1)
		else:
			for n in range(len(pattern[iteration])):
				play_note(pattern[iteration][n])
				await get_tree().create_timer(0.5).timeout
		
		replaying_active = false
		
	if $"Save Track 1".button_pressed:
		iteration += 1
	
	if $"Play Track 1".button_pressed:
		replaying_active = true
		if len(pattern[0]) == 0:
			play_note(1)
		else:
			for n in range(len(pattern[0])):
				play_note(pattern[0][n])
				await get_tree().create_timer(0.5).timeout
		
		replaying_active = false
	
	if $"Save Track 2".button_pressed:
		iteration += 1
	
	if $"Play Track 2".button_pressed:
		replaying_active = true
		if len(pattern[1]) == 0:
			play_note(1)
		else:
			for n in range(len(pattern[1])):
				play_note(pattern[1][n])
				await get_tree().create_timer(0.5).timeout
		
		replaying_active = false
	
	if $"Save Track 3".button_pressed:
		iteration += 1
	
	if $"Play Track 3".button_pressed:
		replaying_active = true
		if len(pattern[2]) == 0:
			play_note(1)
		else:
			for n in range(len(pattern[2])):
				play_note(pattern[2][n])
				await get_tree().create_timer(0.5).timeout
		
		replaying_active = false
		

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

# retrieve note value based on input
func _input(event):
	if replaying_active:
		return

	if Input.is_key_pressed(KEY_A):
		note = 52
		playing(note)
	elif Input.is_key_pressed(KEY_S):
		note = 53
		playing(note)
	elif Input.is_key_pressed(KEY_E):
		note = 54
		playing(note)
	elif Input.is_key_pressed(KEY_D):
		note = 55
		playing(note)
	elif Input.is_key_pressed(KEY_R):
		note = 56
		playing(note)
	elif Input.is_key_pressed(KEY_F):
		note = 57
		playing(note)
	elif Input.is_key_pressed(KEY_T):
		note = 58
		playing(note)
	elif Input.is_key_pressed(KEY_G):
		note = 59
		playing(note)
	elif Input.is_key_pressed(KEY_H):
		note = 60
		playing(note)
	elif Input.is_key_pressed(KEY_U):
		note = 61
		playing(note)
	elif Input.is_key_pressed(KEY_J):
		note = 62
		playing(note)
	elif Input.is_key_pressed(KEY_I):
		note = 63
		playing(note)
	elif Input.is_key_pressed(KEY_K):
		note = 64
		playing(note)
	elif Input.is_key_pressed(KEY_L):
		note = 65
		playing(note)
	elif Input.is_key_pressed(KEY_P):
		note = 66
		playing(note)
	elif Input.is_key_pressed(KEY_SEMICOLON):
		note = 67
		playing(note)

# main function for saving patterns and playing notes
func playing(note):
	if replaying_active == false:
		pattern[iteration].append(note)
		
		play_note(note)
