local units = require(script.Parent.Parent.units)

return {
	future = "za %s",
	past = "%s temu",
	ranges = {
		{
			language = "parę sekund",
			max = 60 * units.second,
			format = {}
		},
		{
			language = "minuta",
			max = 2 * units.minute,
			format = {}
		},
		{
			language = "%d minut",
			max = 60 * units.minute,
			format = { "minutes" }
		},
		{
			language = "godzina",
			max = 2 * units.hour,
			format = {}
		},
		{
			language = "%d godzin",
			max = 36 * units.hour,
			format = { "hours" }
		},
		{
			language = "dzień",
			max = 2 * units.day,
			format = {}
		},
		{
			language = "%d dni",
			max = 10 * units.day,
			format = { "days" }
		},
		{
			language = "tydzień",
			max = 2 * units.week,
			format = {}
		},
		{
			language = "%d tygodni",
			max = 4 * units.week,
			format = { "weeks" }
		},
		{
			language = "miesiąc",
			max = 2 * units.month,
			format = {}
		},
		{
			language = "%d miesięcy",
			max = 12 * units.month,
			format = { "months" }
		},
		{
			language = "rok",
			max = 2 * units.year,
			format = {}
		},
		{
			language = "%d lat",
			max = 1e999,
			format = { "years" }
		}
	}
}