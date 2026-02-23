local poles = require("__electric-age__/scripts/poles")

script.on_init(function()
    poles.on_init()
end)

script.on_nth_tick(120, function()
    poles.on_nth_tick()
end)

local build_events = {
    defines.events.on_built_entity,
    defines.events.on_robot_built_entity,
    defines.events.script_raised_built
}

script.on_event(build_events, function(event)
    poles.reg(event.entity)
end)

script.on_event({
    defines.events.on_entity_died, 
    defines.events.on_player_mined_entity, 
    defines.events.on_robot_mined_entity
}, function(event)
    poles.unreg(event.entity.unit_number)
end)