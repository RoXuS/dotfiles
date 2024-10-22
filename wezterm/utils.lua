local M = {}

-- Assigns all key-value pairs from the second table to the first table
function M.object_assign(t1, t2)
  for key, value in pairs(t2) do
    t1[key] = value
  end
  return t1
end

-- Splits a file path into individual components using '/' or '\\' as separators
function M.parse_path(stringPath)
  local parts = {}
  for part in string.gmatch(stringPath, "[^/\\]+") do
    table.insert(parts, part)
  end
  return parts
end

-- Checks if the path_b is a subpath or the same as the path_a
function M.is_subpath(path_a, path_b)
  local a_parts = M.parse_path(path_a)
  local b_parts = M.parse_path(path_b)

  if #a_parts > #b_parts then
    return false
  end

  -- Ensure all components match in sequence
  for i = 1, #a_parts do
    if a_parts[i] ~= b_parts[i] then
      return false
    end
  end

  return true
end

return M
