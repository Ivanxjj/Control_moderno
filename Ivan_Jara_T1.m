%Universidad de Cuenca
%Taller 1 de control moderno
%Autor: Ivan Jara
clc;clear all;close all;

archivo = 'data_motor.csv'; %leo atchivo
datos = readtable(archivo);%leo csv
disp(datos);

% Mostrar el tipo de dato de cada columna
for i = 1:width(datos)
    fprintf('Columna %d (%s): %s\n', i, datos.Properties.VariableNames{i}, class(datos{:, i}));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure;

plot(datos{:, 2}, datos{:, 3}, '-o', 'DisplayName', 'Signal u');
grid minor;
hold on;
plot(datos{:, 2}, datos{:, 4}, '-x', 'DisplayName', 'Response y');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculo de linea de 100% y base
inicio=round(0.75*length(datos{:,4}));
linea=mean(datos{inicio:end,4});

yline(linea,'--', 'DisplayName', '100 %');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Claculod e recta pendiente
pendientes = diff(datos{:,2}) ./ diff(datos{:,4});
%ecaucion del a recta
p=8;
pendientes(p);
pbasex=datos{p,2};
pbasey=datos{p,4};
y=@(x)pendientes(p)*(x-datos{p,2})+(datos{p,4});

yp2=y((linea-datos{p,4}+pendientes(p)*datos{p,2})/(pendientes(p)));
xp2=(linea-datos{p,4}+pendientes(p)*datos{p,2})/(pendientes(p));

yp20=y((0-datos{p,4}+pendientes(p)*datos{p,2})/(pendientes(p)));
xp20=(0-datos{p,4}+pendientes(p)*datos{p,2})/(pendientes(p));


plot(xp2,yp2, '-o','LineWidth', 1.5, 'DisplayName', 'punto cruce de 100%');
plot(xp20,yp20, '-o','LineWidth', 1.5, 'DisplayName', 'punto de linea base');
fplot(y, 'DisplayName', 'tangente');
yline(yp20,'--', 'DisplayName', 'base');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculo metodos miller

yp_miller=0.6321*linea;

yp2_miller=y((yp_miller-datos{p,4}+pendientes(p)*datos{p,2})/(pendientes(p)));
xp2_miller=(yp_miller-datos{p,4}+pendientes(p)*datos{p,2})/(pendientes(p));

plot(xp2_miller,yp2_miller, '-x','LineWidth', 1.5, 'DisplayName', '0.6321 miller');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculo de analiticico
%yp2a=yp_miller;
yp1a=0.284*linea

yp2a=y((yp1a-datos{p,4}+pendientes(p)*datos{p,2})/(pendientes(p)));
xp2a=(yp1a-datos{p,4}+pendientes(p)*datos{p,2})/(pendientes(p));

plot(xp2a,yp2a, '-x','LineWidth', 1.5, 'DisplayName', '0.284 Y');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%hallar ecuasciones dfd transferencias
%figure;
K=0.6609333;


thetaz=0.3465;

tauz=0.8433;
taum=0.533;
thetaa=0.579;

tauz=2;
taum=3;
thetaa=4;


taua=0.021;

Gz = tf(K,[tauz 1], 'InputDelay', thetaz)
Gm = tf(K,[taum 1], 'InputDelay', thetaz)
Gaa = tf(K,[taua 1], 'InputDelay', thetaa)

%step(Gz)
%step(Gm)
%step(Ga2)
%step(Ga1)

yz = lsim(Gz, datos{:,3}, datos{:,2});
ym = lsim(Gm, datos{:,3}, datos{:,2});
yaa = lsim(Gaa, datos{:,3}, datos{:,2});
plot(datos{:,2},yz,'DisplayName', 'ziegler');
plot(datos{:,2},ym,'DisplayName', 'miller');
plot(datos{:,2},yaa,'DisplayName', 'analitico');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xlim([0, 5]); % Establecer los límites del eje X
ylim([0, 1.6]); % Establecer los límites del eje Y
hold off;
% Personalizar el gráfico
title('Gráfico de datos');
xlabel('Tiempo (s)');
ylabel('Voltaje (V)');
legend;
