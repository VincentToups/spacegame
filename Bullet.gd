extends KinematicBody2D

var vel = Vector2(0,0)
var age = 0;
var max_age = 2;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func init(ivel,imax_age=2):
	vel = ivel;
	max_age = imax_age;
	return self;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	age = age + delta;
	position = position + vel*delta;
	if age > max_age:
		queue_free();
