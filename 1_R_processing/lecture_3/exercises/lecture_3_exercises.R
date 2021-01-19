### Exercise Lecture 3

# PACKAGES & DATASETS
library(dslabs)
library(gridExtra)
library(ggplot2)
library(ggrepel)
library(dplyr)
library(ggtext)
library(ggrepel)
library(grid)

################################################################################

      #       1. CHANGE THE ARGUMENT OF THE SETWD() FUNCTION LINE 197
     # #         BEFORE RUNNING
    # # #     
   #  #  #    2. CHALLENGE GRAPH IS SET TO WORK WHEN FORMATTED WITH SIZE:
  #   #   #      WIDTH=1000 pixels, HEIGHT=700 pixels
 #         #
#     #     #
#############

################################################################################


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
# Use the star wars data set in the dplyr package to:
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
average_weight <- aggregate(starwars$mass, by=list(starwars$species), FUN=mean)
names(average_weight) <- c("species", "mean_mass")
head(average_weight)

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
# With the Hutt Species included
ggplot(data = joint) + geom_point(aes(x=mean_mass, y=mean_size))  +
  geom_text_repel(aes(x=mean_mass, y=mean_size, label=species)) +
  geom_smooth(aes(x=mean_mass, y=mean_size), method="lm") +
  xlab("Mean weight") +
  ylab("Mean height")

# With the Hutt Species removed
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

setwd("D:/repositories/UCA_MSc-DS1/processing_datasets_with_R/lecture_3/exercises")
dataset <- read.csv("EconomistData.csv")
head(dataset)

#  v0
ggplot(dataset, aes(x = CPI, y = HDI)) +
  geom_point()
#  v1
ggplot(dataset, aes(x = CPI, y = HDI)) +
  geom_point(color="blue")
#  v2
ggplot(dataset, aes(x = CPI, y = HDI)) +
  geom_point(aes(color = Region))
#  v3
ggplot(dataset, aes(x = CPI, y = HDI)) +
  geom_point(aes(size = 2, color = Region)) + 
  guides(size = FALSE)
#  v4
ggplot(dataset, aes(x = CPI, y = HDI)) +
  geom_point(aes(size = HDI.Rank, color = Region)) +
  scale_size(trans = 'reverse') + 
  guides(size = FALSE)

# 2

#  v0
ggplot(dataset, aes(x = CPI, y = HDI)) +
  geom_point()
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
  theme(legend.position="bottom") + 
  guides(size = FALSE)

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
  theme(legend.position="bottom") + 
  guides(size = FALSE)

# 4 

# CREATING THE DATASET
dataset2 <- data.frame(dataset)
dataset2$Region = factor(dataset$Region, 
                         levels=c("EU W. Europe", "East EU Cemt Asia","MENA",
                                  "SSA","Americas","Asia Pacific"),
                         labels=c("OECD","Central &\nEastern Europe", 
                                  "Middle East &\nNorth Africa","Sub-Saharan\nAfrica",
                                  "Americas","Asia &\nOceania"))
dataset2$Region <- factor(dataset2$Region, levels = c("OECD", "Americas", "Asia &\nOceania",
                                                       "Central &\nEastern Europe",
                                                       "Middle East &\nNorth Africa",
                                                       "Sub-Saharan\nAfrica"))

# CREATING THE SUBSETS
subs <- subset(dataset2,
               Country %in% c("Sudan","Myanmar","Iraq","Russia",
                              "Argentina","Greeze","Italy","US","Norway",
                              "New Zealand","India","Rwanda","Bhutan",
                              "Cape Verde","Botswana"))
subs2 <- subset(dataset2,
                Country %in% c("Spain","France","Venezuela",
                               "Germany"))
subs3 <- subset(dataset2,
                Country %in% c("China"))
subs4 <- subset(dataset2,
                Country %in% c("South Africa","Japan","Britain","Afghanistan",
                               "Singapore","Congo","Barbados"))
subs5 <- subset(dataset2,
                Country %in% c("Brazil"))

# CREATING THE PLOT

    # VARIABLES
    legend_val <- c("OECD",
                    "Americas",
                    "Asia &\nOceania",
                    "Central &\nEastern Europe",
                    "Middle East &\nNorth Africa",
                    "Sub-Saharan\nAfrica")
    legend_color_val <- c("#37697E", #https://html-color-codes.info/colors-from-image/
                          "#62C5E5",
                          "#96DBF6",
                          "#57A9A0",
                          "#F14F3B",
                          "#8A3E31")
    color_text <- "#333333"
    color_R_text <- "#BAB7B7"
    
    # DRAWS PLOT
    ggplot(dataset2, aes(x=CPI, y=HDI))+
    geom_smooth(aes(group = 1),
                method="lm", 
                formula=y~log(x),
                se=FALSE,
                color="red")+
    geom_point(aes(color = Region),
               shape=21, 
               size=3,
               stroke=3,
               fill="white")+
    geom_text_repel(aes(label=Country),data=subs, color=color_text,
                    nudge_y=0.03)+
    geom_text_repel(aes(label=Country),data=subs2, color=color_text,
                    nudge_y=0.07,nudge_x=-0.04)+
    geom_text_repel(aes(label=Country),data=subs3, color=color_text,
                    nudge_y=0.05)+
    geom_text_repel(aes(label=Country),data=subs4, color=color_text,
                    nudge_y=-0.04,nudge_x=0.05)+
    geom_text_repel(aes(label=Country),data=subs5, color=color_text,
                    nudge_y=0.04,nudge_x=0.05)+
    ggtitle(expression(bold("Corruption and human development")))+
    labs(caption="Source: Transparency International; UN Human Development Report",
         color=color_text)+
    scale_x_continuous(name = expression(italic("Corruption Perceptions Index, 2011 (10=least corrupt)")),
                       breaks=seq(1,10,by=1),
                       limits=c(1,10))+
    scale_y_continuous(name = expression(italic("Human Development Index, 2011 (1=best)")),
                       breaks=seq(0.2,1.0,by=0.1),
                       limits=c(0.2,1.0))+
    scale_fill_discrete(limits = legend_val)+
    scale_color_manual(name="",
                       values=legend_color_val)+
    theme_minimal()+ 
    theme(plot.title = element_text(size=15,vjust=3.2), 
          plot.caption = element_text(size=11, color=color_text, vjust=-1.2, hjust=0),
          legend.position = c(0.36,1),
          legend.direction = "horizontal",
          legend.text = element_text(size=11,color=color_text),
          axis.title.x = element_text(vjust = -1.5,color=color_text),
          axis.title.y = element_text(vjust = 2.5,color=color_text),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.y = element_line(color = color_R_text),
          panel.grid.minor.y = element_blank())+ 
    theme(aspect.ratio=7/10)+
    guides(col=guide_legend(nrow = 1))
    
    # DRAWS X-AXIS SEGMENT LINE AND TICKS
    grid.segments(x0 = 0.76, x1 = 0.78, y0 = 0.935, y1 = 0.935, gp = gpar(col = "red",lwd=2),
    draw = TRUE)
    grid.text("R²=56%",draw=T,just="left",x=0.79,y=0.94,gp=gpar(col=color_text,fontsize=11))
    grid.segments(x0 = 0.135, x1 = 0.909, y0 = 0.1, y1 = 0.1, gp = gpar(col = color_R_text),
    draw = TRUE)
    for (i in 0:9) {
    grid.segments(x0 = 0.135+0.086*i, x1 =0.135+0.086*i, y0 = 0.1, y1 = 0.105, 
    gp = gpar(col = color_R_text),
    draw = TRUE)
    }

  
