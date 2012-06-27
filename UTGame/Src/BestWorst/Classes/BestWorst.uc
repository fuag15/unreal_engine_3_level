class BestWorst extends UTMutator;

var class<GameRules> GRClass;

function InitMutator(string Options, out string ErrorMessage)
{
	WorldInfo.Game.AddGameRules(GRClass);

	Super.InitMutator(Options, ErrorMessage);
}

DefaultProperties
{
	GRClass=class'BestWorst.BestWorst_Rules'
} 