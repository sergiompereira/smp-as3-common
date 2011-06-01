package com.smp.common.display.loaders{

	/**
	-------------------------
	Sérgio Pereira :: 12-2009
	-------------------------
	Gera todos os elementos gráficos.
	Disponibiliza um método update()
	Ex de uso:
	public function PreloaderTeste(){
	preloader = new RectangleLoader(new RectangleOptions());
	var loader:LoadDisplayObject = new LoadDisplayObject("imagem.jpg", true);
	loader.addEventListener("onProgress", preloaderHandler);
	}
	private function preloaderHandler(evt:Event):void{
	preloader.update(evt.target.loadPercent/100);
	}
	*/

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.errors.IOError;
	
	import com.smp.effects.TweenSafe;

	
	
	public class RectanglePreloader extends Sprite {

		private var Options:Object;

		private var _bytesTotal:Number;
		private var _bytesLoaded:Number;
		private var _percentage:Number;

		private var _background:Sprite;
		private var _foreground:Sprite;
		private var _backgroundSh:Shape;
		private var _foregroundSh:Shape;
		private var _shadowSh:Shape;

		private var _tween:TweenSafe;

		
		public function RectanglePreloader(holder:DisplayObjectContainer, preWidth:Number, preHeight:Number, options:RectangleOptions = null):void {

			if (options == null) {
				options = new RectangleOptions();
			}
			
			
			_background = new Sprite  ;
			_backgroundSh = new Shape  ;

			_background.addChild(_backgroundSh);

			with (_backgroundSh.graphics) {
				if (options.border!=null) {
					lineStyle(options.border.thickness,options.border.color,options.border.alpha);
				}
				beginFill(options.backgroundColor, options.backgroundAlpha);
				drawRect(0,0, preWidth, preHeight);
				endFill();
			}
			_foreground = new Sprite  ;
			_foregroundSh = new Shape  ;

			_foreground.addChild(_foregroundSh);

			with (_foregroundSh.graphics) {
				if (options.border!=null) {
					lineStyle(options.border.thickness,0x000000,0);
				}
				beginFill(options.foregroundColor, options.foregroundAlpha);
				drawRect(0,0, preWidth, preHeight);
				endFill();
			}
			_backgroundSh.x = Math.round(- preWidth*(1/2*(options.align - 1)));
			_foregroundSh.x = Math.round(- preWidth*(1/2*(options.align - 1)));

			_foreground.scaleX = 0;

			addChild(_background);
			addChild(_foreground);

			if (options.foregroundShadow) {
				_shadowSh = new Shape();
				with (_shadowSh.graphics) {
					var matrix:Matrix = new Matrix();
					var fct:Number;
					if (options.backgroundShadow) {
						fct=1;
					} else {
						fct=3;
					}
					matrix.createGradientBox(preWidth, preHeight, fct*Math.PI/2,0,0);
					beginGradientFill(GradientType.LINEAR, new Array(0x666666, 0x999999), new Array(1,0), new Array(0,255), matrix);
					drawRect(0,0,preWidth,preHeight);
					endFill();
				}
				_shadowSh.x = Math.round(- preWidth*(1/2*(options.align - 1)));
				addChild(_shadowSh);
			}
			
			//2.3 visa o centro óptico
			if (options.holderDimension != null) {
				options.setPosition(options.holderDimension.width/2-preWidth*(1/2*(2-options.align)), options.holderDimension.height/2.3-preHeight/2);
			}else if (options.position == null) {
				
				options.setPosition(holder.width/2-preWidth*(1/2*(2-options.align)), holder.height/2.3-preHeight/2);
			}
			
			x = Math.round(options.position.x);
			y = Math.round(options.position.y);
			

			holder.addChild(this);

			_tween = new TweenSafe();
		}
		
		//inserir o update num handler que corra a tempos espaçados 
		//não usar onEnterFrame nem Timers com menos de 1/100
		public function update(percentage:Number):void 
		{
			_tween.setTween(_foreground, "scaleX", TweenSafe.REG_EASEIN, _foreground.scaleX, percentage, 0.1, true, true);
		}
		
		public function reset():void 
		{
			_foreground.scaleX = 0;
		}
	}
}