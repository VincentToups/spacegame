extends KinematicBody2D

var Bullet = load("Bullet.tscn");

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var thrust = 100.0;
export var drag = 1;
export var max_s = 300;
export var stopping_rate = 100;
export var hull = 10;
export var energy = 10;
export var max_hull = 10;
export var max_energy = 100;
export var energy_regen_rate = 10;
export var shoot_cost = 10;
export var thrust_energy_rate = 11;
export var shield_energy_rate = 11;
export var shield_tt_up = 1.0;
export var parry_duration = 0.25;

var parry_active = false;
var since_parry_start = 10000;

var is_thrusting = false;
var is_turning = false;
var can_shoot = true;
var since_shot = 0.0;
var is_shooting = false;
var is_stopping = false;
var is_shielding = false;
var shields_up = false;
var since_shield = 0;
export var fire_dead_time = 0.1;

var vel = Vector2(0,0);

# Called when the node enters the scene tree for the first time.
func _ready():
	$Shield.modulate = Color(1,1,1,0.5);
	$Shield.visible = false;
	$Parry.visible = false;
	$Shield/AnimationPlayer.stop(true);
	pass # Replace with function body.

func _process(delta):
	var thrust_cost = thrust_energy_rate*delta;
	var shield_cost = shield_energy_rate*delta;
	
	if is_thrusting and thrust_cost <= energy:
		var r = self.rotation - PI/2;
		var td = Vector2(cos(r),sin(r));
		self.vel = self.vel + thrust*td*delta;
		$Thrust.visible = true;
		$Particles2D.emitting = true;
		$Particles2D2.emitting = true;
		energy -= thrust_cost;
	else:
		self.vel = self.vel*drag;
		$Thrust.visible = false;
		$Particles2D.emitting = false;
		$Particles2D2.emitting = false;
		
	if vel.length() > max_s:
		vel = vel.normalized()*max_s;
		
	if is_shielding and shield_cost <= energy:
		$Shield.visible = true;
		energy -= shield_cost;
		if shields_up == false:
			$Shield/AnimationPlayer.seek(0.0,true)
			$Shield/AnimationPlayer.play("up");
		shields_up = true;
		since_shield += delta;
	else:
		$Shield.visible = false;
		$Shield/AnimationPlayer.stop(true);
		shields_up = false;
		since_shield = 0;
	
	if parry_active and since_parry_start >= parry_duration:
		parry_active = false;
		$Parry.visible = false;
		
	since_parry_start += delta;
			
	since_shot = since_shot + delta;
	can_shoot = since_shot > fire_dead_time and energy >= shoot_cost;
	if is_shooting and can_shoot:
		var r = self.rotation - PI/2;
		var b = Bullet.instance().init(100*Vector2(cos(r),sin(r)) + vel);
		b.position = self.position;
		since_shot = 0;
		var p = get_parent();
		p.add_child(b);
		energy -= shoot_cost;
		
	
	if is_stopping and thrust_cost <= energy:
		var brake_v = vel.rotated(PI).normalized();
		vel = vel + brake_v * stopping_rate*delta;
		if vel.normalized() == brake_v:
			vel = Vector2(0,0);
		energy -= thrust_cost;
	
	self.energy = self.energy + self.energy_regen_rate*delta;
	if self.energy > self.max_energy:
		self.energy = self.max_energy;
	
	self.position = self.position + self.vel*delta;
	
	match is_turning:
		"left": self.rotation = self.rotation + PI/32;
		"right": self.rotation = self.rotation - PI/32;
		
	is_thrusting = false;
	is_turning = false;
	is_shooting = false;
	is_stopping = false;
	is_shielding = false;
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_shield_up_animation_finished(anim_name):
	parry_active = true;
	since_parry_start = 0;
	$Parry.visible = true;
	pass # Replace with function body.
