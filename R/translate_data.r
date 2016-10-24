# Tools to translate extracted data into formats that are easy to calculate
# with.

#' Convert platform action datetimes to difftimes relative to first platform
#' action, and relative to first day.
#'
#' @param user_platform_action_datetime A data frame: (user_id, datetime) 
#' where datetime is a chron
#' object representing the moment a platform action was taken.
#' @return A data frame: (user_id, relative_time, relative_date) where
#' relative_* are difftime objects. relative_time represents the amount of seconds that have
#' passed since their first platform action. relative_date represents the
#' amount of days that have passed since the first day of their platform
#' action.
#' @import data.table
#' @export

find_relative_pa_datetimes <- function(user_platform_action_datetime){
  upd <- data.table::copy(user_platform_action_datetime)
  upd[
    , date := lubridate::date(datetime)
  ][
    , c("user_id"
        , "signup_datetime"
        , "signup_date") 
      := 
      .(user_id
        , min(datetime)
        , min(date) )
    , by = user_id
  ][
    , c('user_id', 'relative_datetime', 'relative_date') 
        := .(user_id
             , difftime(datetime, signup_datetime, units = 'mins')
             , difftime(date, signup_date, units = 'days'))
  ][
    , .(user_id, relative_datetime, relative_date, signup_datetime, signup_date)
  ]
}

#' Classify users as 1d7 or regular.
#'
#' @param user_pa_datetime_relative A data frame: 
#' (user_id, relative_datetime, relative_date). The
#' result of calling find_relative_pa_datetimes.
#' @return A data frame: (user_id, 1d7). The field 1d7 is logical; true if the
#' user returned to Gloo in their first week after signup and false otherwise.
#' @import data.table
#' @export

classify_1d7s <- function(user_pa_datetime_relative){
  updr <- data.table::copy(user_pa_datetime_relative)
  x <- updr[
    , c('user_id'
        , 'day_1_action'
        , 'week_1_action') 
      :=
      .(user_id
        , relative_datetime >= 30 & relative_datetime <= 24*60
        , relative_date >= 1 & relative_date <= 6)
  ][
    , "oneD7" 
      :=
      .(any(day_1_action) | any(week_1_action))
    , by = user_id
  ][
    , .(user_id, oneD7)
  ]

  setkey(x)
  unique(x)
}
