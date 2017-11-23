
rm(list = ls())
setwd("O:/_other/projects/tweets/")
# readRDS("data/twitter_token.rds")

# Packages. ----
library("dplyr")
library("rtweet")
library("stringr")
library("readr")

# Parameters. ----


twitter_handle <- "PFTCommenter"
# twitter_user <- "BarstoolBigCat"
# twitter_user <- "elhabro"
# twitter_user <- "TonyElhabr"
# twitter_user <- "RealSkipBayless"
# twitter_user <- "stephenasmith"

num_tweets <- 3200

topic <- "pardon my take"

export <- FALSE
if(export == TRUE) {
  dir_export <- "data/"
  filename_export <- str_c(dir_path, tweets_user, "_tweets.csv")
}

# Do stuff. ----
tweets_user <- get_timeline(twitter_handle, n = num_tweets)

if(export == TRUE) {
  write_csv(tweets, filename_export)
}

# # rtweets does not seem to have the capability to specify start and end times
# # for retrieving tweets (although twitteR does).
# ?twitteR::searchTwitter
# tweets_search_0 <- twitteR::searchTwitter("BarstoolBigCat", n = 100, since = "2017-01-01", until = "2017-02-01")
# ?search_tweets

# Attempting to get only tweets up to a certain point in time. This needs work...
tweets_user$status_id[1]
tweets_recent_1 <- get_timeline(twitter_handle, n = num_tweets, max_id = tweets_user$status_id[1])
tweets_recent_2 <- get_timeline(twitter_handle, n = num_tweets)
twitter_user <- users_data(tweets_recent_1) %>% slice(1)

twitter_trends <- get_trends("United States")
twitter_trends %>%
  select(trend, query, tweet_volume, as_of, place) %>%
  arrange(desc(tweet_volume)) %>%
  head()

# topic <- "cowboys OR \"dallas cowboys\""

tweets_topic <-
  topic %>% 
  search_tweets(n = 1000, type = "recent")

tweets_topic_users <- 
  topic %>% 
  search_users(n = 1000)

tweets_topic_users_data <-
  tweets_topic_users %>% 
  distinct(name, .keep_all = TRUE) %>%  
  users_data() %>% 
  arrange(desc(followers_count))

tweets_topic_users_data %>% 
  select(name, screen_name, followers_count)

