# GoFish: A Behavioral Function Library for Migratory Fish Agent-Based Models

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![DOI](https://zenodo.org/badge/DOI/10.5281/ZENODO.19483469.svg)](https://doi.org/10.5281/ZENODO.19483469)
[![Bookdown Site](https://img.shields.io/badge/docs-bookdown-brightgreen)](https://vmahan1998.github.io/GoFish/)

---

## Overview

**GoFish** is a modular, open-source behavioral function library for building
agent-based models (ABMs) of migratory fish in coastal and estuarine systems.
Each function represents a distinct physiological process or behavioral
mechanism — metabolism, osmoregulation, contaminant exposure, schooling,
migration, predation, and more — documented using the ODD protocol and
implemented in NetLogo, R, and Python.

The library was developed to support the
**Penobscot Mercury Exposure Model (P-MEM)**, a spatially and temporally
explicit ABM simulating mercury exposure risk in alewives and striped bass
migrating through the Penobscot River Estuary, Maine. It was co-developed with
Tribal collaborators, community members, managers, and researchers through a
participatory workshop held at the University of Maine on August 6, 2025.

---

## Live Documentation

The full library is hosted as an interactive bookdown site:

> **[https://vmahan1998.github.io/GoFish/](https://vmahan1998.github.io/GoFish/)**

Each chapter corresponds to a behavioral or physiological function and includes:

- ODD protocol documentation
- Mathematical formulations
- NetLogo, R, and Python implementations
- Downloadable Word document for offline use

---

## Repository Structure

GoFish/
│
├── index.Rmd                        # Bookdown index and front matter
├── 01-intro.Rmd                     # Introduction
├── 02-ABM.Rmd                       # Agent-based model overview
├── 03-CoDevelopment.Rmd             # Participatory workshop documentation
├── 04-Metabolism.Rmd                # Metabolism submodel
├── 05-Digestion.Rmd                 # Digestion submodel
├── 06-Salinity_Exposure.Rmd         # Salinity exposure and osmoregulation
├── 07-Migration_Cue.Rmd             # Migration cue detection
├── 08-Contaminant_Exposure.Rmd      # Mercury and methylmercury exposure
├── 09-Filter_Feeding.Rmd            # Small particulate (filter) feeding
├── 10-Lipid_Catabolism.Rmd          # Lipid catabolism
├── 11-Landward_Migration.Rmd        # Landward movement
├── 12-Seaward_Migration.Rmd         # Seaward movement
├── 13-Schooling.Rmd                 # Schooling behavior
├── 14-Selective_Tidal_Stream_Transport.Rmd  # STST
├── 15-Predation.Rmd                 # Predator-prey interactions
├── 16-integrate_functions_example_01.Rmd   # Tutorial: Schooling + Movement
├── 17-integrate_functions_example_02.Rmd   # Tutorial: Movement + STST
├── 18-integrate_functions_example_03.Rmd   # Applied: Full P-MEM
├── 19-summary.Rmd                   # Modeling toolkit and best practices
├── 20-references.Rmd                # References
├── 21-glossary.Rmd                  # Glossary
│
├── build.R                          # Build script: renders .docx + bookdown site
├── _bookdown.yml                    # Bookdown configuration
├── _output.yml                      # Output format configuration
├── style.css                        # Custom CSS for the bookdown site
├── word_template.docx               # Optional Word styling template
│
├── images/                          # Figures and diagrams
├── demos/                           # Video demonstrations
├── materials/                       # Workshop materials and handouts
├── inputs/                          # GIS and hydrodynamic input data
│
├── docs/                            # Rendered bookdown site (GitHub Pages)
│   └── chapter_downloads/           # Per-chapter .docx downloads
│
└── nls/                             # NetLogo submodel files (.nls)
├── Schooling.nls
├── Landward-Migration.nls
├── Seaward-Migration.nls
├── Selective-Tidal-Stream-Transport.nls
├── Calculate-metabolism.nls
├── Osmoregulation.nls
├── Mercury-Contamination.nls
├── Methylmercury-Contamination.nls
├── digestion.nls
├── Foraging_postworkshop_update.nls
└── ...

---

## Behavioral Functions

| Chapter | Function | Key Outputs |
|---------|----------|-------------|
| 4  | Metabolism         | Metabolic rate, efficiency multipliers |
| 5  | Digestion          | Energy gain, contaminant assimilation |
| 6  | Salinity Exposure  | Ion-regulatory stress, chloride cell density, osmoregulation energy |
| 7  | Migration Cues     | Migration probability, migration trigger |
| 8  | Contaminant Exposure | Mercury and methylmercury uptake risk |
| 9  | Filter Feeding     | Biomass intake, contaminant stomach loading |
| 10 | Lipid Catabolism   | Energy from lipids, body mass loss |
| 11 | Landward Migration | Upstream movement path, swim energy |
| 12 | Seaward Migration  | Downstream movement path, swim energy |
| 13 | Schooling          | Group cohesion, aligned heading, speed |
| 14 | STST               | Passive drift, tidal transport events |
| 15 | Predation          | Prey consumption, predator foraging, contaminant transfer |

---

## Applied Model: P-MEM

The **Penobscot Mercury Exposure Model (P-MEM)** integrates all functions
above into a single site-specific ABM of the Penobscot River Estuary, Maine.

| Resource | Link |
|----------|------|
| Full model code and data | [GitHub](https://github.com/vmahan1998/Penobscot_Mercury_Exposure.git) |
| Archived release with DOI | [Zenodo](https://doi.org/10.5281/ZENODO.19483469) |
| Interactive results explorer | [Mercury Risk Explorer](https://vkzfr3-vanessa-mahan.shinyapps.io/Mercury_Risk_Explorer/) |

### Model features

- 2-D GIS domain of the Penobscot River Estuary (3 m × 3 m patch resolution)
- Hourly hydrodynamic forcing from a validated Delft3D FM model
- Two focal species: alewife (*Alosa pseudoharengus*) and striped bass (*Morone saxatilis*)
- Four predation pressure scenarios: none, low, base, high
- Outputs: spatial exposure maps, temporal risk profiles, behavioral state time series

---

## Tutorial Models

Two simplified tutorial models demonstrate function integration before
introducing real-world data.

| Tutorial | Functions Combined | Implementations |
|----------|--------------------|-----------------|
| Chapter 16 — Simple | Schooling + Landward Movement | [NetLogo](https://github.com/vmahan1998/Sample_ABM_Tutorials/tree/main/Simple_Example_01/Netlogo) · [R](https://github.com/vmahan1998/Sample_ABM_Tutorials/tree/main/Simple_Example_01/R) · [Python](https://github.com/vmahan1998/Sample_ABM_Tutorials/tree/main/Simple_Example_01/Python) |
| Chapter 17 — Complex | Schooling + Landward Movement + STST | [NetLogo](https://github.com/vmahan1998/Sample_ABM_Tutorials/tree/main/Complex_Example_02/Netlogo) · [R](https://github.com/vmahan1998/Sample_ABM_Tutorials/tree/main/Complex_Example_02/R) · [Python](https://github.com/vmahan1998/Sample_ABM_Tutorials/tree/main/Complex_Example_02/Python) |

---

## Getting Started

### Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| [R](https://www.r-project.org/) | ≥ 4.1 | Rendering and analysis |
| [RStudio](https://posit.co/products/open-source/rstudio/) | Any recent | Recommended IDE |
| [NetLogo](https://ccl.northwestern.edu/netlogo/) | ≥ 6.3 | Running `.nlogo` models |
| [Git](https://git-scm.com/) | Any | Version control |

### R packages

```r
install.packages(c("rmarkdown", "bookdown", "knitr", "data.table", 
                   "terra", "ggplot2", "dplyr", "shiny"))
```

### Clone the repository

```bash
git clone https://github.com/vmahan1998/GoFish.git
cd GoFish
```

### Build the site

Run the build script to render all chapter Word documents and rebuild the
bookdown site:

```r
source("build.R")
```

Or from the terminal:

```bash
Rscript build.R
```

The rendered site will be written to `docs/` and chapter Word documents
will be written to `docs/chapter_downloads/`.

---

## Co-Development

This library was co-developed through a participatory workshop held at the
**University of Maine Innovation Media Research Center** on August 6, 2025.
The workshop brought together Tribal collaborators, community members,
managers, and researchers to shape the modeling objectives, species
priorities, behavioral processes, and outputs represented in the library.

Workshop participants included representatives from the **Penobscot Nation**,
the University of Maine, NOAA Sea Grant, the U.S. Army Corps of Engineers
Engineering Research and Development Center, and other federal and community
partners. Full acknowledgements are documented in Chapter 3.

---

## Citation

If you use GoFish in your research, please cite:

Files and Metadata:

Quintana, V., Huguenard, K., Zydlewski, G., Dello Russo, J., Zipp, K., & Swannack, T. (2026). GoFish: A next-generation toolkit for modeling migratory fish and quantifying sediment-bound contaminant risk in estuaries (Version 1.0) [Computer software]. Zenodo. https://doi.org/10.5281/zenodo.21209898

Website:

Quintana, V., Huguenard, K., Zydlewski, G., Dello Russo, J., Zipp, K., & Swannack, T. (2026). GoFish: A Modular Agent-Based Modeling Toolkit for Migratory Fish. https://vmahan1998.github.io/GoFish/

---

## License

This project is licensed under the **MIT License**.  
See [LICENSE](LICENSE) for details.

---

## Contact

**Vanessa Quintana**  
University of Maine · USACE Engineering Research and Development Center  
[GitHub](https://github.com/vmahan1998)

---

## Acknowledgements

This work was supported by the University of Maine, NOAA Sea Grant, and the
U.S. Army Corps of Engineers Engineering Research and Development Center.
We are grateful to the Penobscot Nation and all workshop participants for
their time, knowledge, and commitment to collaborative science.