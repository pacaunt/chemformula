#import "../src/chemformula.typ": * 

// #ch("CH3OH^2+ (aq) + 3 H2O(l) + e-  ^220_10 Th+")
// #recursive-parse("^99_11 A")
// #parsing-reaction("^99_11 A")

// #parsing-reaction("^220_11 ((Th+)2)4")
#parsing-chem("^220_11 ((Th+2)3)4@")

#position-chem("^220_11 ((Th+2\)3)4@")
#parsing-reaction("^220_11 ((Th+2\)3\)4@")

#parsing-reaction("#tg(Cu^^II)CO3")

#ch("^220_11 \((Th2)3)4")
// #ch("K3[Fe(CN)6]^2+ (aq) + H2O(l) SO4^2- NO3-")

$ ch("2 CH4 + 2(O2 + 1/2 N2) ->[$Delta$][\"beautifully\"] x H2O^3+ f") $

#ch("^220_90 ((Th2)2)2")

#parsing-reaction("^220_(90)Th")


#parsing-reaction("Delta")

$ attach(O, br: 2) $


$ {[ attach(limits( \( attach(limits(a), br: 2)\)), br:3) \] $

$ "Fe"attach("f") $