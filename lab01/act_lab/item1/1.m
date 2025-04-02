clc; clear; close all;
% Parámetros configurables
A = 1; % Amplitud de la señal
Fc = 1000; % Frecuencia de la señal (Hz)
Fs = 5000; % Frecuencia de muestreo (Hz)
d = 0.5; % Ciclo de trabajo (0 < d <= 1)
ts = 1/100000; % Período de muestreo de la señal
% Generación de la señal original
T = 1/Fc; % Período de la señal
n_samples = 200; % Número de muestras para 2 ciclos
% Vector de tiempo
t = 0:ts:(n_samples-1)*ts;
m_t = A * sin(2 * pi * Fc * t);
% Muestreo natural
Ts = 1/Fs; % Período de muestreo
n_samples_pam = floor(length(t) / (Ts / ts));
t_pam = 0:ts:(n_samples-1)*ts;
m_pam = A * sin(2 * pi * Fc * t_pam);
width = d * Ts; % Duración de cada pulso
%% Muestreo Natural PAM
% Generar tren de pulsos natural
natural_samples = zeros(size(t));
for i = 0:floor(max(t)/Ts)
 pulse_start = i*Ts;
 pulse_end = pulse_start + width;
 natural_samples((t >= pulse_start) & (t < pulse_end)) = 1;
end
pam_natural = m_t .* natural_samples; % Señal PAM natural
% Muestreo instantáneo
instant_pulses = zeros(size(t));
for i = 1:length(t_pam)
 idx = find(t >= t_pam(i), 1);
 instant_pulses(idx) = m_pam(i);
end
% Gráficos de las señales en el tiempo
figure;
subplot(3,1,1);
plot(t, m_t, 'b');
xlabel('Tiempo (s)'); ylabel('Amplitud');
title('Señal Original m(t)');
grid on;
subplot(3,1,2);
plot(t, pam_natural, 'r');
xlabel('Tiempo (s)'); ylabel('Amplitud');
title('Muestreo Natural');
grid on;
subplot(3,1,3);
stem(t, instant_pulses, 'b', 'Marker', 'none');
xlabel('Tiempo (s)'); ylabel('Amplitud');
title('Muestreo Instantáneo');
grid on;

%% CÁLCULO DE LA TRANSFORMADA DE FOURIER DE CADA SEÑAL
% Longitud de las señales
L = length(t);
% Frecuencia de muestreo efectiva
Fs_eff = 1/ts;
% Calcular las transformadas de Fourier
Y_original = fft(m_t);
Y_natural = fft(pam_natural);
Y_instant = fft(instant_pulses);
% Vector de frecuencia para el eje x
f = Fs_eff*(0:(L/2))/L;
% Magnitud de las transformadas (solo parte positiva)
P_original = abs(Y_original/L);
P_original = P_original(1:L/2+1);
P_original(2:end-1) = 2*P_original(2:end-1);
P_natural = abs(Y_natural/L);
P_natural = P_natural(1:L/2+1);
P_natural(2:end-1) = 2*P_natural(2:end-1);
P_instant = abs(Y_instant/L);
P_instant = P_instant(1:L/2+1);
P_instant(2:end-1) = 2*P_instant(2:end-1);

% Gráfico de las transformadas de Fourier
figure;
subplot(3,1,1);
plot(f, P_original, 'b');
xlabel('Frecuencia (Hz)'); ylabel('|P(f)|');
title('Espectro de la Señal Original');
grid on;
xlim([0 3*Fs]); % Limitar el eje x para mejor visualización

subplot(3,1,2);
plot(f, P_natural, 'r');
xlabel('Frecuencia (Hz)'); ylabel('|P(f)|');
title(sprintf('Espectro del Muestreo Natural (d = %.1f)', d));
grid on;
xlim([0 3*Fs]); % Limitar el eje x para mejor visualización

subplot(3,1,3);
plot(f, P_instant, 'g');
xlabel('Frecuencia (Hz)'); ylabel('|P(f)|');
title('Espectro del Muestreo Instantáneo');
grid on;
xlim([0 3*Fs]); % Limitar el eje x para mejor visualización

% Figura con las tres transformadas superpuestas para comparación
figure;
plot(f, P_original, 'b', 'LineWidth', 1.5);
hold on;
plot(f, P_natural, 'r', 'LineWidth', 1);
plot(f, P_instant, 'g', 'LineWidth', 1);
xlabel('Frecuencia (Hz)'); ylabel('|P(f)|');
title('Comparación de Espectros');
legend('Señal Original', 'Muestreo Natural', 'Muestreo Instantáneo');
grid on;
xlim([0 3*Fs]); % Limitar el eje x para mejor visualización

% Experimento adicional: Variación del ciclo de trabajo
figure;
d_values = [0.2, 0.5, 0.8];
colors = ['r', 'g', 'b'];

for i = 1:length(d_values)
    d_test = d_values(i);
    width_test = d_test * Ts;
    
    % Generar tren de pulsos natural con nuevo ciclo de trabajo
    natural_samples_test = zeros(size(t));
    for j = 0:floor(max(t)/Ts)
        pulse_start = j*Ts;
        pulse_end = pulse_start + width_test;
        natural_samples_test((t >= pulse_start) & (t < pulse_end)) = 1;
    end
    pam_natural_test = m_t .* natural_samples_test;
    
    % Calcular espectro
    Y_natural_test = fft(pam_natural_test);
    P_natural_test = abs(Y_natural_test/L);
    P_natural_test = P_natural_test(1:L/2+1);
    P_natural_test(2:end-1) = 2*P_natural_test(2:end-1);
    
    % Graficar
    subplot(3,1,i);
    plot(f, P_natural_test, colors(i));
    xlabel('Frecuencia (Hz)'); ylabel('|P(f)|');
    title(sprintf('Espectro PAM Natural, d = %.1f', d_test));
    grid on;
    xlim([0 3*Fs]);
end

% Experimento adicional: Variación de la frecuencia de muestreo
figure;
Fs_values = [3000, 5000, 8000];
colors = ['r', 'g', 'b'];

for i = 1:length(Fs_values)
    Fs_test = Fs_values(i);
    Ts_test = 1/Fs_test;
    width_test = d * Ts_test;
    
    % Generar tren de pulsos natural con nueva frecuencia de muestreo
    natural_samples_test = zeros(size(t));
    for j = 0:floor(max(t)/Ts_test)
        pulse_start = j*Ts_test;
        pulse_end = pulse_start + width_test;
        natural_samples_test((t >= pulse_start) & (t < pulse_end)) = 1;
    end
    pam_natural_test = m_t .* natural_samples_test;
    
    % Calcular espectro
    Y_natural_test = fft(pam_natural_test);
    P_natural_test = abs(Y_natural_test/L);
    P_natural_test = P_natural_test(1:L/2+1);
    P_natural_test(2:end-1) = 2*P_natural_test(2:end-1);
    
    % Graficar
    subplot(3,1,i);
    plot(f, P_natural_test, colors(i));
    xlabel('Frecuencia (Hz)'); ylabel('|P(f)|');
    title(sprintf('Espectro PAM Natural, Fs = %d Hz', Fs_test));
    grid on;
    xlim([0 3*Fs_test]);
end
