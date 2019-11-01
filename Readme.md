#TidyTuesday (https://github.com/rfordatascience/tidytuesday) is a social coding project in R that challenges data scientists to analyze a new dataset each week! This repository houses some of my analyses, all conducted in R.

---

## Gender bias in guest stars on the Simpsons (gender imputed using an API)

![alt_text](https://github.com/rthorst/TidyTuesday/blob/master/simpsons/celeb_means.png)

---

## National Parks are Declining in Popularity

(The key is to correct for growing population -- red line). 

![alt_text](https://raw.githubusercontent.com/rthorst/TidyTuesday/master/national_parks/fig.png)

---

## School Diversity is Constant Across States

US schools are growing more diverse over time - but, the most diverse states from the 1990s still have the most diverse schools today. l

![alt_text](https://raw.githubusercontent.com/rthorst/TidyTuesday/master/school_diversity/fig.png)

One of the more interesting analyses was a dataset of weightlifting competitions, which I discovered included data about lifters who had been disqualified for performance-enhancing drugs! As a lifelong sports fan, I have always wondered how much these drugs actually improve athlete performance, and weightlifting seems the purest test of their effect. I was able to show that performance-enhancing drugs added almost 40kg to a lifter's bench press, a finding that remained (although with roughly half the effect size) in regression models for age and gender. 

![alt_text](https://raw.githubusercontent.com/rthorst/TidyTuesday/master/powerlifting/fig.png)

Finally, I had the chance to explore data about car fuel economy over time. I wondered whether cars are becoming more fuel efficient, on average, simply because of the growth of electric cars (I verified this is not the case using regression models). The most interesting finding, however, is that the gains in fuel economy are most prominent for certain types of driving. Cars are becoming fuel efficient on the highway much faster than they are in city driving: a fact I verify below by plotting regression slopes. 

![alt_text](https://raw.githubusercontent.com/rthorst/TidyTuesday/master/car_fuel_economy/fig.png)
