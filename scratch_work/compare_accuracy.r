library(dplyr)

WAU_count <- rolled_pa_data %>%
  group_by(range_beginning_date) %>%
  summarise(number_of_active_users = length(unique(user_id)))


