% Taller 8 de control moderno
% Autor: Ivan Jara
% Tema: Compensador en adelanto y en retraso (switch opcional)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear all; close all;

%% 1. Función de transferencia del circuito RLC serie
R = 22;              % Ohmios
L = 500e-6;          % Henrios
C = 220e-6;          % Faradios

numm = 1;
denm = [L*C, R*C, 1];
gm = tf(numm, denm)



%% 2. Raíces del sistema original
raices = roots(denm)
polo1 = raices(1);
polo2 = raices(2);

%% 3. Especificaciones de diseño
Mpd = 0.25;
tssd = 0.05;
zeta = log(1/Mpd) / sqrt(pi^2 + (log(1/Mpd))^2);
wn = 4 / (tssd * zeta);
rsd12 = roots([1 2*zeta*wn wn^2])  % Polos deseados

sd = rsd12(1);  % Uno de los polos deseados

%% 4. Mostrar rlocus y polos deseados
figure;
rlocus(gm)
hold on
plot(real(rsd12), imag(rsd12), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
title('ORIGINAL CON POLOS A DISEÑAR (SIN COMPENSAR)');
axis equal;
ylim([-190 190]);

%% 5. Elección del tipo de compensador
opcion = menu('Selecciona tipo de compensador','Adelanto','Retraso');

switch opcion
    case 1  % ADELANTO
        fprintf('\n>> DISEÑO CON COMPENSADOR EN ADELANTO <<\n');
        
        % Cancelamos el polo más lento (el más a la derecha)
        zc = real(polo2);  % Cero en el polo más lento

        % Ángulo desde el otro polo (el que NO se cancela)
        theta1 = rad2deg(angle(sd - polo1));
        theta4 = 180 - theta1;

        % Calcular polo del compensador para cubrir el ángulo
        pc = real(sd) - imag(sd)/tand(theta4);
        
    case 2  % RETRASO
        fprintf('\n>> DISEÑO CON COMPENSADOR EN RETRASO <<\n');
        
        % Cancelamos el polo más rápido (más a la izquierda)
        zc = real(polo1);  % Cero en ese polo

        % Ángulo desde el otro polo (el que NO se cancela)
        theta1 = rad2deg(angle(sd - polo2));
        theta4 = 180 - theta1;

        % Polo del compensador más cerca del eje imaginario
        pc = real(sd) - imag(sd)/tand(theta4);
end

% Mostrar resultados
fprintf('Ángulo θ1 desde polo no cancelado = %.2f°\n', theta1);
fprintf('Ángulo que debe aportar compensador θ4 = %.2f°\n', theta4);
fprintf('Cero del compensador zc = %.4f\n', zc);
fprintf('Polo del compensador pc = %.4f\n', pc);

%% 6. Crear compensador
Kc = 1;
s = tf('s');
Gc = Kc * (s - zc) / (s - pc);  % Signos negativos porque polos/ceros son reales negativos
Gc3 = series(Gc, gm);

%% 7. Lugar de raíces compensado
figure;
rlocus(Gc3)
hold on
plot(real(rsd12), imag(rsd12), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
title('Lugar de raíces del sistema compensado')
axis equal;
ylim([-190 190]);

%% 8. Polos y ceros del compensador
figure;
pzmap(Gc3)
hold on
plot(real(rsd12), imag(rsd12), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
title('Polos y ceros del sistema compensado')
axis equal;
ylim([-190 190]);

%% 9. Cálculo de Kc
Gt = Gc3;  % Asumimos retroalimentación unitaria
mkc = 1 / abs(evalfr(Gt, sd));
fprintf('Ganancia Kc necesaria = %.4f\n', mkc);

%% 10. Sistema compensado final en lazo cerrado
gcomp = feedback(mkc * Gc3, 1);

% Comparar respuestas
figure;
subplot(2,1,1)
step(gcomp)
hold on
step(gm)
legend('Compensado', 'Original')
title('Comparación de respuestas al escalón')
grid on

subplot(2,1,2)
rlocus(gcomp)
title('Lugar de raíces del sistema compensado con Kc')
grid on

%% 11. Análisis de desempeño
[y, t] = step(gcomp);
y_ss = y(end);
[max_val, idx_max] = max(y);
Mp_calc = ((max_val - y_ss)/y_ss)*100;
t_pico = t(idx_max);
idx_tss = find(t >= tssd, 1, 'first');

valor_tss = y(idx_tss);
t_tss = t(idx_tss);

% Graficar respuesta con anotaciones
figure;
step(gcomp)
grid on
hold on
p1 = plot(t_pico, max_val, 'ro', 'MarkerSize', 10, 'LineWidth', 2);     % rojo: Mp
p2 = plot(t_tss, valor_tss, 'mo', 'MarkerSize', 10, 'LineWidth', 2);    % magenta: tss

legend([p1, p2], {
    sprintf('Mp = %.2f%% en (%.3f, %.5f)', Mp_calc, t_pico, max_val),
    sprintf('tss = %.2fs en (%.3f, %.5f)', tssd, t_tss, valor_tss)
}, 'Location', 'best');

% Resultados en consola
disp('--- Resultados del sistema compensado ---');
disp(['Sobreimpulso calculado (Mp): ', num2str(Mp_calc), '%']);
disp(['Coordenadas del pico: (', num2str(t_pico), ', ', num2str(max_val), ')']);
disp(['Coordenadas en tss ≈ 0.05s: (', num2str(t_tss), ', ', num2str(valor_tss), ')']);
