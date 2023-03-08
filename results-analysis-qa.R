library(tidyr)
library(dplyr)

annual_est <- read.csv2('annual_estimates.csv', sep = ',')

x <- annual_est %>%
  select(!(X1828:X1994)) %>%
  group_by(Sector, Industry, Asset, Measure) %>%
  pivot_longer(cols = X1995:X2021) %>%
  mutate(Year = sub('X','',name)) %>%
  select(!name)

write.csv(x, file = 'annual_estimates_long.csv')
