
# load rtweet
library("rtweet")

## whatever name you assigned to your created app
appname <- "tonyelhabr"
appname <- "tonyelhabr_ercot"

## api key (example below is not a real key)
key <- "Rgs6v9QgHOoKnJXARl537FCgj"
key <- 	"DZHusWAzyiFZTEDQno5oEwpIX"

## api secret (example below is not a real key)
secret <- "bh5m9cy4vUPsISTr5dtPMTsSWpn9et1Tb0bJEaY1jPWg78wlKv"
secret <- "SZdfAy7ELrcR0vPwM4tHeyHihkD3bU0uz71iaq2gxiHkbrhJFk"

## create token named "twitter_token"
twitter_token <- create_token(
  app = appname,
  consumer_key = key,
  consumer_secret = secret)

## path of home directory
home_directory <- path.expand("C:/Users/aelhabr/Dropbox/data_science/projects")
home_directory <- path.expand("O:/_other/code/tony")

## combine with name for token
file_name <- file.path(home_directory, "tweets/twitter_token.rds")
file_name <- file.path(home_directory, "data/tweets/twitter_token_ercot.rds")

## save token to home directory
saveRDS(twitter_token, file = file_name)

