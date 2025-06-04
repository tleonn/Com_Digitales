% Parámetros
A = 1;                  % Amplitud
Fs = 10000;             % Frecuencia de muestreo
T = 1;                  % Duración
t = 0:1/Fs:T-1/Fs;      % Vector de tiempo
df = 2500;              % Delta f

% Envolventes complejas
g0 = A * exp(-1j*2*pi*df*t);   % bit 0 (desfasaje -1kHz)
g1 = A * exp(1j*2*pi*df*t);    % bit 1 (desfasaje +1kHz)


% FFT
N = length(t);
f = (-N/2:N/2-1)*(Fs/N);

G0 = fftshift(fft(g0)/N);
G1 = fftshift(fft(g1)/N);


%% Envolventes complejas (baseband)

figure;
plot(f, abs(G0), 'b', 'LineWidth', 1.5); hold on;
plot(f, abs(G1), 'r--', 'LineWidth', 1.5);
title('Transformadas de Fourier de las envolventes complejas');
xlabel('Frecuencia (Hz)');
ylabel('|G(f)|');
legend('Bit 0 (-1kHz)', 'Bit 1 (+1kHz)');
xlim([-3000 3000]); grid on;