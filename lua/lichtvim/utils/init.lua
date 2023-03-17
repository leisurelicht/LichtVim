local M = {}

-- delay notifications till vim.notify was replaced or after 500ms
function M.lazy_notify()
  local notifs = {}
  local function temp(...)
    table.insert(notifs, vim.F.pack_len(...))
  end

  local orig = vim.notify
  vim.notify = temp

  local timer = vim.loop.new_timer()
  local check = vim.loop.new_check()

  local replay = function()
    timer:stop()
    check:stop()
    if vim.notify == temp then
      vim.notify = orig -- put back the original notify if needed
    end
    vim.schedule(
      function()
        ---@diagnostic disable-next-line: no-unknown
        for _, notif in ipairs(notifs) do
          vim.notify(vim.F.unpack_len(notif))
        end
      end
    )
  end

  -- wait till vim.notify has been replaced
  check:start(
    function()
      if vim.notify ~= temp then
        replay()
      end
    end
  )
  -- or if it took more than 500ms, then something went wrong
  timer:start(500, 0, replay)
end

M.api = {}

M.api.autocmd = vim.api.nvim_create_autocmd

function M.api.augroup(name)
  return vim.api.nvim_create_augroup("lichtvim_" .. name, {clear = true})
end

M.table = {}

function M.table.merge(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" then
      if type(t1[k] or false) == "table" then
        table_merge(t1[k] or {}, t2[k] or {})
      else
        t1[k] = v
      end
    else
      t1[k] = v
    end
  end
  return t1
end

M.file = {}

function M.file.is_exist(file)
  return vim.fn.filereadable(file) == 1
end

function M.file.is_dir(file)
  return vim.fn.isdirectory(file) == 1
end

M.path = {}

function M.path.join(...)
  return table.concat(vim.tbl_flatten({...}), "/")
end

M.hi = {}

function M.hi.set(name, opts)
  local command = "highlight " .. name
  for k, v in pairs(opts) do
    if k ~= "gui" then
      command = command .. " gui" .. k .. "=" .. v
    else
      command = command .. " " .. k .. "=" .. v
    end
  end
  vim.cmd(command)
end

function M.hi.get(group, style)
  local opts = {}
  local output = vim.fn.execute("highlight " .. group)
  local lines = vim.fn.trim(output)
  for k, v in lines:gmatch("(%a+)=(#?%w+)") do
    opts[k] = v
  end
  if style ~= "gui" then
    return opts["gui" .. style]
  end
  return opts[style]
end

M.str = {}

function M.str.split(str, sep)
  local sep, fields = sep or ":", {}
  local pattern = string.format("([^%s]+)", sep)
  str:gsub(
    pattern,
    function(c)
      fields[#fields + 1] = c
    end
  )
  return fields
end

function M.str.first_upper(str)
  return str:sub(1, 1):upper() .. str:sub(2)
end

function M.str.starts_with(str, s)
  if #str < #s then
    return false
  end
  return str:sub(1, #s) == s
end

function M.str.ends_with(str, e)
  if #str < #e then
    return false
  end
  return str:sub(-(#e)) == e
end

M.sys = {}

function M.sys.IsMacOS()
  return vim.fn.has("mac")
end

function M.sys.IsLinux()
  -- return vim.fn.has("unix") and not fn.has("macunix") and not fn.has("win32unix")
  return vim.loop.os_uname().sysname() == "Linux"
end

function M.sys.IsWindows()
  -- return vim.fn.has("win16") or fn.has("win32") or fn.has("win64")
  return vim.loop.os_uname().sysname == "Windows_NT"
end

function M.sys.IsGUI()
  return vim.fn.has("gui_running")
end

function M.sys.IsNeovide()
  return vim.fn.exists("g:neovide")
end

return M
