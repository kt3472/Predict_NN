iVerbs <<- read.csv("data/irrVerbs.csv", stringsAsFactors = FALSE)

stemDocumentfix <- function(x)
{
   PlainTextDocument(paste(stemDocument(unlist(strsplit(as.character(x), " "))),collapse=' '))
}

# Stemming ...
stemCompletion2 <- function(x, dictionary) {
   x <- unlist(strsplit(as.character(x), " "))
   x <- x[x != ""]
   x <- stemCompletion(x, dictionary=dictionary)
   x <- paste(x, sep="", collapse=" ")
   PlainTextDocument(stripWhitespace(x))
}

Verb2Infinitive <- function(myCorpus) {
   splitCorpus <- unlist(strsplit(as.character(myCorpus), " "))
   
   # 과거형을 현재형으로 변환함
   past <- iVerbs$Past[which(iVerbs$Past %in% splitCorpus)]
   curr <- iVerbs$Curr[which(iVerbs$Past %in% splitCorpus)]
   ind <- match(splitCorpus, past)
   ind <- ind[is.na(ind) == FALSE]
   pos <- which(splitCorpus %in% past)
   splitCorpus[pos] <- curr[ind]
   
   # 과거분사형을 현재형으로 변환함
   pp <- iVerbs$PP[which(iVerbs$PP %in% splitCorpus)]
   curr <- iVerbs$Curr[which(iVerbs$PP %in% splitCorpus)]
   ind <- match(splitCorpus, pp)
   ind <- ind[is.na(ind) == FALSE]
   pos <- which(splitCorpus %in% pp)
   splitCorpus[pos] <- curr[ind]

   Verb2Infinitive <- paste(splitCorpus, collapse=' ')
}
