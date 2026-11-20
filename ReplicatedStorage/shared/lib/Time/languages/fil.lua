local units = require(script.Parent.Parent.units)

return {
	future = "in %s",
	past = "%s na ang nakalipas",
	ranges = {
		{
			language = "mga ilang seguno pa lang",
			max = 60 * units.second,
			format = {}
		},
		{
			language = "%d na minuto",
			max = 60 * units.minute,
			format = { "minutes" }
		},
		{
			language = "%d na oras",
			max = 36 * units.hour,
			format = { "hours" }
		},
		{
			language = "%d na araw",
			max = 10 * units.day,
			format = { "days" }
		},
		{
			language = "%d na linggo",
			max = 4 * units.week,
			format = { "weeks" }
		},
		{
			language = "%d na buwan",
			max = 12 * units.month,
			format = { "months" }
		},
		{
			language = "%d na taon",
			max = 1e999,
			format = { "years" }
		}
	}
}