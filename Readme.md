#TidyTuesday (https://github.com/rfordatascience/tidytuesday) is a social coding project in R that challenges data scientists to analyze a new dataset each week! This repository houses some of my analyses, all conducted in R.

---

## Gender bias in guest stars on the Simpsons (gender imputed using an API)

![alt_text](https://github.com/rthorst/TidyTuesday/blob/master/simpsons/celeb_means.png)

---

I often try to bring a more sophisticated statistical approach to published claims. Sometimes, I find these claims are not correct. For example, the website FiveThirtyEight claimed that "National Parks have never been so popular" as the present. I suspected that the results could be due to the fact that population has grown rapidly in the US. When the results are normalized by population (red line), I find that national parks have actually been growing less popular since the 1990s. 

![alt_text](https://raw.githubusercontent.com/rthorst/TidyTuesday/master/national_parks/fig.png)

As another example, there were claims that US schools are becoming more diverse over time. While this is true, I suspected that this pattern could be explained in part by the very same schools that are already diverse becoming even more diverse, while those schools that lag behind continuing to lag behind. Supporting this idea, I found that US states with more diverse schools in the 1990s were the same states with more diverse schools in the 2010s, although future analyses should be conducted on individual schools rather than states. 

![alt_text](https://raw.githubusercontent.com/rthorst/TidyTuesday/master/school_diversity/fig.png)

One of the more interesting analyses was a dataset of weightlifting competitions, which I discovered included data about lifters who had been disqualified for performance-enhancing drugs! As a lifelong sports fan, I have always wondered how much these drugs actually improve athlete performance, and weightlifting seems the purest test of their effect. I was able to show that performance-enhancing drugs added almost 40kg to a lifter's bench press, a finding that remained (although with roughly half the effect size) in regression models for age and gender. 

![alt_text](https://raw.githubusercontent.com/rthorst/TidyTuesday/master/powerlifting/fig.png)

Finally, I had the chance to explore data about car fuel economy over time. I wondered whether cars are becoming more fuel efficient, on average, simply because of the growth of electric cars (I verified this is not the case using regression models). The most interesting finding, however, is that the gains in fuel economy are most prominent for certain types of driving. Cars are becoming fuel efficient on the highway much faster than they are in city driving: a fact I verify below by plotting regression slopes. 

![alt_text](https://raw.githubusercontent.com/rthorst/TidyTuesday/master/car_fuel_economy/fig.png)
