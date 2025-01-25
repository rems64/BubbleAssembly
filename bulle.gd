extends RigidBody2D
@onready var collisionBox = $CollisionShape2D
@onready var apparence = $AnimatedSprite2D

@onready var contactHaut = false
@onready var contactBas = false
@onready var contactDroite = false
@onready var contactGauche = false

@onready var len_bulle = apparence.get_sprite_frames().get_frame_texture("bulle", 0).get_size().x

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@onready var i = 0
func _process(delta):
	#i += 1
	#print(held)
	if (i == 50) : 
		contactHaut = false
		contactBas = true
		contactGauche = true
		contactDroite = true
		contact()
	if (i == 100) : 
		contactHaut = false
		contactBas = false
		contactGauche = false
		contactDroite = false
		contact()
	if (i == 150) : 
		contactHaut = true
		contactBas = false
		contactGauche = true
		contactDroite = true
		contact()
	if (i == 200) : 
		contactHaut = false
		contactBas = false
		contactGauche = false
		contactDroite = false
		contact()
	if (i == 150) : 
		contactHaut = true
		contactBas = true
		contactGauche = true
		contactDroite = true
		contact()
	if (i == 200) : 
		contactHaut = true
		contactBas = true
		contactGauche = true
		contactDroite = false
		contact()
		i = 0

signal clicked
var held = false
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton  and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed : 
			clicked.emit(self)

func _physics_process(delta):
	if held :
		global_transform.origin = get_global_mouse_position()

func pickup():
	if held:
		return
	freeze = true
	held = true
	
func drop(impulse=Vector2.ZERO) :
	if held :
		#freeze = false
		apply_central_impulse(impulse)
		held = false



func _on_animation_changed():
	var apparence_size = apparence.get_sprite_frames().get_frame_texture(apparence.animation, 0).get_size()
	#print(new_rect)
	apparence.offset.x = 0; apparence.offset.y = 0;
	if (apparence_size.x < len_bulle) :
		if contactGauche && contactDroite :
			apparence.offset.x = -0.5
			if contactHaut || contactBas :
				apparence.offset.x = 0
		elif contactGauche :
			apparence.offset.x += (len_bulle - apparence_size.x)/2
		else :
			apparence.offset.x -= (len_bulle - apparence_size.x)/2
		
	if (apparence_size.y < len_bulle):
		if contactHaut && contactBas :
			apparence.offset.y = -0.5
		elif contactBas :
			apparence.offset.y -= (len_bulle - apparence_size.y)/2
		else :
			apparence.offset.y += (len_bulle - apparence_size.y)/2
		
			
		
func contact() :
	var anim_name = "coupé"
	if contactHaut : anim_name += " haut"
	if contactBas : anim_name += " bas"
	if contactGauche : anim_name += " gauche"
	if contactDroite : anim_name += " droite"
	
	if anim_name == "coupé" : anim_name = "bulle"
	print(anim_name)
	apparence.play(anim_name)
