ServerEvents.recipes(event =>{
        const {create} = event.recipes
        create.milling([Item.of('minecraft:echo_shard',3),Item.of('minecraft:echo_shard',1).withChance(0.3)],'minecraft:sculk'),
        create.milling([Item.of('minecraft:echo_shard',1),Item.of('minecraft:echo_shard',1).withChance(0.3)],'minecraft:sculk_vein'),
        create.milling([Item.of('minecraft:echo_shard',18),Item.of('minecraft:echo_shard',6).withChance(0.6)],'minecraft:sculk_catalyst'),
        create.milling([Item.of('minecraft:echo_shard',9),Item.of('minecraft:echo_shard',3).withChance(0.3)],'minecraft:sculk_shrieker'),
        create.milling([Item.of('minecraft:echo_shard',9),Item.of('minecraft:echo_shard',3).withChance(0.3)],'minecraft:sculk_sensor'),
        create.haunting('minecraft:sculk_catalyst','minecraft:sculk')
        create.compacting('minecraft:sculk',Item.of('minecraft:echo_shard',4))
})