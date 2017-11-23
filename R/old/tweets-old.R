
# # http://varianceexplained.org/r/trump-tweets/#fn:fullcode ---------------------
library("dplyr")
# library("purrr")
library("twitteR")
setup_twitter_oauth(
  "5OvJTsyfr3tGuHslzHCfJoAjf",
  "1VaXjC3fJB4OQM2xgRuv7NgjS3MAZnRORYRcUS6vNLfgxwE4ly",
  "3320523836-z8TjqZVRLarVcKRZG7cfpAhaveEh23WKxBKxTMn",
  "YYeXG4w1dHEdxtDzanMGr9aPjHso31ufDM68581mpLSis"
)
# 
# trump_tweets <- userTimeline("realDonaldTrump", n = 3200)
# trump_tweets_df <- tbl_df(map_df(trump_tweets, as.data.frame))
# 
# load(url("http://varianceexplained.org/files/trump_tweets_df.rda"))
# 
# library("tidyr")
# 
# tweets <-
#   trump_tweets_df %>%
#   select(id, statusSource, text, created) %>%
#   extract(statusSource, "source", "Twitter for (.*?)<") %>%
#   filter(source %in% c("iPhone", "Android"))
# 
# # http://analyzecore.com/2017/02/08/twitter-sentiment-analysis-doc2vec/ --------
# df_tweets <- twListToDF(searchTwitter("cowboys OR #cowboys", n = 100, lang = 'en'))
# df <- tbl_df(df_tweets)

# --------------
         