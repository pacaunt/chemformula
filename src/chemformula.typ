#import "parser.typ": *

#let ch(chem, scope: (:), mode: "Inline", scale-paren: true) = {
  //let ch = ch.with(scope: scope, mode: mode) // for recursive evaluation

  if type(chem) == content {
    if chem.func() == raw {
      chem = chem.text
    } else if chem.func() == text {
      chem = chem.text
    }
  }

  let recursive-parse(chem, mode: mode, states: (:)) = {
    let EOT = "@"
    let tokens = parsing-reaction(chem + EOT, mode: mode)

    let peek = peek.with(arr: tokens)
    let positions = (:)
    let attach-mode = "r"
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
            expr = (l, r)
              //.map(p => "" + p)
              .join(
                recursive-parse(expr.trim(regex((l, r).map(p => "\\" + p).join("|")), repeat: false)),
              )
          }
        }
        expr
         .replace(regex("\"*[A-Z][a-z]*\"*"), nuc => {
          "\"" + nuc.text.trim("\"") + "\""
         })
        //$#eval-chem(parsing-chem(expr + EOT), scope: scope)$
      } else if type in scripts {
        let recursive-parse = recursive-parse.with(mode: "Scripts")

        // check if nothing is here.
        if positions.len() == 0 {
          // Start of a string, escaped from space -> attach to the right
          if i == 0 or peek(i - 1).type == "Space" {
            // put the current type
            positions.inline = "\"\""
            attach-mode = "l"
          } else {
            positions.inline = results.pop()
            attach-mode = "r"
          }
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
          "Superscript": (pos: "t" + attach-mode, rem: regex("[\^\;\s\@]")),
          "Subscript": (pos: "b" + attach-mode, rem: regex("[\_\;\s\@]")),
          "Above": (pos: "t", rem: regex("[\^\;\s\@]")),
          "Below": (pos: "b", rem: regex("[\_\;\s\@]")),
        )

        let base = positions.remove("inline")
        let args = (:)
        // let verticles = (:)
        // let horizontals = (:)

        for (mode, expr) in positions.pairs() {
          let (pos, rem) = formats.at(mode)
          expr = recursive-parse(expr.trim(rem))
          args.insert(pos, expr)
          // if pos in ("t", "b") {
          //   verticles.insert(pos, expr)
          // } else {
          //   horizontals.insert(pos, expr)
          // }
        }

        // base = math.attach(math.limits(base), ..verticles)
        (
           "attach(#math.limits($"
            + base
            + "$), "
            + {
              args.pairs().map(((k, v)) => k + ": " + v).join(", ") + ")"
            }
        )
        // if attach-mode == "r" {
        //   base + math.attach("", ..horizontals)
        // } else {
        //   math.attach("", ..horizontals) + base
        // }

        positions = (:)
      } else if type == "Space" {
        if peek(i - 1).type == "Digits" and peek(i + 1).type == "Elem" {
          if expr.len() > 1 { " space " } else { " thin " }
        } else if peek(i - 1).type in scripts {
          if expr.len() > 1 { " space " } else { "" }
        } else {
          if expr.len() > 1 { " space " } else { " " }
        }
      } else if type == "Symbol" {
        expr.replace(regex("\@|\;"), "").replace(regex("\*|\."), sym.dot)
      } else if type == "Arrow" {
        let arrow-toks = parse-arrow(expr)
        let args = ()
        let arrow = ""
        for atok in arrow-toks {
          if atok.type == "Args" { args.push(atok.expr.trim(regex("[\[\]]"))) } else {
            arrow = atok.expr.replace("<=>", sym.harpoons.rtlb)
          }
        }
        args = args.map(txt => "#$" + recursive-parse(txt) + "$")
        let above = args.at(0, default: none)
        let below = args.at(1, default: none)
        let size = "100% + 1em"
        if args.len() == 0 {
          size = "2em"
        }
        " stretch(" + arrow + ", size: #{" + size + "})^(" + above + ")_(" + below + ")"
        //$stretch(#arrow, size: size)^above_below$
      } else if type == "Gaseous" {
        expr.replace("^", sym.arrow.t).replace(regex("\@|\;"), "")
        //.trim(" ", repeat: false)
      } else if type == "Precipitation" {
        expr.replace("v", sym.arrow.b).replace(regex("\@|\;"), "")
        //.trim(" ", repeat: false)
      } else if type == "Text" {
        expr
        // eval(mode: "markup", expr.trim("\""), scope: scope)
      } else if type == "Math" {
        //eval(mode: "math", expr.trim("$"), scope: scope)
        expr.trim("$")
      } else {
        expr
      }
      results.push(out)
    }
    results.sum()
  }
  // recursive-parse(chem)
  eval(mode: "math", recursive-parse(chem), scope: (aq: $a q$))
}

#let ch = ch.with(scope: (ch: ch))

