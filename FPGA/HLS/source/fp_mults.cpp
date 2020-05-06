#include "fp_mults.hpp"
#include "iostream"


using namespace std;


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
		)

{

#pragma HLS pipeline II = 1

	mult_t buf_mult [49];
	acc_t acc;


	 buf_mult[0] = pixel_window_0 * kernel_patch_0;
	 buf_mult[1] = pixel_window_1 * kernel_patch_1;
	 buf_mult[2] = pixel_window_2 * kernel_patch_2;
	 buf_mult[3] = pixel_window_3 * kernel_patch_3;
	 buf_mult[4] = pixel_window_4 * kernel_patch_4;
	 buf_mult[5] = pixel_window_5 * kernel_patch_5;
	 buf_mult[6] = pixel_window_6 * kernel_patch_6;
	 buf_mult[7] = pixel_window_7 * kernel_patch_7;
	 buf_mult[8] = pixel_window_8 * kernel_patch_8;
	 buf_mult[9] = pixel_window_9 * kernel_patch_9;

	 buf_mult[10] = pixel_window_10 * kernel_patch_10;
	 buf_mult[11] = pixel_window_11 * kernel_patch_11;
	 buf_mult[12] = pixel_window_12 * kernel_patch_12;
	 buf_mult[13] = pixel_window_13 * kernel_patch_13;
	 buf_mult[14] = pixel_window_14 * kernel_patch_14;
	 buf_mult[15] = pixel_window_15 * kernel_patch_15;
	 buf_mult[16] = pixel_window_16 * kernel_patch_16;
	 buf_mult[17] = pixel_window_17 * kernel_patch_17;
	 buf_mult[18] = pixel_window_18 * kernel_patch_18;
	 buf_mult[19] = pixel_window_19 * kernel_patch_19;

	 buf_mult[20] = pixel_window_20 * kernel_patch_20;
	 buf_mult[21] = pixel_window_21 * kernel_patch_21;
	 buf_mult[22] = pixel_window_22 * kernel_patch_22;
	 buf_mult[23] = pixel_window_23 * kernel_patch_23;
	 buf_mult[24] = pixel_window_24 * kernel_patch_24;
	 buf_mult[25] = pixel_window_25 * kernel_patch_25;
	 buf_mult[26] = pixel_window_26 * kernel_patch_26;
	 buf_mult[27] = pixel_window_27 * kernel_patch_27;
	 buf_mult[28] = pixel_window_28 * kernel_patch_28;
	 buf_mult[29] = pixel_window_29 * kernel_patch_29;

	 buf_mult[30] = pixel_window_30 * kernel_patch_30;
	 buf_mult[31] = pixel_window_31 * kernel_patch_31;
	 buf_mult[32] = pixel_window_32 * kernel_patch_32;
	 buf_mult[33] = pixel_window_33 * kernel_patch_33;
	 buf_mult[34] = pixel_window_34 * kernel_patch_34;
	 buf_mult[35] = pixel_window_35 * kernel_patch_35;
	 buf_mult[36] = pixel_window_36 * kernel_patch_36;
	 buf_mult[37] = pixel_window_37 * kernel_patch_37;
	 buf_mult[38] = pixel_window_38 * kernel_patch_38;
	 buf_mult[39] = pixel_window_39 * kernel_patch_39;

	 buf_mult[40] = pixel_window_40 * kernel_patch_40;
	 buf_mult[41] = pixel_window_41 * kernel_patch_41;
	 buf_mult[42] = pixel_window_42 * kernel_patch_42;
	 buf_mult[43] = pixel_window_43 * kernel_patch_43;
	 buf_mult[44] = pixel_window_44 * kernel_patch_44;
	 buf_mult[45] = pixel_window_45 * kernel_patch_45;
	 buf_mult[46] = pixel_window_46 * kernel_patch_46;
	 buf_mult[47] = pixel_window_47 * kernel_patch_47;
	 buf_mult[48] = pixel_window_48 * kernel_patch_48;


	 acc =   buf_mult[0] +
			 buf_mult[1] +
			 buf_mult[2] +
			 buf_mult[3] +
			 buf_mult[4] +
			 buf_mult[5] +
			 buf_mult[6] +
			 buf_mult[7] +
			 buf_mult[8] +
			 buf_mult[9] +

			 buf_mult[10] +
			 buf_mult[11] +
			 buf_mult[12] +
			 buf_mult[13] +
			 buf_mult[14] +
			 buf_mult[15] +
			 buf_mult[16] +
			 buf_mult[17] +
			 buf_mult[18] +
			 buf_mult[19] +

			 buf_mult[20] +
			 buf_mult[21] +
			 buf_mult[22] +
			 buf_mult[23] +
			 buf_mult[24] +
			 buf_mult[25] +
			 buf_mult[26] +
			 buf_mult[27] +
			 buf_mult[28] +
			 buf_mult[29] +

			 buf_mult[30] +
			 buf_mult[31] +
			 buf_mult[32] +
			 buf_mult[33] +
			 buf_mult[34] +
			 buf_mult[35] +
			 buf_mult[36] +
			 buf_mult[37] +
			 buf_mult[38] +
			 buf_mult[39] +

			 buf_mult[40] +
			 buf_mult[41] +
			 buf_mult[42] +
			 buf_mult[43] +
			 buf_mult[44] +
			 buf_mult[45] +
			 buf_mult[46] +
			 buf_mult[47] +
			 buf_mult[48];

	 out_val = acc;


}
