class SaberCat extends UTMutator;

DefaultProperties
{
}

function InitMutator(string Options, out string ErrorMessage)
{
	if (UTGame(WorldInfo.Game) != None)
	{
		UTGame(WorldInfo.Game).DefaultInventory[0] = class'UTWeap_SaberCat';
	}
	
	Super.InitMutator(Options, ErrorMessage);
}

function bool CheckReplacement(Actor Other)
{
	if (Other.IsA('UTWeap_ShockRifle') && !Other.IsA('UTWeap_SaberCat'))
	{
		ReplaceWith(Other, "UTWeap_SaberCat");
	}
	
	NextMutator.CheckReplacement(Other);
	
	return true;
}