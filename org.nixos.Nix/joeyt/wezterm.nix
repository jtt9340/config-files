{ wezterm }:

let
  patchedWezterm = wezterm.overrideAttrs {
    patchPhase = ''
      runHook prePatch
      sed -i 's/^Exec=/Exec=env XCURSOR_THEME=Adwaita /' assets/wezterm.desktop
      runHook postPatch
    '';
  };
in
{
  enable = true;
  package = patchedWezterm;
  extraConfig = ''
    local config = wezterm.config_builder()

    function capitalize(s)
      return string.upper(string.sub(s, 0, 1)) .. string.sub(s, 2)
    end

    -- Appearance
    local one_dark = wezterm.color.get_builtin_schemes()['One Dark (Gogh)']
    one_dark.foreground = 'lightgray'

    config.color_schemes = {
      ["Joey's One Dark"] = one_dark
    }

    config.color_scheme = "Joey's One Dark"
    config.font_size = 11
    config.warn_about_missing_glyphs = false

    config.enable_scroll_bar = true

    -- Keybindings
    local is_vim = {
      gview = true,
      view = true,
      lvim = true,
      nvim = true,
      vim = true,
      vi = true,
      vimdiff = true,
      gvimdiff = true,
      ['.vim-wrapped'] = true,
    }

    local keys = {
      {
        key = 'h',
        direction = 'left'
      },
      {
        key = 'j',
        direction = 'down'
      },
      {
        key = 'k',
        direction = 'up'
      },
      {
        key = 'l',
        direction = 'right'
      }
    }

    for _, key in ipairs(keys) do
      wezterm.on('select-pane-' .. key.direction, function(window, pane)
        local prog = pane:get_user_vars()['WEZTERM_PROG']
        if is_vim[prog] then
          window:perform_action(
            wezterm.action.Multiple {
              weztern.action.SendKey {
                key = 'w',
                mods = 'CTRL'
              },
              wezterm.action.SendKey {
                key = key.key,
              }
            },
            pane
          )
        else
          window:perform_action(
            wezterm.action.ActivatePaneDirection(capitalize(key.direction)),
            pane
          )
        end
      end)
    end

    config.keys = {
      {
        key = 'w',
        mods = 'CTRL',
        action = wezterm.action.ActivateKeyTable {
          name = 'leader',
          one_shot = false,
          timeout_milliseconds = 500
        }
      }
    }

    config.key_tables = {
      leader = {
        {
          key = 'h',
          action = wezterm.action.EmitEvent('select-pane-left')
        },
        {
          key = 'j',
          action = wezterm.action.EmitEvent('select-pane-down')
        },
        {
          key = 'k',
          action = wezterm.action.EmitEvent('select-pane-up')
        },
        {
          key = 'l',
          action = wezterm.action.EmitEvent('select-pane-right')
        },
        {
          key = 'h',
          mods = 'SHIFT',
          action = wezterm.action.AdjustPaneSize {'Left', 1},
        },
        {
          key = 'j',
          mods = 'SHIFT',
          action = wezterm.action.AdjustPaneSize {'Down', 1},
        },
        {
          key = 'k',
          mods = 'SHIFT',
          action = wezterm.action.AdjustPaneSize {'Up', 1},
        },
        {
          key = 'l',
          mods = 'SHIFT',
          action = wezterm.action.AdjustPaneSize {'Right', 1},
        },
        {
          key = '[',
          action = wezterm.action.ActivateCopyMode
        },
        {
          key = ']',
          action = wezterm.action.PasteFrom('PrimarySelection')
        },
        {
          key = 'v',
          action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
        },
        {
          key = 'g',
          action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
        },
        {
          key = 'd',
          action = wezterm.action.DetachDomain('CurrentPaneDomain')
        },
        {
          key = 'z',
          action = wezterm.action.TogglePaneZoomState
        },
        {
          key = 'x',
          action = wezterm.action.CloseCurrentPane { confirm = true },
        },
        {
          key = 'w',
          action = wezterm.action.SendKey {
            key = 'w',
            mods = 'CTRL'
          },
        },
        {
          key = ',',
          action = wezterm.action.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(function(window, pane, line)
              if line and #line > 0 then
                window:active_tab():set_title(line)
              end
            end)
          }
        }
      }
    }

    -- Multiplexing
    config.unix_domains = {
      {
        name = 'unix'
      }
    }

    config.ssh_domains = {
      {
        name = 'rit',
        remote_address = 'pinkfloyd.cs.rit.edu',
        username = 'jtt9340'
      }
    }

    config.default_domain = 'unix'

    return config
  '';
}
