db.system.js.save(
   {
     _id: "old_vs_young",
     value : function(x) { 
			 var gteCursor = db.teams.aggregate(
				 [
					 {
			 			$unwind : "$players"
			 		},
          {
  					$match :
  					{
  						"players.age" : {
  							$gte : x
  						}
  					}
          },
          {
      			$group : {
      				"_id" : null,
      				totalGoals : {
      					$sum : "$players.goal"
      				}
      			}
      		},
          {
            $project : {
              "_id" : 0,
              totalGoals : 1 
            }
          }
				 ]
			 ).toArray(); 
       
       var ltCursor = db.teams.aggregate(
				 [
					 {
			 			$unwind : "$players"
			 		},
          {
  					$match :
  					{
  						"players.age" : {
  							$lt : x
  						}
  					}
          },
          {
      			$group : {
      				"_id" : null,
      				totalGoals : {
      					$sum : "$players.goal"
      				}
      			}
      		},
          {
            $project : {
              "_id" : 0,
              totalGoals : 1 
            }
          }
				 ]
       ).toArray(); 
       
       try {
         var overAgeGoals = gteCursor[0].totalGoals
       }
       catch(err) {
         var overAgeGoals = 0
       }
       
       try {
         var underAgeGoals = ltCursor[0].totalGoals
       }
       catch(err) {
         var underAgeGoals = 0
       }
       
       print("Test");
       
       if (overAgeGoals > underAgeGoals) 
        return (1 + "\nOver " + x + ": " + overAgeGoals +
                "\nUnder " + x + ": " + underAgeGoals)
      else 
      return (0 + "\nOver " + x + ": " + overAgeGoals +
              "\nUnder " + x + ": " + underAgeGoals)
		 }
   }
);