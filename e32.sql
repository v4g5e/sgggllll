CREATE TABLE Sports_Original (
    athlete_id INT,
    athlete_name NVARCHAR(100),
    athlete_age INT,
    sports_categories NVARCHAR(100),
    coach_name NVARCHAR(100),
    coach_phone NVARCHAR(20),
    coach_specialization NVARCHAR(100),
    competition_id INT,
    competition_name NVARCHAR(100),
    competition_date DATE,
    sport_type NVARCHAR(50),
    result_value NVARCHAR(50),
    achievement NVARCHAR(100),
    training_schedule NVARCHAR(200)
);

INSERT INTO Sports_Original VALUES
(1, 'Иванов Алексей', 16, 'Плавание, Легкая атлетика', 'Петров С.М.', '+7-915-123-45-67', 'Плавание, Тренер высшей категории', 101, 'Городские соревнования по плаванию', '2024-03-20', 'Плавание', '1:25.45', '1 место, Золотая медаль', 'Пн,Ср,Пт 16:00-18:00'),
(2, 'Сидорова Мария', 14, 'Гимнастика, Танцы', 'Козлова А.П.', '+7-916-987-65-43', 'Художественная гимнастика', 102, 'Областные соревнования по гимнастике', '2024-03-22', 'Гимнастика', '9.85 баллов', '2 место, Серебряная медаль', 'Вт,Чт,Сб 15:00-17:00');

CREATE TABLE Sports_1NF (
    record_id INT IDENTITY(1,1) PRIMARY KEY,
    athlete_id INT,
    athlete_name NVARCHAR(100),
    athlete_age INT,
    sports_category NVARCHAR(50),
    coach_name NVARCHAR(100),
    coach_phone NVARCHAR(20),
    coach_specialization NVARCHAR(100),
    competition_id INT,
    competition_name NVARCHAR(100),
    competition_date DATE,
    sport_type NVARCHAR(50),
    result_value NVARCHAR(50),
    achievement NVARCHAR(100),
    training_day NVARCHAR(10),
    training_time NVARCHAR(20)
);

INSERT INTO Sports_1NF VALUES
(1, 'Иванов Алексей', 16, 'Плавание', 'Петров С.М.', '+7-915-123-45-67', 'Плавание', 101, 'Городские соревнования по плаванию', '2024-03-20', 'Плавание', '1:25.45', '1 место', 'Пн', '16:00-18:00'),
(1, 'Иванов Алексей', 16, 'Легкая атлетика', 'Петров С.М.', '+7-915-123-45-67', 'Тренер высшей категории', 101, 'Городские соревнования по плаванию', '2024-03-20', 'Плавание', '1:25.45', 'Золотая медаль', 'Ср', '16:00-18:00');

CREATE TABLE Athletes (
    athlete_id INT IDENTITY(1,1) PRIMARY KEY,
    athlete_name NVARCHAR(100) NOT NULL,
    age INT NOT NULL
);

CREATE TABLE Sports (
    sport_id INT IDENTITY(1,1) PRIMARY KEY,
    sport_name NVARCHAR(50) NOT NULL
);

CREATE TABLE AthleteSports (
    athlete_id INT,
    sport_id INT,
    PRIMARY KEY (athlete_id, sport_id),
    FOREIGN KEY (athlete_id) REFERENCES Athletes(athlete_id),
    FOREIGN KEY (sport_id) REFERENCES Sports(sport_id)
);

CREATE TABLE Coaches (
    coach_id INT IDENTITY(1,1) PRIMARY KEY,
    coach_name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20) NOT NULL
);

CREATE TABLE CoachSpecializations (
    coach_id INT,
    sport_id INT,
    qualification NVARCHAR(100),
    PRIMARY KEY (coach_id, sport_id),
    FOREIGN KEY (coach_id) REFERENCES Coaches(coach_id),
    FOREIGN KEY (sport_id) REFERENCES Sports(sport_id)
);

CREATE TABLE Competitions (
    competition_id INT IDENTITY(1,1) PRIMARY KEY,
    competition_name NVARCHAR(100) NOT NULL,
    competition_date DATE NOT NULL,
    sport_id INT NOT NULL,
    FOREIGN KEY (sport_id) REFERENCES Sports(sport_id)
);

CREATE TABLE Results (
    result_id INT IDENTITY(1,1) PRIMARY KEY,
    athlete_id INT NOT NULL,
    competition_id INT NOT NULL,
    result_value NVARCHAR(50) NOT NULL,
    achievement NVARCHAR(100),
    FOREIGN KEY (athlete_id) REFERENCES Athletes(athlete_id),
    FOREIGN KEY (competition_id) REFERENCES Competitions(competition_id)
);

CREATE TABLE TrainingSchedule (
    schedule_id INT IDENTITY(1,1) PRIMARY KEY,
    athlete_id INT NOT NULL,
    sport_id INT NOT NULL,
    training_day NVARCHAR(10) NOT NULL,
    training_time NVARCHAR(20) NOT NULL,
    FOREIGN KEY (athlete_id) REFERENCES Athletes(athlete_id),
    FOREIGN KEY (sport_id) REFERENCES Sports(sport_id)
);

INSERT INTO Athletes VALUES ('Иванов Алексей', 16), ('Сидорова Мария', 14);
INSERT INTO Sports VALUES ('Плавание'), ('Легкая атлетика'), ('Гимнастика'), ('Танцы');
INSERT INTO AthleteSports VALUES (1,1), (1,2), (2,3), (2,4);
INSERT INTO Coaches VALUES ('Петров С.М.', '+7-915-123-45-67'), ('Козлова А.П.', '+7-916-987-65-43');
INSERT INTO CoachSpecializations VALUES (1,1, 'Тренер высшей категории'), (1,2, 'Тренер высшей категории'), (2,3, 'Художественная гимнастика');
INSERT INTO Competitions VALUES ('Городские соревнования по плаванию', '2024-03-20', 1), ('Областные соревнования по гимнастике', '2024-03-22', 3);
INSERT INTO Results VALUES (1,1,'1:25.45','1 место, Золотая медаль'), (2,2,'9.85 баллов','2 место, Серебряная медаль');
INSERT INTO TrainingSchedule VALUES (1,1,'Пн','16:00-18:00'), (1,1,'Ср','16:00-18:00'), (1,1,'Пт','16:00-18:00');

SELECT a.athlete_name, s.sport_name, COUNT(r.result_id) as competitions_count
FROM Athletes a
JOIN AthleteSports asp ON a.athlete_id = asp.athlete_id
JOIN Sports s ON asp.sport_id = s.sport_id
JOIN Results r ON a.athlete_id = r.athlete_id
GROUP BY a.athlete_id, a.athlete_name, s.sport_name;