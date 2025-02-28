local Event = require 'utils.event'

local Public = {}

local info = [[This is the wasteland. Who will survive?

In this mode, players build towns and fight against other towns and the biters.
The Comfy gui has been disabled since it contains too many goodies.

Have fun and be comfy ^.^]]

local info_adv =
    [[
# Changelog (10th Aug 2023):
 - Fixed that the map now has a random seed upon reset
 - Fixed automatic server reset
 - Fixed player spawn issue
 - Fixed map random seed
 - Made tank and car extremely rare to get via scrap
 - Suicide command has been added. The poison pill will kill the character after 3 minutes
 - Game will automatically reset whenever a town reaches 48h of survival time
 - PvP Shield has been removed
 - Combat balance overhaul (see "Bonuses" button top right to check modifiers)
 - Town player limit fixes
 - Improved base defenses and offline survivability
 - Loads of bugfixes including freezes and desyncs

# Goal of the game
Survive as long as you can. Raid other towns. Defend your town.

# Advanced tips and tricks
- It's best to found new towns far from existing towns, as enemies will become aggressive with town's research.
    Biters and spitters become more aggressive towards towns that are advanced in research.
    Their evolution will scale around technology progress in any nearby towns and pollution levels.
- How to get more ores? Make sure you researched steel processing,
    then hand mine a few big rocks to find ore patches under them!
- How to get more oil? Kill worms - some of them will leave you an oil patch
- The town market is the heart of your town. If it is destroyed, you lose everything.
    So protect it well, repair it whenever possible, and increase its health by purchasing upgrades.
- It's possible to automate trading with the town center! How cool is that?!! Try it out.
    Tip: use filter inserters with to get coins/iron/.. out of the market
- Fishes procreate near towns. The more fishes, the quicker they multiply. Automated fish farm, anyone?
- Use /rename-town NEWNAME (chat command) to rename your town

# Town members and alliances
- Once a town is formed, members may invite other players and teams using a coin. To invite another player, drop a coin
on that player (with the Z key). To accept an invite, offer a coin in return to the member. To leave a town, simply drop coal
on the market.
- To form any alliance with another town, drop a coin on a member or their market. If they agree they can reciprocate with a
coin offering.]]

function Public.toggle_button(player)
    if player.gui.top['towny_map_intro_button'] then
        return
    end
    local b = player.gui.top.add({type = 'sprite-button', caption = 'Info', name = 'towny_map_intro_button', tooltip = 'Show Info'})
    b.style.font_color = {r = 0.5, g = 0.3, b = 0.99}
    b.style.font = 'heading-1'
    b.style.minimal_height = 38
    b.style.minimal_width = 80
    b.style.top_padding = 1
    b.style.left_padding = 1
    b.style.right_padding = 1
    b.style.bottom_padding = 1
end

function Public.show(player, info_type)
    if player.gui.center['towny_map_intro_frame'] then
        player.gui.center['towny_map_intro_frame'].destroy()
    end
    local frame = player.gui.center.add {type = 'frame', name = 'towny_map_intro_frame'}
    frame = frame.add {type = 'frame', direction = 'vertical'}

    local t = frame.add {type = 'table', column_count = 2}

    local label = t.add {type = 'label', caption = 'COMFY Towny: Wasteland survival'}
    label.style.font = 'heading-1'
    label.style.font_color = {r = 0.85, g = 0.85, b = 0.85}
    label.style.right_padding = 8

    frame.add {type = 'line'}
    local cap = info
    if info_type == 'adv' then
        cap = info_adv
    end
    local l2 = frame.add {type = 'label', caption = cap}
    l2.style.single_line = false
    l2.style.font = 'heading-2'
    l2.style.font_color = {r = 0.8, g = 0.7, b = 0.99}
end

function Public.close(event)
    if not event.element then
        return
    end
    if not event.element.valid then
        return
    end
    local parent = event.element.parent
    for _ = 1, 4, 1 do
        if not parent then
            return
        end
        if parent.name == 'towny_map_intro_frame' then
            parent.destroy()
            return
        end
        parent = parent.parent
    end
end

function Public.toggle(event)
    if not event.element then
        return
    end
    if not event.element.valid then
        return
    end
    if event.element.name == 'towny_map_intro_button' then
        local player = game.players[event.player_index]
        if player.gui.center['towny_map_intro_frame'] then
            player.gui.center['towny_map_intro_frame'].destroy()
        else
            Public.show(player, 'adv')
        end
    end
end

local function on_gui_click(event)
    Public.close(event)
    Public.toggle(event)
end

Event.add(defines.events.on_gui_click, on_gui_click)

return Public
