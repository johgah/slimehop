extends Camera2D

func _set_limits():
	# only set the limits if custom bounds have not been set
	if limit_left == -10000000:
		limit_left = 0
	if limit_top == -10000000:
		limit_top = 0
	if limit_right == 10000000:
		limit_right = 0
	if limit_bottom == 10000000:
		limit_bottom = 0
	
	var tilemaps = get_tree().get_nodes_in_group("tilemap")
	for tilemap in tilemaps:
		var used = tilemap.get_used_rect()
		
		if limit_left == 0:
			limit_left = min(used.position.x * tilemap.tile_set.tile_size.x, limit_left)
		if limit_top == 0:
			limit_top = min(used.position.y * tilemap.tile_set.tile_size.y, limit_top)
		if limit_right == 0:
			limit_right = max(used.end.x * tilemap.tile_set.tile_size.x, limit_right)
		if limit_bottom == 0:
			limit_bottom = max(used.end.y * tilemap.tile_set.tile_size.y, limit_bottom) - 24
