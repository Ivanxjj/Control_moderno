import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp

# === Parámetros del circuito ===
R = 100
L = 0.1
Cap = 1e-6

# === Matrices del sistema con 2 salidas ===
A = np.array([[-R / L, -1 / (L * Cap)],
              [1,        0]])
B = np.array([[1 / L],
              [0]])
C = np.array([[1,     0],
              [0, 1 / Cap]])
D = np.array([[0],
              [0]])

# === Tiempo de simulación ===
ts = 0.001
t_final = 0.05
tspan = np.arange(0, t_final + ts, ts)
N = len(tspan)

# === Inicialización ===
x0 = np.array([0, 0])
X = np.zeros((N, 2))      # Estados
Y = np.zeros((N, 2))      # Salidas
u_vec = np.zeros(N)       # Entrada
X[0, :] = x0

# === Función u(t): entrada arbitraria ===
def entrada(t):
    if t < 0.0175:
        return 0
    elif t < 0.034:
        return 5
    elif t < 0.05:
        return 10
    else:
        return 10

# === Modelo con entrada constante ===
def modelRLC_constante(t, x, uk):
    x = x.reshape(-1, 1)
    dx = A @ x + B * uk
    return dx.flatten()

# === Bucle de simulación paso a paso ===
for k in range(1, N):
    uk = entrada(tspan[k])
    u_vec[k] = uk

    # Resolver ODE entre t(k-1) y t(k)
    sol = solve_ivp(lambda t, x: modelRLC_constante(t, x, uk),
                    [tspan[k-1], tspan[k]],
                    X[k-1, :],
                    method='RK45',
                    t_eval=[tspan[k]])
    X[k, :] = sol.y[:, -1]

    # Calcular salida
    Y[k, :] = (C @ X[k, :].reshape(-1, 1) + D * uk).flatten()

# === Gráficas ===
plt.figure(figsize=(10, 6))

plt.subplot(2, 2, 1)
plt.plot(tspan, u_vec)
plt.title('Entrada arbitraria')
plt.xlabel('Tiempo [s]')
plt.ylabel('u(t)')

plt.subplot(2, 2, 2)
plt.plot(tspan, Y[:, 0])
plt.title('Corriente en el circuito')
plt.xlabel('Tiempo [s]')
plt.ylabel('i [A]')

plt.subplot(2, 2, 3)
plt.plot(tspan, Y[:, 1])
plt.title('Voltaje en el capacitor')
plt.xlabel('Tiempo [s]')
plt.ylabel('Vc [V]')

# Si quieres activar el espacio de estados, descomenta esto:
# plt.subplot(2, 2, 4)
# plt.plot(X[:, 0], X[:, 1], marker='>')
# plt.title('Espacio de estados')
# plt.xlabel('x1 = q')
# plt.ylabel('x2 = i')

plt.tight_layout()
plt.show()
