package com.smp.common.display{

	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.display.GradientType;

	
	public class ShapeUtils  {

		public static function createRectangle(width:Number, height:Number, color:Number = 0xffffff, alpha:Number = 1, posx:Number = 0, posy:Number = 0, borderThik:Number = undefined, borderColor:Number = undefined):Shape {
			
			var shape:Shape = new Shape();
			
			with (shape.graphics) {
				lineStyle(borderThik, borderColor);
				beginFill(color,alpha);
				drawRect(posx,posy,width, height);
				endFill();
			}
			
			return shape;

		}
		
		/**
		 * 
		 * @param	width
		 * @param	height
		 * @param	color : the colors that the constitute the gradient
		 * @param	alphaRatio : the transparencies for each color in the color Array (must match the same number of elements)
		 * @param	gradientRatio : the position within the gradient box (from 0 to 255) where each color (set in the color Array) is at its most pure state.
		 * 			(must match the same number of elements of the color Array)
		 * @param	gradientDirection: defaults to horizontal (angle 0). For a vertical option, set to Math.PI/2. Diagonals: multiples of Math.PI/4
		 * @param	posx
		 * @param	posy
		 * @param	borderThik
		 * @param	borderColor
		 * @return
		 */
		public static function createGradientRectangle(width:Number, height:Number, colors:Array = null, alphaRatio:Array = null, gradientRatio:Array = null, gradientDirection:Number = 0, posx:Number = 0, posy:Number = 0, borderThik:Number = undefined, borderColor:Number = undefined):Shape {
			var shape:Shape = new Shape();
			
			if (colors == null) {
				colors = [0xffffff, 0xffffff];
			}
			
			if (alphaRatio == null) {
				alphaRatio = [1, 0];
			}
			if (gradientRatio == null) {
				gradientRatio = [0, 255];
			}
			
			var matrix:Matrix;
			with (shape.graphics) {
				lineStyle(borderThik, borderColor);
				matrix  = new Matrix();
				matrix.createGradientBox(width, height, gradientDirection,0,0);
				beginGradientFill(GradientType.LINEAR, colors, alphaRatio, gradientRatio, matrix);
				drawRect(0,0,width, height);
				endFill();
			}
			
			shape.x = posx;
			shape.y = posy;
			
			return shape;
		}
		
		
		public static function createCircle(radius:Number, color:uint = 0xffffff, alpha:Number = 1, posx:Number = 0, posy:Number = 0, borderThik:Number = undefined, borderColor:Number = undefined):Shape {
			
			var shape:Shape = new Shape();
			
			with (shape.graphics) {
				lineStyle(borderThik, borderColor);
				beginFill(color,alpha);
				drawCircle(posx,posy, radius);
				endFill();
			}
			
			return shape;
		}
		
		public static function createGradientCircle(radius:Number, colors:Array = null, alphaRatio:Array = null, gradientRatio:Array = null, gradientDirection:Number = 0, posx:Number = 0, posy:Number = 0, borderThik:Number = undefined, borderColor:Number = undefined):Shape {
			
			var shape:Shape = new Shape();
			
			if (colors == null) {
				colors = [0xffffff, 0xffffff];
			}
			
			if (alphaRatio == null) {
				alphaRatio = [1, 0];
			}
			if (gradientRatio == null) {
				gradientRatio = [0, 255];
			}
			
			var matrix:Matrix;
			with (shape.graphics) {
				lineStyle(borderThik, borderColor);
				matrix  = new Matrix();
				matrix.createGradientBox(radius, radius, gradientDirection,0,0);
				beginGradientFill(GradientType.RADIAL, colors, alphaRatio, gradientRatio, matrix);
				drawCircle(posx,posy, radius);
				endFill();
			}
			
			return shape;
		}
		
		public static function quickRect(bg:uint,w:Number,h:Number):Shape{
			var r:Shape = new Shape();
			r.graphics.beginFill(bg);
			r.graphics.drawRect(0,0,w,h);
			r.graphics.endFill();
			return r;
			
		}
		public static function quickTri(bg:int,len:Number):Shape{
			
			var p:Number= Math.sqrt((Math.pow(len,2))-Math.pow(len/2,2));
			var t:Shape = new Shape();
			t.graphics.beginFill(bg);
			//t.graphics.lineTo(0,0);
			t.graphics.lineTo(len,0);
			t.graphics.lineTo(len/2,p);
			t.graphics.lineTo(0,0);
			t.graphics.endFill();
			return t;
			
		}
		public static function quickCirc(color:uint,radius:Number):Shape{
			var c:Shape = new Shape();
			c.graphics.beginFill(color);
			c.graphics.drawCircle(0,0,radius);
			c.graphics.endFill();
			return c;
		}
		
		/**
		 * 
		 * @param	sx
		 * @param	sy
		 * @param	outerRadius
		 * @param	innerRadius
		 * @param	startAngle			:Degrees, measured from the positive X axis in clockwise direction. Accepted 0 to 360.
		 * @param	endAngle			:Degrees, measured from the positive X axis in clockwise direction. Accepted 0 to 360.
		 * @param	fillColor
		 * @param	fillAlpha
		 * @param	lineWidth
		 * @param	lineColor
		 * @param	lineAlpha
		 * @return
		 */
		public static function createWedge(sx:Number, sy:Number, outerRadius:Number, innerRadius:Number = 0, startAngle:Number = 0, endAngle:Number = 360, fillColor:Number = 0x999999, fillAlpha:Number = 1, lineWidth:Number = 0, lineColor:Number = 0x000000, lineAlpha:Number = 1, endOuterRadius:Number = 0, endInnerRadius:Number = 0):Shape 
		{
				var shape:Shape = new Shape();
				var segAngle:Number;
				var angle:Number;
				var angleMid:Number;
				var numOfSegs:Number;
				var outerRadiusInc:Number = 0;
				var innerRadiusInc:Number = 0;
				var ax:Number;
				var ay:Number;
				var bx:Number;
				var by:Number;
				var cx:Number;
				var cy:Number;
				
				shape.graphics.beginFill(fillColor, fillAlpha);
				if(lineWidth>0){
					shape.graphics.lineStyle(lineWidth, lineColor, lineAlpha);
				}else {
					shape.graphics.lineStyle();
				}
				
				
				// No need to draw more than 360
				if (Math.abs(endAngle) > 360) 
				{
						endAngle = 360;
				}
				
				numOfSegs = Math.ceil(Math.abs(endAngle-startAngle) / 45);
				segAngle = (endAngle-startAngle) / numOfSegs;
				segAngle = (segAngle / 180) * Math.PI;
				angle = (startAngle / 180) * Math.PI;
				
				if (endOuterRadius > 0) {
					outerRadiusInc = (endOuterRadius - outerRadius) / numOfSegs;
				}
				if (endInnerRadius > 0) {
					innerRadiusInc = (endInnerRadius - innerRadius) / numOfSegs;
				}
				
				
				// Calculate the wedge start point
				var startx:Number = sx + Math.cos(angle) * innerRadius;
				var starty:Number = sy + Math.sin(angle) * innerRadius;
				// Move the pen
				shape.graphics.moveTo(startx, starty);
				
				// Calculate the arc start point
				ax = sx + Math.cos(angle) * outerRadius;
				ay = sy + Math.sin(angle) * outerRadius;
				
				// Draw the first line
				shape.graphics.lineTo(ax, ay);

				for (var i:int=0; i<numOfSegs; i++) 
				{
						
						angle += segAngle;
						angleMid = angle - (segAngle / 2);
						bx = sx + Math.cos(angle) * outerRadius;
						by = sy + Math.sin(angle) * outerRadius;
						cx = sx + Math.cos(angleMid) * (outerRadius / Math.cos(segAngle / 2));
						cy = sy + Math.sin(angleMid) * (outerRadius / Math.cos(segAngle / 2));
						shape.graphics.curveTo(cx, cy, bx, by);
						outerRadius += outerRadiusInc;
				}
			
				var endx:Number;
				var endy:Number;	
				
				if (innerRadius > 0 || endInnerRadius > 0) {
					if (endInnerRadius > 0) {
						innerRadius = endInnerRadius;
					}
					
					// Calculate the wedge end point
					endx = sx + Math.cos(angle) * innerRadius;
					endy = sy + Math.sin( angle) * innerRadius;
					
					// Point of return
					shape.graphics.lineTo(endx, endy);
				
					for (i=0; i<numOfSegs; i++) 
						{
								
								angle -= segAngle;
								angleMid = angle + (segAngle / 2);
								bx = sx + Math.cos(angle) * innerRadius;
								by = sy + Math.sin(angle) * innerRadius;
								cx = sx + Math.cos(angleMid) * (innerRadius / Math.cos(segAngle / 2));
								cy = sy + Math.sin(angleMid) * (innerRadius / Math.cos(segAngle / 2));
								shape.graphics.curveTo(cx, cy, bx, by);
								innerRadius -= innerRadiusInc;
						}
				}else {
					// Calculate the wedge end point
					endx = sx + Math.cos(angle) * innerRadius;
					endy = sy + Math.sin( angle) * innerRadius;
					
					// Point of return
					shape.graphics.lineTo(endx, endy);
				}
				
				shape.graphics.endFill();
				
				return shape;
		}
		
		/**
		 * 
		 * @param	radius
		 * @param	factor		: Opt for values between 0 and 20 ...
		 * @param	color
		 * @param	transparency
		 * @return
		 */
		public static function flower(radius:Number = 10, factor:Number = 4, color:Number = 0x000000, transparency:Number = 0.5):Shape {
			
			var f:Shape = new Shape();
			f.alpha = transparency;
			
			var vectorP:Number;
			var destP:Number;
			with (f.graphics) {
				
				lineStyle();
				beginFill(color);
				
				//lógica : encontrar vector points a cada PI/4 (e não a cada PI/2)
				vectorP = radius*(Math.SQRT2-1);
				//idem: var vectorP = Math.sin(Math.PI/8)*Math.cos(Math.PI/8)*raio;
				//a outra componente (x ou y alternado) é igual ao raio
    			
				//var destP=raio*Math.SQRT2/2;
				destP = radius*Math.cos(Math.PI/factor);
				//destPx = destPy;
				
			
				
				//outras formas:
				/*
				destP = radius*Math.cos(Math.PI*1.8);
				destP = radius*Math.cos(Math.PI*1.5);
				destP = radius*Math.cos(Math.PI*1.2);
				destP = radius*Math.cos(Math.PI);
				destP = radius*Math.cos(Math.PI/2);
				destP = radius*Math.cos(Math.PI/4);
				destP = radius*Math.cos(Math.PI/8);
				destP = radius*Math.cos(Math.PI/16);
				destP = radius*Math.sin(Math.PI/16);
				*/
				
				moveTo(radius,0);
				curveTo(radius,vectorP,destP,destP);
				curveTo(vectorP,radius,0,radius);
				curveTo(-vectorP,radius,-destP,destP);
				curveTo(-radius,vectorP,-radius,0);
				curveTo(-radius,-vectorP,-destP,-destP);
				curveTo(-vectorP,-radius,0,-radius);
				curveTo(vectorP,-radius,destP,-destP);
				curveTo(radius,-vectorP,radius,0);
	
				endFill();

			}
			
			
			f.x = radius*2;
			f.y = radius*2;
			
			return f;
		}
	}
}