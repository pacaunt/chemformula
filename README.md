# chemformula
Typst Packages for easy and extensible chemical formula formatting. 
## Examples 
### Chemcial Formulae
```typ
#ch("H2O")

#ch("Sb2O3")
```
<img width="800" height="186" alt="example-01" src="https://github.com/user-attachments/assets/17373f66-373d-49ed-b497-16241df870c4" />

### Chemical Equations
```typ
#ch("CO2 + C -> 2 CO")

// Multilines are allowed!
#ch("Hg^2+ ->[I^-] HgI2
           ->[I^-] [Hg^II I4]^2- ")
```
<img width="800" height="195" alt="example-02" src="https://github.com/user-attachments/assets/c986a131-9765-4118-9cc9-303ce88d0c16" />

### Charges
```typ
#ch("H+")

#ch("CrO4^2-") // or 
#ch("CrO4 ^2-") // IUPAC recommended

#ch("[AgCl2]-")

#ch("Y^99+") // or
#ch("Y^(99+)") // Same
```
<img width="800" height="282" alt="example-03" src="https://github.com/user-attachments/assets/733f34c4-b12e-4c58-a569-897b6f37dd99" />

### Oxidation States 
```typ
#ch("Fe^^II Fe^^III_2 O4") // or 
#ch("Fe^^(II)Fe^^(III)_(2)O4") // Same
```
<img width="800" height="145" alt="example-04" src="https://github.com/user-attachments/assets/998bb37f-5368-41f6-b847-676a946af992" />

### Stoichiometric Numbers 
```typ
#ch("2H2O") // Tight 

#ch("2 H2O") // Spaced 

#ch("2  H2O") // Very Spaced 

#ch("1/2 H2O") // Automatic Fractions 

#ch("1\/2 H2O") // 
```
<img width="800" height="324" alt="example-05" src="https://github.com/user-attachments/assets/9713350a-43db-416d-8bc7-52ca6a48ae6a" />

### Nuclides, Isotopes 
```typ
#ch("^227_90 Th+") // Attached to " ". So it will not scale with text.

#ch("^227_(90)Th+")

#ch("^0_-1 n-")

#ch("_-1^0 n-")
```
<img width="800" height="278" alt="example-06" src="https://github.com/user-attachments/assets/f09940cb-58db-4a9d-a90c-f9d629f369d4" />

### Parenthesis, Braces, Brackets
```typ
#ch("(NH4)2S") // Automatic sizing 

#ch("[{(X2)3}2]^3+") 

#ch("\[{(X2)3}2]^3+") // To disable this behavior, just type `\`

$display(ch("CH4 + 2(O2 + 7/2N2)"))$ // Hack with math mode
```
<img width="800" height="308" alt="example-07" src="https://github.com/user-attachments/assets/37520c8e-d760-406a-9e95-9ac9e870a193" />

### States of Aggregation 
```typ
// #ch("H2(aq)")

#ch("CO3^2-_((aq))")

#ch("NaOH(aq, $oo$)")
```
<img width="800" height="190" alt="example-08" src="https://github.com/user-attachments/assets/4e7d2e9e-cb92-48fc-93a7-6edd938401b4" />

### Radical Dots 
```typ
#ch("OCO^*-")

#ch("NO^((2*)-)")
```
<img width="800" height="186" alt="example-09" src="https://github.com/user-attachments/assets/81bd6016-e607-44a0-80c9-c1d9dd58dafe" />

### Escaped Modes
```typ
// Use Math Mode!
#ch("NO_x") is the same as #ch("NO_$x$")

#ch("Fe^n+") is the same as #ch("Fe^$n+$")

#ch("Fe(CN)_$6/2$") // Fractions!

#ch("$#[*CO*]$_2^3") // bold text 

// Or just type texts...
#ch("mu\"-\"Cl") // Hyphen Escaped
```
<img width="800" height="329" alt="example-10" src="https://github.com/user-attachments/assets/c8f04a9f-8969-431f-84b8-390a7323b192" />

## Reaction Arrows 
```typ
#ch("A -> B")

#ch("A <- B")

#ch("A <-> B")

#ch("A <=> B")
```
<img width="800" height="295" alt="example-11" src="https://github.com/user-attachments/assets/b75faaf3-ca93-467e-b6c6-6303c29da129" />

### Above/Below Arrow Text 
```typ
#ch("A ->[Delta] B")

#ch("A <=>[Above][Below] B")

#ch("CH3COOH <=>[+ OH-][+ H+] CH3COO-")
```
<img width="800" height="263" alt="example-12" src="https://github.com/user-attachments/assets/34d651ce-e4c3-4933-833e-d3b36e33bcb8" />

### Precipitation and Gas 
```typ
#ch("SO4^2- + Ba^2+ -> BaSO4 v")

#ch("A v B v -> B ^ B ^")
```
<img width="800" height="193" alt="example-13" src="https://github.com/user-attachments/assets/f52e47bb-ed98-487b-a525-ca3f567de329" />

### Alignments
```example
$ ch("A &-> B") \
  ch("B &-> C + D")
$
```
<img width="800" height="204" alt="example-14" src="https://github.com/user-attachments/assets/9bf7f6a3-92bf-40b8-a9fc-20a178b10bcd" />

### More Examples 
```typ
$  
  ch("Zn^2+ <=>[+ 2 OH-][+ 2 H+]")
  limits(ch("Zn(OH)2 v"))_"amphoteres Hydroxid"
  ch("<=>[+ 2 OH-][+ 2H+]")
  limits(ch("[Zn(OH)4]^2-"))_"Hydroxozikat"
$
```
<img width="800" height="182" alt="example-15" src="https://github.com/user-attachments/assets/4da96416-ec73-4100-af90-23610ac7b3b1" />
```typ
#let tg = text.with(fill: olive)
#let ch = ch.with(scope: (tg: tg, ch: ch))
$ ch("Cu^^II Cl2 + K2CO3 -> tg(Cu^^II)CO3 v + 2 KCl") $

// Multiline Supported
$ ch("Hg^2+ ->[I-] HgI2
            ->[I-] [Hg^II I4]^2-
") $
```
<img width="800" height="245" alt="example-16" src="https://github.com/user-attachments/assets/a870ad91-612e-471f-8bf6-ea8211311e08" />

