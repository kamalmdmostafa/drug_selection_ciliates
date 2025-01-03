# Install and load required packages
# install.packages(c("shiny", "shinydashboard", "DT", "writexl"))
library(shiny)
library(shinydashboard)
library(DT)
library(writexl)

# Function to convert concentrations to base unit (ng/ml)
convert_to_base <- function(value, unit) {
  switch(unit,
         "ng/ml" = value,
         "µg/ml" = value * 1000,
         "mg/ml" = value * 1000000,
         "g/ml" = value * 1000000000
  )
}

# Function to convert from base unit (ng/ml) to desired unit
convert_from_base <- function(value, unit) {
  switch(unit,
         "ng/ml" = value,
         "µg/ml" = value / 1000,
         "mg/ml" = value / 1000000,
         "g/ml" = value / 1000000000
  )
}

ui <- dashboardPage(
  dashboardHeader(title = "Advanced Drug Dilution Calculator"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Calculator", tabName = "calculator", icon = icon("calculator")),
      menuItem("Instructions", tabName = "instructions", icon = icon("info-circle")),
      menuItem("Calculation Logic", tabName = "logic", icon = icon("square-root-alt"))
    )
  ),
  dashboardBody(
    tabItems(
      # Calculator Tab
      tabItem(tabName = "calculator",
        fluidRow(
          box(
            title = "Initial Parameters",
            width = 6,
            numericInput("current_volume", "Current Culture Volume", value = 20),
            selectInput("volume_unit", "Volume Unit", 
                       choices = c("ml", "µl"), 
                       selected = "ml"),
            numericInput("current_conc", "Current Drug Concentration", value = 700),
            selectInput("current_conc_unit", "Current Concentration Unit", 
                       choices = c("ng/ml", "µg/ml", "mg/ml", "g/ml"), 
                       selected = "ng/ml"),
            numericInput("feeding_volume", "Feeding Volume", value = 2),
            selectInput("feeding_volume_unit", "Feeding Volume Unit", 
                       choices = c("ml", "µl"), 
                       selected = "ml"),
            numericInput("conc_increment", "Desired Concentration Increment", value = 50),
            selectInput("increment_unit", "Increment Unit", 
                       choices = c("ng/ml", "µg/ml", "mg/ml", "g/ml"), 
                       selected = "ng/ml"),
            numericInput("stock_conc", "Drug Stock Concentration", value = 100),
            selectInput("stock_conc_unit", "Stock Concentration Unit", 
                       choices = c("ng/ml", "µg/ml", "mg/ml", "g/ml"), 
                       selected = "µg/ml"),
            numericInput("steps", "Number of Feeding Steps", value = 5),
            actionButton("calculate", "Calculate", class = "btn-primary")
          ),
          box(
            title = "Results",
            width = 6,
            selectInput("display_unit", "Display Results In", 
                       choices = c("ng/ml", "µg/ml", "mg/ml", "g/ml"), 
                       selected = "ng/ml"),
            downloadButton("downloadData", "Export to Excel", class = "btn-success"),
            verbatimTextOutput("calculation_text"),
            DTOutput("results_table")
          )
        )
      ),
      
      # Instructions Tab
      tabItem(tabName = "instructions",
        box(
          title = "How to Use This Calculator",
          width = 12,
          HTML("
            <h4>Instructions:</h4>
            <ol>
              <li>Enter your initial culture parameters:</li>
                <ul>
                  <li>Current culture volume</li>
                  <li>Current drug concentration</li>
                  <li>Volume of feeding media to be added</li>
                  <li>Desired increment in drug concentration</li>
                  <li>Concentration of your drug stock solution</li>
                </ul>
              <li>Select appropriate units for each value</li>
              <li>Choose how many feeding steps you want to calculate</li>
              <li>Click 'Calculate' to generate results</li>
              <li>Use the 'Display Results In' dropdown to convert results to your preferred units</li>
              <li>Click 'Export to Excel' to download the results as an Excel file</li>
            </ol>
            <h4>Important Notes:</h4>
            <ul>
              <li>All calculations are performed in ng/ml internally for precision</li>
              <li>Volume calculations account for both the feeding media and the added drug solution</li>
              <li>The calculator shows the dilution effect from adding feeding media</li>
              <li>Stock solution volumes are shown in both ml and µl for practical pipetting</li>
              <li>The Excel export includes all calculations and parameters used</li>
            </ul>
          ")
        )
      ),
      
      # Calculation Logic Tab
      tabItem(tabName = "logic",
        box(
          title = "Step-by-Step Calculation Logic",
          width = 12,
          HTML("
            <h4>Overview of Drug Dilution Calculations</h4>
            <p>The calculations in this app follow a systematic approach to account for both dilution effects and concentration increments. Here's the detailed logic:</p>
            
            <h4>1. Unit Conversion</h4>
            <ul>
              <li>All concentrations are converted to ng/ml internally:
                <ul>
                  <li>µg/ml → ng/ml: multiply by 1,000</li>
                  <li>mg/ml → ng/ml: multiply by 1,000,000</li>
                  <li>g/ml → ng/ml: multiply by 1,000,000,000</li>
                </ul>
              </li>
              <li>All volumes are converted to ml:
                <ul>
                  <li>µl → ml: divide by 1,000</li>
                </ul>
              </li>
            </ul>

            <h4>2. Dilution Effect Calculation</h4>
            <div style='background-color: #f8f9fa; padding: 10px; border-radius: 5px; margin: 10px 0;'>
              <p><strong>Formula:</strong> C<sub>diluted</sub> = (C<sub>initial</sub> × V<sub>initial</sub>) ÷ V<sub>final</sub></p>
              <p>Where:</p>
              <ul>
                <li>C<sub>diluted</sub> = Concentration after dilution</li>
                <li>C<sub>initial</sub> = Starting concentration</li>
                <li>V<sub>initial</sub> = Initial volume</li>
                <li>V<sub>final</sub> = V<sub>initial</sub> + V<sub>feeding</sub></li>
              </ul>
            </div>

            <h4>3. Target Concentration Calculation</h4>
            <div style='background-color: #f8f9fa; padding: 10px; border-radius: 5px; margin: 10px 0;'>
              <p><strong>Formula:</strong> C<sub>target</sub> = C<sub>initial</sub> + C<sub>increment</sub></p>
              <p>Where:</p>
              <ul>
                <li>C<sub>target</sub> = Desired final concentration</li>
                <li>C<sub>initial</sub> = Starting concentration</li>
                <li>C<sub>increment</sub> = Desired concentration increase</li>
              </ul>
            </div>

            <h4>4. Required Drug Amount Calculation</h4>
            <div style='background-color: #f8f9fa; padding: 10px; border-radius: 5px; margin: 10px 0;'>
              <p><strong>Formulas:</strong></p>
              <p>Amount<sub>final needed</sub> = C<sub>target</sub> × V<sub>final</sub></p>
              <p>Amount<sub>current</sub> = C<sub>diluted</sub> × V<sub>final</sub></p>
              <p>Amount<sub>additional</sub> = Amount<sub>final needed</sub> - Amount<sub>current</sub></p>
            </div>

            <h4>5. Stock Solution Volume Calculation</h4>
            <div style='background-color: #f8f9fa; padding: 10px; border-radius: 5px; margin: 10px 0;'>
              <p><strong>Formula:</strong> V<sub>stock</sub> = Amount<sub>additional</sub> ÷ C<sub>stock</sub></p>
              <p>Where:</p>
              <ul>
                <li>V<sub>stock</sub> = Volume of stock solution needed</li>
                <li>Amount<sub>additional</sub> = Additional amount of drug needed</li>
                <li>C<sub>stock</sub> = Concentration of stock solution</li>
              </ul>
            </div>

            <h4>Example Calculation</h4>
            <p>Let's work through an example with these initial conditions:</p>
            <ul>
              <li>Current volume: 20 ml</li>
              <li>Current concentration: 700 ng/ml</li>
              <li>Feeding volume: 2 ml</li>
              <li>Desired increment: 50 ng/ml</li>
              <li>Stock concentration: 100,000 ng/ml</li>
            </ul>
            
            <p><strong>Step 1:</strong> Calculate diluted concentration</p>
            <ul>
              <li>V<sub>final</sub> = 20 ml + 2 ml = 22 ml</li>
              <li>C<sub>diluted</sub> = (700 ng/ml × 20 ml) ÷ 22 ml = 636.36 ng/ml</li>
            </ul>
            
            <p><strong>Step 2:</strong> Calculate target concentration</p>
            <ul>
              <li>C<sub>target</sub> = 700 ng/ml + 50 ng/ml = 750 ng/ml</li>
            </ul>
            
            <p><strong>Step 3:</strong> Calculate additional drug needed</p>
            <ul>
              <li>Amount<sub>final needed</sub> = 750 ng/ml × 22 ml = 16,500 ng</li>
              <li>Amount<sub>current</sub> = 636.36 ng/ml × 22 ml = 14,000 ng</li>
              <li>Amount<sub>additional</sub> = 16,500 ng - 14,000 ng = 2,500 ng</li>
            </ul>
            
            <p><strong>Step 4:</strong> Calculate stock volume needed</p>
            <ul>
              <li>V<sub>stock</sub> = 2,500 ng ÷ 100,000 ng/ml = 0.025 ml = 25 µl</li>
            </ul>
          ")
        )
      )
    )
  )
)

server <- function(input, output) {
  
  # Reactive calculation function
  calculations <- eventReactive(input$calculate, {
    # Convert all inputs to base units (ng/ml for concentration, ml for volume)
    current_vol <- if(input$volume_unit == "µl") input$current_volume/1000 else input$current_volume
    feeding_vol <- if(input$feeding_volume_unit == "µl") input$feeding_volume/1000 else input$feeding_volume
    
    current_conc <- convert_to_base(input$current_conc, input$current_conc_unit)
    increment <- convert_to_base(input$conc_increment, input$increment_unit)
    stock_conc <- convert_to_base(input$stock_conc, input$stock_conc_unit)
    
    results <- data.frame(
      Step = numeric(),
      Initial_Volume = numeric(),
      Initial_Conc = numeric(),
      Diluted_Conc = numeric(),
      Target_Conc = numeric(),
      Final_Volume = numeric(),
      Stock_Volume_Required_ml = numeric(),
      Stock_Volume_Required_ul = numeric(),
      stringsAsFactors = FALSE
    )
    
    for(i in 1:input$steps) {
      # Calculate new volume after feeding
      new_vol <- current_vol + feeding_vol
      
      # Calculate diluted concentration
      diluted_conc <- (current_conc * current_vol) / new_vol
      
      # Calculate target concentration
      target_conc <- current_conc + increment
      
      # Calculate required drug amount
      final_amount_needed <- target_conc * new_vol
      current_amount <- diluted_conc * new_vol
      additional_drug_needed <- final_amount_needed - current_amount
      
      # Calculate stock volume needed
      stock_vol_needed_ml <- additional_drug_needed / stock_conc
      stock_vol_needed_ul <- stock_vol_needed_ml * 1000
      
      # Store results
      results[i,] <- c(
        i,
        current_vol,
        current_conc,
        diluted_conc,
        target_conc,
        new_vol,
        stock_vol_needed_ml,
        stock_vol_needed_ul
      )
      
      # Update for next iteration
      current_vol <- new_vol
      current_conc <- target_conc
    }
    
    return(results)
  })
  
  # Create a reactive for parameters summary
  parameters_summary <- reactive({
    data.frame(
      Parameter = c("Current Volume", "Current Concentration", "Feeding Volume",
                   "Concentration Increment", "Stock Concentration"),
      Value = c(input$current_volume, input$current_conc, input$feeding_volume,
                input$conc_increment, input$stock_conc),
      Unit = c(input$volume_unit, input$current_conc_unit, input$feeding_volume_unit,
               input$increment_unit, input$stock_conc_unit),
      stringsAsFactors = FALSE
    )
  })
  
  # Output text summary
  output$calculation_text <- renderText({
    calc <- calculations()
    first_step <- calc[1,]
    
    # Convert concentrations to selected display unit
    display_initial_conc <- convert_from_base(first_step$Initial_Conc, input$display_unit)
    display_diluted_conc <- convert_from_base(first_step$Diluted_Conc, input$display_unit)
    display_target_conc <- convert_from_base(first_step$Target_Conc, input$display_unit)
    
    paste0(
      "For the first feeding step:\n",
      "\nInitial volume: ", round(first_step$Initial_Volume, 3), " ml",
      "\nInitial concentration: ", round(display_initial_conc, 3), " ", input$display_unit,
      "\nDiluted concentration: ", round(display_diluted_conc, 3), " ", input$display_unit,
      "\nTarget concentration: ", round(display_target_conc, 3), " ", input$display_unit,
      "\nStock volume needed: ", round(first_step$Stock_Volume_Required_ml, 4), " ml",
      " (", round(first_step$Stock_Volume_Required_ul, 2), " µl)"
    )
  })
  
  # Output results table
  output$results_table <- renderDT({
    calc <- calculations()
    
    # Convert concentrations to selected display unit
    calc$Initial_Conc <- convert_from_base(calc$Initial_Conc, input$display_unit)
    calc$Diluted_Conc <- convert_from_base(calc$Diluted_Conc, input$display_unit)
    calc$Target_Conc <- convert_from_base(calc$Target_Conc, input$display_unit)
    
    # Prepare table with formatted column names
    colnames(calc) <- c(
      "Step", 
      "Initial Volume (ml)", 
      paste("Initial Conc (", input$display_unit, ")", sep=""),
      paste("Diluted Conc (", input$display_unit, ")", sep=""),
      paste("Target Conc (", input$display_unit, ")", sep=""),
      "Final Volume (ml)",
      "Stock Volume Required (ml)",
      "Stock Volume Required (µl)"
    )
    
    datatable(calc, 
              options = list(pageLength = 10),
              rownames = FALSE) %>%
      formatRound(columns = 2:8, digits = 4)
  })
  
  # Download handler for Excel export
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("drug_dilution_calculations_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".xlsx", sep="")
    },
    content = function(file) {
      # Get the calculation results
      calc <- calculations()
      
      # Convert concentrations to selected display unit for export
      calc$Initial_Conc <- convert_from_base(calc$Initial_Conc, input$display_unit)
      calc$Diluted_Conc <- convert_from_base(calc$Diluted_Conc, input$display_unit)
      calc$Target_Conc <- convert_from_base(calc$Target_Conc, input$display_unit)
      
      # Format column names for the results
      colnames(calc) <- c(
        "Step", 
        "Initial Volume (ml)", 
        paste("Initial Conc (", input$display_unit, ")", sep=""),
        paste("Diluted Conc (", input$display_unit, ")", sep=""),
        paste("Target Conc (", input$display_unit, ")", sep=""),
        "Final Volume (ml)",
        "Stock Volume Required (ml)",
        "Stock Volume Required (µl)"
      )
      
      # Get parameters summary
      params <- parameters_summary()
      
      # Create list of worksheets for Excel file
      sheets <- list(
        "Parameters" = params,
        "Calculations" = calc
      )
      
      # Write to Excel file
      write_xlsx(sheets, file)
    }
  )
}

shinyApp(ui = ui, server = server)
