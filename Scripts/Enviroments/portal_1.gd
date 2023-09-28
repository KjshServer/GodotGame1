extends Node2D

var portal_two

@export var portal_group:int = 1
var is_portal_two:bool = true

func _ready():
	var portals = get_tree().get_nodes_in_group("portal")
	for i in range (portals.size()):
		if portals[i].position != position:
			if portals[i].portal_group == self.portal_group:
				portal_two = portals[i]

func _on_area_teletransport_area_entered(area):
	if area.get_parent().is_in_group("player") and is_portal_two:
		area.get_parent().position = portal_two.position
		portal_two.is_portal_two = false

func _on_area_teletransport_area_exited(_area):
	portal_two.is_portal_two = true
