### EXERCISE 1 #################################################################

library(ggplot2)
library(dplyr)
library(gridExtra)

data <- iris
data2 <- mpg
data3 <- diamonds
data4 <- starwars

# 1a) Using the variable 'Sepal.Length" create an histogram.

ggplot(data) + geom_bar(aes(Sepal.Length)) + 
  ggtitle("Petal and sepal length of iris") + 
  labs(y="Petal length (cm)", x = "Sepal length (cm)")

# 1b) Draw the histogram for the variable "Sepal.Length", with 50  blue bins, 
#     where the y-axis represents the densities.  Add a density red line to the 
#     plot. 

ggplot(data,aes(x=Sepal.Length, y=..density..))+ 
  geom_histogram(fill="blue", bins=50) +
  geom_density(color="red") + 
  ggtitle("Petal and sepal length of iris") + 
  labs(y="Petal length (cm)", x = "Sepal length (cm)")

# 1c) Draw a scatterplot of Sepal.Length and Sepal.Width where color and shape 
#     depend on the Species

ggplot(data, aes(x = Sepal.Length, y = Sepal.Width)) + 
  geom_point(aes(shape = Species, color = Species)) + 
  ggtitle("Petal and sepal length of iris") + 
  labs(y="Petal length (cm)", x = "Sepal length (cm)")

# 1d) Add a separate regression line for each group. 

ggplot(data, aes(x = Sepal.Length, y = Sepal.Width)) + 
  geom_point(aes(shape = Species, color = Species)) + 
  geom_smooth(aes(col=Species), method="lm", se=FALSE) + 
  ggtitle("Petal and sepal length of iris") + 
  labs(y="Petal length (cm)", x = "Sepal length (cm)")

# 1e) Then overall a smooth line

ggplot(data, aes(x = Sepal.Length, y = Sepal.Width)) + 
  geom_point(aes(shape = Species, color = Species)) + 
  geom_smooth(aes(col=Species), method="lm", se=FALSE) +
  geom_smooth(se=FALSE,colour="black") + 
  ggtitle("Petal and sepal length of iris") + 
  labs(y="Petal length (cm)", x = "Sepal length (cm)")

# 1f) Draw a separate scatter plot with a regression line, one for each level 
#     of the variable Species 

sub1 <- subset(data, Species=="setosa")
sub2 <- subset(data, Species=="versicolor")
sub3 <- subset(data, Species=="virginica")

p1 <- ggplot(sub1, aes(x = Sepal.Length, y = Sepal.Width)) + 
  geom_point() + geom_smooth(method="lm", se=FALSE) + 
  ggtitle("Petal and sepal length of iris") + 
  labs(y="Petal length (cm)", x = "Sepal length (cm)") + 
  theme(text = element_text(size = 7))

p2 <- ggplot(sub2, aes(x = Sepal.Length, y = Sepal.Width)) + 
  geom_point() + geom_smooth(method="lm", se=FALSE) + 
  ggtitle("Petal and sepal length of iris") + 
  labs(y="Petal length (cm)", x = "Sepal length (cm)") + 
  theme(text = element_text(size = 7))

p3 <- ggplot(sub3, aes(x = Sepal.Length, y = Sepal.Width)) + 
  geom_point() + geom_smooth(method="lm", se=FALSE) + 
  ggtitle("Petal and sepal length of iris") + 
  labs(y="Petal length (cm)", x = "Sepal length (cm)") + 
  theme(text = element_text(size = 7))

grid.arrange(p1, p2, p3, ncol = 3)

### EXERCISE 2 #################################################################

# 2a) Draw a scatter plot for `displ` (x-axis) and `hwy` (y-axis)

ggplot(data2, aes(x = displ, y = hwy)) + geom_point() + 
  ggtitle("Highway mileage vs. Engine displacement") + 
  labs(y="Highway mileage (gal)", x = "Engine displacement (ltr)")

# 2b) Modify the previous scatter plot in such a way that the shape depends on 
#     the class and the colour on the year

