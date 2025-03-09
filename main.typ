#import "template/thesis.typ": *
#import "abstract.typ": *

#let title = (
  de: "Titel einer Qualifikationsarbeit am IMIS der Universität zu Lübeck",
  eng: "Title of a thesis at the IMIS of the University of Lübeck",
)

#show: thesis.with(
  title: title,
  author: "Author B.Sc.",
  prof: "Univ.-Prof. Maxim Mustermensch",
  support: "Bente Betreuer:in",
  print: true,
  one-sided: false,
  abstract: (abstract),
  keywords: (
    de: "Schlüsselwort 1, Schlüsselwort 2, Schlüsselwort 3, Schlüsselwort 4",
    eng: "Keyword 1, Keyword 2, Keyword 3, Keyword 4",
  ),
)

#include "chapter/introduction.typ"
