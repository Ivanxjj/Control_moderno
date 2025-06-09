import numpy as np
import matplotlib.pyplot as plt
import control as ctrl

# Definir función de transferencia
num = [1, 3]
den = [1, 5, 20, 16, 0]
G = ctrl.TransferFunction(num, den)

# Calcular ceros y polos
zs = ctrl.zeros(G)
ps = ctrl.poles(G)

# Cálculo de parámetros para asíntotas
n = len(ps)
m = len(zs)
k = np.arange(n - m)
theta = (2 * k + 1) * np.pi / (n - m)
sigma0 = (np.sum(np.real(ps)) - np.sum(np.real(zs))) / (n - m)

# Intersecciones con eje imaginario
x = 0
y1 = np.sqrt(3) * (x - sigma0)
y2 = -y1

# Líneas de asíntotas
x1 = np.linspace(sigma0, 6, 200)
x2 = np.linspace(-6, sigma0, 200)

# Derivada de K(s) = -1/G(s)
G_inv = -1 / G
B, A = ctrl.tfdata(G_inv)
B = np.squeeze(B)
A = np.squeeze(A)
term1 = np.convolve(B, np.polyder(A))
term2 = np.convolve(A, np.polyder(B))
max_len = max(len(term1), len(term2))
term1 = np.pad(term1, (max_len - len(term1), 0))
term2 = np.pad(term2, (max_len - len(term2), 0))
adyacentes = term1 - term2
psKs = np.roots(adyacentes)
psKs_real = psKs[np.isclose(np.imag(psKs), 0)]

# Cruce con eje imaginario (Routh-Hurwitz)
K_roots = np.roots([1, 7, -1344])
K = K_roots[K_roots > 0]
if K.size > 0:
    K_val = K[0]
    jw_poly = [(84 - K_val)/5, 0, 3 * K_val]
    jwints = np.roots(jw_poly)
else:
    jwints = []

# Gráfica completa
fig, ax = plt.subplots()
ax.axis([-6, 6, -6, 6])
ax.set_aspect('equal', adjustable='box')
ax.grid(True)
ax.set_title("Lugar Geométrico de las Raíces - Detalles")
ax.set_xlabel('Parte Real')
ax.set_ylabel('Parte Imaginaria')

# Lugar geométrico de las raíces
ctrl.rlocus(G, ax=ax)

# Polos y ceros
ax.plot(np.real(zs), np.imag(zs), 'bo', label='Ceros')
ax.plot(np.real(ps), np.imag(ps), 'rx', label='Polos')

# Asíntotas
ax.plot(sigma0, 0, 'gh', label='Centro de asíntotas')

# Intersecciones con eje imaginario
ax.plot(0, y1, 'kd')
ax.plot(0, y2, 'kd')

# Líneas de asíntotas
for angle in theta:
    m_ang = np.tan(angle)
    ax.plot(x1, m_ang * (x1 - sigma0), 'k-.', linewidth=0.8)
    ax.plot(x2, m_ang * (x2 - sigma0), 'k-.', linewidth=0.8)

# Puntos de llegada
ax.plot(np.real(psKs_real), np.imag(psKs_real), 'ks', label='Ptos. de llegada')

# Cruce con eje imaginario
if K.size > 0:
    ax.plot(np.real(jwints), np.imag(jwints), 'ks', label='Cruce jω')

ax.legend()
plt.show()
