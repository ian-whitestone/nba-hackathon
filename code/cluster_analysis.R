library(data.table)
library(ggplot2)
library(magrittr)
library(lubridate)
library(rms)
library(caret)
library(moments)
library(pcaMethods)
library(plotly)

driver = fread('final_driver.csv', integer64 = 'character')
driver[, log_target := log1p(tickets_purchased)]
driver[, binary_target := tickets_purchased > 0]

vars = names(driver) %>% .[!. %in% c('accountsid','tickets_purchased','log_target', 'binary_target')]

dTail = function(cols, DT) {
  ## Computes stats useful for right-skewed, heavy-tailed, zero-inflated variables
  ## args: cols = character vector of column names
  ##       DT   = data.table containing cols
  ## return: data.table containing the summary stats
  IDA = DT[, .(var      = colnames(.SD),                   ## .SD = compact syntax for executing on each separate column
               pctNA    = 100*colMeans(is.na(.SD)),
               pct0     = 100*colMeans(.SD==0, na.rm=T),   ## pct of non-missing values
               nlev     = sapply(.SD, uniqueN),            ## data.table::uniqueN
               min      = sapply(.SD, min, na.rm=T),       ## need to sapply vector/matrix functions to the columns of a data.table
               max      = sapply(.SD, max, na.rm=T),
               mean     = colMeans(.SD, na.rm=T)
               
  ), .SDcols=cols]                                         ## specify the columns included in .SD
  return(IDA)
}

TR = dTail(vars, driver)

vars_dtail = TR[pct0 < 100, var]

for (x in vars_dtail) {
  driver[, paste0('T_', x) := log1p(get(x))]
}

Tvars = grep('T_', names(driver), value = T)

corvars = driver[, cor(.SD), .SDcols = Tvars] %>% findCorrelation
G = Glm(reformulate(Tvars[-corvars], response = 'log_target'), data = driver)

x_fbw = fastbw(G, k.aic = 2)$names.kept

rm(G); gc();
g = glm(reformulate(x_fbw, response = 'binary_target'), data = driver, family = 'binomial')

driver[, pred := predict(g, driver, type = 'response')]
driver[, ModelMetrics::auc(binary_target, pred)]

cut()
driver[, twentile := cut(pred, labels = F, breaks = quantile(pred, 0:20/20))]

driver[, mean(ninetyd_activity_27), by = twentile] %>% ggplot(aes(x = twentile, y = V1)) + 
  geom_line() + geom_point()

drvPca = driver[, .SD, .SDcols = c('premier_tickets', 'value_tickets','select_tickets', 
                                   'all_activity_10', 'thirtyd_activity_8', 'pred', 
                                   'thirtyd_activity_10', 'all_activity_1')] %>% 
  pca(scale = 'uv', nPcs = 3, method = 'svd')

kmobj = drvPca@scores %>% kmeans(centers = 5, iter.max = 50)

driver[, cluster := kmobj$cluster]

options(datatable.print.nrows=1000, width=150, scientific = F, digits = 3)

driver[, .(var = colnames(.SD), colMeans(.SD)), 
       by = cluster, .SDcols = c('premier_tickets', 'value_tickets','select_tickets', 'all_activity_10', 
                                 'thirtyd_activity_12', 'pred','all_activity_1',
                                 'thirtyd_activity_10')] %>% 
  dcast(cluster ~ var) %>% .[order(-pred)] -> cluster_analysis

setnames(cluster_analysis, 'all_activity_1', 'all_web')
setnames(cluster_analysis, 'all_activity_10', 'all_email_opens')
setnames(cluster_analysis, 'thirtyd_activity_10', 'thirtyd_email_opens')
setnames(cluster_analysis, 'thirtyd_activity_12', 'thirtyd_new_leads')

driver[, .N, by= cluster]

pca = drvPca@scores %>% as.data.table
pca[, cluster := driver[, as.character(cluster)]]

meta = fread('driver_meta.csv', integer64 = 'character')[
  , .(accountsid, eduinfo, occupation, annual_income)]

meta[, technical := occupation == 1]
meta[, clerical := occupation == 2]
meta[, trades := occupation == 3]
meta[, admin := occupation == 4]
meta[, medical := occupation == 5]
meta[, retired := occupation == 6]
meta[, executive := occupation == 7]
meta[, low_income := annual_income == 1]
meta[, avg_income := annual_income == 2]
meta[, middle_class := annual_income == 3]
meta[, mid_upper_class := annual_income == 4]
meta[, upper_class := annual_income == 5]

merge(driver, meta) %>% .[, .(var = colnames(.SD), m = colMeans(.SD)), by = cluster,
                          .SDcols = c('technical','clerical','trades','admin','medical',
                                      'retired','executive')] %>% 
  dcast(cluster ~ var)

merge(driver, meta) %>% .[, .(var = colnames(.SD), m = colMeans(.SD)), by = cluster,
                          .SDcols = c('low_income','avg_income','middle_class',
                                      'mid_upper_class','upper_class')] %>% 
  dcast(cluster ~ var)

plot_ly(pca[1:250000][PC1 < 20 & PC2 < 20 & PC3 < 20], 
        x = ~PC1, y = ~PC2, z = ~PC3, color = ~cluster, marker = list(size = 4)) %>% add_markers()
