/datum/martial_art/psychotic_brawling
	name = "Psychotic Brawling"
	id = MARTIALART_PSYCHOBRAWL
	pacifism_check = FALSE //Quite uncontrollable and unpredictable, people will still end up harming others with it.

/datum/martial_art/psychotic_brawling/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return psycho_attack(A,D)

/datum/martial_art/psychotic_brawling/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return psycho_attack(A,D)

/datum/martial_art/psychotic_brawling/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return psycho_attack(A,D)

/datum/martial_art/psychotic_brawling/proc/psycho_attack(mob/living/carbon/human/A, mob/living/carbon/human/D)
	var/atk_verb
	var/damage = damage_roll(A,D)
	switch(rand(1,8))
		if(1)
			D.help_shake_act(A)
			atk_verb = "helped"
		if(2)
			A.emote("cry")
			A.Stun(15)
			atk_verb = "cried looking at"
		if(3)
			if(A.grab_state >= GRAB_AGGRESSIVE)
				D.grabbedby(A, 1)
			else
				A.start_pulling(D, supress_message = TRUE)
				if(A.pulling)
					D.drop_all_held_items()
					D.stop_pulling()
					if(A.a_intent == INTENT_GRAB)
						log_combat(A, D, "grabbed", addition="aggressively")
						D.visible_message("<span class='warning'>[A] violently grabs [D]!</span>", \
						  "<span class='userdanger'>[A] violently grabs you!</span>")
						A.setGrabState(GRAB_AGGRESSIVE) //Instant aggressive grab
					else
						log_combat(A, D, "grabbed", addition="passively")
						A.setGrabState(GRAB_PASSIVE)
		if(4)
			A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
			atk_verb = "headbutts"
			D.visible_message("<span class='danger'>[A] [atk_verb] [D]!</span>", \
					  "<span class='userdanger'>[A] [atk_verb] you!</span>")
			playsound(get_turf(D), 'sound/weapons/punch1.ogg', 40, 1, -1)
			D.apply_damage(damage*1.3, BRUTE, BODY_ZONE_HEAD)
			A.apply_damage(damage, BRUTE, BODY_ZONE_HEAD)
			if(!istype(D.head,/obj/item/clothing/head/helmet/) && !istype(D.head,/obj/item/clothing/head/hardhat))
				D.adjustOrganLoss(ORGAN_SLOT_BRAIN, damage)
			A.Stun(rand(10,30))
			D.DefaultCombatKnockdown(rand(3,20))//CIT CHANGE - makes stuns from martial arts always use Knockdown instead of Stun for the sake of consistency
		if(5,6)
			A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
			atk_verb = pick("punches", "kicks", "hits", "slams into")
			D.visible_message("<span class='danger'>[A] [atk_verb] [D] with inhuman strength, sending [D.p_them()] flying backwards!</span>", \
							  "<span class='userdanger'>[A] [atk_verb] you with inhuman strength, sending you flying backwards!</span>")
			D.apply_damage(damage*2, BRUTE)
			playsound(get_turf(D), 'sound/effects/meteorimpact.ogg', 25, 1, -1)
			var/throwtarget = get_edge_target_turf(A, get_dir(A, get_step_away(D, A)))
			D.throw_at(throwtarget, 4, 2, A)//So stuff gets tossed around at the same time.
			D.DefaultCombatKnockdown(50)
		if(7,8)
			return FALSE

	if(atk_verb)
		log_combat(A, D, "[atk_verb] (Psychotic Brawling)")
	return TRUE