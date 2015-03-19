
Sys.setenv("PKG_LIBS"="")
Sys.setenv("PKG_CPPFLAGS"="-std=gnu++0x")
Rcpp::sourceCpp('src/regx.cpp')