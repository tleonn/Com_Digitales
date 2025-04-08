clc; clear; close all;

%% Parametros
A = 1;                  % Amplitud de la señal
Fc = 1000;              % Frecuencia de la señal (Hz)
Fs = 35000;             % Frecuencia de muestreo (Hz)
d = 0.5;                % Ciclo de trabajo (duty cycle) del pulso (0 < d <= 1)
ts = 1/100000;          % Período de muestreo 

% Generación del tiempo y señal original
T = 1/Fc;               % Período de la señal senoidal
n_samples = 200;        % Número de muestras totales para simular 2 ciclos de la señal

t = 0:ts:(n_samples-1)*ts;           % Vector de tiempo
m_t = A * sin(2 * pi * Fc * t);      % Señal senoidal original

% Muestreo
Ts = 1/Fs;                            % Período de muestreo real
n_samples_pam = floor(length(t) / (Ts / ts)); % Cantidad de muestras reales basadas en Ts
width = d * Ts;                      

%%  Muestreo instantaneo
instant_pulses = zeros(size(t));     
for n = 0:floor(max(t)/Ts)

    sample_time = n * Ts + d * Ts / 2;
    [~, idx] = min(abs(t - sample_time));  
    if idx <= length(t)
        instant_pulses(idx) = m_t(idx);   
    end
end

%% Cuantificacion 

N = 2;                                % Número de bits 

% 1. Niveles de cuantificación
num_levels = 2^N;                     % Total de niveles de cuantificación
q_levels = linspace(-A, A, num_levels); % Crear niveles uniformemente espaciados entre -A y A


% 2. Cuantificación tipo "sample and hold"
quantized_signal = zeros(size(instant_pulses));  % Inicializar señal cuantificada
sample_indices = find(instant_pulses ~= 0);      % Buscar los índices donde hay muestras (no ceros)

for i = 1:length(sample_indices)
    idx_start = sample_indices(i);               % Índice donde empieza el nivel mantenido

    if i < length(sample_indices)
        idx_end = sample_indices(i+1) - 1;       % Mantener nivel hasta antes del próximo impulso
    else
        idx_end = length(instant_pulses);        % Si es el último, mantener hasta el final
    end

    % Buscar el nivel más cercano
    [~, q_idx] = min(abs(instant_pulses(idx_start) - q_levels));
    level = q_levels(q_idx);                     % Valor cuantificado

    % Rellenar con ese nivel
    quantized_signal(idx_start:idx_end) = level;
end

%% Error de cuantizacion
quant_error = instant_pulses - quantized_signal;   % Diferencia entre señal original y cuantificada
disp(quant_error);                                 

error_max = max(abs(quant_error));                 % Error máximo absoluto
fprintf('Error máximo: %.4f\n', error_max);        


%% Graficos

figure;
hold on;
plot(t, m_t, 'b', 'LineWidth', 1.5);                
stem(t, instant_pulses, 'o', 'Marker', 'none');     
stairs(t, quantized_signal, 'r', 'LineWidth', 1.2); 

% Nota: se usa `stairs` en vez de `plot` para representar bien la salida cuantificada tipo escalera

legend('Original', 'PAM Instantáneo', 'PCM');
title('Comparación de Señales');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;
