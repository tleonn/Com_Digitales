% Parámetros
A = 1;
Ac = 1; % Amplitud de la portadora
fs = 1000; % Frecuencia de muestreo
T = 1/fs; % Duración de la señal
t = 0:T:1-T; % Vector de tiempo

m_t = sin(2*pi*5*t) + 0.5*cos(2*pi*20*t);

% Envoltura compleja g(t)
g_t = Ac * m_t;

% Transformada de Fourier
G_f = fft(g_t);
f = linspace(-fs/2, fs/2, length(G_f));

% Graficar la magnitud de la Transformada de Fourier
figure;
plot(f, abs(fftshift(G_f)));
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
title('Transformada de Fourier de Envolvente Compleja g(t)');