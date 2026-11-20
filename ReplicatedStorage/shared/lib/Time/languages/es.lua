local units = require(script.Parent.Parent.units)

return {
	future = "en %s",
	past = "hace %s",
	ranges = {
		{
			language = "unos segundos",
			max = 60 * units.second,
			format = {}
		},
		{
			language = "un minuto",
			max = 2 * units.minute,
			format = {}
		},
		{
			language = "%d minutos",
			max = 60 * units.minute,
			format = { "minutes" }
		},
		{
			language = "una hor",
			max = 2 * units.hour,
			format = {}
		},
		{
			language = "%d horas",
			max = 36 * units.hour,
			format = { "hours" }
		},
		{
			language = "un día",
			max = 2 * units.day,
			format = {}
		},
		{
			language = "%d días",
			max = 10 * units.day,
			format = { "days" }
		},
		{
			language = "una semana",
			max = 2 * units.week,
			format = {}
		},
		{
			language = "%d semanas",
			max = 4 * units.week,
			format = { "weeks" }
		},
		{
			language = "un mes",
			max = 2 * units.month,
			format = {}
		},
		{
			language = "%d meses",
			max = 12 * units.month,
			format = { "months" }
		},
		{
			language = "un año",
			max = 2 * units.year,
			format = {}
		},
		{
			language = "%d años",
			max = 1e999,
			format = { "years" }
		}
	}
}