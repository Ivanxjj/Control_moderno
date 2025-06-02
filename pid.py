import numpy as np
import matplotlib.pyplot as plt
from control import tf, feedback, series, parallel, step_response, pzmap, poles, zeros
from scipy.signal import residue
from sympy import Matrix, symbols

# Parámetros
R = 5
L = 0.1
Cap = 220e-6
Kp = 10
Ki = 1000
Kd = 0.01

# Planta RLC
num = [1 / (L * Cap)]
den = [1, R/L, 1/(L*Cap)]
G = tf(num, den)

# PID (P + I + D)
P = tf([Kp], [1])
I = tf([Ki], [1, 0])
D = tf([Kd, 0], [1])

PID = parallel(P, I)
PID = parallel(PID, D)

# Lazo abierto y cerrado
OpenLoop = series(PID, G)
ClosedLoop = feedback(OpenLoop, 1)

# Mostrar
print("Función de transferencia en lazo cerrado:")
print(ClosedLoop)

# Polos y ceros
print("Polos del sistema:", poles(ClosedLoop))
print("Ceros del sistema:", zeros(ClosedLoop))

# Ecuación característica (denominador)
den_cl = ClosedLoop.den[0][0]
print("Polinomio característico:", den_cl)

# Routh-Hurwitz (con SymPy)
def routh_hurwitz(coeffs):
    n = len(coeffs)
    if n % 2 == 1:
        coeffs.append(0)  # hacer par si es impar

    m = int(n / 2)
    R = np.zeros((n, m))
    R[0] = coeffs[::2]
    R[1] = coeffs[1::2]

    for i in range(2, n):
        for j in range(m - 1):
            a = R[i-2][0]
            b = R[i-2][j+1]
            c = R[i-1][0]
            d = R[i-1][j+1]
            R[i][j] = ((-1) * (a*d - b*c)) / c if c != 0 else 0
    return R

print("\nTabla de Routh-Hurwitz:")
rh_table = routh_hurwitz(den_cl)
print(rh_table)

# Estabilidad
stable = np.all(poles(ClosedLoop).real < 0)
print(f"\n¿El sistema es estable?: {stable}")

## Gráfica subplot
t, y = step_response(ClosedLoop)
plt.figure(figsize=(10, 4))

# Subplot 1: Respuesta al escalón
plt.subplot(1, 2, 1)
plt.plot(t, y)
plt.title("Respuesta al escalón")
plt.xlabel("Tiempo [s]")
plt.ylabel("Amplitud")
plt.grid()

# Subplot 2: Mapa de polos y ceros manual
plt.subplot(1, 2, 2)
p = poles(ClosedLoop)
z = zeros(ClosedLoop)
plt.scatter(z.real, z.imag, marker='o', color='blue', label='Ceros')
plt.scatter(p.real, p.imag, marker='x', color='red', label='Polos')
plt.axhline(0, color='black', lw=0.5)
plt.axvline(0, color='black', lw=0.5)
plt.grid(True)
plt.title("Mapa de polos y ceros")
plt.xlabel("Re")
plt.ylabel("Im")
plt.legend()

plt.tight_layout()
plt.show()