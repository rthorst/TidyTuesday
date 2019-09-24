
library(magrittr)
library(ggplot2)

# Clean environment and set up working directory.
rm(list = ls(all.names = TRUE))
working_directory <- file.path("S:", "rthorst", "misc", "tidy_tuesday", "national_parks") 
setwd(working_directory)   

# Load data.
df <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-24/school_diversity.csv")

# Calculate a diveristy score.
integrated_map <- c("Diverse"=3, "Undiverse"=2, "Extremely undiverse"=1)
df$diversity_score <- integrated_map[df$diverse]

# Have schools gotten more diverse since 1994? 
# If so, it is the same states, or changing states? 


# Calculate diversity by state / year.
states <- unique(df$ST)
years <- unique(df$SCHOOL_YEAR)

diversity_df <- data.frame(matrix(ncol=3, nrow=0))
colnames(diversity_df) <- c("State", "Year", "Diversity_Score")


for (state in states) {
  
  for (year in years) {
  
    M_diversity_score <- df[(df$ST == state) & (df$SCHOOL_YEAR == year), ]$diversity_score %>% 
                         mean(.)
  
    diversity_df[nrow(diversity_df) + 1, ] <- c(state, year, M_diversity_score)
    

  }
    
}

# Compare diversity in 1994-1995 vs. 2016-2017.
M_diversity_1994 <- diversity_df[diversity_df$Year == "1994-1995", ]$Diversity_Score %>% 
                    as.numeric(.) %>% 
                    mean(., na.rm=TRUE)

M_diversity_2016 <- diversity_df[diversity_df$Year == "2016-2017", ]$Diversity_Score %>% 
  as.numeric(.) %>% 
  mean(., na.rm=TRUE)


msg <- paste("Mean diversity score in 1994-1995 = ", M_diversity_1994, "in 2016-2017 = ", M_diversity_2016)
cat(msg)

# Correlate diversity over time. 
diversities_1994 <- diversity_df[diversity_df$Year == "1994-1995", ]$Diversity_Score %>% as.numeric()
diversities_2016 <- diversity_df[diversity_df$Year == "2016-2017", ]$Diversity_Score %>% as.numeric()
r <- cor.test(x=diversities_1994, y=diversities_2016, method="pearson")

msg <- paste("Correlation in diversity across states over time, r = ", r$estimate, "p = ", r$p.value)
cat(msg)

# Finding: we're getting more diverse, but the most diverse states in 1994 are still the most diverse states in 2016. 
# This can be shown in one scatter plot where the axes change but still correlated, e.g. we're shifted off the diagonal.


# Gather by year.
to_plot <- tidyr::spread(data=diversity_df, key=Year, value=Diversity_Score)
na_rows <- c(14)
to_plot <- to_plot[-na_rows, ]
names(to_plot) <- c("State", "Diversity_1994", "Diversity_2016")
to_plot$Diversity_1994 <- as.numeric(to_plot$Diversity_1994)
to_plot$Diversity_2016 <- as.numeric(to_plot$Diversity_2016)

# Plot.
ggthemr::ggthemr()
p <- ggplot(to_plot, aes(x=Diversity_1994, y=Diversity_2016)) + 
  geom_point() + 
  theme(axis.text = element_blank(), panel.grid = element_blank()) + 
  xlab("Diversity in 1994-1995") + 
  ylab("Diversity in 2016-2017") + 
  geom_abline(slope=1, intercept=0) + 
  xlim(0, 3) + 
  ylim(0, 3)
ggsave(filename="fig.png", plot=p, height=4, width=4)
# I need to plot X = 1994 score, Y = 2016 score.