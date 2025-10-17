local opened = false
local PreviousComponent = {}
local PreviousTexture = {}
local PreviousTorso = {}

-- Abrir menu
RegisterCommand(Config.Command, function()
    if not opened then
        opened = true
        SendNUIMessage({
            action = 'show',
            translations = Locales
        })
        SetNuiFocus(true, true)
    end
end)

RegisterKeyMapping(Config.Command, 'Abrir Menu de Roupa', 'keyboard', Config.KeyToOpen)

-- Desativa controles enquanto menu aberto
CreateThread(function()
    while true do
        Wait(0)
        if opened then
            -- Desativa controles comuns
            for _, control in ipairs({1,2,3,4,5,6,263,264,257,140,141,142,143,177,200,202,322,245,37,261,262}) do
                DisableControlAction(0, control, true)
            end
            HideHudComponentThisFrame(19)
            DisablePlayerFiring(PlayerId(), true)
        end
    end
end)

-- Fechar menu
RegisterNUICallback('close', function()
    SendNUIMessage({ action = 'hide' })
    SetNuiFocus(false, false)
    opened = false
end)

-- Pega gênero do ped
function GetPedGender(playerPed)
    local male = GetHashKey("mp_m_freemode_01")
    local female = GetHashKey("mp_f_freemode_01")
    local gender = GetEntityModel(playerPed)
    if gender == male then return 'male'
    elseif gender == female then return 'female' end
end

-- Função auxiliar para tocar animação
function PlayAnim(item)
    local playerPed = PlayerPedId()
    local dict, anim, move = '', '', 51

    if item == 'shirt' then dict, anim = 'missmic4', 'michael_tux_fidget'
    elseif item == 'pants' then dict, anim = 're@construction', 'out_of_breath'
    elseif item == 'shoes' then dict, anim = 'random@domestic', 'pickup_low'; move = 0
    elseif item == 'jewelry' then dict, anim = 'clothingtie', 'try_tie_positive_a'
    elseif item == 'glasses' then dict, anim = 'clothingspecs', 'take_off'
    elseif item == 'watch' then dict, anim = 'nmt_3_rcm-10', 'cs_nigel_dual-10'
    elseif item == 'vest' then dict, anim = 'clothingtie', 'try_tie_negative_a'
    elseif item == 'mask' then dict, anim = 'mp_masks@standard_car@ds@', 'put_on_mask'
    elseif item == 'ear' then dict, anim = 'mp_cp_stolen_tut', 'b_think'
    elseif item == 'hat' then dict, anim = 'mp_masks@standard_car@ds@', 'put_on_mask'
    elseif item == 'bag' then dict, anim = 'anim@heists@ornate_bank@grab_cash', 'intro'
    elseif item == 'gloves' then dict, anim = 'nmt_3_rcm-10', 'cs_nigel_dual-10' end

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(100) end
    TaskPlayAnim(playerPed, dict, anim, 3.0, 3.0, 1500, move, 0, false, false, false)
    Wait(1500)
end

