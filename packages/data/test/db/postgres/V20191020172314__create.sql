CREATE TABLE city (
  id          SERIAL                   NOT NULL,
  uuid        UUID                     NOT NULL,
  name        VARCHAR(64)                  NULL,
  created_at  TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at  TIMESTAMP WITH TIME ZONE NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE address (
  id          SERIAL                   NOT NULL,
  uuid        UUID                     NOT NULL,
  street      VARCHAR(64)                  NULL,
  number      INTEGER                      NULL,
  city_id     INTEGER                      NULL REFERENCES city(id),
  created_at  TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at  TIMESTAMP WITH TIME ZONE NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE person (
  id          SERIAL                   NOT NULL,
  uuid        UUID                     NOT NULL,
  first_name  VARCHAR(64)                  NULL,
  last_name   VARCHAR(64)                  NULL,
  age         INTEGER                      NULL,
  address_id  INTEGER                      NULL REFERENCES address(id),
  created_at  TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at  TIMESTAMP WITH TIME ZONE NOT NULL,
  PRIMARY KEY (id)
);