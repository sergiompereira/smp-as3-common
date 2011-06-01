package com.smp.common.bitmap
{

	//original namespace:
	//jp.voq.image.resample


	public class Lanczos3Filter
	{
		public function Lanczos3Filter() {
			super();
		}
		
		public function fwidth():Number {
			return 3.0;
		}
		
		public function proceed(value:Number):Number {
			if (value < 0) {
				value = -value;
			}
			if (value < 3) {
				return sinc(value) * sinc(value / 3);
			} else {
				return 0;
			}
		}
		
		private function sinc(value:Number):Number {
			if (value != 0) {
				value = value * Math.PI;
				return Math.sin(value) / value;
			} else {
				return 1;
			}
		}

	}
}