
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

tweets_tony <-
  read_csv("data/tweets_tony.csv")

tweets_andrew <-
  userTimeline("elhabro", n = 3200) %>%
  twListToDF()
tweets_andrew %>% pull(text)

library("lubridate")
library("ggplot2")
tweets <-
  tweets_andrew %>%
  mutate(person = "elhabro") %>%
  mutate(timestamp = ymd_hms(created))

ggplot(tweets, aes(x = timestamp, fill = person)) +
  geom_histogram(position = "identity",
                 bins = 20,
                 show.legend = FALSE) +
  facet_wrap( ~ person, ncol = 1)

library("tidytext")
library("stringr")

replace_reg <- "https://t.co/[A-Za-z\\d]+|http://[A-Za-z\\d]+|&amp;|&lt;|&gt;|RT|https"
unnest_reg <- "([^A-Za-z_\\d#@']|'(?![A-Za-z_\\d#@]))"
tidy_tweets <- tweets %>% 
  filter(!str_detect(text, "^RT")) %>%
  mutate(text = str_replace_all(text, replace_reg, "")) %>%
  unnest_tokens(word, text, token = "regex", pattern = unnest_reg) %>%
  filter(!word %in% stop_words$word,
         str_detect(word, "[a-z]"))

frequency <- tidy_tweets %>% 
  group_by(person) %>% 
  count(word, sort = TRUE) %>% 
  left_join(tidy_tweets %>% 
              group_by(person) %>% 
              summarise(total = n())) %>%
  mutate(freq = n/total)

frequency

library("tidyr")

frequency <- frequency %>% 
  select(person, word, freq) %>% 
  spread(person, freq)

frequency

library("scales")

ggplot(frequency, aes(elhabro, elhabro)) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.25, height = 0.25) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  geom_abline(color = "red")
download.file(url="http://curl.haxx.se/ca/cacert.pem", destfile = "cacert.pem")
