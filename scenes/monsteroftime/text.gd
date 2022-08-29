extends Control

var cutscenetext = {
	"intro1": "Eh, Wake up [color=red]Sagnol[/color]!",
	"intro2": "We are almost there! The [color=red]boss[/color] is waiting for us.",
	"intro3": "Nice! How long did the trip take?",
	"intro4": "16 days, exactly as in the legend! Now hurry up!",

	"intro2-1": "Let's go! It should be right near the [color=aqua]Beach[/color]!",
	"intro2-2": "I bet the [color=yellow]Portal[/color] is in these ruins...",
	"intro2-3": "I can't believe we found it!",
	"intro2-4": "Do you know how it works exactly ?",
	"intro2-5": "Erf, I need to read again the book, give me some time.",
	
	"forestlook" : "The edge of a [color=aqua]Forest[/color]...",
	"snowlook" : "A cold wind comes from this [color=aqua]Path[/color]... The statues make me think that there are locals nearby...",
	"firelook" : "The [color=aqua]Volcano[/color] seems active...",


	"intro3-1": "I've found 3 ways, a [color=aqua]Forest[/color], a [color=aqua]Cold Path[/color] and the last leads to the [color=aqua]Volcano[/color], nothing dangerous in sight.",
	"intro3-2": "Good! I think I know how to open, the [color=yellow]Portal[/color]...",
	"intro3-3": "We need to find 3 [color=yellow]Stones[/color], they should be in these 3 [color=yellow]Pillars[/color], but someone must have taken them...",
	"intro3-4": "We will explore this land, there are surely clues somewhere.",
	"intro3-5": "I agree, let me go to that [color=aqua]Volcano[/color], I would like to see one up close.",
	"intro3-6": "I take the [color=aqua]Cold Path[/color]! ",
	"intro3-7": "Alright, [color=red]Sagnol[/color], go explore the [color=aqua]Forest[/color], I will stay near the [color=yellow]Portal[/color]. Good luck all.",



	"flower1-1": "Hey! You! Don't kill my [color=red]Flowers[/color]!!",
	"flower1-2": "Please...",
#[color=red][/color] for people
#[color=aqua][/color] for places
#[color=yellow][/color] for objects
	"rihouse1-1": "I have nothing to steal! Go away!",#g
	"rihouse1-2": "I'm not here to rob you, my name is [color=red]Sagnol[/color], come so we can talk!",
	"rihouse1-3": "Why are you here? You works for [color=red]Patrick[/color]?",#g
	"rihouse1-4": "I don't know any [color=red]Patrick[/color]. I came from a [color=aqua]far land[/color], I need to find [color=yellow]3 Stones[/color] related to that [color=yellow]Portal[/color] near the [color=aqua]Beach[/color]. You know something about it?",
	"rihouse1-5": "I've seen the [color=yellow]Portal[/color] and I'm pretty sure [color=red]Patrick[/color] stole one of the [color=yellow]Stones[/color] years ago, a green one.",#g
	"rihouse1-6": "[color=red]Patrick[/color] is my former master, he owns the whole [color=aqua]Forest[/color] and lives in a [color=aqua]big Manor[/color], where I was jailed. I fled to have a better life!",#g
	"rihouse1-7": "He was doing such horrible things I couldn't take it anymore. ",#g
	"rihouse1-8": "You saw the The [color=red]Evil Mushrooms[/color]? it's his last creation, and you know why he created them?",#g
	"rihouse1-9": "Only to eat them! To find the best way to kill and cook! And I was forced to be his assistant!",#g
	"rihouse1-10": "Now I try to make smart [color=red]Flowers[/color] with my knowledge, it makes me happy, so please don't attack them.",#g
	"rihouse1-11": "As long as they don't hurt me... So, you said the [color=yellow]green Stone[/color] is in the [color=aqua]Manor[/color]? ",
	"rihouse1-12": "Yes, I think, in his [color=aqua]secret room[/color].",#g
	"rihouse1-13": "Where exaclty?",
	"rihouse1-14": "In the [color=aqua]kitchen[/color]. Be carful, there are plenty of traps and monsters and [color=red]Patrick[/color] is very strong...",#g
	"rihouse1-15": "Thanks for your help, and good luck with your plants.",
	"rihouse1-16": "Can you help me back? [color=red]Patrick[/color] never paid my [color=yellow]wages[/color], but he kept the acounts just to annoy me!",#g
	"rihouse1-17": "How much?",
	"rihouse1-18": "[color=yellow]800 Pieces[/color].",#g
	"rihouse1-19": "I'll see what I can I do.",
	"rihouse1-20": "Thanks...",#g



	"chief": "The portal is near the sea...",
	"poh0": "I have enough pieces to make a new heart!",
	"poh1": "A Piece of heart! 4 of them increase my life!",
	"poh2": "A Piece of heart! I got 2 of them!",
	"poh3": "A Piece of heart! I'm only missing one!",
	"key": "A small key! I can use it only once...",
	"switcharm": "A piece of a mecanism!",
}
var chief = {
	"introcut2": "Explore the area, I need more time.",
	"introcut3": "Go explore the [color=aqua]Forest[/color], we need to finds the three [color=yellow]Stones[/color] to open the portal.",
}
var friend1 = {
	"introcut2": "Your [color=yellow]Sword[/color] and [color=yellow]Shield[/color] are ready ? Be careful.",

}
var friend2 = {
	"introcut2": "If you run out of [color=yellow]Arrows[/color], you can sometimes find wood in the bushes to craft new ones.",
}

