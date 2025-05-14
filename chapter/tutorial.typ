#import "/template/utils.typ": *
#import "@preview/alexandria:0.2.0": *

= Das Template

== Struktur

Im Folgenden ist die Struktur des Projektes aufgeführt.

```txt
../
|- addendum/            Anhang
|   |- addendum.typ
|
|- bibliography/
|   |- references.bib   alle Quellen bis aus Normen
|   |- normen.bib       Normen werden hier definiert
|
|- chapter/             Directory für alle Kapitel
|   |- introduction.typ 
|
|- template/
|   |- imis-logo.png
|   |- internal.typ
|   |- thesis.typ       Template des Dokuments
|   |- utils.typ        Sammlung nützlicher Funktionen
|
|- acronym.typ          Definition von Abkürzungen
|- abstract.typ         DE und ENG Variante des abstracts
|- foreword.typ         Vorbemerkung falls benötigt
|- glossar.typ          Definition von Begriffen
|- software.typ         Verwendete Software (nicht immer notwendig)

```

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

== Literatur
Das Literaturverzeichnis sollte dem aktuellsten APA Standard entsprechen, 
solange mit der Betreuer:in nichts anderes vereinbart wurde. In Typst können 
Quellen über .bib Dateien eingebunden werden. Im Ordner _\/bibliography_
können neue Einträge in den Dateien _references.bib_
(alle Quellen bis auf Normen) und _normen.bib_ (nur Normen) hinzugefügt werden.
Das Literaturverzeichnis wird automatisch erstellt, sobald die Quellen im Text 
verwendet werden.

Typst selbst unterstützt aktuell keine Unterteilung des 
Literaturverzeichnisses in mehrere Bereiche, um beispielsweise Online-Quellen 
gesondert aufzuführen. Hierzu wird das Package 
Alexandria#footnote[https://github.com/SillyFreak/typst-alexandria] verwendet.
Wichtig zu beachten ist, dass Normen in _normen.typ_ definiert werden müssen 
und alle anderen Quellen in _references.typ_ damit sie im entsprechenden Bereich 
auftauchen. Zusätzlich muss für Online-Quellen der korrekte Typ (\@misc) 
genutzt werden. Für das Zitieren im Text ist darauf zu achten die Präfixe 
_n-_ für Normen und _r-_ für alle anderen Quellen zu nutzen.

Im Text gibt es folgende Möglichkeiten Quellen zu zitieren:\
*1. Parenthical citation:*\
```typ
Im Vergleich zu SAGAT @r-endsley_situation_1988 ...
```
rendert zu: _Im Vergleich zu SAGAT @r-endsley_situation_1988 ..._

*2. Narrative citation:*\
```typ
#tc(<r-abeele2021>) diskutieren, dass ...
```
rendert zu: _ #tc(<r-abeele2021>) diskutieren, dass ..._

*3. Collapsed citation:*\
```typ
#citegroup(prefix: "r-")[@r-endsley_situation_1988 @r-endsley_systematic_2021 @r-Nielsen1990 @r-abeele2021]
```
rendert zu: _Irgendeine Aussage #citegroup(prefix: "r-")[@r-endsley_situation_1988 @r-endsley_systematic_2021 @r-Nielsen1990 @r-abeele2021] ..._

*Wichtig:* Anders als bei der Standard Zitierweise muss in diesem Template für das 
Zitieren von Normen das Präfix _n-_ vor die Quelle gesetzt werden. Für alle 
anderen Quellen muss das Präfix _r-_ genutzt werden.

Je nach zitierter Dokumentsorte, sieht die Referenz im Literaturverzeichnis 
anders aus:

- Beispiel für einen Konferenzband @r-Nielsen1990
- Beispiel für einen Journal-Artikel @r-hollan2000
- Beispiel für ein Buch @r-zobel2014writing
- Beispiel für eine Norm @n-ISO9241
- Beispiel für eine Webseite @r-webimis

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
Verschiedene Funktionen des glossarium packages werden in Kurzform über Utils 
bereitgestellt.

```typ
@thumbstick:long:pl
```
@thumbstick:long:pl

=== Zitation
Zitationen eines Papers (prose)

```typ
#tc(<r-abeele2021>)
```
#tc(<r-abeele2021>)


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
