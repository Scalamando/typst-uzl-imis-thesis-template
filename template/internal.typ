// --- Internal ---

#let reset-figure-counter(it) = {
  counter(figure.where(kind: "chapfigure-" + repr(image))).update(0)
  counter(figure.where(kind: "chapfigure-" + repr(table))).update(0)
  counter(figure.where(kind: "chapfigure-" + repr(raw))).update(0)
  it
}

#let chapter-figure(it) = {
  if type(it.kind) == str and it.kind.starts-with("chapfigure-") {
    it
  } else {
    let chapter = counter(heading.where(level: 1)).at(it.location()).first()
    let dic = it.fields()
    // Ignores output of dic.remove, errors otherwise
    let _ = if "body" in dic {
      dic.remove("body")
    }
    let _ = if "label" in dic {
      dic.remove("label")
    }
    let _ = if "counter" in dic {
      dic.remove("counter")
    }

    // Unwrap figure kind
    let figkind = if type(it.kind) == str {
      it.kind
    } else {
      repr(it.kind)
    }

    let fig = figure(
      if figkind == "image" {
        box(it.body, radius: 0.25em, clip: true) // Slightly rounded corners for images
      } else { it.body },
      ..dic,
      placement: auto, // important, otherwise figures will be placed 'as-is', leading to large empty spaces before or after them
      numbering: n => numbering("1.1", chapter, n),
      kind: "chapfigure-" + figkind,
    )

    // Build figure label of type '<kind>:<label>' (e.g. 'fig:uml-chart')
    if it.has("label") {
      let new-label = if it.kind == table {
        "tbl"
      } else if it.kind == raw {
        "lst"
      } else {
        "fig"
      }
      new-label += ":" + str(it.label)
      [#fig #label(new-label)]
    } else {
      fig
    }
  }
}

#let pagebreak-to-odd = context {
  let n = here().page()
  if calc.odd(n) {
    page(header: [], footer: [])[]
  } else if calc.even(n) {
    v(100%, weak: true)
  }
}

#let page-is-inserted(loc) = {
  let page = loc.page()
  let pairs = state("chapter-markers").at(loc)
  if pairs == none {
    return false
  }
  // page is inserted if surrounded by end- and start-marker for any chapter
  return pairs.any(((end-page, start-page)) => {
    page > end-page and page < start-page
  })
}

#let prepend-headers(it) = {
  let f = it.func()
  if repr(f) == "sequence" {
    // using repr() because I could not find element function to compare with
    for i in it.children {
      prepend-headers(i)
    }
  } else if repr(f) == "styled" {
    // copy fields style
    let fields = it.fields()
    let child = fields.remove("child")
    let styles = fields.remove("styles")
    f(prepend-headers(child), styles, ..fields)
  } else if f == heading and it.depth == 1 {
    // search for chapter headings
    // insert page breaks to have chapter on odd page, preceded by a blank even page
    [
      #[]<chapter-end-marker> // marker positioned before the pagebreak
      #pagebreak(to: "odd")
      #[]<chapter-start-marker> // marker positioned before the pagebreak
      #it
    ]
  } else {
    it
  }
}
