#!/command/with-contenv bashio

# Initialize command variable
CMD="./goalfeed"


sanitize_input() {
    echo "$1" | grep -oE '\b[a-zA-Z0-9]{2,3}\b' | paste -sd, -
}

# Check if mlb_teams has a value in the configuration
if bashio::config.has_value 'mlb_teams'; then
    MLB_TEAMS=$(bashio::config 'mlb_teams')
    # Sanitize the input
    MLB_TEAMS=$(sanitize_input "$MLB_TEAMS")
    CMD+=" --mlb $MLB_TEAMS"
fi

# Check if nhl_teams has a value in the configuration
if bashio::config.has_value 'nhl_teams'; then
    NHL_TEAMS=$(bashio::config 'nhl_teams')
    # Sanitize the input
    NHL_TEAMS=$(sanitize_input "$NHL_TEAMS")
    CMD+=" --nhl $NHL_TEAMS"
fi

if bashio::config.true 'test_goals'; then
    CMD+=" --test-goals"
fi

export SUPERVISOR_API=http://supervisor

echo $CMD
# Execute the command
$CMD