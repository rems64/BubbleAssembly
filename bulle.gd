extends RigidBody2D

signal clicked
@onready var collisionBox = $CollisionShape2D
@onready var apparence = $AnimatedSprite2D

@onready var voisinHaut = null
@onready var voisinBas = null
@onready var voisinGauche = null
@onready var voisinDroite = null
#@onready var contactHaut = false
#@onready var contactBas = false
#@onready var contactDroite = false
#@onready var contactGauche = false

@onready var len_bulle = apparence.get_sprite_frames().get_frame_texture("bulle", 0).get_size().x
@onready var held = false

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position.x = get_parent().global_position.x + 2*len_bulle
	global_position.y = get_parent().global_position.y + 3*len_bulle
	#modulate = Color(191, 222, 255)
	#modulate = Color(1, 1, 1, 255)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton  and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed : 
			clicked.emit(self)

func _physics_process(delta):
	#//reinitialize les voisins
	if voisinHaut != null : _on_bulle_exited(voisinHaut)
	if voisinBas != null : _on_bulle_exited(voisinBas)
	if voisinGauche != null : _on_bulle_exited(voisinGauche)
	if voisinDroite != null : _on_bulle_exited(voisinDroite)
		#global_transform.origin = round(get_global_mouse_position())
	
	#//déplace la bubulle comme on le veut
	if held : 
		global_position = round(get_global_mouse_position())
		#collision = move_and_collide(round(get_global_mouse_position())-global_position)
	
	#//recalcule des voisins
	var collision = get_colliding_bodies()
	if collision != [] :
		if held :
			global_position = round(get_global_mouse_position())
		for bulle in collision :
			#_on_bulle_collisioned(collision.get_collider())
			_on_bulle_collisioned(bulle)
			
	else :
		pass
#	update l'affichage
	contact()

func pickup():
	if held:
		return
	freeze = true
	held = true
	
func drop(impulse=Vector2.ZERO) :
	if held :
		#freeze = false
		apply_central_impulse(impulse)
		var collision = get_colliding_bodies()
		if collision != [] :
			print(collision)
			 #handle the rightful placement
			var me_x = global_position.x
			var me_y = global_position.y
			var min_dist = +INF
			var proche_bulle
			
			#cherche la bulle voisine la plus proche
			for bulle in collision :
				#var bulle = collider
				var bulle_x = bulle.global_position.x
				var bulle_y = bulle.global_position.y
				var dist = sqrt((bulle_x - me_x)**2 + (bulle_y - me_y)**2)
				
				if dist < min_dist :
					min_dist = dist
					proche_bulle = bulle
				
			#place l'objet en fonction de la bulle voisine la plus proche
			var bulle_x = proche_bulle.global_position.x
			var bulle_y = proche_bulle.global_position.y
			var diff_x = me_x - bulle_x
			var diff_y = me_y - bulle_y
			if abs(diff_x) > abs(diff_y) : #si la bulle est plus à ma gauche/droite qu'en haut/bas :
				global_position.y = bulle_y
				if diff_x < 0 : #la bulle est à ma droite
					global_position.x = bulle_x - 2*len_bulle-5
				else : global_position.x = bulle_x + 2*len_bulle+5
			else :
				global_position.x = bulle_x
				if diff_y < 0 : #la bulle est en-dessous de moi
					global_position.y = bulle_y - 2*len_bulle-5
				else : global_position.y = bulle_y + 2*len_bulle+5
			
		held = false



func _on_animation_changed():
	var apparence_size = apparence.get_sprite_frames().get_frame_texture(apparence.animation, 0).get_size()
	#print(new_rect)
	apparence.offset.x = 0; apparence.offset.y = 0;
	var contactHaut = voisinHaut != null
	var contactBas = voisinBas != null
	if (apparence_size.x < len_bulle) :
		var contactGauche = voisinGauche != null
		var contactDroite = voisinDroite != null
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
	if voisinHaut!=null : anim_name += " haut"
	if voisinBas!=null : anim_name += " bas"
	if voisinGauche!=null : anim_name += " gauche"
	if voisinDroite!=null : anim_name += " droite"
	
	if anim_name == "coupé" : anim_name = "bulle"
	apparence.play(anim_name)


func _on_bulle_collisioned(bulle: Node):
	#if held :
		#bulle._on_bulle_collisioned(self)
	remove_from_voisin(bulle)
	var bulle_x = bulle.global_position.x
	var bulle_y = bulle.global_position.y
	var me_x = global_position.x
	var me_y = global_position.y
	
	var diff_x = me_x - bulle_x
	var diff_y = me_y - bulle_y
	if abs(diff_x) > abs(diff_y) : #si la bulle vient plutôt de gauche/droite que de haut/bas :
		if diff_x < 0 : #la bulle est à ma droite
			voisinDroite = bulle
		else : voisinGauche = bulle
	else :
		if diff_y < 0 : #la bulle est en-dessous de moi
			voisinBas = bulle
		else : voisinHaut = bulle


func _on_bulle_exited(bulle: Node) -> void:
	#if held :
		#bulle._on_bulle_exited(self)
	remove_from_voisin(bulle)

func remove_from_voisin(bulle : Node) :
	if voisinHaut == bulle : voisinHaut = null
	elif voisinBas == bulle : voisinBas = null
	elif voisinGauche == bulle : voisinGauche = null
	elif voisinDroite == bulle : voisinDroite = null
