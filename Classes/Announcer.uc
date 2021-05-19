class Announcer extends Mutator
	config(Announcer);

var config array<string> messages;
var config int delay;

var int lastMessageIndex;

event PostBeginPlay()
{
	if (messages.length > 0)
	{
		log("Loaded"@messages.length@"announcements.");
	}
	else
	{
		log("No meesages were found for announcer!", 'Anouncer');
		Destroy();
	}
}

function MatchStarting()
{
	setTimer(delay, true);
}

function Mutate(string MutateString, PlayerController Sender)
{
	local int i;
	if (MutateString ~= "test_announcer")
	{
		for (i = 0; i < messages.length; i++)
		{
			broadcastMessage(messages[i]);
		}
	}
	super.Mutate(MutateString, Sender);
}

function Timer()
{
	local int messageid;
	if (messages.length == 1)
	{
		broadcastMessage(messages[0]);
	}
	else
	{
		do {
			messageId = Rand(messages.length);
		} until(messageId != lastMessageIndex);

		broadcastMessage(messages[messageId]);
		lastMessageIndex = messageid;
	}
}

function broadcastMessage(string message)
{
	local Controller C;
	local PlayerController pController;
	for ( C = Level.ControllerList; C != none; C = C.nextController )
	{
		pController = PlayerController(C);
		if ( pController != none )
		{
			if (!(pController.PlayerReplicationInfo.PlayerName ~= "WebAdmin" && pController.PlayerReplicationInfo.PlayerID == 0))
			{
				pController.ClientMessage(message, 'Announcer');
			}
		}
	}
}

defaultproperties
{
	GroupName="KF-Announcer"
	FriendlyName="Server announcer"
	Description="Sending automatic chat message to all players."

	delay = 300;
}