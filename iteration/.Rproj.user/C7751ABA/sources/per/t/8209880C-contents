
nombres <- c("jorge","jacky","elias","daniel","nikol","oscar")

for(i in nombres){
  saludo <- paste0("Hola ", i, "!")
  print(saludo)
}


#-----------------------------------------------

df <- data.frame()

for(i in nombres){
  saludo <- paste0("Hola ", i, "!")
  df <- rbind(df, saludo)
}



#----------------------------------------------

for(año in seq(from = 2016, to = 2022, by = 2)){
  mensaje <- paste("El", año, "fue el mejor año")
  print(mensaje)
}

#----------------------------------------------

library(rvest)      # HTML Hacking & Web Scraping
library(tidyverse)  # Data Manipulation

# Guardar URL -------------------------------------------------------------
url <- "https://repositorioacademico.upc.edu.pe/handle/10757/621444/recent-submissions"

# Leer HTML ---------------------------------------------------------------
page <- read_html(url)
page

titulo <- page %>% html_nodes(".list-title-clamper") %>% html_text()
titulo



#Loop para 3 páginas
for (page_result in seq(from = 0, to = 40, by = 20)) {
  link <- paste0("https://repositorioacademico.upc.edu.pe/handle/10757/621444/recent-submissions?offset=",
                page_result)
  print(link)
}


#-------------------------------------------------------

df <- data.frame()

#Loop para 3 páginas
for (page_result in seq(from = 0, to = 40, by = 20)) {
  link <- paste0("https://repositorioacademico.upc.edu.pe/handle/10757/621444/recent-submissions?offset=",
                 page_result)
  
  page <- read_html(link)
  
  titulo <- page %>% html_nodes(".list-title-clamper") %>% html_text()
  
  df <- rbind(df,  data.frame(titulo)) 
  
  print(paste("Página:",(page_result/20)+1))
  
}



