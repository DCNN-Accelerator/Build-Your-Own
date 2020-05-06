#include "fp_mults.hpp"
#include "iostream"
#include "stdlib.h"
#include "time.h"

#include "fstream"
#include <unistd.h>
#include <direct.h>

#include "cstdlib"
#include "vector"
#include "bits/stdc++.h"




std::vector<int8_t> generate_kernel(int size, int seed)
{

	std::vector<int8_t> kernel_arr;

	/*Create randomized array of floats between [-1 1) in a [Size x 1] array (should be one-dimensional)
	 */

	srand(seed);
	std::cout << "In kernel generation.." << "\n";

	for (int i = 0; i < size; i++)
	{
		//double c = (double) rand() / (RAND_MAX + 1) * (1 - (-1)) + -1;
		int8_t c = rand() % 127;
		kernel_arr.push_back(c);
	}

	return kernel_arr;
}

std::vector<int> generate_pix_array(int size, int seed)
{
	std::vector<int> pix_array;


	/*Create randomized array of integers between [0,255] in a [Size x 1] array (should be one-dimensional)
	 */

	srand(seed); //seeding the random number
	std::cout << "In pixel generation.." << "\n";

	for (int i = 0; i < size; i ++)
	{
		pix_array.push_back ( rand() % 255 );
	}

	return pix_array;
}

int16_t dot_prod_benchmark(const std::vector<int8_t> kernel, const std::vector<int> pixels, int size)
{

	int16_t buf = 0;
	double output = 0;

	for (int i = 0; i < size; i++)
	{
		output = output + (kernel[i] * pixels[i]);
	}


	/* implement rounding */
//	buf = static_cast<int16_t> (round(output));
	return output;

}



void write_to_csv (const double* kernel, const int* pixel, const kernel_t* fp_kernel, const pixel_t* fp_pixel, int size)
{
	/* Write Kernel and Pixel values to CSV for MATLAB verification */

	std::cout << "Writing to CSV... " << "\n";

	std::ofstream kernel_csv;
	std::ofstream pixel_csv;

	std::ofstream kernel_fp_csv;
	std::ofstream pixel_fp_csv;


	char char_buff[FILENAME_MAX];
	_getcwd(char_buff, FILENAME_MAX);

	std::string cwd(char_buff);

	std::cout << cwd << "\n";


	kernel_csv.open("kernel.csv");
	pixel_csv.open("pixel.csv");

	kernel_fp_csv.open("kernel_fp.csv");
	pixel_fp_csv.open("pixel_fp.csv");


	for (int i = 0; i < size; i++)
	{
		kernel_csv << kernel[i] << "," << "\n";
		pixel_csv <<  pixel[i] <<  "," << "\n";

		kernel_fp_csv << fp_kernel[i] << "," << "\n";
		pixel_fp_csv <<  fp_pixel[i]  << "," << "\n";
	}

	kernel_csv.close();
	pixel_csv.close();

	kernel_fp_csv.close();
	pixel_fp_csv.close();

}


