### 
# Robert Thorstad, thorstadrs@gmail.com.
# 

# Tidy R exercise: The Simpsons.
# Gender analysis of Simpsons guest stars.


library(magrittr)
library(ggplot2)

# Clear R environment and set up working directory and progressbar.
cat("Clear R environment and set working directory")
rm(list = ls(all.names = TRUE))
setwd(file.path("S:", "rthorst", "misc", "r_tidy_tuesday"))
pb <- progress::progress_bar$new(total = 1387)

##########################################################################
####### Read data from internet and add gender column. Run only once due 
####### to rate limits for the gender api. 
############################################################################

# 
# # load data
# simpsons <- readr::read_delim("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-08-27/simpsons-guests.csv",
#                               delim = "|", quote = "")
# 
# # Helper function to classify gender using an API.
# GetGender <- function(name) {
# 
#   # get query URL.
#   base_url <- "https://api.namsor.com/onomastics/api/json/gender/"
#   query_url <- paste(base_url, gsub(" ", "/", name)) %>%
#                gsub(" ", "", .)
# 
#   # get result and return content.
#   query_result <- httr::GET(query_url) %>%  httr::content(.)
#   gender <- query_result["gender"]$gender
# 
#   return(gender)
# }
# 
# # Add gender column.
# genders <- c()
# for (guest_name in simpsons$guest_star) {
# 
#   gender <- try(GetGender(guest_name)) # on exception, gender will be a string of the error message.
#   if (is.null(gender)) {gender <- "NA"}
#   genders <- append(genders, gender)
#   pb$tick()
# }
# simpsons$gender <- genders
# 
# # Write dataset.
# save(simpsons, file="simpsons.RData")

################ Prepare dataset for analysis #####################################

# Load data.
miceadds::load.Rdata(filename="simpsons.Rdata", objname="simpsons")

# Keep only rows where gender is "male" or "female" (drop "NA" and error messages.)
valid_gender_mask <- simpsons$gender %in% c("male", "female")
simpsons <- simpsons[valid_gender_mask, ]

# Fix season column: drop rows from the movie and cast string season number to integer.
not_movie_mask <- !(simpsons$season %in% "Movie")
simpsons <- simpsons[not_movie_mask, ]
simpsons$season <- as.integer(simpsons$season)

# Encode gender ordinally: 1 = Male, 2 = Female
simpsons$male <- as.integer(simpsons$gender == "male")

# Calculate gender ratio by season.
percent_male_by_season <- c()
for (season in unique(simpsons$season)) {
  season_df <- simpsons[simpsons$season == season, ]
  percent_male <- 100  * mean(season_df$male)
  percent_male_by_season <- append(percent_male_by_season, percent_male)
}



################## Plotting ########################################
# Goal is to show there's a gender gap which does not change with time.

# Set up dataframe of means.
df_means <- data.frame(
  gender = c("Male", "Female"),
  percent = c(mean(percent_male_by_season), 100-mean(percent_male_by_season))
)  
  

# Plot means.
ggthemr::ggthemr(palette="earth")
p <- ggplot(data = df_means, aes(gender, percent)) + 
  geom_bar(stat="identity") + 
  ylab("Percent of Actors") + 
  xlab("") +
  ggtitle("Gender Ratio of Simpsons\nGuest Stars") +
  theme_classic()


# Format plot.
grid(FALSE)

# Save.
ggsave(filename="means.png", plot=p, height=4, width=4)


################# Plot gender balance for celebrity appearances only ###################

# Celebrity roles are specified by "Himself" or "Herself"
celebrities_df <- simpsons[simpsons$role %in% c("Himself", "Herself"), ]

# Set up dataframe of means.
df_means <- data.frame(
  gender = c("Male", "Female"),
  percent = c(100*mean(celebrities_df$male), 100 - 100*mean(celebrities_df$male))
)  


# Plot means.
ggthemr::ggthemr(palette="earth")
p <- ggplot(data = df_means, aes(gender, percent)) + 
  geom_bar(stat="identity") + 
  ylab("Percent of Actors") + 
  xlab("") +
  ggtitle("Gender Ratio of \n Celebrity Guest Stars") +
  theme_classic()


# Format plot.
grid(FALSE)

# Save.
ggsave(filename="celeb_means.png", plot=p, height=4, width=4)

# # Set up dataframe of time series.
# df_plot <- data.frame(
#   season = unique(simpsons$season), 
#   percent_male = percent_male_by_season, 
#   avg = rep(mean(percent_male_by_season), max(simpsons$season))
# )
# 
# # Plot time series.
# geom_main <- geom_line(color="black", size=3)
# ggplot(data = df_plot, ggplot2::aes(x=season, y=percent_male)) + geom_main

##################### Wikipedia API ###############################################


CheckIfWikipediaArticleExists <- function(s) {
  
  base_url <- "https://en.wikipedia.org/w/api.php?action=opensearch&limit=1&search="
  query_url <- paste(base_url, s) %>% 
    gsub(" ", "", .)
  
  description <- httr::GET(query_url) %>% 
    httr::content() %>% 
    .[[3]] 

  return (as.integer(length(description) > 0))
}

simpsons$HasWikipediaArticle <- lapply(simpsons$role, CheckIfWikipediaArticleExists)
has_wikipedia_article <- c()
for (v in simpsons$HasWikipediaArticle) {
  has_wikipedia_article <- append(has_wikipedia_article, v[[1]])
}
simpsons$HasWikipediaArticle <- has_wikipedia_article

male <- simpsons[simpsons$male == 1, ]
female <- simpsons[simpsons$male == 0, ]
male_wiki_avg <- mean(male$HasWikipediaArticle)
female_wiki_avg <- mean(female$HasWikipediaArticle)

