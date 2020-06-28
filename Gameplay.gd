extends Node2D

var Ship = load("Ship.tscn");
var Status = load("Status.tscn");
var player = Ship.instance();
export var width : int = 512
export var height : int = 300

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	width = get_viewport().get_rect().size.x;
#	height = get_viewport().get_rect().size.y;
	player.position = Vector2(200,200);
	add_child(player);
	$Player_status.ship = player;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("rotate_down"):
		player.is_turning = "right"
	if Input.is_action_pressed("rotate_up"):
		player.is_turning = "left";
	if Input.is_action_pressed("thrust"):
		player.is_thrusting = true;
	if Input.is_action_pressed("shoot"):
		player.is_shooting = true;
	if Input.is_action_pressed("dead_stop"):
		player.is_stopping = true;
	if player.position.x < 0:
		player.position.x = player.position.x + width;
	if player.position.x >= width:
		player.position.x = player.position.x - width;
	if player.position.y < 0:
		player.position.y = player.position.y + height;
	if player.position.y >= height:
		player.position.y = player.position.y - height;
#	pass
