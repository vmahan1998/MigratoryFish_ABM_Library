# ============================================================
#  build.R
#  Run this script to:
#    1. Install any missing packages
#    2. Render each chapter as a .docx download
#    3. Build the full bookdown site
# ============================================================

# ============================================================
#  build.R
#  Run this script to:
#    1. Install any missing packages
#    2. Register custom knitr engines
#    3. Render each chapter as a .docx download
#    4. Build the full bookdown site
# ============================================================

# ------------------------------------------------------------
# 1. Check and install required packages
# ------------------------------------------------------------

required_packages <- c("rmarkdown", "bookdown", "knitr")

for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message("Installing missing package: ", pkg)
    install.packages(pkg)
  }
}

library(rmarkdown)
library(bookdown)

# ------------------------------------------------------------
# 2. Register custom knitr engines
# ------------------------------------------------------------

knitr::knit_engines$set(netlogo = function(options) {
  code <- paste(options$code, collapse = "\n")
  if (options$eval) {
    knitr::engine_output(options, code, "")
  } else {
    knitr::engine_output(options, code, "")
  }
})

message("Registered custom knitr engine: netlogo")

# ------------------------------------------------------------
# 3. Create output folder for chapter downloads
# ------------------------------------------------------------

download_dir <- "docs/chapter_downloads"

if (!dir.exists(download_dir)) {
  dir.create(download_dir, recursive = TRUE)
  message("Created directory: ", download_dir)
}

# ------------------------------------------------------------
# 4. Read bibliography files from index.Rmd YAML header
# ------------------------------------------------------------

index_lines <- readLines("index.Rmd", warn = FALSE)

bib_start <- grep("^bibliography:", index_lines)
bib_files <- c()

if (length(bib_start) > 0) {
  for (i in (bib_start + 1):length(index_lines)) {
    line <- trimws(index_lines[i])
    # Stop when we hit the next YAML key
    if (grepl("^[a-zA-Z]", line) && !grepl("^-", line)) break
    if (grepl("^-", line)) {
      bib_file <- gsub('^-\\s*"|"$', "", line)
      bib_file <- trimws(bib_file)
      if (file.exists(bib_file)) {
        bib_files <- c(bib_files, bib_file)
        message("Found bibliography: ", bib_file)
      } else {
        message("Warning: bibliography file not found: ", bib_file)
      }
    }
  }
}

message("Total bibliography files loaded: ", length(bib_files))

# Check for a CSL citation style file
csl_file <- list.files(pattern = "\\.csl$")[1]
if (!is.na(csl_file) && length(csl_file) > 0) {
  message("Found CSL file: ", csl_file)
} else {
  csl_file <- NULL
  message("No CSL file found, using default citation style")
}

# Build pandoc args once — reused for every chapter render
pandoc_args <- "--citeproc"

if (length(bib_files) > 0) {
  bib_args    <- unlist(lapply(bib_files, function(b) c("--bibliography", b)))
  pandoc_args <- c(pandoc_args, bib_args)
}

if (!is.null(csl_file)) {
  pandoc_args <- c(pandoc_args, "--csl", csl_file)
}

message("Pandoc citation args ready\n")

# ------------------------------------------------------------
# 5. Render full book as a single Word document
# ------------------------------------------------------------

message("Rendering full book as Word document...")

full_book_path <- file.path(download_dir, "Quintana_GoFish_Library.docx")

tryCatch({
  
  bookdown::render_book(
    input         = "index.Rmd",
    output_format = bookdown::word_document2(
      reference_docx = word_template,
      toc            = TRUE,
      toc_depth      = 3,
      fig_caption    = TRUE,
      pandoc_args    = pandoc_args
    ),
    output_dir    = download_dir,
    quiet         = TRUE
  )
  
  # bookdown names the file after the book title, rename to our convention
  generated <- list.files(download_dir, pattern = "\\.docx$", full.names = TRUE)
  generated <- generated[!grepl("Quintana_GoFish_", generated)]
  if (length(generated) > 0) {
    file.rename(generated[1], full_book_path)
  }
  
  message("  ✓ Full book rendered: ", full_book_path, "\n")
  
}, error = function(e) {
  message("  ✗ Full book render failed: ", conditionMessage(e), "\n")
})

