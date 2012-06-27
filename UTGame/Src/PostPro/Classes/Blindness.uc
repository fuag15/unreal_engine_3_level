class Blindness extends UTMutator;

function ModifyPlayer(Pawn Other)
{
	local LocalPlayer LocalPlayer;
	local PostProcessSettings DarkSettings;

	LocalPlayer = LocalPlayer( PlayerController( Other.Controller ).Player );
	LocalPlayer.bOverridePostProcessSettings = true;

	DarkSettings = LocalPlayer.CurrentPPInfo.LastVolumeUsed.Settings;

	DarkSettings.bEnableDOF = true;
	DarkSettings.DOF_FocusInnerRadius = 1.f;
	DarkSettings.DOF_BlurKernelSize = 12.f;

	DarkSettings.DOF_MaxFarBlurAmount = 2.f;

	DarkSettings.Scene_Desaturation *= 0.5f;

	DarkSettings.Scene_HighLights.X -= 0.1f;
	DarkSettings.Scene_HighLights.Y -= 0.1f;
	DarkSettings.Scene_HighLights.Z -= 0.1f;

	DarkSettings.Scene_Midtones.X *= 2.5f;
	DarkSettings.Scene_Midtones.Y *= 2.5f;
	DarkSettings.Scene_Midtones.Z *= 2.5f;

	DarkSettings.Bloom_Scale *= 5.f;

	LocalPlayer.PostProcessSettingsOverride = DarkSettings;

	if ( UTPawn( Other ) != None )
	{
		UTPawn( Other ).SetInvisible( true );
	}

	super.ModifyPlayer( Other );
}

DefaultProperties
{

} 