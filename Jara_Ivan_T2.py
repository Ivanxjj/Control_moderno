import numpy as np
import matplotlib.pyplot as plt
import control as ctrl

# Numerador y denominador de la función de transferencia
num = [3]
den = [1, 2, 3]
delay = 2  # tiempo muerto

# Crear la función de transferencia con retardo
Gs = ctrl.tf(num, den)
Gs_delayed = ctrl.pade(delay, 1)  # Aproximación de Padé de orden 1
delay_tf = ctrl.tf(*Gs_delayed)
Gs_total = ctrl.series(delay_tf, Gs)

# Definir el tiempo
t = np.arange(0, 40.1, 0.1)  # de 0 a 40 con paso 0.1

# Crear la señal arbitraria
s1 = np.linspace(0, 10, 100)
s2 = 20 * np.ones(100)
s3 = np.linspace(20, 10, 100)
s4 = np.zeros(101)
signal = np.concatenate((s1, s2, s3, s4))

# Gráfica de la señal arbitraria
plt.figure()
plt.plot(t, signal, label='Señal arbitraria')
plt.grid(True, which='both', linestyle='--', linewidth=0.5)
plt.xlabel('Tiempo (s)')
plt.ylabel('Amplitud')
plt.title('Gráfica de señal arbitraria')
plt.legend()

# Simulación con lsim
# Simulación con lsim / forced_response
plt.figure()
t_out, y = ctrl.forced_response(Gs_total, T=t, U=signal)

# Graficar la entrada
plt.plot(t, signal, label='Entrada (Señal arbitraria)', linestyle='--')

# Graficar la salida
plt.plot(t_out, y, label='Salida del sistema')

# Decoración del gráfico
plt.grid(True, which='both', linestyle='--', linewidth=0.5)
plt.xlabel('Tiempo (s)')
plt.ylabel('Amplitud')
plt.title('Entrada vs. Salida del sistema con retardo')
plt.legend()
plt.show()

