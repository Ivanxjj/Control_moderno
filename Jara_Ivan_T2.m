%Universidad de Cuenca
%Taller 2 de control moderno
%Autor: Ivan Jara
clc;clear all;close all;

num=[3];
den=[1 2 3];
ts=0.1;
%Gs=tf(num,den); %tiempo continuo
Gz=tf(num,den,ts); %tiempo discreto

delay=2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%uno
Gs=tf(num,den);
figure
subplot(2,1,1)
impulse(Gs)
subplot(2,1,2)
step(Gs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%dos

[y1,t1] = step(Gs);
figure();
subplot(2,1,1)
plot(t1,y1)

[y2,t2] = impulse(Gs);
subplot(2,1,2)
plot(t2,y2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tres
delay=2;
Gs=tf(num,den,'InputDelay',delay);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Cuatro
[y3,t3] = step(Gs);
figure();
subplot(2,1,1)

plot(t3,y3)
title('Escalón');
[y4,t4] = impulse(Gs);
subplot(2,1,2)

plot(t4,y4)
title('Impulso');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Cinco
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Cuatro
[y3,t3] = step(Gs);
figure();

% Subplot 1: Respuesta al escalón
subplot(2,1,1)
plot(t3,y3,'DisplayName', 'Respuesta')
title('Escalón');
xlabel('Tiempo (s)')
ylabel('Amplitud')
grid on

% Encontrar y graficar el punto máximo
[max_val_step, idx_step] = max(y3);
hold on
plot(t3(idx_step), max_val_step, 'ro', 'MarkerSize', 8, 'DisplayName', 'Máximo')
legend

% Subplot 2: Respuesta al impulso
[y4,t4] = impulse(Gs);
subplot(2,1,2)
plot(t4,y4,'DisplayName', 'Respuesta')
title('Impulso');
xlabel('Tiempo (s)')
ylabel('Amplitud')
grid on

% Encontrar y graficar el punto máximo
[max_val_impulse, idx_impulse] = max(y4);
hold on
plot(t4(idx_impulse), max_val_impulse, 'ro', 'MarkerSize', 8, 'DisplayName', 'Máximo')
legend
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%respuesta senales arbitrarias
figure;
num=[3];
den=[1 2 3];
delay=2;
Gs=tf(num,den,'InputDelay',delay);

t=0:0.1:30;
t=t;
%t=linspace(0,30,300);

s1=zeros(1,100);
s2=5*ones(1,100);
s3=10*ones(1,101);

signal = [s1, s2, s3];%concateno
plot(t,signal);
grid minor;
figure

lsim(Gs,signal,t);
grid minor;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%respuesta senales arbitrarias complejo
figure;
num=[3];
den=[1 2 3];
delay=2;
Gs=tf(num,den,'InputDelay',delay);

t=0:0.1:40;
t=t;
%t=linspace(0,30,300);

s1=zeros(1,100);
s2=5*ones(1,100);
s3=linspace(15,25,100);
s4=25*ones(1,101);

signal = [s1, s2, s3, s4];%concateno
plot(t,signal,'DisplayName', 'Señal arbitraria');
grid minor;
figure

lsim(Gs,signal,t);
grid minor;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%actividad reto
figure;
num=[3];
den=[1 2 3];
delay=2;
Gs=tf(num,den,'InputDelay',delay);

t=0:0.1:40;
t=t;
%t=linspace(0,30,300);

s1=linspace(0,10,100);
s2=20*ones(1,100);
s3=linspace(20,10,100);
s4=zeros(1,101);

signal = [s1, s2, s3, s4];%concateno
plot(t,signal,'DisplayName', 'Señal arbitraria');
grid minor;
% Nombrar los ejes
xlabel('Tiempo (s)');   % Etiqueta para el eje X
ylabel('Amplitud');     % Etiqueta para el eje Y

% Agregar título y grid
title('Gráfica de señal arbitraria');
legend
figure

lsim(Gs,signal,t);
grid minor;