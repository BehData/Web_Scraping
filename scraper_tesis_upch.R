rm(list=ls())

# Cargar librerías --------------------------------------------------------
library(rvest)      # HTML Hacking & Web Scraping
library(tidyverse)  # Data Manipulation
library(openxlsx)   # Excel manipulation
library(xopen)      # Opens URL in Browser
library(beepr)      # Notification sounds

# Guardar URL ------------------------------------------------------------------

url <- "https://repositorio.upch.edu.pe/handle/20.500.12866/70/recent-submissions"
xopen(url)

# Leer HTML --------------------------------------------------------------------
page <- read_html(url)

# Extracción de nodos ----------------------------------------------------------
titulo <- page |> html_nodes(".artifact-title") |> html_text()
año    <- page |> html_nodes(".date")           |> html_text()
autor  <- page |> html_nodes(".author span")    |> html_text()
univ   <- page |> html_nodes(".publisher")      |> html_text()

# Leer URL de 3 páginas --------------------------------------------------------
for (page_result in seq(from = 0, to = 40, by = 20)) {
  url <- paste0("https://repositorio.upch.edu.pe/handle/20.500.12866/20/recent-submissions?offset=", page_result) 
  print(url)
}

# Almacenar nodos en una BD ----------------------------------------------------
df <- data.frame()

for (page_result in seq(from = 0, to = 40, by = 20)) {
  
  url  <- paste0("https://repositorio.upch.edu.pe/handle/20.500.12866/70/recent-submissions?offset=", page_result)
  page <- read_html(url)
  
  titulo <- page |> html_nodes(".artifact-title") |> html_text()
  año    <- page |> html_nodes(".date")           |> html_text()
  autor  <- page |> html_nodes(".author span")    |> html_text()
  
  df <- rbind(df, data.frame(titulo, año, autor, univ))
  
  print(paste("Pagina:", (page_result/20)+1))
  beep(2) # Notificar iteración exitosa
}

beep(8) # Notificar compilado exitoso

View(df)


# Crear funciones para extraer metadata -----------------------------------

# Extraer subject ----
get_subject  <- function(x) {
  tesis_page <- read_html(x)
  tesis_subject  <- tesis_page |>  
    html_nodes(".odd:nth-child(17) .label-cell+ td , .even:nth-child(16) .label-cell+ td , .odd:nth-child(15) .label-cell+ td") |> 
    html_text() |> 
    paste(collapse = ",")
  return(tesis_subject)
}

# Extraer asesor ----
get_asesor  <- function(x) {
  tesis_page <- read_html(x)
  tesis_asesor  <- tesis_page |>  
    html_nodes(".odd:nth-child(1) .label-cell+ td") |> 
    html_text() 
  return(tesis_asesor)
}


# Almacenar nodos de diferentes URL en una BD ------------------------------
df <- data.frame()

for (page_result in seq(from = 0, to = 40, by = 20)){
  
  url  <- paste0("https://repositorio.upch.edu.pe/handle/20.500.12866/70/recent-submissions?offset=", page_result)
  page <- read_html(url)
  
  # Obtener los enlaces de la tesis
  id_links <- page |> 
    html_nodes("#aspect_discovery_recentSubmissions_RecentSubmissionTransformer_div_recent-submissions a") |>  
    html_attr("href")
  
  # Agregar el prefijo y sufijo al enlace
  tesis_links      <- paste0("https://repositorio.upch.edu.pe", id_links)
  tesis_links_full <- paste0("https://repositorio.upch.edu.pe", id_links, "?show=full")
  
  titulo  <- page |> html_nodes("#aspect_discovery_recentSubmissions_RecentSubmissionTransformer_div_recent-submissions a") |> html_text()
  año     <- page |> html_nodes(".date") |> html_text()
  autor   <- page |> html_nodes(".author span") |> html_text()
  subject <- sapply(tesis_links_full, FUN = get_subject, USE.NAMES = FALSE)
  asesor  <- sapply(tesis_links_full, FUN = get_asesor, USE.NAMES = FALSE)
  
  df <- rbind(df, data.frame(titulo, año, autor, tesis_links, univ, subject, asesor))
  
  print(paste("Pagina:", (page_result/20)+1))
  
}

beep(8) # Notificar compilado exitoso

View(df)

# Exportar data como archivo excel ----
write.xlsx(df, "tesis_psicología_upch.xlsx")
