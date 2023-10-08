local mply = FindMetaTable( "Player" )
local ment = FindMetaTable( "Entity" )

function mply:AddToMVP()
end

function mply:AddSpyDocument()
	self:SetNWInt("CollectedDocument", 1)
end

function mply:SetOnFire(ply)
end

function mply:LevelBar()
end

function mply:SetForcedAnimation(sequence, endtime, startcallback, finishcallback, stopcallback)

	if sequence == false then
		self:StopForcedAnimation()
		return
	end
	
	  if SERVER then
	  
		if isstring(sequence) then sequence = self:LookupSequence(sequence) end
		  self:SetCycle(0)
		  self.ForceAnimSequence = sequence
		  
		  time = endtime
		  
		  if endtime == nil then
			time = self:SequenceDuration(sequence)
		  end
		  
		  
		  
		  net.Start("BREACH_SetForcedAnimSync")
		  net.WriteEntity(self)
		  net.WriteUInt(sequence, 20) -- seq cock
		  net.Broadcast()
		  
		  if isfunction(startcallback) then startcallback() end
		  
		  self.StopFAnimCallback = stopcallback
		  
			timer.Create("SeqF"..self:EntIndex(), time, 1, function()
			  if (IsValid(self)) then
			  
				self.ForceAnimSequence = nil
				
				net.Start("BREACH_EndForcedAnimSync")
				net.WriteEntity(self)
				net.Broadcast()
				
				self.StopFAnimCallback = nil
				
				if isfunction(finishcallback) then
					finishcallback()
				end
				
			end
			  
		end)
		  
	end
		
end

