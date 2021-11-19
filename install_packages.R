# Diese Packages werden für die Erstellung der Auswertung gebraucht

packages <-
  c("tidyverse",
    "pathwork",
    "shiny",
    "rmarkdown")
if (length(missing_pkgs <-
           setdiff(packages, rownames(installed.packages()))) > 0) {
  message("Installing missing package(s): ",
          paste(missing_pkgs, collapse = ", "))
  install.packages(missing_pkgs)
}

install.packages("tinytex")
tinytex::install_tinytex()  
