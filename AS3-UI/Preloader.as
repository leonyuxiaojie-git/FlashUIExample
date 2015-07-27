package {
	import fl.controls.Label;
	import fl.controls.ProgressBar;

	import flash.display.Sprite;
	
	public class Preloader extends Sprite
	{
		private var preloaderImage : lnkPreloader;
		private var progressBar : ProgressBar;
		private var progressLabel : Label;
		
		public function Preloader()
		{
			super();
			init();
		}
		
		private function init():void
		{
			preloaderImage = new lnkPreloader();
			addChild(preloaderImage);
	
			progressLabel = new Label();
			progressLabel.x = 350;
			progressLabel.y = 360;
			addChild(progressLabel);
			
			progressBar = new ProgressBar();
			addChild(progressBar);
			progressBar.width = 200;
			progressBar.x = 250;
			progressBar.y = 350;
			progressBar.maximum = 0;
			progressBar.maximum = 100;
			progressBar.value = 0;
		}
		
		public function update(progress : int):void
		{
			progressBar.value = progress;
			progressLabel.text = progress + "%";
		}
		
		public function destroy() : void
		{
			removeChild(preloaderImage);
			removeChild(progressBar);
			
			preloaderImage = null;
			progressBar = null;
		}
	}
}