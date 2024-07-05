# Chargement des librairies nécessaires
library(shiny)
library(shinydashboard)

server <- function(input, output) {
  
  ###################
  # PARTIE GRIMPEUR #
  ###################
  
  output$dataframeTable1 <- renderDT({
    datatable(read.csv("climber_df.csv"))
  })
  
  output$dataframeTable2 <- renderDT({
    datatable(read.csv("routes_rated.csv"))
  })
  
  output$dataframeTable3 <- renderDT({
    datatable(read.csv("grades_conversion_table.csv"))
  })
  
  filtered_data <- reactive({
    data <- climber_df
    
    # Filtre sur l'âge
    if (input$ageFilter != "all") {
      age_bounds <- strsplit(input$ageFilter, "-")[[1]]
      if (length(age_bounds) == 2) {
        data <- data %>%
          filter(age >= as.numeric(age_bounds[1]), age <= as.numeric(age_bounds[2]))
      } else {
        # Si l'âge est dans la catégorie "51+", par exemple
        data <- data %>%
          filter(age >= 51)
      }
    }
    # Filtre sur le sexe
    if (input$sexFilter != "all") {
      data <- data %>%
        filter(sex == as.numeric(input$sexFilter))
    }
    
    # Filtre sur les pays sélectionnés
    if (!is.null(input$countrySelect) && length(input$countrySelect) > 0) {
      data <- data %>%
        filter(country %in% input$countrySelect)
    }
    # Retourne le dataframe filtré
    data
  })
  
  filtered_data_2 <- reactive({
    data <- climber_df
    
    # Filtre sur les pays sélectionnés
    if (!is.null(input$countrySelect) && length(input$countrySelect) > 0) {
      data <- data %>%
        filter(country %in% input$countrySelect)
    }
    
    # Filtre sur l'âge
    if (input$ageFilter != "all") {
      age_bounds <- strsplit(input$ageFilter, "-")[[1]]
      if (length(age_bounds) == 2) {
        data <- data %>%
          filter(age >= as.numeric(age_bounds[1]), age <= as.numeric(age_bounds[2]))
      } else {
        # Si l'âge est dans la catégorie "51+", par exemple
        data <- data %>%
          filter(age >= 51)
      }
    }
    # Retourne le dataframe filtré
    data
  })
  
  average_difficulty <- reactive({
  
    # Directly use the filtered data
    avg_diff <- routes_rated %>%
      filter(country %in% input$countrySelect2) %>%
      group_by(country) %>%
      summarise(average_difficulty = mean(grade_mean, na.rm = TRUE)) %>%
      ungroup()
    
    avg_diff
  })
  
  output$totalCountries <- renderInfoBox({
    infoBox(
      "Total Countries", 
      length(unique(climber_df$country)),
      icon = icon("globe"),
      color = "green"
    )
  })
  
  # Pour le nombre total de grimpeurs
  output$totalClimbers <- renderInfoBox({
    infoBox(
      "Total Climbers", 
      nrow(climber_df),
      icon = icon("users"),
      color = "green"
    )
  })
  
  
  output$climbersMap <- renderLeaflet({
    mapclimbers(world_data_1) 
  })
  output$climberspie <- renderPlotly({
    climbers_pie_chart(filtered_data())
  })
  
  output$genderPieChart <- renderPlotly({
    gender_piechart(filtered_data_2())
  })
  
  output$gradesMaxDistribution <- renderPlotly({
    histo_grades(filtered_data())
  })
  
  output$bmiVsGradesPlot <- renderPlotly({
    # Assurez-vous d'appeler bmi_vs_grades_plot avec les données appropriées
    bmi_vs_grades_plot(filtered_data())
  })

  ###################
  # PARTIE ROUTES   #
  ###################
  
  output$totalCountries_routes <- renderInfoBox({
    infoBox(
      "Total Countries", 
      length(unique(routes_rated$country)),
      icon = icon("globe"),
      color = "green"
    )
  })
  
  # Pour le nombre total de grimpeurs
  output$totalRoutes <- renderInfoBox({
    infoBox(
      "Total Routes", 
      nrow(routes_rated),
      icon = icon("mountain"),
      color = "green"
    )
  })
  
  output$routesMap <- renderLeaflet({
    maproutes(world_data_2) 
  })
  
  output$routespie <- renderPlotly({
    routes_piechart(routes_counts) 
  })
  
  output$averageDifficulty <- renderText({
    # Make sure to call the reactive expression here
    avg_diff <- average_difficulty()
    
    # Check if avg_diff is not empty
    if(nrow(avg_diff) > 0){
      difficulty_routes(avg_diff)
    } else {
      "No data available for the selected country."
    }
  })
     
}







