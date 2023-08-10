extends Node

var STONE = Tile.new(1)
var DIRT = Tile.new(2)
var GRASS = GrassTile.new(3)
var PLANKS = Tile.new(4)
var COBBLESTONE = Tile.new(16)
var SAPLING = SaplingTile.new(15)

var TILES = [STONE, DIRT, GRASS, PLANKS, COBBLESTONE, SAPLING]

func get_tile(tex: int):
	for i in TILES:
		if i.tex == tex:
			return i
	return null
