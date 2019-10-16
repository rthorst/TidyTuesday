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


# Load data.
ipf_lifts <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-08/ipf_lifts.csv") %>% 
  na.omit()

# Recode columns for gender and whether result was disqualification.
ipf_lifts$disqualified <- as.integer(ipf_lifts$place == "DD")
ipf_lifts$male <- as.integer(ipf_lifts$sex == "M")

# Fit regression model: bench press weight by age, gender, weight, and whether DQ.
model <- lm(ipf_lifts$best3bench_kg ~ ipf_lifts$age + ipf_lifts$male + ipf_lifts$bodyweight_kg + ipf_lifts$disqualified)

cat("----------\nRegression Weights for predicting bench press weight")
coef(model)
cat("----------\n95% CI for regression weights")
confint(model)

#### Plot 1: Bench press weight by disqualified Y/N.
ggthemr::ggthemr()
ipf_lifts$disqualified[ipf_lifts$disqualified==0] <- "Not Disqualified"
ipf_lifts$disqualified[ipf_lifts$disqualified==1] <- "Disqualified"
ggplot(ipf_lifts, aes(x=disqualified, y=best3bench_kg)) + 
  geom_boxplot() + 
  theme_classic() + 
  theme(text = element_text(size=20)) + 
  xlab("") + 
  ylab("Bench Press (kg)")

