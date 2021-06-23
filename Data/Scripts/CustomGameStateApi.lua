local customApi = {
  GAME_STATE_LOBBY = 0,
  GAME_STATE_ROUND = 1,
  GAME_STATE_ROUND_END = 2,
  GAME_STATE_GAME_END = 3
}

function customApi.RegisterGameStateManagerServer(stateGetter, stateTimeGetter, stateSetter, stateTimeSetter)
  if _G.customApiGameState and _G.customApiGameState.registeredOnServer then
    error("Multiple game state managers detected")
  end

  _G.customApiGameState = {
    registeredOnServer = true,
    stateGetter = stateGetter,
    stateTimeGetter = stateTimeGetter,
    stateSetter = stateSetter,
    stateTimeSetter = stateTimeSetter
  }

  _G.customApiGameState.stateGetter = stateGetter
end

function customApi.RegisterGameStateManagerClient(stateGetter, stateTimeGetter)
  if _G.customApiGameState and _G.customApiGameState.registeredOnServer then
    error("Multiple game state managers detected")
  end
  
  _G.customApiGameState = {
    registeredOnServer = true,
    stateGetter = stateGetter,
    stateTimeGetter = stateTimeGetter,
  }
end

function customApi.IsGameStateManagerRegistered()
  return _G.customApiGameState ~= nil
end

-- Getters

function customApi.GetGameState()
  if not _G.customApiGameState then
    warn("GetGameState - Game state manager not registered")
    return nil
  end

  return _G.customApiGameState.stateGetter()
end

function customApi.GetTimeRemainingInState()
  if not _G.customApiGameState then
    warn("GetTimeRemainingInState - Game state manager not registered")
    return nil
  end

  return _G.customApiGameState.stateTimeGetter()
end

-- Setters

function customApi.SetGameState(newState)
  if not _G.customApiGameState then
    warn("SetGameState - Game state manager not registered")
    return nil
  end

  _G.customApiGameState.stateSetter(newState)
end

function customApi.SetTimeRemainingInState(remainingTime)
  if not _G.customApiGameState then
    warn("SetTimeRemainingInState - Game state manager not registered")
    return nil
  end

  _G.customApiGameState.stateTimeSetter(remainingTime)
end

return customApi
