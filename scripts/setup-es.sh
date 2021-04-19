#!/bin/sh

set -e
set -o pipefail

HOST=localhost

put(){
    curl --user elastic:changeme -X PUT "$HOST:9200/$1" -H 'Content-Type: application/json' -d "
    $2
    "
}

post(){
    curl --user elastic:changeme -X POST "$HOST:9200/$1" -H 'Content-Type: application/json' -d "
    $2
    "
}

put '_ilm/policy/test-service-policy' '
{
  "policy": {
    "phases": {
      "hot": {
        "actions": {
          "rollover": {
            "max_age": "6d",
            "max_size": "20gb"
          },
          "set_priority": {
            "priority": 100
          }
        }
      },
      "delete": {
        "min_age": "1d",
        "actions": {
          "delete": {}
        }
      }
    }
  }
}
'

put '_ilm/policy/test-system-policy' '
{
  "policy": {
    "phases": {
      "hot": {
        "actions": {
          "rollover": {
            "max_age": "30d",
            "max_size": "20gb"
          },
          "set_priority": {
            "priority": 100
          }
        }
      },
      "delete": {
        "min_age": "1d",
        "actions": {
          "delete": {}
        }
      }
    }
  }
}
'

put '_template/test-service' '
{
  "index_patterns": "test-service*",
  "mappings" : {
      "properties" : {
        "@timestamp" : {
          "type" : "date"
        },
        "app" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "level" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "message" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "service" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "version" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        }
      }
  },
  "settings": {
    "number_of_shards":   5,
    "number_of_replicas": 0,
    "index.lifecycle.name": "test-service-policy",
    "index.lifecycle.rollover_alias": "test-service"
  }
}
'

put '_template/test-system' '
{
  "index_patterns": "test-system*",
  "mappings": {
      "properties": {
          "@timestamp": {
              "type": "date"
          },
          "Channel": {
              "type": "text",
              "fields": {
                  "keyword": {
                      "type": "keyword",
                      "ignore_above": 256
                  }
              }
          },
          "ComputerName": {
              "type": "text",
              "fields": {
                  "keyword": {
                      "type": "keyword",
                      "ignore_above": 256
                  }
              }
          },
          "Data": {
              "type": "text",
              "fields": {
                  "keyword": {
                      "type": "keyword",
                      "ignore_above": 256
                  }
              }
          },
          "EventCategory": {
              "type": "long"
          },
          "EventID": {
              "type": "long"
          },
          "EventType": {
              "type": "text",
              "fields": {
                  "keyword": {
                      "type": "keyword",
                      "ignore_above": 256
                  }
              }
          },
          "Message": {
              "type": "text",
              "fields": {
                  "keyword": {
                      "type": "keyword",
                      "ignore_above": 256
                  }
              }
          },
          "RecordNumber": {
              "type": "long"
          },
          "Sid": {
              "type": "text",
              "fields": {
                  "keyword": {
                      "type": "keyword",
                      "ignore_above": 256
                  }
              }
          },
          "SourceName": {
              "type": "text",
              "fields": {
                  "keyword": {
                      "type": "keyword",
                      "ignore_above": 256
                  }
              }
          },
          "StringInserts": {
              "type": "text",
              "fields": {
                  "keyword": {
                      "type": "keyword",
                      "ignore_above": 256
                  }
              }
          },
          "TimeGenerated": {
              "type": "text",
              "fields": {
                  "keyword": {
                      "type": "keyword",
                      "ignore_above": 256
                  }
              }
          },
          "TimeWritten": {
              "type": "text",
              "fields": {
                  "keyword": {
                      "type": "keyword",
                      "ignore_above": 256
                  }
              }
          }
      }
  },
  "settings": {
    "number_of_shards":   5,
    "number_of_replicas": 0,
    "index.lifecycle.name": "test-system-policy",
    "index.lifecycle.rollover_alias": "test-system"
  }
}
'

# # activate
put 'test-service-000001' '
{
  "aliases": {
    "test-service": {
      "is_write_index": true
    }
  }
}
'
# activate
put 'test-system-000001' '
{
  "aliases": {
    "test-system": {
      "is_write_index": true
    }
  }
}
'

# # start ilm
post '_ilm/start' ''

echo

exit 0
