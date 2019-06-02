library(tidyverse)



# read data ---------------------------------------------------------------

dat <-
  read_csv2("dati/ds27_pop_sto_quartiere.csv") %>% 
  janitor::clean_names()


# explore -----------------------------------------------------------------



# top 15  -----------------------------------------------------------------

# Top 15 citizeships in 2018

top_15_2018 <- 
  dat %>%
  filter(cittadinanza != "Italia",
         anno == 2018) %>% 
  group_by(cittadinanza) %>% 
  summarise(n = sum(residenti)) %>% #arrange(desc(n))
  top_n(n = 15, wt = n) %>% 
  pull(cittadinanza)
  
# boxplot tutti
dat %>% 
  group_by(anno, cittadinanza) %>% 
  summarise(residenti = sum(residenti)) %>% 
  filter(cittadinanza != "Italia") %>% 
  ggplot(aes(x = anno,
             y = residenti,
             group = anno)) +
  scale_y_log10() +
  geom_boxplot()


# cittadini per anno per quartiere
# top 15 2018


pdf(file = "plots/top_15_2018_by_quartiere.pdf",
    height = 20,
    width = 30)
dat %>%  
  filter(cittadinanza %in% top_15_2018) %>% 
  group_by(anno, nil, cittadinanza) %>% 
  summarise(residenti = sum(residenti)) %>% 
  ggplot(aes(x = anno,
             y = residenti,
             group = anno)) +
  geom_boxplot() +
  facet_wrap(facets = "nil", scales = "free_y")
dev.off()

# cittadini per anno per cittadinanza
# top 15 2018

pdf(file = "plots/top_15_2018_by_cittadinanza.pdf",
    height = 14,
    width = 18)
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
dev.off()

# cittadini 


# heatmap cittadini vs quartiere 2018 -------------------------------------

top_30_2018 <- 
  dat %>%
  filter(cittadinanza != "Italia",
         anno == 2018) %>% 
  group_by(cittadinanza) %>% 
  summarise(n = sum(residenti)) %>% #arrange(desc(n))
  top_n(n = 30, wt = n) %>% 
  pull(cittadinanza)



pdf("plots/2018-heatmap.pdf", height = 10, width = 25)
dat %>%  
  filter(anno == 2018,
         cittadinanza %in% top_30_2018) %>% 
  group_by(anno, nil, cittadinanza) %>% 
  summarise(residenti = sum(residenti)) %>% 
  # ungroup() %>% 
  group_by(cittadinanza) %>% 
  mutate(residenti = scales::rescale(residenti, to = c(0,1), from = c(0, max(residenti)))) %>%
  select(-anno) %>% 
  spread(key = "nil",
         value = "residenti") %>% 
  column_to_rownames("cittadinanza") %>% 
  superheat::superheat(pretty.order.cols = T,
                       row.dendrogram = T, 
                       bottom.label.text.angle = 90) 
dev.off()  
  
  

