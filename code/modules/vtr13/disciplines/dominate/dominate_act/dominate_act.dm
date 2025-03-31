//A datum processed and applied via element/compulsion.
//all relevant instances for it are stored in SSdominate_act, you should never declare one.
//No procs for this datum or any of its children should be called outside of element/compulsion.
/datum/dominate_act
	var/phrase = "PLACEHOLDER" //MUST BE UNIQUE
	var/activate_verb = "placeholder"
	var/linked_trait = null //Set this if you set a duration
	var/no_remove = FALSE //Set to TRUE if the compulsion doesn't need to be removed
	var/duration

/datum/dominate_act/proc/apply_message(mob/living/target)
	to_chat(target, span_danger("You are x'd to [activate_verb]."))

/datum/dominate_act/proc/apply(mob/living/target, mob/living/aggressor, datum/element/linked_element)
	SHOULD_CALL_PARENT(TRUE)
	aggressor.say(phrase)
	if(target.mind)
		apply_message(target)
	if(no_remove)
		return

	if(linked_trait)
		ADD_TRAIT(target, linked_trait, DOMINATE_ACT_TRAIT)
	if(duration)
		addtimer(CALLBACK(src, PROC_REF(remove), target, linked_element), duration)
	RegisterSignal(target, COMSIG_ELEMENT_DETACH, PROC_REF(remove)) //Detach when the parent element detaches.

/datum/dominate_act/proc/remove(datum/source, datum/element/linked_element)
	SIGNAL_HANDLER
	SHOULD_CALL_PARENT(TRUE)
	
	if(no_remove)
		CRASH("Hey uh dominate_act '[phrase]' has NO_REMOVE turned on, but remove() was called.")

	if(!istype(linked_element, /datum/element/compulsion))
		return FALSE
	if(!isliving(source))
		CRASH("Are You trying to remove a dominate_act from a person who doesn't exist? What???")
	
	if(linked_trait && !HAS_TRAIT(source, linked_trait))
		return FALSE
	
	var/mob/living/source_mob = source
	if(source_mob.mind)
		to_chat(source_mob, span_notice("You no longer need to [activate_verb]."))
	
	UnregisterSignal(source, COMSIG_ELEMENT_DETACH)
	REMOVE_TRAIT(source, linked_trait, DOMINATE_ACT_TRAIT)
	return TRUE
