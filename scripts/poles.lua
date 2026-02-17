local LIMITS = {
    ["small-electric-pole"] = 16666.66,
    ["medium-electric-pole"] = 83333.33,
    ["big-electric-pole"] = 250000.00
}

-- check per tick
local cpt = 10

local poles_manager = {}

function poles_manager.on_init()
    storage.electric_age = storage.electric_age or {
        list = {},
        next = nil
    }
end

function poles_manager.reg(entity)
    if not (entity and entity.valid) then return end
    if LIMITS[entity.name] then
        storage.electric_age.list[entity.unit_number] = entity
    end
end

function poles_manager.unreg(id)
    storage.electric_age.list[id] = nil
end

function poles_manager.check_overload(entity)
    if not (entity and entity.valid) then return -1 end

    local limit = LIMITS[entity.name]
    if not limit then return -1 end

    local statistics = entity.electric_network_statistics
    if not statistics then return -1 end
    
    local network = 0
    for name, _ in pairs(statistics.input_counts) do
        network = network + statistics.get_flow_count{
            name=name,
            precision_index=defines.flow_precision_index.one_minute,
            sample_index=1,
            category="input"
        }
    end

    local nid = entity.get_wire_connector(defines.wire_connector_id.pole_copper).network_id
    game.print("NID: " .. nid .. " network: " .. network .. " limit: " .. limit .. " rate: " .. network / limit)

    local rate = network / limit
    if rate > 0.9 and rate < 1.0 then
        return 1
    elseif rate >= 1.0 then
        return 2
    end

    return 0
end

function poles_manager.disconnect(entity)
    if not (entity and entity.valid) then return end

    local conn = entity.get_wire_connector(defines.wire_connector_id.pole_copper)
    if not (conn and conn.valid) then return end

    local connections = conn.connections
    if #connections > 0 then
        local rand = math.random(#connections)
        local target = connections[rand].target
        if target and target.valid then
            conn.disconnect_from(target)

            entity.surface.create_entity{
                name = "small-electric-pole-explosion", 
                position = entity.position
            }
        end
    end
end

function poles_manager.warn(entity)
    if not (entity and entity.valid) then return end
    
    local force = entity.force
    for _, player in pairs(force.players) do
        player.add_custom_alert(
            entity,
            {type="virtual", name = "signal-lightning"},
            "High load line",
            true
        )
    end

end

function poles_manager.on_nth_tick()
    local data = storage.electric_age
    if not data then return end

    local index = data.next
    for i = 1, cpt do
        local id, entity = next(data.list, index)

        if not id then
            index = nil
            break
        end

        index = id
        if entity and entity.valid then
            local result = poles_manager.check_overload(entity)
            if result == 1 then
                poles_manager.warn(entity)
            elseif result == 2 then
                poles_manager.disconnect(entity)
                break
            end
        else
            data.list[id] = nil
        end
    end

    data.next = index
end

return poles_manager
