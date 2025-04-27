% Parámetros generales
Nbits = 1e4;            % Número de bits
sps = 8;                % Muestras por símbolo (frecuencia de muestreo alta) 
t_bit = 1;              % Duración de cada bit (en segundos )
Fs = sps / t_bit;       % Frecuencia de muestreo **

alphas = [0, 0.25, 0.75, 1]; % Valores de roll-off

% Bits aleatorios
bits = randi([0 1], 1, Nbits);

% Codificación NRZ-L: Señal con 1 y -1 que se crea mediante 1 -> +1, 0 -> -1
nrz = 2*bits - 1;

% Upsamplear (interpolar) la señal
tx_signal = upsample(nrz, sps);  % Inserta sps ceros entre símbolos **

% Tiempo para el pulso coseno alzado
span = 6;  % Span de símbolo del filtro (cuántos símbolos dura)
t = linspace(-span/2, span/2, span*Fs+1);  % Simétrico centrado en cero

% Loop para cada valor de alpha
for i = 1:length(alphas)
    alpha = alphas(i);
    
    % Construir el pulso coseno alzado
    h = zeros(size(t));
    for k = 1:length(t)
        if t(k) == 0
            h(k) = 1;
        elseif abs(t(k)) == 1/(2*alpha)
            h(k) = (pi/4) * sinc(1/(2*alpha));
        else
            h(k) = sinc(t(k)) .* cos(pi*alpha*t(k)) ./ (1 - (2*alpha*t(k))^2);
        end
    end
    
    % Normalizar energía del filtro
    h = h / sqrt(sum(h.^2));
    
    % Convolución para aplicar el shaping **
    tx_filtered = conv(tx_signal, h, 'same'); 
    
    figure;
    subplot(1,1,1);
    plot(tx_filtered); 
    title(['Señal filtrada (\alpha = ', num2str(alpha), ')']);
    xlabel('Muestras');
    ylabel('Amplitud');
    grid on;
    

    eyediagram(tx_filtered, 2*Fs); % 2 símbolos para ver el cruce
    title(['Diagrama de ojo sin Ruido gaussiano para convolucion con (\alpha = ', num2str(alpha),')']);

    % Agregar ruido AWGN
    snr_dB = 20; % Relación señal a ruido 
    rx_signal = awgn(tx_filtered, snr_dB, 'measured');

    % Diagrama de ojo
    eyediagram(rx_signal, 2*sps); % 2 símbolos para ver el cruce
    title(['Diagrama de ojo para convolucion con (\alpha = ', num2str(alpha),')']);
end
