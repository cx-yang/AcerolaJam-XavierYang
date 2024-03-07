extends ParallaxLayer

@onready var sprite_2d = $Sprite2D

@export var texture: Texture
@export var scroll_scale: float = 0.0
@export var tx_x: float = 1280.0
@export var tx_y: float = 720.0


func _ready():
	motion_scale.y = scroll_scale
	var scale_f =  get_viewport_rect().size.y / tx_y
	sprite_2d.texture = texture
	sprite_2d.scale = Vector2(scale_f, scale_f)
	motion_mirroring.y = tx_y * scale_f * 1
