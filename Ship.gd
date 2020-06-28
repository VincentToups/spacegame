extends KinematicBody2D

var Bullet = load("Bullet.tscn");

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var thrust = 100.0;
export var thrust_cost = 1.0;
export var drag = 1;
export var max_s = 7000;
export var hull = 10;
export var energy = 10;
export var max_hull = 10;
export var max_energy = 10;
var is_thrusting = false;
var is_turning = false;
var can_shoot = true;
var since_shot = 0.0;
var is_shooting = false;
export var fire_dead_time = 0.1;

var vel = Vector2(0,0);

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func _process(delta):
	if is_thrusting:
		var r = self.rotation - PI/2;
		var td = Vector2(cos(r),sin(r));
		self.vel = self.vel + thrust*td*delta;
		$Thrust.visible = true;
		$Particles2D.emitting = true;
		$Particles2D2.emitting = true;
	else:
		self.vel = self.vel*drag;
		self.vel = self.vel.clamped(max_s);
		$Thrust.visible = false;
		$Particles2D.emitting = false;
		$Particles2D2.emitting = false;
		
	since_shot = since_shot + delta;
	can_shoot = since_shot > fire_dead_time;
	if is_shooting and can_shoot:
		var r = self.rotation - PI/2;
		var b = Bullet.instance().init(100*Vector2(cos(r),sin(r)) + vel);
		b.position = self.position;
		since_shot = 0;
		var p = get_parent();
		print(p);
		p.add_child(b);
		print(b);
		
	
	
	self.position = self.position + self.vel*delta;
	
	match is_turning:
		"left": self.rotation = self.rotation + PI/32;
		"right": self.rotation = self.rotation - PI/32;
		var other_value: false
		
	is_thrusting = false;
	is_turning = false;
	is_shooting = false;
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
