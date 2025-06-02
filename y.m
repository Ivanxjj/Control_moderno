clc;
clear;
close all;

% Definir la variable de Laplace
s = tf('s');

% Funciones de transferencia dadas
G1 = 3/s;
G2 = 1/(s^2 + 1);
H1 = 3;

% Combinar G1 y G2 en serie
G_open = series(G1, G2);  % o G1*G2

% Sistema en lazo cerrado con realimentación negativa
Gs = feedback(G_open, H1);  % T(s) = G_open / (1 + G_open*H1)

% Mostrar la función de transferencia resultante
disp('Función de transferencia en lazo cerrado:')
Gs

% Mostrar polos y ceros
disp('Polos del sistema:')
pole(Gs)

disp('Ceros del sistema:')
zero(Gs)
%%
% Obtener coeficientes del denominador
[num, den] = tfdata(Gs, 'v');

% Mostrar polinomio característico
disp('Polinomio característico:')
disp(den)

% Crear la tabla de Routh-Hurwitz manualmente (opcional) o usar función externa
% Alternativamente puedes usar la herramienta Control System Toolbox para análisis completo:
isStable = isstable(Gs);
disp(['¿El sistema es estable?: ', string(isStable)])
%%
% Mostrar respuesta al escalón
figure;
step(Gs)
title('Respuesta al escalón del sistema')

% Mostrar lugar de las raíces
figure;
rlocus(Gs)
title('Lugar de las raíces')

% Mostrar mapa de polos y ceros
figure;
pzmap(Gs)
grid on
title('Polos y ceros del sistema')
