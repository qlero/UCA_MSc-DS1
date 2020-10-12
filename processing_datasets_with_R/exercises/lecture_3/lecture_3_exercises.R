### Exercise Lecture 3

# PACKAGES & DATASETS

library(dslabs)
library(gridExtra)
library(ggplot2)
library(ggrepel)
library(dplyr)

################################################################################

### Exercise 1
# Create a grid of plots with (incl. title, axis labels, colors, state 
# and abb) with total_murders and population_size as data.
# Repeat the previous exercise but now change both axes to be in the log 
# scale.

# 1.
plot_1 <- murders %>% 
  ggplot(aes(population/10^6, total, label=abb)) + 
  geom_point(aes(col=region), size = 3) +
  geom_text_repel() +
  theme(legend.position="none", plot.title=element_text(size=12)) +
  scale_color_discrete(name = "Region") +
  xlab("Populations in millions (norm scale)") +
  ylab("Total number of murders (norm scale)") +
  ggtitle("Total Murders vs. Pop. Size in Norm. Scale")

plot_2 <- murders %>% 
  ggplot(aes(population/10^6, total, label=abb)) +
  geom_point(aes(col=region), size = 3) +
  geom_text_repel() +
  scale_x_log10() +
  scale_y_log10() +
  theme(legend.position="bottom", plot.title = element_text(size=12)) +
  scale_color_discrete(name = "Region") +
  xlab("Populations in millions (log scale)") +
  ylab("Total number of murders (log scale)") +
  ggtitle("Total Murders vs. Pop. Size in Log Scale")

grid.arrange(plot_1, plot_2, ncol = 2)

################################################################################

### Exercise 2
# Use the starwars data set in the dplyr package to:
#  - list the different human characters,
#  - list the different worlds,
#  - compute the average weight and height of the different character types,
#  - display on a plot the number of characters of each type in a decreasing 
#    order,
#    ggplot(data = mpg) + geom_bar(aes(x = trans))
#    Species$count = table(starwars$species)
#  - visualize the relationship between the height and weight of the 
#    different characters.

# 1
humans <- filter(starwars, species == 'Human')
names <- humans$name
head(names)

# 2
worlds <- table(starwars$homeworld)
head(worlds)

# 3
#average_weight <- starwars %>% 
#  group_by(species) %>%
#  summarise(Mean = mean(mass, na.rm=TRUE))
average_weight <- aggregate(starwars$mass, by=list(starwars$species), FUN=mean)
names(average_weight) <- c("species", "mean_mass")
head(average_weight)

#average_size <- starwars %>% 
#  group_by(species) %>%
#  summarise(Mean = mean(height, na.rm=TRUE))
average_size <- aggregate(starwars$height, by=list(starwars$species), FUN=mean)
names(average_size) <- c("species", "mean_size")
head(average_size)

joint <- left_join(average_weight, average_size, by = c("species"))
head(joint)

# 4
countSpecies <- table(starwars$species)
countSpecies <- as.data.frame(countSpecies[order(-as.numeric(countSpecies))])
names(countSpecies) <- c("species", "count")
head(countSpecies)

ggplot(data=countSpecies, aes(x=species, y=count)) +
  geom_bar(stat="identity", fill="#FF9999", colour="black")+
  geom_text(aes(label=count),vjust=-1)+ 
  theme(axis.text.x=element_text(angle=90, hjust=1))


# 5
ggplot(data = joint) + geom_point(aes(x=mean_mass, y=mean_size))  +
  geom_text_repel(aes(x=mean_mass, y=mean_size, label=species)) +
  geom_smooth(aes(x=mean_mass, y=mean_size), method="lm") +
  xlab("Mean weight") +
  ylab("Mean height")

# if we remove the Hutt class of characters:
jointWoHutt <- joint[!(joint$species=="Hutt"),]
ggplot(data = jointWoHutt) + geom_point(aes(x=mean_mass, y=mean_size))  +
  geom_text_repel(aes(x=mean_mass, y=mean_size, label=species)) +
  geom_smooth(aes(x=mean_mass, y=mean_size), method="lm") +
  xlab("Mean weight") +
  ylab("Mean height")

################################################################################

### Exercise 3
# Compare two simulated datasets with a plot and a hypothesis test.
# Use a functions that:
#   visualizes the two distributions with a histogram,
# uses a t-test to compares means and summarizes the results with a string

# 1
sim_dataset_1 <- rnorm(1000, 0.66, 0.66)
sim_dataset_2 <- rnorm(1000, 0, 1)

df_sim_dataset_1 <- data.frame(value = sim_dataset_1)
df_sim_dataset_1$name <- "distribution_1"
df_sim_dataset_2 <- data.frame(value = sim_dataset_2)
df_sim_dataset_2$name <- "distribution_2"

