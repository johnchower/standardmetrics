% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summarise_data.r
\name{count_signups_multiclass}
\alias{count_signups_multiclass}
\title{Count signups per week (user classes > 2)}
\usage{
count_signups_multiclass(relative_pa_datetimes, user_classes, range_beginning,
  user_set = NULL)
}
\arguments{
\item{relative_pa_datetimes}{A data frame: (user_id, datetime) giving the
moments when a user took a platform action.}

\item{user_classes}{A data frame: (user_id, user_class) that groups users into
classes.}

\item{range_beginning}{A data.table with a single column of dates which 
denote the first days of each date range.}

\item{user_set}{A subset of users to restrict the calculation to. If not set
(ie NULL) then all users available in relative_pa_datetimes are used.}
}
\value{
A data frame: (week_beginning, number_of_signups)
}
\description{
Count signups per week (user classes > 2)
}

