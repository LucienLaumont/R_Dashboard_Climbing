library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(DT)

tags$head(tags$script(HTML("
  $(document).on('click', '.external-link', function(e) {
    e.preventDefault();
    window.open($(this).attr('href'), '_blank');
  });
")))


ui <- dashboardPage(
  dashboardHeader(title = "L'Escalade"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Présentations", tabName = "présentations", icon = icon("table")),
      menuItem("Grimpeurs", tabName = "grimpeurs", icon = icon("user")),
      menuItem("Routes", tabName = "routes",icon = icon("mountain"))
      # Ensure each menuItem has a corresponding tabName and icon
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "présentations",
              fluidRow(
                column(width = 8,
                  box(title = "Projet", status = "primary", solidHeader = TRUE,width = NULL,
                    p("L’objectif du mini projet est d’éclairer un sujet d’intérêt public (météo, environnement, politique, vie publique, 
                      finance, transports, culture, santé, sport, économie, agriculture, écologie, etc…) que vous choisissez librement.
                      Vous utiliserez des données publiques Open Data, accessibles et non modifiées.",style = "font-size: 30px;")
                  ),
                  box(title = "Fichier et lien", status = "primary", solidHeader = TRUE,width = NULL,
                    p(a("Livrables & données", href = "https://perso.esiee.fr/~courivad/DSIA4101C/miniprojetdata.html", class = "external-link", style = "font-size: 17px;")),
                    p(a("Lien Git Projet", href = "https://git.esiee.fr/laumontl/r_climbing_project", class = "external-link", style = "font-size: 17px;"))
                  ),
                ),
                column(width = 4,
                  box(title = "Réalisation", status = "primary", solidHeader = TRUE,width = NULL,
                      p(strong("Etudiants :"),"Laumont Lucien",style = "font-size: 30px;"),
                      p("Lepage Emmanuelle",style = "font-size: 30px;"),
                      p(strong("Professeur :"),"Charles Maupou",style = "font-size: 30px;"),
                      img(src = "ESIEE_Paris_logo.png",width = 500),
                  ),
                ),
                box(
                  title = "Data sur les Grimpeurs dans le monde :", 
                  status = "primary",
                  width = 12,
                  solidHeader = TRUE, 
                  DTOutput("dataframeTable1")
                ),
                box(
                  title = "Data sur les Routes dans le monde :", 
                  status = "primary", 
                  solidHeader = TRUE,
                  width = 12,
                  DTOutput("dataframeTable2")
                ),
                box(title = "Conversion Etats-Unis / France Grade :",
                  status = "primary", 
                  width = 8,
                  solidHeader = TRUE, 
                  DTOutput("dataframeTable3")
                ),
                img(src = "climber_1.png", width = 550)
                )
              
        ),
      tabItem(tabName = "grimpeurs",
              fluidRow(
                infoBoxOutput("totalClimbers", width = 6),
                infoBoxOutput("totalCountries", width = 6)
              ),
              fluidRow(
                box(title = "Country",width = 4, status = "primary", solidHeader = TRUE,
                    selectInput("countrySelect", "",
                                choices = unique(climber_df$country), multiple = TRUE)
                ),
                box(title = "Age",width = 4, status = "primary", solidHeader = TRUE,
                    selectInput("ageFilter", "",
                    choices = c("Tous" = "all", "18-30" = "18-30", "31-50" = "31-50", "51+" = "51+"))
                ),
                box(title = "Sex",width = 4, status = "primary", solidHeader = TRUE,
                    selectInput("sexFilter", "",
                    choices = c("Tous" = "all", "Homme" = "0", "Femme" = "1"))
                ),
              ),
              fluidRow(
                box(title = "Carte des Grimpeurs :", status = "primary", solidHeader = TRUE,width = 8,
                    leafletOutput("climbersMap", height = 580)
                ),
                box(title = "Pourcentage de Grimpeurs par Pays, Age & Sex :", status = "primary", solidHeader = TRUE,width = 4,
                    plotlyOutput("climberspie",height = 250)
                ),
                box(title = "Pourcentage de Genre par Pays & Age :", status = "primary", solidHeader = TRUE,width = 4,
                    plotlyOutput("genderPieChart",height = 250)
                ),
              ),
              fluidRow(
                box(title = "Explication IMC :", status = "primary", solidHeader = TRUE,
                    img(src = "IMC_Image.jpg", height = "350px", width = "100%"),
                ),
                box(title = "IMC vs Grade Moyen :", status = "primary", solidHeader = TRUE,
                    plotlyOutput("bmiVsGradesPlot", height = "350px")
                ),
                box(
                  title = "Répartition des Grades Max des Grimpeurs :", status = "primary", solidHeader = TRUE,width = 12,
                  plotlyOutput("gradesMaxDistribution", height = "400px")
                  # Ajoutez ici les éléments interactifs après l'histogramme
                ),
              ),
            
      ),
      tabItem(tabName = "routes",
              fluidRow(
                infoBoxOutput("totalRoutes", width = 6),
                infoBoxOutput("totalCountries_routes", width = 6)
              ),
              fluidRow(
                box(title = "Carte des Routes :", status = "primary", solidHeader = TRUE, width = 8,
                    leafletOutput("routesMap", height = 750)
                ),
                box(title = "Grade Moyen des routes par pays :", width = 4, status = "primary", solidHeader = TRUE,
                    selectInput("countrySelect2", "Select a country:",
                                choices = unique(routes_rated$country), multiple = FALSE),
                    textOutput("averageDifficulty")
                ),
                box(title = "Pourcentage de Routes par Pays :", status = "primary", solidHeader = TRUE, width = 4,
                    plotlyOutput("routespie", height = 425)  # Removed the space after "routespie"
                ),
              ),

      )
  )
)
)

