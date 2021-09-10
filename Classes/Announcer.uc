class Announcer extends Mutator
	config(Announcer);

var config int Delay;
var config array<string> Messages;

var int lastMessageIndex;

event PostBeginPlay()
{
	if (Messages.length > 0)
	{
		log("Loaded"@Messages.length@"announcements.");
	}
	else
	{
		log("No meesages were found for announcer!", 'Anouncer');
		Destroy();
	}
}

function MatchStarting()
{
	setTimer(Delay, true);
}

function Mutate(string MutateString, PlayerController Sender)
{
	local int i;
	if (MutateString ~= "test_announcer" && (Sender.PlayerReplicationInfo != none && Sender.PlayerReplicationInfo.bAdmin))
	{
		for (i = 0; i < Messages.length; i++)
		{
			broadcastMessage(Messages[i]);
		}
	}
	super.Mutate(MutateString, Sender);
}

function Timer()
{
	local int messageid;
	if (Messages.length == 1)
	{
		broadcastMessage(Messages[0]);
	}
	else
	{
		do {
			messageId = Rand(Messages.length);
		} until(messageId != lastMessageIndex);

		broadcastMessage(Messages[messageId]);
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
				pController.teamMessage(none, message, 'Announcer');
			}
		}
	}
}

defaultproperties
{
	GroupName="KF-Announcer"
	FriendlyName="Server announcer"
	Description="Sending automatic chat message to all players."

	Delay = 300;
}