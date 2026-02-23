local entity = data.raw["lab"]["lab"]
entity.energy_usage = "350kW"
entity.energy_source.drain = "150kW"

entity = data.raw["mining-drill"]["electric-mining-drill"]
entity.energy_usage = "220kW"
entity.energy_source.drain = "80kW"

entity = data.raw["mining-drill"]["big-mining-drill"]
entity.energy_usage = "330kW"
entity.energy_source.drain = "170kW"

entity = data.raw["mining-drill"]["pumpjack"]
entity.energy_usage = "220kW"
entity.energy_source.drain = "80kW"

entity = data.raw["furnace"]["electric-furnace"]
entity.energy_usage = "1800kW"
entity.energy_source.drain = "200kW"

entity = data.raw["assembling-machine"]["assembling-machine-1"]
entity.energy_usage = "70kW"
entity.energy_source.drain = "30kW"

entity = data.raw["assembling-machine"]["assembling-machine-2"]
entity.energy_usage = "200kW"
entity.energy_source.drain = "50kW"

entity = data.raw["assembling-machine"]["assembling-machine-3"]
entity.energy_usage = "330kW"
entity.energy_source.drain = "120kW"

entity = data.raw["assembling-machine"]["oil-refinery"]
entity.energy_usage = "3500kW"
entity.energy_source.drain = "1200kW"

entity = data.raw["assembling-machine"]["chemical-plant"]
entity.energy_usage = "350kW"
entity.energy_source.drain = "250kW"