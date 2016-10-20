# Tools for extracting raw data from Looker

#' Return a list of date intervals relative to the current date.
#'
#' @param base_date A date object.
#' @return interval_list A list of (date_interval, functions_to_apply)  pairs.
#'  See standardmetrics::interval_list for an example of how to format this list.
#' @import data.table

define_date_ranges <- function(base_date = Sys.Date()){
  this_week <- seq.Date(from = base_date - 6
                        , to = base_date
                        , by = 1)
  most_recent_friday <- this_week[which(lubridate::wday(this_week) == 6)]
  most_recent_month <- as.Date(format(base_date, '%Y-%m-01')) 
  
  Days <- seq.Date(from = most_recent_friday - 7
                   , to = most_recent_friday 
                   , by = 1)

  Weeks_beginning <- seq.Date(from = most_recent_friday - 28
                              , to = most_recent_friday  
                              , by = 7)

  Months_beginning <- seq.Date(from = as.Date('2016-01-01')
                               , to = most_recent_month
                               , by = 'months')

  Days_for_months <- seq.Date(from = min(Months_beginning)
                              , to = max(Months_beginning) - 1
                              , by = 'days')
  list(days = 
         data.table::data.table(range_beginning_date = Days)
       , weeks_beginning = 
           data.table::data.table(range_beginning_date = Weeks_beginning)
       , months_beginning = 
           data.table::data.table(range_beginning_date = Months_beginning)
       , days_for_months = 
           data.table::data.table(range_beginning_date = Days_for_months)
  )
}

#' Download user_platform_action_date data from Looker, and format date column
#' correctly.
#' 
#' @return A data frame with a user_id column and a
#' platform_action_date_column.
#' @importFrom dplyr %>%

extract_user_pa_date <- function(){
  x <- glootility::run_look_list(standardmetrics::sessiondate_looks)
  champs <- dplyr::mutate(
              x[['user_session_date_champions']]
              , user_id = user_dimensions.id
              , platform_action_date = 
                  as.Date(session_duration_fact.timestamp_date)
            ) %>%
            dplyr::select(user_id, platform_action_date)
  end_users <- dplyr::mutate(
                 x[['user_session_date_end_users']]
                 , user_id = user_dimensions.id
                 , platform_action_date = 
                     as.Date(session_duration_fact.timestamp_date)
               ) %>%
            dplyr::select(user_id, platform_action_date)
  internal_users <- dplyr::mutate(
                      x[['user_platform_action_date_internal_users']]
                      , user_id = user_dimensions.id
                      , platform_action_date = 
                          as.Date(user_platform_action_facts.timestamp_date)
                    ) %>%
            dplyr::select(user_id, platform_action_date)
  
  z <- rbind(champs, end_users, internal_users)

  as.data.table(z)
}

#' Download session_datetime data from Looker, and format date and time columns
#' correctly.
#' 
#' @return A data frame with columns user_id, date, time.

extract_user_pa_datetime <- function(){
  x <- glootility::run_look_list(standardmetrics::sessiondatetime_looks)
  y  <- dplyr::mutate(
          x[["user_session_date_time"]]
          , user_id = user_dimensions.id
          , datetime = session_duration_fact.timestamp_time
        )
  z <- dplyr::select(y, user_id, datetime)
  as.data.table(z)
}

