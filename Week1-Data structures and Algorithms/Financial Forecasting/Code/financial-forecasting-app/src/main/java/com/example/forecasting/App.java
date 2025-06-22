package com.example.forecasting;

public class App {
    public static void main(String[] args) {
        double[] financialData = {1000, 1200, 1100, 1300, 1250, 1400, 1350};
        int windowSize = 3;
        double forecast = MovingAverageForecast.forecast(financialData, windowSize);
        System.out.println("Next period forecast (Moving Average): " + forecast);
    }
}