ggplot(data2, aes(x = displ, y = hwy)) + 
  geom_point(aes(shape = class, color = year)) + 
  ggtitle("Highway mileage vs. Engine displacement") + 
  labs(y="Highway mileage (gal)", x = "Engine displacement (ltr)")

# 2c) Display the data conditionally on one categorical variable (here the class 
#     variable)- Hint: ?mapping

compact <- subset(data2, class=="compact")
midsize <- subset(data2, class=="midsize")
suv <- subset(data2, class=="suv")
seater2 <- subset(data2, class=="2seater")
minivan <- subset(data2, class=="minivan")
pickup <- subset(data2, class=="pickup")
subcompact <- subset(data2, class=="subcompact")

# Scatter plot for compact class cars
p1 <- ggplot(compact, aes(x = displ, y = hwy)) + geom_point(aes(color = year)) + 
  ggtitle("Highway mileage vs. Engine displacement (compact cars)") + 
  labs(y="Highway mileage (gal)", x = "Engine displacement (ltr)") + 
  theme(legend.position="none") + theme(text = element_text(size = 7))

# Scatter plot for midsize class cars
p2 <- ggplot(midsize, aes(x = displ, y = hwy)) + geom_point(aes(color = year)) + 
  ggtitle("Highway mileage vs. Engine displacement (midsize cars)") + 
  labs(y="Highway mileage (gal)", x = "Engine displacement (ltr)") + 
  theme(legend.position="none") + theme(text = element_text(size = 7))

# Scatter plot for suv class cars
p3 <- ggplot(suv, aes(x = displ, y = hwy)) + geom_point(aes(color = year)) + 
  ggtitle("Highway mileage vs. Engine displacement (SUVs)") + 
  labs(y="Highway mileage (gal)", x = "Engine displacement (ltr)") + 
  theme(legend.position="none") + theme(text = element_text(size = 7))

# Scatter plot for seater2 class cars
p4 <- ggplot(seater2, aes(x = displ, y = hwy)) + geom_point(aes(color = year)) + 
  ggtitle("Highway mileage vs. Engine displacement (2-seater cars)") + 
  labs(y="Highway mileage (gal)", x = "Engine displacement (ltr)") + 
  theme(legend.position="none") + theme(text = element_text(size = 7))

# Scatter plot for minivan class cars
p5 <- ggplot(minivan, aes(x = displ, y = hwy)) + geom_point(aes(color = year)) + 
  ggtitle("Highway mileage vs. Engine displacement (minivans)") + 
  labs(y="Highway mileage (gal)", x = "Engine displacement (ltr)") + 
  theme(legend.position="none") + theme(text = element_text(size = 7))

# Scatter plot for pickup class cars
p6 <- ggplot(pickup, aes(x = displ, y = hwy)) + geom_point(aes(color = year)) + 
  ggtitle("Highway mileage vs. Engine displacement (pickups)") + 
  labs(y="Highway mileage (gal)", x = "Engine displacement (ltr)") + 
  theme(legend.position="none") + theme(text = element_text(size = 7))

# Scatter plot for subcompact class cars
p7 <- ggplot(subcompact, aes(x = displ, y = hwy)) + geom_point(aes(color = year)) + 
  ggtitle("Highway mileage vs. Engine displacement (subcompact cars)") + 
  labs(y="Highway mileage (gal)", x = "Engine displacement (ltr)") + 
  theme(text = element_text(size = 7))

grid.arrange(p1, p2, p3, p4, p5, p6, p7, ncol=2)

# 2d) Load the diamonds dataset. Draw a scatter plot of 'carat' ` (x-axis)  and 
#     'price’ (y-axis) where the colour depends on the variable 'cut', add also 
#     a smooth line and display conditionally on the variable 'color’.

colE <- subset(data3, color="E")
colI <- subset(data3, color="I")
colJ <- subset(data3, color="J")
colH <- subset(data3, color="H")
colF <- subset(data3, color="F")
colG <- subset(data3, color="G")
colD <- subset(data3, color="D")

