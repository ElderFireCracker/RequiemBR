
/datum/job/vamp/vtr/citizen_vtr
	title = "Pedestrian"
	faction = "Vampire"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the Economy"
	selection_color = "#e3e3e3"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/citizen_vtr
	antag_rep = 7
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.
	paycheck_department = ACCOUNT_CIV

	display_order = JOB_DISPLAY_ORDER_CITIZEN_VTR

	exp_type_department = EXP_TYPE_SERVICES

	allowed_species = list("Vampire", "Ghoul", "Human")

	v_duty = "uhhh, elgeon, say something vampiric"
	duty = "elge put something uh CoD-ie in here thx"
	minimal_masquerade = 0
	allowed_bloodlines = list("Ventrue", "Daeva", "Mekhet", "Nosferatu", "Gangrel")


/datum/outfit/job/citizen_vtr/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.clane)
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
			if(H.clane.male_clothes)
				uniform = H.clane.male_clothes
		else
			shoes = /obj/item/clothing/shoes/vampire/heels
			if(H.clane.female_clothes)
				uniform = H.clane.female_clothes
	else
		uniform = /obj/item/clothing/under/vampire/emo
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
		else
			shoes = /obj/item/clothing/shoes/vampire/heels

/datum/outfit/job/citizen_vtr
	name = "Pedestrian"
	jobtype = /datum/job/vamp/vtr/citizen_vtr
	l_pocket = /obj/item/vamp/phone
	id = /obj/item/cockclock
	uniform = /obj/item/clothing/under/vampire/emo
	shoes = /obj/item/clothing/shoes/vampire
	backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)


/obj/effect/landmark/start/vtr/citizen_vtr
	name = "Pedestrian"
	icon_state = "Assistant"
