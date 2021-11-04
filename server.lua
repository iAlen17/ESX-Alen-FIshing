



discord = {
    ['webhook'] = 'https://discord.com/api/webhooks/899994045923885106/T2XHJotIH9BXNfvLZHzn0mcTWMAPuHjSh9Sxt3Y9VtQ8a2_Ox5IPBki9j0O9MSY8MGia',
    ['name'] = 'Fishing Logs',
    ['image'] = 'https://cdn.discordapp.com/attachments/774536621802389544/899986988386623498/logo.png'
}


RegisterServerEvent('Alen-Fishing:Add')
AddEventHandler('Alen-Fishing:Add', function()
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local item = fish
    local chance = math.random(3,7)

    Player.addInventoryItem("fish", chance)
    sendtodiscordaslog(Player.getName() ..  ' - ' .. Player.getIdentifier(), ' Caught '   ..  chance .. ' fishes!')
end)

RegisterServerEvent("Alen-Fishing:Sell")
AddEventHandler("Alen-Fishing:Sell", function()
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local alencount = Player.getInventoryItem('fish').count
    local payment = Config['Payment']
    if alencount <= 1 then
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = "You don't have enough fishes to sell"})			
    else   
        Player.removeInventoryItem('fish', alencount)
        Player.addMoney(payment*alencount)       
        sendtodiscordaslog(Player.getName() ..  ' - ' .. Player.getIdentifier(), ' Earned $' .. alencount*payment .. ' By Selling fishes!')
end
end)


ESX.RegisterUsableItem('fishingrod', function(source, item) 
    local Player = ESX.GetPlayerFromId(source)
		TriggerClientEvent('fishing:useRod', source)
        sendtodiscordaslog(Player.getName() ..  ' - ' .. Player.getIdentifier() .. ' - ' .. Player.job.name, ' Tried to start fishing')
end)

RegisterCommand("fishing", function(source, args, rawCommand)
    local source = source
    local Player = ESX.GetPlayerFromId(source)
    TriggerClientEvent('fishing:useRod', source)
    sendtodiscordaslog(Player.getName() ..  ' - ' .. Player.getIdentifier() .. ' - ' .. Player.job.name, ' Tried to start fishing')
end, false)

sendtodiscordaslog = function(name, message)
    local data = {
        {
            ["color"] = '3553600',
            ["title"] = "**".. name .."**",
            ["description"] = message,
        }
    }
    PerformHttpRequest(discord['webhook'], function(err, text, headers) end, 'POST', json.encode({username = discord['name'], embeds = data, avatar_url = discord['image']}), { ['Content-Type'] = 'application/json' })
end

