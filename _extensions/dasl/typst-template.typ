#let preprint(
  title: none,
  running-head: none,
  authors: none,
  requestors: none,
  affiliations: none,
  abstract: none,
  github: none,
  keywords: none,
  citation: none,
  date: none,
  version: none,
  branding: none,
  leading: 0.6em,
  spacing: 1em,
  first-line-indent: 0cm,
  linkcolor: rgb(0, 0, 0),
  margin: (x: 3cm, y: 3cm),
  paper: "a4",
  lang: "en",
  region: "US",
  font: ("Times", "Times New Roman", "Arial"),
  fontsize: 11pt,
  section-numbering: none,
  toc: false,
  toc_title: "contents",
  toc_depth: none,
  toc_indent: 1.5em,
  bibliography-title: "References",
  bibliography-style: "apa",
  cols: 1,
  col-gutter: 4.2%,
  doc,
) = {

  /* Document settings */

  // Set link and cite colors
  show link: set text(fill: linkcolor)
  show cite: set text(fill: linkcolor)

  // Allow custom title for bibliography section
  set bibliography(title: bibliography-title, style: bibliography-style)

  // Format author strings here
  let author_strings = ()
  if authors != none {
    for a in authors {
      let author_string = [
        #a.name#super[#a.affiliation]
        #if a.keys().contains("orcid") {
            box(
              height: 1em,
              link(
                a.orcid, 
                figure(
                  image("orcid.svg", height: 0.9em)
                )
              )
            )
          } \
        #a.email \
        ]
      author_strings.push(author_string)
    }
  }

  // Format requestor strings here
  let requestor_strings = ()
  if requestors != none {
    for r in requestors {
      let requestor_string = [
        #r.name#super[#r.affiliation]
        #if r.keys().contains("orcid") {
            box(
              height: 1em,
              link(
                r.orcid, 
                figure(
                  image("orcid.svg", height: 0.9em)
                )
              )
            )
          } \
        #r.email \
        ]
      requestor_strings.push(requestor_string)
    }
  }

  // Page settings (including headers & footers)
  set page(
    paper: paper, 
    margin: margin,
    numbering: "1",
    header-ascent: 50%,
    header: locate(
        // Page 1 header can include citation and branding
        loc => if [#loc.page()] == [1] {
          set align(left)
          set text(size: 0.85em)
          box(
            inset: 0.2em,
            if branding == "hutch" {
              image("data-science-lab.png", width: 20em)
            }
          )
        } else {
          // Page >1 header has running head and page number
          grid(
            columns: (1fr, 1fr),
            align(left)[#running-head],
            align(right)[#counter(page).display()]
          )
        }
    ),
    footer-descent: 24pt,
    footer: locate(
        // could put something on front page 
        loc => if [#loc.page()] == [1] {
                    box(
            inset: 0.2em,
            [
                  
            #if github != none {
              let (repo) = "https://github.com/" + github
              grid(
                columns: (5%,95%), 
                gutter: 0%, 
                [#image("github-mark.svg", width: 1em) ], 
                repo
                )
                }
    
            ]
          )
        } else {
          []
        }
    )
  )
  
  // Paragraph settings
  set par(
    justify: true, 
    leading: leading,
    first-line-indent: first-line-indent
  )
  // Set space between paragraphs
  show par: set block(spacing: spacing)

  // Text settings
  set text(
    lang: lang,
    region: region,
    font: font,
    size: fontsize
  )

  // Headers
  set heading(
    numbering: section-numbering
  )
  // Level 1 headers
  show heading.where(
    level: 1
  ): it => block(width: 100%, below: 1em, above: 1.25em)[
    #set align(center)
    #set text(size: fontsize*1.1, weight: "bold",fill: rgb("#1B365D"))
    #it
  ]
  // Level 2 headers
  show heading.where(
    level: 2
  ): it => block(width: 100%, below: 1em, above: 1.25em)[
    #set text(size: fontsize*1.05, fill: rgb("#0a799a"))
    #it
  ]
  // Level 3 headers
  show heading.where(
    level: 3
  ): it => block(width: 100%, below: 0.8em, above: 1.2em)[
    #set text(size: fontsize, style: "italic")
    #it
  ]
  // Level 4 headers are in paragraph
  show heading.where(
    level: 4
  ): it => box(
    inset: (top: 0em, bottom: 0em, left: 0em, right: 1em), 
    text(size: 1em, weight: "bold", it)
  )
  // Level 5 headers are in paragraph
  show heading.where(
    level: 5
  ): it => box(
    inset: (top: 0em, bottom: 0em, left: 0em, right: 1em), 
    text(size: 1em, weight: "bold", style: "italic", it)
  )

  /* Content front matter */

  let titleblock(
    body, 
    width: 100%, 
    size: 1.5em, 
    fill: rgb("#1B365D"),
    weight: "bold", 
    above: 1em, 
    below: 0em
  ) = [
    #align(center)[
      #block(width: width, above: above, below: below)[
        #text(weight: weight, size: size, fill: fill)[#body]
      ]
    ]
  ]

  if title != none {
    titleblock(title)
  }
  
  if date != none {
    titleblock(
      weight: "regular", size: 1em, fill: black,
      [Date: #date]
      ) 
    }
  if version != none {
    titleblock(
      weight: "regular", size: 1em, fill: black,
      [Version: #version]
    )
  }
  
// Authors and Requestors

  block(width: 100%, above: 1em, below: 0em)[
    
    #columns(2)[
    #align(left)[
      #set text(weight: "bold", fill: rgb("#0a799a"), size: 1.2em)
      Authors
      
      #if authors != none {
        set text(size: 0.8em, fill: black, weight: "regular")
        author_strings.join()
      }
      ]
    
    #colbreak()
    
    #align(right)[
      #if requestors != none {
        set text(weight: "bold", fill: rgb("#0a799a"), size: 1.2em)
        [Prepared for]
        set text(size: 0.8em, fill: black, weight: "regular")
        requestor_strings.join()
        } 
        ]
    ]
  ]

  block(width: 100%, above: 2em, below: 0em)[
  
    #align(left)[
      #if affiliations != none {
        for a in affiliations [
          #super[#a.id]#a.name#if a.keys().contains("department") [, #a.department] \
          ]
      }
    ]
  ]

 
  // Abstract and keywords block
  block(inset: (top: 2em, bottom: 0em, left: 2.4em, right: 2.4em))[
    #set text(size: 0.92em)
    #if abstract != none {
      line(length: 100%, stroke: 0.5pt + rgb("#00ABC8"))
      abstract
      line(length: 100%, stroke: 0.5pt + rgb("#00ABC8"))
    }
    #if keywords != none {
      [#v(0.4em)#text(style: "italic")[Keywords:] #keywords]
    }
  ]

  // Table of contents
  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(inset: (top: 2em, bottom: 0em, left: 2.4em, right: 2.4em))[
      #outline(
        title: toc_title,
        depth: toc_depth,
        indent: toc_indent
      )
    ]
  }

  /* Content */

  // Separate content a bit from front matter
  v(2em)
  
  // Show document content with cols if specified
  if cols == 1 {
    doc
  } else {
    columns(
      cols, 
      gutter: col-gutter, 
      doc
    )
  }

}

// Remove gridlines from tables
#set table(
  inset: 6pt,
  stroke: none
)
