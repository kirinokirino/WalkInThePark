extends Node

const M_names_list: Array = ["Alex", "Bob", "Peter", "Pedro"]
const F_names_list: Array = ["Alex", "Lisa", "Victoria", "Elizabeth"]
const names: Array = ["Alex", "Bob", "Peter", "Pedro", "Lisa", "Victoria", "Elizabeth"]
const thoughts = [
	"Oh, I can still smell the breakfast I had today in my smell.",
	"Did I lock the door properly?..",
	"I should probably call [name].",
	"I wonder if [name] will like the gift.",

	"I could go for some cake right now.",
	"The air feels so fresh! I should go for walks more often.",

	"I think I'm sweating too much. I hope noone is noticing that...",
	"Damn, this guy I ran into yesterday, what a goddamn asshole.",
	"I. am. hungry.",
	"Oh man, I forgot my book at home.",

	"Hehe, that video I watched yesterday was hilarious!",
	"I hope my cat is waiting for me at home...",
	"Should I buy that cool thing I saw?... Or nah?...",
	"These clothes are so comfy!",
	"Man, frogs are the best.",
	"~Para para para, pere pere pere~",
	"I should sit down... I feel tired.",
	"I really need a new bed. My back hurts!",
	"I wish someone gave me flowers...",
	"I could really use a couple of million bucks right now.",
	"I swear I hear some music in the distance... Where is it coming from?",
	"~Nossa, nossa, lala-lala-lala-laaa~",
	"Is my hair messy?..",
	"I wish I were a script writer. I have so many movie ideas!",
	"I wish I were a game designer. I have so many ideas for games!",
	"Imagine if people had a computer built into their eyes...",
	"Oh, right, [name]' birthday is tomorrow!",
	"5... 7... 8 cents are in my pocket right now!",
	"I wonder if Google will ever go bankrupt...",
	"The show starts at 5pm, I hope I'll be back by that point.",
	"Man, that was a very weird talk I had with [name] just now.",
	"How many levels are there in Candy Crush?",
	"I need some sleep, it can't go on like this",
	"I wish I could see stars at daytime too.",
	"My bag makes a weird sound... I hope noone else hears that.",
	"Should I become a youtuber? I do have a decent phone camera!",
	"What would be top 10 movies I would show to my future grandkids?",
	"I really like Indian food.",
	"How do you properly cook noodles? I bet I've done it wrong all my life.",
	"~Nananana, nananana, heyheyheyhey~",
	"I ate a bag of freezed fruit some months ago.",
	"I love the sound of wind. Tho it makes me feel chaotic.",
	"What is love?",
	"If a bundle of lettuce is called a head, does that mean that the harvesting of lettuce is called decapitating?",
	"I kinda feel lonely right now.",
	"Breathing in... Breathing out... Breathing in...",
	"What day is it today anyways?",
	"Man, imagine how many people in the world never had homemade butter.",
	"I should start studying French already!",
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

static func thought():
	var thought = thoughts[randi() % thoughts.size()]
	thought = thought.replace("[name]", names[randi() % names.size()])
	return thought
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
