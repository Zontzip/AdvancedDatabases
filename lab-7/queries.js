// 1. Find all the students that failed
db.C13451458_schema.find(
  {
    results: {
      $elemMatch: {
        mark: {
          $lt: 40
        }
      }
    }
  }
);

// 2. Find the number of people that passed each exam
db.C13451458_schema.aggregate(
  [
    {
      $unwind : "$results"
    },
    {
      $match:
      {
        "results.mark" : {
          "$gte" : 40
        }
      }
    },
    {
      $group : {
        _id: "$results.name",
        total : {
          $sum: 1
        }
      }
    }
  ]
);