local german_names = {}
local german_lastnames = {}
local usa_names = {}
local usa_lastnames = {}
local gru_names = {"Ivan","Dmitry","Sergey","Alexey","Andrey","Pavel","Varus","Vladimir","Maxim","Evgeha","Evgeniy","Nikolay","Roman","Oleg","Viktor","Sosiska", "Alisher", "Igor","Churkha","Mikhail","Sergei","Alexander","Anatoly","Yuri","Boris","Gennady","Konstantin","Andrei","Vitaly","Vladislav","Stanislav","Yaroslav","Sergei","Dmitriy","Anton","Artem","Artur","Timur","Denis","Egor","Fedor","Kirill","Leonid","Nikita","Zhenya","Makumba","Popabava"}
local gru_lastnames = {"Ivanov","Petrov","Sidorov","Kuznetsov","Smirnov","Popov","Putin","Bitchass","Pootis","Vasiliev","Kapustin","Sosiskin","Mat", "Kuleshov", "Zaitsev","Propka","Golubev","Churkhin","Sokolov","Prigozhin","Morozov","Novikov","Kozlov","Lebedev","Semenov","Egorov","Pavlov","Karpov","Nikitin","Mironov","Fedorov","Frolov","Aleksandrov","Vorobev","Stepanov","Gavrilov","Agafonov","Makarov","Kondratiev","Konovalov","Kuzmin","Ilin","Ponomarev","Melnikov","Bogdanov","Kulikov","Safonov","Zakharov","Aksenov","Golovin","Matveev","Nazarov","Markov","Rozhkov","Gusev","Sergeev","Borisov","Grigoriev","Pozharsky","Korolev","Shapovalov","Tarasov","Igorev","Dmitriev","Prokhorov","Vorontsov","Kolesnikov","Kupriyanov","Suvorov","Kudryavtsev","Zyablikov","Maltsev","Komarov","Solovyov","Vinogradov","Belyakov","Artemov","Mikhailov","Ponomarenko","Gorbatov","Krasnov","Belyaev","Rodionov","Malinin","Sorokin","Kazakov","Gorbachev","Davydov","Frolov","Bogomolov","Malakhov","Zinoviev","Zubkov","Vlasov","Lazarev","Novoselov","Kondratov","Vishnyakov","Tikhonov","Panin","Golosov","Belov","Zubarev","Nesterov","Khokhlov","Popobava"}
local femname = {"Emma", "Olivia", "Ava", "Isabella", "Sophia", "Mia", "Charlotte", "Amelia", "Harper", "Evelyn","Abigail", "Emily", "Elizabeth", "Mila", "Ella", "Avery", "Sofia", "Camila", "Aria", "Scarlett","Victoria", "Madison", "Luna", "Grace", "Chloe", "Penelope", "Layla", "Riley", "Zoey", "Nora","Lily", "Eleanor", "Hannah", "Lillian", "Addison", "Aubrey", "Ellie", "Stella", "Natalie", "Zoe","Lucy", "Paisley", "Everly", "Anna", "Caroline", "Nova", "Genesis", "Emilia", "Kennedy", "Samantha","Maya", "Willow", "Kinsley", "Naomi", "Aaliyah", "Elena", "Sarah", "Ariana", "Allison", "Gabriella", "Leah", "Hazel", "Violet", "Aurora", "Savannah", "Audrey", "Brooklyn", "Bella", "Claire", "Skylar","Alice", "Madelyn", "Cora", "Ruby", "Eva", "Serenity", "Autumn", "Adeline", "Hailey", "Gianna","Valentina", "Isla", "Eliana", "Quinn", "Nevaeh", "Ivy", "Sadie", "Piper", "Lydia", "Alexa","Josephine", "Emery", "Julia", "Delilah", "Arianna", "Vivian", "Kaylee", "Sophie", "Brielle", "Madeline","Peyton", "Rylee", "Clara", "Hadley", "Melanie", "Mackenzie", "Reagan", "Adalynn", "Liliana", "Aubree","Jade", "Katherine", "Isabelle", "Natalia", "Raelynn", "Maria", "Athena", "Ximena", "Arya", "Leilani","Taylor", "Faith", "Rose", "Kylie", "Alexandra", "Mary", "Margaret", "Lyla", "Ashley", "Amaya","Eliza", "Brianna", "Bailey", "Andrea", "Khloe", "Jasmine", "Melody", "Iris", "Isabel", "Norah","Annabelle", "Valeria", "Emerson", "Adalyn", "Ryleigh", "Eden", "Emersyn", "Anastasia", "Kayla", "Alyssa","Juliana", "Charlie", "Esther", "Ariel", "Cecilia", "Valerie", "Alina", "Molly", "Reese", "Aliyah","Lilly", "Parker", "Finley", "Morgan", "Sydney", "Jordyn", "Eloise", "Trinity", "Daisy", "Kimberly","Lauren", "Genevieve", "Sara","Arabella", "Harmony", "Elise", "Remi", "Teagan", "Alexis", "London", "Sloane", "Laila", "Lucia","Diana", "Juliette", "Sienna", "Elliana", "Londyn", "Ayla", "Callie", "Gracie", "Josie", "Amara","Jocelyn", "Daniela", "Everleigh", "Mya", "Rachel", "Summer", "Tracy", "Alana", "Brooke", "Alaina", "Mckenzie","Catherine", "Amy", "Presley", "Journee", "Rosalie", "Ember", "Brynlee", "Rowan", "Joanna", "Paige","Rebecca", "Ana", "Sawyer", "Mariah", "Nicole", "Brooklynn", "Payton", "Marley", "Fiona", "Georgia","Lila", "Harley", "Adelyn", "Alivia", "Noelle", "Gemma", "Vanessa", "Journey", "Makayla", "Angelina","Adaline", "Catalina", "Alayna", "Julianna", "Leila", "Lola", "Adriana", "June", "Juliet", "Jayla","River", "Tessa", "Lia", "Dakota", "Delaney", "Selena", "Blakely", "Ada", "Camille", "Zara","Malia", "Hope", "Samara", "Vera", "Mckenna", "Briella", "Izabella", "Hayden", "Raegan", "Michelle","Angela", "Ruth", "Freya", "Kamila", "Vivienne", "Aspen", "Olive", "Kendall", "Elaina", "Thea","Kali", "Destiny", "Amiyah", "Evangeline", "Carmen", "Phoenix", "Elsie", "Evie", "Amina", "Giselle","Brynn", "Lilah", "Lucille", "Aniyah", "Charlie", "Harlow", "Lena", "Maci", "Annie", "Mariana","Mikayla", "Danna", "Kira", "Adelaide", "Alison", "Camryn", "Alessandra", "Raelyn", "Nyla", "Addilyn","Dylan", "Keira", "Allyson", "Haven", "Mallory", "Erin", "Lia", "Jazmine", "Miriam", "Evelynn","Anne", "Leslie", "Kaitlyn", "Emely", "Arielle", "Mira", "Briana", "Daphne", "Lilliana", "Myla","Penelope", "Kamryn", "Aubrie", "Jane", "Raelynn", "Talia", "Rylie", "Nina", "Kayleigh", "Luciana","Malia", "Scarlet", "Amanda", "Daniella", "Guadalupe", "Tatum", "Kyla", "Kaelyn", "Miranda", "Alivia","Annalise", "Skyler", "Kelsey", "Haley", "Lana", "Sabrina", "Mikaela","Celeste", "Ariella", "Alani", "Natasha", "Nadia", "Jane", "Bianca", "Katie", "Elisa", "Lacey","Cassandra", "Camilla", "Esmeralda", "Josephine", "Miracle", "Charlee", "Adelynn", "Laura", "Anaya", "Nayeli","Melany", "Sage", "Annabella", "Dayana", "Ariah", "Kenzie", "Stephanie", "Ivanna", "Aubriella", "Sarai","Megan", "Paislee", "Helen", "Blair", "Amirah", "Averie", "Demi", "Willa", "Jayleen", "Phoebe","Elle", "Lorelei", "Joselyn", "Malaysia", "Zuri", "Elsa", "Madisyn", "Anabelle", "Hattie", "Kara","Remington", "Charleigh", "Raven", "Jaelynn", "Sylvia", "Elyse", "Lainey", "Siena", "Braelynn", "Nylah","Lennon", "Lennox", "Renata", "Elisabeth", "Violeta", "Amia", "Armani", "Imani", "Kori", "Milani","Astrid", "Nalani", "Simone", "Rory", "Kiera", "Adelina", "Nola", "Savanna", "Alejandra", "Aitana","Kaia", "Sandra", "Jolie", "Katalina", "Eileen", "Nadia", "Lilianna", "Miah", "Tiana", "Zariah","Marilyn", "Rebekah", "Aurelia", "Zahra", "Haylee", "Amara", "Reyna", "Frankie", "Mabel", "Amayah","Meredith", "Elliot", "Kenna", "Alanna", "Maliyah", "Joelle", "Karter", "Alayah", "Anahi", "Crystal","Zoe", "Kalani", "Kallie", "Marlee", "Erika", "Amani", "Bristol", "Dulce", "Aileen", "Ariyah","Evie", "Dorothy", "Elora", "Joy", "Meghan", "Sutton", "Audrina", "Kyla", "Lilith", "Kadence","Cataleya", "Leona", "Lindsey", "Gloria", "Remy", "Chelsea", "Remi", "Lorelai", "Amelie", "Bethany","Zara", "Marie", "Blaire", "Lauryn", "Anika", "Cameron", "Colette", "Alicia", "April", "Julie","Savannah", "Xiomara", "Blakely", "Karina", "Reina", "Kensley", "Holly", "Rosemary", "Jemma", "Amalia","Kathleen", "Helena", "Hope", "Elisabet", "Marina", "Cassidy", "Briar", "Joyce", "Emelia", "Clarissa","Ezra", "Martha", "Sariah"}
local femlast = {"Smith", "Johnson", "Jhones", "Williams", "Jones", "Brown", "Davis", "Miller", "Wilson", "Moore", "Taylor","Anderson", "Thomas", "Jackson", "White", "Harris", "Martin", "Thompson", "Garcia", "Martinez", "Robinson","Clark", "Rodriguez", "Lewis", "Lee", "Walker", "Hall", "Allen", "Young", "Hernandez", "King","Wright", "Lopez", "Hill", "Scott", "Green", "Adams", "Baker", "Gonzalez", "Nelson", "Carter","Mitchell", "Perez", "Roberts", "Turner", "Phillips", "Campbell", "Parker", "Evans", "Edwards", "Collins","Stewart", "Sanchez", "Morris", "Rogers", "Reed", "Cook", "Morgan", "Bell", "Murphy", "Bailey","Cooper", "Richardson", "Cox", "Howard", "Ward", "Torres", "Peterson", "Gray", "Ramirez", "James","Watson", "Brooks", "Kelly", "Sanders", "Price", "Bennett", "Wood", "Barnes", "Ross", "Henderson","Coleman", "Jenkins", "Perry", "Powell", "Long", "Patterson", "Hughes", "Flores", "Washington", "Butler","Simmons", "Foster", "Gonzales", "Bryant", "Alexander", "Russell", "Griffin", "Diaz", "Hayes", "Myers","Ford", "Hamilton", "Graham", "Sullivan", "Wallace", "Woods", "Cole", "West", "Jordan", "Owens","Reynolds", "Fisher", "Ellis", "Harrison", "Gibson", "Mcdonald", "Cruz", "Marshall", "Ortiz", "Gomez","Murray", "Freeman", "Wells", "Webb", "Simpson", "Stevens", "Tucker", "Porter", "Hunter", "Hicks","Crawford", "Henry", "Boyd", "Mason", "Morales", "Kennedy", "Warren", "Dixon", "Ramos", "Reyes","Burns", "Gordon", "Shaw", "Holmes", "Rice", "Robertson", "Hunt", "Black", "Daniels", "Palmer","Mills", "Nichols", "Grant", "Knight", "Ferguson", "Rose", "Stone", "Hawkins", "Dunn", "Perkins","Hudson", "Spencer", "Gardner", "Stephens", "Payne", "Pierce", "Berry", "Matthews", "Arnold", "Wagner","Willis", "Ray", "Watkins", "Olson", "Carroll", "Duncan", "Snyder", "Hart", "Cunningham", "Bradley","Lane", "Andrews", "Ruiz", "Harper", "Fox", "Riley", "Armstrong"}
local malename = {"Aiden", "Alexander", "Andrew", "Anthony", "Austin", "Benjamin", "Blake", "Brayden", "Caleb", "Cameron","Carter", "Charles", "Christopher", "Colton", "Connor", "Daniel", "David", "Dominic", "Dylan", "Elijah","Ethan", "Gabriel", "Gavin", "Henry", "Hunter", "Isaac", "Jack", "Jackson", "Jacob", "James","Jason", "Jayden", "Jeremiah", "John", "Jonathan", "Joseph", "Joshua", "Julian", "Justin", "Kevin","Landon", "Levi", "Liam", "Logan", "Lucas", "Luke", "Mason", "Matthew", "Michael", "Nathan","Nicholas", "Noah", "Oliver", "Oscar", "Owen", "Parker", "Ryan", "Samuel", "Sebastian", "Thomas","Tyler", "William", "Wyatt", "Aaron", "Adam", "Adrian", "Alan", "Albert", "Alex", "Alexandre","Alexis", "Alfred", "Ali", "Allen", "Alvin", "Andre", "Andres", "Angel", "Angelo", "Anthony","Antonio", "Armando", "Arnold", "Arthur", "Arturo", "Asher", "Austin", "Axel", "Barry", "Beau","Ben", "Benjamin", "Bernard", "Bill", "Billy", "Blake", "Bob", "Bobby", "Brad", "Bradley","Brady", "Brandon", "Braylon", "Brendan", "Brenden", "Brendon", "Brett", "Brian", "Bruce", "Bryce","Bryson", "Caleb", "Calvin", "Cameron", "Carl", "Carlos", "Carter", "Casey", "Cedric", "Chad","Charles", "Charlie", "Chase", "Chris", "Christian", "Christopher", "Clarence", "Clark", "Cody", "Colby","Cole", "Colin", "Collin", "Colton", "Conner", "Connor", "Cooper", "Corey", "Craig", "Cristian","Curtis", "Cyril", "Dale", "Dalton", "Damian", "Damien", "Damon", "Dan", "Daniel", "Danny","Dante", "Darius", "Darren", "Daryl", "Dave", "David", "Dean", "Dennis", "Derek", "Derrick","Desmond", "Devon", "Dexter", "Diego", "Dominic", "Don", "Donald", "Donovan", "Douglas", "Drake","Drew", "Duane", "Dustin", "Dwayne", "Dylan", "Eddie", "Edgar", "Edison", "Eduardo", "Edward","Edwin", "Eli", "Elias", "Elijah", "Elliot", "Elliott", "Ellis", "Elmer", "Elton", "Emerson","Emmanuel", "Eric", "Erik", "Ernest", "Eugene", "Evan", "Everett", "Fabian", "Fernando", "Finn", "Floyd", "Francis", "Frank","Franklin", "Fred", "Frederick", "Gabriel", "Garrett", "Gary", "Gavin", "George", "Gerald", "Gilbert","Giovanni", "Glen", "Glenn", "Gordon", "Graham", "Grant", "Gregory", "Guy", "Harold", "Harrison","Harry", "Harvey", "Hayden", "Heath", "Henry", "Herbert", "Herman", "Howard", "Hugh", "Hunter","Ian", "Isaac", "Isaiah", "Ivan", "Jack", "Jackson", "Jacob", "Jaden", "Jake", "James","Jamie", "Jamison", "Jared", "Jason", "Jasper", "Jay", "Jayden", "Jeff", "Jeffery", "Jeffrey","Jeremy", "Jerome", "Jerry", "Jesse", "Jesus", "Jim", "Jimmy", "Joe", "Joel", "John","Johnny", "Jonah", "Jonathan", "Jordan", "Jorge", "Jose", "Joseph", "Joshua", "Josiah", "Juan","Julian", "Julio", "Junior", "Justin", "Kai", "Kaleb", "Karl", "Keith", "Kelly", "Kelvin","Ken", "Kenneth", "Kenny", "Kent", "Kevin", "Kieran", "Kirk", "Kyle", "Lamar", "Lance","Landon", "Larry", "Lawrence", "Lee", "Leo", "Leon", "Leonard", "Leroy", "Leslie", "Levi","Lewis", "Liam", "Lionel", "Logan", "Lonnie", "Lorenzo", "Louis", "Lucas", "Luis", "Luke","Malachi", "Malcolm", "Manuel", "Marc", "Marcus", "Mario", "Mark", "Marshall", "Martin", "Mason","Mathew", "Matt", "Matthew", "Maurice", "Max", "Maxwell", "Mckenzie", "Melvin", "Michael", "Micheal","Mickey", "Miguel", "Mike", "Milton", "Mitchell", "Morgan", "Nathan", "Nathaniel", "Neil", "Nelson","Nicholas", "Nick", "Nicolas", "Noah", "Nolan", "Norman", "Oliver", "Omar", "Orlando", "Oscar","Owen", "Pablo", "Patrick", "Paul", "Pedro", "Perry", "Peter", "Philip", "Phillip", "Preston","Quentin", "Ralph", "Ramiro", "Ramon", "Randall", "Randy", "Ray", "Raymond", "Reece", "Reginald","Rene", "Reuben", "Rex", "Rhett", "Ricardo", "Richard", "Rick", "Ricky", "Riley", "Rob","Robbie", "Robert", "Roberto", "Robin", "Rocky", "Rod", "Rodney", "Rodolfo", "Roger", "Roland","Ron", "Ronald", "Ronnie", "Roosevelt", "Rory", "Ross", "Roy", "Ruben", "Rudy", "Russell","Ryan", "Sam", "Samuel", "Santiago", "Scott", "Sean", "Sebastian", "Seth", "Shane", "Shawn","Sidney", "Silas", "Simon", "Solomon", "Spencer", "Stanley", "Stefan", "Stephen", "Steve", "Steven","Stewart", "Stuart", "Sylvester", "Tanner", "Taylor", "Ted", "Terence", "Terrance", "Terrell", "Terry","Thaddeus", "Theodore", "Thomas", "Tim", "Timothy", "Toby", "Tom", "Tomas", "Tony", "Trace","Travis", "Trent", "Trevor", "Troy", "Tyler", "Tyrone", "Tyson", "Ulysses", "Van","Victor", "Vince", "Vincent", "Virgil", "Wade", "Walker", "Walter", "Warren", "Wayne", "Wesley","Weston", "Wilbur", "Will", "William", "Willie", "Willis", "Winston", "Wyatt", "Xavier", "Yahir","Zachariah", "Zachary", "Zack", "Zane", "Roman", "Cyox", "Suoh", "Uracos", "Shaky", "Saitama"}
local malelast = {"Smith", "Johnson", "Williams", "Jones", "Brown", "Davis", "Miller", "Wilson", "Putis", "Pootisman", "Pootis", "Moore", "Taylor","Anderson", "Thomas", "Jackson", "White", "Harris", "Martin", "Thompson", "Garcia", "Martinez", "Robinson","Clark", "Rodriguez", "Lewis", "Lee", "Walker", "Hall", "Allen", "Young", "Hernandez", "King","Wright", "Lopez", "Hill", "Scott", "Green", "Adams", "Baker", "Gonzalez", "Nelson", "Carter","Mitchell", "Perez", "Roberts", "Turner", "Phillips", "Campbell", "Parker", "Evans", "Edwards", "Collins","Stewart", "Sanchez", "Morris", "Rogers", "Reed", "Cook", "Morgan", "Bell", "Murphy", "Bailey","Rivera", "Cooper", "Richardson", "Cox", "Howard", "Ward", "Torres", "Peterson", "Gray", "Ramirez","James", "Watson", "Brooks", "Kelly", "Sanders", "Price", "Bennett", "Wood", "Barnes", "Ross","Henderson", "Coleman", "Jenkins", "Perry", "Powell", "Long", "Patterson", "Hughes", "Flores", "Washington","Butler", "Simmons", "Foster", "Gonzales", "Bryant", "Alexander", "Russell", "Griffin", "Diaz", "Hayes","Myers", "Ford", "Hamilton", "Graham", "Sullivan", "Wallace", "Woods", "Cole", "West", "Jordan","Owens", "Reynolds", "Fisher", "Ellis", "Harrison", "Gibson", "McDonald", "Cruz", "Marshall", "Ortiz","Gomez", "Murray", "Freeman", "Wells", "Webb", "Simpson", "Stevens", "Tucker", "Porter", "Hunter","Hicks", "Crawford", "Henry", "Boyd", "Mason", "Morales", "Kennedy", "Warren", "Dixon", "Ramos","Reyes", "Burns", "Gordon", "Shaw", "Holmes", "Rice", "Robertson", "Hunt", "Black", "Daniels","Palmer", "Mills", "Nichols", "Grant", "Knight", "Ferguson", "Rose", "Stone", "Hawkins", "Dunn","Perkins", "Hudson", "Spencer", "Gardner", "Stephens", "Payne", "Pierce", "Berry", "Matthews", "Arnold","Wagner", "Willis", "Ray", "Watkins", "Olson", "Carroll", "Duncan", "Snyder", "Hart", "Cunningham","Bradley", "Lane", "Andrews", "Ruiz", "Harper", "Fox", "Riley","Armstrong", "Carpenter", "Weaver", "Greene", "Lawrence", "Elliott", "Chavez", "Sims", "Austin", "Peters","Kelley", "Franklin", "Lawson", "Fields", "Gutierrez", "Ryan", "Schmidt", "Carr", "Vasquez", "Castillo","Wheeler", "Chapman", "Oliver", "Montgomery", "Richards", "Williamson", "Johnston", "Banks", "Meyer", "Bishop","McCoy", "Howell", "Alvarez", "Morrison", "Hansen", "Fernandez", "Garza", "Harvey", "Little", "Burton","Stanley", "Nguyen", "George", "Jacobs", "Reid", "Kim", "Fuller", "Lynch", "Dean", "Gilbert","Garrett", "Romero", "Welch", "Larson", "Frazier", "Burke", "Hanson", "Day", "Mendoza", "Moreno","Bowman", "Medina", "Fowler", "Brewer", "Hoffman", "Carlson", "Silva", "Pearson", "Holland", "Douglas","Fleming", "Jensen", "Vargas", "Byrd", "Davidson", "Hopkins", "May", "Terry", "Herrera", "Wade","Soto", "Walters", "Curtis", "Neal", "Caldwell", "Lowe", "Jennings", "Barnett", "Graves", "Jimenez","Horton", "Shelton", "Barrett", "Obrien", "Castro", "Sutton", "Gregory", "McKinney", "Lucas", "Miles","Craig", "Rodriquez", "Chambers", "Holt", "Lambert", "Fletcher", "Watts", "Bates", "Hale", "Rhodes","Pena", "Beck", "Newman", "Haynes", "McDaniel", "Mendez", "Bush", "Vaughn", "Parks", "Dawson","Santiago", "Norris", "Hardy", "Love", "Steele", "Curry", "Powers", "Schultz", "Barker", "Guzman","Page", "Munoz", "Ball", "Keller", "Chandler", "Weber", "Leonard", "Walsh", "Lyons", "Ramsey","Wolfe", "Schneider", "Mullins", "Benson", "Sharp", "Bowen", "Daniel", "Barber", "Cummings", "Hines","Baldwin", "Griffith", "Valdez", "Hubbard", "Salazar", "Reeves", "Warner", "Stevenson", "Burgess", "Santos","Tate", "Cross", "Garner", "Mann", "Mack", "Moss", "Thornton", "Dennis", "McGee", "Farmer","Delgado", "Aguilar", "Vega", "Glover", "Manning", "Cohen", "Harmon", "Rodgers", "Robbins", "Newton","Todd", "Blair", "Higgins","Ingram", "Reese", "Cannon", "Strickland", "Townsend", "Potter", "Goodwin", "Walton", "Rowe", "Hampton","Ortega", "Patton", "Swanson", "Joseph", "Francis", "Goodman", "Maldonado", "Yates", "Becker", "Erickson","Hodges", "Rios", "Conner", "Adkins", "Webster", "Norman", "Malone", "Hammond", "Flowers", "Cobb","Moody", "Quinn", "Blake", "Maxwell", "Pope", "Floyd", "Osborne", "Paul", "McCarthy", "Guerrero","Lindsey", "Estrada", "Sandoval", "Gibbs", "Tyler", "Gross", "Fuentes", "Flynn", "Barrera", "MacDonald","Everett", "Contreras", "Harrington", "Hess", "Henson", "Gallegos", "Hardin", "Blackwell", "Barr", "Livingston","Middleton", "Spears", "Branch", "Blevins", "Chen", "Kerr", "McConnell", "Hatfield", "Harding", "Ashley","Solis", "Herman", "Frost", "Giles", "Blackburn", "William", "Pennington", "Woodward", "Finley", "McIntosh","Koch", "Best", "Solomon", "McCullough", "Dudley", "Nolan", "Blanchard", "Rivas", "Brennan", "Mejia","Kane", "Benton", "Joyce", "Buckley", "Haley", "Valentine", "Maddox", "Russo", "McKnight", "Buck","Moon", "McMillan", "Crosby", "Berg", "Dotson", "Mays", "Roach", "Church", "Chan", "Richmond","Meadows", "Faulkner", "Oneill", "Knapp", "Kline", "Barry", "Ochoa", "Jacobson", "Gay", "Avery","Hendricks", "Horne", "Shepard", "Hebert", "Cherry", "Cardenas", "McIntyre", "Whitney", "Waller", "Holman","Donaldson", "Cantu", "Terrell", "Morin", "Gillespie", "Fuentes", "Tillman", "Sanford", "Bentley", "Peck","Key", "Salas", "Rollins", "Gamble", "Dickson", "Battle", "Santana", "Cabrera", "Cervantes", "Howe","Hinton", "Hurley", "Spence", "Zamora", "Yang", "McNeil", "Suarez", "Case", "Petty", "Gould","McFarland", "Sampson", "Carver", "Bray", "Rosario", "MacDonald", "Stout", "Hester", "Melendez", "Dillon","Farley", "Hopper", "Galloway", "Potts", "Hasan", "Bernard", "Joyner", "Stein", "Aguirre", "Osborn", "Mercer","Bender"}

