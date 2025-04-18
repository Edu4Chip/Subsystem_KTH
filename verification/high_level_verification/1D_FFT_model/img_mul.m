% MATLAB script to multiply two imaginary numbers

% Define two imaginary numbers
a = -0.8125+0.55078125i;
b = 0.70703125-0.70703125i;

% Extract real and imaginary parts (for clarity)
real_a = real(a);
imag_a = imag(a);
real_b = real(b);
imag_b = imag(b);

% Convert inputs to fixed-point hexadecimal format (8 bits integer, 8 bits fractional)
scale_factor = 2^8;
real_a_hex = dec2hex(typecast(int16(real_a * scale_factor), 'uint16'), 4);
imag_a_hex = dec2hex(typecast(int16(imag_a * scale_factor), 'uint16'), 4);
real_b_hex = dec2hex(typecast(int16(real_b * scale_factor), 'uint16'), 4);
imag_b_hex = dec2hex(typecast(int16(imag_b * scale_factor), 'uint16'), 4);

% Intermediate calculations
ac = real_a * real_b;
bd = imag_a * imag_b;
ad = real_a * imag_b;
bc = imag_a * real_b;
real_part = ac - bd;
imag_part = ad + bc;

% Convert intermediate results to fixed-point hexadecimal format
ac_hex = dec2hex(typecast(int16(ac * scale_factor), 'uint16'), 4);
bd_hex = dec2hex(typecast(int16(bd * scale_factor), 'uint16'), 4);
ad_hex = dec2hex(typecast(int16(ad * scale_factor), 'uint16'), 4);
bc_hex = dec2hex(typecast(int16(bc * scale_factor), 'uint16'), 4);
real_part_hex = dec2hex(typecast(int16(real_part * scale_factor), 'uint16'), 4);
imag_part_hex = dec2hex(typecast(int16(imag_part * scale_factor), 'uint16'), 4);

% Multiply the imaginary numbers
result = a * b;

% Convert final result to fixed-point hexadecimal format
real_hex = dec2hex(typecast(int16(real_part * scale_factor), 'uint16'), 4);
imag_hex = dec2hex(typecast(int16(imag_part * scale_factor), 'uint16'), 4);

% Display intermediate results in hexadecimal format
disp(['ac = ', real_a_hex, ' * ', real_b_hex, ' = ', ac_hex])
disp(['bd = ', imag_a_hex, ' * ', imag_b_hex, ' = ', bd_hex])
disp(['ad = ', real_a_hex, ' * ', imag_b_hex, ' = ', ad_hex])
disp(['bc = ', imag_a_hex, ' * ', real_b_hex, ' = ', bc_hex])
disp(['Real part calculation: ', ac_hex, ' - ', bd_hex, ' = ', real_part_hex])
disp(['Imaginary part calculation: ', ad_hex, ' + ', bc_hex, ' = ', imag_part_hex])

% Display the final result in hexadecimal format
disp(['The result in hexadecimal (16-bit fixed-point): ', real_hex, ' + ', imag_hex, 'i'])