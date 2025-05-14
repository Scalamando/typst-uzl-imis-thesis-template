// Go ahead and customize it to your liking!
// It takes your content and some metadata and formats it.
// The project function defines how your document looks.
#import "@preview/acrostiche:0.5.1"
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.8": *
#import "@preview/drafting:0.2.0"
#import "@preview/glossy:0.7.0"
#import "@preview/hydra:0.4.0" // Maybe later, doesn't work very well atm
#import "@preview/i-figured:0.2.4"
#import "@preview/icu-datetime:0.1.2": fmt-date
#import "@preview/outrageous:0.4.0"
#import "@preview/alexandria:0.2.0": *
#import "/acronyms.typ": acronyms
#import "/glossar.typ": glossar-list
#import "internal.typ"
#import "utils.typ"


#let (margin-left, margin-top, margin-right, margin-bottom) = (
  3.5cm,
  3.5cm,
  2.5cm,
  4cm,
)

/// Produces a new thesis template.
///
/// - title (de: str, eng: str): title of this thesis
/// - author (str): author of this thesis
/// - support (str): the professor responsible for this thesis
/// - support (str): who supported you with writing this thesis
/// - date (datetime): finalized date of this thesis, defaults to today
/// - abstract (de: content, eng: content): abstract of this thesis
/// - keywords (de: str, eng: str): keywords belonging to this thesis
#let thesis(
  title: (de: "", eng: ""),
  thesis-type: "",
  author: "",
  prof: "",
  support: "",
  company: (show-company: true, name: ""),
  date: datetime.today(),
  abstract: (de: "", eng: ""),
  keywords: (de: "", eng: ""),
  print: false,
  one-sided: true,
  body,
) = {
  // Set the document's basic properties.
  set document(author: author, title: title.de)
  // Temporary settings for the Title page
  set page(
    paper: "a4",
    margin: (
      left: margin-right, // same as right for title page
      right: margin-right,
      top: margin-top,
      bottom: margin-bottom,
    ),
  )

  // --- alexandria bib Package Setup ---
  show: alexandria(prefix: "r-", read: path => read(path))
  show: alexandria(prefix: "n-", read: path => read(path))


  // --- glossy Package Setup ---
  show: glossy.init-glossary.with(glossar-list)

  // --- Acrostiche (Achronyms) Package Setup ---
  acrostiche.init-acronyms(acronyms)

  // --- Drafting Package Setup ---
  drafting.set-page-properties(
    margin-left: margin-left,
    margin-right: margin-right,
  )

  // --- Codly Package Setup ---
  show: codly-init
  codly(
    zebra-fill: color.hsl(0deg, 0%, 98%),
    stroke: 1pt + color.hsl(0deg, 0%, 85%),
  )

  // --- Headings and Numbering ---
  // Only do numbering for the first three levels (e.g. 1.1.1, but not 1.1.1.1)
  set heading(
    numbering: (..nums) => {
      if nums.pos().len() < 4 {
        numbering("1.1", ..nums)
      }
    },
  )

  // References to level 1 headings should say 'Kapitel'
  show heading.where(level: 1): set heading(supplement: [Kapitel])

  // Enable numbering for bibliography
  show bibliography: set heading(numbering: "1")

  // Figure numbering per chapter

  show figure: i-figured.show-figure
  show figure.caption: c => context [
    #set text(size: 0.9em, hyphenate: false)
    #text(weight: "bold")[#c.supplement #c.counter.display(c.numbering)]#c.separator#c.body
  ]
  set figure(placement: auto)
  set place(clearance: 2em)


  // --- General Typography and Style ---
  set par(leading: 0.85em) // Line Height
  set text(
    font: "Linux Libertine",
    lang: "de",
    size: 12pt,
    hyphenate: auto,
  )
  // hide acronym links
  show link: it => {
    if type(it.dest) == label or print {
      it
    } else {
      underline[#it]
    }
  }

  //show heading: set text(font: "Atkinson Hyperlegible")

  // -- Content --
  
  // define if company text is shown
  let company-text(company-name) = if company.show-company {
    text(
      "Die Arbeit ist im Rahmen einer Tätigkeit bei der Firma " + 
      company-name + 
      " entstanden."
    ) 
  }

  // --- Title Page ---
  align(center)[
    #set par(leading: 0.65em, spacing: 0.85em) // Line Height

    #image("imis-logo.png")

    #v(3em, weak: true)

    #par(
      text(
        title.de,
        weight: 700,
        size: 1.75em,
      ),
      leading: 0.6em,
    ) #v(1.5em, weak: true)

    #par(
      text(
        title.eng,
        weight: 400,
        size: 1.25em,
      ),
    ) #v(3.5em, weak: true)

    *#thesis-type* #v(1.5em, weak: true)

    im Rahmen des Studiengangs \ *Medieninformatik* \ der Universität zu Lübeck

    #v(3em, weak: true)

    vorgelegt von:

    *#author*

    #v(3em, weak: true)

    ausgegeben und betreut von:

    *#prof*

    #v(2em, weak: true)

    mit Unterstützung von:

    *#support*

    #v(2em, weak: true)

    #company-text(company.name)

    #v(3em, weak: true)
    

    Lübeck, #date.display("[day padding:none]. [month repr:long] [year]")
  ]

  if not one-sided {
    pagebreak(to: "odd")
  }

  // Justify paragraphs and add one line of spacing between paragraphs
  set par(justify: true, spacing: 2em)

  // Setup page for the rest of the thesis
  set page(
    header: context {
      let page-is-odd = calc.odd(here().page())
      if one-sided or page-is-odd {
        align(right, counter(page).display("i"))
        v(-1em)
        line(length: 100%, stroke: color.hsl(0deg, 0%, 70%))
      }
    },
    margin: if one-sided {
      (
        left: margin-left,
        right: margin-right,
        top: margin-top,
        bottom: margin-bottom,
      )
    } else {
      (
        inside: margin-left,
        outside: margin-right,
        top: margin-top,
        bottom: margin-bottom,
      )
    },
  )

  // Initial Drafting Package Setup
  if one-sided {
    drafting.set-page-properties()
  } else {
    drafting.set-margin-note-defaults(hidden: true)
  }


  // --- Abtract ---
  [
    // Change heading style only for this block
    #set heading(numbering: none, outlined: false)
    #show heading.where(level: 1): set heading(bookmarked: true)
    #show heading.where(level: 1): it => [
      #v(1.5em)
      #it
      #v(1.5em)
    ]
    #show heading.where(level: 2): it => [
      #v(1.5em)
      #it
      #v(0.75em)
    ]

    = Kurzfassung
    #abstract.de

    == Schlüsselwörter
    #keywords.de.split(regex(",\s?")).join("\n")

    #if one-sided {
      pagebreak()
    } else {
      pagebreak(to: "odd")
    }

    = Abstract
    #abstract.eng

    == Keywords
    #keywords.eng.split(regex(",\s?")).join("\n")

    #if one-sided {
      pagebreak()
    } else {
      pagebreak(to: "odd")
    }

    // -- Foreword --
    //
    // Include custome foreword
    #include "../foreword.typ"

    #if one-sided {
      pagebreak()
    } else {
      pagebreak(to: "odd")
    }
  ]

  // --- Table of Contents ---
  {
    show heading.where(level: 1): it => [
      #pagebreak(weak: true)
      #text(size: 1.5em, pad(it, top: 0.5em))
      #v(1em)
    ]
    show outline.entry: outrageous.show-entry.with(
      ..outrageous.presets.typst,
      font-weight: (700, 400),
      vspace: (2em, 1em),
    )
    outline(depth: 3)
  }


  // Reset page counter for main part
  counter(page).update(0)

  // -- Main body --
  set page(
    numbering: none,
    footer: context if one-sided {
      none
    } else {
      let loc = locate(here())
      if not internal.page-is-inserted(loc) {
        let page-is-odd = calc.odd(here().page())
        align(
          if page-is-odd {
            right
          } else {
            left
          },
          counter(page).display("1"),
        )
      }
    },
    header: context {
      let loc = locate(here())
      if not internal.page-is-inserted(loc) {
        let hydra-heading-1 = hydra.hydra(1)
        if one-sided {
          grid(
            columns: (1fr, 12pt),
            rows: auto,
            align(
              left,
              hydra-heading-1,
            ),
            align(right, counter(page).display()),
          )
        } else {
          let hydra-heading-2 = hydra.hydra(2)
          let page-is-odd = calc.odd(here().page())
          if page-is-odd {
            grid(
              columns: 1fr,
              rows: auto,
              align(
                right,
                if hydra-heading-2 != none {
                  hydra-heading-2
                } else {
                  hydra-heading-1
                },
              ),
            )
          } else {
            grid(
              columns: 1fr,
              rows: auto,
              align(
                left,
                hydra-heading-1,
              ),
            )
          }
        }
        v(-0.7em)
        if hydra-heading-1 != none {
          line(length: 100%, stroke: color.hsl(0deg, 0%, 70%))
        }
      }
    },
  )

  // Style lists and enums
  set list(indent: 1em)
  set enum(indent: 1em)

  // Style Tables
  show table: set text(font: "inter")
  show table.cell: it => {
    if it.y == 0 {
      set text(white)
      it
    } else {
      it
    }
  }
  set table(
    stroke: 0.5pt + gray.darken(20%),
    fill: (_, y) => if y == 0 {
      gray.darken(40%)
    } else if calc.odd(y) {
      gray.lighten(80%)
    },
  )


  {
    // Body Heading styles
    show heading.where(level: 1): it => (
      context [
        #if one-sided {
          pagebreak(weak: true)
        }
        #text(
          size: 1.65em,
          pad(
            [
              #set par(leading: 0.75em)
              #text(
                counter(heading).display(),
                size: 72pt,
                fill: color.hsl(0deg, 0%, 60%),
              ) \
              #it.body
            ],
            top: 4em,
          ),
        )
        #i-figured.reset-counters(it, return-orig-heading: false)
        #v(2em)
      ]
    )
    show heading.where(level: 2): it => [
      #v(1.5em)
      #text(size: 1.25em, it)
      #v(1.5em)
    ]
    show heading.where(level: 3): it => [
      #v(1em)
      #text(size: 1.25em, it)
      #v(1em)
    ]
    show heading.where(level: 4): it => [
      #v(1em)
      #it
      #v(0.75em)
    ]

    context if not one-sided {
      show: internal.prepend-headers
      counter(page).update(1)

      let chapter-end-markers = query(<chapter-end-marker>)
      let chapter-start-markers = query(<chapter-start-marker>)
      let pairs = chapter-end-markers
        .enumerate()
        .map((
          (index, chapter-end-marker),
        ) => {
          let chapter-start-marker = chapter-start-markers.at(index)
          let end-page = chapter-end-marker.location().page()
          let start-page = chapter-start-marker.location().page()
          (end-page, start-page)
        })
      state("chapter-markers").update(pairs)

      body
    } else {
      body
    }
  }

  // Hide heading numbering
  set heading(numbering: none)
  show heading.where(level: 1): it => [
    #pagebreak(weak: true)
    #text(size: 1.5em, pad(it, top: 0.5em))
    #v(2em)
  ]
  show heading.where(level: 2): it => [
    #v(1.5em)
    #text(size: 1.25em, it)
    #v(1.5em)
  ]

  // -- Bibliography --
  load-bibliography(
    "../bibliography/references.bib",
    prefix: "r-",
    full: false,
    style: "apa",
  )

  context {
    let (references, ..rest) = get-bibliography("r-")

    render-bibliography(
      title: [Literatur],
      (
        references: references.filter(r => r.details.type != "misc"),
        ..rest,
      ),
    )

    render-bibliography(
      title: [Online-Quellen],
      (
        references: references.filter(r => r.details.type == "misc"),
        ..rest,
      ),
    )
  }

  bibliographyx(
    "../bibliography/normen.bib",
    prefix: "n-",
    title: "Normen",
    full: false,
    style: "apa",
  )

  // -- Software --

  include "/software.typ"

  // Glossar and acronyms
  [
    // Change heading style only for this block
    #show heading.where(level: 1): it => [
      #if one-sided {
        pagebreak()
      } else {
        pagebreak(to: "odd")
      }
      #v(1.5em)
      #it
      #v(1.5em)
    ]
    #show heading.where(level: 2): it => [
      #v(1.5em)
      #it
      #v(0.75em)
    ]

    // --- Table of Acronyms ---
    #if (acronyms.len() > 0) {
      acrostiche.print-index(
        title: [Abkürzungen],
        delimiter: "",
        outlined: true,
        sorted: "up",
        row-gutter: 1em,
      )
    }

    // --- Glossar ---
    #glossy.glossary(title: "Glossar", sort: true)
  ]

  // -- Addendum --
  show figure: it => i-figured.show-figure(it, numbering: "A.1")

  // style anpassen

  // Include custom addendum first, show table of figures, etc. afterwards
  {
    show heading.where(level: 2): set heading(
      numbering: (
        first,
        ..numbers,
      ) => if numbers.pos().len() > 0 {
        numbering("A", ..numbers)
      },
      supplement: [Anhang],
    )
    counter(heading).update(1)
    include "/addendum/addendum.typ"
  }

  show outline: set heading(outlined: true)
  show outline.entry.where(level: 1): it => {
    v(0.25em)
    it
  }

  // --- Table of Images/Tables/Listing ---
  i-figured.outline(
    target-kind: image,
    title: [Abbildungsverzeichnis],
  )
  i-figured.outline(target-kind: table, title: [Tabellenverzeichnis])


  set page(header: none, footer: none)
  if one-sided {
    pagebreak()
  } else {
    internal.pagebreak-to-odd
  }

  // --- Eidesstattlicheerklärung ---
  [
    #heading(text([Erklärung], size: 20pt), outlined: false, numbering: none)

    Ich versichere an Eides statt, die vorliegende Arbeit selbstständig verfasst und nur die angegebenen Quellen benutzt zu haben.

    #v(8em)

    #line(length: 50%, stroke: color.hsl(0deg, 0%, 50%))
    #v(-1.0em)
    #author.replace("B.Sc.", "") // Remove title for the signature

    #v(1em)

    Lübeck, #fmt-date(date, locale: "de", length: "long")
  ]
}

