# Ensure necessary libraries are loaded (if using tidyverse syntax)
install.packages("dplyr")
install.packages("tidyverse")

library(dplyr)
library(tidyverse)

# Read the raw data
file_path <- "~/Downloads/NFL_Capital_Structure_Analysis/data/01-raw_data/raw_data.csv" # Replace with your actual path
raw_data <- read.csv(file_path)

# Define offensive positions and special teams
offensive_positions <- c("QB", "HB", "FB", "WR", "TE", "LT", "LG", "RG", "C", "RT", "G", "RB", "T")
special_teams_positions <- c("K", "P", "LS")

# Create the cleaned dataset with new columns
cleaned_data <- raw_data %>%
  mutate(
    # Add offense_or_defense column
    offense_or_defense = case_when(
      Pos %in% offensive_positions ~ "Offense",
      Pos %in% special_teams_positions ~ "Special Teams",
      TRUE ~ "Defense"
    ),
    # Add Position_Group column
    Position_Group = case_when(
      Pos %in% c("LT", "LG", "C", "RG", "RT", "G", "T") ~ "OL",  # Include T as OL
      Pos %in% c("HB", "FB", "RB") ~ "RB",  # HB, FB, and RB grouped as RB
      Pos == "QB" ~ "QB",
      Pos == "TE" ~ "TE",
      Pos == "WR" ~ "WR",
      Pos %in% c("DE", "DT") ~ "DL",  # Defensive Line
      Pos == "OLB" ~ "EDGE",  # Edge Rusher
      Pos %in% c("ILB", "LB") ~ "MLB",  # Inside Linebacker, LB treated as ILB
      Pos == "CB" ~ "CB",
      Pos %in% c("FS", "SS", "S") ~ "S",  # Free Safety and Strong Safety grouped as S
      Pos %in% special_teams_positions ~ "ST",  # Special Teams
      TRUE ~ "Other"  # Catch-all for any unexpected positions
    )
  )

library(dplyr)

# Update the team name
cleaned_data <- cleaned_data %>%
  mutate(Team = ifelse(Team == "49ers", "San Francisco 49ers", Team))

# Verify the change
unique(cleaned_data$Team)


library(dplyr)

# Calculate Position_Group_Spending by Team, Year, and Position_Group
cleaned_data <- cleaned_data %>%
  group_by(Team, Year, Position_Group) %>%
  mutate(Position_Group_Spending = sum(as.numeric(gsub("[^0-9.]", "", Cap.Hit)), na.rm = TRUE)) %>%
  ungroup()

# Inspect the updated data
head(cleaned_data)

library(dplyr)
library(tidyr)

# Clean the Team column in both datasets
cleaned_data <- cleaned_data %>%
  mutate(Team = gsub("[^a-zA-Z0-9 ]", "", Team))

raw_data_2 <- raw_data_2 %>%
  mutate(Team = gsub("[^a-zA-Z0-9 ]", "", Team))

# Define all position groups
all_position_groups <- unique(cleaned_data$Position_Group)

# Create a complete grid of Team, Year, and Position_Group
full_grid <- cleaned_data %>%
  distinct(Team, Year) %>%
  expand(Team, Year, Position_Group = all_position_groups)

# Merge spending data into the full grid
final_table <- full_grid %>%
  left_join(
    cleaned_data %>%
      group_by(Year, Team, Position_Group) %>%
      summarize(
        `Spending on The Position Group` = sum(Position_Group_Spending, na.rm = TRUE),
        .groups = "drop"
      ),
    by = c("Team", "Year", "Position_Group")
  ) %>%
  # Replace missing spending values with 0
  mutate(`Spending on The Position Group` = replace_na(`Spending on The Position Group`, 0))

# Remove rows where spending is 0
final_table <- final_table %>%
  filter(`Spending on The Position Group` != 0)

# Add Wins from cleaned raw_data_2
final_table <- final_table %>%
  left_join(
    raw_data_2 %>% select(Team, Year, Wins),
    by = c("Team", "Year")
  )

# Verify merged data
unique(final_table$Wins)  # Check unique values of Wins
final_table %>% filter(is.na(Wins))  # Inspect rows missing Wins

# Save the updated table to a CSV file
write.csv(final_table, "~/Downloads/Recreated_Example_Table_With_Wins.csv", row.names = FALSE)

cat("Recreated Example Table with total wins saved successfully.")

library(dplyr)

# Update the team name
final_table <- final_table %>%
  mutate(Team = ifelse(Team == "49ers", "San Francisco 49ers", Team))

# Verify the change
unique(cleaned_data$Team)


library(dplyr)

# Add Wins from raw_data_2 to final_table
final_table <- final_table %>%
  left_join(
    raw_data_2 %>% select(Team, Year, Wins),  # Select only relevant columns
    by = c("Team", "Year")  # Merge on Team and Year
  )

# Save the updated table
write.csv(final_table, "~/Downloads/Recreated_Example_Table_With_Wins.csv", row.names = FALSE)

cat("Recreated Example Table with Wins added successfully.")

# Remove the first 22 rows
final_table <- final_table[-c(1:22), ]

# Save the updated final_table
write.csv(final_table, "~/Downloads/Final_Table_Updated.csv", row.names = FALSE)

cat("First 22 rows removed from final_table and saved successfully.")

library(dplyr)

# Create a single Wins column (use Wins.x if not NA, otherwise Wins.y)
final_table <- final_table %>%
  mutate(Wins = coalesce(Wins.x, Wins.y)) %>%  # Prioritize Wins.x, then Wins.y
  select(-Wins.x, -Wins.y)  # Remove the original Wins.x and Wins.y columns

# Save the updated final_table
write.csv(final_table, "~/Downloads/Final_Table_With_Single_Wins.csv", row.names = FALSE)

cat("Wins.x and Wins.y merged into a single Wins column successfully.")

