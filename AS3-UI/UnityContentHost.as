package
{
	/**
	 * A simple project with UI and Preloader built in Flash. The fla is published to a swc which is
	 * then included in the project to provide access to the Flash created assets.
	 * 
	 * It uses the UnityShared.swc, which is automatically built next to your unity project build.
	 * 
	 * Make sure you compile the content host -swf-version=13 and that if you run it in an html container with wmode=direct set; both are needed to allow stage3d usage.
	 * Also make sure you link against UnityShared.swc and that you use the playerglobals for fp11.0, or fp11.1.
	 **/
	
	import com.unity.IUnityContentHost;
	import com.unity.UnityContentLoader;
	import com.unity.UnityLoaderParams;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	
	/**
	 * The class that will recieve the unity callbacks needs to implement IUNityContentHost. It does not have to be your displaylist root, but for simplicity we do it on the content root here.
	 */
	[SWF(width='720', height='400', backgroundColor='#FFFFFF', frameRate='60')]
	public class UnityContentHost extends Sprite implements IUnityContentHost
	{
		private var unityContentLoader:UnityContentLoader;
				
		private var preloader : Preloader;
		private var basicUI : BasicUI;
		
		public function UnityContentHost()
		{
			init();
		}
			
		private function init():void
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			preloader = new Preloader();
			addChild(preloader);
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			loadUnity();
		}
		
		private function loadUnity():void
		{
			var params:UnityLoaderParams = new UnityLoaderParams(false,720,400,false);//We disable automatic scaling to stage, set a size and disable the standard preloader.
			unityContentLoader = new UnityContentLoader("UnityContent.swf", this, params, false);
			unityContentLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onUnityContentLoaderProgress);
			unityContentLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onUnityContentLoaderComplete);
			unityContentLoader.loadUnity();
		}
		
		private function onUnityContentLoaderProgress(event:ProgressEvent):void
		{
			preloader.update((event.bytesLoaded/event.bytesTotal) * 100);
		}
		
		private function onUnityContentLoaderComplete(event:Event):void
		{
			addChild(unityContentLoader);
			unityContentLoader.unityContent.setContentHost(this);//Set this instance as the callback handler for unity.	
		}
		
		public function unityInitStart():void
		{
			//This is called when the content is loaded and the initialization of the unity engine is started.	
		}
		
		public function unityInitComplete():void
		{
			destroyPreloader();	
			
			//This is called when the unity engine is done initializing and the first level is loaded.								
			basicUI = new BasicUI(unityContentLoader.unityContent);
			addChild(basicUI);
			
			//From this point on, you can use sendmessage to send over messages..in this case we send a reference to
			//the basicUI, which can then be referenced by the UnityContent swf (UICommunicator.cs) to update the display.
			unityContentLoader.unityContent.sendMessage("FlashUICommunicator","SetFlashUI",{flashUI:basicUI});
					
		}

		private function destroyPreloader() : void 
		{
			removeChild(preloader);
			preloader.destroy();
			preloader = null;
		}
	}
}