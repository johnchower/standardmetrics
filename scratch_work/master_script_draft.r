rm(list = ls())  
devtools::document()
devtools::load_all()

glootility::connect_to_lookr()
library(dplyr)

date_ranges <- define_date_ranges()
# .sesh_dur_date <- extract_user_pa_date()
# .sesh_dur_datetime <-  extract_user_pa_datetime()
sesh_dur_date <- data.table::copy(.sesh_dur_date)
sesh_dur_datetime <- data.table::copy(.sesh_dur_datetime)


AU_counts <- loop_calculate_active_users(date_ranges, sesh_dur_date)
MAU_count_by_month <- AU_counts$months_beginning
DAU_count_by_day <- AU_counts$days_for_months

DAU_to_MAU_ratio_by_month  <- calculate_DAU_MAU_ratio(MAU_count_by_month
                                                      , DAU_count_by_day)

relative_pa_datetimes <- sesh_dur_datetime %>%
  find_relative_pa_datetimes 

user_oneD7 <- relative_pa_datetimes %>%
  classify_1d7s

signup_count <- count_signups(relative_pa_datetimes
                              , user_oneD7
                              , date_ranges$weeks_beginning)

signup_count_all <- count_signups(relative_pa_datetimes
                              , user_oneD7
                              , date_ranges$weeks_beginning_since_20160101
                              )

user_retention_data <- get_user_retention_data(relative_pa_datetimes
                                               , user_oneD7)