function mply:Namesurvivor(ply,body)
	local namesurvivormale = table.Random(malename)
	local namesurvivorlastmale = table.Random(malelast)
	local femnamesurv = table.Random(femname)
	local femnamesurvlast = table.Random(femlast)
	self:SetNamesurvivor(namesurvivormale.." "..namesurvivorlastmale)

	if self:IsFemale() then
		self:SetNamesurvivor(femnamesurv.." "..femnamesurvlast)
	end
	if self:GetRoleName() == role.SCI_SPECIAL_HEALER then
		self:SetNamesurvivor("Matilda".." "..femnamesurvlast)
	end
    if self:GetRoleName() == role.SCI_SPECIAL__SLOWER then
		self:SetNamesurvivor("Speedwone".." "..namesurvivorlastmale)
	end
	if self:GetRoleName() == role.SCI_SPECIAL_DAMAGE then
		self:SetNamesurvivor("Kelen".." "..namesurvivorlastmale)
	end
	if self:GetRoleName() == role.SCI_SPECIAL_VISION then
		self:SetNamesurvivor("Hedwig".." "..namesurvivorlastmale)
	end
	if self:GetRoleName() == role.SCI_SPECIAL_MINE then
		self:SetNamesurvivor("Feelon".." "..namesurvivorlastmale)
	end
	if self:GetRoleName() == role.SCI_SPECIAL_INVISIBLE then
		self:SetNamesurvivor("Ruprecht".." "..namesurvivorlastmale)
	end
	if self:GetRoleName() == role.SCI_SPECIAL_SPEED then
		self:SetNamesurvivor("Lomao".." "..namesurvivorlastmale)
	end
	if self:GetRoleName() == role.SCI_SPECIAL_SHIELD then
		self:SetNamesurvivor("Shieldmeh".." "..namesurvivorlastmale)
	end
	if self:GetRoleName() == role.SCI_SPECIAL_BOOSTER then
		self:SetNamesurvivor("Georg".." "..namesurvivorlastmale)
	end
	if self:GTeam() == TEAM_GRU then
		self:SetNamesurvivor(table.Random(gru_names).." "..table.Random(gru_lastnames))
	end
