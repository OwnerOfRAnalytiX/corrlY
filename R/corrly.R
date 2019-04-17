#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

library(plotly)

# correlation Coeficient using pearson Method
# corr_coef(variable1=data$variable1, variable2=data$variable2, decimal="1 or 2 or 3 or 4....")
# Example:- corr_coef_pearson(variable1 = data_frame$col1, variable2 = data_frame$col2, decimal = 2)

corr_coef_pearson<- function(variable1=NULL, variable2=NULL, decimal=NULL){
  round(cor(variable1, variable2, use = "everything", method = "pearson"), decimal)
}

# correlation Coeficient using kendall Method
# corr_coef(variable1=data$variable1, variable2=data$variable2, decimal="1 or 2 or 3 or 4....")
# Example:-  corr_coef_kendall(variable1 = data_frame$col1, variable2 = data_frame$col2, decimal = 2)
corr_coef_kendall<- function(variable1=NULL, variable2=NULL, decimal=NULL){
  round(cor(variable1, variable2, use = "everything", method = "kendall"), decimal)
}

# correlation Coeficient using spearman Method
# corr_coef(variable1=data$variable1, variable2=data$variable2, decimal="1 or 2 or 3 or 4....")
# Example:-  corr_coef_spearman(variable1 = data_frame$col1, variable2 = data_frame$col2, decimal = 2)
corr_coef_spearman<- function(variable1=NULL, variable2=NULL, decimal=NULL){
  round(cor(variable1, variable2, use = "everything", method = "spearman"), decimal)
}


#============================================================ Correlation Scatter Plot ====================================================================

# Example:-  spearman<- corr_coef_spearman(variable1 = data_frame$col1, variable2 = data_frame$col2, decimal = 2)
# Example:- corr_scatterly(data= data_frame, variable1= data_frame$col1, variable2=data_frame$col2, corr_coef= spearman, xname="Column X", yname="Column Y")

corr_scatterly <- function(data=NULL, variable1=NULL, variable2=NULL, corr_coef=NULL, xname="", yname=""){
  fit<- lm(variable2 ~ variable1)
  return(plot_ly(x = variable1, y = variable2) %>%
           add_markers(marker = list(size = 15, opacity = 0.8), showlegend = TRUE, text = paste0(variable1, variable2), name = "") %>%
           add_lines(y = fitted(fit), line = list(color = 'rgb(250,128,114)', width = 3), showlegend = TRUE,
                     text = ~paste0("Correlation Coefitient R = ", corr_coef), name = "Best Fit Line") %>%
           layout(xaxis = list(title = paste0(unique(xname))),
                  yaxis = list(title = paste0(unique(yname)), showlegend = TRUE)) %>%
           layout(legend = list(orientation = "h",   # show entries horizontally
                                xanchor = "bottom",  # use center of legend as anchor
                                x = 0.40, y = -0.3,
                                bordercolor = "#333",
                                borderwidth = 2)) %>% layout(paste0('Correlation Coefficient =', corr_coef))%>%
           plotly::config(displaylogo = FALSE, collaborate = FALSE))
}


#============================================================ Correlation Matrix Plot ====================================================================

# Example:- matrixly(data = data_frame)

matrixly <- function(data= NULL){
  correlation <- round(cor(data, use = "everything", method = "pearson"), 2)
  nms <- names(data)
  return(
    plot_ly(x=nms, y=nms, z = correlation, color = ~correlation, key = correlation, type = "heatmap", source = "heatplot") %>%
      layout(xaxis = list(title = ""),
             yaxis = list(title = "")) %>%
      layout(legend = list(orientation = "h",   # show entries horizontally
                           xanchor = "bottom",  # use center of legend as anchor
                           x = 0.45, y = -0.3,
                           bordercolor = "#333",
                           borderwidth = 2)) %>%
      plotly::config(displaylogo = FALSE, collaborate = FALSE)
  )
}


