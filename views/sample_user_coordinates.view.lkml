view: sample_user_coordinates {
  derived_table: {
    sql:
      SELECT * FROM UNNEST ([STRUCT<user_id STRING,email STRING, address STRING, latitude NUMERIC,longitude NUMERIC>
        ("user1","googlecloud-paris@example.com","25 Rue de Clichy, 75009 Paris", 48.87881851213283,2.3296058400039517),
        ("user2", "decathlon-city-lille@example.com", "31 Rue de Béthune, 59000 Lille", 50.63459809473876, 3.063897382262143),
        ("user3", "decathlon-paris-madeleine@example.com","23 Bd de la Madeleine, 75001 Paris", 48.869961343648434, 2.3256177839061785)
        ])
      )
    ;;
  }
}
