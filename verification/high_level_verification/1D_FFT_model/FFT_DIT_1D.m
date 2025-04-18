% Parameters
N = 256; % Number of points
DATA_TYPE = 'fixed'; % Choose 'float' or 'fixed'
WORD_LENGTH = 32; % Bit width for fixed-point representation
VALUES_PER_LINE = 256 / WORD_LENGTH; % Number of values per line
NUMBER_OF_LINES = N / VALUES_PER_LINE;
FRACTIONAL_BITS = WORD_LENGTH/4; % Number of fractional bits
fs = 1000; % Sampling frequency in Hz

% Generate input data
t = (0:N-1) / fs;
x = 0.1 * sin(2 * pi * 120 * t) + 0.05 * sin(2 * pi * 300 * t);

% Convert to specified data type
if strcmp(DATA_TYPE, 'fixed')
    x = fi(x, 1, WORD_LENGTH/2, WORD_LENGTH/4);
end

% Save input data to file
fid = fopen('input_data.txt', 'w');
for i = 1:N
    fprintf(fid, '%f %f\n', real(x(i)), imag(x(i)));
end
fclose(fid);

% Compute FFT using DIT-FFT
x = double(x);
X = bitrevorder(x); % Bit-reversal permutation
stages = log2(N);
for s = 1:stages
    m = 2^s;
    half_m = m / 2;
    W_m = exp(-2j * pi / m * (0:half_m-1)); % Twiddle factors
    for k = 1:m:N
        for j = 0:half_m-1
            t = W_m(j+1) * X(k + j + half_m);
            u = X(k + j);

            real_prod = round(real(X(k + j + half_m) * (2^FRACTIONAL_BITS)));
            imag_prod = round(imag(X(k + j + half_m) * (2^FRACTIONAL_BITS)));

            X(k + j) = u + t;
            X(k + j + half_m) = u - t;            
        end
    end
end
freqs = (0:N-1) * (fs / N); % Frequency axis

% Save twiddle factors to file
fid = fopen('twiddle_factors.txt', 'w');
for i = 1:half_m
    Tw = exp(-2j * pi / m * (0:i-1));
    fprintf(fid, '%f %f\n', real(Tw(i)), imag(Tw(i)));
end
for i = 1:half_m
    fprintf(fid, '%f %f\n', real(0), imag(0));
end
fclose(fid);

% Save output data to file
fid = fopen('output_data.txt', 'w');
for i = 1:N
    fprintf(fid, '%f %f\n', real(X(i)), imag(X(i)));
end
fclose(fid);

%%{
% Read FFT data from file
fid = fopen('output_data_rtl.txt', 'r');
file_data = {};  % Initialize output cell array

tline = fgetl(fid);
while ischar(tline)
    tokens = strsplit(strtrim(tline));      % Split line into index and binary string
    binary_string = tokens{2};              % Get the binary part (256 bits)
    
    % Read chunks in reversed order: from the end of the string to the start
    for i = 1:8
        start_idx = 256 - (i * 32) + 1;
        chunk = binary_string(start_idx : start_idx + 31);
        file_data{end+1, 1} = chunk;        % Append each 32-bit chunk as a new row
    end
    
    tline = fgetl(fid);                     % Read next line
end

fclose(fid);


% Convert binary strings to real and imaginary parts
real_parts = zeros(1, N);
imag_parts = zeros(1, N);
for i = 1:N
    real_bin = file_data{i}(1:WORD_LENGTH/2);
    imag_bin = file_data{i}(WORD_LENGTH/2+1:WORD_LENGTH);
    real_parts(i) = double(typecast(uint16(bin2dec(real_bin)), 'int16')) / (2^FRACTIONAL_BITS);
    imag_parts(i) = double(typecast(uint16(bin2dec(imag_bin)), 'int16')) / (2^FRACTIONAL_BITS);
end
X_file = real_parts + 1j * imag_parts;
%}

% Plot results
figure;
subplot(2,1,1);
plot(freqs(1:N/2), abs(X(1:N/2))); % Generated data FFT
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Matlab FFT');
grid on;

%%{
subplot(2,1,2);
plot(freqs(1:N/2), abs(X_file(1:N/2))); % Loaded FFT data
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('DRRA2 FFT');
grid on;
%}