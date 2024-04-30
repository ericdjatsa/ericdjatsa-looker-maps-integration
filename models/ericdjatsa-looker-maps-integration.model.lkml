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
  # always_filter: {
  #   #filters: [nearby_places.user_email: "decathlon-city-lille@example.com"]
  # }
}
