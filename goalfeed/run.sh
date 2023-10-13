#!/command/with-contenv bashio

# Initialize command variable
CMD="/goalfeed"

sanitize_input() {
    echo "$1" | grep -oE '\b[a-zA-Z0-9]{2,3}\b' | paste -sd, -
}

# Check if mlb_teams is set in the configuration
MLB_TEAMS=$(bashio::config 'mlb_teams')
# Sanitize the input
MLB_TEAMS=$(sanitize_input "$MLB_TEAMS")
if [[ ! -z "$MLB_TEAMS" ]]; then
    CMD+=" --mlb $MLB_TEAMS"
fi

# Check if nhl_teams is set in the configuration
NHL_TEAMS=$(bashio::config 'nhl_teams')
# Sanitize the input
NHL_TEAMS=$(sanitize_input "$NHL_TEAMS")
echo $NHL_TEAMS
if [[ ! -z "$NHL_TEAMS" ]]; then
    CMD+=" --nhl $NHL_TEAMS"
fi

echo $CMD
# Execute the command
$CMD
