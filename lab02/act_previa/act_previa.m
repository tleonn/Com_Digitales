% Parámetros iniciales
f0 = 1; % Frecuencia de 6 dB (elegir un valor arbitrario, ej. 1 Hz)
alphas = [0, 0.25, 0.75, 1]; % Factores de roll-off
t = linspace(0, 10, 1000); % Vector de tiempo (t >= 0)
N = length(t);

% Inicializar matrices para guardar todas las respuestas
all_h = zeros(length(alphas), length(t)); % cada fila será un h diferente
f = linspace(-2*(f0 + max(alphas)*f0), 2*(f0 + max(alphas)*f0), 1000); % f general
all_H = zeros(length(alphas), length(f)); % cada fila será un H diferente

% Configuración de gráficos
figure;
for i = 1:length(alphas)
    alpha = alphas(i);
    
    % Cálculo de parámetros
    f_delta = alpha * f0;
    B = f0 + f_delta; % Ancho de banda absoluto
    f1 = f0 - f_delta;
    
    % Respuesta en frecuencia H_e(f)
    H = zeros(size(f));
    for j = 1:length(f)
        if abs(f(j)) < f1
            H(j) = 1;
        elseif abs(f(j)) >= f1 && abs(f(j)) <= B
            H(j) = 0.5 * (1 + cos( (pi*(abs(f(j)) - f1)) / (2*f_delta) ));
        else
            H(j) = 0;
        end
    end
    
    % Respuesta al impulso h_e(t)
    h = 2 * f0 * (sinc(2*f0*t)) .* (cos(2*pi*f_delta*t) ./ (1 - (4*f_delta*t).^2));
    h(abs(1 - (4*f_delta*t).^2) < 1e-6) = 0; % Aproximación

    % Guardar en matrices para graficar luego
    all_h(i, :) = h;
    all_H(i, :) = H;

    % Gráficos individuales
    subplot(length(alphas), 2, 2*i-1);
    plot(t, h, 'LineWidth', 1.5);
    xlabel('Tiempo (t)');
    ylabel('h_e(t)');
    title(['Respuesta al impulso (\alpha = ', num2str(alpha), ')']);
    grid on;
    
    subplot(length(alphas), 2, 2*i);
    plot(f, H, 'LineWidth', 1.5);
    xlabel('Frecuencia (f)');
    ylabel('H_e(f)');
    title(['Respuesta en frecuencia (\alpha = ', num2str(alpha), ')']);
    grid on;
end

% Figura extra: todas las h_e(t) en un solo gráfico
figure;
hold on;
for i = 1:length(alphas)
    plot(t, all_h(i, :), 'LineWidth', 1.5, 'DisplayName', ['\alpha = ', num2str(alphas(i))]);
end
xlabel('Tiempo (t)');
ylabel('h_e(t)');
title('Todas las respuestas al impulso');
legend show;
grid on;
hold off;

% Figura extra: todas las H_e(f) en un solo gráfico
figure;
hold on;
for i = 1:length(alphas)
    plot(f, all_H(i, :), 'LineWidth', 1.5, 'DisplayName', ['\alpha = ', num2str(alphas(i))]);
end
xlabel('Frecuencia (f)');
ylabel('H_e(f)');
title('Todas las respuestas en frecuencia');
legend show;
grid on;
hold off;
