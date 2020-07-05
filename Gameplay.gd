extends Node2D

var Ship = load("Ship.tscn");
var BasicAI = load("BasicAI.tscn");

var Status = load("Status.tscn");
var player = Ship.instance();

var enemy = Ship.instance();
var enemyAI = BasicAI.instance().init(enemy, player);

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
	enemy.position = Vector2(100,100);
	add_child(player);
	$Player_status.ship = player;
	$Enemy_status.ship = enemy;
	add_child(enemyAI);
	add_child(enemy);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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
	if Input.is_action_pressed("shield"):
		player.is_shielding = true;
	if player.position.x < 0:
		player.position.x = player.position.x + width;
	if player.position.x >= width:
		player.position.x = player.position.x - width;
	if player.position.y < 0:
		player.position.y = player.position.y + height;
	if player.position.y >= height:
		player.position.y = player.position.y - height;
		
	if enemy.position.x < 0:
		enemy.position.x = enemy.position.x + width;
	if enemy.position.x >= width:
		enemy.position.x = enemy.position.x - width;
	if enemy.position.y < 0:
		enemy.position.y = enemy.position.y + height;
	if enemy.position.y >= height:
		enemy.position.y = enemy.position.y - height;
#	pass
