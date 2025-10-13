#import "@preview/mantys:1.0.2": *
#import "@local/chemformula:0.1.0": ch
#show: mantys(
  ..toml("../typst.toml").package,

  title: ch("CH$e$m^$f$;o;r$mu$uLa_\"0.1.0\""),
  // subtitle: "Tagline",
  date: datetime.today(),

  // url: "",

  abstract: [
    #lorem(50)
  ],

  examples-scope: (
    scope: (ch: ch),
    imports: (:),
  ),
)



= Elemental

```example 
#ch("CH3COOH G^((de)3H)")
```



/// Helper for Tidy-Support
/// Uncomment, if you are using Tidy for documentation
// #let show-module(name, scope: (:), outlined: true) = tidy-module(
//   read(name + ".typ"),
//   name: name,
//   show-outline: outlined,
//   include-examples-scope: true,
//   extract-headings: 3,
// )
