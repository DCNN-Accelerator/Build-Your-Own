#ifndef fp_mults_h
#define fp_mults_h

#include "ap_fixed.h"
#include "stdint.h"
// Refactored all datatypes to be signed integers

/*
typedef ap_fixed  <8,8,  AP_RND, AP_SAT> kernel_t;
typedef ap_ufixed <8,8, AP_RND>  pixel_t;
typedef ap_fixed  <16,16, AP_RND,AP_SAT>  fm_t;
typedef ap_fixed  <16,16, AP_RND, AP_SAT> mult_t;
typedef ap_fixed  <32,32, AP_RND, AP_SAT> acc_t;
*/


typedef int8_t kernel_t;
typedef uint8_t pixel_t;

typedef int16_t fm_t;
typedef int16_t mult_t;

typedef int16_t acc_t;


void fp_test (kernel_t test_kernel, pixel_t test_pixel, fm_t &output_val);


void fp_sop
(

		kernel_t kernel_patch_0,
		kernel_t kernel_patch_1,
		kernel_t kernel_patch_2,
		kernel_t kernel_patch_3,
		kernel_t kernel_patch_4,
		kernel_t kernel_patch_5,
		kernel_t kernel_patch_6,
		kernel_t kernel_patch_7,
		kernel_t kernel_patch_8,
		kernel_t kernel_patch_9,
		kernel_t kernel_patch_10,
		kernel_t kernel_patch_11,
		kernel_t kernel_patch_12,
		kernel_t kernel_patch_13,
		kernel_t kernel_patch_14,
		kernel_t kernel_patch_15,
		kernel_t kernel_patch_16,
		kernel_t kernel_patch_17,
		kernel_t kernel_patch_18,
		kernel_t kernel_patch_19,
		kernel_t kernel_patch_20,
		kernel_t kernel_patch_21,
		kernel_t kernel_patch_22,
		kernel_t kernel_patch_23,
		kernel_t kernel_patch_24,
		kernel_t kernel_patch_25,
		kernel_t kernel_patch_26,
		kernel_t kernel_patch_27,
		kernel_t kernel_patch_28,
		kernel_t kernel_patch_29,
		kernel_t kernel_patch_30,
		kernel_t kernel_patch_31,
		kernel_t kernel_patch_32,
		kernel_t kernel_patch_33,
		kernel_t kernel_patch_34,
		kernel_t kernel_patch_35,
		kernel_t kernel_patch_36,
		kernel_t kernel_patch_37,
		kernel_t kernel_patch_38,
		kernel_t kernel_patch_39,
		kernel_t kernel_patch_40,
		kernel_t kernel_patch_41,
		kernel_t kernel_patch_42,
		kernel_t kernel_patch_43,
		kernel_t kernel_patch_44,
		kernel_t kernel_patch_45,
		kernel_t kernel_patch_46,
		kernel_t kernel_patch_47,
		kernel_t kernel_patch_48,

		pixel_t pixel_window_0,
		pixel_t pixel_window_1,
		pixel_t pixel_window_2,
		pixel_t pixel_window_3,
		pixel_t pixel_window_4,
		pixel_t pixel_window_5,
		pixel_t pixel_window_6,
		pixel_t pixel_window_7,
		pixel_t pixel_window_8,
		pixel_t pixel_window_9,
		pixel_t pixel_window_10,
		pixel_t pixel_window_11,
		pixel_t pixel_window_12,
		pixel_t pixel_window_13,
		pixel_t pixel_window_14,
		pixel_t pixel_window_15,
		pixel_t pixel_window_16,
		pixel_t pixel_window_17,
		pixel_t pixel_window_18,
		pixel_t pixel_window_19,
		pixel_t pixel_window_20,
		pixel_t pixel_window_21,
		pixel_t pixel_window_22,
		pixel_t pixel_window_23,
		pixel_t pixel_window_24,
		pixel_t pixel_window_25,
		pixel_t pixel_window_26,
		pixel_t pixel_window_27,
		pixel_t pixel_window_28,
		pixel_t pixel_window_29,
		pixel_t pixel_window_30,
		pixel_t pixel_window_31,
		pixel_t pixel_window_32,
		pixel_t pixel_window_33,
		pixel_t pixel_window_34,
		pixel_t pixel_window_35,
		pixel_t pixel_window_36,
		pixel_t pixel_window_37,
		pixel_t pixel_window_38,
		pixel_t pixel_window_39,
		pixel_t pixel_window_40,
		pixel_t pixel_window_41,
		pixel_t pixel_window_42,
		pixel_t pixel_window_43,
		pixel_t pixel_window_44,
		pixel_t pixel_window_45,
		pixel_t pixel_window_46,
		pixel_t pixel_window_47,
		pixel_t pixel_window_48,



		fm_t &out_val
		);



#endif
