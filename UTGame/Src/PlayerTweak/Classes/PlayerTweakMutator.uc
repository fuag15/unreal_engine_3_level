class PlayerTweakMutator extends UTMutator
config(PlayerTweak);

var config float Speed;
var config float JumpHeight;
var config int StartHealth;
var config int MaxHealth;

function ModifyPlayer(Pawn Other)
{
	Other.GroundSpeed *= (Speed/100);
	Other.JumpZ *= (JumpHeight/100);
	Other.Health *= StartHealth;
	Other.HealthMax *= MaxHealth;
	
	Super.ModifyPlayer(Other);
}

DefaultProperties
{
}

