db.teams.drop();

// 1 - create a collections called your_student_id_teams and insert the
// documents about teams and football players contained in this file
db.teams.insert({
	team_id: "eng1",
	date_founded: new Date("Oct 04, 1896"),
     league: "Premier League",
	 points: 62,
	 name: "Manchester United",
     players: [ { p_id: "Rooney", goal: 85, caps: 125, age: 28 },
              { p_id: "Scholes", goal: 15, caps: 225, age: 28 },
			  { p_id: "Giggs", goal: 45, caps: 359, age: 38 } ]
	 });

db.teams.insert({
	team_id: "eng2",
	date_founded: new Date("Oct 04, 1899"),
     league: "Premier League",
	 points: 52,
	 name: "Arsenal",
     players: [ { p_id: "Mata", goal: 5, caps: 24, age: 27 },
              { p_id: "Bergkamp", goal: 95, caps: 98, age: 48 } ]
	 });

db.teams.insert({
	team_id: "eng3",
	date_founded: new Date("Oct 04, 1912"),
     league: "Premier League",
	 points: 65,
	 name: "Chelsea",
     players: [ { p_id: "Costa", goal: 15, caps: 25, age: 28 },
              { p_id: "Ivanov", goal: 5, caps: 84, age: 28 },
			  { p_id: "Drogba", goal: 105, caps: 125, age: 35 } ]
	 });

db.teams.insert({
	team_id: "spa1",
	date_founded: new Date("Oct 04, 1912"),
     league: "La Liga",
	 points: 80,
	 name: "Barcelona",
     players: [ { p_id: "Messi", goal: 195, caps: 189, age: 30 },
              { p_id: "Valdes", goal: 0, caps: 158, age: 27 },
			  { p_id: "Iniesta", goal: 72, caps: 25, age: 31},
			  { p_id: "Pique", goal: 9, caps: 201, age: 38 } ]
	 });

db.teams.insert({
	team_id: "spa2",
	date_founded: new Date("Nov 04, 1914"),
     league: "La Liga",
	 points: 72,
	 name: "Real Madrid",
     players: [ { p_id: "Ronaldo", goal: 135, caps: 134, age: 28 },
				 { p_id: "Bale", goal: 75, caps: 45, age: 27 },
				 { p_id: "Marcelo", goal: 11, caps: 25, age: 31 },
              { p_id: "Benzema", goal: 125, caps: 95, age: 22 } ]
	 });

db.teams.insert({
	team_id: "spa3",
	date_founded: new Date("Oct 04, 1912"),
     league: "La liga",
	 points: 68,
	 name: "Valencia",
     players: [ { p_id: "Martinez", goal: 26, caps: 54, age: 21 },
              { p_id: "Aimar", goal: 45, caps: 105, age: 29 } ]
	 });

db.teams.insert({
	team_id: "ita1",
	date_founded: new Date("Oct 04, 1922"),
     league: "Serie A",
	 points: 69,
	 name: "Roma",
     players: [ { p_id: "Totti", goal: 198, caps: 350, age: 35 },
              { p_id: "De Rossi", goal: 5, caps: 210, age: 30 },
			  { p_id: "Gervinho", goal: 43, caps: 57, age: 24 } ]
	 });

db.teams.insert({
	team_id: "ita2",
	date_founded: new Date("Oct 04, 1899"),
     league: "Serie A",
	 points: 52,
	 name: "Juventus",
     players: [ { p_id: "Buffon", goal: 0, caps: 225, age: 37 },
              { p_id: "Pirlo", goal: 45, caps: 199, age: 35 },
			  { p_id: "Pogba", goal: 21, caps: 42, age: 20 } ]
	 });

db.teams.insert({
	team_id: "ita3",
	date_founded: new Date("Oct 04, 1911"),
     league: "Serie A",
	 points: 62,
	 name: "AC Milan",
     players: [ { p_id: "Inzaghi", goal: 115, caps: 189, age: 35 },
              { p_id: "Abbiati", goal: 0, caps: 84, age: 24 },
			  { p_id: "Van Basten", goal: 123, caps: 104, age: 35 } ]
	 });

