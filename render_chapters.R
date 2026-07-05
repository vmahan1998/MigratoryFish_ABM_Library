library(rmarkdown)

# --- Word template (optional) ---------------------------------
word_template <- if (file.exists("word_template.docx")) "word_template.docx" else NULL

# --- Image resource paths -------------------------------------
# Pandoc runs from the project root, so relative image paths that point
# into docs/ (or the asset subfolders) won't resolve and images get
# silently dropped from the .docx. List every folder images might live in.
image_dirs <- c(
  getwd(),
  file.path(getwd(), "images"),
  file.path(getwd(), "demos"),
  file.path(getwd(), "materials"),
  file.path(getwd(), "docs"),
  file.path(getwd(), "docs", "images"),
  file.path(getwd(), "docs", "demos"),
  file.path(getwd(), "docs", "materials")
)
image_dirs <- image_dirs[dir.exists(image_dirs)]
resource_args <- unlist(lapply(image_dirs, function(d) c("--resource-path", d)))

# --- Citation support (optional) ------------------------------
pandoc_args <- c("--citeproc", resource_args)

# --- Render each chapter --------------------------------------
chapters <- list.files(pattern = "^\\d+-.+\\.Rmd$")

for (ch in chapters) {
  output_file <- gsub("\\.Rmd$", ".docx", ch)
  output_path <- file.path("docs/chapter_downloads", output_file)
  
  tryCatch({
    render(
      input         = ch,
      output_format = word_document(
        reference_docx = word_template,   # NULL = default styling
        pandoc_args    = pandoc_args
      ),
      output_file   = output_path,
      envir         = new.env()
    )
    message("Rendered: ", output_path)
  }, error = function(e) {
    message("Skipped ", ch, ": ", e$message)
  })
}