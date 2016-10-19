# Tools for loading data from Gloo's databases

#' Return a list of date intervals relative to the current date.
#'
#' @param base_date A date object.
#' @return interval_list A list of (date_interval, functions_to_apply)  pairs.
#'  See standardmetrics::interval_list for an example of how to format this list.

define_date_ranges <- function(base_date = Sys.Date()){
  this_week <- seq.Date(from = base_date - 6
                        , to = base_date
                        , by = 1)
  most_recent_friday <- this_week[which(lubridate::wday(this_week) == 6)]
  most_recent_month <- as.Date(format(base_date, '%Y-%m-01')) 
  
  Days <- seq.Date(from = most_recent_friday - 7
                   , to = most_recent_friday - 1
                   , by = 1)

  Weeks_beginning <- seq.Date(from = most_recent_friday - 28
                              , to = most_recent_friday - 1 
                              , by = 7)

  Months_beginning <- seq.Date(from = as.Date('2016-01-01')
                               , to = most_recent_month
                               , by = 'months')

  list(days = Days
       , weeks_beginning = Weeks_beginning
       , months_beginning = Months_beginning)
}


