# download.file(url = "http://curl.haxx.se/ca/cacert.pem", destfile = "cacert.pem")
# oauth_tony <-
#   setup_twitter_oauth(
#   "5OvJTsyfr3tGuHslzHCfJoAjf",
#   "1VaXjC3fJB4OQM2xgRuv7NgjS3MAZnRORYRcUS6vNLfgxwE4ly",
#   "3320523836-z8TjqZVRLarVcKRZG7cfpAhaveEh23WKxBKxTMn",
#   "YYeXG4w1dHEdxtDzanMGr9aPjHso31ufDM68581mpLSis"	
# )	
# save(oauth_tony, file = "/data/oauth_tony.RData")
# save.image(file = "oath_tony.RData")
# rm(oauth_tony)
# load("data/oauth_tony.RData")
# 	
# tweets_elhabro <-	
#   userTimeline("elhabro", n = 3200) %>%
#   twListToDF()