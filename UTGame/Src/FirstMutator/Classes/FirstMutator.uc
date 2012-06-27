class FirstMutator extends UTMutator;

DefaultProperties
{
}

function InitMutator(string Options, out string ErrorMessage)
{
	if (UTGame(WorldInfo.Game) != None)
	{
		UTGame(WorldInfo.Game).DefaultInventory[0] = class'UTWeap_EnforcerPlusOne';
	}
	
	Super.InitMutator(Options, ErrorMessage);
}

function bool CheckReplacement(Actor Other)
{
	if (Other.IsA('UTWeap_Enforcer') && !Other.IsA('UTWeap_EnforcerPlusOne'))
	{
		ReplaceWith(Other, "UTWeap_EnforcerPlusOne");
	}
	
	NextMutator.CheckReplacement(Other);
	
	return true;
}