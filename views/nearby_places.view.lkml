view: nearby_places {

  parameter: select_location_type {
    # Maps Places API v1 allowed location types: https://developers.google.com/maps/documentation/places/web-service/supported_types#table1
    type: string
    allowed_value: {  value: "campground"  }
    allowed_value: {  value: "gym"  }
    allowed_value: {  value: "park"  }
    allowed_value: {  value: "stadium"  }
  }

  parameter: select_radius {
    type: string
    allowed_value: { label: "100m" value: "100"}
    allowed_value: { label: "500m" value: "500"}
    allowed_value: { label: "1km" value: "1000"}
    allowed_value: { label: "5km" value: "1000"}
    allowed_value: { label: "10km" value: "1000"}
    allowed_value: { label: "20km" value: "1000"}
  }

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
    ),
    loc AS (SELECT
      user_coordinates.user_id,
      user_coordinates.email as user_email,
      user_coordinates.address as user_address,
      user_coordinates.lat as user_lat,
      user_coordinates.lon as user_lng,
      JSON_EXTRACT_ARRAY(`ericdjatsa-genai-demos.looker_maps_integration.maps_get_nearby_places`(user_coordinates.lat, user_coordinates.lon, {%parameter select_radius %}, {% parameter select_location_type %})) as nearby_places_replies
    FROM user_coordinates)
    SELECT
      loc.user_id,
      loc.user_email,
      loc.user_address,
      loc.user_lat,
      loc.user_lng,
      JSON_VALUE(nearby_places, "$.name") AS place_name,
      JSON_VALUE(nearby_places, "$.lat") AS place_lat,
      JSON_VALUE(nearby_places, "$.lng") AS place_lng
    FROM loc, UNNEST(nearby_places_replies) as nearby_places
        ;;
  }

  # filter: email_filter {
  #   type: string
  #   suggest_dimension: user_email
  #   sql: EXISTS (SELECT email FROM ${sample_user_coordinates_in_bq.SQL_TABLE_NAME} WHERE {% condition %} email {% endcondition %} );;
  # }

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
