#Author : Ege Savcı

require(twitteR)
require(stringr)
require(tm)
require(wordcloud)
require(dplyr)
options(encoding="utf-8")

consumerKey <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
consumerSecret <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
access_token="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
access_secret="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

setup_twitter_oauth(consumerKey,consumerSecret,access_token,access_secret)

# 
top_tweet = userTimeline("bohringerstein", n=5000) #select user and number of tweets

tweets_df = twListToDF(top_tweet) #to DataFrame
tweet_txt = tweets_df$text #to text

#remove @'s and RT's
cleaned_txt <- gsub("(RT|via)((?:\\b\\W*@\\w+)+)","",tweet_txt)
# remove At people
cleaned_txt = gsub("@\\w+", "",cleaned_txt) #remove subtweets
cleaned_txt = gsub("[[:punct:]]", "", cleaned_txt) #remove punctuations

toFile<-file("output.txt") #write tweets a text file
writeLines(cleaned_txt,sep = "\n", toFile)
close(toFile)


filtered <- grep(pattern = "^\\d+\\.", x= tweet_txt, value=TRUE) #take only flood tweets. IT MUST BE START WITH (1.tweet 2.tweet ... etc.) 
filtered

filteredFile <- file("flood.txt") #write cleaned flood to text file
writeLines(filtered,sep = "\n",filteredFile)
close(filteredFile)


