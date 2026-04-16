extends Node2D

var height = 648
var width = 1152

var score = 0
var started = false

var notes = [52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67]
var white_keys = [false, false, false, false, false, false, false, false, false, false, false]
var black_keys = [false, false, false, false, false, false]
var white_notes = [52,53,55,57,59,60,62,64,65,67]
var black_notes = [54,56,58,61,63,66]

var pattern = []
var pattern_length = []
var response = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	set_instrument(0,2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $Exit.button_pressed:
		get_tree().change_scene_to_file("res://main_menu.tscn")
		
	if $Infinite.button_pressed and not started:
		started = true
		$Gamemode.text = 'Gamemode: Infinite'
	
	if $Easy.button_pressed and not started:
		started = true
		pattern = []
		pattern_length = 5
		$Gamemode.text = 'Gamemode: Easy'
		$Score.text = str('Score: ', score)
		playing()
	
	if $Medium.button_pressed and not started:
		started = true
		pattern = []
		pattern_length = 10
		$Gamemode.text = 'Gamemode: Medium'
		$Score.text = str('Score: ', score)
		playing()
	
	if $Hard.button_pressed and not started:
		started = true
		pattern = []
		pattern_length = 15
		$Gamemode.text = 'Gamemode: Hard'
		$Score.text = str('Score: ', score)
		playing()

func set_instrument(channel, instrument):
	var midi_event = InputEventMIDI.new()
	midi_event.channel = 0
	midi_event.message = MIDI_MESSAGE_PROGRAM_CHANGE
	midi_event.instrument = instrument
	$MidiPlayer.receive_raw_midi_message(midi_event)
	
func _draw() -> void:
	draw_rect(Rect2(0,0,width,height), Color.SKY_BLUE)
	
	var key_width = float(width) / 10
	var piano_height = float(height) / 2
	
	draw_rect(Rect2(0, piano_height, width, piano_height), Color.WHITE)
	
	# white keys
	for key in range(10):
		var x = key_width * key
		draw_line(Vector2(x, piano_height), Vector2(x, height), Color.BLACK)

		if white_keys[key]:
			draw_rect(Rect2(x, piano_height, key_width, piano_height), Color.DIM_GRAY)
	
	# black keys
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



func playing():
	for x in pattern_length:
		var index = randi_range(0,15)
		pattern.append(notes[index])
	
	for note in pattern:
		active_key(note)
		play_note(note)
		await get_tree().create_timer(0.3).timeout
		play_note_off(note)
		await get_tree().create_timer(0.5).timeout
		
	started = false


func play_note(pitch):
	var m = InputEventMIDI.new()
	m.message = MIDI_MESSAGE_NOTE_ON
	m.pitch = pitch
	m.velocity = 100
	m.channel = 0		
	$MidiPlayer.receive_raw_midi_message(m)	
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
	
# function to find key which is playing played and mark it as active
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



func _input(event):
	var note = 0
	if started:
		return

	if event is InputEventKey:
		if event.is_pressed() and not event.is_echo():
			note = key_to_note(event.keycode)
			if note != 0:
				play_note(note)
		
		elif event.is_released():
			play_note_off(note)
			
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
