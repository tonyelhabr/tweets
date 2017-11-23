

library("rtweet")
library("dplyr")
httr::set_config(httr::config(ssl_verifypeer = 0L))

# params:
person1 <- "elhabro"
n_max <- 1000

# df_tweets <-
#   paste0("data/tweets/tweets_", person1, ".csv") %>% 
#   read.csv(stringsAsFactors = FALSE) %>% 
#   tbl_df()
# 
# df_tweets <-
#   df_tweets %>% 
#   arrange(desc(created_at)) %>% 
#   slice(1:n_max)

df_tweets <-
  "goodell" %>%
  search_tweets(n = n_max)

library("tidytext")
library("stringr")

replace_regex <- "https://t.co/[A-Za-z\\d]+|http://[A-Za-z\\d]+|&amp;|&lt;|&gt;|RT|https"
df_tweets <-
  df_tweets %>% 
  # filter(!str_detect(text, "^(RT|@)")) %>%
  mutate(text = str_replace_all(text, "[^[:alnum:] ]", "")) # %>% 
  # mutate(text = str_replace_all(text, replace_regex, ""))

library("text2vec")
prep_fun <- str_to_lower
tok_fun <- word_tokenizer

it_tweets <-
  itoken(
    df_tweets$text,
    preprocessor = prep_fun,
    tokenizer = tok_fun,
    progressbar = TRUE
  )

vectorizer <- readRDS("data/tweets/vectorizer.rds")
dtm_tweets <- create_dtm(it_tweets, vectorizer)

tfidf <- TfIdf$new()
dtm_tweets_tfidf <- fit_transform(dtm_tweets, tfidf)

glmnet_classifier <- readRDS("data/tweets/glmnet_classifier.rds")

library("glmnet")
preds_tweets <-
  predict(glmnet_classifier, dtm_tweets_tfidf, type = "response")[, 1]

# adding rates to initial dataset
df_tweets$sentiment <- preds_tweets

# color palette
# colors <- c("#ce472e", "#f05336", "#ffd73e", "#eec73a", "#4ab04a")
colors <- scales::hue_pal()(5)

df_tweets %>% 
  ggplot(aes(x = created_at, y = sentiment, color = sentiment)) +
  theme_minimal() +
  scale_color_gradientn(
    colors = colors,
    limits = c(0, 1),
    breaks = seq(0, 1, by = 1 / 2)
  ) +
  geom_point(aes(color = sentiment)) +
  geom_hline(
    yintercept = 0.65,
    # color = "#4ab04a",
    color = colors[4],
    size = 2
  ) +
  geom_hline(
    yintercept = 0.35,
    # color = "#f05336" ,
    color = colors[1],
    size = 2
  ) +
  geom_smooth(size = 1.5, color = "black") +
  theme(
    legend.title = element_blank(),
    # legend.position = "bottom"
    legend.position = "none"
  ) +
  # guides(color = guide_legend(title = NULL)) +
  labs(
    x = NULL,
    y = "Probability",
    title = "Sentiment of Tweets",
    subtitle = "Probability of Positivivity",
    caption = "*Value closer to 1 indicates higher positivity."
  )