datasets <- rbind(df_sim_dataset_1, df_sim_dataset_2)
head(datasets)

ggplot(datasets, aes(value, fill = name)) + 
  geom_histogram(alpha = 0.4, binwidth=0.2)

# 2

# we are looking into whether the two datasets are independent samples.

t_testing_datasets <- function(ds1, ds2) {
  ttest <- t.test(ds1, ds2, paired=FALSE)
  cat(paste("The t-score is a ratio representing the difference between two ",
            "groups and the difference within the groups.",
            "The t-score is ", round(ttest$statistic,4),
            "The associated p-value is ", signif(ttest$p.value, digits = 5),
            "(low p-values are good)."))
}

ttest <- t_testing_datasets(sim_dataset_1, sim_dataset_2)

################################################################################

### Exercise 4
# PART 1
# The data for the exercises is EconomistData.csv file.
# These data consist of Human Development Index and Corruption Perception Index 
# scores for several countries.
#   - Create a scatter plot with CPI on the x axis and HDI on the y axis
#   - Color the points blue
#   - Map the color of the the points to Region.
#   - Make the points bigger by setting size to 2
#   - Map the size of the points to HDI.Rank
# PART 2
#   - Re-create a scatter plot with CPI on the x axis and HDI on the y axis 
#     (as you did in the previous exercise).
#   - Overlay a smoothing line on top of the scatter plot using geom_smooth.
#   - Overlay a smoothing line on top of the scatter plot using geom_smooth, 
#     but use a linear model for the predictions. Hint: see ?stat_smooth.
#   - Overlay a smoothing line on top of the scatter plot using geom_line. 
#     Hint: change the statistical transformation.
#   - BONUS: Overlay a smoothing line on top of the scatter plot using the 
#     default loess method, but make it less smooth. Hint: see ?loess.
# PART 3
#   - Create a scatter plot with CPI on the x axis and HDI on the y axis. 
#     Color the points to indicate region.
#   - Modify the x, y, and color scales so that they have more easily-understood
#     names (e.g., spell out "Human development Index" instead of "HDI").
#   - Modify the color scale to use specific values of your choosing. 
#     Hint: see ?scale_color_manual.
# PART 4 Challenge - Recreate This Economist Graph exam/Economist1.pdf
# Graph source: http://www.economist.com/node/21541178
# Building off of the graphics you created in the previous exercises, put the 
# finishing touches to make it as close as possible to the original economist 
# graph.

# 1
setwd("D:/repositories/UCA_MSc-DS1/processing_datasets_with_R/exercises/lecture_3")
dataset <- read.csv("EconomistData.csv")
head(dataset)

#  v1
ggplot(dataset, aes(x = CPI, y = HDI)) +
  geom_point(color="blue")
#  v2
ggplot(dataset, aes(x = CPI, y = HDI)) +
  geom_point(size = 2, aes(color = Region))
#  v3
ggplot(dataset, aes(x = CPI, y = HDI)) +
  geom_point(aes(size = HDI.Rank, color = Region)) +
  scale_size(trans = 'reverse')

# 2

#  v1
ggplot(dataset, aes(x = CPI, y = HDI)) + geom_point() + 
  geom_smooth()
#  v2
ggplot(dataset, aes(x = CPI, y = HDI)) + geom_point() + 
  geom_smooth(method="lm")
#  v3
ggplot(dataset, aes(x = CPI, y = HDI)) + geom_point() + 
  geom_line(stat='smooth') + geom_smooth(method="lm")
#  v4
ggplot(dataset, aes(x = CPI, y = HDI)) + geom_point() + 
  geom_smooth(method = "loess", span = 0.5)

# 3

#  v1
ggplot(dataset, aes(x = CPI, y = HDI)) +
  geom_point(aes(size=2, color = Region)) +
  labs(title = "Relationship between HDI and CPI",
       x = "Corruption Perceptions Index",
       y ="Human Development Index") + 
  theme(legend.position="bottom") 

#  v2
ggplot(dataset, aes(x = CPI, y = HDI)) +
  geom_point(aes(size=2, color = Region)) +
  labs(title = "Relationship between HDI and CPI",
       x = "Corruption Perceptions Index",
       y ="Human Development Index") + 
  scale_color_manual(values=c("red", 
                              "blue", 
                              "orange", 
                              "salmon", 
                              "green", 
                              "dark green"),
                     labels=c("Americas",
                              "Asia Pacific",
                              "Eastern Europe & Central Asia", 
                              "Western Europe", 
                              "Middle East & North Africa", 
                              "Sub-Saharan Africa")) + 
  theme(legend.position="bottom") 

# 4  
