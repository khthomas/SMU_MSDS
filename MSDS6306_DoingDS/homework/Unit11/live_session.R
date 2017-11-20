library(dygraphs)
data =(nhtemp)

dygraph(data) %>%
  dyAxis("x", drawGrid = FALSE) %>%
  dySeries(label = "Temperature", color = "red") %>%
  dyRangeSelector(height = 50)
