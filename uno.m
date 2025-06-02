%Universida de Cuenca
%Materia: Teoria de control meoderno
%Taller 6: 
%Autor: Ivan Javier Jara
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear all;close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Primer orden estable
num=1;
%den=[2 1];%estable
den=[2 -1];%inestable
tau=4*2;
Gs=tf(num,den)
[y,t]=step(Gs);
disp("polos de Gs");
roots(den)

plot(t,y,DisplayName='Respuesta al escalon');
title("Respuesta al escalon de un sitema de primer orden");
grid minor;
hold on;

diferencias = abs(t - 8); % Calcula la diferencia absoluta
indice = find(diferencias == min(diferencias)); % Encuentra el índice del valor más cercano

%plot(tau,y(indice),'o',DisplayName='Punto 4T estabilizacion');

legend
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
