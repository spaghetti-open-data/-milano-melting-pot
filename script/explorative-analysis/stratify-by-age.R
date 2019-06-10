library(tidyverse)
library(ggridges)

# read full dataset -------------------------------------------------------

mi_pop <-
  read_csv2("dati/ds27_pop_sto_quartiere.csv") %>% 
  janitor::clean_names() %>% 
  # Fix age class "100 e piu" to 100
  mutate(eta = case_when(eta == "100 e più" ~ "100",
                         TRUE ~ eta),
         eta = as.integer(eta))




# Italian or any other by age ---------------------------------------------

mi_pop %>% count(eta) %>% View()
mi_pop %>% filter(is.na(eta)) %>% View()

mi_pop_2018 <- 
  mi_pop%>% 
  mutate(cittadinanza = case_when(cittadinanza != "Italia" ~ "Other",
                                  cittadinanza == "Italia" ~ "Italian")) %>% 
  # only last year
  filter(anno == max(anno)) %>% 
  # Count citizens
  group_by(cittadinanza, eta) %>% 
  summarise(residenti = sum(residenti)) 

mi_pop_2018 %>% group_by(cittadinanza) %>% summarise(residenti = sum(residenti))

# histogram
mi_pop_2018 %>% 
  ggplot(aes(x = eta, y = residenti,
             fill = cittadinanza, colour = cittadinanza)) +
  geom_histogram(stat = "identity", alpha = .5) +
  facet_grid(cittadinanza ~ .) +
  theme_bw()

ggsave("plots/hist-italians-foreigner.png", height = 4, width = 7)

# density fill
mi_pop_2018 %>% 
  ggplot(aes(x = eta, y = residenti,
             fill = cittadinanza)) +
  geom_density(stat = "identity", position = "fill",
               alpha = .5) +
  theme_minimal() 

ggsave("plots/density-fill-italians-foreigner.png", height = 3, width = 7)

# top 30 nationalities -----------------------------------------------------

# Select top 30 communities
top_30_2018 <- 
  mi_pop %>%
  filter(anno == 2018) %>% 
  group_by(cittadinanza) %>% 
  summarise(n = sum(residenti)) %>% #arrange(desc(n))
  top_n(n = 30, wt = n) %>% 
  pull(cittadinanza)

top_30_2018

mi_pop_top30_2018 <- 
  mi_pop %>% 
  filter(cittadinanza %in% top_30_2018) %>% 
  # only last year
  filter(anno == max(anno)) %>% 
  # Count citizens
  group_by(cittadinanza, eta) %>% 
  summarise(residenti = sum(residenti)) %>% 
  group_by(cittadinanza) %>% 
  mutate(residenti = scales::rescale(residenti,
                                     to = c(0,1),
                                     from = c(0, max(residenti))),
         residenti = smooth(residenti))

  
mi_pop_top30_2018 %>% 
  ggplot(aes(x = eta,
             y = reorder(cittadinanza, eta, FUN = "median"))) +
  geom_density_ridges(aes(height = residenti), stat = "identity",
                       alpha = .4, scale = 1.2) +
  theme_ridges() +
  labs(x = "age", y = "")

ggsave("plots/ridges-top30-by-age.png")
