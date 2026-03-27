extends Node2D

# Created File

#Branched Fork

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_instrument(0, 2)
	
	play_note(60)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_instrument(channel, instrument):
	var midi_event = InputEventMIDI.new()
	midi_event.channel = 0
	midi_event.message = MIDI_MESSAGE_PROGRAM_CHANGE
	midi_event.instrument = instrument
	$MidiPlayer.receive_raw_midi_message(midi_event)

func play_note(note):
	var m = InputEventMIDI.new()
	m.message = MIDI_MESSAGE_NOTE_ON
	m.pitch = note
	m.velocity = 100
	m.channel = 0		
	$MidiPlayer.receive_raw_midi_message(m)	
