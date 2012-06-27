class ChargeRifle extends UTWeap_InstagibRifle;

enum Colour
{
	eRed,
	eBlue,
	eNeutral
};

var Colour Charge;
var bool Hard;
var linearcolor RedCube, BlueCube, NeutralCube;
var texture2d WeakMat, StrongMat;
var MaterialInstanceConstant NewMaterial;

function ReColour(LinearColor NewColour, Actor HitActor)
{
	if (HitActor.IsA('PowerCube'))
	{
		NewMaterial = PowerCube( HitActor ).StaticMeshComponent.CreateAndSetMaterialInstanceConstant( 0 );
		NewMaterial.SetVectorParameterValue('PowerColour', NewColour);
	}

}

function ReMaterial(Actor HitActor)
{
	if (Hard == true)
	{
		NewMaterial = PowerCube( HitActor ).StaticMeshComponent.CreateAndSetMaterialInstanceConstant( 0 );
		NewMaterial.SetTextureParameterValue('BaseTexture', WeakMat);
		NewMaterial.SetTextureParameterValue('RippleEffect', StrongMat);

		Hard = false;
	}
	else
	{
		NewMaterial = PowerCube( HitActor ).StaticMeshComponent.CreateAndSetMaterialInstanceConstant( 0 );
		NewMaterial.SetTextureParameterValue('BaseTexture', StrongMat);
		NewMaterial.SetTextureParameterValue('RippleEffect', WeakMat);

		Hard = true;
	}
	switch(Charge)
	{
		case eRed:
		ReColour(RedCube, HitActor);
		break;
		case eBlue:
		ReColour(BlueCube, HitActor);
		break;
		case eNeutral:
		ReColour(NeutralCube, HitActor);
		break;
	}
}

simulated function StartFire(byte FireModeNum)
{
	local vector HitLocation, HitNormal, Dir;
	local Actor HitActor;
	local TraceHitInfo HitInfo;
	local ImpactInfo CurrentImpact;
	local PortalTeleporter Portal;
	local float HitDist;
	local vector StartTrace, EndTrace;
	local array<ImpactInfo> ImpactList;

	StartTrace = InstantFireStartTrace();
	EndTrace = InstantFireEndTrace(StartTrace);

	// Perform trace to retrieve hit info

	HitActor = GetTraceOwner( ).Trace(HitLocation, HitNormal, EndTrace, StartTrace, TRUE, vect(0,0,0), HitInfo, TRACEFLAG_Bullet);

	// If we didn't hit anything, then set the HitLocation as being the EndTrace location
	if( HitActor == None )
	{
		HitLocation = EndTrace;
	}

	// Convert Trace Information to ImpactInfo type.
	CurrentImpact.HitActor = HitActor;
	CurrentImpact.HitLocation = HitLocation;
	CurrentImpact.HitNormal = HitNormal;
	CurrentImpact.RayDir = Normal(EndTrace - StartTrace);
	CurrentImpact.HitInfo = HitInfo;

	// Add this hit to the ImpactList
	ImpactList[ ImpactList.Length ] = CurrentImpact;

	// check to see if we've hit a trigger.
	// In this case, we want to add this actor to the list so we can give it damage, and then continue tracing through.
	if( HitActor != None )
	{
		if (!HitActor.bBlockActors && PassThroughDamage( HitActor ))
		{
			// disable collision temporarily for the trigger so that we can catch anything inside the trigger
			HitActor.bProjTarget = false;
			// recurse another trace
			CurrentImpact = CalcWeaponFire(HitLocation, EndTrace, ImpactList);
			// and reenable collision for the trigger
			HitActor.bProjTarget = true;
		}
		else
		{
			// if we hit a PortalTeleporter, recurse through
			Portal = PortalTeleporter(HitActor);
			if( Portal != None && Portal.SisterPortal != None )
			{
				Dir = EndTrace - StartTrace;
				HitDist = VSize(HitLocation - StartTrace);
				// calculate new start and end points on the other side of the portal
				StartTrace = Portal.TransformHitLocation( HitLocation );
				EndTrace = StartTrace + Portal.TransformVector( Normal( Dir ) * ( VSize( Dir ) - HitDist) );
				//@note: intentionally ignoring return value so our hit of the portal is used for effects
				//@todo: need to figure out how to replicate that there should be effects on the other side as well
				CalcWeaponFire(StartTrace, EndTrace, ImpactList);
			}
		}

		if (HitActor.IsA('PowerCube'))
		{
			if (FireModeNum == 0)
			{
				switch(Charge)
				{
					case eRed:
					ReColour(BlueCube, HitActor);
					Charge = eBlue;
					break;
					case eBlue:
					ReColour(NeutralCube, HitActor);
					Charge = eNeutral;
					break;
					case eNeutral:
					ReColour(RedCube, HitActor);
					Charge = eRed;
					break;
				}
			}
			else
			{
				ReMaterial( CurrentImpact.HitActor );
			}
		}
	}
}

exec function SpawnCube()
{
	local class CubeClass;

	CubeClass = class<PowerCube>(DynamicLoadObject("Weap_PowerCube.PowerCube", class'Class'));

	Spawn( CubeClass,,, );
}

DefaultProperties
{
	RedCube = (R = 100, G = 5, B = 5, A = 1)
	BlueCube = (R = 5, G = 5, B = 100, A = 1)
	NeutralCube = (R = 100, G = 100, B = 5, A = 1)
	WeakMat = texture2d'Envy_Effects.Energy.Materials.T_EFX_Energy_Swirl_03'
	StrongMat = texture2d'Envy_Effects.Energy.Materials.T_EFX_Energy_Tile_01'
	Hard = false
}