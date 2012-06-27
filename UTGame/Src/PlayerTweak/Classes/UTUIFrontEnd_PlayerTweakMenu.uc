class UTUIFrontEnd_PlayerTweakMenu extends UTUIFrontEnd;

var transient UTUISlider PlayerSpeed;
var transient UTUISlider PlayerJumpHeight;
var transient UTUISlider PlayerStartHealth;
var transient UTUISlider PlayerMaxHealth; 

event SceneActivated(bool bInitialActivation)
{
	Super.SceneActivated(bInitialActivation);
	
	if(bInitialActivation)
	{
		PlayerSpeed = UTUISlider(FindChild('sliSpeed', true));
		PlayerJumpHeight = UTUISlider(FindChild('sliJumpHeight', true));
		PlayerStartHealth = UTUISlider(FindChild('sliStartHealth', true));
		PlayerMaxHealth = UTUISlider(FindChild('sliMaxHealth', true));
		
		PlayerSpeed.SliderValue.CurrentValue = 100.f;
		PlayerSpeed.SliderValue.MinValue = 25.f;
		PlayerSpeed.SliderValue.MaxValue = 200.f;
		PlayerSpeed.SliderValue.NudgeValue = 25.f;
		PlayerSpeed.SliderValue.bIntRange = true;
		
		PlayerJumpHeight.SliderValue.CurrentValue = 100.f;
		PlayerJumpHeight.SliderValue.MinValue = 0.f;
		PlayerJumpHeight.SliderValue.MaxValue = 400.f;
		PlayerJumpHeight.SliderValue.NudgeValue = 25.f;
		PlayerJumpHeight.SliderValue.bIntRange = true;
		
		PlayerStartHealth.SliderValue.CurrentValue = 100;
		PlayerStartHealth.SliderValue.MinValue = 25f;
		PlayerStartHealth.SliderValue.MaxValue = 250f;
		PlayerStartHealth.SliderValue.NudgeValue = 25;
		PlayerStartHealth.SliderValue.bIntRange = true;
		
		PlayerMaxHealth.SliderValue.CurrentValue = 199;
		PlayerMaxHealth.SliderValue.MinValue = 25;
		PlayerMaxHealth.SliderValue.MaxValue = 500;
		PlayerMaxHealth.SliderValue.NudgeValue = 25;
		PlayerMaxHealth.SliderValue.bIntRange = true;
	}
}

function SetupButtonBar()
{
	ButtonBar.AppendButton("", OnButtonBar_Back);
} 

function bool OnButtonBar_Back(UIScreenObject InButton, int InPlayerIndex)
{
	class 'PlayerTweak.PlayerTweakMutator'.default.Speed = PlayerSpeed.GetValue();
	class 'PlayerTweak.PlayerTweakMutator'.default.JumpHeight = PlayerJumpHeight.GetValue();
	class 'PlayerTweak.PlayerTweakMutator'.default.StartHealth = PlayerStartHealth.GetValue();
	class 'PlayerTweak.PlayerTweakMutator'.default.MaxHealth = PlayerMaxHealth.GetValue();

	class 'PlayerTweak.PlayerTweakMutator'.static.StaticSaveConfig();

	CloseScene(self);

	return true;
} 

DefaultProperties
{
}