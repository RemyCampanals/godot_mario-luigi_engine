extends Sprite3D

onready var animation: AnimationPlayer = $AnimationPlayer;

func _ready():
	animation.play("Loop");
