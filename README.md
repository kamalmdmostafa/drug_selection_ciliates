# drug_selection_ciliates
# Drug Dilution Calculator - Shiny App

A Shiny application for calculating drug dilutions with precision, supporting multiple concentration units and Excel export functionality.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation Guide](#installation-guide)
  - [Installing R](#installing-r)
  - [Installing RStudio](#installing-rstudio)
  - [Required R Packages](#required-r-packages)
- [Running the Application](#running-the-application)
- [Features](#features)
- [Troubleshooting](#troubleshooting)

## Prerequisites
- R (version 4.0.0 or higher)
- RStudio (version 1.4.0 or higher)
- Internet connection for package installation

## Installation Guide

### Installing R

1. Visit the CRAN (Comprehensive R Archive Network) website:
   - Windows: https://cran.r-project.org/bin/windows/base/
   - macOS: https://cran.r-project.org/bin/macosx/
   - Linux: https://cran.r-project.org/bin/linux/

2. Download the latest version for your operating system:
   - Windows: Click on "Download R x.x.x for Windows"
   - macOS: Click on "R-x.x.x.pkg"
   - Linux: Follow the instructions for your distribution

3. Run the installer and follow the installation wizard:
   - Windows: Accept default settings unless you have specific requirements
   - macOS: Double-click the downloaded .pkg file and follow instructions
   - Linux: Use your distribution's package manager

### Installing RStudio

1. Visit the RStudio download page:
   https://www.rstudio.com/products/rstudio/download/#download

2. Download the appropriate version for your operating system

3. Install RStudio:
   - Windows: Run the .exe file and follow the installation wizard
   - macOS: Open the .dmg file and drag RStudio to Applications
   - Linux: Run the .deb or .rpm package installer

### Required R Packages

Launch RStudio and run the following commands in the console to install required packages:

```r
# Install required packages
install.packages(c("shiny", "shinydashboard", "DT", "writexl"))
```

## Running the Application

1. Open RStudio

2. Create a new R script and copy the entire Shiny app code into it

3. Save the script as `app.R`

4. Run the application either by:
   - Clicking the "Run App" button in RStudio
   - Or running the following command in the console:
   ```r
   shiny::runApp("path/to/your/app.R")
   ```

## Features

- **Unit Conversion**: Supports multiple concentration units (ng/ml, µg/ml, mg/ml, g/ml)
- **Step-by-Step Calculations**: Shows dilution effects and required stock volumes
- **Excel Export**: Export calculations and parameters to Excel file
- **Interactive Interface**: Real-time calculation updates
- **Detailed Instructions**: Built-in help and calculation logic explanation

## Troubleshooting

### Common Issues and Solutions

1. **Package Installation Errors**
   ```r
   # If you encounter installation errors, try:
   install.packages("package_name", dependencies = TRUE)
   ```

2. **Version Conflicts**
   ```r
   # Update all packages
   update.packages()
   ```

3. **Loading Package Errors**
   - Restart R session: Session > Restart R
   - Check package installation:
   ```r
   installed.packages()
   ```

### Still Having Issues?

If you encounter any problems:
1. Check R and RStudio versions
2. Verify all packages are installed correctly
3. Clear R environment and restart RStudio
4. Make sure you have internet connection for initial package installation

## Additional Notes

- The app performs all calculations in base units (ng/ml) internally for precision
- Excel exports include both parameters and calculations sheets
- Regular updates of R and packages are recommended for optimal performance

For questions or issues, please open an issue in the repository.
