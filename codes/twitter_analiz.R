require(twitteR)
require(stringr)
require(tm)
require(wordcloud)


consumerKey <- "XXXXXXXXXXXX"
consumerSecret <- "XXXXXXXXXXXX"
access_token="XXXXXXXXXXXX"
access_secret="XXXXXXXXXXXX"
setup_twitter_oauth(consumerKey,consumerSecret,access_token,access_secret)


r_stats<- searchTwitter("#spacex",n=1500,since = "2009-01-01")

r_stats_text <- sapply(r_stats, function(x) x$getText())
tweets.text=unique(r_stats_text)
# smiley at
tweets.text=str_replace_all(tweets.text,"[^[:graph:]]", " ") 
tweets.text=str_replace_all(tweets.text,"rtab2015", " ") 
# k???k harfe ?evir
tweets.text <- tolower(tweets.text)
# Replace blank space ("rt")^
tweets.text <- gsub("rt", "", tweets.text)
# kullanici mention at @UserName
tweets.text <- gsub("@\\w+", "", tweets.text)
# noktalama isaretlerini at
tweets.text <- gsub("[[:punct:]]", "", tweets.text)
# linkleri at
tweets.text <- gsub("http\\w+", "", tweets.text)
# tablari at
tweets.text <- gsub("[ |\t]{2,}", "", tweets.text)
# bastaki bosluklari at
tweets.text <- gsub("^ ", "", tweets.text)
# sondaki bosluklari at
tweets.text <- gsub(" $", "", tweets.text)

#stopword çıakrma
corpus <- Corpus(VectorSource(tweets.text))
#stopwrods from text file
#stopwords_tr <- readLines("turkce_stopwords.txt",encoding="UTF-8")
#mystopwords <- c('dedi','ile','bunu','buna','gibi','bir','hem','her','...','to','ve','for','hiç','yok','the','var','ama','yeni','eski','biz','gün','son','ilk','and','one','için','çok','iyi','are','için','kişi','ben','antalya','izmir','travel')

corpus1 <- tm_map(corpus,removeWords,c(stopwords("English"),"this","will","de","en","la","via"))


r_stats_text=tweets.text

r_stats_text_corpus <- Corpus(VectorSource(corpus1))
wordcloud(r_stats_text_corpus, min.freq = 5, scale=c(2,0.8),colors=brewer.pal(8, "Dark2"), random.color= TRUE, random.order = FALSE, max.words = 500)

# dtm <- DocumentTermMatrix(corpus)
# as.matrix(dtm)
# dtm1 <- DocumentTermMatrix(corpus1)
# as.matrix(dtm1)

#dendrogram oluşturma
tdm <- TermDocumentMatrix(corpus1,control = list(wordLengths = c(1,Inf)))
tdm2 <- removeSparseTerms(tdm, sparse = 0.98)
m2 <- as.matrix(tdm2)

# cluster termleri
distMatrix <- dist(scale(m2))
fit <- hclust(distMatrix, method = "ward.D2")
plot(fit)
rect.hclust(fit, k = 6) 
