ServerEvents.recipes(event => {
    event.shaped(
        Item.of('origins:orb_of_origin', 1),
        [
            'DDD',
            'DSD',
            'DDD'
        ],
        {
            D: 'minecraft:diamond',
            S: 'minecraft:nether_star'
        }
    );
});