#import "parser.typ": *

#let eval-chem(tokens, scope: (:)) = {
  let positions = ()
  let stripped = regex("\;|\@|\ ")

  let peek = peek.with(arr: tokens)
  let eval-methods = (
    "None": v => {
      v.expr = v.expr.replace(regex("\@|\;"), "").replace(regex("\.|\*"), sym.dot)
      if peek(v.i - 1).type == "Digits" and peek(v.i + 1).type == "Nucleus" {
        v.expr = v.expr.replace(" ", sym.space.thin, count: 1)
        (position: "inline", value: v.expr)
      } else {
        (position: "inline", value: v.expr)
      }
    },
    "Digits": v => {
      if peek(v.i - 1).type == "None" {
        if peek(v.i + 1).type == "None" {
          if peek(v.i + 2).type != "None" {
            (position: "inline", value: v.expr)
          } else {
            (position: "inline", value: v.expr)
          }
        } else {
          (position: "inline", value: v.expr)
        }
      } else {
        if peek(v.i - 1).type == "Nucleus" {
          (position: "br", value: v.expr)
        } else {
          (position: "inline", value: v.expr)
        }
      }
    },
    "Charges": v => {
      v.expr = v.expr.replace("-", sym.minus).replace(regex("\*|\."), sym.bullet)
      if peek(v.i - 1).type == "None" {
        (position: "inline", value: v.expr)
      } else {
        (position: "tr", value: v.expr)
      }
    },
    "Superscript": v => {
      v.expr = v.expr.trim("^").trim(stripped).replace("-", sym.minus).replace(regex("\*|\."), sym.bullet)
      (position: "tr", value: v.expr)
    },
    "Subscript": v => {
      v.expr = v.expr.trim("_").trim(stripped).replace("-", sym.minus).replace(regex("\*|\."), sym.bullet)
      (position: "br", value: v.expr)
    },
    "Above": v => {
      v.expr = v.expr.trim("^").trim(stripped).replace("-", sym.minus).replace(regex("\*|\."), sym.bullet)
      (position: "t", value: v.expr)
    },
    "Below": v => {
      v.expr = v.expr.trim("_").trim(stripped).replace("-", sym.minus).replace(regex("\*|\."), sym.bullet)
      (position: "b", value: v.expr)
    },
    "Nucleus": v => {
      let braces = (
        "(": ")",
        "{": "}",
        "[": "]",
      )
      for (l, r) in braces.pairs() {
        if type(v.expr) == str and v.expr.starts-with(l) and v.expr.ends-with(r) {
          v.expr = (l, r).join(
            eval-chem(parsing-chem(v.expr.trim(regex((l, r).map(p => "\\" + p).join("|"))))),
          )
        }
      }
      (position: "inline", value: v.expr)
    },
  )

  let values = (i: 0, type: "None", expr: "")
  for (i, toks) in tokens.enumerate() {
    values.i = i
    values = values + toks
    positions.push((eval-methods.at(values.type))(values))
  }

  // [#positions]

  let results = ()
  let temp = (inline: "")

  let reset-positions(temp, results) = {
    let base = temp.remove("inline", default: "")
    if temp.len() == 0 {
      results.push(base)
    } else {
      results.push(math.attach(math.limits(base), ..temp))
      temp = (:)
    }
    return (temp, results)
  }

  for (position, value) in positions {
    if temp.at(position, default: none) != none {
      (temp, results) = reset-positions(temp, results)
      temp.insert(position, value)
    } else {
      temp.insert(position, value)
    }
  }
  if temp.len() != 0 {
    (_, results) = reset-positions(temp, results)
  }

  results.sum()
}




#let ch(chem, scope: (:)) = {
  let ch = ch.with(scope: scope) // for recursive evaluation

  if type(chem) == content {
    if chem.func() == raw {
      chem = chem.text
    } else if chem.func() == text {
      chem = chem.text
    }
  }
  let EOT = "@"
  let tokens = parsing-reaction(chem + EOT)
  let peek = peek.with(arr: tokens)


  let results = ()
  for (i, toks) in tokens.enumerate() {
    let (type, expr) = toks
    let out = if type == "Elem" {
      $#eval-chem(parsing-chem(expr + EOT), scope: scope)$
    } else if type == "Space" {
      " "
    } else if type == "Symbol" {
      expr.replace(regex("\@|\;"), "").replace(regex("\*|\."), sym.dot)
    } else if type == "Arrow" {
      let arrow-toks = parse-arrow(expr)
      let args = ()
      let arrow = ""
      for atok in arrow-toks {
        if atok.type == "Args" { args.push(atok.expr.trim(regex("[\[\]]"))) } else {
          arrow = eval(mode: "math", atok.expr.replace("<=>", sym.harpoons.rtlb))
        }
      }
      args = args.map(ch)
      let above = args.at(0, default: none)
      let below = args.at(1, default: none)
      $stretch(#arrow, size: #150%)^above_below$
    } else if type == "Gaseous" {
      expr.replace("^", sym.arrow.t).replace(regex("\@|\;"), "").trim(" ")
    } else if type == "Precipitation" {
      expr.replace("v", sym.arrow.b).replace(regex("\@|\;"), "").trim(" ")
    } else if type == "Text" {
      eval(mode: "markup", expr.trim("\""), scope: scope)
    } else if type == "Math" {
      eval(mode: "math", expr.trim("$"), scope: scope)
    }
    results.push(out)
  }
  results.sum()
}

