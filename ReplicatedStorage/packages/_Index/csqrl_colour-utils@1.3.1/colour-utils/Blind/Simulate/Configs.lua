local Enum2 = require(script.Parent.Parent.Enum)

return {
	Anomalised = {
		[Enum2.Blind.Protanomaly] = true,
		[Enum2.Blind.Deuteranomaly] = true,
		[Enum2.Blind.Tritanomaly] = true,
		[Enum2.Blind.Achromatomaly] = true
	},
	Groups = {
		[Enum2.Blind.Trichromacy] = Enum2.Group.Trichroma,
		[Enum2.Blind.Protanopia] = Enum2.Group.Protan,
		[Enum2.Blind.Protanomaly] = Enum2.Group.Protan,
		[Enum2.Blind.Deuteranopia] = Enum2.Group.Deutan,
		[Enum2.Blind.Deuteranomaly] = Enum2.Group.Deutan,
		[Enum2.Blind.Tritanopia] = Enum2.Group.Tritan,
		[Enum2.Blind.Tritanomaly] = Enum2.Group.Tritan,
		[Enum2.Blind.Achromatopsia] = Enum2.Group.Achroma,
		[Enum2.Blind.Achromatomaly] = Enum2.Group.Achroma
	},
	Gamma_Correct = 2.2,
	Matrix = {
		XYZ_RGB = {
			3.241,
			-0.969,
			0.056,
			-1.537,
			1.876,
			-0.204,
			-0.499,
			0.042,
			1.057
		},
		RGB_XYZ = {
			0.412,
			0.213,
			0.019,
			0.358,
			0.715,
			0.119,
			0.18,
			0.072,
			0.95
		}
	},
	Blinder = {
		[Enum2.Group.Protan] = { X = 0.747, Y = 0.254, M = 1.273, YI = -0.074 },
		[Enum2.Group.Deutan] = { X = 1.4, Y = -0.4, M = 0.968, YI = 0.003 },
		[Enum2.Group.Tritan] = { X = 0.175, Y = 0, M = 0.063, YI = 0.292 }
	}
}