HT = nil
TriggerEvent('HT_base:getBaseObjects', function(obj)
    HT = obj
end)

HT.RegisterServerCallback("pj-blackmarket:configCallback", function(source, cb)
    cb(Config)
end)

HT.RegisterServerCallback("pj-blackmarket:randomLocCB", function(source, cb)
    cb(Config.randomLocation)
end)

HT.RegisterServerCallback("pj-blackmarket:canOpen", function(source, cb, location)
    local dist = #(Config.randomLocation.coords - location)
    if dist <= 10 then
        cb(true)
    else
        cb(false)
    end
end)

CreateThread(function ()
    print('^1/////////////////////////////////////////////////////////////////////////////////////////////////')
    print('^4PJ-blackmarket: KØRE! Lokation for denne session: '..Config.randomLocation.coords)
    print('^1/////////////////////////////////////////////////////////////////////////////////////////////////^0')
end)

RegisterServerEvent('pj-blackmarket:item')
AddEventHandler('pj-blackmarket:item', function(itemName, amount)
    local source = source
    local xPlayer = vRP.getUserId({source})
	local getcoords = GetEntityCoords(soruce)
    local dist = #(Config.randomLocation.coords - getcoords)
    amount = Round(amount)
    if amount < 0 or dist >= 10 then
        sendToDiscord(Strings['exploit_title'], (Strings['exploit_message']):format(xPlayer), 15548997)
        print('pj-blackmarket: ' .. xPlayer .. ' forsøgte at bruge exploit på blackmarket!')
        vRP.kick({source, Strings['kick_msg']})
        return
    end
    local price = 0
    local itemLabel = ''
    local itemType = ''
    for i=1, #Config.Items, 1 do
        if Config.Items[i].item == itemName then
            price = Config.Items[i].price
            itemLabel = Config.Items[i].label
            if Config.Items[i].type then
                itemType = Config.Items[i].type
            end
            break
        end
    end
    price = price * amount
    if Config.PayAccount == "black_money" then
        local xMoney = vRP.getInventoryItemAmount(xPlayer, idname)

        local xMoney = vRP.getBankMoney({xPlayer})
        if xMoney >= price then
            vRP.tryFullPayment({xPlayer, price})
            if itemType == 'weapon' then
                vRP.giveInventoryItem({xPlayer, itemName, amount, true})
            end
            local args = vRP.parseItem(itemName) 
            local item = vRP.items[args[1]] 

            if item ~= nil then
                local itemName = vRP.computeItemName(item, args)
                local itemDescription = vRP.computeItemDescription(item, args)
                local itemWeight = vRP.computeItemWeight(item, args)
            end
            local label = itemName
            sendToDiscord(Strings['purchase_title'], (Strings['purchase_message']):format(xPlayer, amount, itemName, GroupDigits(price), 5763719))
            TriggerClientEvent('pj-blackmarket:notify', source, (Strings['purchase_notify']):format(amount, label, GroupDigits(price)))
        else
            local missingMoney = price - xMoney
            TriggerClientEvent('pj-blackmarket:notify', source, (Strings['not_enough_notify']):format((GroupDigits(missingMoney))))
        end
    end
end)

RegisterServerEvent('pj-blackmarket:later')
AddEventHandler('pj-blackmarket:later', function()
    local xPlayer = vRP.getUserId({source})
    sendToDiscord(Strings['exploit_title'], (Strings['exploit_message']):format(xPlayer), 15548997)
    print('pj-blackmarket: ' .. xPlayer .. ' forsøgte at bruge exploit på blackmarket!')
    vRP.kick({source, Strings['kick_msg']})
end)

function sendToDiscord(name, message, color) 
    local connect = {
        {
            ["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "PJ-BlackMarket - by PJ-Scripts",
            },
        }
    }
    PerformHttpRequest(Config.WebhookLink, function(err, text, headers) end, 'POST', json.encode({username = 'PJ-BlackMarket', embeds = connect, avatarrl = 'https://media.discordapp.net/attachments/949247950419271680/1184883171813249135/image.png?ex=65a00c72&is=658d9772&hm=33d55bd7be133dacccdf3a9df01412707f52cb3702a94506f9a5bce7640b87c7&=&format=webp&quality=lossless'}), { ['Content-Type'] = 'application/json' })
end


function GroupDigits(number)
    local formattedNumber = tostring(number)
    formattedNumber = string.reverse(formattedNumber)
    formattedNumber = string.gsub(formattedNumber, "(%d%d%d)", "%1,")
    formattedNumber = string.reverse(formattedNumber)
    formattedNumber = string.gsub(formattedNumber, "^,", "")
    return formattedNumber
end

function Round(value, numDecimalPlaces)
    numDecimalPlaces = numDecimalPlaces or 0
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(value * mult + 0.5) / mult
end
