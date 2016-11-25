// 1. Find all the students that failed
db.C13451458_schema.find(
  {
    results: {
      $elemMatch: {
        mark:
        {lt$: 40}
      }
    }
  }
)
