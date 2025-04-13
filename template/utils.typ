#import "@preview/drafting:0.2.0"
#import "@preview/acrostiche:0.5.1"

// This file contains common utilities for use in this thesis template

/// Adds a side-note
///
/// - body (content): the notes content
/// - ..kwargs (dictionary): accepts all margin-note options of the drafting package
#let note(body, ..kwargs) = {
  set text(size: 10pt, font: "Atkinson Hyperlegible")
  drafting.margin-note(body, ..kwargs)
}

#let x-label(
  name,
  supplement: [],
) = place[#figure(supplement: supplement, kind: "hidden")[]#label(name)]

#let ff(num) = {
  link(<ff>)[F#num]
}

#let ffcounter = counter("forschungsfrage")
#let forschungsfrage(body, num: 0) = block(breakable: false)[
  #if num == 0 {
    ffcounter.step()
  }
  #stack(
    dir: ltr,
    spacing: 8pt,
    [*F#if num != 0 { num } else { context ffcounter.display() }*],
    line(angle: 90deg, length: 11pt),
    block(width: 93%, body),
  )
]

/// Returns an acronoym defined in `acronoyms.typ`. The first mention of the
/// acronym will include it's fully qualified form.
///
/// - label (str): label of the acronym
///
/// acrostiche package
/// https://typst.app/universe/package/acrostiche/
///
#let ac(label) = {
  acrostiche.ac(label)
}

#let acs(label) = {
  acrostiche.acs(label)
}

#let acp(label) = {
  acrostiche.acp(label)
}

#let acl(label) = {
  acrostiche.acl(label)
}

#let aclp(label) = {
  acrostiche.aclp(label)
}

#let acf(label) = {
  acrostiche.acf(label)
}

#let acfp(label) = {
  acrostiche.acrfp(label)
}

// Note

#let icon(codepoint) = {
  box(
    height: 1em,
    baseline: 0.15em,
    image(codepoint),
  )
  h(0.25em)
}

#let note(body, title: "NOTE", tone: yellow, inline: true) = {
  set text(font: "New Computer Modern", weight: "regular", size: 0.8em)

  let fg = tone.lighten(20%)
  let bg = tone.lighten(80%)
  let pad = 0.35em

  if inline {
    set text(size: 0.9em)
    box(
      text(title, weight: "extrabold", fill: white),
      fill: fg,
      stroke: fg + 1pt,
      outset: (y: pad),
      inset: (x: pad),
      radius: if body == [] {
        0.25em
      } else {
        (left: 0.25em)
      },
    )
    if body != [] {
      box(
        body,
        fill: bg,
        stroke: fg + 1pt,
        outset: (y: pad),
        inset: (x: pad),
        radius: (right: 0.25em),
      )
    }
  } else {
    context {
      let note-text = text(title, weight: "extrabold", fill: white)
      let note-rect = rect(
        note-text,
        fill: fg,
        stroke: fg + 1pt,
        radius: (left: 0.25em),
      )
      block(
        [
          #place(
            note-rect,
            dx: -5pt - measure(note-rect).width,
            dy: -5pt,
          )
          #body
        ],
        fill: bg,
        stroke: fg + 1pt,
        inset: 5pt,
        radius: (top-left: 0em, rest: 0.25em),
        width: 100%,
      )
    }
  }
}


// Text Citation Utils
#let tc(label, supplement: none) = {
  cite(label, form: "prose", supplement: supplement)
}

#let tcc(labels, supplement: none)= {
  let author = cite(labels.at(0), form: "author", supplement: none)
  let years = labels
    .map(label => cite(label, form: "year", supplement: none))
    .join(", ")

  author + " (" + years + ")"
}

#let mc(labels, supplement: none) = {
  // create array of author and year arrays for input labels
  let citations = labels.map(label => {
    // check for single or combined reference
    if type(label) != array {
      // return author and year from label
      let author = cite(label, form: "author", supplement: none)
      let year = cite(label, form: "year", supplement: none)
      return (author, year)
    } else {
      // return author and years from label array
      let author = cite(label.at(0), form: "author", supplement: none)
      let years = label
        .map(sublabel => cite(sublabel, form: "year", supplement: none))
        .join(", ")
      return (author, years)
    }
  })
  .map(tuple => tuple.join(", ")) // connect author and year(s) per array

  // show citation
  "(" + citations.join("; ") + ")"
}


// Text Status Tools (WIP, ToDo)


#let needs-citation = {
  note([], title: "CITATION", tone: red)
}

#let todo(body, inline: true) = {
  note(body, title: "To-Do", tone: orange, inline: inline)
}

#let todo-b(body) = {
  todo(body, inline: false)
}

#let wip(body, inline: true) = {
  note(body, title: "WIP", tone: blue, inline: inline)
}

#let wip-b(body) = {
  wip(body, inline: false)
}

#let question(body) = {
  note(body, title: "Question", tone: purple, inline: false)
}

#let answer(body) = {
  note(body, title: "Answer", tone: green, inline: false)
}

#let done(body) = {
  note(body, title: "Done", tone: green, inline: true)
}

