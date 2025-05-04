import numpy as np
import matplotlib.pyplot as plt
import control as ctrl

# === Parámetros del circuito RLC serie ===
R = 100           # Resistencia en ohmios
L = 0.1           # Inductancia en henrios
Cap = 1e-6        # Capacitancia en faradios

# === Matrices del modelo en espacio de estados ===
A = np.array([[-R/L, -1/(L*Cap)],
              [1,     0]])
B = np.array([[1/L],
              [0]])
C = np.array([[1, 0],
              [0, 1/Cap]])   # Salidas: voltaje del capacitor y corriente
D = np.array([[0],
              [0]])

# === Crear sistema en espacio de estados ===
sys = ctrl.ss(A, B, C, D)

# === Respuesta al escalón ===
t1, y1 = ctrl.step_response(sys)

# Asegurarse de que las dimensiones coincidan y extraer el voltaje
y1_voltage = y1[0, :].flatten()  # Asegurarse de que sea un array 1D

# Graficar las respuestas al escalón
plt.figure(figsize=(10, 6))
plt.subplot(2, 1, 1)
plt.plot(t1, y1_voltage, label='Vc (voltaje)')
plt.title('Respuesta al Escalón')
plt.xlabel('Tiempo [s]')
plt.ylabel('Voltaje [V]')
plt.legend()

# === Respuesta al impulso ===
t2, y2 = ctrl.impulse_response(sys)

# Asegurarse de que las dimensiones coincidan y extraer el voltaje
y2_voltage = y2[0, :].flatten()  # Asegurarse de que sea un array 1D

# Graficar las respuestas al impulso
plt.subplot(2, 1, 2)
plt.plot(t2, y2_voltage, label='Vc (voltaje)')
plt.title('Respuesta al Impulso')
plt.xlabel('Tiempo [s]')
plt.ylabel('Voltaje [V]')
plt.legend()

plt.tight_layout()
plt.show()

# === Conversión a función de transferencia ===
G = ctrl.ss2tf(sys)
print("Función de transferencia del sistema:")
print(G)

# === Conversión de nuevo a espacio de estados ===
AA, BB, CC, DD = ctrl.tf2ss(G)
