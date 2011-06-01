package com.smp.common.bitmap

//original namespace:
//jp.voq.image.resample

//original copyright notice:

// BitmapResampler is based on Anders Melander's program.
// http://www.delphi32.com/vcl/657/
// Here are copyright notices of his program.
// 
// -----------------------------------------------------------------------------
// Project:	bitmap resampler
// Module:	resample
// Description: Interpolated Bitmap Resampling using filters.
// Version:	01.02
// Release:	3
// Date:	15-MAR-1998
// Target:	Win32, Delphi 2 & 3
// Author(s):	anme: Anders Melander, anders@melander.dk
// Copyright	(c) 1997,98 by Anders Melander
// Formatting:	2 space indent, 8 space tabs, 80 columns.
// -----------------------------------------------------------------------------
// This software is copyrighted as noted above.  It may be freely copied,
// modified, and redistributed, provided that the copyright notice(s) is
// preserved on all copies.
//
// There is no warranty or other guarantee of fitness for this software,
// it is provided solely "as is".  Bug reports or fixes may be sent
// to the author, who may or may not act on them as he desires.
//
// You may not include this software in a program or other software product
// without supplying the source, or without informing the end-user that the
// source is available for no extra charge.
//
// If you modify this software, you should include a notice in the "Revision
// history" section giving the name of the person performing the modification,
// the date of modification, and the reason for such modification.
// -----------------------------------------------------------------------------
// Here's some additional copyrights for you:
//
// From filter.c:
// The authors and the publisher hold no copyright restrictions
// on any of these files; this source code is public domain, and
// is freely available to the entire computer graphics community
// for study, use, and modification.  We do request that the
// comment at the top of each file, identifying the original
// author and its original publication in the book Graphics
// Gems, be retained in all programs that use these files.
//

