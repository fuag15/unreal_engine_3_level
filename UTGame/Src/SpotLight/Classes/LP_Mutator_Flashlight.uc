class LP_Mutator_Flashlight extends UTMutator;

var Color RedColour, BlueColour, LightColour;
var float LightScale;

DefaultProperties
{
	RedColour = (R = 255, G = 25, B = 25)
	BlueColour = (R = 25, G = 25, B = 255)
	LightColour = (R = 255, G = 255, B = 255)
	LightScale = 1;
}

function ModifyPlayer(Pawn Other)
{
	local SpotLightComponent LightAttachment;

	if (Other.IsA('UTPawn'))
	{
		LightAttachment = new(self) class'SpotLightComponent';

		if (WorldInfo.Game.bTeamGame == true)
		{
			if (UTPawn( Other ).Controller.PlayerReplicationInfo.Team.TeamIndex == 0)
			{
				LightAttachment.SetLightProperties(LightScale, RedColour);
			}
			else if (UTPawn( Other ).Controller.PlayerReplicationInfo.Team.TeamIndex == 1)
			{
				LightAttachment.SetLightProperties(LightScale, BlueColour);
			}
		}
		else
		{
			LightAttachment.SetLightProperties(LightScale, LightColour);
		}

		LightAttachment.CastDynamicShadows = true;
		LightAttachment.SetEnabled( true );

		UTPawn( Other ).AttachComponent( LightAttachment );
	}

	super.ModifyPlayer( Other );
} 