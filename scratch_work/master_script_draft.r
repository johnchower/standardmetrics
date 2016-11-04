rm(list = ls())  
devtools::document()
devtools::load_all()
library(dplyr)

devtools::install_github('johnchower/standardmetrics')
devtools::install_github('johnchower/glootility')
glootility::connect_to_lookr()
library(dplyr)

.sesh_dur_date <- extract_user_pa_date()
.sesh_dur_datetime <-  extract_user_pa_datetime()

date_ranges <- define_date_ranges(base_date = Sys.Date(), week_start = 6)

sesh_dur_date <- data.table::copy(.sesh_dur_date) %>%
    filter(platform_action_date >= as.Date('2016-01-01')) %>%
    {data.table::as.data.table(.)}

sesh_dur_datetime <- data.table::copy(.sesh_dur_datetime) %>%
    filter(as.Date(datetime) >= as.Date('2016-01-01')) %>%
    {data.table::as.data.table(.)}

AU_counts <- loop_calculate_active_users(date_ranges, sesh_dur_date) 

AU_counts <- AU_counts %>%
    lapply(FUN = function(df){
        out <- df %>%
            filter(!is.na(range_beginning_date)) %>%
            filter(range_beginning_date != max(range_beginning_date))
        
        data.table::as.data.table(out)
    })

MAU_count_by_month <- AU_counts$months_beginning 
WAU_count_by_week <- AU_counts$weeks_beginning 
DAU_count_by_day <- AU_counts$days 
DAU_count_by_day_all <- AU_counts$days_for_months 


DAU_to_MAU_ratio_by_month  <- calculate_DAU_MAU_ratio(MAU_count_by_month
                                                      , DAU_count_by_day_all)

overall_DAU_to_MAU_ratio <- calculate_overall_ratio(date_ranges$months_beginning)


relative_pa_datetimes <- sesh_dur_datetime %>%
  find_relative_pa_datetimes 

user_xd7 <- relative_pa_datetimes %>%
    count_days_of_activity_week1 %>% 
    mutate(user_class = ifelse(user_class >=4
                          , 'a_Core'
                          , ifelse(user_class >= 2 & user_class <= 3
                                   , 'b_Casual'
                                   , 'c_Marginal'))) %>%
    {data.table::as.data.table(.)}


user_oneD7 <- relative_pa_datetimes %>%
  classify_1d7s

signup_count <- count_signups(relative_pa_datetimes
                              , user_oneD7
                              , date_ranges$weeks_beginning)

signup_count_multi <- count_signups_multiclass(relative_pa_datetimes
                                               , user_xd7
                                               , date_ranges$weeks_beginning_since_20160101
                                               )

signup_count_all <- count_signups(relative_pa_datetimes
                                  , user_oneD7
                                  , date_ranges$weeks_beginning_since_20160101)

user_retention_data <- get_user_retention_data(relative_pa_datetimes
                                               , user_oneD7)


user_retention_data_multi <- get_user_retention_data(relative_pa_datetimes
                                                     , select(user_xd7, user_id,  oneD7 = user_class))
