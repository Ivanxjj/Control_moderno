%Universidad de Cuenca
%Taller 5 de teoria de control moderno
%Autor: Ivan Jara

clc;clear all;close all;

R = 5;
L = 0.1;
Cap = 220e-6;
Kp=10;
Ki=1000;
Kd = 0.01;

num=1/(L*Cap);
den=[1 R/L 1/(L*Cap)];
G=tf(num, den)