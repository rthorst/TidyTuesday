# Author Robert Thorstad, thorstadrs@gmail.com, 9/16/2019.
# National Parks "Tidy Tuesday" project: 
# See https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-09-17


library(magrittr)
library(ggplot2)

##################### Set up environment. You may need to change the working_directory to the appropriate directory ============

# Clean environment and set up working directory.
rm(list = ls(all.names = TRUE))
working_directory <- file.path("S:", "rthorst", "misc", "tidy_tuesday", "national_parks") 
setwd(working_directory)   

# Load data and save.
# park_visits <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-17/national_parks.csv")
# state_pop <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-17/state_pop.csv")
# gas_price <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-17/gas_price.csv")
# 
# save(park_visits, file="park_visits.RData")
# save(state_pop, file="state_pop.RData")
# save(gas_price, file="gas_price.RData")

# Load data.
data_fnames <- c("gas_price.RData", "park_visits.RData", "state_pop.RData")
obj_names <- c("gas_price", "park_visits", "state_pop")
for (file_num in 1:length(data_fnames)) {
  miceadds::load.Rdata(filename=data_fnames[file_num], objname = obj_names[file_num])
}

######### Analysis #1: Visits/year, adjusted for population #####################

# Steps:
# Get a dataframe of total visits (to all parks) by year.
# Adjust these visits by population. 

# park visits by year.
park_visits_by_year <- aggregate(park_visits$visitors, by=list(park_visits$year), FUN=sum)
names(park_visits_by_year) <- c("year", "visitors")
park_visits_by_year <- park_visits_by_year[park_visits_by_year$year != "Total", ]
park_visits_by_year$year <- as.numeric(park_visits_by_year$year)

# add population.
population <- read.csv("us_population.csv") # source: https://fred.stlouisfed.org/series/POPTOTUSA647NWDB
population$year <- lapply(population$DATE, substring, first=5) %>% as.numeric()
population <- select(population, -c("DATE"))
park_visits_with_population <- dplyr::inner_join(park_visits_by_year, population, by=c("year"))

# normalize visits by population.
park_visits_with_population$visits_over_population <- (park_visits_with_population$visitors / park_visits_with_population$population)

# standardize both columns.
park_visits_with_population$visitors <- scale(park_visits_with_population$visitors)
park_visits_with_population$visits_over_population <- scale(park_visits_with_population$visits_over_population)

# long style dataframe.
to_plot <- tidyr::gather(park_visits_with_population, 'visitors', 'visits_over_population', key="measure", value="score")

# plot.
p <- ggplot(to_plot, aes(x=year, y=score, col=measure)) + 
  geom_line() + 
  ylab("Visitors\n(normalized)") + 
  scale_color_manual(labels = c("Total\nVisitors", "Visitors /\nUS Population"), values = c("blue", "red")) +
  theme_bw() + 
  theme(legend.title = element_blank()) + 
  xlab("Year")

# format plot.
grid(FALSE)

# save plot.
ggsave(filename="fig.png", plot=p, height=2, width=4)