# ------------------------------------------------------------
# 6. Render each chapter as a Word document
# ------------------------------------------------------------

chapter_files <- list.files(
  pattern = "^\\d+-.+\\.Rmd$",
  full.names = FALSE
)

if (length(chapter_files) == 0) {
  warning("No chapter Rmd files found. Check your working directory.")
} else {
  message("\nFound ", length(chapter_files), " chapter(s) to render as .docx\n")
}

word_template <- if (file.exists("word_template.docx")) "word_template.docx" else NULL

if (!is.null(word_template)) {
  message("Using Word template: ", word_template)
} else {
  message("No word_template.docx found, using default styling")
}

render_results <- data.frame(
  chapter  = character(),
  status   = character(),
  message  = character(),
  stringsAsFactors = FALSE
)

for (ch in chapter_files) {
  
  ch_lines   <- readLines(ch, warn = FALSE)
  title_line <- ch_lines[grep("^# ", ch_lines)[1]]
  
  if (!is.na(title_line)) {
    ch_title <- sub("^# ", "", title_line)
    ch_title <- gsub("[^a-zA-Z0-9 ]", "", ch_title)
    ch_title <- gsub("\\s+", "_", trimws(ch_title))
  } else {
    ch_title <- gsub("\\.Rmd$", "", ch)
    ch_title <- gsub("^\\d+-", "", ch_title)
  }
  
  output_name <- paste0("Quintana_GoFish_", ch_title, ".docx")
  output_path <- file.path(download_dir, output_name)
  
  message("Rendering: ", ch, " → ", output_path)
  
  result <- tryCatch({
    
    rmarkdown::render(
      input         = ch,
      output_format = rmarkdown::word_document(
        reference_docx = word_template,
        toc            = FALSE,
        fig_caption    = TRUE,
        keep_md        = FALSE,
        pandoc_args    = pandoc_args
      ),
      output_file   = output_path,
      envir         = new.env(parent = globalenv()),
      quiet         = TRUE
    )
    
    list(status = "OK", message = "")
    
  }, error = function(e) {
    list(status = "ERROR", message = conditionMessage(e))
  }, warning = function(w) {
    list(status = "WARNING", message = conditionMessage(w))
  })
  
  render_results <- rbind(render_results, data.frame(
    chapter = ch,
    status  = result$status,
    message = result$message,
    stringsAsFactors = FALSE
  ))
  
  if (result$status == "OK") {
    message("  ✓ Done\n")
  } else {
    message("  ✗ ", result$status, ": ", result$message, "\n")
  }
}

# ------------------------------------------------------------
# 7. Print render summary
# ------------------------------------------------------------

message("\n============================================================")
message("Chapter render summary:")
message("============================================================")

for (i in seq_len(nrow(render_results))) {
  status_icon <- ifelse(render_results$status[i] == "OK", "✓", "✗")
  message(
    sprintf("  %s  %-45s %s",
            status_icon,
            render_results$chapter[i],
            render_results$status[i]
    )
  )
  if (nchar(render_results$message[i]) > 0) {
    message("       └─ ", render_results$message[i])
  }
}

n_ok    <- sum(render_results$status == "OK")
n_error <- sum(render_results$status == "ERROR")

message("\n  ", n_ok, " succeeded  |  ", n_error, " failed")
message("============================================================\n")

# ------------------------------------------------------------
# 8. Build the full bookdown site
# ------------------------------------------------------------

message("Building bookdown site...\n")

tryCatch({
  
  bookdown::render_book(
    input         = "index.Rmd",
    output_format = "bookdown::gitbook",
    quiet         = FALSE
  )
  
  message("\n============================================================")
  message("✓ Bookdown site built successfully")
  message("============================================================\n")
  
}, error = function(e) {
  message("\n============================================================")
  message("✗ Bookdown build failed: ", conditionMessage(e))
  message("============================================================\n")
  stop(e)
})

# ------------------------------------------------------------
# 9. Final summary
# ------------------------------------------------------------

message("Build complete.")
message("  Chapter downloads : ", normalizePath(download_dir))
message("  Site output       : ", normalizePath("docs"))