end

function mply:ClearBodyGroups()
    for _, v in pairs(self:GetBodyGroups()) do
        self:SetBodygroup(v.id, 0)
    end
end

function GetTableOverride( tab )
	local metatable = {
		__add = function( left, right )
			return AddTables( left, right )
		end
	}
	setmetatable( tab, metatable )
	return tab
end

function mply:AddToStatistics(reason,value)
end

function GM:PlayerSpray(ply)
    return !ply:IsSuperAdmin()
end

function mply:AddToAchievementPoint()
end

function GetAlivePlayers()
	local players = {}
	for k,v in pairs(player.GetAll()) do
		if v:GTeam() != TEAM_SPEC then
			if v:Alive() then
				table.ForceInsert(players, v)
			end
		end
	end
	return players
end

function mply:TakeHealth(number)
	local hp = self:Health()
	local new = hp - number
	if new <= 0 then
		self:Kill()
		return
	end
	self:SetHealth(new)
end

function mply:AddHealth(number)
	local health, max = self:Health(), self:GetMaxHealth()
	local new = health + number
	self:SetHealth(math.min(new, max))
end

function mply:AnimatedHeal(amount)
    local maxHealth = self:GetMaxHealth()
    local targetHealth = math.min(self:Health() + amount, maxHealth)
    local startTime = CurTime()
    local timerName = "AnimatedHeal_" .. self:EntIndex()

    if timer.Exists(timerName) then
        timer.Remove(timerName)
    end

    timer.Create(timerName, 0.1, 3 / 0.1, function()
        local elapsedTime = CurTime() - startTime

        local currentHealth = Lerp(elapsedTime / 3, self:Health(), targetHealth)

        self:SetHealth(math.min(math.Round(currentHealth), maxHealth))

        if elapsedTime >= 3 then
            timer.Remove(timerName)
        end
    end)
end

function mply:UnUseBag()
	if self:GetUsingBag() == "" then return end
	local tbl_bonemerged = ents.FindByClassAndParent( "ent_bonemerged", self )
	for i = 1, #tbl_bonemerged do
	 local bonemerge = tbl_bonemerged[ i ]
	 print(bonemerge:GetModel())
	 if bonemerge:GetModel() == "models/cultist/backpacks/bonemerge/backpack_big.mdl" or bonemerge:GetModel() == "models/cultist/backpacks/bonemerge/backpack_small.mdl" then
		 bonemerge:Remove()
	 end
 local item = ents.Create( self:GetUsingBag(self:GetClass()) )
 if IsValid( item ) then
	 item:Spawn()
	 item:SetPos( self:GetPos() )
 end
 self:SetUsingBag("")
 end
end

function mply:UnUseBro()
 if self:GetUsingArmor() == "" then return end
 local tbl_bonemerged = ents.FindByClassAndParent( "ent_bonemerged", self )
 for i = 1, #tbl_bonemerged do
	 local bonemerge = tbl_bonemerged[ i ]
	 print(bonemerge:GetModel())
	 if bonemerge:GetModel() == "models/cultist/armor_pickable/bone_merge/heavy_armor.mdl" or bonemerge:GetModel() == "models/cultist/armor_pickable/bone_merge/light_armor.mdl" then
		 bonemerge:Remove()
	 end
 local item = ents.Create( self:GetUsingArmor(self:GetClass()) )
 if IsValid( item ) then
	 item:Spawn()
	 item:SetPos( self:GetPos() )
 end
 self:SetUsingArmor("")
 end
end

function mply:UnUseHat()
 if self:GetUsingHelmet() == "" then return end
 local tbl_bonemerged = ents.FindByClassAndParent( "ent_bonemerged", self )
 for i = 1, #tbl_bonemerged do
	 local bonemerge = tbl_bonemerged[ i ]
	 print(bonemerge:GetModel())
	 if bonemerge:GetModel() == "models/cultist/humans/mog/head_gear/mog_helmet.mdl" or bonemerge:GetModel() == "models/cultist/humans/security/head_gear/helmet.mdl" then
		 bonemerge:Remove()
	 end
	 local item = ents.Create( self:GetUsingHelmet(self:GetClass()) )
	 if IsValid( item ) then
		 item:Spawn()
		 item:SetPos( self:GetPos() )
	 end
	 self:SetUsingHelmet("")
 end
end


