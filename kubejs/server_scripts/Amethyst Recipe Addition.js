ServerEvents.recipes(event =>{
        const {create} = event.recipes
        create.mixing("minecraft:budding_amethyst",["minecraft:amethyst_block",Item.of("minecraft:amethyst_cluster",6)])
})