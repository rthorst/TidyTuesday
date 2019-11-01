#TidyTuesday (https://github.com/rfordatascience/tidytuesday) is a social coding project in R that challenges data scientists to analyze a new dataset each week! This repository houses some of my analyses.

One of the key features of my approach is to think creatively about the kinds of questions a dataset can answer - and this has often involved seeking out additional sources of data. For example, Given data about characters in the Simpsons, I used a machine learning model to impute the gender of the actors who played these characters, revealing a strong gender bias in the guest stars on the Simpsons. 

![alt_text](https://raw.githubusercontent.com/rthorst/TidyTuesday/master/simpsons/means.png)

I often try to bring a more sophisticated statistical approach to published claims. Sometimes, I find these claims are not correct. For example, the website FiveThirtyEight claimed that "National Parks have never been so popular" as the present. I suspected that the results could be due to the fact that population has grown rapidly in the US. When the results are normalized by population (red line), I find that national parks have actually been growing less popular since the 1990s. 

![alt_text](https://raw.githubusercontent.com/rthorst/TidyTuesday/master/national_parks/fig.png)
