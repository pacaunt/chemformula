#import "parser.typ": *

#let ch(chem, scope: (:), mode: "Inline") = {
  let ch = ch.with(scope: scope) // for recursive evaluation

  if type(chem) == content {
    if chem.func() == raw {
      chem = chem.text
    } else if chem.func() == text {
      chem = chem.text
    }
  }
  let EOT = "@"
  let tokens = parsing-reaction(chem + EOT, mode: mode)

  let peek = peek.with(arr: tokens)
  let positions = (:)
  let scripts = ("Superscript", "Subscript", "Above", "Below")

  let results = ("",)
  let _type = std.type
  for (i, toks) in tokens.enumerate() {
    let (type, expr) = toks
    let out = if type in ("Digits", "None") {
      if mode == "Scripts" {
        expr = expr.replace(regex("\.|\*"), sym.bullet)
      }
      expr.trim(regex("\@|\;")).replace("-", sym.minus).replace(regex("\.|\*"), sym.dot)
    } else if type == "Elem" {
      let braces = (
        "(": ")",
        "{": "}",
        "[": "]",
      )
      for (l, r) in braces.pairs() {
        if _type(expr) == str and expr.starts-with(l) and expr.ends-with(r) {
          expr = (l, r).join(
            ch(expr.trim(regex((l, r).map(p => "\\" + p).join("|")))),
          )
        }
      }
      expr
      //$#eval-chem(parsing-chem(expr + EOT), scope: scope)$
    } else if type in scripts {
      let ch = ch.with(mode: "Scripts")


      // check if nothing is here.
      if positions.len() == 0 {
        positions.inline = results.pop()
      }

      // put the current type
      positions.insert(type, expr)

      let next = peek(i + 1)
      if next.type in scripts {
        if not next.type in positions {
          //positions.insert(type, expr)
          continue
        }
      }

      let formats = (
        "Superscript": (pos: "tr", rem: regex("[\^\;\s\@]")),
        "Subscript": (pos: "br", rem: regex("[\_\;\s\@]")),
        "Above": (pos: "t", rem: regex("[\^\;\s\@]")),
        "Below": (pos: "b", rem: regex("[\_\;\s\@]")),
      )

      let base = positions.remove("inline")
      let args = (:)

      for (mode, expr) in positions.pairs() {
        let (pos, rem) = formats.at(mode)
        expr = expr.trim(rem)
        args.insert(pos, ch(expr.trim(regex("[\(\)]"), repeat: false)))
      }

      math.attach(math.limits(base), ..args)
      positions = (:)
    } else if type == "Space" {
      if peek(i - 1).type == "Digits" and peek(i + 1).type == "Elem" {
        expr.replace(" ", sym.space.thin, count: 1)
      } else {
        " "
      }
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
      let size = 100% + 1em
      if args.len() == 0 {
        size = 2em
      }
      $stretch(#arrow, size: size)^above_below$
    } else if type == "Gaseous" {
      expr.replace("^", sym.arrow.t).replace(regex("\@|\;"), "").trim(" ", repeat: false)
    } else if type == "Precipitation" {
      expr.replace("v", sym.arrow.b).replace(regex("\@|\;"), "").trim(" ", repeat: false)
    } else if type == "Text" {
      eval(mode: "markup", expr.trim("\""), scope: scope)
    } else if type == "Math" {
      eval(mode: "math", expr.trim("$"), scope: scope)
    }
    results.push(out)
  }
  $results.sum()$
}

