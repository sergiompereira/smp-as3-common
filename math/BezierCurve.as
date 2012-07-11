package com.smp.common.math
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Sérgio Pereira
	 */
	public class BezierCurve 
	{
		protected var graphics:Graphics;
		protected var options:lineStyleOptions;
		protected var brush:BitmapData;
		
		public function BezierCurve(graphics:Graphics) {
			this.graphics = graphics;
		}
		
		public function drawQuadratic():void {
			
		}
		
		public function drawCubic(startpoint:Point, destpoint:Point, control1:Point, control2:Point):void {
			if (!options) {
				throw IOError('Line style was not set.');
			}
			
			graphics.lineStyle(1, options.color);
			graphics.beginFill(options.color);
			
			var inc:Number = 0.001;
			var i:Number = 0;
			var point:Point;
			var length:Number = 0;
			var stroke:Boolean = true;
			var lastPoint:Point;
			var nextPoint:Point;
			
			for (i = 0; i <= 1; i += inc) {
				if (nextPoint) {
					point = nextPoint;
				}else {
					point = interpolatePoint(startpoint,destpoint, control1, control2,i);
				}
				
				if(lastPoint){
					length += Geometry2D.getDistance(lastPoint.x, lastPoint.y, point.x, point.y);
				}
				
				nextPoint = interpolatePoint(startpoint,destpoint, control1, control2, i + inc);
				if (stroke) {
					var angle:Number = 0;
					if (nextPoint) {
						angle = Geometry2D.getLineAngle(point, nextPoint);
					}
					drawRect(point, angle);
				}
				
				if ((stroke && length > options.dashlen) || (!stroke && length > options.spacelen)) {
					stroke = !stroke;
					length = 0;
				}
				
				lastPoint = point;
			}
			
		}
		
		public function lineStyle(thickness:Number, color:Number, dashlen:Number = 0, spacelen:Number = 0):void {
			options = new lineStyleOptions();
			options.color = color;
			options.thickness = thickness;
			options.dashlen = dashlen;
			options.spacelen = spacelen;
		}
		
		protected function interpolatePoint(s:Point,d:Point,c1:Point,c2:Point,t:Number):Point {
			var point:Point = new Point();
			point.x = interpolateCubic(s.x, c1.x, c2.x, d.x, t);
			point.y = interpolateCubic(s.y, c1.y, c2.y, d.y, t);
			return point;
		}
		protected function interpolateCubic(a:Number, b:Number, c:Number, d:Number, r:Number):Number {
			return a * Math.pow(1 - r, 3) + b * 3 * Math.pow(1 - r, 2) * r +c * 3 * (1 - r) * Math.pow(r,2) + d * Math.pow(r, 3);
		}
		
		protected function drawRect(point:Point, rotation:Number):void {
			var side:Number = options.thickness / 2;
			var corner1:Point = new Point(point.x + 1, point.y + side);
			var corner2:Point = new Point(point.x + 1, point.y - side);
			var corner3:Point = new Point(point.x, point.y - side);
			var corner4:Point = new Point(point.x, point.y + side);
			
			if (rotation > 0) {
				corner1 = Geometry2D.rotatePoint(point,corner1, rotation);
				corner2 = Geometry2D.rotatePoint(point,corner2, rotation);
				corner3 = Geometry2D.rotatePoint(point,corner3, rotation);
				corner4 = Geometry2D.rotatePoint(point,corner4, rotation);
			}
			graphics.moveTo(corner1.x, corner1.y);
			graphics.lineTo(corner2.x, corner2.y);
			graphics.lineTo(corner3.x, corner3.y);
			graphics.lineTo(corner4.x, corner4.y);
			graphics.lineTo(corner1.x, corner1.y);

		}
		
		
	}
	
}

class lineStyleOptions {
	
	public var thickness:Number;
	public var color:Number;
	public var dashlen:Number;
	public var spacelen:Number;
	
	public function lineStyleOptions() {
		
	}
	
}