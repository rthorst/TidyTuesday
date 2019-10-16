### 
# Robert Thorstad, thorstadrs@gmail.com.
# 

# Tidy R exercise: Car Fuel Economy.

library(magrittr)
library(ggplot2)

# Clear R environment and set up working directory and progressbar.
cat("Clear R environment and set working directory")
rm(list = ls(all.names = TRUE))
setwd(file.path("S:", "rthorst", "misc", "tidy_tuesday", "car_fuel_economy"))

######################################
###### Load data and calculate columns 
######################################

df <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-15/big_epa_cars.csv")
df["Years_Since_1984"] <- df$year - 1984
df["Electric"] <- as.integer(df$fuelType %in% c("Electricity", "Premium Gas or Electricity", "Regulary Gas and Electricity", "Premium and Electricity", "Regular Gas or Electricity"))

#########################################
########### Regression and plot #########

# Regressions.
city_model <- lm(df$city08 ~ df$Years_Since_1984 + df$Electric)
hwy_model <- lm(df$highway08 ~ df$Years_Since_1984 + df$Electric)  

# Create data to plot.
years_since_1984 <- 0:36
year_labels <- (years_since_1984 + 1984)
y_city <- (years_since_1984 * city_model$coefficients[[2]]) + city_model$coefficients[[1]]
y_hwy <- (years_since_1984 * hwy_model$coefficients[[2]]) + hwy_model$coefficients[[1]]

plot_df <- data.frame("Year" = year_labels, "City" = y_city, "Highway" = y_hwy) %>% 
 tidyr::gather(., "Road", "MPG", -Year)

# Plot.
ggthemr::ggthemr()
p <- ggplot(plot_df, aes(x=Year, y=MPG, col=Road)) + 
  geom_line(size=2) + 
  theme(panel.grid = element_blank()) + 
  ylab("MPG, Adjusted for # Electric Vehicles") + 
  labs(color = "Road Type") # legend title.

ggsave(filename="fig.png", plot=p, height=4, width=4)

