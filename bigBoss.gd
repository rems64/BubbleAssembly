extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_cliqued() -> void:
	get_tree().change_scene_to_file("res://level01.tscn")

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
