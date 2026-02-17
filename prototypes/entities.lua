local entity = data.raw["lab"]["lab"]
entity.energy_usage = "350kW"
entity.energy_source.drain = "150kW"

entity = data.raw["mining-drill"]["electric-mining-drill"]
entity.energy_usage = "220kW"
entity.energy_source.drain = "80kW"

entity = data.raw["mining-drill"]["big-mining-drill"]
entity.energy_usage = "330kW"
entity.energy_source.drain = "170kW"

entity = data.raw["electric-pole"]["big-electric-pole"]
entity.supply_area_distance = 0
entity.auto_connect_up_to_n_wires = 2

entity = data.raw["electric-pole"]["substation"]
entity.supply_area_distance = 0
entity.auto_connect_up_to_n_wires = 20