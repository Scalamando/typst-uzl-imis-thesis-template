#import "/template/utils.typ": *

= Das Template

== Struktur

_/acronym.typ_ Akronyme festgelegt.
#ac("VR")

_/abstract.typ_ DE und ENG Variante vom abstract

_/foreword.typ_ Vorbemerkungen falls benötigt

_/glossar.typ_ glossar einträge definieren @thumbstick:pl

_/literature.bib_ Literatur im BibLatex Format (Zotero + Better Bibtex Plugin mit Auto Export wird sehr empfohlen)

_/software.typ_ Für die Arbeit verwendete Software (nicht immer notwendig)


== Referenzieren <chap::intro:ref>

Abschnitte referenzieren @chap::intro:ref

```typ
@chap::intro:ref
```
#line(length: 100%)

Abbildung referenzieren @fig:figure-a

```typ
@fig:figure-a
```

#figure(
  image("../template/imis-logo.png", width: 80%),
  caption: [
    A step in the molecular testing
    pipeline of our lab.
  ],
) <figure-a>
#line(length: 100%)
Anhang referenzieren

```typ
@anhang-x
```

@anhang-x

== utils

Die Utils sind eine Ansammlung an nützlichen funktionen. Diese müssen in jedem File in dem sie verwendet werde importiert werden (siehe Zeile 1 in _/chapter/introduction.typ_)

```typ
#import "/template/utils.typ": *
```

=== Abk.
Verschiedene Funktionen des acrotastic packages werden in kruzform über die Utils bereitgestellt.

```typ
#acf("VR")
```
#acf("VR")

=== Glossar
Verschiedene Funktionen des glossarium packages werden in kruzform über die Utils bereitgestellt.

```typ
@thumbstick:long:pl
```
@thumbstick:long:pl

=== Zitation
Zitationen (prose)

```typ
#tc(<abeele2021>)
```
#tc(<abeele2021>)

=== Text notes

Inline Needs Citation label

```typ
#needs-citation
```
#needs-citation

#line(length: 100%)

```typ
#todo[]
```

#todo[]

#line(length: 100%)

```typ
#todo-b[#lorem(20)]
```
#todo-b[#lorem(20)]

#line(length: 100%)

```typ
#wip[]
#wip-b[#lorem(20)]
```

#wip[]
#wip-b[#lorem(20)]

#line(length: 100%)

```typ
#question[#lorem(20)]
#question[#lorem(20)
  #answer[42]
]
```

#question[#lorem(20)]
#question[#lorem(20)
  #answer[42]
]

#line(length: 100%)

```typ
#done[]
```

#done[]

