local ae = peripheral.wrap("ae2cc_adapter_0")

-- getAvailableObjects()
-- { { type = string, id = string, displayName = string, amount = number }... }
local availableObjects = ae.getAvailableObjects()

local all_items_count = 0

for i = 1, #availableObjects do
  local obj = availableObjects[i]
  all_items_count = all_items_count + obj.amount
  print("Amount: " .. all_items_count)
end

print("")
print("Final all items count: " .. all_items_count)