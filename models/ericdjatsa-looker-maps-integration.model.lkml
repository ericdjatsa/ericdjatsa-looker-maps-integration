# Define the database connection to be used for this model.
connection: "ericdjatsa-genai-demos-looker-maps-integration"

# include all the views
include: "/views/**/*.view"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: ericdjatsa_looker_maps_integration_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "2 hour"
}

persist_with: ericdjatsa_looker_maps_integration_default_datagroup


explore: nearby_places {
}

view: nearby_places {
  derived_table: {
    sql:
    WITH user_coordinates AS (
        user_id,
        email,
        cast(latitude as string) as lat,
        cast(longitude as string) as lon
      FROM ${users_order_items_products.SQL_TABLE_NAME}
    -- WHERE {% condition email_filter %} email {% endcondition %}
    LIMIT 10
    ),
    loc AS (SELECT
      user_coordinates.user_id,
      user_coordinates.email,
      JSON_EXTRACT_ARRAY(`ericdjatsa-genai-demos.looker_maps_integration.maps_get_nearby_places`(user_coordinates.lat, user_coordinates.lon, "500", "gym")) as nearby_places_replies
    FROM user_coordinates)
    SELECT
      loc.user_id,
      JSON_VALUE(nearby_places, "$.name") AS name,
      JSON_VALUE(nearby_places, "$.lat") AS lat,
      JSON_VALUE(nearby_places, "$.lng") AS lng
    FROM nearby_places_replies, UNNEST(nearby_places) as nearby_places
        ;;
  }

  filter: email_filter {}
  dimension: user_id {}
  dimension: email {}
  dimension: name {}
  dimension: lat {}
  dimension: lng {}
  dimension: location {
    type: location
    sql_latitude: ${lat} ;;
    sql_longitude: ${lng} ;;
  }
}
