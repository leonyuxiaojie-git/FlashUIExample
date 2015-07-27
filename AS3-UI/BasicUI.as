package {
	import fl.controls.Button;

	import com.unity.IUnityContent;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	//By no means are these best practices, merely a hacked together example UI
	public class BasicUI extends Sprite
	{
		private var unityContentRef : IUnityContent;
		
		private var changeWallColourButton : Button;
		private var numberOfColourChangesText : lnkColourChanges;		
		
		public function BasicUI(unityContent : IUnityContent) 
		{
			unityContentRef = unityContent;
			
			changeWallColourButton = new Button();
			changeWallColourButton.label = "Change Colour";
			changeWallColourButton.width = 120;
			changeWallColourButton.x = 10;
			changeWallColourButton.y = 10;			
			changeWallColourButton.addEventListener(MouseEvent.MOUSE_UP, onChangeWallColourButtonClicked);
			addChild(changeWallColourButton);
			
			numberOfColourChangesText = new lnkColourChanges();
			numberOfColourChangesText.count.text = "0";
			numberOfColourChangesText.x = 10;
			numberOfColourChangesText.y = 40;
			addChild(numberOfColourChangesText);
		}

		//An example of how to call into the UnityContent swf. Instructs it to change the wall colour
		private function onChangeWallColourButtonClicked(event : MouseEvent) : void 
		{
			unityContentRef.sendMessage("FlashUICommunicator", "ChangeWallColour");
		}
				
			
		//Called from the UnityContent swf once it's changed the colour of the wall
		public function updateColourChangesUIText(numberOfColourChanges : int):void
		{
			numberOfColourChangesText.count.text = numberOfColourChanges.toString();
		}	
	}
}
