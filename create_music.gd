extends Node2D


var note = 0
var pattern = [[],[],[],[]]
var iteration = 3
var replaying_active = false

const WHITE_KEYS_NUM = 10
const BLACK_KEYS_NUM = 6

# used for what keys are 'active'
var white_keys = [false, false, false, false, false, false, false, false, false, false, false]
var black_keys = [false, false, false, false, false, false]

# used for drawing piano
var width = 1152
var height = 648


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_instrument(0, 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_float) -> void:
	if $Replay_Current.button_pressed:
		if len(pattern[3]) == 0:
			play_note(1)
			await get_tree().create_timer(0.3).timeout
			play_note_off(1)
		else:
			replay(pattern[3])
		
	if $"Save Track 1".button_pressed:
		if len(pattern[3]) != 0:
			pattern[0] = pattern[3].duplicate()
			pattern[3].clear()

	
	if $"Play Track 1".button_pressed:
		if len(pattern[0]) == 0:
			play_note(1)
			await get_tree().create_timer(0.3).timeout
			play_note_off(1)
		else:
			replay(pattern[0])
	
	if $"Save Track 2".button_pressed:
		if len(pattern[3]) != 0:
			pattern[1] = pattern[3].duplicate()
			pattern[3].clear()
	
	if $"Play Track 2".button_pressed:
		if len(pattern[1]) == 0:
			play_note(1)
			await get_tree().create_timer(0.3).timeout
			play_note_off(1)
		else:
			replay(pattern[1])
	
	if $"Save Track 3".button_pressed:
		if len(pattern[3]) != 0:
			pattern[2] = pattern[3].duplicate()
			pattern[3].clear()
		
	if $"Play Track 3".button_pressed:
		if len(pattern[2]) == 0:
			play_note(1)
			await get_tree().create_timer(0.3).timeout
			play_note_off(1)
		else:
			replay(pattern[2])
	
	
	if $Exit.button_pressed:
		get_tree().change_scene_to_file("res://main_menu.tscn")

# setting instrument as Piano
func set_instrument(channel, instrument):
	var midi_event = InputEventMIDI.new()
	midi_event.channel = 0
	midi_event.message = MIDI_MESSAGE_PROGRAM_CHANGE
	midi_event.instrument = instrument
	$MidiPlayer.receive_raw_midi_message(midi_event)

# note playing function
func play_note(pitch):
	var m = InputEventMIDI.new()
	m.message = MIDI_MESSAGE_NOTE_ON
	m.pitch = pitch
	m.velocity = 100
	m.channel = 0		
	$MidiPlayer.receive_raw_midi_message(m)	
	active_key(pitch)
	queue_redraw()

# stop playing note
func play_note_off(pitch):
	var m = InputEventMIDI.new()
	m.message = MIDI_MESSAGE_NOTE_ON
	m.pitch = pitch
	m.velocity = 0
	m.channel = 0		
	$MidiPlayer.receive_raw_midi_message(m)	
	white_keys = [false, false, false, false, false, false, false, false, false, false]
	black_keys = [false, false, false, false, false, false]
	queue_redraw()

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
func playing(pitch):
	if replaying_active == false:
		pattern[iteration].append(pitch)
		
		play_note(pitch)

func key_to_note(key):
	match key:
		KEY_A: 
			white_keys[0] = true
			return 52
		KEY_S: 
			white_keys[1] = true
			return 53
		KEY_E: 
			black_keys[0] = true
			return 54
		KEY_D: 
			white_keys[2] = true
			return 55
		KEY_R: 
			black_keys[1] = true
			return 56
		KEY_F: 
			white_keys[3] = true
			return 57
		KEY_T: 
			black_keys[2] = true
			return 58
		KEY_G: 
			white_keys[4] = true
			return 59
		KEY_H: 
			white_keys[5] = true
			return 60
		KEY_U: 
			black_keys[3] = true
			return 61
		KEY_J: 
			white_keys[6] = true
			return 62
		KEY_I: 
			black_keys[4] = true
			return 63
		KEY_K: 
			white_keys[7] = true
			return 64
		KEY_L: 
			white_keys[8] = true
			return 65
		KEY_P: 
			black_keys[5] = true
			return 66
		KEY_SEMICOLON: 
			white_keys[9] = true
			return 67
		_: return 0


func active_key(key):
	match key:
		52: white_keys[0] = true
		53: white_keys[1] = true
		54: black_keys[0] = true
		55: white_keys[2] = true
		56: black_keys[1] = true
		57: white_keys[3] = true
		58: black_keys[2] = true
		59: white_keys[4] = true
		60: white_keys[5] = true
		61: black_keys[3] = true
		62: white_keys[6] = true
		63: black_keys[4] = true
		64: white_keys[7] = true
		65: white_keys[8] = true
		66: black_keys[5] = true
		67: white_keys[9] = true

# replay function
func replay(sequence):
	replaying_active = true

	for n in range(len(sequence)):
		play_note(sequence[n])
		await get_tree().create_timer(0.2).timeout
		play_note_off(sequence[n])
		await get_tree().create_timer(0.1).timeout
		
	replaying_active = false

# drawing piano
func _draw() -> void:
	draw_rect(Rect2(0,0,width,height), Color.SKY_BLUE)
	
	var key_width = float(width) / WHITE_KEYS_NUM
	var piano_height = float(height) / 2
	
	draw_rect(Rect2(0, piano_height, width, piano_height), Color.WHITE)
	
	# white keys
	for key in range(WHITE_KEYS_NUM):
		var x = key_width * key
		draw_line(Vector2(x, piano_height), Vector2(x, height), Color.BLACK)
		
		if white_keys[key]:
			draw_rect(Rect2(x, piano_height, key_width, piano_height), Color.DIM_GRAY)

	
	# black keys
	draw_rect(Rect2(1.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.BLACK)
	draw_rect(Rect2(2.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.BLACK)
	draw_rect(Rect2(3.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.BLACK)
	draw_rect(Rect2(5.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.BLACK)
	draw_rect(Rect2(6.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.BLACK)
	draw_rect(Rect2(8.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.BLACK)

	if black_keys[0]:
		draw_rect(Rect2(1.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.DIM_GRAY)
	else:
		draw_rect(Rect2(1.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.BLACK)
	if black_keys[1]:
		draw_rect(Rect2(2.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.DIM_GRAY)
	else:
		draw_rect(Rect2(2.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.BLACK)
	if black_keys[2]:
		draw_rect(Rect2(3.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.DIM_GRAY)
	else:
		draw_rect(Rect2(3.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.BLACK)
	if black_keys[3]:
		draw_rect(Rect2(5.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.DIM_GRAY)
	else:
		draw_rect(Rect2(5.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.BLACK)
	if black_keys[4]:
		draw_rect(Rect2(6.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.DIM_GRAY)
	else:
		draw_rect(Rect2(6.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.BLACK)
	if black_keys[5]:
		draw_rect(Rect2(8.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.DIM_GRAY)
	else:
		draw_rect(Rect2(8.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.BLACK)

	# looks weird so adding 2 keys to make it look more like a piano
	draw_rect(Rect2(0 * key_width, piano_height, key_width * 0.25, piano_height * 0.5), Color.BLACK)
	draw_rect(Rect2(9.75 * key_width, piano_height, key_width * 0.25, piano_height * 0.5), Color.BLACK)