-- Selecionar item do menu
RegisterNUICallback('select', function(data)
    local playerPed = PlayerPedId()
    local item = data.item

    if PreviousComponent[item] == nil then
        -- Tirar item
        if item == 'shirt' then
            PreviousComponent[item] = GetPedDrawableVariation(playerPed, 11)
            PreviousTexture[item] = GetPedTextureVariation(playerPed, 11)
            PreviousTorso[item] = GetPedDrawableVariation(playerPed, 3)
            PlayAnim(item)
            if GetPedGender(playerPed) == 'male' then
                SetPedComponentVariation(playerPed, 11, Config.TakeOff.male.shirt, 0, 2)
                SetPedComponentVariation(playerPed, 8, 15, 0, 2)
                SetPedComponentVariation(playerPed, 3, 15, 0, 2)
            else
                SetPedComponentVariation(playerPed, 11, Config.TakeOff.female.shirt, 0, 2)
                SetPedComponentVariation(playerPed, 8, 15, 0, 2)
                SetPedComponentVariation(playerPed, 3, 15, 0, 2)
            end
        elseif item == 'pants' then
            PreviousComponent[item] = GetPedDrawableVariation(playerPed, 4)
            PreviousTexture[item] = GetPedTextureVariation(playerPed, 4)
            PlayAnim(item)
            if GetPedGender(playerPed) == 'male' then
                SetPedComponentVariation(playerPed, 4, Config.TakeOff.male.pants, 0, 2)
            else
                SetPedComponentVariation(playerPed, 4, Config.TakeOff.female.pants, 0, 2)
            end
        elseif item == 'shoes' then
            PreviousComponent[item] = GetPedDrawableVariation(playerPed, 6)
            PreviousTexture[item] = GetPedTextureVariation(playerPed, 6)
            PlayAnim(item)
            if GetPedGender(playerPed) == 'male' then
                SetPedComponentVariation(playerPed, 6, Config.TakeOff.male.shoes, 0, 2)
            else
                SetPedComponentVariation(playerPed, 6, Config.TakeOff.female.shoes, 0, 2)
            end
        elseif item == 'jewelry' then
            PreviousComponent[item] = GetPedDrawableVariation(playerPed, 7)
            PreviousTexture[item] = GetPedTextureVariation(playerPed, 7)
            PlayAnim(item)
            if GetPedGender(playerPed) == 'male' then
                SetPedComponentVariation(playerPed, 7, Config.TakeOff.male.jewelry, 0, 2)
            else
                SetPedComponentVariation(playerPed, 7, Config.TakeOff.female.jewelry, 0, 2)
            end
        elseif item == 'glasses' then
            PreviousComponent[item] = GetPedPropIndex(playerPed, 1)
            PreviousTexture[item] = GetPedPropTextureIndex(playerPed, 1)
            PlayAnim(item)
            if GetPedGender(playerPed) == 'male' then
                SetPedPropIndex(playerPed, 1, Config.TakeOff.male.glasses, 0, false)
            else
                SetPedPropIndex(playerPed, 1, Config.TakeOff.female.glasses, 0, false)
            end
        elseif item == 'watch' then
            PreviousComponent[item] = GetPedPropIndex(playerPed, 6)
            PreviousTexture[item] = GetPedPropTextureIndex(playerPed, 6)
            PlayAnim(item)
            if GetPedGender(playerPed) == 'male' then
                SetPedPropIndex(playerPed, 6, Config.TakeOff.male.watch, 0, false)
            else
                SetPedPropIndex(playerPed, 6, Config.TakeOff.female.watch, 0, false)
            end
        elseif item == 'vest' then
            PreviousComponent[item] = GetPedDrawableVariation(playerPed, 9)
            PreviousTexture[item] = GetPedTextureVariation(playerPed, 9)
            PlayAnim(item)
            if GetPedGender(playerPed) == 'male' then
                SetPedComponentVariation(playerPed, 9, Config.TakeOff.male.vest, 0, 2)
            else
                SetPedComponentVariation(playerPed, 9, Config.TakeOff.female.vest, 0, 2)
            end
        elseif item == 'mask' then
            PreviousComponent[item] = GetPedDrawableVariation(playerPed, 1)
            PreviousTexture[item] = GetPedTextureVariation(playerPed, 1)
            PlayAnim(item)
            if GetPedGender(playerPed) == 'male' then
                SetPedComponentVariation(playerPed, 1, Config.TakeOff.male.mask, 0, 2)
            else
                SetPedComponentVariation(playerPed, 1, Config.TakeOff.female.mask, 0, 2)
            end
        elseif item == 'ear' then
            PreviousComponent[item] = GetPedPropIndex(playerPed, 2)
            PreviousTexture[item] = GetPedPropTextureIndex(playerPed, 2)
            PlayAnim(item)
            ClearPedProp(playerPed, 2)
        elseif item == 'hat' then
            PreviousComponent[item] = GetPedPropIndex(playerPed, 0)
            PreviousTexture[item] = GetPedPropTextureIndex(playerPed, 0)
            PlayAnim(item)
            if GetPedGender(playerPed) == 'male' then
                SetPedPropIndex(playerPed, 0, Config.TakeOff.male.hat, 0, false)
            else
                SetPedPropIndex(playerPed, 0, Config.TakeOff.female.hat, 0, false)
            end
        elseif item == 'bag' then
            PreviousComponent[item] = GetPedDrawableVariation(playerPed, 5)
            PreviousTexture[item] = GetPedTextureVariation(playerPed, 5)
            PlayAnim(item)
            if GetPedGender(playerPed) == 'male' then
                SetPedComponentVariation(playerPed, 5, Config.TakeOff.male.bag, 0, 2)
            else
                SetPedComponentVariation(playerPed, 5, Config.TakeOff.female.bag, 0, 2)
            end
        elseif item == 'gloves' then
            if GetPedDrawableVariation(playerPed, 3) > 15 then
                PreviousComponent[item] = GetPedDrawableVariation(playerPed, 3)
                PreviousTexture[item] = GetPedTextureVariation(playerPed, 3)
                PlayAnim(item)
                if GetPedGender(playerPed) == 'male' then
                    SetPedComponentVariation(playerPed, 3, Config.TakeOff.male.gloves, 0, 2)
                else
                    SetPedComponentVariation(playerPed, 3, Config.TakeOff.female.gloves, 0, 2)
                end
            end
        end
    else
        -- Restaurar item anterior
        if item == 'shirt' then
            PlayAnim(item)
            SetPedComponentVariation(playerPed, 11, PreviousComponent[item], PreviousTexture[item], 2)
            SetPedComponentVariation(playerPed, 3, PreviousTorso[item], 0, 2)
        elseif item == 'pants' then
            PlayAnim(item)
            SetPedComponentVariation(playerPed, 4, PreviousComponent[item], PreviousTexture[item], 2)
        elseif item == 'shoes' then
            PlayAnim(item)
            SetPedComponentVariation(playerPed, 6, PreviousComponent[item], PreviousTexture[item], 2)
        elseif item == 'jewelry' then
            PlayAnim(item)
            SetPedComponentVariation(playerPed, 7, PreviousComponent[item], PreviousTexture[item], 2)
        elseif item == 'glasses' then
            PlayAnim(item)
            SetPedPropIndex(playerPed, 1, PreviousComponent[item], PreviousTexture[item], false)
        elseif item == 'watch' then
            PlayAnim(item)
            SetPedPropIndex(playerPed, 6, PreviousComponent[item], PreviousTexture[item], false)
        elseif item == 'vest' then
            PlayAnim(item)
            SetPedComponentVariation(playerPed, 9, PreviousComponent[item], PreviousTexture[item], 2)
        elseif item == 'mask' then
            PlayAnim(item)
            SetPedComponentVariation(playerPed, 1, PreviousComponent[item], PreviousTexture[item], 2)
        elseif item == 'ear' then
            PlayAnim(item)
            SetPedPropIndex(playerPed, 2, PreviousComponent[item], PreviousTexture[item], false)
        elseif item == 'hat' then
            PlayAnim(item)
            SetPedPropIndex(playerPed, 0, PreviousComponent[item], PreviousTexture[item], false)
        elseif item == 'bag' then
            PlayAnim(item)
            SetPedComponentVariation(playerPed, 5, PreviousComponent[item], PreviousTexture[item], 2)
        elseif item == 'gloves' then
            PlayAnim(item)
            SetPedComponentVariation(playerPed, 3, PreviousComponent[item], PreviousTexture[item], 2)
        end
        PreviousComponent[item] = nil
        PreviousTexture[item] = nil
        PreviousTorso[item] = nil
    end
end)

