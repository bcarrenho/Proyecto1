pacman::p_load(rnaturalearth, rnaturalearthdata, magrittr, dplyr, ggplot2, viridis,
               sf, ggthemes,readxl, tmap, geoR, e1071)


world <- ne_countries(scale= 50 , type='map_units', returnclass='sf')
density <- read_sf("data/ne_50m_urban_areas.shp")
PM2_5 <- read_excel("data/PM2.5.xls")


#eliminar hasta [4:53], luego [4:11] y luego [5:7]
PM2_5[4:61] <- list(NULL)
PM2_5[5:7] = list(NULL)


world = merge(world, PM2_5, by = "iso_a3")

Samerica = world %>%
  filter( region_un == "Americas")

Samerica[1:4] <- list(NULL)
Samerica[2:31] <- list(NULL)
Samerica[4:20] <- list(NULL)
Samerica[6:13] <- list(NULL)

Samerica <- Samerica[-c(20, 28), ] #Eliminar Francia y Dinamarca(Greonlandia)

names(Samerica)[names(Samerica) == '2017'] <- '% de personas expuestas a PM2.5'

density$scalerank <- NULL

pal1 <- magma(n = length(unique(density$"area_sqkm")), direction = -1)
pal2 <- viridis(n = length(unique(Samerica$"% de personas expuestas a PM2.5")), direction = -1)


tmap_mode("view")
tmap_options(check.and.fix = TRUE)
tm_shape(Samerica, bbox = c(-130, -30, -60, 50)) +   #Coordenadas America
  tm_polygons(col = "% de personas expuestas a PM2.5", palette = pal2, title = "Personas expuestas a PM2.5 (%)")+
  tm_shape(density) +
  tm_layout(title = "America")+
  tm_polygons(col = "area_sqkm", palette = pal1 , title = "Densidad Poblacional en ciertas zonas urbanas (hab/km2)")+
  tm_basemap("Esri.WorldStreetMap")


###########

hist(
  Samerica$`% de personas expuestas a PM2.5`,
  col = 'red',
  nclass = 20,
  main = "Histograma",
  ylab = 'Frecuencia Relativa',
  xlab = 'Exposicion a PM2.5 (%)'
)

summary(Samerica$`% de personas expuestas a PM2.5`)

