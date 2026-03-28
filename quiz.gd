extends Node2D

var height = 648
var width = 1152

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $Exit.button_pressed:
		get_tree().change_scene_to_file("res://main_menu.tscn")

func _draw() -> void:
	draw_rect(Rect2(0,0,width,height), Color.SKY_BLUE)
	
	var key_width = float(width) / 10
	var piano_height = float(height) / 2
	
	draw_rect(Rect2(0, piano_height, width, piano_height), Color.WHITE)
	
	# white keys
	for key in range(10):
		var x = key_width * key
		draw_line(Vector2(x, piano_height), Vector2(x, height), Color.BLACK)

	
	# black keys
	draw_rect(Rect2(1.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.BLACK)
	draw_rect(Rect2(2.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.BLACK)
	draw_rect(Rect2(3.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.BLACK)
	draw_rect(Rect2(5.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.BLACK)
	draw_rect(Rect2(6.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.BLACK)
	draw_rect(Rect2(8.75 * key_width, piano_height, key_width * 0.5, piano_height * 0.5), Color.BLACK)

	

	# looks weird so adding 2 keys to make it look more like a piano
	draw_rect(Rect2(0 * key_width, piano_height, key_width * 0.25, piano_height * 0.5), Color.BLACK)
	draw_rect(Rect2(9.75 * key_width, piano_height, key_width * 0.25, piano_height * 0.5), Color.BLACK)
