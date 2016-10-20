devtools::document()
devtools::load_all()

date_ranges <- define_date_ranges()
sesh_dur_data <- extract_user_pa_date()
AU_counts <- loop_calculate_active_users(date_ranges, sesh_dur_data)

MAU_count_by_month <- AU_counts$months_beginning
DAU_count_by_day <- AU_counts$days_for_months

