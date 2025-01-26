extends Node2D
#@onready var child = $bulle
var held_object = null
# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_tree().get_nodes_in_group("pickable"):
		node.clicked.connect(_on_pickable_clicked)

func _on_pickable_clicked(object):
	if held_object == null:
		object.pickup()
		held_object = object

func _unhandled_input(event) :
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop(Input.get_last_mouse_velocity())
			held_object = null
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_button_pressed():
	var bulle = preload("res://bubulle.tscn").instantiate()
	#var bulle_instance = bulle.instance()
	#bulle.global_transform = child.global_transform
	bulle.global_position.x += 5
	bulle.global_position.y += 5
	bulle.visible = true
	add_child(bulle)
	bulle.clicked.connect(_on_pickable_clicked)

func dijkstra(bulleDep : Node) :
	var liste_voisins = [bulleDep]
	if bulleDep.voisinHaut != null : liste_voisins.append(bulleDep.voisinHaut)
	if bulleDep.voisinBas != null : liste_voisins.append(bulleDep.voisinBas)
	if bulleDep.voisinGauche != null : liste_voisins.append(bulleDep.voisinGauche)
	if bulleDep.voisinDroite != null : liste_voisins.append(bulleDep.voisinDroite)
	var voisins_visites = [bulleDep]
	var i = 0
	while voisins_visites.size() < liste_voisins.size() :
		i += 1
		print("_______")
		print("tour : ", i)
		#print("liste voisins : ", liste_voisins)
		#print("liste_visites : ", voisins_visites)
		var voisin = liste_voisins[voisins_visites.size()]
		if voisin.voisinHaut != null : 
			if !(voisin.voisinHaut in liste_voisins) :
				liste_voisins.append(voisin.voisinHaut)
		if voisin.voisinBas != null : 
			if !(voisin.voisinBas in liste_voisins) :
				liste_voisins.append(voisin.voisinBas)
		if voisin.voisinGauche != null : 
			if !(voisin.voisinGauche in liste_voisins) :
				liste_voisins.append(voisin.voisinGauche)
		if voisin.voisinDroite != null : 
			if !(voisin.voisinDroite in liste_voisins) :
				liste_voisins.append(voisin.voisinDroite)
		voisins_visites.append(voisin)
	liste_voisins.pop_front()
	return liste_voisins
