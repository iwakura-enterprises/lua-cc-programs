-- Sugar Cane Software 1.1
-- Made by Iwakura Enterprises
--  for Natali // Shrimp Bank International

local monitor = peripheral.find("monitor")

function count_sugar()
  local peripherals = peripheral.getNames()

  for _, name in ipairs(peripherals) do
    print(name)
  end

  local chest_0 = peripheral.wrap("mythicmetals_decorations:mythic_chest_0")
  local chest_1 = peripheral.wrap("mythicmetals_decorations:mythic_chest_1")

  local inv_0 = chest_0.list()
  local inv_1 = chest_1.list()

  local count_all_sugar = 0

  for slot, item in pairs(inv_0) do
    count_all_sugar = count_all_sugar + item.count
  --  print(("%d x %s in slot %d"):format(item.count, item.name, slot))
  end

  for slot, item in pairs(inv_1) do
    count_all_sugar = count_all_sugar + item.count
  end

  monitor.clear()
  monitor.setCursorPos(1, 1)
  monitor.write("= Shrimp Bank International =")
  monitor.setCursorPos(1, 2)
  monitor.write("Current Balance: ")
  monitor.setCursorPos(5, 3)
  monitor.write("" .. count_all_sugar .. " sugar canes")
  monitor.setCursorPos(1, 4)
  -- monitor.write("     - Keeping you afloat //")
  monitor.setCursorPos(1, 5)
  monitor.write("// we are keeping you afloat.")
  sleep(1)
end

while true do
  count_sugar()
end