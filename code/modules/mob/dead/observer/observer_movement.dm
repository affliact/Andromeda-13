/mob/dead/observer/down()
	set name = "Двигаться вниз"
	set category = "IC"

	if(zMove(DOWN, z_move_flags = ZMOVE_FEEDBACK))
		to_chat(src, span_notice("Ты двигаешься вниз."))

/mob/dead/observer/up()
	set name = "Двигаться вверх"
	set category = "IC"

	if(zMove(UP, z_move_flags = ZMOVE_FEEDBACK))
		to_chat(src, span_notice("Ты двигаешься вверх."))

/mob/dead/observer/can_z_move(direction, turf/start, turf/destination, z_move_flags = NONE, mob/living/rider)
	z_move_flags |= ZMOVE_IGNORE_OBSTACLES  //observers do not respect these FLOORS you speak so much of.
	return ..()
