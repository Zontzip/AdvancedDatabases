// 1. Find all the students that failed
db.C13451458_schema.find(
  {
    "results" : {
      $elemMatch : {
        "mark" : {
          $lt : 40
        }
      }
    }
  },
  {
    "name" : 1,
    "surname" : 1
  }
);

// 2. Find the number of people that passed each exam
db.C13451458_schema.aggregate(
  [
    {
      $unwind : "$results"
    },
    {
      $match :
      {
        "results.mark" : {
          $gte : 40
        }
      }
    },
    {
      $group : {
        "_id" : "$results.name",
        total : {
          $sum : 1
        }
      }
    }
  ]
);

// 3. Find the student with the highest average mark
db.C13451458_schema.aggregate(
  [
    {
      $unwind : "$results"
    },
    {
      $group : {
        "_id" : "$name",
        averageGrade : {
          $avg : "$results.mark"
        }
      }
    },
    {
      $sort : {
        averageGrade : -1
      }
    },
    {
      $limit : 1
    }
  ]
);
