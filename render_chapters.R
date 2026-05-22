library(rmarkdown)

chapters <- list.files(pattern = "^\\d+-.+\\.Rmd$")

for (ch in chapters) {
  output_file <- gsub("\\.Rmd$", ".docx", ch)
  output_path <- file.path("docs/chapter_downloads", output_file)
  
  tryCatch({
    render(
      input       = ch,
      output_format = word_document(
        reference_docx = "word_template.docx"  # optional styling template
      ),
      output_file = output_path,
      envir       = new.env()
    )
    message("Rendered: ", output_path)
  }, error = function(e) {
    message("Skipped ", ch, ": ", e$message)
  })
}