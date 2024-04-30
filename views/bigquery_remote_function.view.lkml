view: bigquery_remote_function {
  derived_table: {
    sql:
      # Article here: https://medium.com/@sampitcher/find-nearby-cafes-on-looker-using-google-maps-api-and-bigquery-remote-functions-aaa39922536

    CREATE OR REPLACE FUNCTION `ericdjatsa-genai-demos`.looker_maps_integration.maps_get_nearby_places(
      lat STRING, long STRING, radius STRING, type STRING)
        RETURNS STRING
    REMOTE WITH CONNECTION `ericdjatsa-genai-demos.us.ericdjatsa-genai-demos-cf-cnx`
    OPTIONS (endpoint = 'https://us-central1-ericdjatsa-genai-demos.cloudfunctions.net/maps_get_nearby_places') ;  ;;
  }

}
