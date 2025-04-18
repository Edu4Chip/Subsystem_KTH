% Parameters
N = 16; % Number of points
DATA_TYPE = 'fixed'; % Choose 'float' or 'fixed'
WORD_LENGTH = 16; % Bit width for fixed-point representation
VALUES_PER_LINE = 256 / WORD_LENGTH; % Number of values per line
NUMBER_OF_LINES = N / VALUES_PER_LINE;
fs = 1000; % Sampling frequency in Hz

% Generate input data
t = (0:N-1) / fs;
x = sin(2 * pi * 1 * t) + 0.5 * sin(2 * pi * 2 * t);

% Convert to specified data type
if strcmp(DATA_TYPE, 'fixed')
    FRACTION_LENGTH = WORD_LENGTH / 2;
    x = fi(x, 1, WORD_LENGTH, FRACTION_LENGTH);
end

% Save input data to file
fid = fopen('input_data.txt', 'w');
for i = 1:N
    fprintf(fid, '%f %f\n', real(x(i)), imag(x(i)));
end
fclose(fid);

% Compute FFT
X = fft(double(x));
freqs = (0:N-1) * (fs / N); % Frequency axis

% Save output data to file
fid = fopen('output_data.txt', 'w');
for i = 1:N
    fprintf(fid, '%f, %f\n', real(X(i)), imag(X(i)));
end
fclose(fid);

% Plot results
figure;
plot(freqs(1:N/2), abs(X(1:N/2))); % Plot only positive frequencies
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('FFT of Input Signal');
grid on;
