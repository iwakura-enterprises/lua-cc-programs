local ae = peripheral.wrap("ae2cc_adapter_0")

-- getAvailableObjects()
-- { { type = string, id = string, displayName = string, amount = number }... }
local availableObjects = ae.getAvailableObjects()

for i = 1, #availableObjects do
  local obj = availableObjects[i]
  print("Type: " .. obj.type)
  print("ID: " .. obj.id)
  print("Display Name: " .. obj.displayName)
  print("Amount: " .. obj.amount)
  sleep(1)
end