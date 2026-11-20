local units = require(script.Parent.Parent.units)

return {
	future = "လာမည့် %s",
	past = "ပြီးခဲ့သည့် %s",
	ranges = {
		{
			language = "စက္ကန့်အနည်းငယ်",
			max = 60 * units.second,
			format = {}
		},
		{
			language = "၁ မိနစ်",
			max = 2 * units.minute,
			format = {}
		},
		{
			language = "%d မိနစ်",
			max = 60 * units.minute,
			format = { "minutes" }
		},
		{
			language = "၁ နာရီ",
			max = 2 * units.hour,
			format = {}
		},
		{
			language = "%d နာရီ",
			max = 36 * units.hour,
			format = { "hours" }
		},
		{
			language = "၁ နေ့",
			max = 2 * units.day,
			format = {}
		},
		{
			language = "%d နေ့",
			max = 10 * units.day,
			format = { "days" }
		},
		{
			language = "၁ ပတ်",
			max = 2 * units.week,
			format = {}
		},
		{
			language = "%d ပတ်",
			max = 4 * units.week,
			format = { "weeks" }
		},
		{
			language = "၁ လ",
			max = 2 * units.month,
			format = {}
		},
		{
			language = "%d လ",
			max = 12 * units.month,
			format = { "months" }
		},
		{
			language = "၁ နှစ်",
			max = 2 * units.year,
			format = {}
		},
		{
			language = "%d နှစ်",
			max = 1e999,
			format = { "years" }
		}
	}
}