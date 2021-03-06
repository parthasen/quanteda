% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/dfm-main.R
\docType{methods}
\name{docfreq}
\alias{docfreq}
\alias{docfreq,dfm,missing-method}
\alias{docfreq,dfm,numeric-method}
\alias{docfreq,dfmDense,missing-method}
\alias{docfreq,dfmDense,numeric-method}
\alias{docfreq,dfmSparse,missing-method}
\alias{docfreq,dfmSparse,numeric-method}
\title{get the document frequency of a feature}
\usage{
docfreq(object, threshold = 0)

\S4method{docfreq}{dfmDense,numeric}(object, threshold = 0)

\S4method{docfreq}{dfmDense,missing}(object, threshold = 0)

\S4method{docfreq}{dfmSparse,numeric}(object, threshold = 0)

\S4method{docfreq}{dfmSparse,missing}(object, threshold = 0)

\S4method{docfreq}{dfm,numeric}(object, threshold = 0)

\S4method{docfreq}{dfm,missing}(object, threshold = 0)
}
\arguments{
\item{object}{a \link{dfm-class} document-feature matrix}

\item{threshold}{numeric value of the threshold for counting a feature
as existing in the document, default is 0}
}
\description{
Returns the document frequency of a feature in a \link{dfm-class} object,
which occurs greater than a threshold.
}

