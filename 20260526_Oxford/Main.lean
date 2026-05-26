import VersoSlides
import Slides

open VersoSlides

def main (args : List String) : IO UInt32 := do
  let config : Config := { center := false, margin := 0 }
  let rc ← slidesMain (config := config) (doc := %doc Slides) (args := args)
  let outputDir := config.outputDir
  let cssContents ← IO.FS.readFile "../static/custom.css"
  let overrideContents ← IO.FS.readFile "overrides.css"
  IO.FS.writeFile (outputDir / "custom.css") (cssContents ++ "\n" ++ overrideContents)
  let logoBytes ← IO.FS.readBinFile "../static/lean-logo.png"
  IO.FS.writeBinFile (outputDir / "lean-logo.png") logoBytes
  let logoLargeBytes ← IO.FS.readBinFile "../static/lean-logo-large.png"
  IO.FS.writeBinFile (outputDir / "lean-logo-large.png") logoLargeBytes
  let htmlPath := outputDir / "index.html"
  let html ← IO.FS.readFile htmlPath
  let html := html.replace "</head>" "<link rel=\"stylesheet\" href=\"custom.css\">\n    </head>"
  let html := html.replace "Reveal.initialize({" "Reveal.initialize({\n        disableLayout: true,"
  let titleSlideOld := "<section>\n          <h2>\n            AI and mathematics</h2>\n          <p>\n            Kim Morrison</p>\n          <p>\n            Oxford, 26 May 2026\nhttps://tqft.net/talks/20260526-Oxford/</p>\n          </section>"
  let titleSlideNew := "<section class=\"title-slide\">\n          <div class=\"top-area\"><img class=\"logo\" src=\"lean-logo-large.png\" alt=\"Lean Logo\"></div>\n          <div class=\"blue-band\"><h1>AI and mathematics</h1>\n          <div class=\"meta\"><strong>Kim Morrison</strong></div>\n          <div class=\"date\">Oxford | 26 May 2026</div>\n          <div class=\"url\"><a href=\"https://tqft.net/talks/20260526-Oxford/\">tqft.net/talks/20260526-Oxford</a></div>\n          </div></section>"
  let html := html.replace titleSlideOld titleSlideNew
  let slideHeader := "<div class=\"slide-header\"><img src=\"lean-logo.png\" alt=\"Lean\"></div>"
  let html := html.replace "<section>\n" s!"<section>\n          {slideHeader}\n"
  let html := html.replace "<section data-transition=\"fade\">\n" s!"<section data-transition=\"fade\">\n          {slideHeader}\n"
  -- Render the "Lean specialized models" sub-list in two columns.
  let html := html.replace "Lean specialized models</p>\n              <ul>" "Lean specialized models</p>\n              <ul class=\"column-list\">"
  -- Replace any standalone link to the lean-workbench URL with an embedded iframe.
  -- This keys on the URL only — robust to slide reordering and surrounding text edits.
  let workbenchUrl := "https://178-105-254-142.sslip.io/guest-be69b2ca/abc"
  let workbenchSlideOld := "<p>\n            <a href=\"" ++ workbenchUrl ++ "\">" ++ workbenchUrl ++ "</a>\n</p>"
  let workbenchSlideNew := s!"<iframe class=\"workbench-iframe\" src=\"{workbenchUrl}\"></iframe>"
  let html := html.replace workbenchSlideOld workbenchSlideNew
  IO.FS.writeFile htmlPath html
  return rc
