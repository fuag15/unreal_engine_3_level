class PowerCube extends KActorSpawnable;

DefaultProperties
{
	Begin Object Name=StaticMeshComponent0
	StaticMesh=StaticMesh'Weap_PowerCube.PowerCube'
	Scale3D=(X=1.0,Y=1.0,Z=1.0)
	WireframeColor=(R=0,G=255,B=128,A=255)
	BlockRigidBody=true
	RBChannel=RBCC_GameplayPhysics
	RBCollideWithChannels=(Default=TRUE, GameplayPhysics=TRUE, EffectPhysics=TRUE)
	end Object
	
	bWakeOnLevelStart=true
}