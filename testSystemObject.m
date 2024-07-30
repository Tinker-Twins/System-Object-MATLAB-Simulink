clear;
close all;
clc;

movingAverageFilter = movingAverageFilter('WindowLength',10);

t = (1:250)';
signal = randn(250,1); % Noisy pulse sequence
smoothedSignal = movingAverageFilter(signal);

plot(t,signal,t,smoothedSignal);
legend(["Input","Output"])