% Taller 8 de control moderno
%Autor: Ivan Jara
%Tema: Compkensador en adelanto
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear all;close all;

%% funcion manual de transferencia
Ra=0.635;
La=0.0883;
Ki=9.43;
Kb=1010;
Jm=330*10^3;
Bm=1*10^-3;

numm=[Ki/(La*Jm)];
denm=[1 ((Bm/Jm)+(Ra/La)) ((Ra*Bm)+(Ki*Kb))/(La*Jm)];

gm=tf(numm,denm);

%% raices denominador de la funcion de transferencia
roots(denm);
%% figura 1 step y locus original
figure();
subplot(2,1,1)
step(gm)
subplot(2,1,2)
rlocus(gm)
%% compensacion de modelo diseno mp=10% y tss=1s; cera=? y wn=?
Mpd=0.1;
tssd=1;
cerac=(log(1/Mpd))/(sqrt(pi^2+(log(1/Mpd))^2));
wnc=4/(tssd*cerac);

% raices s de parametro

rsd12=roots([1 2*cerac*wnc wnc^2]);

%% figura 2 2.2 polos objetivo
figure()
rlocus(gm)
hold on;
title('ORIGINAL CON POLOS A DISENAR (SIN COMPESAR)');
plot(real(rsd12), imag(rsd12), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
axis equal;
ylim([-6 6]);



%% DISENO COMPENSADOR (delantado)
% 1 asumo ec de compensador
Kc=1;
p=1;
z=1;
s=tf('s');
Gc=Kc*((s+z)/(s+p));

m=(5.4575-0)/(-4-(0.0457));
teta1=180+rad2deg(atan(m));% trandformar a gradientes
teta4=180-teta1;

%compolnete real de polo nuevo
x=-4-((5.4575)/(atan(teta4)));

pc=-7.9543;
zc=-7.1457;

Gc2=Kc*((s-zc)/(s-pc));
Gc3=series(Gc2,gm);
figure()
rlocus(Gc3)
hold on
plot(real(rsd12), imag(rsd12), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
axis equal;
ylim([-6 6]);

figure
pzmap(Gc3)
hold on
plot(real(rsd12), imag(rsd12), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
axis equal;
ylim([-6 6]);
%% haalar Kc
Gt=1/(Gc3*1010);
ss=-4 + 1j*5.4575;
mkc=abs(evalfr(Gt,ss));
%% compensado
figure()
gcomp=feedback(mkc*Gc3,1010);

subplot(2,1,1)
step(gcomp)
hold on;
step(gm)
subplot(2,1,2)
rlocus(gcomp)

%% evalfr Kc+?
figure()
step(gcomp)
grid minor
%% eval fr por proceso
% Obtener la respuesta al escalón

[y,t] = step(gcomp);

% Estado estable (último valor)
y_ss = y(end);

% Encontrar el sobreimpulso máximo (Mp)
[max_val, idx_max] = max(y);
Mp_calc = ((max_val - y_ss) / y_ss) * 100;
t_pico = t(idx_max); % Tiempo correspondiente al pico

% Encontrar el valor en tss = 1s
idx_tss = find(t >= 1, 1, 'first');
valor_tss = y(idx_tss);
t_tss = t(idx_tss); % Tiempo correspondiente a tss

% Graficar la respuesta y marcar los puntos
figure()
step(gcomp)
grid minor
hold on

% Marcar el sobreimpulso
plot(t_pico, max_val, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
plot(t_tss, valor_tss, 'mo', 'MarkerSize', 10, 'LineWidth', 2);

% Agregar leyenda con coordenadas completas
legend({
    sprintf('Mp = %.2f%% en (%.3f, %.5f)', Mp_calc, t_pico, max_val),
    sprintf('tss = 1s en (%.3f, %.5f)', t_tss, valor_tss)
}, 'Location', 'best');

% Mostrar coordenadas en la terminal
disp(['Sobreimpulso calculado (Mp): ', num2str(Mp_calc), '%']);
disp(['Coordenadas del pico: (', num2str(t_pico), ', ', num2str(max_val), ')']);
disp(['Coordenadas en tss = 1s: (', num2str(t_tss), ', ', num2str(valor_tss), ')']);
