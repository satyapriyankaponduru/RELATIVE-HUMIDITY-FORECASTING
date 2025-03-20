library(tidyr)
library(tseries)
library(ggplot2)
library(forecast)
library(lmtest)
library(fable)
library(reshape2)

data <- read.csv("daily_weather.csv")

variable_names <- names(data)

# Plot histograms and density plots for each variable
hist_plots <- lapply(variable_names, function(col) {
  ggplot(data, aes(x = .data[[col]])) +
    geom_histogram(fill = "skyblue", color = "black", bins = 20) +
    labs(x = col, y = "Frequency", title = paste("Histogram of", col))
})
density_plots <- lapply(variable_names, function(col) {
  ggplot(data, aes(x = .data[[col]])) +
    geom_density(fill = "skyblue", color = "black") +
    labs(x = col, y = "Density", title = paste("Density Plot of", col))
})

# Correlation matrix heatmap
correlation_matrix <- cor(data)
correlation_long <- melt(correlation_matrix)
ggplot(correlation_long, aes(Var2, Var1, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab", 
                       name="Correlation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, size = 12, hjust = 1)) +
  coord_fixed()

data <- na.omit(data)

# Standardize and convert data to time series
standardize_ts <- function(x) {
  x <- x - mean(x)
  ts(x, start = 1, end = length(x))
}

vars <- c("air_pressure_9am", "air_temp_9am", "avg_wind_direction_9am",
          "avg_wind_speed_9am", "max_wind_direction_9am", "max_wind_speed_9am",
          "rain_accumulation_9am", "rain_duration_9am", "relative_humidity_9am",
          "relative_humidity_3pm")

data_ts <- lapply(vars, function(var) standardize_ts(data[[var]]))
names(data_ts) <- vars

# Plot standardized time series
lapply(data_ts, function(x) plot(x, main = paste("Standardized", deparse(substitute(x)))))

# Differencing to make stationary
data_diff <- lapply(data_ts, diff)

# Check stationarity with ADF test
lapply(data_diff, adf.test)

# ACF and PACF plots for differenced data
lapply(data_diff, acf)
lapply(data_diff, pacf)

# CCF plots with differenced relative humidity at 3pm
lapply(data_diff, function(x) ccf(x, data_diff$relative_humidity_3pm))

# Periodograms for differenced data
lapply(data_diff, function(x) spectrum(x, log = 'no', main = paste("Periodogram of", deparse(substitute(x)))))

# Create lagged variables
create_lags <- function(x, lags) {
  lapply(lags, function(l) filter(x, c(0, rep(1, l)), sides = 1))
}

lags <- list(1, 2)
data_lags <- lapply(data_diff, create_lags, lags)

# Prepare data for ARIMA modeling
data_arima <- do.call(cbind, c(data_lags, list(sin_pred = sin(2 * pi * (1:length(data_diff[[1]])) * (1/365)),
                                               cos_pred = cos(2 * pi * (1:length(data_diff[[1]])) * (1/365)))))

# ARIMA model selection
best_model <- NULL
best_aic <- Inf
for (p in 1:5) {
  for (q in 1:5) {
    model <- arima(data_diff$relative_humidity_3pm, xreg = data_arima, order = c(p, 0, q))
    if (AIC(model) < best_aic) {
      best_model <- model
      best_aic <- AIC(model)
    }
  }
}

summary(best_model)

# Check residuals
res <- residuals(best_model)
Box.test(res, lag = 3)
plot(res, main = "Residual Plot")
acf(res)

# Forecasting
forecast_values <- forecast(best_model, xreg = data_arima[(length(data_diff$relative_humidity_3pm) + 1):nrow(data_arima), ])
plot(forecast_values, main = "Forecasted Relative Humidity at 3PM")

