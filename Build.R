# ============================================================
#  build.R
#  Run this script to:
#    1. Install any missing packages
#    2. Render each chapter as a .docx download
#    3. Build the full bookdown site
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

# Register netlogo as a passthrough engine so code blocks
# render as plain code without throwing an error
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
# 4. Render each chapter as a Word document
# ------------------------------------------------------------

# Find all numbered chapter Rmd files (e.g. 01-intro.Rmd, 02-ABM.Rmd)
chapter_files <- list.files(
  pattern = "^\\d+-.+\\.Rmd$",
  full.names = FALSE
)

if (length(chapter_files) == 0) {
  warning("No chapter Rmd files found. Check your working directory.")
} else {
  message("\nFound ", length(chapter_files), " chapter(s) to render as .docx\n")
}

# Optional: point to a Word template for consistent styling
# Create this by saving a formatted .docx as word_template.docx in your project root
word_template <- if (file.exists("word_template.docx")) "word_template.docx" else NULL

render_results <- data.frame(
  chapter  = character(),
  status   = character(),
  message  = character(),
  stringsAsFactors = FALSE
)

for (ch in chapter_files) {
  
  output_name <- gsub("\\.Rmd$", ".docx", ch)
  output_path <- file.path(download_dir, output_name)
  
  message("Rendering: ", ch, " → ", output_path)
  
  result <- tryCatch({
    
    rmarkdown::render(
      input         = ch,
      output_format = rmarkdown::word_document(
        reference_docx  = word_template,
        toc             = TRUE,
        toc_depth       = 3,
        fig_caption     = TRUE,
        keep_md         = FALSE
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
# 5. Print render summary
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
# 6. Build the full bookdown site
# ------------------------------------------------------------

message("Building bookdown site...\n")

tryCatch({
  
  bookdown::render_book(
    input        = "index.Rmd",
    output_format = "bookdown::gitbook",
    quiet        = FALSE
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
# 7. Final summary
# ------------------------------------------------------------

message("Build complete.")
message("  Chapter downloads : ", normalizePath(download_dir))
message("  Site output       : ", normalizePath("docs"))