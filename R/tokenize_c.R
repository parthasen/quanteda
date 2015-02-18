rm(list = ls())
setwd("/home/kohei/Documents/R")

#devtools::install_github("kbenoit/quanteda", ref="dev")
#devtools::install_github("kbenoit/quantedaData")
#require(quanteda)
#require(quantedaData)

# Compile
#install.packages('Rcpp')
require(Rcpp)
Sys.setenv("PKG_LIBS"="-lpcrecpp") # This is importanat
Rcpp::sourceCpp('src/tokenize.cpp')

#' @rdname tokenize_c
#' @importFrom Rcpp evalCpp
#' @useDynLib quanteda
#' @param compatible with its R version
tokenize_c <- function(x, sep=' ', simplify=FALSE,
                      minLength=1, toLower=TRUE, removeDigits=TRUE, removePunct=TRUE,
                      removeTwitter=TRUE, removeURL=TRUE, removeAdditional=NULL){
    remove <- c()
    if(removeDigits){
      remove <- c(remove,'[[:digit:]]')
    }
    if(removePunct){
      remove <- c(remove,'[[:punct:]]')
    }
    if(!is.null(removeAdditional)){
      remove <- c(remove, removeAdditional)
    }
    if(simplify){
      return(tokenizecpp(x, sep, paste0(remove, collapse='|'), 
                         minLength, toLower, removeTwitter, removeURL))
    }else{
      return(list(tokenizecpp(x, sep, paste0(remove, collapse='|'), 
                         minLength, toLower, removeTwitter, removeURL)))
    
    }
  
}

# Dev -----------------------------------------

text1 <- 'This is 1 sentence with 2.0 numbers in it, and one comma.'
text2 <- "We are his Beliebers, and him is #ourjustin @justinbieber we luv u"
text2 <- "We are his Beliebers, and him is @justinbieber"
text3 <- "Collocations can be represented as inheritance_tax using the _ character."
text4 <- "But under_scores can be removed with removeAdditional."
text5 <- "This is a $1,500,000 budget and $20bn cash and a $5 cigar"
text6 <- "URL regex from http://daringfireball.net/2010/07/improved_regex_for_matching_urls."

tokenize(text1, removeDigits=FALSE)
tokenize_c(text1, removeDigits=FALSE)
tokenize(text1, toLower=FALSE)
tokenize_c(text1, toLower=FALSE)
tokenize(text2, removeTwitter=TRUE)
tokenize_c(text2, removeTwitter=TRUE)
tokenize(text4, removeAdditional="[_]")
tokenize_c(text4, removeAdditional="[_]")
tokenize(text5, removeDigits=FALSE)
tokenize_c(text5, removeDigits=FALSE)
tokenize(text6, removeURL=TRUE)
tokenize_c(text6, removeURL=TRUE)


text7 <- as.character('Вчера в Минске завершились переговоры Путина, Меркель, Олланда и Порошенко по вопросу урегулирования конфликта на Украине. По сути, стороны не пришли к каким-то значимым договоренностям. Порошенко зажат между Дебальцевским котлом и Обамой, а Россия уступать не намерена. Об этом в эфире видеоканала Pravda.Ru рассказывает политолог Сергей Михеев.')
text8 <- as.character('A very common operation with strings, is to tokenize it with a delimiter of your own choice. This way you can easily split the string up in smaller pieces, without fiddling with the find() methods too much. In C, you could use strtok() for character arrays, but no equal function exists for strings. This means you have to make your own. Here is a couple of suggestions, use what suits your best.')

tokenize(text7, removePunct = TRUE)
tokenize_c(text7, removePunct = TRUE)

tokenize(text8, removePunct = TRUE)
tokenize_c(text8, removePunct = TRUE)

# Bnchmark--------------------

#install.packages('microbenchmark')
library(microbenchmark)

text_bech <- text8
#text_bech <- paste(inaugTexts, collapse=' ')
#text_bech <- inaugTexts[2]
microbenchmark(strsplit(text_bech, ' ', fixed=TRUE),
               tokenizecpp(text_bech, ' ', remove="[^a-zA-Z ]", minLength=1, 
                           toLower=TRUE, removeTwitter=TRUE, removeURL=TRUE),
               tokenize_c(text_bech, simplify=TRUE, removeDigits=TRUE, removePunct=TRUE,
                          toLower=TRUE, removeAdditional='[_]', 
                          removeTwitter=TRUE, removeURL=TRUE), 
               tokenize(text_bech, simplify=TRUE, removeDigits=TRUE, removePunct=TRUE,
                        toLower=TRUE, removeAdditional='[_]', 
                        removeTwitter=TRUE, removeURL=TRUE), times=1000)

