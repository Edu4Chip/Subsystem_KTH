/*
 * Uncomment the following macro to enable debug mode.
 */
#define DEBUG

/*
 * Uncomment the following macro to generate human readable output file for
 * debugging. It is mandatory to enable define DATA_TYPE if DEBUG is enabled.
 */
#define DATA_TYPE int16_t

#include "Drra.hpp"
#include "IO.hpp"
#include "Util.hpp"
#include <cstdlib>

#define N 16

int main() {
  IO __input_buffer__;
  IO __output_buffer__;

  // Initialize the input buffer
  init(__input_buffer__);
  store_data("mem/sram_image_in.bin", __input_buffer__);

  // if DEBUG is enabled, generate human readable (almost) output file
#ifdef DEBUG
  bin_to_hex_file("mem/sram_image_in.bin", "mem/sram_image_in.hex");
  bin_to_num_file<DATA_TYPE>("mem/sram_image_in.bin", "mem/sram_image_in.txt");
#endif

  // Run the model 0
  reset(__output_buffer__);
  model_l0(__input_buffer__, __output_buffer__);
  store_data("mem/sram_image_m0.bin", __output_buffer__);

  return 0;
}

/*
 * Generate the input SRAM image.
 */
void init(IO &input_buffer) {
  vector<int32_t> v(N + N / 2); // Data and Twiddle factors

  ifstream datafile("../fft_data/input_data.txt"); // Open the file
  if (!datafile) {
    std::cerr << "Error opening file!" << std::endl;
    return;
  }

  float real, imag;
  for (int i = 0; i < N; i++) {
    if (!(datafile >> real >> imag)) {
      std::cerr << "Error reading file!" << std::endl;
      return;
    }
    int16_t real_fixed =
        static_cast<int16_t>(real * 256); // Convert to fixed-point
    int16_t imag_fixed = static_cast<int16_t>(imag * 256);
    v[i] = (static_cast<int32_t>(imag_fixed) & 0xFFFF) |
           (static_cast<int32_t>(real_fixed) << 16);
  }
  datafile.close();

  ifstream twiddlefile("../fft_data/twiddle_factors.txt"); // Open the file
  if (!twiddlefile) {
    std::cerr << "Error opening file!" << std::endl;
    return;
  }

  for (int i = 0; i < N / 2; i++) {
    if (!(twiddlefile >> real >> imag)) {
      std::cerr << "Error reading file!" << std::endl;
      return;
    }
    int16_t real_fixed =
        static_cast<int16_t>(real * 256); // Convert to fixed-point
    int16_t imag_fixed = static_cast<int16_t>(imag * 256);
    v[i + N] = (static_cast<int32_t>(imag_fixed) & 0xFFFF) |
               (static_cast<int32_t>(real_fixed) << 16);
  }
  twiddlefile.close();

  // Write the processed numbers to the input buffer
  input_buffer.write<int32_t>(0, 3, v);
}

/*
 * Define the reference algorithm model. It will generate the reference output
 * SRAM image. You can use free C++ programs.
 */
void model_l0(IO &input_buffer, IO &output_buffer) {
  // Read output file from MATLAB and write to the output buffer for comparison
  vector<int32_t> X(N); // Data and Twiddle factors

  ifstream outfile("../fft_data/output_data.txt"); // Open the file
  if (!outfile) {
    std::cerr << "Error opening file!" << std::endl;
    return;
  }

  float real, imag;
  for (int i = 0; i < N; i++) {
    if (!(outfile >> real >> imag)) {
      std::cerr << "Error reading file!" << std::endl;
      return;
    }
    int16_t real_fixed =
        static_cast<int16_t>(real * 256); // Convert to fixed-point
    int16_t imag_fixed = static_cast<int16_t>(imag * 256);
    X[i] = (static_cast<int32_t>(imag_fixed) & 0xFFFF) |
           (static_cast<int32_t>(real_fixed) << 16);
  }
  outfile.close();

  output_buffer.write<int32_t>(0, 2, X);
}
