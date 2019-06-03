library(tidyverse)
library(superheat)

# read data ---------------------------------------------------------------

dat <-
  read_csv2("dati/ds27_pop_sto_quartiere.csv") %>% 
  janitor::clean_names()


# explore -----------------------------------------------------------------


# Select top 15 communities
top_15_2018 <- 
  dat %>%
  filter(cittadinanza != "Italia",
         anno == 2018) %>% 
  group_by(cittadinanza) %>% 
  summarise(n = sum(residenti)) %>% #arrange(desc(n))
  top_n(n = 15, wt = n) %>% 
  pull(cittadinanza)
  


# boxplot:
# citizens by disctrict
# of top 15 communities in 2018

pdf(file = "plots/top_15_2018_by_quartiere.pdf",
    height = 20,
    width = 30)
p <- 
  dat %>%  
  filter(cittadinanza %in% top_15_2018) %>% 
  group_by(anno, nil, cittadinanza) %>% 
  summarise(residenti = sum(residenti)) %>% 
  ggplot(aes(x = anno,
             y = residenti,
             group = anno)) +
  geom_boxplot() +
  facet_wrap(facets = "nil", scales = "free_y")

p %>% print()
dev.off()

# boxplot:
# citizens by citizenship
# of top 15 communities in 2018


pdf(file = "plots/top_15_2018_by_cittadinanza.pdf",
    height = 14,
    width = 18)
p2 <- 
  dat %>%  
  filter(cittadinanza %in% top_15_2018) %>% 
  group_by(anno, nil, cittadinanza) %>% 
  summarise(residenti = sum(residenti)) %>% 
  ggplot(aes(x = anno,
             y = residenti,
             group = anno)) +
  geom_boxplot() +
  # ggbeeswarm::geom_beeswarm(alpha = .5) + 
  facet_wrap(facets = "cittadinanza", scales = "free_y")

p2 %>% print()
dev.off()


# heatmap cittadini vs quartiere 2018 -------------------------------------


# Need total population by disctrict 
# to scale communities
pop_quar <- 
  dat %>% 
  filter(anno == 2018) %>% 
  group_by(nil) %>% 
  summarise(residenti_tot = sum(residenti, na.rm = T))


# Select only top 30 communities
# We take more if needed
top_30_2018 <- 
  dat %>%
  filter(cittadinanza != "Italia",
         anno == 2018) %>% 
  group_by(cittadinanza) %>% 
  summarise(n = sum(residenti)) %>% #arrange(desc(n))
  top_n(n = 30, wt = n) %>% 
  pull(cittadinanza)


# Heatmap
# Distribution of top 30 communities in districts
# in 2018

pdf("plots/2018-heatmap.pdf", height = 12, width = 25)
p3 <- 
  dat %>%  
  filter(anno == 2018,
         cittadinanza %in% top_30_2018) %>% 
  left_join(pop_quar) %>%
  # NA to 0
  # reasonable assumption?
  mutate(residenti = case_when(is.na(residenti) ~ 0,
                               TRUE ~ residenti)) %>%
  # summarize community size
  group_by(anno, nil, cittadinanza, residenti_tot) %>% 
  summarise(residenti = sum(residenti)) %>% 
  ungroup() %>%
  # ration of community size to total district's population size
  mutate(residenti = residenti/residenti_tot) %>% 
  group_by(cittadinanza) %>% 
  # scale everything 0 to 1
  # for relative comparison of community among district
  mutate(residenti = scales::rescale(residenti, to = c(0,1), from = c(0, max(residenti)))) %>%
  select(-anno, - residenti_tot) %>% 
  # prepare data for heatmap
  spread(key = "nil",
         value = "residenti") %>% 
  column_to_rownames("cittadinanza") %>% 
  # plot heatmap
  superheat(pretty.order.cols = T,
            row.dendrogram = T, 
            bottom.label.text.angle = 90,
            bottom.label.text.size = 3) 

p3 %>% print()
dev.off()  
  
  

