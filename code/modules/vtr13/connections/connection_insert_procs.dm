/mob/living/proc/insert_character_connection(group_type, member_type, player_ckey, character_name, connection_desc, group_id = NULL)
	var/our_group_id = group_id
	if(!our_group_id)
		our_group_id = get_next_character_connection_group_id()

	var/datum/db_query/query = SSdbcore.NewQuery({"
			INSERT INTO [format_table_name("character_connection")] (`group_id`, `group_type`, `member_type`, `player_ckey`, `character_name`, `connection_desc`, `round_id_established`, `date_established`)
			VALUES (:group_id, :group_type, :member_type, :ckey, :char_name, :connection_desc, :round_id, Now())
		"}, list(
			"group_id" = group_id, 
			"group_type" = group_type, 
			"member_type" = member_type, 
			"ckey" = player_ckey, 
			"char_name" = character_name, 
			"connection_desc" = connection_desc, 
			"round_id" = GLOB.round_id)
	)
	query.Execute()
	qdel(query_log_connection)
	
	return our_group_id
