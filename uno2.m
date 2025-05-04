clc; clear all; close all;

% === Parámetros del circuito RLC serie ===
R = 100;           % Resistencia en ohmios
L = 0.1;           % Inductancia en henrios
Cap = 1e-6;        % Capacitancia en faradios

% === Matrices del modelo en espacio de estados ===
A = [-R/L, -1/(L*Cap); 1, 0];
B = [1/L; 0];
C = [1, 0; 0, 1/Cap];   % Salidas: voltaje del capacitor y corriente
D = [0; 0];

% === Crear sistema en espacio de estados ===
sys = ss(A, B, C, D);

% === Respuestas al escalón e impulso ===
figure;
subplot(2,1,1);
step(sys);
title('Respuesta al Escalón');
xlabel('Tiempo [s]'); ylabel('Salida');

subplot(2,1,2);
impulse(sys);
title('Respuesta al Impulso');
xlabel('Tiempo [s]'); ylabel('Salida');

% === Conversión a función de transferencia ===
G = tf(sys);
disp('Función de transferencia del sistema:');
G

% === Conversión de nuevo a espacio de estados ===
[AA, BB, CC, DD] = ssdata(G);

