package com.example.forecasting;

public class MovingAverageForecast {
 
    public static double forecast(double[] data, int window) {
        if (data.length < window) {
            throw new IllegalArgumentException("Not enough data for the window size");
        }
        double sum = 0;
        for (int i = data.length - window; i < data.length; i++) {
            sum += data[i];
        }
        return sum / window;
    }
}
