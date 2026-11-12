# Home Assistant Community Add-on: GoalFeed

The Home Assistant GoalFeed add-on provides real-time goal updates for NHL and MLB games, featuring a web interface and REST API for monitoring your favourite teams.

## Features

- **Real-time Goal Events**: Automatic notifications when your teams score
- **Web Interface**: Interactive scoreboard and team management UI
- **REST API**: Programmatic access to games, events, and team data
- **WebSocket Support**: Real-time updates via WebSocket connection
- **Multi-League Support**: NHL and MLB teams

## Installation

The installation of this add-on is similar to other Home Assistant add-ons.

1. Navigate to the GoalFeed repository on GitHub.
2. Click the "Clone or download" button and copy the repository URL.
3. In your Home Assistant instance, go to the add-on store and add the repository URL.
4. Find the GoalFeed add-on in the list and click "Install".
5. Once installed in the configuration tab, enter the two or three letter code for the teams you want to get events for (ie. WPG, TOR, NYY)
6. Start the "Goalfeed" add-on and check the logs to ensure everything is running smoothly.

## Accessing the Web Interface

After starting the add-on, you can access the web interface in two ways:

1. **Via Home Assistant Panel**: Click on the Goalfeed icon in the Home Assistant sidebar
2. **Direct Access**: Navigate to port 8080 on your Home Assistant host

The web interface provides:
- Live scoreboard with real-time game updates
- Team management for configuring which teams to monitor
- Event feed showing recent goals and scores

## API Documentation

The add-on exposes a REST API on port 8080:

- **API Base URL**: `http://[your-host]:8080/api`
- **Swagger Documentation**: `http://[your-host]:8080/swagger/index.html`
- **WebSocket**: `ws://[your-host]:8080/ws`

### Key API Endpoints

- `GET /api/games` - Get all active games
- `GET /api/leagues` - Get league configurations
- `POST /api/leagues` - Update team configurations
- `GET /api/events` - Get recent goal events
- `GET /api/teams` - Get available teams per league

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

### Configuration Options

- **nhl_teams**: Comma-separated list of NHL team codes (e.g., "TOR,WPG,NYR")
- **mlb_teams**: Comma-separated list of MLB team codes (e.g., "TOR,NYY,BOS")
- **test_goals**: Enable test goals every minute for testing automations (default: false)
- **broadcast_delay_seconds**: Hold back everything Goalfeed sends to Home Assistant (goal events and sensors) by this many seconds, so your lights don't go off before the goal is on your TV or stream. 0 turns it off; the maximum is 900 (15 minutes). Measure it once: note when the goal light fires and when the goal appears on screen, and use the difference. Needs Goalfeed 1.0.53 or later (default: 0)

### Example Configuration

```yaml
nhl_teams: "TOR,WPG"
mlb_teams: "TOR,NYY"
test_goals: false
broadcast_delay_seconds: 0
```

## Creating Automations

You can create Home Assistant automations that trigger when your teams score. See the [GoalFeed wiki](https://github.com/goalfeed/goalfeed/wiki/Goal-Automation) for detailed automation examples.
