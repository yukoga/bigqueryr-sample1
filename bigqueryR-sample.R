## ---- initial-setup ----
library(bigQueryR)
library(googleAnalyticsR)

## ---- auth ----
bqr_auth()

## ---- list-projects ----
bqr_list_projects()
bqr_list_datasets("project-id")

## ---- query1 ----
data1 = google_analytics_bq('gcp-jp', '88451488',
                            start = '2016-12-01', end = '2016-12-14',
                            metrics = c('sessions', 'pageviews', 'timeOnSite'),
                            dimensions = c('source', 'medium'),
                            sort = 'sessions')
head(data1)

## ---- query2 ----
query2 = "SELECT
  date,
  SUM(totals.visits) AS sessions,
  SUM(totals.pageviews) AS pageviews,
  SUM(totals.timeOnSite) AS timeOnSite
FROM (TABLE_DATE_RANGE([88451488.ga_sessions_], 
  TIMESTAMP('2016-12-01'), TIMESTAMP('2016-12-14')))
GROUP BY
  date
ORDER BY
  date ASC
"

data2 = google_analytics_bq('gcp-jp', '88451488',
                            query = query2)
head(data2)

## ---- scatter-plot ----
n1 = nPlot(sessions ~ timeOnSite, group='medium', data=data1, type='scatterChart')
print(n1)

## ---- line-plot ----
m2 = mPlot(x='date', y=list('sessions', 'pageviews'), data=data2, type="Line")
m2$set(pointSize=0, lineWidth=1, lineColors=list('#09B27F', '#DA00FF'), 
       labels=list('Sessions', 'Pageviews'), 
       hideHover='auto',
       dateFormat = "#! function (x) {
       _date = new Date((x-1)*60*60*24*1000 + 60*60*24*1000*365*47 + 60*60*24*1000*12);
       return new Intl.DateTimeFormat('ja').format(_date);
       }!#",
       yLabelFormat = "#! function (y) {
       return (Math.round(y * Math.pow(10, 2)) / Math.pow(10, 2)).toString();
       }!#")
print(m2)


