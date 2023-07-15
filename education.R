
# Cargar librerías --------------------------------------------------------
library(rvest)      # HTML Hacking & Web Scraping
library(tidyverse)  # Data Manipulation
library(openxlsx)   # Excel manipulation
library(xopen)      # Opens URL in Browser
library(beepr)      # Notification sounds

# Guardar URL ------------------------------------------------------------------

url <- "https://www.crisol.com.pe/los-mas-vendidos?p=2"
xopen(url)

# Leer HTML --------------------------------------------------------------------
page <- read_html(url)

# Extracción de nodos ----------------------------------------------------------
title <- page |> html_nodes(".product-item-link") |> html_text()
author <- page |> html_nodes(".author") |> html_text()


print(title)
print(author)
print(price)

for (page_result in seq(from = 1, to = 5, by = 1)) {
  url <- paste0("https://www.crisol.com.pe/los-mas-vendidos?p=", page_result) 
  print(url)
}

# Almacenar nodos en una BD ----------------------------------------------------
df <- data.frame()

for (page_result in seq(from = 0, to = 5, by = 1)) {
  
  url  <- paste0("https://www.crisol.com.pe/los-mas-vendidos?p=", page_result)
  page <- read_html(url)
  
  title <- page |> html_nodes(".product-item-link") |> html_text()
  author <- page |> html_nodes(".author") |> html_text()
  
  df <- rbind(df, data.frame(title, author))
  
  print(paste("Pagina:", (page_result)))
  beep(2) # Notificar iteración exitosa
}

#beep(8) # Notificar compilado exitoso

View(df)






