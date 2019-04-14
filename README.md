# ZSSN (Zombie Survival Social Network)

ZSSN Is a system created to help the human to survive an apocalypse zombie. Using only REST API requests, survivors can share resources with others non-infected humans.

## Table of Contents

* [Installation](#installation)
* [API Documentation](#api-documentation)
  * [List Survivors](#list-survivors)
  * [Add Survivors](#add-survivors)
  * [Update Survivor Location](#update-survivor-location)
  * [Flag Survivor as Infected](#flag-survivor-as-infected)
  * [Trade Resources](#trade-resources)
* [Reports](#reports)
  * [Percentage of infected survivors](#percentage-of-infected-survivors)
  * [Percentage of non-infected survivors](#percentage-of-non-infected-survivors)
  * [Average Resources By Survivor](#average-resources-by-survivor)
  * [Points lost because of infected survivors](#points-lost-because-of-infected-survivors)
* [Testing with RSpec](#testing-with-rspec)

## Installation

1. Clone the project.

  ~~~ sh
  $ https://github.com/leospaula/zssn_api.git
  ~~~

2. Bundle the Gems.

  ~~~ sh
  $ bundle install
  ~~~

3. Set the database connection at the config file `config/database.yml`.

4. Create and migrate database.

  ~~~ sh
  $ rails db:create && rails db:migrate
  ~~~

5. Start the application

  ~~~ sh
  $ rails s
  ~~~

Application will be runing at [localhost:3000](http://localhost:3000).

## API Documentation

### List Survivors

##### Request 

```sh
GET  /survivors`
```

##### Response

```sh
status: 200 Ok
```

```sh
Content-Type: "application/json"
```

```sh
Body:
{
    "survivors": [
        {
            "id": 1,
            "name": "Survivor Test 1",
            "age": 43,
            "gender": "male",
            "infection_count": 0,
            "last_location": {
                "latitude": "89809809809",
                "longitude": "-88983982100"
            },
            "resources": [
                {
                    "name": "water",
                    "quantity": 10
                },
                {
                    "name": "food",
                    "quantity": 6
                }
            ]
        },
        {
            "id": 2,
            "name": "Survivor Test 2",
            "age": 23,
            "gender": "female",
            "infection_count": 0,
            "last_location": {
                "latitude": "89809809809",
                "longitude": "-88983982100"
            },
            "resources": [
                {
                    "name": "medication",
                    "quantity": 10
                },
                {
                    "name": "ammunition",
                    "quantity": 10
                }
            ]
        }
    ]
}
```

### Add Survivors

##### Request 

```sh
POST  /survivors`
```

```sh
Parameters:
{
    "survivor": 
    {
        "name": "Survivor Test", 
        "age": "43", 
        "gender": "female", 
        "last_location": {"latitude": "87779809809", "longitude": "-84567982100"},
        "resources": [
        {
            "name": "medication", 
            "quantity": 10
            
        }, 
        { 
            "name":"water", 
            "quantity": 6
            
        }]
    }
}
```

##### Response

```sh
status: 201 created
```

```sh
Content-Type: "application/json"
```

```sh
Body:
{
    "survivor": {
      "id": 1,
      "name": "Survivor Test",
      "age": 43,
      "gender": "female",
      "infection_count": 0,
      "last_location": {
          "latitude": "87779809809",
          "longitude": "-84567982100"
      },
      "resources": [
        {
            "name": "medication", 
            "quantity": 10
            
        }, 
        { 
            "name":"water", 
            "quantity": 6
            
        }]
    }
}
```

##### Errors
Status | Error                | Message
------ | ---------------------|--------
422    | Unprocessable Entity |   
409    | Conflict             | Survivor needs to declare resources

### Update Survivor Location

##### Request 

```sh
PATCH/PUT /survivors/:id
```

```sh
Parameters:
{
    "survivor": 
    {
        "latitude": "-16.6868824", 
        "longitude": "-49.2647885"
    }
}
```

##### Response

```sh
status: 204 no_content
```

```sh
Content-Type: "application/json"
```

##### Errors
Status | Error      |
------ | -----------|
404    | Not Found  |

### Flag Survivor as Infected

##### Request 

```sh
POST   /survivors/:id/flag_infection
```

##### Response

```sh
status: 200 ok
```

```sh
Content-Type: "application/json"
```

```sh
Body:
{
    "message": "Survivor was reported as infected x time(s)"
}
```

##### Errors
Status | Error      |
------ | -----------|
404    | Not Found  |


### Trade Resources

Survivors can trade items among themselves, respecting a price table.

##### Request 

```sh
POST   /trade_resources
```

```sh
Parameters:
{
  "trade": {
    "survivor_1": {
      "id": "1",
      "resources": [
        {
          "name": "water",
          "quantity": 1
        },
        {
          "name": "food",
          "quantity": 1
        }
      ]
    },
    "survivor_2": {
      "id": "2",
      "resources": [
        {
          "name": "ammunition",
          "quantity": 7
        }
      ]
    }
  }
}
```

##### Response

```sh
status: 200 ok
```

```sh
Content-Type: "application/json"
```

```sh
Body:
{
    "message": "Trade successfully completed"
}
```

##### Errors
Status | Error                | Message
------ | ---------------------|--------
404    | Not Found            | Survivor with id xxxxx does not exist 
422    | Unprocessable Entity | Survivor X is infected
409    | Conflict             | Survivor X doesn't have enough resources
409    | Conflict             | Resources points is not balanced both sides


## Reports

### Percentage of infected survivors

##### Request 

```sh
GET   /reports/infected_survivors
```

##### Response

```sh
status: 200 ok
```

```sh
Content-Type: "application/json"
```

```sh
Body:
{
    "data": "X%"
}
```

### Percentage of non-infected survivors

##### Request 

```sh
GET   /reports/not_infected_survivors
```

##### Response

```sh
status: 200 ok
```

```sh
Content-Type: "application/json"
```

```sh
Body:
{
    "data": "X%"
}
```

### Average Resources By Survivor

##### Request 

```sh
GET   /reports/resources_by_survivor
```

##### Response

```sh
status: 200 ok
```

```sh
Content-Type: "application/json"
```

```sh
Body:
{{
    "data": {
        "water": 3,
        "food": 1.6,
        "medication": 6.6,
        "ammunition": 4.3
    }
}
```

### Points lost because of infected survivors

##### Request 

```sh
GET   /reports/lost_infected_points
```

##### Response

```sh
status: 200 ok
```

```sh
Content-Type: "application/json"
```

```sh
Body:
{
    "data": "23 points lost"
}
```

## Testing with RSpec

The project was build with TDD (Test Driven Development). To execute the tests just run the tests with RSpec.

1. Execute all tests

    ~~~ sh
    $ bundle exec rspec
    ~~~
