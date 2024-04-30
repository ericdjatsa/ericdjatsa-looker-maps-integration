view: nearby_places {
  derived_table: {
    sql:
    WITH user_coordinates AS (
      SELECT
        user_id,
        email,
        address,
        cast(latitude as string) as lat,
        cast(longitude as string) as lon
      FROM ${sample_user_coordinates_in_bq.SQL_TABLE_NAME}
      --WHERE {% condition email_filter %} email {% endcondition %}
    LIMIT 10
    ),
    loc AS (SELECT
      user_coordinates.user_id,
      user_coordinates.email as user_email,
      user_coordinates.address as user_address,
      user_coordinates.lat as user_lat,
      user_coordinates.lon as user_lng,
      JSON_EXTRACT_ARRAY(`ericdjatsa-genai-demos.looker_maps_integration.maps_get_nearby_places`(user_coordinates.lat, user_coordinates.lon, "500", "gym")) as nearby_places_replies
    FROM user_coordinates)
    SELECT
      loc.user_id,
      loc.email,
      loc.user_address,
      loc.user_lat,
      loc.user_lng,
      JSON_VALUE(nearby_places, "$.name") AS place_name,
      JSON_VALUE(nearby_places, "$.lat") AS place_lat,
      JSON_VALUE(nearby_places, "$.lng") AS place_lng
    FROM loc, UNNEST(nearby_places_replies) as nearby_places
        ;;
  }

  filter: email_filter {
    type: string
    suggest_dimension: user_email
    sql: EXISTS (SELECT email FROM ${sample_user_coordinates_in_bq.SQL_TABLE_NAME} WHERE {% condition %} email {% endcondition %} );;

  }
  dimension: user_id {}
  dimension: user_email {}
  dimension: user_address {}
  dimension: user_lat {}
  dimension: user_lng {}
  dimension: user_location {
    type: location
    sql_latitude: ${user_lat} ;;
    sql_longitude: ${user_lng} ;;
  }

  dimension: place_name {}
  dimension: place_lat {}
  dimension: place_lng {}
  dimension: place_location {
    type: location
    sql_latitude: ${place_lat} ;;
    sql_longitude: ${place_lng} ;;
  }
}