#============================================================ Autocorrelation ====================================================================

#acfq<- c(data_frame$col2, data_frame$col1)
#Example:- acf_ly(acfq)

acf_ly <- function(series) {
  significance_level <- qnorm((1 + 0.95)/2)/sqrt(sum(!is.na(series)))
  a_cf <-acf(series, plot=F)
  df_acf <-with(a_cf, data.frame(lag, acf))
  acf_plotly<- plot_ly(df_acf, x = ~lag, y = ~acf, color = ~acf, type = "bar", showlegend = FALSE,
                       mode='markers', marker=list(colorbar=list(title='Correlation Coeficient'))) %>%
    layout(xaxis = list( title = 'LAG'), yaxis = list( title = 'ACF')) %>%
    add_lines(y = significance_level,
              line = list(color = 'rgb(22, 96, 167)'),
              name = "Positive Significance Level", showlegend = TRUE) %>%
    add_lines(y = -significance_level,
              line = list(color = '#07A4B5'),
              name = "Negative Significance Level", showlegend = TRUE) %>%
    config(displaylogo = FALSE, collaborate = FALSE);
  acf_plotly <- acf_plotly %>% colorbar(title="Correlation Coeficient")
  acf_plotly
  return(acf_plotly)
}


#============================================================ Partial Autocorrelation ====================================================================

#pcfq<- c(data_frame$col2, data_frame$col1)
#Example:- pacf_ly(acfq)

pacf_ly <- function(series) {
  significance_level <- qnorm((1 + 0.95)/2)/sqrt(sum(!is.na(series)))
  p_acf <-pacf(series, plot=F)
  df_pacf <- with(p_acf, data.frame(lag, acf))
  pacf_plotly <- plot_ly(df_pacf, x = ~lag, y = ~acf, color = ~acf, type = "bar", showlegend = FALSE,
                         mode='markers', marker=list(colorbar=list(title='Correlation Coeficient'))) %>%
    layout(xaxis = list( title = 'LAG'), yaxis = list( title = 'PACF')) %>%
    add_lines(y = significance_level,
              line = list(color = 'rgb(22, 96, 167)'),
              name = "Positive Significance Level", showlegend = TRUE) %>%
    add_lines(y = -significance_level, line = list(color = '#07A4B5'),
              name = "Negative Significance Level", showlegend = TRUE) %>%
    config(displaylogo = FALSE, collaborate = FALSE);
  pacf_plotly <- pacf_plotly %>% colorbar(title="Correlation Coeficient")
  pacf_plotly
  return(pacf_plotly);
}


#============================================================ Cross Correlation ====================================================================

# ccf_ly(data_frame$row1, data_frame$imp1)
ccf_ly <- function(series1,series2) {
  series <- c(series1, series2)
  significance_level <- qnorm((1 + 0.95)/2)/sqrt(sum(!is.na(series)))
  p_ccf <-ccf(series1, series2, plot=F)
  df_ccf <- with(p_ccf, data.frame(lag, acf))
  ccf_plotly <- plot_ly(df_ccf, x = ~lag, y = ~acf, color = ~acf, type = "bar", showlegend = FALSE,
                        mode='markers', marker=list(colorbar=list(title='Correlation Coeficient'))) %>%
    layout(xaxis = list( title = 'LAG'), yaxis = list( title = 'CCF')) %>%
    add_lines(y = significance_level,
              line = list(color = 'rgb(22, 96, 167)'),
              name = "Positive Significance Level", showlegend = TRUE) %>%
    add_lines(y = -significance_level, line = list(color = '#07A4B5'),
              name = "Negative Significance Level", showlegend = TRUE) %>%
    config(displaylogo = FALSE, collaborate = FALSE);
  ccf_plotly <- ccf_plotly %>% colorbar(title="Correlation Coeficient")
  ccf_plotly
  return(ccf_plotly);
}
