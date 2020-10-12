### Exercise Lecture 3

### Exercise 1
# Create a grid of plots with (including title, axis labels, colors, state 
# and abb) with total_murders and population_size as data.
# Repeat the previous exercise but now change both axes to be in the log 
# scale.

library(gridExtra)
library(ggplot2)
library(ggrepel)
library(dplyr)

data(murders)
head(murders)

# 1.
p1 <- murders %>% ggplot(aes(population/10^6, total, label = abb)) + 
  geom_point(aes(col=region), size = 3) +
  geom_text_repel() +
  xlab("Populations in millions (norm scale)") +
  ylab("Total number of murders (norm scale)") +
  scale_color_discrete(name = "Region") +
  theme(legend.position="none", plot.title = element_text(size=12)) +
  ggtitle("Total Murders vs. Pop. Size in Norm. Scale")
p2 <- murders %>% ggplot(aes(population/10^6, total, label = abb)) +
  geom_point(aes(col=region), size = 3) +
  geom_text_repel() +
  xlab("Populations in millions (log scale)") +
  ylab("Total number of murders (log scale)") +
  scale_x_log10() +
  scale_y_log10() +
  scale_color_discrete(name = "Region") +
  theme(legend.position="bottom", plot.title = element_text(size=12)) +
  ggtitle("Total Murders vs. Pop. Size in Log Scale")
grid.arrange(p1, p2, ncol = 2)

### Exercise 2
# Use the starwars data set in the dplyr package to:
#  • list the different human characters,
#  • list the different worlds,
#  • compute the average weight and height of the different character types,
#  • display on a plot the number of characters of each type in a decreasing 
#    order,
#    ggplot(data = mpg) + geom_bar(aes(x = trans))
#    Species$count = table(starwars$species)
#  • visualize the relationship between the height and weight of the 
#    different characters.

# 1
humans <- filter(starwars, species == 'Human')
names <- humans$name
head(names)

# 2
worlds <- starwars$homeworld

# 3
average_weight <- starwars %>% group_by(species) %>%
  dplyr::summarize(Mean = mean(mass, na.rm=TRUE))
average_size <- starwars %>% group_by(species) %>%
  dplyr::summarize(Mean = mean(height, na.rm=TRUE))
joint <- left_join(average_weight, average_size, by = c("species"))

ggplot(data = joint) + geom_point(aes(x=Mean.x, y=Mean.y))  +
  geom_text_repel(aes(x=Mean.x, y=Mean.y, label=species)) +
  xlab("Mean weight (log scale)") +
  ylab("Mean height (log scale)") +
  scale_x_log10() +
  scale_y_log10()

# 4
countSpecies <- table(starwars$species)
countSpecies <- as.data.frame(countSpecies[order(-as.numeric(countSpecies))])
names(countSpecies) <- c("species", "count")
rownames(countSpecies) <- countSpecies$species
countSpecies$species <- NULL

barplot(t(as.matrix(countSpecies)), beside=TRUE)

#5
ggplot(data=joint) + geom_point(aes(x=Mean.x, y=Mean.y)) + 
  geom_smooth(aes(x=Mean.x, Mean.y), method = 'lm')
# if we remove the Hutt
jointWoHutt <- joint[!(joint$species=="Hutt"),] # to use later
ggplot(data=jointWoHutt) + geom_point(aes(x=Mean.x, y=Mean.y)) + 
  geom_smooth(aes(x=Mean.x, Mean.y), method = 'lm')

### Exercise 3
# Compare two simulated datasets with a plot and a hypothesis test.
# Use a functions that:
#   visualises the two distributions with a histogram,
# uses a t-test to compares means and summarises the results with a string

histogram <- function(x1, x2, binwidth=0.1, xlim=c(-3,3)) {
  df <- data.frame(
    x = c(x1, x2),
    g = c(rep("x1", length(x1)), rep("x2", length(x2)))
  )
  ggplot(df, aes(x, fill=g)) + geom_histogram(binwidth = binwidth) + coord_cartesian(xlim = xlim)
  
  
}
t_test <- function(x1, x2) {}
  test <- test(x1, x2)
sprintf()

x1 <- rnorm (100, 0, 0.5)
x2 <- rnorm (200, 0.15, 0.9)

histogram(X1, x2)
cat(t_test(x1, x2))

# Exercise 4