var grindri = {
	"test": "Good luck!",
}

var cutscenanim = {
	"intro1": "friend1",
	"intro2": "friend2",
	"intro3": "sagnol",
	"intro4": "friend1",

	"intro2-1": "chief",
	"intro2-2": "chief",
	"intro2-3": "friend2",
	"intro2-4": "sagnol",
	"intro2-5": "chief",
	
	"forestlook" : "Kinemonster",
	"snowlook" : "Kinemonster",
	"firelook" : "Kinemonster",
	
	"intro3-1": "Kinemonster",
	"intro3-2": "chief",
	"intro3-3": "chief",
	"intro3-4": "friend1",
	"intro3-5": "friend2",
	"intro3-6": "friend1",
	"intro3-7": "chief",
	
	
	
	"flower1-1": "grindri",
	"flower1-2": "grindri",
	
	"rihouse1-1": "grindri",
	"rihouse1-2": "Kinemonster",
	"rihouse1-3": "grindri",
	"rihouse1-4": "Kinemonster",
	"rihouse1-5": "grindri",
	"rihouse1-6": "grindri",
	"rihouse1-7": "grindri",
	"rihouse1-8": "grindri",
	"rihouse1-9": "grindri",
	"rihouse1-10": "grindri",
	"rihouse1-11": "Kinemonster",
	"rihouse1-12": "grindri",
	"rihouse1-13": "Kinemonster",
	"rihouse1-14": "grindri",
	"rihouse1-15": "Kinemonster",
	"rihouse1-16": "grindri",
	"rihouse1-17": "Kinemonster",
	"rihouse1-18": "grindri",
	"rihouse1-19": "Kinemonster",
	"rihouse1-20":"grindri",








	"poh0": "Kinemonster",
	"poh1": "Kinemonster",
	"poh2": "Kinemonster",
	"poh3": "Kinemonster",
	"key": "Kinemonster",
	"switcharm": "Kinemonster",
	"chief": "chief",
	
	}

var cutscenvoice = {
	"intro1": "friend1",
	"intro2": "friend2",
	"intro3": "sagnol",
	"intro4": "friend1",

	"intro2-1": "chief",
	"intro2-2": "chief",
	"intro2-3": "friend2",
	"intro2-4": "sagnol",
	"intro2-5": "chief",
	
	
	"intro3-1": "sagnol",
	"intro3-2": "chief",
	"intro3-3": "chief",
	"intro3-4": "friend1",
	"intro3-5": "friend2",
	"intro3-6": "friend1",
	"intro3-7": "chief",
	
	
	
	"flower1-1": "grindri",
	"flower1-2": "grindri",
	
	"forestlook" : "sagnol",
	"snowlook" : "sagnol",
	"firelook" : "sagnol",
	
	"rihouse1-1": "grindri",
	"rihouse1-2": "sagnol",
	"rihouse1-3": "grindri",
	"rihouse1-4": "sagnol",
	"rihouse1-5": "grindri",
	"rihouse1-6": "grindri",
	"rihouse1-7": "grindri",
	"rihouse1-8": "grindri",
	"rihouse1-9": "grindri",
	"rihouse1-10": "grindri",
	"rihouse1-11": "sagnol",
	"rihouse1-12": "grindri",
	"rihouse1-13": "sagnol",
	"rihouse1-14": "grindri",
	"rihouse1-15": "sagnol",
	"rihouse1-16": "grindri",
	"rihouse1-17": "sagnol",
	"rihouse1-18": "grindri",
	"rihouse1-19": "sagnol",
	"rihouse1-20":"grindri",
	
	"poh0": "sagnol",
	"poh1": "sagnol",
	"poh2": "sagnol",
	"poh3": "sagnol",
	"key": "sagnol",
	"switcharm": "sagnol",
	"chief": "chief",
	}


var voices = {
	"sagnol": preload("res://asset/sounds/voiceF1.wav"),#sagnol
	"friend1": preload("res://asset/sounds/voiceM1.wav"),#friend1
	"friend2": preload("res://asset/sounds/voiceM2.wav"),#friend2
	"chief": preload("res://asset/sounds/voiceM3.wav"),#chief
	"grindri": preload("res://asset/sounds/voiceM4.wav"),#grindri
#	"man1disto": preload("res://asset/sounds/voiceM12.wav"),
}


func _ready():
	pass
