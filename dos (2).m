clc; clear all; close all;

% === Parámetros del circuito ===
R = 100;
L = 0.1;
Cap = 1e-6;

% === Matrices del sistema con 2 salidas ===
A = [-R/L, -1/(L*Cap); 1, 0];
B = [1/L; 0];
C = [1, 0; 0, 1/Cap];   % 2 salidas
D = [0; 0];

% === Simulación ===
ts = 0.015;
tspan = [0 ts];
u = 1;           % Entrada escalón
x0 = [0; 0];     % Condición inicial

[t, X] = ode45(@(t,x) modelRLC(t, x, A, B, u), tspan, x0);

% === Cálculo de salidas ===
Y = (C * X.' + D * u).';  % Y es Nx2

% === Gráficas ===
figure;

subplot(2,2,1);
plot(t, Y(:,1));  % Voltaje del capacitor
title('Corriente en el circuito');
xlabel('Tiempo [s]');
ylabel('Vc [V]');

subplot(2,2,2);
plot(t, Y(:,2));  % Corriente (i)
title('Voltaje en el capacitor');
xlabel('Tiempo [s]');
ylabel('i [A]');

subplot(2,2,[3 4]);
plot(X(:,1), X(:,2), '>-');
title('Trayectoria en el espacio de estados');
xlabel('x1 = q'); ylabel('x2 = i');

% === Función de modelo ===
function dx = modelRLC(t, x, A, B, u)
    dx = A * x + B * u;
end
