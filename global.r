library(sf)
library(leaflet)
library(dplyr)
library(tidyr)

# Charger les données des grimpeurs
climber_df <- read.csv("climber_df.csv")
routes_rated <- read.csv("routes_rated.csv")

# Convert the 'country' column in both data frames to uppercase
routes_rated$country <- toupper(routes_rated$country)
climber_df$country <- toupper(climber_df$country)


# Convert the 'country' column in both data frames to uppercase
routes_rated$country <- toupper(routes_rated$country)
climber_df$country <- toupper(climber_df$country)

# Proceed with creating counts as before
routes_counts <- 
  routes_rated %>%
  group_by(country) %>%
  summarise(Count = n()) %>%
  ungroup()

climbers_counts <- 
  climber_df %>%
  group_by(country) %>%
  summarise(Count = n()) %>%
  ungroup()

# Load the geographical data
world_geojson <- sf::st_read("world.geojson")

# Join the data after ensuring the country codes match in case
world_data_1 <- world_geojson %>%
  left_join(climbers_counts, by = c("ISO_A3" = "country")) %>%
  replace_na(list(Count = 0))

world_data_2 <- world_geojson %>%
  left_join(routes_counts, by = c("ISO_A3" = "country")) %>%
  replace_na(list(Count = 0))


#########################
##### MAP ###############
#########################

mapclimbers <- function(world_data_1) {  
  
  leaflet(world_geojson) %>%
    addTiles() %>% 
    addPolygons(
      fillColor = ~pal1(world_data_1$Count),  
      weight = 2,
      opacity = 1,
      color = 'white',
      dashArray = '3',
      fillOpacity = 0.7,
      highlight = highlightOptions(
        weight = 5,
        color = '#666',
        dashArray = '',
        fillOpacity = 0.7,
        bringToFront = TRUE),
      label = ~paste(ISO_A3, world_data_1$Count),
      labelOptions = labelOptions(
        style = list('font-weight' = 'normal', padding = '3px 8px'),
        textsize = '15px',
        direction = 'auto')) %>%
    addLegend(
      pal = pal1,
      values = ~world_data_1$Count,
      title = "Nombre de Grimpeurs",
      position = "bottomright"
    ) %>%
    setView(lng = 0, lat = 0, zoom = 2)
}

maproutes <- function(world_data_2) {  
  
  leaflet(world_geojson) %>%
    addTiles() %>%  
    addPolygons(
      fillColor = ~pal2(world_data_2$Count), 
      weight = 2,
      opacity = 1,
      color = 'white',
      dashArray = '3',
      fillOpacity = 0.7,
      highlight = highlightOptions(
        weight = 5,
        color = '#666',
        dashArray = '',
        fillOpacity = 0.7,
        bringToFront = TRUE),
      label = ~paste(ISO_A3, world_data_2$Count),  # utiliser climber_counts$Count ici
      labelOptions = labelOptions(
        style = list('font-weight' = 'normal', padding = '3px 8px'),
        textsize = '15px',
        direction = 'auto')) %>%
    addLegend(
      pal = pal2,
      values = ~world_data_2$Count,
      title = "Nombre de Grimpeurs",
      position = "bottomright"
    ) %>%
    setView(lng = 0, lat = 0, zoom = 2)
}


# Couleur personnalisée en fonction du nombre de grimpeurs / routes
pal1 <- colorNumeric(palette = "viridis", domain = world_data_1$Count)
pal2 <- colorNumeric(palette = "plasma", domain = world_data_2$Count)

#########################
##### PIE CHART #########
#########################


climbers_pie_chart <- function(filtered_data){
  # Calcul du pourcentage de grimpeurs par pay
  filtered_data <- 
    filtered_data %>%
    group_by(country) %>%
    summarise(Count = n()) %>%
    ungroup()
  
  filtered_data <- filtered_data %>%
    mutate(Percentage = (Count / sum(Count)) * 100)
  
  # Création du pie chart avec plotly
  pie_chart <- plot_ly(
    data = filtered_data,
    labels = ~country,
    values = ~Percentage,
    type = "pie",
    hole = 0.2 
  ) %>%
    layout(
      showlegend = TRUE
    )
  
  return(pie_chart)

}

gender_piechart <- function(filtered_data){
  
  gender_counts <- filtered_data%>%
    mutate(sex = factor(sex, labels = c("Homme", "Femme"))) %>%
    group_by(sex) %>%
    summarise(Count = n())
  
  # Créer le pie chart avec Plotly
  pie_chart <- plot_ly(gender_counts, labels = ~sex, values = ~Count, type = 'pie',hole = 0.2,
          textinfo = 'percent',
          insidetextorientation = 'radial') %>%
    layout(
      showlegend = TRUE
    )

  
  return(pie_chart)
  
}

routes_piechart <- function(routes_counts){
  
  routes_counts <- routes_counts %>%
    mutate(Percentage = (Count / sum(Count)) * 100)
  
  # Création du pie chart avec plotly
  pie_chart <- plot_ly(
    data = routes_counts,
    labels = ~country,
    values = ~Percentage,
    type = "pie",
    hole = 0.2  
  ) %>%
    layout(
      showlegend = TRUE
    )
  
  return(pie_chart)
}


#########################
##### HISTOGRAMME #######
#########################

histo_grades <- function(filtered_data){
  
  # Utilisez filtered_data qui est déjà filtré selon les inputs de l'utilisateur
  grades_data <- filtered_data %>%
    count(grades_max, sort = TRUE) # sort = TRUE pour trier par nombre de grimpeurs
  
  # Créer le graphique avec plotly
  histo <- plot_ly(grades_data, x = ~grades_max, y = ~n, type = 'bar', text = ~n) %>%
    layout(
      xaxis = list(title = "Grades Max"),
      yaxis = list(title = "Nombre de Grimpeurs"))
  
  return(histo)
}

#########################
##### GRAPH BMI #########
#########################

calculate_bmi <- function(weight, height_cm) {
  height_m <- height_cm / 100
  bmi <- weight / (height_m^2)
  return(bmi)
}

bmi_vs_grades_plot <- function(data){
  
  # Ajouter une colonne IMC au dataframe
  data <- data %>%
    mutate(
      bmi = calculate_bmi(weight, height),
      grades_mean = as.numeric(grades_mean)  # Convertir en numérique si nécessaire
    )
  
  # Utiliser Plotly pour créer le graphique
  plot <- plot_ly(data, x = ~bmi, y = ~grades_mean, type = 'scatter', mode = 'markers',
                  marker = list(size = 10)) %>%
    layout(
      xaxis = list(title = "IMC"),
      yaxis = list(title = "Grade Moyen")
    )
  
  return(plot)
}

difficulty_routes <- function(avg_diff){
  
  return(paste("Difficulté moyenne en ",avg_diff$country, ": ", round(avg_diff$average_difficulty, 2), collapse = "\n"))
  
}





