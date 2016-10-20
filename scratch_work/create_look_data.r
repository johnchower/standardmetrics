# Use this script to make changes to the looks which get pulled by
# 'extract_user_platform_action_date_data'

sessiondate_looks  <-  list(
  list(look_name = "user_session_date_champions"
       , look_id = 2598),
  list(look_name = "user_session_date_end_users"
       , look_id = 2599),
  list(look_name = "user_platform_action_date_internal_users"
       , look_id = 2600)
)

devtools::use_data(sessiondate_looks, sessiondate_looks, overwrite = T)

sessiondatetime_looks <- list(
  list(look_name = "user_session_date_time"
       , look_id = 2507)
)

devtools::use_data(sessiondatetime_looks, sessiondatetime_looks, overwrite = T)

