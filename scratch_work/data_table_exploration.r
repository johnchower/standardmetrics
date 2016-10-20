library(data.table)

X <- data.table(user_id = sample(1:100, size = 20, replace = T)
                , platform_action_date  = sample(seq.Date(from = as.Date('2016-01-01')
                                      , to = as.Date('2016-01-30')
                                      , by = 1)
                             , size = 20
                             , replace = T))
X[, rollDate := platform_action_date]
setkey(X, rollDate)

Y <- data.table(interval_start_date = seq.Date(from = as.Date('2016-01-01')
                                               , to = as.Date('2016-01-31')
                                               , by = 6))

Y[, rollDate := interval_start_date]
setkey(Y, rollDate)

Y[X, .(user_id, platform_action_date, interval_start_date), roll=T]                                                     
