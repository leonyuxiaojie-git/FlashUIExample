using UnityEngine;
using UnityEngine.Flash;

//Responsible for handling communication between the Unity published swf and the flash host swf (which
//contains the UI).
public class FlashUICommunicator : MonoBehaviour 
{	
	public object flashUI;
	
	public GameObject wall;
	
	private int numberOfColourChanges = 0;
	
	//Stores a reference to the FlashUI from the Flash host swf. Enables us to later call
	//functions on the BasicUI class (in the flash project).
	void SetFlashUI(object o)
	{
		#if UNITY_FLASH
			ActionScript.Statement("FlashUICommunicator$flashUI$ = {0}.flashUI", o);
		#endif
	}
	
	//Called via sendMessage from the Flash host swf when the Change Colour flash button is pressed.
	//Changes the colour of the wall and then requests for the host swf to update the value in the UI
	public void ChangeWallColour()
	{
		numberOfColourChanges++;
		
		wall.renderer.material.color = new Color(Random.Range(0.0f, 1.0f), Random.Range(0.0f, 1.0f), Random.Range(0.0f, 1.0f), 1.0f);
		
		#if UNITY_FLASH
		if(flashUI != null)
		{
			ActionScript.Statement("FlashUICommunicator$flashUI$['updateColourChangesUIText']({0})",numberOfColourChanges);
		}
		#endif
	}

}