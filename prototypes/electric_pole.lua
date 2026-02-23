local function create_pole_drain(size, consumption)
    return {
        type = "electric-energy-interface",
        name = size .. "-electric-pole-drain",
        icon = "__base__/graphics/icons/" .. size .. "-electric-pole.png",
        icon_size = 64,
        flags = {"not-on-map", "placeable-off-grid", "not-blueprintable", "hide-alt-info", "not-deconstructable"},
        collision_mask = {layers = {}},
        selection_box = nil,
        selectable_in_game = false,
        energy_source = {
            type = "electric",
            usage_priority = "primary-input",
            buffer_capacity = consumption,
            render_no_power_icon = false
        },
        energy_usage = consumption,
        gui_mode = "none",
        allow_copy_paste = false
    }
end

data:extend({
    create_pole_drain("small", "1kW"),
    create_pole_drain("medium", "3kW"),
    create_pole_drain("big", "5kW")
})

local entity = data.raw["electric-pole"]["small-electric-pole"]
entity.supply_area_distance = 0

entity = data.raw["electric-pole"]["medium-electric-pole"]
entity.supply_area_distance = 0

entity = data.raw["electric-pole"]["big-electric-pole"]
entity.supply_area_distance = 0