local units = require(script.Parent.Parent.units)

return {
	future = "în %s",
	past = "acum %s",
	ranges = {
		{
			language = "câteva secunde",
			max = 60 * units.second,
			format = {}
		},
		{
			language = "un minut",
			max = 2 * units.minute,
			format = {}
		},
		{
			language = "%d minute",
			max = 60 * units.minute,
			format = { "minutes" }
		},
		{
			language = "o oră",
			max = 2 * units.hour,
			format = {}
		},
		{
			language = "%d ore",
			max = 24 * units.hour,
			format = { "hours" }
		},
		{
			language = "o zi",
			max = 2 * units.day,
			format = {}
		},
		{
			language = "%d zile",
			max = 7 * units.day,
			format = { "days" }
		},
		{
			language = "o săptămână",
			max = 2 * units.week,
			format = {}
		},
		{
			language = "%d săptămâni",
			max = 4 * units.week,
			format = { "weeks" }
		},
		{
			language = "o lună",
			max = 2 * units.month,
			format = {}
		},
		{
			language = "%d luni",
			max = 12 * units.month,
			format = { "months" }
		},
		{
			language = "un an",
			max = 2 * units.year,
			format = {}
		},
		{
			language = "%d ani",
			max = 1e999,
			format = { "years" }
		}
	}
}