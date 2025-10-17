Config = {}

-- Command and keybind
Config.Command = 'menuropa'
Config.KeyToOpen = 'F5'



-- Language (can change to "en" and "pt")
Config.Language = 'en'



-- DO NOT TOUCH
Locales = {}

local function LoadLocale(lang)
    local path = string.format('locales/%s.json', lang)
    print(('[MenuClothes] Trying to load language: %s'):format(lang))

    local file = LoadResourceFile(GetCurrentResourceName(), path)
    if file then
        local data = json.decode(file)
        if data then
            print(('[MenuClothes] %s.json loaded successfully!'):format(lang))
            return data
        else
            print(('[MenuClothes] Error decoding %s.json'):format(lang))
        end
    else
        print(('[MenuClothes] File %s.json not found!'):format(lang))
    end
    return nil
end

Locales = LoadLocale(Config.Language) or LoadLocale('en') or {}



-- Below we can configure the clothes you want to stay when you take them off in the menu if you have mods you have to change them.

Config.TakeOff = {
    male = {    
        shirt = 15,
        pants = 21,
        shoes = 34,
        jewelry = 0,
        glasses = 0,
        watch = 2,
        vest = 0,
        mask = 0,
        hat = 11,
        bag = 0,
        gloves = 0
    },

    female = {
        shirt = 15,
        pants = 21,
        shoes = 35,
        jewelry = 0,
        glasses = 5,
        watch = 1,
        vest = 0,
        mask = 0,
        hat = 57,
        bag = 0,
        gloves = 0
    }
}
