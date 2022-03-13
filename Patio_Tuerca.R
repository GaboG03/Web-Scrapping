library(rvest)
library(stringr)
library(tidyverse)
library(xlsx)


url1<- "https://ecuador.patiotuerca.com/usados/-/autos?type_autos_moderated=moderated"


pagina_web1<- read_html(url1)


marca <- html_nodes(pagina_web1,".vehicle-href") 


marca<- html_attrs(marca)



kilometraje <- html_nodes(pagina_web1,".vehicle-highlight") 


kilometraje<- html_text(kilometraje)


kilometraje<- gsub(pattern = '\\s20(0|1|2)\\d{1}\\s', x = kilometraje, replacement = "")

kilometraje1<- gsub(pattern = '.\\s(Q|G)[a-z]*', x = kilometraje, replacement = "")

kilometraje1<- str_replace_all(kilometraje1,"[\\s]+", " ")


Ciudad<- unlist(str_extract_all(kilometraje,"(Q|G)[a-z]*"))

ciudad_c<- c(c(NA,NA,NA,NA,NA),Ciudad)


kilometraje1_c<- c( c(NA,NA,NA,NA,NA), kilometraje1 )




marcas<- ""

for(i in seq(1,length(marca))){
  
  marcas[i]<- marca[[i]][4]
}



marcas<- str_replace_all(marcas,"[\\s]+", "")

marcas<- marcas[!is.na(marcas)]


marcas<- unique(marcas)



marcasP<- gsub(pattern = '([[:upper:]])', x = marcas, replacement = " \\1")

nombres_marca <- gsub(pattern = '[0-9]{4}', x = marcasP, replacement = "")

anio<- str_extract_all(marcas,"[0-9]{4}$")





precio<- html_nodes(pagina_web1,".price-text") 
precio<- html_text(precio)

precio<- str_replace_all(precio,"[\\s]+", "")



######################


fecha<- html_nodes(pagina_web1,".image-loader") 
fecha<- html_attrs(fecha)


s_fecha<- ""

for(i in seq(1,length(fecha)))
{
  s_fecha[i]<- fecha[[i]][4]
}


fecha_f<-unlist(str_extract_all(s_fecha,'(2022[0-9]*|[0-9][0-9](2022|2021))'))


## ARMAR LA FECHA: 

fecha_pub<- c(c(NA,NA,NA),fecha_f  )


datos<- data.frame( Marca = nombres_marca, Anio=unlist(anio), Precio = precio,Kilometraje = kilometraje1_c, Ciudad = ciudad_c, Fecha_Publicacion=fecha_pub )


write.xlsx(datos,"Patio_Tuerca_scrapping.xlsx")






