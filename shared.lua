local function applyProps(entity, usage, source)
    entity.energy_usage = usage
    entity.energy_source = source
end

return {
    applyProps = applyProps
}