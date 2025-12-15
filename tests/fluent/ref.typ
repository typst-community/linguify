#let de = smallcaps("DE:")
#let en = smallcaps("EN:")

#let data = toml("lang.toml")

#let path = data.ftl.at("path", default: "./l10n")
#(data.lang = data.ftl.languages.map(lang => {
  (lang, read(path + "/" + lang + ".ftl"))
}).to-dict())

*Data: *
#box(fill: luma(240), radius: 5pt, inset: 0.8em)[#data]

= Greetings
- Hello, Lore!
- Hello, Pete!
- test


= Headings
#set heading(numbering: "1.a.")
```typc
#set heading(numbering: "1.a.")
```

Your document has 0 headings.

#[
  #set text(lang: "de")
  #de Dein Dokument hat keine Überschriften.
]

= Head

Your document has 1 heading.

#[
  #set text(lang: "de")
  #de Dein Dokument hat eine Überschrift.
]

= Head

Your document has 2 headings.

#[
  #set text(lang: "de")
  #de Dein Dokument hat 2 Überschriften.
]
