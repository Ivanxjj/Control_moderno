clc; clear all; close all;

%  Parámetros del circuito 
R = 100;
L = 0.1;
Cap = 1e-6;

%  Matrices del sistema con 2 salidas 
A = [-R/L, -1/(L*Cap); 1, 0];
B = [1/L; 0];
C = [1, 0; 0, 1/Cap];
D = [0; 0];

%  Tiempo de simulación 
ts = 0.001;
t_final = 0.05;
tspan = 0:ts:t_final;
N = length(tspan);

%  Inicialización 
x0 = [0; 0];
X = zeros(N, 2);     % Estados
Y = zeros(N, 2);     % Salidas
u_vec = zeros(N,1);  % Entradas
X(1,:) = x0;

%  Bucle de simulación paso a paso 
for k = 2:N
    % Valor de entrada constante en este paso
    uk = entrada(tspan(k));
    u_vec(k) = uk;

    % Resolver ODE entre t(k-1) y t(k)
    [t_local, Xk] = ode45(@(t,x) modelRLC_constante(t, x, A, B, uk), ...
                          [tspan(k-1), tspan(k)], X(k-1,:)');
    X(k,:) = Xk(end,:);  % Guardar solo el último valor

    % Calcular salida en ese instante
    Y(k,:) = (C * X(k,:).' + D * uk).';  % Transponer para que quede como fila
end

%  Gráficas 
figure;

subplot(2,2,1);
plot(tspan, u_vec);
title('Entrada arbitraria');
xlabel('Tiempo [s]');
ylabel('u(t)');

subplot(2,2,2);
plot(tspan, Y(:,1));
title('Corriente en el circuito');
xlabel('Tiempo [s]');
ylabel('i [A]');

subplot(2,2,3);
plot(tspan, Y(:,2));
title('Voltaje en el capacitor');
xlabel('Tiempo [s]');
ylabel('Vc [V]');

%subplot(2,2,4);
%plot(X(:,1), X(:,2), '>-');
%title('Espacio de estados');
%xlabel('x1 = q'); ylabel('x2 = i');

% === Función u(t): entrada arbitraria ===
function u = entrada(t)
    if t < 0.0175
        u = 0;
    elseif t < 0.034
        u = 5;
    elseif t < 0.05
        u = 10;
    else
        u = 10;
    end
end

% === Modelo del sistema con entrada constante ===
function dx = modelRLC_constante(t, x, A, B, u)
    dx = A * x + B * u;
end
