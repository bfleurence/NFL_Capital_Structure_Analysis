# install and download the proper packages 
install.packages("readxl")
install.packages("openxlsx")

library(readxl)
library(openxlsx)

# Specify the file path
file_path <- "~/Downloads/NFL_2021_2024_Final_Filled_Teams_Years.xlsx"

# Read the Excel file
raw_data <- read.xlsx(file_path)

# Save as CSV
write.csv(raw_data, "~/Downloads/NFL_Capital_Structure_Analysis/data/01-raw_data/raw_data.csv", row.names = FALSE)

# Specify the file path
file_path <- "~/Downloads/Team_Win_Percentage.xlsx"

# Read the file
raw_data_2 <- read.xlsx(file_path)

# Save to a new file
output_path <- "~/Downloads/raw_data_2.xlsx"
write.xlsx(raw_data_2, output_path)

# Confirmation message
cat("File successfully read and saved as raw_data_2.xlsx at", output_path)





