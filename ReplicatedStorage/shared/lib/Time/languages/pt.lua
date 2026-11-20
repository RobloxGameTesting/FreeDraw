local units = require(script.Parent.Parent.units)

return {
	future = "em %s",
	past = "%s atrás",
	ranges = {
		{
			language = "uns segundos",
			max = 60 * units.second,
			format = {}
		},
		{
			language = "um minuto",
			max = 2 * units.minute,
			format = {}
		},
		{
			language = "%d minutos",
			max = 60 * units.minute,
			format = { "minutes" }
		},
		{
			language = "uma hora",
			max = 2 * units.hour,
			format = {}
		},
		{
			language = "%d horas",
			max = 36 * units.hour,
			format = { "hours" }
		},
		{
			language = "um dia",
			max = 2 * units.day,
			format = {}
		},
		{
			language = "%d dias",
			max = 10 * units.day,
			format = { "days" }
		},
		{
			language = "uma semana",
			max = 2 * units.week,
			format = {}
		},
		{
			language = "%d semanas",
			max = 4 * units.week,
			format = { "weeks" }
		},
		{
			language = "um mês",
			max = 2 * units.month,
			format = {}
		},
		{
			language = "%d mêses",
			max = 12 * units.month,
			format = { "months" }
		},
		{
			language = "um ano",
			max = 2 * units.year,
			format = {}
		},
		{
			language = "%d anos",
			max = 1e999,
			format = { "years" }
		}
	}
}