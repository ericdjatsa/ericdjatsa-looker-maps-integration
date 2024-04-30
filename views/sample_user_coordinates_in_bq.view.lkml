# The name of this view in Looker is "Sample User Coordinates In Bq"
view: sample_user_coordinates_in_bq {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `ericdjatsa-genai-demos.looker_maps_integration.sample_user_coordinates_in_bq` ;;

  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Email" in Explore.

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: address {
    type: string
    sql: ${TABLE}.address ;;
    link: {
      label: "See nearby gym"
      url: "/explore/ericdjatsa-looker-maps-integration/nearby_places?fields=nearby_places.user_location,nearby_places.user_address,nearby_places.place_location,nearby_places.place_name,nearby_places.user_email&f[nearby_places.select_location_type]=gym&f[nearby_places.select_radius]=1000&f[nearby_places.user_email]={{email._value}}&sorts=nearby_places.user_location&limit=500&column_limit=50"
    }
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: count {
    type: count
  }
}
