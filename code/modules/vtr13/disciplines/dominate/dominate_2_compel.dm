/datum/discipline_power/vtr/dominate/compel
	name = "Compel"
	desc = "Quickly compel a victim to obey with a short verbal command."
	level = 2

	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK|DISC_CHECK_SEE
	target_type = TARGET_PLAYER|TARGET_LIVING|TARGET_SELF

	var/datum/action/select_compel_button/select_compel_button = null
	var/selected_command

/datum/discipline_power/vtr/dominate/compel/post_gain()
	selected_command = SSdominate_compulsion.compel_list["Think Twice!"]
	select_compel_button = new(owner, src)
	select_compel_button.Grant(owner)

/datum/discipline_power/vtr/dominate/compel/activate(mob/living/target)
	. = ..()
	playsound(target, 'code/modules/wod13/sounds/dominate.ogg', 100, FALSE)
	if(!SSroll.opposed_roll(
		owner,
		target,
		dice_a = owner.get_total_social() + discipline.level,
		dice_b = target.get_total_social() + target.get_total_blood(), 
		alert_atom = target,
		show_player_a = FALSE,
		show_player_b = FALSE))
		to_chat(owner, span_warning("[target] resists your command!"))
		return
	target.AddElement(/datum/element/compulsion, owner, selected_command)
