#define BALLOON_TEXT_WIDTH 200
#define BALLOON_TEXT_SPAWN_TIME (0.2 SECONDS)
#define BALLOON_TEXT_FADE_TIME (0.1 SECONDS)
#define BALLOON_TEXT_FULLY_VISIBLE_TIME (0.7 SECONDS)
#define BALLOON_TEXT_TOTAL_LIFETIME(mult) (BALLOON_TEXT_SPAWN_TIME + BALLOON_TEXT_FULLY_VISIBLE_TIME*mult + BALLOON_TEXT_FADE_TIME)
/// The increase in duration per character in seconds
#define BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MULT (0.05)
/// The amount of characters needed before this increase takes into effect
#define BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MIN 10

/**
 * Creates text that will float from the atom upwards to the viewer.
 *
 * Args:
 * * mob/viewer: The mob the text will be shown to. Nullable (But only in the form of it won't runtime).
 * * text: The text to be shown to viewer. Must not be null.
 * * pixel_drift: Randomizes the start point of the balloon text
 */
/atom/proc/balloon_alert(mob/viewer, text, pixel_drift = FALSE)
	SHOULD_NOT_SLEEP(TRUE)

	INVOKE_ASYNC(src, PROC_REF(balloon_alert_perform), viewer, text, pixel_drift)

/// Create balloon alerts (text that floats up) to everything within range.
/// Will only display to people who can see.
/atom/proc/balloon_alert_to_viewers(message, self_message, vision_distance = DEFAULT_MESSAGE_RANGE, list/ignored_mobs)
	SHOULD_NOT_SLEEP(TRUE)

	var/list/hearers = get_hearers_in_view(vision_distance, src)
	hearers -= ignored_mobs

	for (var/mob/hearer in hearers)
		if (hearer.is_blind())
			continue

		balloon_alert(hearer, (hearer == src && self_message) || message)

// Do not use.
// MeasureText blocks. I have no idea for how long.
// I would've made the maptext_height update on its own, but I don't know
// if this would look bad on laggy clients.
/atom/proc/balloon_alert_perform(mob/viewer, text, pixel_drift = FALSE)

	var/client/viewer_client = viewer?.client
	if (isnull(viewer_client))
		return

	var/image/balloon_alert = image(loc = isturf(src) ? src : get_atom_on_turf(src), layer = ABOVE_MOB_LAYER)
	balloon_alert.plane = BALLOON_CHAT_PLANE
	balloon_alert.alpha = 0
	balloon_alert.appearance_flags = RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM
	balloon_alert.maptext = MAPTEXT("<span style='text-align: center; -dm-text-outline: 1px #0005;'>[text]</span>")
	balloon_alert.maptext_x = (BALLOON_TEXT_WIDTH - ICON_SIZE_X) * -0.5 - base_pixel_x
	balloon_alert.maptext_height = WXH_TO_HEIGHT(viewer_client?.MeasureText(text, null, BALLOON_TEXT_WIDTH))
	balloon_alert.maptext_width = BALLOON_TEXT_WIDTH

	if(pixel_drift)
		balloon_alert.pixel_x += rand(-8, 8)
		balloon_alert.pixel_y += rand(-8, 8)

	viewer_client?.images += balloon_alert

	var/length_mult = 1 + max(0, length(strip_html_full(text)) - BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MIN) * BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MULT

	animate(
		balloon_alert,
		pixel_y = ICON_SIZE_Y * 1.2,
		time = BALLOON_TEXT_TOTAL_LIFETIME(length_mult),
		easing = SINE_EASING | EASE_OUT,
	)

	animate(
		alpha = 255,
		time = BALLOON_TEXT_SPAWN_TIME,
		easing = CUBIC_EASING | EASE_OUT,
		flags = ANIMATION_PARALLEL,
	)

	animate(
		alpha = 0,
		time = BALLOON_TEXT_FULLY_VISIBLE_TIME * length_mult,
		easing = CUBIC_EASING | EASE_IN,
	)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(remove_image_from_client), balloon_alert, viewer_client), BALLOON_TEXT_TOTAL_LIFETIME(length_mult))

#undef BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MIN
#undef BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MULT
#undef BALLOON_TEXT_FADE_TIME
#undef BALLOON_TEXT_FULLY_VISIBLE_TIME
#undef BALLOON_TEXT_SPAWN_TIME
#undef BALLOON_TEXT_TOTAL_LIFETIME
#undef BALLOON_TEXT_WIDTH