void run_mults_test()
{

	/*
	 To test the UUT:
	 - Create Kernel Patch and Pixel Patch arrays
	 - Compute dot product using float precision
	 - Call UUT with same Kernel Patch and Pixel Patch as args (TODO: may need to cast to FP type)
	 - Define a tolerance measure and compare double precision value and fixed point output
	 - If error > tolerance -> test fail;  else: test pass!
	 */


// Generate Benchmark Kernel and Pixels with C++ Double Precision and compute SOP

	int test_size = 49;
	int seed = time(NULL);

	std::vector<double> errors;


		for (int i = 0; i < 100; i++) {


			std::vector<int8_t> kernel_patch = generate_kernel(test_size,seed);
			std::vector<int>   pixel_array   = generate_pix_array(test_size,seed);
			int16_t test_output = dot_prod_benchmark(kernel_patch, pixel_array, test_size);
			std::cout << "Test Output Value (Benchmark) : " << test_output << "\n" ;

		// Cast Double Kernel and Pixel values to FP precision types

			std::vector<kernel_t>  fp_kernel;
			std::vector<pixel_t>   fp_pixels;

			for (int i = 0; i < test_size; i++ )
			{
				kernel_t buf_k  = kernel_patch.at(i);
				pixel_t  buf_p  = pixel_array.at(i);

				fp_kernel.push_back(buf_k);
				fp_pixels.push_back(buf_p);
			}

		// Write to CSV for MATLAB debugging, if needed
		//	write_to_csv(kernel_patch, pixel_array, fp_kernel, fp_pixels, test_size);
		//Call UUT for Fixed Point SOP Computation

			fm_t fp_test_out;
			fp_sop
			(
					fp_kernel[0],
					fp_kernel[1],
					fp_kernel[2],
					fp_kernel[3],
					fp_kernel[4],
					fp_kernel[5],
					fp_kernel[6],
					fp_kernel[7],
					fp_kernel[8],
					fp_kernel[9],
					fp_kernel[10],
					fp_kernel[11],
					fp_kernel[12],
					fp_kernel[13],
					fp_kernel[14],
					fp_kernel[15],
					fp_kernel[16],
					fp_kernel[17],
					fp_kernel[18],
					fp_kernel[19],
					fp_kernel[20],
					fp_kernel[21],
					fp_kernel[22],
					fp_kernel[23],
					fp_kernel[24],
					fp_kernel[25],
					fp_kernel[26],
					fp_kernel[27],
					fp_kernel[28],
					fp_kernel[29],
					fp_kernel[30],
					fp_kernel[31],
					fp_kernel[32],
					fp_kernel[33],
					fp_kernel[34],
					fp_kernel[35],
					fp_kernel[36],
					fp_kernel[37],
					fp_kernel[38],
					fp_kernel[39],
					fp_kernel[40],
					fp_kernel[41],
					fp_kernel[42],
					fp_kernel[43],
					fp_kernel[44],
					fp_kernel[45],
					fp_kernel[46],
					fp_kernel[47],
					fp_kernel[48],

					fp_pixels[0],
					fp_pixels[1],
					fp_pixels[2],
					fp_pixels[3],
					fp_pixels[4],
					fp_pixels[5],
					fp_pixels[6],
					fp_pixels[7],
					fp_pixels[8],
					fp_pixels[9],
					fp_pixels[10],
					fp_pixels[11],
					fp_pixels[12],
					fp_pixels[13],
					fp_pixels[14],
					fp_pixels[15],
					fp_pixels[16],
					fp_pixels[17],
					fp_pixels[18],
					fp_pixels[19],
					fp_pixels[20],
					fp_pixels[21],
					fp_pixels[22],
					fp_pixels[23],
					fp_pixels[24],
					fp_pixels[25],
					fp_pixels[26],
					fp_pixels[27],
					fp_pixels[28],
					fp_pixels[29],
					fp_pixels[30],
					fp_pixels[31],
					fp_pixels[32],
					fp_pixels[33],
					fp_pixels[34],
					fp_pixels[35],
					fp_pixels[36],
					fp_pixels[37],
					fp_pixels[38],
					fp_pixels[39],
					fp_pixels[40],
					fp_pixels[41],
					fp_pixels[42],
					fp_pixels[43],
					fp_pixels[44],
					fp_pixels[45],
					fp_pixels[46],
					fp_pixels[47],
					fp_pixels[48],

					fp_test_out
			);

			std::cout << "Fixed Point SOP Value: " << fp_test_out << "\n";

		// Compare against Benchmark SOP Value
		//	double fm_error = abs(fp_test_out.to_double() - test_output);
			double fm_error = abs(fp_test_out - test_output);
			errors.push_back(fm_error);
			seed++;
		}

	// Calculate the error over all the runs
	double mean_error = accumulate(errors.begin(),errors.end(), 0)/100;

	std::cout << "average error: " << mean_error << "\n";


}



void run_fp_single_test()
{

	int pre_quant_pixel = 255;
	double pre_quant_kernel = 0.99;



	pixel_t test_pixel = pre_quant_pixel;
	kernel_t test_kernel = pre_quant_kernel;

	fm_t test_output;

	std::cout << "Prequantized pixel value" << test_pixel << "\n";
	std::cout << "prequant kernel val: " << test_kernel << "\n";




}

int main()
{

	run_mults_test();

}
