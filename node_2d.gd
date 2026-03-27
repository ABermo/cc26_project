extends Node2D


var note = 0
var pattern = [[],[],[],[]]
var iteration = 3
var replaying_active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_instrument(0, 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Replay_Current.button_pressed:
		if len(pattern[3]) == 0:
			play_note(1)
			await get_tree().create_timer(0.3).timeout
			play_note_off(1)
		else:
			replay(pattern[3])
		
	if $"Save Track 1".button_pressed:
		pattern[0] = pattern[3]
	
	if $"Play Track 1".button_pressed:
		if len(pattern[0]) == 0:
			play_note(1)
			await get_tree().create_timer(0.3).timeout
			play_note_off(1)
		else:
			replay(pattern[0])
	
	if $"Save Track 2".button_pressed:
		pattern[1] = pattern[3]
	
	if $"Play Track 2".button_pressed:
		if len(pattern[1]) == 0:
			play_note(1)
			await get_tree().create_timer(0.3).timeout
			play_note_off(1)
		else:
			replay(pattern[1])
	
	if $"Save Track 3".button_pressed:
		pattern[2] = pattern[3]
	
	if $"Play Track 3".button_pressed:
		if len(pattern[2]) == 0:
			play_note(1)
			await get_tree().create_timer(0.3).timeout
			play_note_off(1)
		else:
			replay(pattern[2])
		

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

# stop playing note
func play_note_off(note):
	var m = InputEventMIDI.new()
	m.message = MIDI_MESSAGE_NOTE_ON
	m.pitch = note
	m.velocity = 0
	m.channel = 0		
	$MidiPlayer.receive_raw_midi_message(m)	

# retrieve note value based on input
func _input(event):
	if replaying_active:
		return

	if event is InputEventKey:
		if event.is_pressed() and not event.is_echo():
			note = key_to_note(event.keycode)
			if note != 0:
				playing(note)
				play_note(note)
		
		elif event.is_released():
			play_note_off(note)


# main function for saving patterns and playing notes
func playing(note):
	if replaying_active == false:
		pattern[iteration].append(note)
		
		play_note(note)

func key_to_note(key):
	match key:
		KEY_A: return 52
		KEY_S: return 53
		KEY_E: return 54
		KEY_D: return 55
		KEY_R: return 56
		KEY_F: return 57
		KEY_T: return 58
		KEY_G: return 59
		KEY_H: return 60
		KEY_U: return 61
		KEY_J: return 62
		KEY_I: return 63
		KEY_K: return 64
		KEY_L: return 65
		KEY_P: return 66
		KEY_SEMICOLON: return 67
		_: return null

# replay function
func replay(pattern):
	replaying_active = true

	for n in range(len(pattern)):
		play_note(pattern[n])
		await get_tree().create_timer(0.2).timeout
		play_note_off(pattern[n])
		await get_tree().create_timer(0.1).timeout
		
	replaying_active = false
