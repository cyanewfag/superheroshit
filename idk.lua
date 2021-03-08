local curTime = globalvars.curtime;
local localPlayer = entitylist.get_localplayer();

local hitFont = renderer.create_font("Broadway", 18, true);

local hits = {};
local hitWords = {"OWNED", "OOF", "SMASH", "BOOM"};
local wordColors = {color.new(35, 70, 226), color.new(49, 124, 225), color.new(217, 226, 0), color.new(65, 222, 91), color.new(221, 124, 30)};

function on_render()
    localPlayer = entitylist.get_localplayer();
    curTime = globalvars.curtime;
    local removals = {};

    if (localPlayer) then
        if (#hits > 0) then
            for i = 1, #hits do
                local percent = (curTime - hits[i][1]) / 1;
                if (percent >= 1) then table.insert(removals, i); end
                local height = 35 * percent;

                local position2D = utils.world_to_screen(vector.new(hits[i][2].x, hits[i][2].y, hits[i][2].z + height));

                renderer.text_centered(position2D.x, position2D.y, hits[i][4], true, true, hits[i][3], hitFont);
            end
        end
    end

    if (#removals > 0) then
        for i = 1, #removals do
            table.remove(hits, #removals);
        end
    end
end

function on_gameevent(e)
    if (e:get_name() == "player_hurt") then
        local hitEnt = entitylist.get_entity_from_userid(e:get_int("userid"));
        local attackerEnt = entitylist.get_entity_from_userid(e:get_int("attacker"));
        localPlayer = entitylist.get_localplayer();

        if (attackerEnt == localPlayer) then
            if (hitEnt and attackerEnt and localPlayer) then
                local entityVec = hitEnt:get_hitbox(e:get_int("hitgroup"));
                local heightValue = entityVec.z + math.random(-8, 8);

                table.insert(hits, {globalvars.curtime, vector.new(entityVec.x, entityVec.y, heightValue), wordColors[math.random(1, #wordColors)], hitWords[math.random(1, #hitWords)]});
            end
        end
    end
end
