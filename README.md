# RELATIVE-HUMIDITY-FORECASTING
STAT-S 650 Time Series Analysis

## **Project Overview**
This project analyzes and forecasts **relative humidity at 3 PM** using **time series models**. We employ **ARIMA and ARIMAX models** to predict humidity levels based on historical weather data. The study aims to improve forecasting accuracy by incorporating **morning meteorological conditions** such as temperature, wind speed, and rainfall.

## **Dataset**
The dataset used in this study is sourced from **Kaggle** ([link](https://www.kaggle.com/datasets/apratik46/daily-weather-dataset)) and contains **1094 rows and 10 meteorological variables** recorded at **9 AM** and **3 PM**.

### **Key Variables**
- **air_pressure_9am**: Air pressure (hectopascals)
- **air_temp_9am**: Air temperature (°F)
- **avg_wind_direction_9am**: Average wind direction (degrees)
- **avg_wind_speed_9am**: Average wind speed (mph)
- **max_wind_direction_9am**: Maximum wind direction (degrees)
- **max_wind_speed_9am**: Maximum wind speed (mph)
- **rain_accumulation_9am**: Rainfall accumulation (mm)
- **rain_duration_9am**: Rainfall duration (seconds)
- **relative_humidity_9am**: Relative humidity (%) at 9 AM
- **relative_humidity_3pm**: **Target Variable** - Relative humidity (%) at 3 PM

## **Project Objectives**
1. **Explore Temporal Dependency**: Analyze how **morning humidity** affects **afternoon humidity**.
2. **Evaluate Lagged Effects**: Assess whether **previous-day humidity levels** improve predictions.
3. **Analyze Morning Weather Impact**: Study how **temperature, wind speed, and rainfall** influence humidity.
4. **Compare ARIMA vs. ARIMAX**: Test if including additional meteorological variables improves predictions.
5. **Ensure Stationarity**: Use **differencing techniques** to stabilize time series data.

## **Methodology**
### **1. Data Preprocessing**
- Handle missing values using `na.omit()`.
- Standardize variables for uniform scaling.
- Convert data to **time series format**.

### **2. Exploratory Data Analysis**
- **Histograms & Density Plots** for each variable.
- **Correlation Heatmap** to examine variable relationships.
- **Time Series Plots** to visualize trends and seasonality.

### **3. Stationarity Analysis**
- **ADF Test** to check stationarity.
- **ACF/PACF Plots** to detect autocorrelation.

### **4. Feature Engineering**
- Create **lagged variables** for improving predictions.
- Add **sinusoidal predictors** to model seasonality.

### **5. Modeling & Evaluation**
- Fit **ARIMA(p,d,q) models**.
- Fit **ARIMAX models** with exogenous variables.
- Select the **best model based on AIC & BIC**.
- Validate residuals using **Box-Pierce & Ljung-Box tests**.

### **6. Forecasting**
- Generate forecasts for future **3 PM humidity levels**.
- Visualize predictions with confidence intervals.

## **Results**
- The **ARIMA(5,0,5) model** was identified as the **best fit** based on **AIC (7528) & BIC (7592)**.
- Residuals showed **no significant autocorrelation**, indicating a well-fitted model.
- **ARIMAX models** further improved prediction accuracy by incorporating additional meteorological variables.

## **Future Work**
- Implement **Vector Autoregressive (VAR) models** for multi-variable forecasting.
- Compare **deep learning approaches (LSTMs, CNNs)** with traditional models.
- Integrate **real-time weather API data** for continuous forecasting updates.

## **Project Files**
- `daily_weather.csv`: Dataset used for analysis.
- `EXA.R`: R script containing **data preprocessing, EDA, and modeling**.
- `Daily Weather.Rmd`: R Markdown file for **detailed analysis and reporting**.
- `Daily-Weather.html`: Rendered HTML report.
- `STAT-S 650.pptx`: Presentation summarizing findings.
- `sponduru_STATS650.pdf`: Detailed project report.

## **Technologies Used**
- **Programming**: R
- **Libraries**: `tidyr`, `tseries`, `ggplot2`, `forecast`, `lmtest`, `fable`, `reshape2`
- **Visualization**: `ggplot2`, `corrplot`, `time series plots`
- **Statistical Methods**: ARIMA, ARIMAX, ADF test, ACF/PACF analysis

## **Author**
**Satya Priyanka Ponduru**  
📧 sponduru@iu.edu  
📍 Indiana University, Data Science
