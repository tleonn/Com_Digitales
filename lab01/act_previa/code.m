clc; clear; close all;

% Parámetros configurables
A = 1;                  % Amplitud de la señal
Fc = 1000;              % Frecuencia de la señal (Hz)
Fs = 5000;              % Frecuencia de muestreo (Hz)
d = 0.5;                % Ciclo de trabajo (0 < d <= 1)
ts = 1/100000;          % Período de muestreo de la señal

% Generación de la señal original
T = 1/Fc;               % Período de la señal
n_samples = 200;     % Número de muestras para 2 ciclos

% Vector de tiempo
t = 0:ts:(n_samples-1)*ts;
m_t = A * sin(2 * pi * Fc * t);

% Muestreo natural
Ts = 1/Fs;              % Período de muestreo
n_samples_pam = floor(length(t) / (Ts / ts));
t_pam = 0:ts:(n_samples-1)*ts;
m_pam = A * sin(2 * pi * Fc * t_pam);
width = d * Ts;         % Duración de cada pulso

%% Muestreo Natural PAM
% Generar tren de pulsos natural
natural_samples = zeros(size(t));
for i = 0:floor(max(t)/Ts)
    pulse_start = i*Ts;
    pulse_end = pulse_start + width;
    natural_samples((t >= pulse_start) & (t < pulse_end)) = 1;
end

pam_natural = m_t .* natural_samples; % Señal PAM natural

%% Muestreo instantáneo
instant_pulses = zeros(size(t));
for n = 0:floor(max(t)/Ts)
    % Calcular tiempo de muestra dentro de Ts
    sample_time = n*Ts + d*Ts/2; % Muestra en el centro de la ventana d*Ts
    [~, idx] = min(abs(t - sample_time));
    if idx <= length(t)
        instant_pulses(idx) = m_t(idx);
    end
end


% Gráficos
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


figure;
hold on;
plot(t, m_t, 'LineWidth', 1.5);
plot(t, pam_natural, 'LineWidth', 1.2);
stem(t, instant_pulses, 'b', 'Marker', 'none');
legend('Original', 'PAM Natural', 'PAM Instantáneo');
title('Comparación de Señales');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;
