
/datum/job/vamp/vtr/hierophant
	title = "Hierophant"
	department_head = list("Seneschal")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Beast Within"
	selection_color = "#19571e"

	outfit = /datum/outfit/job/hierophant

	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	
	exp_type = EXP_TYPE_CRONE
	exp_type_department = EXP_TYPE_LANCEA

	my_contact_is_important = TRUE
	display_order = JOB_DISPLAY_ORDER_HIEROPHANT
	v_duty = "Cackle madly and sew chicken legs onto a birdhouse. elge should find a more fitting description for Corpse's favorite role"
	minimal_masquerade = 4
	minimal_generation = 7
	allowed_species = list("Vampire")
	allowed_bloodlines = list("Ventrue", "Daeva", "Mekhet", "Nosferatu", "Gangrel")
	experience_addition = 20
	known_contacts = list("Seneschal", "Keeper of Elysium", "Sheriff", "Page")

/datum/outfit/job/hierophant
	name = "Hierophant"
	jobtype = /datum/job/vamp/vtr/hierophant

	id = /obj/item/card/id/hierophant
	glasses = /obj/item/clothing/glasses/vampire/perception
	suit = /obj/item/clothing/suit/vampire/trench/archive
	shoes = /obj/item/clothing/shoes/vampire
	gloves = /obj/item/clothing/gloves/vampire/latex
	uniform = /obj/item/clothing/under/vampire/archivist
	r_pocket = /obj/item/vamp/keys/hierophant
	l_pocket = /obj/item/vamp/phone/hierophant
	backpack_contents = list(/obj/item/passport=1, /obj/item/phone_book=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/arcane_tome=1, /obj/item/vamp/creditcard/elder=1, /obj/item/melee/vampirearms/katana/kosa=1)

/datum/outfit/job/hierophant/pre_equip(mob/living/carbon/human/H)
	..()

/obj/effect/landmark/start/hierophant
	name = "Hierophant"
	icon_state = "Dealer"
