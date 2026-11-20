local Enum2 = {
	Blind = {
		Trichromacy = 0,
		Protanopia = 1,
		Protanomaly = 2,
		Deuteranopia = 3,
		Deuteranomaly = 4,
		Tritanopia = 5,
		Tritanomaly = 6,
		Achromatopsia = 7,
		Achromatomaly = 8
	},
	Group = {
		Trichroma = 0,
		Protan = 1,
		Deutan = 2,
		Tritan = 3,
		Achroma = 4
	}
}

Enum2.Blind.None = Enum2.Blind.Trichromacy
Enum2.Blind.LowRed = Enum2.Blind.Protanomaly
Enum2.Blind.LowGreen = Enum2.Blind.Deuteranomaly
Enum2.Blind.LowBlue = Enum2.Blind.Tritanomaly
Enum2.Blind.LowColour = Enum2.Blind.Achromatomaly

Enum2.Blind.NoRed = Enum2.Blind.Protanopia
Enum2.Blind.NoGreen = Enum2.Blind.Deuteranopia
Enum2.Blind.NoBlue = Enum2.Blind.Tritanopia
Enum2.Blind.NoColour = Enum2.Blind.Achromatopsia

return Enum2