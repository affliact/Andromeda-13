// Singulo, tesla, and explosive delam

/// When we have too much gas.
/datum/sm_delam/singularity

/datum/sm_delam/singularity/can_select(obj/machinery/power/supermatter_crystal/sm)
	return (sm.absorbed_gasmix.total_moles() >= MOLE_PENALTY_THRESHOLD)

/datum/sm_delam/singularity/delam_progress(obj/machinery/power/supermatter_crystal/sm)
	if(!..())
		return FALSE
	sm.radio.talk_into(
		sm,
		"Предупреждение: достигнута критическая масса охлаждающей жидкости.",
		sm.damage > sm.emergency_point ? sm.emergency_channel : sm.warning_channel
	)
	return TRUE

/datum/sm_delam/singularity/delaminate(obj/machinery/power/supermatter_crystal/sm)
	message_admins("Суперматерия [sm] в [ADMIN_VERBOSEJMP(sm)] вызвала порождение сингулярности.")
	sm.investigate_log("вызвала порождение сингулярности.", INVESTIGATE_ENGINE)

	effect_irradiate(sm)
	effect_demoralize(sm)
	if(sm.is_main_engine)
		effect_anomaly(sm)
	if(!effect_singulo(sm))
		effect_explosion(sm)
	return ..()

/datum/sm_delam/singularity/filters(obj/machinery/power/supermatter_crystal/sm)
	..()

	sm.modify_filter(name = "ray", new_params = list(
		color = SUPERMATTER_SINGULARITY_RAYS_COLOUR
	))

	sm.add_filter(name = "outline", priority = 2, params = list(
		type = "outline",
		size = 1,
		color = SUPERMATTER_SINGULARITY_LIGHT_COLOUR
	))

	if(sm.final_countdown)
		sm.add_filter(name = "icon", priority = 3, params = list(
			type = "layer",
			icon = new/icon('icons/effects/96x96.dmi', "singularity_s3", frame = rand(1,8)),
			flags = FILTER_OVERLAY
		))
	else
		sm.remove_filter("icon")

/datum/sm_delam/singularity/on_deselect(obj/machinery/power/supermatter_crystal/sm)
	. = ..()
	sm.remove_filter(list("outline", "icon"))

/datum/sm_delam/singularity/overlays(obj/machinery/power/supermatter_crystal/sm)
	return list()

/datum/sm_delam/singularity/lights(obj/machinery/power/supermatter_crystal/sm)
	..()
	sm.set_light_color(SUPERMATTER_SINGULARITY_LIGHT_COLOUR)

/// When we have too much power.
/datum/sm_delam/tesla

/datum/sm_delam/tesla/can_select(obj/machinery/power/supermatter_crystal/sm)
	return (sm.internal_energy > POWER_PENALTY_THRESHOLD)

/datum/sm_delam/tesla/delam_progress(obj/machinery/power/supermatter_crystal/sm)
	if(!..())
		return FALSE
	sm.radio.talk_into(
		sm,
		"ОПАСНОСТЬ: ПРОИСХОДИТ ЦЕПНАЯ РЕАКЦИЯ.",
		sm.damage > sm.emergency_point ? sm.emergency_channel : sm.warning_channel
	)
	return TRUE

/datum/sm_delam/tesla/delaminate(obj/machinery/power/supermatter_crystal/sm)
	message_admins("Суперматерия [sm] в [ADMIN_VERBOSEJMP(sm)] вызвала отключение теслы.")
	sm.investigate_log("вызвала отключение теслы.", INVESTIGATE_ENGINE)

	effect_irradiate(sm)
	effect_demoralize(sm)
	if(sm.is_main_engine)
		effect_anomaly(sm)
	effect_tesla(sm)
	effect_explosion(sm)
	return ..()


/datum/sm_delam/tesla/filters(obj/machinery/power/supermatter_crystal/sm)
	..()

	sm.modify_filter(name = "ray", new_params = list(
		color = SUPERMATTER_TESLA_COLOUR,
	))

	sm.add_filter(name = "icon", priority = 2, params = list(
		type = "layer",
		icon = new/icon('icons/obj/machines/engine/energy_ball.dmi', "energy_ball", frame = rand(1,12)),
		flags = FILTER_UNDERLAY
	))

/datum/sm_delam/tesla/on_deselect(obj/machinery/power/supermatter_crystal/sm)
	. = ..()
	sm.remove_filter(list("icon"))

/datum/sm_delam/tesla/lights(obj/machinery/power/supermatter_crystal/sm)
	..()
	sm.set_light_color(SUPERMATTER_TESLA_COLOUR)

/// Default delam.
/datum/sm_delam/explosive

/datum/sm_delam/explosive/can_select(obj/machinery/power/supermatter_crystal/sm)
	return TRUE

/datum/sm_delam/explosive/delaminate(obj/machinery/power/supermatter_crystal/sm)
	message_admins("Суперматерия [sm] в [ADMIN_VERBOSEJMP(sm)] вызвал обычный сбой.")
	sm.investigate_log("вызвал обычный сбой.", INVESTIGATE_ENGINE)

/// ADD Andromeda-13
	priority_announce(
				title = "Техногенная авария",
		text = "Кристалл суперматерии подвергся расслоению, выжившим членам экипажа немедленно покинуть зону отчуждения.",
		sound =  'sound/announcer/default/sm_explosion.ogg',
		color_override = "red",
	)
/// END Andromeda-13

	effect_irradiate(sm)
	effect_demoralize(sm)
	if(sm.is_main_engine)
		effect_anomaly(sm)
	effect_explosion(sm)
	return ..()
