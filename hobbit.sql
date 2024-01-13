CREATE TABLE IF NOT EXISTS user(
    user_id INT(9) PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    username VARCHAR(20) NOT NULL UNIQUE,
    password VARCHAR(20) NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(50) NOT NULL,
    interests ENUM('basketball', 'football', 'volleyball', 'skateboard', 'hiking', 'bowling', 'biking', 'running', 'sightseeing') NOT NULL
);

CREATE TABLE IF NOT EXISTS events (
    event_id INT(9) PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    location VARCHAR(255) NOT NULL,
    photo BLOB ,
    description TEXT,
    category ENUM('basketball', 'football', 'volleyball', 'skateboard', 'hiking', 'bowling', 'biking', 'running', 'sightseeing') NOT NULL,
    host_id INT(9),
    FOREIGN KEY (host_id) REFERENCES user(user_id)
);


CREATE TABLE IF NOT EXISTS participation (
    user_id INT(9),
    event_id INT(9),
    PRIMARY KEY (user_id, event_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (event_id) REFERENCES events(event_id)
);
