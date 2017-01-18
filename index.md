---
title       : bigqueryR
subtitle    : R package for BigQuery.
author      : Yutaka Koga
job         : GA360 MSC APAC
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : solarized_light      # 
widgets     : [bootstrap, quiz]            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
ext_widgets: {rCharts: [libraries/morris, libraries/nvd3]}

--- 

## Setup  

### Prerequisites  
1. [required] Install [R](https://www.r-project.org/) (recommended to user latest version.)  
2. [optional] Install [RStudio](https://www.rstudio.com/)  
  
### Install bigqueryR  
```
install.packages('bigqueryR')
```

---

## Initial instructions  
### Load bigqueryR 

```r
library(bigQueryR)
library(googleAnalyticsR)
```

### Authentication  

```r
bqr_auth()
```

### Get lists of your project and datasets  

```r
bqr_list_projects()
bqr_list_datasets("project-id")
```

--- 

## Query Analytics 360 data on BigQuery  
### Query pre-defined metrics and dimensions.  

```r
data1 = google_analytics_bq('gcp-jp', '88451488',
                            start = '2016-12-01', end = '2016-12-14',
                            metrics = c('sessions', 'pageviews', 'timeOnSite'),
                            dimensions = c('source', 'medium'),
                            sort = 'sessions')
head(data1)
```

---

## Query Analytics 360 data on BigQuery  
### Or you can query with an any custom query.  

```r
query2 = "SELECT
  date,
  SUM(totals.visits) AS sessions,
  SUM(totals.pageviews) AS pageviews,
  SUM(totals.timeOnSite) AS timeOnSite
FROM (TABLE_DATE_RANGE([88451488.ga_sessions_], TIMESTAMP('2016-12-01'), TIMESTAMP('2016-12-14')))
GROUP BY
  date
ORDER BY
  date ASC
"

data2 = google_analytics_bq('gcp-jp', '88451488',
                            query = query2)
head(data2)
```

---

## Visualize data  
### Now you can show chart with R functionality.  

```r
n1 = nPlot(sessions ~ timeOnSite, group='medium', data=data1, type='scatterChart')
print(n1)
```

<iframe src=' assets/fig/scatter-plot-1.html ' scrolling='no' frameBorder='0' seamless class='rChart nvd3 ' id=iframe- chartfa49576fdc6e ></iframe> <style>iframe.rChart{ width: 100%; height: 400px;}</style>

---

## Visualize data  
### Time series as follows.  

```r
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
```

<iframe src=' assets/fig/line-plot-1.html ' scrolling='no' frameBorder='0' seamless class='rChart morris ' id=iframe- chartfa495a9f1e90 ></iframe> <style>iframe.rChart{ width: 100%; height: 400px;}</style>
