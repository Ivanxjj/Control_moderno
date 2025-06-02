%Universida de Cuenca
%Materia: Teoria de control meoderno
%Taller 6: 
%Autor: Ivan Javier Jara
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear all;close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%segundo orden
clc;
clear;
close all;

%% Parámetros del sistema RLC y PID
R = 5;
L = 0.1;
Cap = 220e-6;
Kp = 10;
Ki = 1000;
Kd = 0.01;

%% Variable simbólica
s = tf('s');

%% Modelo de la planta (RLC)
num = 1 / (L * Cap);                     % Numerador
den = [1, R/L, 1/(L*Cap)];               % Denominador
G = tf(num, den);                        % Planta RLC

%% Controlador PID
P = tf(Kp);
I = tf(Ki/s);
D = tf(Kd * s);
PID = parallel(P, I);
PID = parallel(PID, D);                 % PID total

%% Sistema en lazo abierto y cerrado
OpenLoop = series(PID, G);
ClosedLoop = feedback(OpenLoop, 1);     % Retroalimentación unitaria negativa

%% Mostrar función de transferencia en lazo cerrado
disp('Función de transferencia en lazo cerrado:')
ClosedLoop

%% Análisis de estabilidad
disp('Polos del sistema:')
p = pole(ClosedLoop)
disp('Ceros del sistema:')
z = zero(ClosedLoop)

%% Obtener polinomio característico
[~, den_cl] = tfdata(ClosedLoop, 'v');
disp('Polinomio característico:')
disp(den_cl)

%% Estabilidad con Routh-Hurwitz
isStable = isstable(ClosedLoop);
disp(['¿El sistema es estable?: ', string(isStable)])

%% Subplot: respuesta y mapa de polos y ceros
figure;
subplot(1,2,1)
step(ClosedLoop)
title('Respuesta al escalón')
grid on

subplot(1,2,2)
pzmap(ClosedLoop)
title('Mapa de polos y ceros')
grid on
