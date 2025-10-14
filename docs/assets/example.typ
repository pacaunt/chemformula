#import "@local/chemformula:0.1.0": ch

#set page(width: 4in, margin: 0.2in, height: auto)

#show raw.where(lang: "example"): it => {
  eval(mode: "markup", it.text, scope: (ch: ch))
}

#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  set text(size: 13pt)
  it
}

= Chemical Formulae
```example
#ch("H2O")

#ch("Sb2O3")
```
= Chemical Equations
```example
#ch("CO2 + C -> 2 CO")

// Multilines are allowed!
#ch("Hg^2+ ->[I^-] HgI2
           ->[I^-] [Hg^II I4]^2- ")
```
= Charges
```example
#ch("H+")

#ch("CrO4^2-") // or 
#ch("CrO4 ^2-") // IUPAC recommended

#ch("[AgCl2]-")

#ch("Y^99+") // or
#ch("Y^(99+)") // Same
```

= Oxidation States 
```example
#ch("Fe^^II Fe^^III_2 O4") // or 
#ch("Fe^^(II)Fe^^(III)_(2)O4") // Same
```
= Stoichiometric Numbers 
```example
#ch("2H2O") // Tight 

#ch("2 H2O") // Spaced 

#ch("2  H2O") // Very Spaced 

#ch("1/2 H2O") // Automatic Fractions 

#ch("1\/2 H2O") // 
```
= Nuclides, Isotopes 
```example
#ch("^227_90 Th+") // Attached to " ". So it will not scale with text.

#ch("^227_(90)Th+")

#ch("^0_-1 n-")

#ch("_-1^0 n-")
```

= Parenthesis, Braces, Brackets
```example
#ch("(NH4)2S") // Automatic sizing 

#ch("[{(X2)3}2]^3+") 

#ch("\[{(X2)3}2]^3+") // To disable this behavior, just type `\`

$display(ch("CH4 + 2(O2 + 7/2N2)"))$ // Hack with math mode
```

= States of Aggregation 
```example 
#ch("H2(aq)")

#ch("CO3^2-_((aq))")

#ch("NaOH(aq, $oo$)")
```

= Radical Dots 
```example
#ch("OCO^*-")

#ch("NO^((2*)-)")
```

= Escaped Modes
```example 
// Use Math Mode!
#ch("NO_x") is the same as #ch("NO_$x$")

#ch("Fe^n+") is the same as #ch("Fe^$n+$")

#ch("Fe(CN)_$6/2$") // Fractions!

#ch("$#[*CO*]$_2^3") // bold text 

// Or just type texts...
#ch("mu\"-\"Cl") // Hyphen Escaped
```
= Reaction Arrows 
```example
#ch("A -> B")

#ch("A <- B")

#ch("A <-> B")

#ch("A <=> B")
```

= Above/Below Arrow Text 
```example
#ch("A ->[Delta] B")

#ch("A <=>[Above][Below] B")

#ch("CH3COOH <=>[+ OH-][+ H+] CH3COO-")
```

= Precipitation and Gas 
```example
#ch("SO4^2- + Ba^2+ -> BaSO4 v")

#ch("A v B v -> B ^ B ^")
```

= Alignments
```example
$ ch("A &-> B") \
  ch("B &-> C + D")
$
```
= More Examples 
```example
$  
  ch("Zn^2+ <=>[+ 2 OH-][+ 2 H+]")
  limits(ch("Zn(OH)2 v"))_"amphoteres Hydroxid"
  ch("<=>[+ 2 OH-][+ 2H+]")
  limits(ch("[Zn(OH)4]^2-"))_"Hydroxozikat"
$
```

= More Examples 
```example
#let tg = text.with(fill: olive)
#let ch = ch.with(scope: (tg: tg, ch: ch))
$ ch("Cu^^II Cl2 + K2CO3 -> tg(Cu^^II)CO3 v + 2 KCl") $

// Multiline Supported
$ ch("Hg^2+ ->[I-] HgI2 
           ->[I-] [Hg^II I4]^2-
") $
```



