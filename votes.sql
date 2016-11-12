CREATE TABLE votes (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  voter_id INTEGER,

  FOREIGN KEY(voter_id) REFERENCES voter(id)
);

CREATE TABLE voters (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES voter(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  houses (id, address)
VALUES
  (1, "Pennsylvania Ave and New York Ave"), (2, "Hartley Pl and Linden St");

INSERT INTO
  voters (id, fname, lname, house_id)
VALUES
  (1, "George", "Bush", 1),
  (2, "Barack", "Obama", 1),
  (3, "Bill", "Clinton", 2),
  (4, "John", "Kennedy", NULL);

INSERT INTO
  votes (id, name, voter_id)
VALUES
  (1, "New Taxes", 1),
  (2, "Health Care", 2),
  (3, "DOMA", 3),
  (4, "Gun Control", 4);
