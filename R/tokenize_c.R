#' c tokenizing function
#'
#' @author Kohei Watanabe
#' @rdname tokenize_c
#' 
#' @param x string to be tokenized
#' @param sep by default, tokenize expects a "white-space" delimiter between
#'   tokens. Alternatively, \code{sep} can be used to specify another character
#'   which delimits fields.
#' @importFrom Rcpp evalCpp
#' @useDynLib quanteda
#' @export
#' @export
tokenize_c <- function(x, sep=' ', simplify=FALSE,
                      minLength=1, toLower=TRUE, removeDigits=TRUE, removePunct=TRUE,
                      removeTwitter=TRUE, removeURL=TRUE, removeAdditional=''){

    if(simplify){
      return(tokenizecpp(x, sep, minLength, toLower, removeDigits, removePunct, 
                         removeTwitter, removeURL, removeAdditional))
    }else{
      return(list(tokenizecpp(x, sep, minLength, toLower, removeDigits, removePunct, 
                         removeTwitter, removeURL, removeAdditional)))
    
    }
}