function GhostBoneMerge(entity, model, no_draw, skin, sub_material)
    local bnmrg = ents.Create("ent_bonemerged")
    entity.bonemerge_ent = bnmrg
    entity.bonemerge_ent:SetModel(model)
    entity.bonemerge_ent:SetSkin(entity:GetSkin())
    entity.bonemerge_ent:Spawn()
    entity.bonemerge_ent:SetParent(entity, 0)
    entity.bonemerge_ent:SetLocalPos(vector_origin)
    entity.bonemerge_ent:SetLocalAngles(angle_zero)
    entity.bonemerge_ent:AddEffects(EF_BONEMERGE)
    entity.bonemerge_ent:AddEffects(EF_NOSHADOW)
    entity.bonemerge_ent:AddEffects(EF_NORECEIVESHADOW)

    if skin then
        entity.bonemerge_ent:SetSkin(skin)
    end

    if not entity.BoneMergedEnts then
        entity.BoneMergedEnts = {}
    end

    if sub_material then
        entity.Sub_Material = sub_material
    end

    if no_draw then
        entity.no_draw = true
    end

	if model:find("/heads/") or model:find("/head/") or model:find("/funnyheads/") or model:find("goc/head") or model:find("balaclavas_new") or model:find("balaclavas") and !model:find("hair") then
        entity.HeadEnt = bnmrg
        if entity.Sub_Material then
            local sub_material_id = 0
            if CORRUPTED_HEADS[model] then
                sub_material_id = 1
            end
            entity.bonemerge_ent:SetSubMaterial(sub_material_id, entity.Sub_Material)
        end
    end

    if no_draw then
        entity.bonemerge_ent.no_draw = no_draw
    end

    entity.BoneMergedEnts[#entity.BoneMergedEnts + 1] = entity.bonemerge_ent

    return bnmrg
end

function Bonemerge(model, entity, skin, sub_material)
    local bnmrg = ents.Create("ent_bonemerged")
	entity.bonemerge_ent = bnmrg
    entity.bonemerge_ent:SetModel(model)
	entity.bonemerge_ent:Spawn()
	entity.bonemerge_ent:SetOwner( entity )
    entity.bonemerge_ent:SetParent( entity )
	entity.bonemerge_ent:SetLocalPos( vector_origin )
    entity.bonemerge_ent:SetLocalAngles( angle_zero )
    entity.bonemerge_ent:SetMoveType( MOVETYPE_NONE )
    entity.bonemerge_ent:AddEffects( EF_BONEMERGE )
    entity.bonemerge_ent:AddEffects( EF_BONEMERGE_FASTCULL )
    entity.bonemerge_ent:AddEffects( EF_PARENT_ANIMATES )

	if ( skin ) then
		entity.bonemerge_ent:SetSkin( skin )
	end
	
	
	if ( sub_material ) then
		entity.Sub_Material = sub_material
	end

	if ( !entity.BoneMergedEnts ) then
		entity.BoneMergedEnts = {}
	end

	if model:find("/heads/") or model:find("/head/") or model:find("/funnyheads/") or model:find("goc/head") or model:find("balaclavas_new") or model:find("balaclavas") and !model:find("hair") then
        entity.HeadEnt = bnmrg
        if entity.Sub_Material then
            local sub_material_id = 0
            if CORRUPTED_HEADS[model] then
                sub_material_id = 1
            end
            entity.bonemerge_ent:SetSubMaterial(sub_material_id, entity.Sub_Material)
        end
    end

	entity.BoneMergedEnts[ #entity.BoneMergedEnts + 1 ] = entity.bonemerge_ent

	return bnmrg
end

function mply:PrintTranslatedMessage( string )
	net.Start( "TranslatedMessage" )
		net.WriteString( string )
	net.Send( self )
end

function mply:ForceDropWeapon( class )
	if self:HasWeapon( class ) then
		local wep = self:GetWeapon( class )
		if IsValid( wep ) and IsValid( self ) then
			if self:GTeam() == TEAM_SPEC then return end
			local atype = wep:GetPrimaryAmmoType()
			if atype > 0 then
				wep.SavedAmmo = wep:Clip1()
			end	
			if wep:GetClass() == nil then return end
			if wep.droppable != nil and !wep.droppable then return end
			self:DropWeapon( wep )
			self:ConCommand( "lastinv" )
		end
	end
end

function mply:DropAllWeapons( strip )
	if GetConVar( "br_dropvestondeath" ):GetInt() != 0 then
		self:UnUseArmor()
	end
	if #self:GetWeapons() > 0 then
		local pos = self:GetPos()
		for k, v in pairs( self:GetWeapons() ) do
			local candrop = true
			if v.droppable != nil then
				if v.droppable == false then
					candrop = false
				end
			end
			if candrop then
				local class = v:GetClass()
				local wep = ents.Create( class )
				if IsValid( wep ) then
					wep:SetPos( pos )
					wep:Spawn()
					if class == "br_keycard" then
						local cardtype = v.KeycardType or v:GetNWString( "K_TYPE", "safe" )
						wep:SetKeycardType( cardtype )
					end
					local atype = v:GetPrimaryAmmoType()
					if atype > 0 then
						wep.SavedAmmo = v:Clip1()
					end
				end
			end
			if strip then
				v:Remove()
			end
		end
	end
end

// just for finding a bad spawns :p
function mply:FindClosest(tab, num)
	local allradiuses = {}
	for k,v in pairs(tab) do
		table.ForceInsert(allradiuses, {v:Distance(self:GetPos()), v})
	end
	table.sort( allradiuses, function( a, b ) return a[1] < b[1] end )
	local rtab = {}
	for i=1, num do
		if i <= #allradiuses then
			table.ForceInsert(rtab, allradiuses[i])
		end
	end
	return rtab
end

function mply:GiveRandomWep(tab)
	local mainwep = table.Random(tab)
	self:Give(mainwep)
	local getwep = self:GetWeapon(mainwep)
	if getwep.Primary == nil then
		print("ERROR: weapon: " .. mainwep)
		print(getwep)
		return
	end
	getwep:SetClip1(getwep.Primary.ClipSize)
	self:SelectWeapon(mainwep)
	self:GiveAmmo((getwep.Primary.ClipSize * 4), getwep.Primary.Ammo, false)
end

function mply:DeleteItems()
	for k,v in pairs(ents.FindInSphere( self:GetPos(), 150 )) do
		if v:IsWeapon() then
			if !IsValid(v.Owner) then
				v:Remove()
			end
		end
	end
end

function mply:UnUseArmor()
	if self:GetUsingCloth() == "armor_goc" or self:GetModel():find("goc.mdl") or self:GetUsingCloth() == "" then return end
	self:SetModel(self.OldModel)
	self:SetSkin(self.OldSkin)
	self:SetupHands()

	for k,v in pairs(self:LookupBonemerges()) do
		if v:GetModel() == "models/cultist/humans/mog/head_gear/mog_helmet.mdl" or v:GetModel() == "models/cultist/humans/balaclavas_new/balaclava_full.mdl" then v:Remove() end
		v:SetInvisible(false)
	end

	self:SetBodyGroups(self.OldBodygroups)
	local item = ents.Create( self:GetUsingCloth(self:GetClass()) )
	if IsValid( item ) then
		item:Spawn()
		item:SetPos( self:GetPos() )
	end
	self:SetUsingCloth("")
end

function mply:SpectatePlayerNext()
	if self:GTeam() != TEAM_SPEC then return end

	self:SetMoveType(MOVETYPE_NOCLIP)

	local players = self:GetValidSpectateTargets()
	if self:GetObserverMode() == OBS_MODE_ROAMING then
		if #players > 0 then
			self:Spectate( OBS_MODE_CHASE )
			self:SetMoveType(MOVETYPE_NOCLIP)
		else
			return
		end
	end

	if #players < 1 then
		self:UnSpectate()
		self:Spectate( OBS_MODE_ROAMING )
		self:SetMoveType(MOVETYPE_NOCLIP)
		return
	end

	local cur_target = self:GetObserverTarget()
	local index

	if !IsValid( cur_target ) then
		index = 1
	else
		for i, v in ipairs( players ) do
			if v == cur_target then
				index = i + 1
				break
			end
		end
	end

	if !index then index = 1 end

	if index > #players then
		index = 1
	end

	local target = players[index]

	if target != cur_target then
		self:SpectateEntity( target )
	end
end

function mply:SpectatePlayerPrev()
	if self:GTeam() != TEAM_SPEC then return end
	self:SetMoveType(MOVETYPE_NOCLIP)

	local players = self:GetValidSpectateTargets()

	if self:GetObserverMode() == OBS_MODE_ROAMING then
		if #players > 0 then
			self:Spectate( OBS_MODE_CHASE )
			self:SetMoveType(MOVETYPE_NOCLIP)
		else
			return
		end
	end

	if #players < 1 then
		self:UnSpectate()
		self:Spectate( OBS_MODE_ROAMING )
		self:SetMoveType(MOVETYPE_NOCLIP)

		return
	end

	local cur_target = self:GetObserverTarget()
	local index

	if !IsValid( cur_target ) then
		index = 1
	else
		for i, v in ipairs( players ) do
			if v == cur_target then
				index = i - 1
				break
			end
		end
	end

	if !index then index = 1 end

	if index < 1 then
		index = #players
	end

	local target = players[index]

	if target != cur_target then
		self:SpectateEntity( target )
	end
end

function mply:ChangeSpectateMode()
	if self:GTeam() != TEAM_SPEC then return end
	self:SetMoveType(MOVETYPE_NOCLIP)
	
	local cur_mode = self:GetObserverMode()

	if #self:GetValidSpectateTargets() < 1 then
		if cur_mode != OBS_MODE_ROAMING then
			self:UnSpectate()
			self:Spectate( OBS_MODE_ROAMING )
			self:SetMoveType(MOVETYPE_NOCLIP)
		end

		return
	end

	if cur_mode == OBS_MODE_ROAMING then
		self:Spectate( OBS_MODE_CHASE )
		self:SetMoveType(MOVETYPE_NOCLIP)
		self:SpectatePlayerNext()
		self:SetMoveType(MOVETYPE_NOCLIP)
	elseif cur_mode == OBS_MODE_IN_EYE then
		self:Spectate( OBS_MODE_CHASE )
		self:SetMoveType(MOVETYPE_NOCLIP)
	elseif cur_mode == OBS_MODE_CHASE then
		--self:Spectate( OBS_MODE_IN_EYE )
	end

end

function mply:GetValidSpectateTargets( all )
	local players = GetActivePlayers()
	local tab = {}

	for k, v in pairs(players) do
		if v:GTeam() != TEAM_SPEC or !v:Alive() then return end
		if all then
			table.insert( players, v )
		end
	end
end

function mply:InvalidatePlayerForSpectate()
    local roam = #self:GetValidSpectateTargets() < 1
    for k, v in pairs(player.GetAll()) do
        if v:GTeam() != TEAM_SPEC then return end
        if v != self then
            if v:GetObserverTarget() == self then
                if roam then
                    v:UnSpectate()
                    v:Spectate(OBS_MODE_ROAMING)
                else
                    v:SpectatePlayerNext()
                end
                self:SetMoveType(MOVETYPE_NOCLIP)
            end
        end
    end
end

function CheckSpectatorMode( all )
	for k, v in pairs( player.GetAll() ) do
		if v:GTeam() == TEAM_SPEC then
			v:CheckSpectatorMode( all )
		end
	end
end

function mply:SetSpectator()
	local players = self:GetValidSpectateTargets() or {}
	--self:CrosshairEnable()
	--self:SetNamesurvivor("Spectator")
	self:Flashlight( false )
	self:AllowFlashlight( false )
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetRoleName(role.Spectator)
	self:SetGTeam(TEAM_SPEC)
	self:SetNoDraw(true)
	self:SetNoTarget( true )
	--self:SetNoCollideWithTeammates(true)

	if roam or #players < 1 then
		self:UnSpectate()
		self:Spectate( OBS_MODE_ROAMING )
		self:SetMoveType( MOVETYPE_NOCLIP )
	else
		self:Spectate( OBS_MODE_CHASE )
		self:SpectateEntity( players[1] )
		self:SetMoveType( MOVETYPE_NOCLIP )
	end

	--if self.SetRoleName then self:SetRoleName(role.Spectator) end
	self.Active = true
	self.BaseStats = nil
	self.UsingArmor = nil
	self.canblink = false
	self.handsmodel = nil

	self:SetMoveType(MOVETYPE_NOCLIP)

	--print("adding " .. self:Nick() .. " to spectators")
end

function mply:SetSCP0082( hp, speed, spawn )
end

function mply:SetInfectD()
end

function mply:SetInfectMTF()
end

function mply:SetupNormal()
	self.BaseStats = nil
	self.UsingArmor = nil
	self.handsmodel = nil
	self:UnSpectate()
	self:Spawn()
	self:GodDisable()
	self:SetNoDraw(false)
	self:SetNoTarget(false)
	self:SetupHands()
	self:RemoveAllAmmo()
	self:StripWeapons()
	self.canblink = true
	self.noragdoll = false
	self.scp1471stacks = 1
end

function mply:SetupAdmin()
end

function UIUSpy_MakeDocuments()
    local igroki_s_documentami = {}

    for _, ply in ipairs(player.GetAll()) do
        if ply:GTeam() != TEAM_SCP or ply:GTeam() != TEAM_SPEC or ply:GetRoleName() != "UIU Spy" then
            table.insert(igroki_s_documentami, ply)
        end
    end

    if #igroki_s_documentami >= 3 then
        for i = 1, 3 do
            local index = math.random(1, #igroki_s_documentami)
            local target = igroki_s_documentami[index]
            
            target:Give("item_special_document")
            target:RXSENDNotify("Вы являетесь важным сотрудником фонда! При себе вы имеете важные документы, которые вы должны эвакуировать и не умереть.")
            target:SetNWBool("Have_docs", true)

            table.remove(igroki_s_documentami, index)
        end
    end
end

function mply:MakeZombie()
	for i, material in pairs(self:GetMaterials()) do
		i = i -1
		if !table.HasValue(BREACH.ZombieTextureMaterials, material) then
			if string.StartWith(material, "models/all_scp_models/") then
				local str = string.sub(material, #"models/all_scp_models//")
				str = "models/all_scp_models/zombies/"..str
				self:SetSubMaterial(i, str)
			end
		else
			self:SetSubMaterial(i, "!ZombieTexture")
		end
	end
	if !self.BoneMergedEnts then return end
	for _, bnmrg in pairs(self.BoneMergedEnts) do
		if !IsValid(bnmrg) then continue end
		if bnmrg:GetModel():find("male_head_") or bnmrg:GetModel():find("balaclava") then
			self.FaceTexture = "models/all_scp_models/zombies/shared/heads/head_1_1"
			if CORRUPTED_HEADS[bnmrg:GetModel()] then
				bnmrg:SetSubMaterial(1, self.FaceTexture)
			else
				bnmrg:SetSubMaterial(0, self.FaceTexture)
			end
		else
			for i, material in pairs(bnmrg:GetMaterials()) do
				i = i -1
				if !table.HasValue(BREACH.ZombieTextureMaterials, material) then
					if string.StartWith(material, "models/all_scp_models/") then
						local str = string.sub(material, #"models/all_scp_models//")
						str = "models/all_scp_models/zombies/"..str
						bnmrg:SetSubMaterial(i, str)
					end
				else
					bnmrg:SetSubMaterial(i, "!ZombieTexture")
				end
			end
		end
	end
end

function mply:SurvivorCleanUp()
    self:ClearBodyGroups()
    self:SetSkin(0)

    if self:GTeam() ~= TEAM_SCP then
        local tbl_bonemerged = ents.FindByClassAndParent("ent_bonemerged", self) or {}
        for i = 1, #tbl_bonemerged do
            local bonemerge = tbl_bonemerged[i]
            bonemerge:Remove()
        end

        self:StripWeapons()
        self:StripAmmo()
        self:SetNW2Bool("Breach:CanAttach", false)
        self:SetUsingBag("")
        self:SetUsingCloth("")
        self:SetUsingArmor("")
        self:SetUsingHelmet("")
        self:SetStamina(200)
		self:SetNWBool("Have_docs", false)
        self:Flashlight(false)
        self:SetBoosted(false)
		self:SetForcedAnimation(false)
		self:SetMaxSlots(8)
		self:SetInDimension(false)
    end
end

function mply:SetupCISpy()
	local rand = math.random(1, 3)
	if rand == 1 then
			self:SetBodygroup(3, 7)
			self:SetBodygroup(4, 1)
			self:StripWeapons()
			Bonemerge(BREACH_ROLES.SECURITY.security.roles[1].headgear, self)
			for k, v in pairs(BREACH_ROLES.SECURITY.security.roles[1].weapons) do
				self:Give(v)
				self:Give("breach_keycard_security_1")
				self:Give("item_tazer")
				self:StripAmmo()
				self:GetWeapon("item_tazer"):SetClip1(20)
			end
	elseif rand == 2 then
		    for k,v in pairs(self:LookupBonemerges()) do v:Remove() end
			self:SetBodygroup(3, 4)
			self:SetBodygroup(5, 2)
				Bonemerge(BREACH_ROLES.SECURITY.security.roles[3].head, self)
				Bonemerge(BREACH_ROLES.SECURITY.security.roles[3].headgear, self)
			self:StripWeapons()
			for k, v in pairs(BREACH_ROLES.SECURITY.security.roles[3].weapons) do
				self:Give(v)
				self:Give("breach_keycard_security_2")
				self:Give("item_tazer")
				self:StripAmmo()
				self:GetWeapon("item_tazer"):SetClip1(20)
			end
	elseif rand == 3 then 
		    for k,v in pairs(self:LookupBonemerges()) do v:Remove() end
			self:SetBodygroup(3, 5)
			self:SetBodygroup(5, 1)
			Bonemerge(BREACH_ROLES.SECURITY.security.roles[7].head, self)
			Bonemerge(BREACH_ROLES.SECURITY.security.roles[7].headgear, self)
			self:StripWeapons()
			for k, v in pairs(BREACH_ROLES.SECURITY.security.roles[7].weapons) do
				self:Give(v)
				self:Give("item_tazer")
				self:Give("breach_keycard_security_2")
				self:StripAmmo()
				self:GetWeapon("item_tazer"):SetClip1(20)
		    end
	  end
end

function mply:ApplyRoleStats(role)
	self:SetRoleName( role.name )
	self:SetGTeam( role.team )

	self.kills = 0
	self.teamkills = 0

	local isblack = math.random(1,3) == 1
	if role.white == true then isblack = false end
	local HeadModel = istable(role["head"]) and table.Random(role["head"]) or role["head"]

	if role.models and role.fmodels then
		local selfmodel
	
		if math.random(0, 1) == 0 then
			selfmodel = role.fmodels
		else
			selfmodel = role.models
		end
	
		local finalselfmodel = selfmodel[math.random(1, #selfmodel)]
	
		self:SetModel(finalselfmodel)
	else
		if role.models then
			local finalselfmodel = role.models[math.random(1, #role.models)]
			self:SetModel(finalselfmodel)
		elseif role.fmodels then
			local finalselfmodel = role.fmodels[math.random(1, #role.fmodels)]
			self:SetModel(finalselfmodel)
		end
	end

    self:SurvivorCleanUp()

	if role.head then Bonemerge(HeadModel,self) end

	if role["usehead"] then
		if role["randomizehead"] then
			if self:GetRoleName() == "Class-D Bor" then return end
			if !self:IsFemale() then
				Bonemerge(PickHeadModel(self:SteamID64()), self)
			elseif self:IsFemale() then
				Bonemerge(PickHeadModel(self:SteamID64(), true), self)
			end
		else
			Bonemerge("models/cultist/heads/male/male_head_1.mdl", self)
		end
	end

	if role["randomizeface"] or !role["white"] then
		for k,v in pairs(self:LookupBonemerges()) do
			if CORRUPTED_HEADS[v:GetModel()] then v:SetSubMaterial(1, PickFaceSkin(isblack,self:SteamID64(),false)) end
			if v:GetModel():find("fat_heads") or v:GetModel():find("bor_heads") then continue end
			if v:GetModel():find("heads") or v:GetModel():find("balaclavas_new") then
				if !self:IsFemale() then
				v:SetSubMaterial(0, PickFaceSkin(isblack,self:SteamID64(),false))
			elseif
			  self:IsFemale() then
				v:SetSubMaterial(0, PickFaceSkin(isblack,self:SteamID64(),true))
			  end
			end
		end
	end

	local HairModel = nil
	if math.random(1, 5) > 1 then
		if isblack and !self:IsFemale() and role["blackhairm"] then
			HairModel = role["blackhairm"][math.random(1, #role["blackhairm"])]
		elseif role["hairm"] and !self:IsFemale() then
			HairModel = role["hairm"][math.random(1, #role["hairm"])]
		elseif role["hairf"] and self:IsFemale() then
			HairModel = role["hairf"][math.random(1, #role["hairf"])]
		end
	end
 
    if HairModel then
		if self:GetRoleName() == "Medic" and !self:IsFemale() then return end
		Bonemerge(HairModel,self)
	end
   	
	if isblack and self:GetModel():find("class_d") then
		self:SetSkin(1)
	end

	if isblack and self:GetRoleName() == "Class-D Bor" then
		for k,v in pairs(self:LookupBonemerges()) do
			if v:GetModel():find("bor_heads") then
				v:SetSkin(1)
			end
		end
	end

	if role.skin then
		self:SetSkin(role.skin)
	elseif !isblack then
		self:SetSkin(0)
	end

	if role.headgear then Bonemerge(role.headgear, self) end
	if role.hackerhat then Bonemerge(role.hackerhat, self) end
	if role.bodygroups then self:SetBodyGroups( role.bodygroups ) end

	for i = 0, 9 do
        local bodygroupKey = "bodygroup" .. i
        if role[bodygroupKey] then
            self:SetBodygroup(i, role[bodygroupKey])
        end
    end
	
	if role.cispy then
		self:SetupCISpy()
	end

    if role.weapons and role.weapons ~= "" then
        for _, weapon in pairs(role.weapons) do
            self:Give(weapon)
        end
    end

	if role.keycard and role.keycard != "" then 
		self:Give("breach_keycard_"..role.keycard)
	end 

    self:StripAmmo()

    if role.ammo and role.ammo ~= "" then
        for _, ammo in pairs(role.ammo) do
            self:GiveAmmo(ammo[2], self:GetWeapon(ammo[1]):GetPrimaryAmmoType(), true)
        end
    end

    if self:HasWeapon("item_tazer") then
        self:GetWeapon("item_tazer"):SetClip1(20)
    end
	
	if self:HasWeapon("item_radio") then
		local radio = self:GetWeapon( "item_radio" )
		net.Start("SetFrequency")
		net.WriteEntity(self:GetWeapon( "item_radio" ))
		net.WriteFloat(Radio_GetChannel(self:GTeam(), self:GetRoleName()))
		net.Broadcast()
		self:GetWeapon("item_radio").Channel = Radio_GetChannel(self:GTeam(), self:GetRoleName())
	end

	self:Namesurvivor()
    
	if role.damage_modifiers then
		self.HeadResist = role.damage_modifiers["HITGROUP_HEAD"]
		self.GearResist = role.damage_modifiers["HITGROUP_CHEST"]
		self.StomachResist = role.damage_modifiers["HITGROUP_STOMACH"]
		self.ArmResist = role.damage_modifiers["HITGROUP_RIGHTARM"]
		self.LegResist = role.damage_modifiers["HITGROUP_RIGHTLEG"]
	end
	
	self:SetNWString("AbilityName", "")
	self.AbilityTAB = nil
	self:SendLua("if BREACH.Abilities and IsValid(BREACH.Abilities.HumanSpecialButt) then BREACH.Abilities.HumanSpecialButt:Remove() end if BREACH.Abilities and IsValid(BREACH.Abilities.HumanSpecial) then BREACH.Abilities.HumanSpecial:Remove() end")
	self:SetSpecialMax(0)
	self:SetSpecialCD(10)

	if role.ability then
        net.Start("SpecialSCIHUD")
        net.WriteString(role["ability"][1])
        net.WriteUInt(role["ability"][2], 9)
        net.WriteString(role["ability"][3])
        net.WriteString(role["ability"][4])
        net.WriteBool(role["ability"][5])
        net.Send(self)
        self:SetNWString("AbilityName", (role["ability"][1]))
	end

    if role.ability_max then
	   self:SetSpecialMax( role["ability_max"] )
    end

	self:SetHealth(role.health)
	self:SetMaxHealth(role.health)

	if role.walkspeed then
		self:SetWalkSpeed(100 * (role.walkspeed or 1))
    else
  		self:SetWalkSpeed(100)
	end
	
	if role.runspeed then
		self:SetRunSpeed(195 * (role.runspeed or 1))
	else
		self:SetRunSpeed(195)
	end
	
	if self:GetRoleName() == "Class-D Fast" then
		self:SetRunSpeed(231)
	end
	
	if role.jumppower then
		self:SetJumpPower(190 * (role.jumppower or 1))
    else
  		self:SetJumpPower(190)
	end
	
	if role.stamina then 
		self:SetStaminaScale(role.stamina)
	end

	if role.maxslots then 
		self:SetMaxSlots(role.maxslots) 
	end

	if self:GTeam() == TEAM_CLASSD and self:IsPremium() then
        self:SetBodygroup(0, math.random(0, 4))
    end
	
	self:Flashlight( false )
	net.Start("RolesSelected")
	net.Send(self)

	self:SetupHands()

	if self:GetRoleName() == "UIU Spy" and timer.Exists("RoundTime") then
		UIUSpy_MakeDocuments()
	end
end

function mply:IsActivePlayer()
	return self.Active
end

hook.Add( "KeyPress", "keypress_spectating", function( ply, key )
	if ply:GTeam() != TEAM_SPEC or ply:GetRoleName() == role.ADMIN then return end
	if ( key == IN_ATTACK ) then
		ply:SpectatePlayerLeft()
		ply:SetMoveType(MOVETYPE_NOCLIP)
	elseif ( key == IN_ATTACK2 ) then
		ply:SpectatePlayerRight()
		ply:SetMoveType(MOVETYPE_NOCLIP)
	elseif ( key == IN_RELOAD ) then
		ply:ChangeSpecMode()
		ply:SetMoveType(MOVETYPE_NOCLIP)
	end
end )

function mply:SpectatePlayerRight()
	if !self:Alive() then return end
	if self:GetObserverMode() != OBS_MODE_IN_EYE and
	   self:GetObserverMode() != OBS_MODE_CHASE 
	then return end
	self:SetNoDraw(true)
	local allply = GetAlivePlayers()
	if #allply == 1 then return end
	if not self.SpecPly then
		self.SpecPly = 0
	end
	self.SpecPly = self.SpecPly - 1
	if self.SpecPly < 1 then
		self.SpecPly = #allply 
	end
	for k,v in pairs(allply) do
		if k == self.SpecPly then
			self:SpectateEntity( v )
			self:SetMoveType(MOVETYPE_NOCLIP)
		end
	end
end

function mply:SpectatePlayerLeft()
	if !self:Alive() then return end
	if self:GetObserverMode() != OBS_MODE_IN_EYE and
	   self:GetObserverMode() != OBS_MODE_CHASE 
	then return end
	self:SetNoDraw(true)
	local allply = GetAlivePlayers()
	if #allply == 1 then return end
	if not self.SpecPly then
		self.SpecPly = 0
	end
	self.SpecPly = self.SpecPly + 1
	if self.SpecPly > #allply then
		self.SpecPly = 1
	end
	for k,v in pairs(allply) do
		if k == self.SpecPly then
			self:SpectateEntity( v )
			self:SetMoveType(MOVETYPE_NOCLIP)
		end
	end
end

function mply:ChangeSpecMode()
	if !self:Alive() then return end
	if !(self:GTeam() == TEAM_SPEC) then return end
	self:SetNoDraw(true)
	self:SetMoveType(MOVETYPE_NOCLIP)
	local m = self:GetObserverMode()
	local allply = #GetAlivePlayers()
	if allply < 2 then
		self:Spectate(OBS_MODE_ROAMING)
		self:SetMoveType(MOVETYPE_NOCLIP)
		return
	end

	if m == OBS_MODE_IN_EYE then
		self:Spectate(OBS_MODE_CHASE)	
	elseif m == OBS_MODE_CHASE then
		self:SetMoveType(MOVETYPE_NOCLIP)
		if GetConVar( "br_allow_roaming_spectate" ):GetInt() == 1 then
			self:Spectate(OBS_MODE_ROAMING)
		elseif GetConVar( "br_allow_ineye_spectate" ):GetInt() == 1 then
			self:Spectate(OBS_MODE_IN_EYE)
			self:SpectatePlayerLeft()
			self:SetMoveType(MOVETYPE_NOCLIP)
		else
			self:SpectatePlayerLeft()
			self:SetMoveType(MOVETYPE_NOCLIP)
		end	
	elseif m == OBS_MODE_ROAMING then
		if GetConVar( "br_allow_ineye_spectate" ):GetInt() == 1 then
			self:Spectate(OBS_MODE_IN_EYE)
			self:SpectatePlayerLeft()
		else
			self:Spectate(OBS_MODE_CHASE)
			self:SpectatePlayerLeft()
			self:SetMoveType(MOVETYPE_NOCLIP)
		end
	else
		self:Spectate(OBS_MODE_ROAMING)
		self:SetMoveType(MOVETYPE_NOCLIP)
	end
end

function mply:SaveExp()
	self:SetPData( "breach_exp", self:GetExp() )
end

function mply:SaveLevel()
	self:SetPData( "breach_level", self:GetLevel() )
end

function mply:AddExp(amount, msg)
	--amount = amount * GetConVar("br_expscale"):GetInt()
	--if self.Premium == true then
		--amount = amount * GetConVar("br_premium_mult"):GetFloat()
	--end
	amount = math.Round(amount)
	--if not self.GetNEXP then
	--	player_manager.RunClass( self, "SetupDataTables" )
	--end
	self:SetNEXP( self:GetNEXP() + amount )
	self:SetPData( "breach_exp", self:GetExp() )

	local xp = self:GetNEXP()
	local lvl = self:GetNLevel()

	if xp > (680 * math.max(1, self:GetNLevel())) then
		self:SetNEXP(xp - (680 * math.max(1, self:GetNLevel())))
		self:SetNLevel( self:GetNLevel() + 1 )
		self:SetPData( "breach_level", self:GetNLevel() )
	end

	if self:GetNEXP() < 0 then
		self:SetNEXP(1)
	end
	
end

function mply:AddLevel(amount)
	if not self.GetNLevel then
		player_manager.RunClass( self, "SetupDataTables" )
	end
	if self.GetNLevel and self.SetNLevel then
		self:SetNLevel( self:GetNLevel() + amount )
		self:SetPData( "breach_level", self:GetNLevel() )
	else
		if self.SetNLevel then
			self:SetNLevel( 0 )
		else
			ErrorNoHalt( "Cannot set the exp, SetNLevel invalid" )
		end
	end
end


function mply:SurvivorSetRoleName(name)
	local rl = nil
	for k,v in pairs(BREACH_ROLES) do
		for _,role in pairs(v.roles) do
			if role.name == name then
				rl = role
			end
		end
	end
	if rl != nil then
		self:ApplyRoleStats(rl)
	end
end

function mply:SetActive( active )
	self.ActivePlayer = active
	self:SetNActive( active )
	if !gamestarted then
		CheckStart()
	end
end

function mply:ToggleAdminModePref()
	if self.admpref == nil then self.admpref = false end
	if self.admpref then
		self.admpref = false
		if self.AdminMode then
			self:ToggleAdminMode()
			self:SetSpectator()
		end
	else
		self.admpref = true
		if self:GetRoleName() == role.Spectator then
			self:ToggleAdminMode()
			self:SetupAdmin()
		end
	end
end

function mply:ToggleAdminMode()
	if self.AdminMode == nil then self.AdminMode = false end
	if self.AdminMode == true then
		self.AdminMode = false
		self:SetActive( true )
		self:DrawWorldModel( true ) 
	else
		self.AdminMode = true
		self:SetActive( false )
		self:DrawWorldModel( false ) 
	end
end

hook.Add( "SetupMove", "StanceSpeed", function( ply, mv, cmd )
	local velLength = ply:GetVelocity():Length2DSqr()

	if ( mv:KeyReleased( IN_SPEED ) || mv:KeyDown( IN_SPEED ) && velLength < .25 ) then
		ply.Run_fading = true
	end

	if ( mv:KeyDown( IN_SPEED ) && velLength > .25 || ply.SprintMove && !ply.Run_fading ) then

		if ( ply:IsLeaning() ) then
			ply:SetNW2Int( "LeanOffset", 0 )
			ply.OldStatus = nil
		end

		if ( !ply.SprintMove ) then
			ply.Run_fading = nil
			ply.SprintMove = true
			ply.Sprint_Speed = ply:GetWalkSpeed()
		end

		ply.Sprint_Speed = math.Approach( ply.Sprint_Speed, ply:GetRunSpeed(), FrameTime() * 128 )

		mv:SetMaxClientSpeed( ply.Sprint_Speed )
		mv:SetMaxSpeed( ply.Sprint_Speed )

	elseif ( ply.SprintMove && ply.Run_fading ) then
		local walk_Speed = ply:GetWalkSpeed()

		ply.Sprint_Speed = math.Approach( ply.Sprint_Speed, walk_Speed, FrameTime() * 128 )

		mv:SetMaxClientSpeed( ply.Sprint_Speed )
		mv:SetMaxSpeed( ply.Sprint_Speed )

		if ( ply.Sprint_Speed == walk_Speed ) then
			ply.SprintMove = nil
			ply.Sprint_Speed = nil
		end
	end


	if ( ply:Crouching() ) then
		local walk_speed = ply:GetWalkSpeed()

		mv:SetMaxClientSpeed( walk_speed * .5 )
		mv:SetMaxSpeed( walk_speed * .5 )
	end


	local wep = ply:GetActiveWeapon()

	if ( wep != NULL && wep.CW20Weapon && wep.dt.State == CW_AIMING ) then
		mv:SetMaxClientSpeed( mv:GetMaxClientSpeed() * .5 )
		mv:SetMaxSpeed( mv:GetMaxSpeed() * .5 )
	end

	if ( ply:IsLeaning() ) then
		mv:SetMaxClientSpeed( mv:GetMaxClientSpeed() * .75 )
		mv:SetMaxSpeed( mv:GetMaxSpeed() * .75 )
	end

	if ( ply.SpeedMultiplier ) then
		mv:SetMaxClientSpeed( mv:GetMaxClientSpeed() * ply.SpeedMultiplier )
		mv:SetMaxSpeed( mv:GetMaxSpeed() * ply.SpeedMultiplier )
	end
end)

local ment = FindMetaTable('Entity')

function mply:Make409Statue()

	if self.Used500 then return end

	local ragdoll

	if self:HasWeapon("item_special_document") then
		local document = ents.Create("item_special_document")
		document:SetPos(self:GetPos() + Vector(0,0,20))
		document:Spawn()
		document:GetPhysicsObject():SetVelocity(Vector(table.Random({-100,100}),table.Random({-100,100}),175))
	end

	if !self.DeathAnimation then
		ragdoll = ents.Create("prop_ragdoll")
		ragdoll:SetModel(self:GetModel())
		ragdoll:SetSkin(self:GetSkin())

		ragdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

		for i = 0, 9 do
			ragdoll:SetBodygroup(i, self:GetBodygroup(i))
		end
		ragdoll:SetPos(self:GetPos())
		ragdoll:Spawn()
		
		ragdoll:SetMaterial("nextoren/ice_material/icefloor_01_new")

		if ( ragdoll && ragdoll:IsValid() ) then

				for i = 1, ragdoll:GetPhysicsObjectCount() do

					local physicsObject = ragdoll:GetPhysicsObjectNum( i )
					local boneIndex = ragdoll:TranslatePhysBoneToBone( i )
					local position, angle = self:GetBonePosition( boneIndex )

					if ( physicsObject && physicsObject:IsValid() ) then

						physicsObject:SetPos( position )
						physicsObject:SetMass( 65 )
						physicsObject:SetAngles( angle )
						physicsObject:EnableMotion(false)
						physicsObject:Wake()

				end
			end

		end

		local bonemerges = ents.FindByClassAndParent("ent_bonemerged", self)
		if istable(bonemerges) then
			for _, bnmrg in pairs(bonemerges) do
				if IsValid(bnmrg) and !bnmrg:GetNoDraw() then
					local bnmrg_rag = Bonemerge(bnmrg:GetModel(), ragdoll)
					bnmrg_rag:SetMaterial("nextoren/ice_material/icefloor_01_new")
				end
			end
		end

	end

	self:AddToStatistics("l:scp409_death", -100)
	self:LevelBar()

	local pos = self:GetPos()
	local ang = self:GetAngles()

	self:SetupNormal()
	self:SetSpectator()

	return ragdoll
end


function mply:SCP409Infect()
	self.Infected409 = true

	self:Make409Statue()

	timer.Simple(1, function()
		self.Infected409 = nil
	end)
	
end

function mply:Start409Infected()
	if !IsValid(self) and !self:IsPlayer() then return end
	self.Infected409 = true
	print("заразився 409 "..self:Name())
	self:SetBottomMessage("l:scp409_1st_stage")
	timer.Create("MEGAINFECTEDMESSAGE"..self:SteamID(), math.random(30,35), 1, function()
		self:SetBottomMessage("l:scp409_2st_stage")
		self:ScreenFade( SCREENFADE.IN, Color( 21, 108, 221, 190), 0.5, 0.5 )
		timer.Remove("MEGAINFECTEDMESSAGE"..self:SteamID())
	end)
	timer.Create("INFECTED"..self:SteamID(), math.random(134,146), 1, function()
		self:ScreenFade( SCREENFADE.IN, Color( 21, 108, 221, 190), 16, 10 )

		net.Start("ForcePlaySound")
		net.WriteString("nextoren/others/freeze_sound.ogg")
		net.Send(self)

		timer.Simple(16, function()
		evacuate(self,"vse",-200,"l:scp409_death")
		self:Make409Statue()

		self.Infected409 = nil
		timer.Remove("INFECTED"..self:SteamID())
		end)
	end)
end
