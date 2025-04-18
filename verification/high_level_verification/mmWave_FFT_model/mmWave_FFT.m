clear; clc; close all;

%% Radar Parameters
c = 3e8;            % Speed of light (m/s)
fc = 76e9;          % Operating frequency (Hz)
B = 1e9;            % Bandwidth (Hz)
T_chirp = 50e-6;    % Chirp duration (s)
S = B / T_chirp;    % Chirp slope (Hz/s)
lambda = c / fc;    % Wavelength
Nr = 256;           % Number of range samples (Range FFT)
Nd = 128;           % Number of chirps (Doppler FFT)
ts = linspace(0, T_chirp, Nr)'; % Range axis

%% Target Parameters
R1 = 16; % Initial range of target 1 (m)
V1 = 10; % Velocity of target 1 (m/s)
R2 = 7.5;
V2 = -5;

%% Signal Simulation
Rx_signal1 = zeros(Nr, Nd); % Preallocate received signal matrix
Rx_signal2 = zeros(Nr, Nd);

for chirp = 1:Nd
    R_t1 = R1 + V1 * (chirp * T_chirp); % Range update per chirp
    R_t2 = R2 + V2 * (chirp * T_chirp);
    tau1 = 2 * R_t1 / c; % Time delay
    tau2 = 2 * R_t2 / c;
    % Received signal with time delay and Doppler shift
    Rx_signal1(:, chirp) = exp(1j * 2 * pi * (fc * (ts - tau1) + 0.5 * S * (ts - tau1).^2));
    Rx_signal2(:, chirp) = exp(1j * 2 * pi * (fc * (ts - tau2) + 0.5 * S * (ts - tau2).^2));
end

%% Beat Signal Generation
Rx_signal = Rx_signal1 + Rx_signal2;
Tx_signal = exp(1j * 2 * pi * (fc * ts + 0.5 * S * ts.^2));
beat_signal = Tx_signal .* conj(Rx_signal); % IF signal

% plot and save beatsignal
%figure;
%plot(real(beat_signal(:,1))); % Plot the real part of the beat signal for the first chirp
%title('Beat Signal (First Chirp)');
%xlabel('Sample Index');
%ylabel('Amplitude');
%grid on;

% save('IF_signal', 'beat_signal');
writematrix(beat_signal,"beat_signal.txt");
 
%% Range FFT
range_fft = fft(beat_signal, Nr, 1);
range_fft_plot = abs(range_fft(1:Nr/2)); % Single-sided spectrum
 
%% Doppler FFT
doppler_fft = fftshift(fft(range_fft, Nd, 2), 2);
doppler_fft = abs(doppler_fft);
% Doppler Frequency Axis
delta_f_d = 1 / T_chirp;  % Doppler frequency resolution
f_d = linspace(-delta_f_d/2, delta_f_d/2, Nd);
% Velocity Calculation
v = f_d * lambda / 2;

%% Plot Results
figure;
subplot(2,1,1);
max_range = (c * Nr) / (4 * B); % Max range
range_axis = linspace(0, max_range, Nr/2); % Range axis (m)
plot(range_axis, range_fft_plot);
title('Range Spectrum'); xlabel('Range (m)'); ylabel('Amplitude');

subplot(2,1,2);
imagesc(v, range_axis .* 2, 10*log10(doppler_fft));
colorbar;
title('Range-Doppler Map'); xlabel('Velocity (m/s)'); ylabel('Range (m)');