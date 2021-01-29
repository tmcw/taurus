# taurus

![Screenshot](./taurus.png)

_Authors note_: this is a SwiftUI version of a [Gemini](https://gemini.circumlunar.space/) browser for Mac.
My goals with this project were:

- Be pretty, like iA Writer or other fancy Mac software
- Be native to the macOS experience
- Do this from the ground up - not using any existing browser engine tech.

I'm open sourcing & archiving this project because SwiftUI is a dead-end for this
kind of project right now. A lot of the things I wanted to do, in the current issues,
are blocked upstream by limitations in SwiftUI. So I'm rewriting it in UIKit or Cocoa
or something. macOS development is tricky!

Feel free to fork or rewrite or just read through it if you want. The most interesting
bits are a Swift port of [wooorm's dioscuri parser for the gemtext format](https://github.com/wooorm/dioscuri),
which makes the rest of the project sort of clear. The network layer is very unfinished,
since Gemini's [security model](https://drewdevault.com/2020/09/21/Gemini-TOFU.html) is
a little tricky, and my understanding of how to do that on the mac is fragmentary at best.

---

Basically this project is at the point where it can load a gemini page, show all the kinds
of content in it, navigate to other pages, and open web links in another browser.

Where it started to get hard was just any sort of UI niceity - resetting scroll when going
from one page to another, handling hover and focus states, allowing text selection - all
of these are thoroughly difficult with SwiftUI. Thankfully all of these also have very little
to do with the Gemini-parsing guts of the project, so that part can be reused in the future
project.
