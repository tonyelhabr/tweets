
library("rtweet")
library("dplyr")

# person1 <- "elhabro"
# df_tweets <-
#   paste0("data/tweets/tweets_", person1, ".csv") %>% 
#   read.csv(stringsAsFactors = FALSE) %>% 
#   tbl_df()
# 
# df_tweets <-
#   df_tweets %>% 
#   arrange(desc(created_at)) %>% 
#   slice(1:1000)

df_tweets <-
  "las vegas" %>%
  search_tweets(n = 1000)

library("tidytext")
library("stringr")

replace_regex <- "https://t.co/[A-Za-z\\d]+|http://[A-Za-z\\d]+|&amp;|&lt;|&gt;|RT|https"
df_tweets <-
  df_tweets %>% 
  # filter(!str_detect(text, "^(RT|@)")) %>%
  mutate(text = str_replace_all(text, "[^[:alnum:] ]", "")) %>% 
  mutate(text = str_replace_all(text, replace_regex, ""))

library("text2vec")
prep_fun <- tolower
tok_fun <- word_tokenizer

it_tweets <- itoken(
  df_tweets$text,
  preprocessor = prep_fun,
  tokenizer = tok_fun,
  # ids = df_tweets$status_id,
  progressbar = TRUE
)

# creating vocabulary and document-term matrix
vectorizer <- readRDS("data/tweets/vectorizer.rds")
dtm_tweets <- create_dtm(it_tweets, vectorizer)

# transforming data with tf-idf
tfidf <- TfIdf$new()
dtm_tweets_tfidf <- fit_transform(dtm_tweets, tfidf)

# loading classification model
glmnet_classifier <- readRDS("data/tweets/glmnet_classifier.rds")

# predict probabilities of positiveness
library("glmnet")
preds_tweets <-
  predict(glmnet_classifier, dtm_tweets_tfidf, type = "response")[, 1]

# adding rates to initial dataset
df_tweets$sentiment <- preds_tweets

# color palette
cols <- c("#ce472e", "#f05336", "#ffd73e", "#eec73a", "#4ab04a")

set.seed(932)
samp_ind <-
  sample(c(1:nrow(df_tweets)), nrow(df_tweets) * 0.1) # 10% for labeling

library("ggrepel")
# plotting
# Substitute created_at for created
# ggplot(df_tweets, aes(x = created, y = sentiment, color = sentiment)) +
ggplot(df_tweets, aes(x = created_at, y = sentiment, color = sentiment)) +
  theme_minimal() +
  scale_color_gradientn(
    colors = cols,
    limits = c(0, 1),
    breaks = seq(0, 1, by = 1 / 4),
    labels = c(
      "0",
      round(1 / 4 * 1, 1),
      round(1 / 4 * 2, 1),
      round(1 / 4 * 3, 1),
      round(1 / 4 * 4, 1)
    ),
    guide = guide_colourbar(
      ticks = T,
      nbin = 50,
      barheight = .5,
      label = T,
      barwidth = 10
    )
  ) +
  geom_point(aes(color = sentiment), alpha = 0.8) +
  geom_hline(
    yintercept = 0.65,
    color = "#4ab04a",
    size = 1.5,
    alpha = 0.6,
    linetype = "longdash"
  ) +
  geom_hline(
    yintercept = 0.35,
    color = "#f05336",
    size = 1.5,
    alpha = 0.6,
    linetype = "longdash"
  ) +
  geom_smooth(size = 1.2, alpha = 0.2) +
  geom_label_repel(
    data = df_tweets[samp_ind,],
    aes(label = round(sentiment, 2)),
    fontface = "bold",
    size = 2.5,
    max.iter = 100
  ) +
  theme(
    legend.position = "bottom",
    legend.direction = "horizontal",
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    plot.title = element_text(
      size = 20,
      face = "bold",
      vjust = 2,
      color = "black",
      lineheight = 0.8
    ),
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    axis.text.y = element_text(size = 8, face = "bold", color = "black"),
    axis.text.x = element_text(size = 8, face = "bold", color = "black")
  ) +
  ggtitle("Tweets Sentiment rate (probability of positiveness)")

