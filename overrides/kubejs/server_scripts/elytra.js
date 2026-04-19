ServerEvents.recipes(event =>{
    const {create} = event.recipes
    const incomplete = 'create:incomplete_precision_mechanism'
    create.sequenced_assembly(
    [
    Item.of("minecraft:elytra").withChance(1.0),
    Item.of("minecraft:elytra").withChance(0.1)
    ],
    'minecraft:elytra',
    [
    create.cutting(incomplete,incomplete),
    create.deploying(incomplete,[incomplete,'minecraft:phantom_membrane']),
    create.deploying(incomplete,[incomplete,'minecraft:string']),
    create.deploying(incomplete,[incomplete,'minecraft:light_gray_dye']),
    create.deploying(incomplete,[incomplete,'minecraft:slime_ball']),
    create.deploying(incomplete,[incomplete,'minecraft:feather']),
    create.pressing(incomplete,incomplete)
    ]
    )
    .transitionalItem(incomplete)
    .loops(32)
})