return {
	group = {
		id = 2588056,
		roles = {
			creator = {
				id = 17131138,
				color = Color3.fromHex("fc859c"),
				level = "CREATOR",
				special = true,
				trusted = true
			},
			leadStaff = {
				id = 20132133,
				color = Color3.fromHex("73d5fa"),
				level = "ADMIN",
				special = true,
				trusted = true
			},
			staff = {
				id = 17131168,
				color = Color3.fromHex("9ab3ff"),
				level = "MOD",
				special = true,
				trusted = true
			},
			gameStaff = {
				id = 29056337,
				color = Color3.fromHex("7389ff"),
				level = "MOD",
				special = true,
				trusted = true
			},
			founder = {
				id = 93617248,
				color = Color3.fromHex("f5be58"),
				level = "VIP",
				special = true,
				trusted = true
			},
			trusted = {
				id = 62677738,
				color = Color3.fromHex("b38fed"),
				level = "VIP",
				special = true,
				trusted = true
			},
			familiar = {
				id = 17131140,
				color = Color3.fromHex("ff92dc"),
				level = "PLAYER",
				special = true,
				trusted = true
			},
			player = {
				id = 20181124,
				color = Color3.fromHex("9baab5"),
				level = "PLAYER",
				special = false,
				trusted = false
			}
		},
		levels = { "CREATOR", "ADMIN", "MOD", "VIP", "PLAYER" },
		assignments = {
			[255] = "creator",
			[100] = "leadStaff",
			[8] = "staff",
			[7] = "gameStaff",
			[5] = "founder",
			[3] = "trusted",
			[2] = "familiar",
			[1] = "player",
			[0] = "player"
		},
		rankUps = {
			{
				from = "player",
				to = "familiar",
				criteria = { time = 1800000 }
			}
		}
	},
	tools = {
		draw = { limit = 2500 },
		claim = {
			spawn = { radius = 128 },
			bounds = {
				min = Vector2.new(5, 5),
				max = { regular = Vector2.new(40, 40), pro = Vector2.new(120, 120) }
			}
		},
		shape = { minRadius = 0.2, maxRadius = 128 }
	},
	layers = { limit = 30, offset = 0.01 },
	history = {
		limit = { regular = 30, premium = 150 }
	},
	votekick = { duration = 25, banDuration = 900, percentageRequired = 0.6, minimumHours = 5 },
	pro = {
		tiers = {
			{ id = 3406800122, length = 3, cost = 99 },
			{ id = 3406800674, length = 90, cost = 999 },
			{ id = 3406800289, length = 7, cost = 149 },
			{ id = 3406800823, length = 180, cost = 1799 },
			{ id = 3406800520, length = 30, cost = 399, special = true },
			{ id = 3406800965, length = 365, cost = 2999, special = true }
		}
	},
	report = {
		labels = {
			[Enum.ModerationResultLabel.ChildExploitation] = {
				reason = "Child exploitation",
				duration = nil
			},
			[Enum.ModerationResultLabel.SuicideSelfInjuryAndHarmfulBehavior] = {
				reason = "Self-harm",
				duration = 3
			},
			[Enum.ModerationResultLabel.ThreatsBullyingAndHarassment] = {
				reason = "Harassment",
				duration = 7
			},
			[Enum.ModerationResultLabel.TerrorismAndViolentExtremism] = {
				reason = "Terrorism/extremism",
				duration = 7
			},
			[Enum.ModerationResultLabel.DiscriminationSlursAndHateSpeech] = {
				reason = "Hate speech",
				duration = 7
			},
			[Enum.ModerationResultLabel.RealWorldSensitiveEvents] = {
				reason = "Sensitive events",
				duration = 3
			},
			[Enum.ModerationResultLabel.ViolentContentAndGore] = {
				reason = "Gore/violence",
				duration = 3
			},
			[Enum.ModerationResultLabel.RomanticAndSexualContent] = {
				reason = "Romantic/sexual",
				duration = 7
			},
			[Enum.ModerationResultLabel.IllegalAndRegulatedGoodsAndActivities] = {
				reason = "Illegal goods/activities",
				duration = 3
			},
			[Enum.ModerationResultLabel.Profanity] = { reason = "Profanity", duration = 2 },
			[Enum.ModerationResultLabel.Other] = { reason = "Other", duration = 2 }
		}
	}
}