db.teams.insert({
	team_id: "ita4",
	date_founded: new Date("Oct 04, 1902"),
  league: "Serie A",
  points: 71,
  name: "Inter Milan",
  players: [
      { p_id: "Handanovic", goal: 0, caps: 51, age: 29 },
      { p_id: "Cambiasso", goal: 35, caps: 176, age: 35 },
      { p_id: "Palacio", goal: 78, caps: 75, age: 31 }
    ]
	 });

// 2 - Insert two new players to man utd and ac milan
db.teams.update(
  {team_id : "eng1"},
  {
    $push : {
      players : {
        p_id: "Keane", goal: 44, caps: 326, age: 33
      }
    }
  }
);

db.teams.update(
  {team_id : "ita3"},
  {
    $push : {
      players : {
        p_id: "Kaka", goal: 32, caps: 112, age: 53
      }
    }
  }
);

// 3 - Find the oldest team
db.teams.find().limit(1).sort({
    date_founded : 1
  }).pretty();

// 4 - Update the number of goals of all the Real Madrid Players by 3 goals each
db.teams.find({team_id : "spa2"}).pretty();

db.teams.update(
  {team_id : "spa2"},
  {
    $inc : {
      "players.0.goal" : 3,
      "players.1.goal" : 3,
      "players.2.goal" : 3,
      "players.3.goal" : 3
    }
  }
);

// 5 - Using a cursor, update the number of caps of all the "Serie A" teams
// by incrementing them by 10% (round it!)
var myCursor = db.teams.find({league: "Serie A"});

var documentArray = myCursor.toArray();

for (var i in documentArray) {
  var playerArray = documentArray[i].players;

  for (var j in playerArray) {
    updatedCaps = Math.round(playerArray[j].caps + (playerArray[j].caps
			* 10/100));

		var dataToSet={};
		dataToSet["players."+j+".caps"] = updatedCaps;

		db.teams.update({"_id" : documentArray[i]._id}, {$set : dataToSet});
		printjson(updatedCaps);
  }
};

// 6 - Update the points of Arsenal to be equal to the points of Barcelona
var barCursor = db.teams.find({team_id: "spa1"}, {points : 1});
var barDocArray = barCursor.toArray();
var barPoints = barDocArray[0].points;
print(barPoints);

var arsCursor = db.teams.find({team_id: "eng2"}, {points : 1});
var arsDocArray = arsCursor.toArray();

var dataToSet={};
dataToSet["points"] = barPoints;
db.teams.update({"_id" : arsDocArray[0]._id}, {$set : dataToSet});

// 7 - Find all the players over 30 years old containing the string "es"
db.teams.aggregate(
	[
		{
			$unwind : "$players"
		},
		{
			$match :
			{
				"players.p_id" : {
					$regex : /es/g
				}
			}
		},
		{
			$match :
			{
				"players.age" : {
					$gte : 30
				}
			}
		}
	]
);

// 8 - Using aggregate mongoDB operator, list the total points by league
db.teams.aggregate(
	[
		{
			$group : {
				"_id" : "$league",
				totalPoints : {
					$sum : "$points"
				}
			}
		}
	]
);

// 9 - Using aggregation, list all the teams by number of goals in desc order
db.teams.aggregate(
	[
		{
			$unwind : "$players"
		},
		{
			$group : {
				"_id" : "$name",
				totalGoals : {
					$sum : "$players.goal"
				}
			}
		},
		{
			$sort : {
				totalGoals : -1
			}
		}
	]
);

// 10 - Compute the average number of goals per match per player and store the
// output in a collection named student_id_avg_goals.
db.teams.aggregate(
	[
		{
			$unwind : "$players"
		},
		{
			$project : {
				"_id" : 0,
				"players.p_id" : 1,
				averageGoals : {
					$divide : ["$players.goal", "$players.caps"]
				}
			}
		},
		{
			$out : "C13451458_avg_goals"
		}
	]
);

// 11 - Write a js function old_vs_young(x), that receives a positive integer x
// representing the age of a player and returns 1 if the total number of goals
// scored by the players with age >= x years is greater than the total number of
// goals scored by the players with age < x, otherwise it returns 0.
// The function also prints the number of goals for each group of players
function old_vs_young(x) {
	
}