-- Resetar todos os itens
RegisterNUICallback('reset', function(data, cb)
    local playerPed = PlayerPedId()
    for k,_ in pairs(PreviousComponent) do
        if k == 'shirt' then
            SetPedComponentVariation(playerPed, 11, PreviousComponent[k], PreviousTexture[k], 2)
            SetPedComponentVariation(playerPed, 3, PreviousTorso[k], 0, 2)
        elseif k == 'pants' then
            SetPedComponentVariation(playerPed, 4, PreviousComponent[k], PreviousTexture[k], 2)
        elseif k == 'shoes' then
            SetPedComponentVariation(playerPed, 6, PreviousComponent[k], PreviousTexture[k], 2)
        elseif k == 'jewelry' then
            SetPedComponentVariation(playerPed, 7, PreviousComponent[k], PreviousTexture[k], 2)
        elseif k == 'glasses' then
            SetPedPropIndex(playerPed, 1, PreviousComponent[k], PreviousTexture[k], false)
        elseif k == 'watch' then
            SetPedPropIndex(playerPed, 6, PreviousComponent[k], PreviousTexture[k], false)
        elseif k == 'vest' then
            SetPedComponentVariation(playerPed, 9, PreviousComponent[k], PreviousTexture[k], 2)
        elseif k == 'mask' then
            SetPedComponentVariation(playerPed, 1, PreviousComponent[k], PreviousTexture[k], 2)
        elseif k == 'ear' then
            SetPedPropIndex(playerPed, 2, PreviousComponent[k], PreviousTexture[k], false)
        elseif k == 'hat' then
            SetPedPropIndex(playerPed, 0, PreviousComponent[k], PreviousTexture[k], false)
        elseif k == 'bag' then
            SetPedComponentVariation(playerPed, 5, PreviousComponent[k], PreviousTexture[k], 2)
        elseif k == 'gloves' then
            SetPedComponentVariation(playerPed, 3, PreviousComponent[k], PreviousTexture[k], 2)
        end
    end
    PreviousComponent, PreviousTexture, PreviousTorso = {}, {}, {}
    cb('ok')
end)
