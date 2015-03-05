#' c tokenizing function
#'
#' @author Kohei Watanabe
#' @rdname tokenize_c
#' @importFrom Rcpp evalCpp
#' @useDynLib quanteda
#' @export
tokenize_c <- function(x, sep=' ', simplify=FALSE,
                      minLength=1, toLower=TRUE, removeDigits=TRUE, removePunct=TRUE,
                      removeTwitter=TRUE, removeURL=TRUE, removeAdditional=''){
    Sys.setenv("PKG_LIBS"="-lpcrecpp")
    if(simplify){
      return(tokenizecpp(x, sep, minLength, toLower, removeDigits, removePunct, 
                         removeTwitter, removeURL, removeAdditional))
    }else{
      return(list(tokenizecpp(x, sep, minLength, toLower, removeDigits, removePunct, 
                         removeTwitter, removeURL, removeAdditional)))
    
    }
}