p1 <- ggplot(colE, aes(x = carat, y = price)) + geom_point(aes(color = cut)) + 
  geom_smooth(method="lm", se=FALSE)  + labs(y="price", x = "carat") +
  ggtitle("Carat rating vs. Price for E-colored gold") + 
  theme(text = element_text(size = 7)) + theme(legend.position="none") 

p2 <- ggplot(colI, aes(x = carat, y = price)) + geom_point(aes(color = cut)) + 
  geom_smooth(method="lm", se=FALSE)  + labs(y="price", x = "carat") +
  ggtitle("Carat rating vs. Price for I-colored gold") + 
  theme(text = element_text(size = 7)) + theme(legend.position="none") 

p3 <- ggplot(colJ, aes(x = carat, y = price)) + geom_point(aes(color = cut)) + 
  geom_smooth(method="lm", se=FALSE)  + labs(y="price", x = "carat") +
  ggtitle("Carat rating vs. Price for J-colored gold") + 
  theme(text = element_text(size = 7)) + theme(legend.position="none") 

p4 <- ggplot(colH, aes(x = carat, y = price)) + geom_point(aes(color = cut)) + 
  geom_smooth(method="lm", se=FALSE)  + labs(y="price", x = "carat") +
  ggtitle("Carat rating vs. Price for H-colored gold") + 
  theme(text = element_text(size = 7)) + theme(legend.position="none") 

p5 <- ggplot(colF, aes(x = carat, y = price)) + geom_point(aes(color = cut)) + 
  geom_smooth(method="lm", se=FALSE)  + labs(y="price", x = "carat") +
  ggtitle("Carat rating vs. Price for F-colored gold") + 
  theme(text = element_text(size = 7)) + theme(legend.position="none") 

p6 <- ggplot(colG, aes(x = carat, y = price)) + geom_point(aes(color = cut)) + 
  geom_smooth(method="lm", se=FALSE)  + labs(y="price", x = "carat") +
  ggtitle("Carat rating vs. Price for G-colored gold") + 
  theme(text = element_text(size = 7)) + theme(legend.position="none") 

p7 <- ggplot(colD, aes(x = carat, y = price)) + geom_point(aes(color = cut)) + 
  geom_smooth(method="lm", se=FALSE)  + labs(y="price", x = "carat") +
  ggtitle("Carat rating vs. Price for D-colored gold") + 
  theme(text = element_text(size = 7))

grid.arrange(p1, p2, p3, p4, p5, p6, p7, ncol=2)

### EXERCISE 3 #################################################################

# Load the starwars dataset.
# 3a) Which variable (column) has the most missing values?

na_count <-sapply(data4, function(y) sum(length(which(is.na(y)))))
na_count[na_count==max(na_count)]

# 3b) How many humans are contained in starwars dataset overall and by gender?

humans <- subset(data4, species=="Human")
nrow(humans)
table(humans$gender)

# 3c) From which homeworld do the most individuals (rows) come from? 

tail(names(sort(table(data4$homeworld))), 1)

# 3d) Create an histogram of the gender distribution of the starwars Universe, 
#     set the title : "Gender distribution of the sw Universe".
# Modify the colour using the command : fill_color_manual.

ggplot(data4, aes(gender)) + geom_histogram(stat="count", aes(fill=gender)) +
  scale_fill_manual(values=c("salmon", "orange"), na.value="gray") +
  ggtitle("Gender distribution of the sw Universe")

# 3f) Draw the densities for feminines and masculines only (removing the droids 
# from the data first)

livings <- data4[data4$species!='Droid',]

ggplot(livings, aes(x=height, color=gender)) +
  geom_density(fill="white", alpha=0.6, position="dodge")

# 3g) Draw a segmented barplot for the variable 'sex' where the colors depend
# on the hair colours  and where on the y-axis the proportions are displayed.

ggplot(data4) + geom_bar(aes(sex, fill = hair_color,), position = 'fill') + 
  scale_y_continuous(labels = scales::percent)

#ggplot(data4) + geom_bar(aes(hair_color, fill = sex,), position = 'fill') + 
#  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
#  scale_y_continuous(labels = scales::percent)
