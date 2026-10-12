

#let custom-letter(
  // -- Path Management --
  image-dir: ".", 
  
  // -- Images --
  header-image: none, 
  signature-image: none, 
  
  // -- Sender/Recipient --
  sender-name: none, 
  sender-title: none,
  recipient: none,           // The person's name (e.g., "John Doe")
  recipient-address: none,   // The mailing address block
  date: none, 
  subject: none, 
  
  // -- Content --
  body
) = {
  // 1. Branding Color
  let forest-green = rgb(34, 139, 34)

  // 2. Helper: Path Joiner
  // Pandoc escapes markup characters (e.g. "\_") in metadata strings; undo that.
  let unescape(s) = if s == none { none } else { s.replace("\\", "") }
  let resolve-path(filename) = {
    let filename = unescape(filename)
    let dir = unescape(image-dir)
    if filename == none { none } 
    else if dir == none or dir == "" { filename }
    else { dir + "/" + filename }
  }

  // 3. Page Setup
  set page(
    paper: "us-letter",
    margin: (x: 0.8in, top: 1.6in, bottom: 1in),
    
    header: context {
      let img-path = resolve-path(header-image)
      
      if img-path != none {
        set align(left)
        image(img-path, width: 100%) 
        v(5pt)
        line(length: 100%, stroke: 2pt + forest-green)
      }
    },
    header-ascent: 10%,

    footer: context {
      line(length: 100%, stroke: 2pt + forest-green)
      v(1pt)
      set text(size: 9pt, font: "New Computer Modern")
      grid(
        columns: (1fr, auto),
        if subject != none { subject } else { "" },
        [p. #counter(page).display()/#counter(page).final().first()]
      )
    }
  )

  // 4. Text Styles
  set list(indent: 2em)
  set enum(indent: 2em)
  set text(font: "New Computer Modern", size: 11pt)
  set par(justify: true, leading: 0.65em, first-line-indent: 1.5em)
  show link: underline
  show link: set text(fill: blue)  
  show ref: set text(fill: blue)
  show cite: set text(fill: blue)
  // 5. Document Metadata
  if date != none and date != "" {
    align(right, date)
    v(1em)
  } else {
    // FALLBACK: Use Typst's native system date formatted cleanly
    align(right, datetime.today().display("[month repr:long] [day], [year]"))
    v(1em)
  }

  // Changed to recipient-address
  if recipient-address != none {
    block(width: 100%, {
      set text(font: ("Arial")) 
      recipient-address
    })
    v(0.1em)
  }

  if subject != none {
    align(center, text(size: 1.2em, weight: "bold")[Subject: #subject])
    v(0.1em)
  }

  // 5.5 Greeting Block
  if recipient != none and recipient != "" {
    // Using a block ensures it remains unindented. Asterisks add bolding.
    block(width: 100%, [*Dear #recipient,*])
    v(0.5em)
  }

  // 6. Body
  body
  // 7. Signature Block
  if sender-name != none and sender-name != "" {
    v(0.1em)
    align(right, block(width: 50%, breakable: false, {
      set align(left)
      
      // Determine the image beforehand
      let sig-path = resolve-path(signature-image)
      let sig-img = if sig-path != none { image(sig-path, height: 3em) }
      
      // Use a stack to layout the block without paragraph semantics
      stack(
        dir: ttb,          // Top-to-bottom
        spacing: 0.5em,    // Consistent gap between all items
        
        [*Sincerely,*],
        sig-img,
        [*#sender-name*],
        if sender-title != none and sender-title != "" { sender-title }
      )
    }))
  }
}


// ALIAS: Required for Quarto to detect this as a template
#let article = custom-letter
