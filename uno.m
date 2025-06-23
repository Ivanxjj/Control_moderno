%taller 9 de contro d moderno

clc;
clear all;
close all;
%%
%cracion d fincon de trandferencia RLC serie
R=100;
L=159.15e-3;
C=15.915e-6;

num=[(R*C) 0];
den=[L*C R*C 1];
G=tf(num,den);

%creacion de diagram de bode
M=100;
N=100;
w=logspace(0,10,N);
figure();
bode(G,w);

%ejercico 9.2
%maginut d
% Componentes
%%
% Ejercicio 9.1 - Análisis de circuito RLC serie
% Iván Javier Jara Pauta

% PARÁMETROS DEL CIRCUITO:
%R = 10;            % Resistencia en ohmios
%L = 1e-3;          % Inductancia en Henrios
%C = 100e-6;        % Capacitancia en Faradios

% FUNCIÓN DE TRANSFERENCIA:
% Se obtiene al analizar el voltaje en el capacitor (salida) respecto a la fuente (entrada):
% H(s) = 1 / (LC*s^2 + RC*s + 1)

% Pregunta: ¿Cómo se obtiene la función de transferencia?
% Respuesta: Se usa análisis de mallas y se obtiene Vout(s)/Vin(s) como un sistema de segundo orden.

% Numerador y denominador:
num = [R*C 0];  % Solo 1 en el numerador porque la salida es directamente sobre el capacitor
den = [L*C, R*C, 1];  % Coeficientes del denominador: LC, RC, y 1

% CREAR SISTEMA EN FORMA DE TRANSFERENCIA
H = tf(num, den);

% VECTOR DE FRECUENCIAS:
f = logspace(0, 10, 1000);  % generaicond e ferecucnias en hercios segin intwerpretacion
w=f;  % trabajar directo en rad/s
%w = 2 * pi * f;            % Conversión a radianes por segundo
%% 3
% Pregunta: ¿Qué debería hacer para obtener la gráfica en Hertz?
% Respuesta: Definir 'f' en Hz y convertir a rad/s como 'w = 2*pi*f'; luego graficar contra 'f'.

% s = jω (frecuencia compleja)
s = 1i * w;

% EVALUACIÓN MANUAL DE H(jw)
Hs = polyval(num, s) ./ polyval(den, s);

% MAGNITUD:
mag = abs(Hs);               % Módulo complejo
%% 1
% Pregunta: ¿Qué unidad debe tener la magnitud?
% Respuesta: Se usa decibelios (dB). Fórmula: 20 * log10(|H(jw)|)
mag_dB = 20 * log10(mag);    % Magnitud en dB

% FASE:
phase_rad = angle(Hs);        % Fase en radianes
%% 2
% Pregunta: ¿Qué unidad debe tener la fase?
% Respuesta: La fase debe ir en grados (°). Se convierte así:
% 
%phase_deg = rad2deg(phase_rad);  % Convertir a grados
phase_deg = (phase_rad)*(180/pi);

% GRAFICAR DIAGRAMA DE BODE MANUAL

figure;

% MAGNITUD EN dB
subplot(2,1,1);
semilogx(f, mag_dB, 'b', 'LineWidth', 1.5);
title('Magnitud del sistema (Bode)');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (dB)');
xlim([0 10^5]);
grid on;

% FASE EN GRADOS
subplot(2,1,2);
semilogx(f, phase_deg, 'r', 'LineWidth', 1.5);
title('Fase del sistema (Bode)');
xlabel('Frecuencia (dB)');
ylabel('Fase (°)');
xlim([0 10^5]);
grid on;
%% 4
% Pregunta: ¿Cómo evaluó la función en una frecuencia específica?
% Respuesta: Se reemplazó s = jω en la función H(s) usando s = 1i * w, y se evaluó con 'polyval'.
%% 5
% Pregunta: ¿Cómo calculó la magnitud?
% Respuesta: Se usó abs(H(jw)) para obtener el módulo, y luego 20*log10(...) para convertirlo a dB.
%% 6
% Pregunta: ¿Cómo calculó la fase?
% Respuesta: Se usó angle(H(jw)) para obtener el ángulo en radianes, y luego se convierte a grados.

%% pasar a funcijn







R1=10e3;
R2=10e3;
R3=10e3;
R4=10e3;
C1=1e-12;
C2=1e-6;

num=[R4*R2*R1*C1 1];
den=[R3*R1*R2*C2 1];
gg=tf(num,den)
figure()
N2=1000;
ww=logspace(-12,12,N2);
%ww = 2 * pi * ww;
%%ww=ww/2*pi;
bode(gg,ww)

%% num = [1];  % Solo 1 en el numerador porque la salida es directamente sobre el capacitor
%den = [L*C, R*C, 1];  % Coeficientes del denominador: LC, RC, y 1

% CREAR SISTEMA EN FORMA DE TRANSFERENCIA
H = tf(num, den);

% VECTOR DE FRECUENCIAS:
f = logspace(-12, 12, 1000);  % generaicond e ferecucnias en hercios segin intwerpretacion
%w=f;  % trabajar directo en rad/s
w = 2 * pi * f;            % Conversión a radianes por segundo
%% 3
% Pregunta: ¿Qué debería hacer para obtener la gráfica en Hertz?
% Respuesta: Definir 'f' en Hz y convertir a rad/s como 'w = 2*pi*f'; luego graficar contra 'f'.

% s = jω (frecuencia compleja)
s = 1i * w;

% EVALUACIÓN MANUAL DE H(jw)
Hs = polyval(num, s) ./ polyval(den, s);

% MAGNITUD:
mag = abs(Hs);               % Módulo complejo
%% 1
% Pregunta: ¿Qué unidad debe tener la magnitud?
% Respuesta: Se usa decibelios (dB). Fórmula: 20 * log10(|H(jw)|)
mag_dB = 20 * log10(mag);    % Magnitud en dB

% FASE:
phase_rad = angle(Hs);        % Fase en radianes
%% 2
% Pregunta: ¿Qué unidad debe tener la fase?
% Respuesta: La fase debe ir en grados (°). Se convierte así:
% 
%phase_deg = rad2deg(phase_rad);  % Convertir a grados
phase_deg = (phase_rad)*(180/pi);

% GRAFICAR DIAGRAMA DE BODE MANUAL

figure;

% MAGNITUD EN dB
subplot(2,1,1);
semilogx(f, mag_dB, 'b', 'LineWidth', 1.5);
title('Magnitud del sistema (Bode)');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (dB)');
xlim([0 10^7]);
grid on;

% FASE EN GRADOS
subplot(2,1,2);
semilogx(f, phase_deg, 'r', 'LineWidth', 1.5);
title('Fase del sistema (Bode)');
xlabel('Frecuencia (Hz)');
ylabel('Fase (°)');
xlim([0 10^7]);
grid on;