local SUB_LIMIT = 200000 -- 12MW / 60 ticks = 200,000 J/tick

local quality_multipliers = {
    ["normal"] = 1.0,      -- 12 MW
    ["uncommon"] = 1.3,    -- 15.6 MW
    ["rare"] = 1.7,        -- 20.4 MW
    ["epic"] = 2.5,        -- 30 MW
    ["legendary"] = 5.0    -- 60 MW
}

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
    if entity.name ~= "substation" then return end

    storage.electric_age.list[entity.unit_number] = {pole = entity}
end

function poles_manager.unreg(id)
    local entry = storage.electric_age.list[id]
    if entry then
        storage.electric_age.list[id] = nil
    end
end

function poles_manager.check_overload(pole)
    if not (pole and pole.valid) then return -1 end

    local statistics = pole.electric_network_statistics
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

    local rate = network / (SUB_LIMIT * quality_multipliers[pole.quality])
    return rate > 1
end

function poles_manager.apply_overheat_damage(entity)
    if not (entity and entity.valid) then return end
    
    local surface = entity.surface
    local pos = entity.position

    surface.create_entity{
        name = "fire-flame",
        position = pos,
        initial_ground_flame_count = 5
    }
end

function poles_manager.on_nth_tick()
    local data = storage.electric_age
    if not data then return end

    local index = data.next
    for i = 1, cpt do
        local id, entry = next(data.list, index)

        if not id then
            index = nil
            break
        end

        index = id
        local pole = entry.pole

        if pole and pole.valid then
            local yes = poles_manager.check_overload(pole)
            if yes then
                poles_manager.apply_overheat_damage(pole)
            end
        else
            poles_manager.unreg(id)
        end
    end

    data.next = index
end

return poles_manager