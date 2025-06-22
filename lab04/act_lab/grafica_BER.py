import numpy as np
import matplotlib.pyplot as plt

# Eb/N0 en dB (1 a 11)
ebn0 = np.arange(1, 12)

# Exponentes medidos para BER
bpsk_exp = np.array([2.8, 3.12, 3.54, 4.03, 4.60, 5.36, 6.30, 7.5, np.nan, np.nan, np.nan])
qpsk_exp = np.array([4.33, 5.10, 5.93, 7.48, np.nan, np.nan, np.nan, np.nan, np.nan, np.nan, np.nan])
psk8_exp = np.array([1.76, 1.92, 2.1, 2.34, 2.63, 2.98, 3.42, 3.98, 4.63, 5.45, 6.31])

# Convertir exponentes a BER reales
bpsk_ber = 10**(-bpsk_exp)
qpsk_ber = 10**(-qpsk_exp)
psk8_ber = 10**(-psk8_exp)

# Grafica
plt.figure(figsize=(8,5))
plt.semilogy(ebn0, bpsk_ber, 'o-', label='BPSK', color='blue')
plt.semilogy(ebn0, qpsk_ber, 's-', label='QPSK', color='green')
plt.semilogy(ebn0, psk8_ber, '^-', label='8-PSK', color='orange')

plt.grid(True, which='both', linestyle='--', linewidth=0.5)
plt.xlabel('$E_b/N_0$ (dB)')
plt.ylabel('Tasa de error de bits (BER)')
plt.title('BER vs. $E_b/N_0$ para distintas modulaciones')
plt.legend()
plt.tight_layout()
plt.show()