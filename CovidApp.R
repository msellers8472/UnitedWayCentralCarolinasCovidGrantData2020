#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readxl)
library(tidyverse)
library(leaflet)
library(stringr)
library(sf)
library(here)
library(widgetframe)
library(spData)
library(tigris)
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("COVID-19 Grant Data"),

    # Sidebar with a slider input for year, numeric input for population
    #Sidebar with inputs for type of grant, round of funding, amount of funding, ZIP code
    sidebarLayout(
        sidebarPanel(
            selectInput("category",
            label="Choose a category of grant.",
            choices = list("Education",
                           "Emergency Financial Assistance",
                           "Health/Mental Health/Substance Use",
                           "Food Security",
                           "Employment & Workforce Development",
                           "Shelter & Housing",
                           "Environment",
                           "Civic Engagement",
                           "Basic Needs",
                           "Child Care",
                           "Equity and Inclusion",
                           "Legal Advocacy",
                           "All"),
            selected = "All"
        ),
        numericInput("grantSize",
                    "Minimum Grant Size",
                    min = 0,
                    max = 1975000,
                    value = 5000)
        ),
        

        # Show the map, table
        mainPanel(
           #plotOutput("distPlot")
            leafletOutput("map"),
            dataTableOutput("table")
        )
    )
)

# Define server logic required to draw the map and table
server <- function(input, output) {
    fund_data_meck <- read_excel("~/Documents/COVID Fund Map Folder//CovidGrantDistributions/FundAwardsNoArts.xlsx")
    
    zipcodes=zctas(starts_with = "28")
    fund_data_meck <- fund_data_meck %>%
        mutate(zctaZipCode = as.character(zctaZipCode))
    fund_data_meck <- merge(zipcodes, fund_data_meck,
                            by_df = fund_data_meck$zctaZipCode)
    fund_data_meck <- filter(fund_data_meck, fund_data_meck$ZCTA5CE10 == fund_data_meck$zctaZipCode)
    
    #Creates map by the inputs specified. Strategy: create filtered dataset, feed to leaflet.
    output$map <- renderLeaflet({
        #pop_by_year <- filter(urban_agglomerations,
        #                      year == input$year,
        #                      population_millions > input$pop_min)
        if(input$category == "All"){
            grantByCategory <- filter(fund_data_meck,
                                      fund_data_meck$Total > input$grantSize)
        }
        else {
            grantByCategory <- filter(fund_data_meck,
                                      fund_data_meck$Category == input$category,
                                      fund_data_meck$Total > input$grantSize)
        }
        
        #zipcodes <- us_zipcodes()
        #grantByCategory <- merge(grantByCategory, zipcodes, by.x = grantByCategory$`ZCTA zip code`, by.y = zipcodes$zipcode)
        colorGrant <- colorFactor(palette = c("red", "orange", "yellow",
                                              "green", "blue", "blueviolet", "purple",
                                              "deeppink", "sienna", "lightblue2", 
                                              "forestgreen", "lightpink"),
                                  levels = c("Education", "Emergency Financial Assistance",
                                             "Health/Mental Health/Substance Use", "Food Security",
                                             "Employment & Workforce Development", "Shelter & Housing",
                                             "Environment", "Civic Engagement", "Basic Needs", "Child Care",
                                             "Equity and Inclusion", "Legal Advocacy"))
        leaflet(data= grantByCategory) %>%
            addTiles() %>%
            addPolygons(label = ~ZCTA5CE10) %>%
            addCircleMarkers(lng=grantByCategory$lng, lat = grantByCategory$lat,
                              radius = 10,
                       popup=grantByCategory$organizationDescriptionBlurb, fillOpacity = 1,
                       color = ~colorGrant(grantByCategory$Category))
    })
    
    #Creates table.
    
    output$table <- renderDataTable({
        if(input$category == "All"){
            grantByCategory <- filter(fund_data_meck,
                                      fund_data_meck$Total > input$grantSize)
        }
        else {
            grantByCategory <- filter(fund_data_meck,
                                      fund_data_meck$Category == input$category,
                                      fund_data_meck$Total > input$grantSize)
        }
        viewVars <- c("Organization", "Total", "Category", "Number of grants")
        grantByCategoryView <- grantByCategory[viewVars]
        grantByCategoryView
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
