class BestWorst_Rules extends GameRules;

var Controller m_bestPlayer;
var Controller m_worstPlayer;

var PointLightComponent m_bestPlayerLight;
var PointLightComponent m_worstPlayerLight;

var int m_bonus;
var int m_malus;

var color redColor;
var color greenColor;

defaultproperties
{
	m_bonus = 2
	m_malus = 2

	redColor = (R=255,G=0,B=0,A=255);
	greenColor = (R=0,G=255,B=0,A=255);
}

function ScoreKill( Controller Killer, Controller Killed )
{
	local int killerId, killedId, bestPlayerId, worstPlayerId;

	killerId = Killer.playerReplicationInfo.PlayerId;
	killedId = Killed.playerReplicationInfo.PlayerId;
	bestPlayerId = getBestPlayerId( );
	worstPlayerId = getWorstPlayerId( );

	//check if the killed player is the worst player => malus
	if(killedId == worstPlayerId)
	{
		setMalus(killer);
	}

	//check if the killed player is the best player = >bonus
	if(killedId == bestPlayerId)
	{
		setBonus(killer);
	}

	//check if the killer was the worst player => bonus
	if(killerId == bestPlayerId)
	{
		setBonus(killer);
	}

	//update status best and worst player
	updateControllersStatus(killedId);

	if ( NextGameRules != None )
	{
		NextGameRules.ScoreKill(Killer,Killed);
	}
} 

function int getBestPlayerId()
{
	local int i;
	local PlayerReplicationInfo bestPlayer, currentPlayer;
	for(i=0;i<worldInfo.GRI.PRIArray.length;i++)
	{
		currentPlayer = worldInfo.GRI.PRIArray[i];
		if(i==0)
		{
			bestPlayer = currentPlayer;
		}
		if(bestPlayer!=none && bestPlayer.score < currentPlayer.score)
		{
			bestPlayer = currentPlayer;
		}
		else if(bestPlayer!=none && bestPlayer.score == currentPlayer.score)
		{
			if(bestPlayer.deaths > currentPlayer.deaths)
			{
				bestPlayer = currentPlayer;
			}
		}
	}
	return bestPlayer.playerId;
}

function int getWorstPlayerId()
{
	local int i;
	local PlayerReplicationInfo worstPlayer, currentPlayer;
	for(i=0;i<worldInfo.GRI.PRIArray.length;i++)
	{
		currentPlayer = worldInfo.GRI.PRIArray[i];
		if(i==0)
		{
			worstPlayer = currentPlayer;
		}

		if(worstPlayer!=none && worstPlayer.score > currentPlayer.score )
		{
			worstPlayer = currentPlayer;
		}

		else if(worstPlayer!=none && worstPlayer.score == currentPlayer.score)
		{
			if(worstPlayer.deaths < currentPlayer.deaths)
			worstPlayer = currentPlayer;
		}
	}
	return worstPlayer.playerId;
} 

function setBonus(Controller c)
{
	c.PlayerReplicationInfo.score += m_bonus;
	c.PlayerReplicationInfo.bForceNetUpdate = true;
	c.PlayerReplicationInfo.Kills+= m_bonus;
}

function setMalus(Controller c)
{
	c.PlayerReplicationInfo.score -= m_malus;
	c.PlayerReplicationInfo.bForceNetUpdate = true;
	c.PlayerReplicationInfo.Kills -= m_malus;
}

function updateControllersStatus(int killedId)
{
	local Controller controller;
	local int bestPlayerId, worstPlayerId, currentPlayerId;

	bestPlayerId = getBestPlayerId();
	worstPlayerId = getWorstPlayerId();

	if(bestPlayerId == worstPlayerId)
	{
		return;
	}

	//detach previous light component
	if(m_bestPlayer!=None && m_bestPlayer.pawn != None)
	{
		m_bestPlayer.pawn.detachComponent(m_bestPlayerLight);
	}

	if(m_worstPlayer!=None && m_worstPlayer.Pawn != None)
	{
		m_worstPlayer.pawn.detachComponent(m_worstPlayerLight);
	}
	
	m_bestPlayer = None;
	m_worstPlayer = None;

	//create the point light
	if(m_bestPlayerLight == None)
	{
		m_bestPlayerLight = createPointLight(false);
	}
	
	if(m_worstPlayerLight == None)
	{
		m_worstPlayerLight = createPointLight(true);
	}
	
	//retrieve best and worst controller
	ForEach DynamicActors(class'Controller', controller)
	{
		currentPlayerId = controller.PlayerReplicationInfo.PlayerId;

		if(m_bestPlayer != None && m_worstPlayer != None) //if best and worst found break
		{
			break;
		}

		if(currentPlayerId == bestPlayerId && currentPlayerId != killedId)
		{
			m_bestPlayer = controller;
		}

		if(currentPlayerId == worstPlayerId && currentPlayerId != killedId)
		{
			m_worstPlayer = controller;
		}
	}

	//attach the light ccmponent
	if(m_bestPlayer!=none && m_bestPlayer.Pawn != None)
	{
		m_bestPlayer.pawn.attachComponent(m_bestPlayerLight);
	}

	if(m_worstPlayer!=none && m_worstPlayer.pawn!=None)
	{
		m_worstPlayer.pawn.attachComponent(m_worstPlayerLight);
	}
}

function PointLightComponent createPointLight(bool red)
{
	local PointLightComponent plc;
	local class<PointLightComponent> plcClass;

	plcClass = class'Engine.PointLightComponent';
	plc = new (self)plcClass;

	plc.Radius=250;
	plc.SetEnabled(true);
	
	if(red)
	{
		plc.SetLightProperties(1000, redColor);
	}
	else
	{
		plc.SetLightProperties(1000, greenColor);
	}
	
	return plc;
} 