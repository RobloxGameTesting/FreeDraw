local units = require(script.Parent.Parent.units)

return {
	future = "in %s",
	past = "%s ago",
	ranges = {
		{
			language = "a few seconds",
			max = 60 * units.second,
			format = {}
		},
		{
			language = "a minute",
			max = 2 * units.minute,
			format = {}
		},
		{
			language = "%d minutes",
			max = 60 * units.minute,
			format = { "minutes" }
		},
		{
			language = "an hour",
			max = 2 * units.hour,
			format = {}
		},
		{
			language = "%d hours",
			max = 36 * units.hour,
			format = { "hours" }
		},
		{
			language = "a day",
			max = 2 * units.day,
			format = {}
		},
		{
			language = "%d days",
			max = 10 * units.day,
			format = { "days" }
		},
		{
			language = "a week",
			max = 2 * units.week,
			format = {}
		},
		{
			language = "%d weeks",
			max = 4 * units.week,
			format = { "weeks" }
		},
		{
			language = "a month",
			max = 2 * units.month,
			format = {}
		},
		{
			language = "%d months",
			max = 12 * units.month,
			format = { "months" }
		},
		{
			language = "a year",
			max = 2 * units.year,
			format = {}
		},
		{
			language = "%d years",
			max = 1e999,
			format = { "years" }
		}
	}
}