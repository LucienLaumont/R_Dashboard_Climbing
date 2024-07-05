
# 🧗‍♂️ Climbing Dashboard Project

## 🌟 Overview
This project was developed during my second year in Data Science class. The dashboard identifies trends in the climbing domain, such as the proportion of male and female climbers and the distribution of practitioners worldwide. We created several dynamic graphs to visualize these trends. This project was completed with the help of Emmanuelle Lepage.

## 📊 Analysis Report

Our dashboard compiles various graphs focused on climbing-related data. The analysis covers 26 countries and 10,927 climbers. It also includes data on 55,858 climbing routes across 59 countries.

### Climber Section

#### 🌍 Map and Pie Chart on Countries
1. **Dominance of Spain and the USA**: These two countries stand out with a high number of climbers (1,306 and 1,248 respectively), suggesting they might be major centers for climbing.
2. **Popularity of Climbing in Spain**: With 12% of the recorded climbers, Spain shows a particularly high popularity for climbing.
3. **Comparison with France**: France has about half the number of climbers compared to Spain, providing a point of comparison that highlights the popularity of climbing in different European countries.
4. **Geographic Distribution of Climbers**: These graphs highlight significant differences in the geographic distribution of climbers, which may reflect various factors such as the availability of climbing sites, sports culture, and investments in climbing infrastructure.

#### 🚻 Gender Pie Chart
1. **Male Predominance**: There is a majority of men in the climbing world, both in Spain and globally.
2. **Low Female Representation in Spain**: In Spain, women constitute only 12.3% of climbers, illustrating a low female representation in this sport.
3. **Global Trend**: The percentage of female climbers in Spain is representative of the global trend in the climbing community.

#### 📈 Histogram on Maximum Grade
1. **Difficulty Scale**: Difficulty levels are measured on a scale from 0 to 100.
2. **Most Common Difficulty Level**: The difficulty level 62 is the most frequently achieved, with 1,032 climbers reaching it.
3. **Highest Level Achieved**: The highest recorded level is 77, achieved by 16 climbers.
4. **Minimum Level**: The lowest recorded level is 49, achieved by 29 climbers.

### Route Section

#### 🌍 Map and Pie Chart on Countries
1. **Visualization of Climbing Routes**: The map and pie chart in the dashboard show the countries with the most climbing routes.
2. **Domination of Spain**: Spain stands out with the most routes, having 15,293 routes, or 27% of the global total.
3. **Italy in Second Position**: Italy follows with 6,423 routes, representing 11.5% of the world's routes.
4. **Average Route Difficulty**: The average difficulty of routes is quite similar between countries, with 47.48 in Spain, 46.27 in Italy, and 50 in France.

## 🛠️ Developer Guide

Our code is separated into three main files: `global.R`, `server.R`, and `ui.R`.

### Global.R
1. Loading necessary data for the dashboard (csv and geojson).
2. Data merging.
3. Map formation using the leaflet library.
4. Formation of pie charts with plotly.
5. Creation of the histogram.
6. Scatter plot between average grade and BMI.

### Server.R
1. Creation of `filtered_data` as a reactive function.
2. Data filtering based on user inputs.
3. Creation of outputs for each element to display.

### Ui.R
1. Home page presenting the subject.
2. Dashboard layout and selection of input parameters with age ranges, gender, and countries.
3. Creation of the "climbers" page with boxes for each element.
4. Process for the "routes" page.

## 🚀 How to Run

### Prerequisites
- **R**: Ensure you have R installed on your system.
- **R Packages**: You will need the following R packages: `shiny`, `leaflet`, `plotly`, `dplyr`.

### Running the Dashboard
1. Clone the repository to your local machine.
2. Open R and set the working directory to the cloned repository.
3. Run the following command to start the dashboard:

```
shiny::runApp()
```

## 📧 Contact
For any inquiries or further information, please contact:
- Lucien Laumont: lucien.laumont@edu.esiee.fr
- Emmanuelle Lepage: emmanuelle.lepage@edu.esiee.fr
