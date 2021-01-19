#Workshop2

# ggplot
install.packages('ggplot2')
library(ggplot2)
library(dplyr)
library(tidyverse)


#Exercise 1 
#From iris data:
#1a) Using the variable 'Sepal.Length" create an histogram
ggplot(data = iris) + geom_histogram(aes(x = Sepal.Length))

#1b) Draw the histogram for the variable "Sepal.Length", with 50 blue bins, where the y-axis represents the densities.
#   add a density red line to the plot.

ggplot(data = iris) + geom_histogram(aes(x = Sepal.Length, y = ..density..), 
                                    bins=50, fill = 'blue') + geom_density(aes(x = Sepal.Length),col = 'red')

#1c)From the iris dataset draw a scatterplot of Sepal.Length and Sepal.Width where color and shape depend on the Species
ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species, shape=Species)) +
  geom_point(size=3)


#1d) Add a separate regression line for each group. 
ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species, shape=Species)) +
  geom_point(size=3) +
  geom_smooth(method="lm", aes(fill=Species)) 

#1e) Then overall a smooth line
ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width)) +
  geom_point(size=3, aes(color=Species, shape=Species)) +
  geom_smooth(method="loess", color="black", se=FALSE) +
  geom_smooth(method="lm", aes(color=Species, fill=Species)) 



#1g) Draw a separate scatter plot with a regression line, one for each level of the variable Species 

ggplot(iris,aes(x=Sepal.Length, y=Sepal.Width, color=Species, shape=Species)) +
  geom_point(size=3) +
  geom_smooth(method="lm", aes(fill=Species)) + facet_wrap(~Species)




###Exercise 2
#2a) Plot a scatter plot with the variables `displ` (x-axis) and `hwy` (y-axis)

ggplot(mpg, aes(displ, hwy)) + geom_point()+geom_smooth()

#2b) Modify the previous scatter plot in such a way that the color depends on the class and 
# on the year

ggplot(data = mpg) + geom_point(aes(x = displ,y = hwy,col = class, shape = factor(year)))

#2c)display the data conditionally on one categorical variable (here the class variable)- Hint: ?mapping

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, col = class)) + facet_wrap( ~ class, nrow = 3)


## Load the diamonds dataset. Draw a scatter plot of 'carat' and 'price' where the color depends on the variable 'cut', 
## add also the smooth line and display depending on the variable 'color'
ggplot(data = diamonds,
       mapping = aes(x = carat, y = price)) +
  geom_point(mapping = aes(colour = cut)) +
  geom_smooth(method = 'lm') +
  facet_grid(color ~ .) 

#Exercise 3
#Load the starwars dataset.

sw <- dplyr::starwars
# Which variable (column) has the most missing values?
sw[,which.max(colSums(is.na(sw)))] # => birth_year 

#How many humans are contained in starwars dataset overall and by gender?
sw %>% 
  filter(species == "Human") %>%
  group_by(gender) %>%
  count()

# From which homeworld do the most indidividuals (rows) come from? 
sw %>%
  group_by(homeworld) %>%
  count() %>%
  arrange(desc(n)) 

# Create a bar plot of  gender distribution of the starwars Universe, set the title : "Gender distribution of the sw Universe".
# Modify the color to using the command : scale_color_manual.
mycol=c("yellow", "green", "pink")
ggplot(sw, aes(x = gender)) + geom_bar(aes(fill = gender)) + labs(title = "Gender distribution of the sw Universe",  
                                                                  x = "Gender", y = "Frequency")+ 
  scale_fill_manual(name = "Gender:", values = mycol, na.value = mycol[3])

#Draw the densities for the height of feminines and masculines only (removing the droids from the data first)

starwars %>%
  filter(gender %in% c("feminine", "masculine")) %>%
  ggplot(aes(height, fill = gender)) +
  geom_density()


#Draw a segmented barplot for the variable 'sex' where the colors depend on the hair colours 
#and where on the y-axis the proportions are displayed.
ggplot(data = starwars, mapping = aes(x = sex, fill = hair_color)) +
  geom_bar(position = "fill") +
  labs(y = "proportion")






