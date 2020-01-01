CREATE TABLE person (
  id          UUID                     NOT NULL,
  first_name  VARCHAR(64)              NOT NULL,
  last_name   VARCHAR(64)              NOT NULL,
  age         INTEGER                  NOT NULL,
  created_at  TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at  TIMESTAMP WITH TIME ZONE NOT NULL,
  PRIMARY KEY (id)
);