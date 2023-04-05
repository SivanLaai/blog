---
title: nvim下混合编译调试Dreamplace源码
date: 2023-04-05T19:08:19+08:00
draft: false
categories:
 - 调试
tags:
---

## 安装插件

- 前置需要安装NvChad

### 引入插件
```lua
    {
      lazy = false,
      "rcarriga/nvim-dap-ui",
      dependencies = {
        {
          "mfussenegger/nvim-dap",
          config = function()
            return require("custom.configs.dap.init")      Annotations specify that at most 0 return value(s) are required, found 1 to 2 returned here instead.
          end,
        },
      },
    },
```
### 配置插件
- C++调试配置
```lua
-- c++配置
-- file:dap/cppdbg.lua
local dap  = require("dap")
local function isempty(s)
        return s == nil or s == ""
end
dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = '~/.local/share/nvim/mason/bin/OpenDebugAD7',
}
dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = true,
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'cppdbg',
    request = 'launch',
    MIMode = 'gdb',
    miDebuggerServerAddress = 'localhost:1234',
    miDebuggerPath = '/usr/bin/gdb',
    cwd = '${workspaceFolder}',
    args = function()
      return {vim.fn.input('Parameters to executable: ', vim.fn.getcwd() .. '/', 'file')}
    end,
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
  },
}
```

- 调试初始化
```lua
-- c++配置
-- file:dap/init.lua
local dap, dapui = require("dap"), require("dapui")

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

require("custom.configs.dap.cppdbg")
```
- 调试快捷键配置
```lua
M.Debug = {
  n = {
    ["<F5>"] = { ':lua require("dap").continue()<CR>', "debug: run/continue" },
    ["<F7>"] = { ':lua require("dap").toggle_breakpoint()<CR>', "debug: toggle breakpoint" },
    ["<F8>"] = { ':lua require("dap").terminate() require("dapui").close()<CR>', "debug: stop" },
    ["<F9>"] = { ':lua require("dap").step_into()<CR>', "debug: step into" },
    ["<F10>"] = { ':lua require("dap").step_out()<CR>', "debug: step out" },
    ["<F11>"] = { ':lua require("dap").step_over()<CR>', "debug: step out" },
    ["<leader>db"]= { ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', "debug: Set breakpoint with condition" },
    ["<leader>dc"]= { ':lua require("dap").run_to_cursor()<CR>', "debug: run to cursor" },
    ["<leader>dl"]= { ':lua require("dap").run_last()<CR>', "debug: run last" },
    ["<leader>do"]= { ':lua require("dap").repl.open()<CR>', "debug: open REPL" },
  },
}
```


## 调试源码

### 启动GDBServer

```bash
gdbserver localhost:1234 ~/anaconda3/bin/python unittest/ops/lpabs_wirelength_unittest.py
```

### Neovim连接GDBServer

- 按F5进入调试运行模式，选2回车

![image.png](https://cdn.staticaly.com/gh/SivanLaai/image-store-rep@master/note/20230405192735.png)

- 输入运行参数回车

![image.png](https://cdn.staticaly.com/gh/SivanLaai/image-store-rep@master/note/20230405193133.png)


- 输入对应的python路径回车

![image.png](https://cdn.staticaly.com/gh/SivanLaai/image-store-rep@master/note/20230405193213.png)

### 调试界面

显示如下则成功进入调试模式：

![image.png](https://cdn.staticaly.com/gh/SivanLaai/image-store-rep@master/note/20230405194205.png)
