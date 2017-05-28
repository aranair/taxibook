# Taxi Booking

## How to run?

Via docker:

```
docker build -t taxibooking .
docker run -p 3000:3000 taxibooking
```

Via localhost:

```
bundle install
rails s
```

## API Endpoints

### POST /api/book

Required JSON keys: 
- Source
- Destination

Maximum value of x, y:  2,147,483,647

Minimum value of x, y: -2,147,483,648

```json
# x and y are the corresponding x/y values on the grid
{"source": { "x": -1, "y": -1 }, "destination": { "x": -2, "y": -2 }}
```

**Request**

```bash
curl -H "Content-Type: application/json" -X POST -d '{"source": { "x": -1, "y": -1 }, "destination": { "x": -2, "y": -2 }}' http://localhost:3000/api/book
```

**Response:**

```json
{ "car_id": 1, "total_time": 6 }
```


**Request (Missing key)**

```bash
curl -H "Content-Type: application/json" -X POST -d '{"source": { "x": -1, "y": -1 }}' http://localhost:3000/api/book
```

**Response:**

```json
{ "errors":"param is missing or the value is empty: destination" }
```

**Request (Outside boundary values)**

```bash
curl -H "Content-Type: application/json" -X POST -d '{"source": { "x": -1, "y": -1 }, "destination": { "x": -2, "y": 99147483647 }}' http://localhost:3000/api/book
```

**Response:**

```json
{ "errors":"Coordinates are outside of world boundaries." }
```

### GET /api/print
Prints the current list of cars with their corresponding attribute values. 

**Note**: After the car has picked up the customer, customer_location will be set to nil.

**Request:**

```bash
curl -X GET localhost:3000/api/print
```

**Response:**

```json
[  
   {  
      "id":1,
      "status":"booked",
      "current_location":{  
         "x":-1,
         "y":0
      },
      "customer_location":{  
         "x":-1,
         "y":-1
      },
      "destination":{  
         "x":-2,
         "y":-2
      }
   },
   {  
      "id":2,
      "status":"available",
      "current_location":{  
         "x":0,
         "y":0
      }
   },
   {  
      "id":3,
      "status":"available",
      "current_location":{  
         "x":0,
         "y":0
      }
   }
]
```

### GET /api/tick
Moves the system forward one time unit

**Request:**

```bash
curl -XGET localhost:3000/api/tick
```

Response:  empty


### GET /api/reset
Resets the entire system back to original

**Request:**
```
curl -XGET localhost:3000/api/reset
```

Response:  empty

## Tests

### All the test specs

```
rspec spec
```

### Partially

```
rspec spec/models
# or
rspec spec/requests
```

