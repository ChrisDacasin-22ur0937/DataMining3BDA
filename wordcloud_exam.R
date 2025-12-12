setwd("C:\\Users\\Computer\\OneDrive\\Desktop\\rprogramming")
getwd

install.packages(c("tm", "SnowballC", "wordcloud", "RColorBrewer"))

library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)

text <- readLines("feedback.txt", encoding = "UTF-8", warn = FALSE)
text <- paste(text, collapse = " ")
corpus <- Corpus(VectorSource(text))

corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, content_transformer(function(x) gsub("[^a-z ]", " ", x)))
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeWords, stopwords("english"))

tdm <- TermDocumentMatrix(corpus)
m <- as.matrix(tdm)
word_freq <- sort(rowSums(m), decreasing = TRUE)
df <- data.frame(word = names(word_freq), freq = word_freq)

# Show Top 10 Words
head(df, 10)

word_freq_rev <- word_freq[order(word_freq, decreasing = FALSE)]

set.seed(1234)
wordcloud(
  words = names(word_freq_rev),
  freq = word_freq_rev,
  min.freq = 2,
  max.words = 1000,
  random.order = FALSE,
  colors = brewer.pal(8, "Dark2")
)

png("wordcloud_exam.png", width = 800, height = 600)
set.seed(1234)
wordcloud(
  words = names(word_freq_rev),
  freq = word_freq_rev,
  min.freq = 2,
  max.words = 1000,
  random.order = FALSE,
  colors = brewer.pal(8, "Dark2")
)
dev.off()

rare_words <- word_freq[word_freq == 1]
rare_words_5 <- head(rare_words, 5)
print(rare_words_5)

png("wordcloud_rare.png", width = 800, height = 600)
wordcloud(
  words = names(rare_words_5),
  freq = rare_words_5,
  min.freq = 1,
  random.order = FALSE,
  colors = brewer.pal(8, "Dark2")
)
dev.off()
