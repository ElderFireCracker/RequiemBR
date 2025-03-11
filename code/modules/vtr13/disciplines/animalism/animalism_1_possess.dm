/datum/discipline_power/vtr/animalism/possess
	name = "Possess Animal"
	desc = "Elgeon write a description kthx. Get that rat in you"
	level = 1
	violates_masquerade = FALSE
	cancelable = TRUE
	target_type = TARGET_LIVING
	duration_override = TRUE
	var/mob/living/simple_animal/possessed_creature = null

	var/datum/action/unpossess/unpossess_datum = null
	var/list/allowed_types = list(
		/mob/living/simple_animal/hostile/beastmaster/rat,
		/mob/living/simple_animal/hostile/beastmaster/cat,
		/mob/living/simple_animal/pet/rat,
		/mob/living/simple_animal/pet/cat/vampire
	)
	range = 7

/datum/discipline_power/vtr/animalism/possess/can_activate(mob/living/simple_animal/target, alert = FALSE)
	. = ..()
	if(possessed_creature)
		if(alert)
			to_chat(owner, span_warning("You are already possessing a creature!"))
		return FALSE

	if(!target || !allowed_types.Find(target.type))
		if(alert)
			to_chat(owner, span_warning("You cannot cast [src] on [target]!"))
		return FALSE
	if(target.mind)
		if(alert)
			to_chat(owner, span_warning("[target] resists your possession!"))
		return FALSE
	
	

/datum/discipline_power/vtr/animalism/possess/activate(mob/living/simple_animal/target)
	..()
	if(istype(target, /mob/living/simple_animal/pet/rat))
		var/mob/living/simple_animal/pet/rat/never_despawn_rat = target
		never_despawn_rat.should_despawn = FALSE
	owner.mind.transfer_to(target)
	possessed_creature = target
	unpossess_datum = new(target, src)
	unpossess_datum.Grant(target)
	RegisterSignal(possessed_creature, list(COMSIG_PARENT_QDELETING, COMSIG_LIVING_DEATH), PROC_REF(deactivate_trigger))
	RegisterSignal(owner, list(COMSIG_PARENT_QDELETING, COMSIG_LIVING_DEATH), PROC_REF(deactivate_trigger))
	RegisterSignal(owner, COMSIG_POWER_TRY_ACTIVATE, PROC_REF(prevent_other_powers))

/datum/discipline_power/vtr/animalism/possess/proc/prevent_other_powers(datum/source, datum/target)
	SIGNAL_HANDLER
	to_chat(owner, span_warning("You cannot use other disciplines while possessing a creature!"))
	return POWER_PREVENT_ACTIVATE

/datum/discipline_power/vtr/animalism/possess/proc/deactivate_trigger(datum/source)
	SIGNAL_HANDLER
	try_deactivate()

/datum/discipline_power/vtr/animalism/possess/deactivate()
	. = ..()

	UnregisterSignal(possessed_creature, list(COMSIG_PARENT_QDELETING, COMSIG_LIVING_DEATH))
	UnregisterSignal(owner, list(COMSIG_PARENT_QDELETING, COMSIG_LIVING_DEATH, COMSIG_POWER_TRY_ACTIVATE))
	if(possessed_creature.mind)
		possessed_creature.mind.transfer_to(owner)
	
	unpossess_datum.Remove(possessed_creature)
	qdel(unpossess_datum)
	possessed_creature = null
	


/datum/action/unpossess
	name = "Unpossess"
	desc = "Unpossess the current creature."
	background_icon_state = "discipline"
	button_icon_state = "hivemind"
	var/datum/discipline_power/vtr/animalism/possess/possess_datum

/datum/action/unpossess/New(Target, datum/discipline_power/vtr/animalism/possess/possess_discipline)
	..(Target)
	possess_datum = possess_discipline

/datum/action/unpossess/Trigger()
	possess_datum.deactivate()