clc,clear all,close all;
num=1;
den=[2 1];
gs=tf(num,den);
roots(den);
pole(gs);
%%
wn=1;
xi=1.2;%0 osilatorio,0.2 subamoprtiguado,1 crticament amortiguado.1.2sobre amoritguado

num=wn^2;
den=[1 2*xi*wn wn^2];
gs=tf(num,den);

roots(den);
pole(gs);

[y,t]=step(gs,15);

subplot(2,1,1)
plot(t,y);
grid on
title("Sistema oscilatorio");
subplot(2,1,2)
pzmap(gs)

%%
