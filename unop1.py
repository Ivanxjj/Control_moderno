import numpy as np
import matplotlib.pyplot as plt
import control as ctrl

# Parámetros del circuito
R = 100           # Resistencia en ohmios
L = 0.1           # Inductancia en henrios
Cap = 1e-6        # Capacitancia en faradios

# Matrices del sistema
A = np.array([[0, 1],
              [-1/(L*Cap), -R/L]])
B = np.array([[0],
              [1/L]])
C = np.array([[1/Cap, 0]])
D = np.array([[0]])

# Crear sistema en espacio de estados
sys = ctrl.ss(A, B, C, D)

# Respuesta al escalón
t_step, y_step = ctrl.step_response(sys)

# Respuesta al impulso
t_imp, y_imp = ctrl.impulse_response(sys)

# Gráficas
plt.figure(figsize=(10, 6))

plt.subplot(2, 1, 1)
plt.plot(t_step, y_step)
plt.title('Respuesta al Escalón')
plt.xlabel('Tiempo [s]')
plt.ylabel('Vc [V]')
plt.grid(True)

plt.subplot(2, 1, 2)
plt.plot(t_imp, y_imp)
plt.title('Respuesta al Impulso')
plt.xlabel('Tiempo [s]')
plt.ylabel('Vc [V]')
plt.grid(True)

plt.tight_layout()
plt.show()
