library(plotly)
library(htmlwidgets)

# Define the path to the data folder
data_folder <- "./data"

# Get the list of files in the data folder
file_list <- list.files(data_folder)

# Preparing data for box plots
box_data <- list()
for (file_name in file_list) {
  file_path <- file.path(data_folder, file_name)
  if (endsWith(file_name, ".csv")) {
    df <- read.csv(file_path)
    box_data <- c(box_data, t(df[, 3:ncol(df)]))
  }
}

# Preparing data for scatter plots
scatter_data <- list()
for (file_name in file_list) {
  file_path <- file.path(data_folder, file_name)
  if (endsWith(file_name, ".csv")) {
    df <- read.csv(file_path)
    scatter_data <- c(scatter_data, t(df[, 3:ncol(df)]))
  }
}

# Preparing data for histograms
hist_data <- list()
for (file_name in file_list) {
  file_path <- file.path(data_folder, file_name)
  if (endsWith(file_name, ".csv")) {
    df <- read.csv(file_path)
    hist_data <- c(hist_data, t(df[, 4:ncol(df)]))
  }
}

# Create subplots
fig <- subplot(
  plot_ly() %>% add_boxplot(y = ~box_data[[i]], name = colnames(df)[i + 2], showlegend = FALSE) %>% layout(xaxis = list(title = "Value"), yaxis = list(title = "Frequency")),
  plot_ly() %>% add_markers(x = seq_len(length(scatter_data[[i]])), y = ~scatter_data[[i]], name = colnames(df)[i + 2]) %>% layout(xaxis = list(title = "Value"), yaxis = list(title = "Frequency")),
  plot_ly() %>% add_histogram(x = ~hist_data[[i]], nbinsx = 10, name = colnames(df)[i + 3]) %>% layout(xaxis = list(title = "Value"), yaxis = list(title = "Frequency")),
  nrows = 3, shareX = TRUE
)

# Update layout
fig <- fig %>% layout(height = 900, width = 800, title = "Interactive Visualization")

# Save the visualization as an HTML file
htmlwidgets::saveWidget(fig, "visualization.html", selfcontained = TRUE)

# Open the HTML file in the browser
browseURL(paste0("file://", normalizePath("visualization.html")))