{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.ConvolutionFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	public class BitmapResampler {
		
		/**
		 * Unsharp filter for sharpen scaled image.
		 */
		private static const UNSHARP_FILTER:ConvolutionFilter = new ConvolutionFilter(
			3,
			3,
			[
				-0.05, -0.05, -0.05,
				-0.05,  1.40, -0.05,
				-0.05, -0.05, -0.05
			],
			1
		);
		
		private static const debug:Boolean = true;
		
		public static const FILTER_LANCZOS3:Lanczos3Filter = new Lanczos3Filter();
		
		/**
		 * Resampling image from source to destination.
		 */
		public function resample(
			src:BitmapData,
			dst:BitmapData,
			unsharp:Boolean = false,
			easyScaling:Number = 0.5
		):void {
			
			var filter:Lanczos3Filter = FILTER_LANCZOS3;
			
			var i:int;
			var j:int;
			var k:int;
			var x:int;
			var r:int;
			var g:int;
			var b:int;
			var pos:int;
			var center:Number;
			var width:Number = 0;
			var fscale:Number = 0;
			var weight:Number = 0;
			var left:int = 0;
			var right:int = 0;
			var n:int = 0;
			var contrib:Array
			var rgb:ResamplingColor = new ResamplingColor();
			var color:ResamplingColor = new ResamplingColor();
			
			var fwidth:Number = filter.fwidth();
			
			var dstWidth:int = dst.width;
			var dstHeight:int = dst.height;
			var srcWidth:int = src.width;
			var srcHeight:int = src.height;
			
			var xscale:Number = (srcWidth == 1) ? dstWidth : (dstWidth-1) / (srcWidth-1);
			var yscale:Number = (srcHeight == 1) ? dstHeight : (dstHeight-1) / (srcHeight-1);
			
			// Easy scaling for performance
			var escale:Number = 1 / easyScaling;
			if (xscale < easyScaling || yscale < easyScaling) {
				var middle:BitmapData = new BitmapData(dstWidth*escale, dstHeight*escale);
				var matrix:Matrix = new Matrix();
				matrix.scale(dstWidth*escale / srcWidth, dstHeight*escale / srcHeight);
				middle.draw(src, matrix);
				
				srcWidth = middle.width;
				srcHeight = middle.height;
				src = middle;
				xscale = (srcWidth == 1) ? dstWidth : (dstWidth-1) / (srcWidth-1);
				yscale = (srcHeight == 1) ? dstHeight : (dstHeight-1) / (srcHeight-1);
			}
			
			var work:BitmapData = new BitmapData(dstWidth, srcHeight);
			var clist:ContributorList;
			var cont:Contributor;
			
			
			// --------------------------------------------
			// Pre-calculate filter contributions for a row
			// -----------------------------------------------
			contrib = new Array(dstWidth);
			for (i = 0; i < dstWidth; i++) {
				contrib[i] = new ContributorList();
			}
			
			// Horizontal sub-sampling
			// Scales from bigger to smaller width
			if (xscale < 1) {
				width = fwidth / xscale;
				fscale = 1 / xscale;
				var length:int = width * 2 + 1;
				
				for (i = 0; i < dstWidth; i++) {
					clist = contrib[i];
					clist.n = 0;
					clist.p = new Array(length);
					for (j = 0; j < length; j++) {
						clist.p[j] = new Contributor();
					}
					center = i / xscale;
					left = int(Math.floor(center - width));
					right = int(Math.ceil(center + width));
					
					for (j = left; j <= right; j++) {
						weight = filter.proceed((center - j) / fscale) / fscale;
						if (weight == 0) {
							continue;
						}
						if (j < 0) {
							n = -j;
						}
						if (j >= srcWidth) {
							n = srcWidth - j + srcWidth - 1;
						} else {
							n = j;
						}
						k = clist.n;
						clist.n++;
						clist.p[k].pixel = n;
						clist.p[k].weight = weight;
					}
				}
				
			} else {
				
		    	// Horizontal super-sampling
    			// Scales from smaller to bigger width
				for (i = 0; i < dstWidth; i++) {
					clist = contrib[i];
					clist.n = 0;
					length = width * 2 + 1;
					clist.p = new Array(length);
					for (j = 0; j < length; j++) {
						clist.p[j] = new Contributor();
					}
					center = i / xscale;
					left = int(Math.floor(center - fwidth));
					right = int(Math.ceil(center + fwidth));
					
					for (j = left; j <= right; j++) {
						
						weight = filter.proceed(center - j);
						
						if (weight == 0) {
							continue;
						}
						
						if (j < 0) {
							n = -j;
						} else if (j >= srcWidth) {
							n = srcWidth - j + srcWidth - 1;
						} else {
							n = j;
						}
						
						k = clist.n;
						clist.n++;
						clist.p[k].pixel = n;
						clist.p[k].weight = weight;
					}
				}
			}
			
			// ----------------------------------------------------
			// Apply filter to sample horizontally from Src to Work
			// ----------------------------------------------------
			var bytes:ByteArray = src.getPixels(new Rectangle(0, 0, src.width, src.height));
			
			for (k = 0; k < srcHeight; k++) {
				
				for (i = 0; i < dstWidth; i++) {
					
					r = 0;
					g = 0;
					b = 0;
					
					clist = contrib[i];
					
					n = clist.n;
					
					for (j = 0; j < n; j++) {
						cont = clist.p[j];
						x = cont.pixel;
						if (x < 0) x = 0;
						pos = (x + k * src.width) * 4 + 1;
						weight = cont.weight;
						if (weight == 0) {
							continue;
						}
						r += weight * bytes[pos];
						g += weight * bytes[pos+1];
						b += weight * bytes[pos+2];
					}
					
					color.r = Math.max(0, Math.min(255, Math.round(r)));
					color.g = Math.max(0,Math.min(255, Math.round(g)));
					color.b = Math.max(0, Math.min(255, Math.round(b)));
					 
					work.setPixel(i, k, color.rgb);
				}
			}
			
			// -----------------------------------------------
			// Pre-calculate filter contributions for a column
			// -----------------------------------------------
			contrib = new Array(dstHeight);
			for (i = 0; i < dstHeight; i++) {
				contrib[i] = new ContributorList();
			}
			
			if (yscale < 1) {
				
				width = fwidth / yscale;
				fscale = 1 / yscale;
				
				for (i = 0; i < dstHeight; i++) {
					clist = contrib[i];
					clist.n = 0;
					clist.p = new Array(int(width * 2 + 1));
					for (j = 0; j < clist.p.length; j++) {
						clist.p[j] = new Contributor();
					}
					
					center = i / yscale;
					left = Math.floor(center - width);
					right = Math.ceil(center + width);
					
					for (j = left; j <= right; j++) {
						weight = filter.proceed((center - j) / fscale) / fscale;
						if (weight == 0) {
							continue;
						}
						if (j < 0) {
							n = -j;
						} else if (j >= srcHeight) {
							n = srcHeight - j + srcHeight - 1;
						}  else {
							n = j;
						}
						k = clist.n;
						clist.n++;
						clist.p[k].pixel = n;
						clist.p[k].weight = weight;
					}
				}
				
			} else {
				
				// Vertical super-sampling
				// Scales from smaller to bigger height
				for (i = 0; i < dstHeight; i++) {
					clist = contrib[i];
					clist.p = new Array(int(fwidth * 2 + 1));
					center = i / yscale;
					left = Math.floor(center - fwidth);
					right = Math.ceil(center + fwidth);
					for (j = left; j <= right; j++) {
						weight = filter.proceed(center - j);
						if (weight == 0) {
							continue;
						}
						if (j < 0) {
							n = -j;
						} else if (j >= srcHeight) {
							n = srcHeight - j + srcHeight - 1;
						} else {
							n = j;
						}
						k = clist.n;
						clist.n++;
						clist.p[k].pixel = n;
						clist.p[k].weight = weight;
					}
				}
			}
			
			// --------------------------------------------------
			// Apply filter to sample vertically from Work to Dst
			// --------------------------------------------------
			bytes = work.getPixels(new Rectangle(0, 0, work.width, work.height));
			for (k = 0; k < dstWidth; k++) {
				for (i = 0; i < dstHeight; i++) {
					
					rgb.r = 0;
					rgb.g = 0;
					rgb.b = 0;
					
					clist = contrib[i];
					
					for (j = 0; j < clist.n; j++) {
						cont = clist.p[j];
						x = cont.pixel;
						if (x < 0) x = 0;
						pos = (k + x * work.width) * 4 + 1;
						weight = cont.weight;
						if (weight == 0) continue;
						rgb.r += bytes[pos] * weight;
						rgb.g += bytes[pos+1] * weight;
						rgb.b += bytes[pos+2] * weight;
					}
					
					color.r = Math.max(0, Math.min(255, Math.round(rgb.r)));
					color.g = Math.max(0,Math.min(255, Math.round(rgb.g)));
					color.b = Math.max(0, Math.min(255, Math.round(rgb.b)));
					 
					dst.setPixel(k, i, color.rgb);
				}
			}
			
			if (unsharp) {
				// unsharp filter
				var filtered:Bitmap = new Bitmap(dst);
				filtered.filters = [UNSHARP_FILTER];
				dst.draw(filtered);
			}
			
		}
	}
}

internal class ResamplingColor {
	internal var r:int;
	internal var g:int;
	internal var b:int;
	internal var a:int;
	
	internal function from(color:uint):void {
		a = (color >> 24) & 0xff;
		r = (color >> 16) & 0xff;
		g = (color >> 8) & 0xff;
		b = (color >> 0) & 0xff;
	}
	
	internal function get rgb():uint {
		return (r << 16) | (g << 8) | (b);
	}
	
	internal function get rgba():uint {
		return (a << 24) | (r << 16) | (g << 8) | (b);
	}
}

internal class Contributor {
	internal var pixel:int;
	internal var weight:Number;
}

internal class ContributorList {
	internal var n:int;
	internal var p:Array;
}
