local responses = {
    'Did you know rocks are hard? ',
    'Hell yeah, you hit that rock real hard',
    'Is that how you hold a pickaxe?',
    'Only an iron pickaxe? What a pleb',
    '*insert_mincraft_reference_dont_forget*',
}

local response = responses[math.random(1, #responses)]
local tx1 = { id = 'mined', title = "Rock Mined", description = response }
local tx2 = { id = 'not_mined', title = "Mining Stopped", description = 'You stopped mining the rock' }

local rocks = {
    'cs_x_rublrge', 'cs_x_rublrgd', 'cs_x_rublrga'
}

local loc = {
    [1] = vec3(2951.349, 2732.997, 44.641), [2] = vec3(2974.869, 2781.313, 38.825),
    [3] = vec3(2945.104, 2772.254, 39.206), [4] = vec3(2927.815, 2799.937, 41.329),
    [5] = vec3(3025.864, 2764.761, 55.415), [6] = vec3(2952.192, 2699.734, 54.939),
    [7] = vec3(3054.195, 2729.955, 63.930), [8] = vec3(3025.157, 2877.916, 85.523),
    [9] = vec3(3025.941, 2992.944, 72.004), [10] = vec3(2983.627, 2869.067, 61.114),
    [11] = vec3(3022.759, 3033.391, 90.390), [12] = vec3(2966.989, 2802.650, 41.408)
}

local minerock = function()
    if lib.progressBar({
        duration = World.Mining.duration, label = 'Mining Rock',
        useWhileDead = false, canCancel = true,
        disable = {
            car = true, move = true
        },
        anim = {
            blendIn = 3.0, dict = 'melee@large_wpn@streamed_core',
            clip = 'ground_attack_on_spot', blendOut = 3.0,
        },
        prop = {
            bone = 57005,
            model = `prop_tool_pickaxe`,
            pos = vec3(0.0, -0.20, -0.05),
            rot = vec3(80.0, -20.0, 175.0)
        },
    }) then
        DoNotif(tx1, Cor)
        local chance = math.random(1, 99)
        if chance <= 70 then
            lib.callback.await('miit:give:mining:reward')
        else
            lib.callback.await('miit:give:mining:reward')
            lib.callback.await('miit:give:mining:bonus')
        end
    else
        DoNotif(tx2, War)
    end
end

local options = {
    {
        name = 'mining', icon = 'fa-solid fa-hammer',
        label = locale('side_obtn_rock'),
        --items = 'tirekit',
        canInteract = function(_, distance)
            return distance < 2.0
        end,
        onSelect = function(data)
            local object = data.entity
            if Debug then lib.print.info('Rock: '..object) end
            minerock()
        end
    },
}

local load_rocks = function()
    for _, rock in pairs(loc) do
        -- load model
        local model = rocks[math.random(1, #rocks)]
        lib.requestModel(model, 500)
        -- create object
        local object = CreateObject(model, rock.x, rock.y, rock.z, true, true, false)
        local head = math.random(45,235)
        SetObject(object, head)
        -- set entity
        Target:addLocalEntity(object, options)
        -- log for debug
        if Debug then lib.print.info('Loaded:Mine:Obj: '..object) end
    end
end

RegisterNetEvent('miit:c:mining:load:rocks')
AddEventHandler('miit:c:mining:load:rocks', function()
    --load_rocks()
end)

TriggerServerEvent('miit:s:mining:load:rocks')