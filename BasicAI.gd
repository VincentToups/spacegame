extends Node2D

var Ship = load("Ship.tscn")

var ship : KinematicBody2D = null;
var target_ship : KinematicBody2D = null;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func init(self_ship, enemy_ship):
	ship = self_ship;
	target_ship = enemy_ship;
	return self;


var state = "approach";


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func adjust_heading_towards(s,delta,lead):
	var lp = s.position + s.vel*delta*lead;
	var d = ship.position - lp;
	var tr = d.angle();
	if tr >= 2*PI:
		tr -= 2*PI;
	if tr < 0:
		tr += 2*PI;
	var r = ship.rotation + PI/2;
	if r >= 2*PI:
		r -= 2*PI;
	if r < 0:
		r += 2*PI;
	var dd = abs(r-tr);
	if dd > PI/30:
		if r < tr:
			ship.is_turning = "left"
		else:
			ship.is_turning = "right";
	return abs(r - tr);
	

func _process_approach(delta):
	var dh = adjust_heading_towards(target_ship, delta, 0);
	if dh < PI/4:
		ship.is_thrusting = true;
		ship.is_shooting = true;
	else:
		ship.is_stopping = true;
	if ship.energy <= ship.max_energy*0.1:
		state = "recharging";
		
func _process_recharging(_delta):
	if ship.energy > ship.max_energy*0.66:
		state = "approach";
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		"approach":
			_process_approach(delta);
		"recharging":
			_process_recharging(delta);
		var _otherwise:
			pass
