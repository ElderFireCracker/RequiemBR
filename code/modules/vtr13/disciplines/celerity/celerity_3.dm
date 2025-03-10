/datum/movespeed_modifier/vtr/celerity3
	multiplicative_slowdown = -1

/datum/discipline_power/vtr/celerity/three
	name = "Celerity 3"
	desc = "Move faster. React in less time. Your body is under perfect control."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = DURATION_TURN

	grouped_powers = list(
		/datum/discipline_power/vtr/celerity/one,
		/datum/discipline_power/vtr/celerity/two,
		/datum/discipline_power/vtr/celerity/four,
		/datum/discipline_power/vtr/celerity/five
	)

/datum/discipline_power/vtr/celerity/three/activate()
	. = ..()
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(celerity_visual))

	owner.celerity_visual = TRUE
	owner.add_movespeed_modifier(/datum/movespeed_modifier/vtr/celerity3)

/datum/discipline_power/vtr/celerity/three/deactivate()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	owner.celerity_visual = FALSE
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/vtr/celerity3)