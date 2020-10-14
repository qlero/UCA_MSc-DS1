library(dplyr)
library(ggplot2)
library(dslabs)

### importing data
data <- murders

### 3 ways to plot
# ggplot(data = data)
# data %>% ggplot()
# p <- ggplot(data = data)

### Using ggplot for basic viz
data %>% ggplot() + geom_point(aes(x=population/10^6, y=total))
# p <- ggplot(data = data)
# p+geom_point(aes(x=population/10^6, y=total))

p <- ggplot(data = data)
p + geom_point(aes(x=population/10^6, y=total)) + 
  geom_text(aes(population/10^6, total, label = abb))

p + geom_point(aes(x=population/10^6, y=total), size = 3) + 
  geom_text(aes(population/10^6, total, label = abb), nudge_x = 1.5)

####

p <- murders %>% ggplot(aes(population/10^6, total, label = abb))

p + geom_point(size=3) + geom_text(aes(x=10, y=800, label = "Hello there!"))

p + geom_point(size = 3) +
  geom_text(nudge_x = 0.075) +
  scale_x_continuous(trans = "log10") +
  scale_y_continuous(trans = "log10")

p + geom_point(size = 3) +
  geom_text(nudge_x = 0.05) +
  scale_x_log10() + scale_y_log10()

p + geom_point(size = 3) +
  geom_text(nudge_x = 0.05) +
  scale_x_log10() + scale_y_log10() +
  xlab("Populations in millions (log scale)") +
  ylab("Total number of murders (log scale)") + 
  ggtitle("US Gun Murders in 2010")

####

p <- murders %>% ggplot(aes(population/10^6, total, label = abb)) + 
  geom_text(nudge_x = 0.05) + scale_x_log10() +
  scale_y_log10() + 
  xlab("Populations in millions (log scale)") + 
  ylab("Total number of murders (log scale)") +
  ggtitle("US Gun Murders in 2010")
p + geom_point(color ="blue ", size = 3 )

p <- murders %>% ggplot(aes(population/10^6, total, label = abb)) + 
  geom_text(nudge_x = 0.075) + scale_x_log10() +
  scale_y_log10() + 
  xlab("Populations in millions (log scale)") + 
  ylab("Total number of murders (log scale)") +
  ggtitle("US Gun Murders in 2010")
p + geom_point(aes(col=region), size = 3 )

r <- murders %>% 
  summarize(rate = sum(total) / sum(population) * 10^6) %>% 
  pull(rate)

p + geom_point(aes(col=region), size = 3) + geom_abline(intercept = log10(r))

install.packages("ggthemes")
install.packages("ggrepel")
library(ggthemes)
library(ggrepel)
p + theme_economist()

r <- murders %>% summarize(rate = sum(total) / sum(population) * 10^6) %>%
  pull(rate)
murders %>% ggplot(aes(population/10^6, total, label = abb)) +
  geom_abline(intercept = log10(r), lty = 2, color = "darkgrey") +
  geom_point(aes(col=region), size = 3) +
  geom_text_repel() +
  scale_x_log10() +
  scale_y_log10() +
  xlab("Populations in millions (log scale)") +
  ylab("Total number of murders (log scale)") +
  ggtitle("US Gun Murders in 2010") +
  scale_color_discrete(name = "Region") +
  theme_economist()

####

data(murders)
x <- log10(murders$population)
y <- murders$total

data.frame(x = x, y = y) %>% ggplot(aes(x, y)) + geom_point()

qplot(x, y)

#### 
install.packages("gridExtra")
library(gridExtra)
#> Attaching package: 'gridExtra’
#> The following object is masked from 'package:dplyr’:
#> combine
p1 <- murders %>% mutate(rate = total/population*10^5) %>%
  filter(population < 2*10^6) %>%
  ggplot(aes(population/10^6, rate, label = abb)) + 
  geom_text() + 
  ggtitle("Small States")
p2 <- murders %>% mutate(rate = total/population*10^5) %>%
  filter(population > 10*10^6) %>%
  ggplot(aes(population/10^6, rate, label = abb)) +
  geom_text() +
  ggtitle("Large States")
grid.arrange(p1, p2, ncol = 2)

###

ggplot(data = mpg) + 
  geom_histogram(aes(x = hwy, y = ..density..), bins=50, fill = 'pink') + 
  geom_density(aes(x = hwy),col = 'green')

ggplot(data = mpg) + geom_boxplot(aes(x = '',y = hwy), fill = 'lightblue')
ggplot(data = mpg) + geom_qq(aes(sample = hwy)) + geom_qq_line(aes(sample = hwy))
ggplot(data = mpg) + geom_bar(aes(x = trans))
ggplot(data = mpg) + geom_bar(aes(x = "", fill = factor(trans)))

# LINEAR MODEL
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(mapping = aes(x = displ, y = hwy), method = 'lm')

out = lm(mpg$hwy ~ 1 + mpg$displ)
plot(out)