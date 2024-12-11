CREATE DATABASE db;

USE db;

-- TASK1(DATA MODELLING)

CREATE TABLE Students (
    StudentID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(100),
    Grade INT,
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(15),
    EnrolledSubjects TEXT, -- Comma-separated values for simplicity
    DateCreated DATETIME DEFAULT CURRENT_TIMESTAMP,
    LastLogin DATETIME
);

CREATE TABLE Chapters (
    ChapterID VARCHAR(10) PRIMARY KEY,
    SubjectID VARCHAR(10),
    Title VARCHAR(100),
    Description TEXT,
    PrerequisiteChapters TEXT, -- Comma-separated ChapterIDs
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Exercises (
    ExerciseID VARCHAR(10) PRIMARY KEY,
    ChapterID VARCHAR(10),
    Title VARCHAR(100),
    Description TEXT,
    DifficultyLevel ENUM('Easy', 'Medium', 'Hard'),
    TotalQuestions INT,
    TimeLimit INT,
    FOREIGN KEY (ChapterID) REFERENCES Chapters(ChapterID)
);

CREATE TABLE Questions (
    QuestionID VARCHAR(10) PRIMARY KEY,
    ExerciseID VARCHAR(10),
    QuestionText TEXT,
    Options TEXT, -- JSON format or comma-separated
    CorrectOption VARCHAR(50),
    Marks FLOAT,
    Tags TEXT, -- Comma-separated values for categorization
    FOREIGN KEY (ExerciseID) REFERENCES Exercises(ExerciseID)
);

CREATE TABLE TestResults (
    ResultID VARCHAR(10) PRIMARY KEY,
    TestID VARCHAR(10),
    StudentID VARCHAR(10),
    Score FLOAT,
    TimeTaken INT,
    SubmissionDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

CREATE TABLE PerformanceAnalytics (
    StudentID VARCHAR(10) PRIMARY KEY,
    SubjectID VARCHAR(10),
    AverageScore FLOAT,
    TimeSpent INT,
    WeakAreas TEXT, -- Comma-separated ChapterIDs or Tags
    ImprovementSuggestions TEXT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);
SELECT * FROM Students;
SELECT * FROM Chapters;
SELECT * FROM Exercises;
SELECT * FROM Questions;
SELECT * FROM TestResults;
SELECT * FROM PerformanceAnalytics;

-- TASK2(QUESTION RANDOMIZATION) 

SELECT QuestionID, QuestionText, Options
FROM Questions
WHERE ExerciseID = 'EX001'
ORDER BY RAND()
LIMIT 10;

-- TASK3(STUDENT PERFORMANCE)

SELECT 
    StudentID,
    COUNT(TestID) AS TotalTestsTaken,
    SUM(TotalQuestions) AS TotalQuestionsAttempted,
    SUM(CorrectAnswers) AS TotalCorrectAnswers,
    (SUM(CorrectAnswers) / SUM(TotalQuestions)) * 100 AS OverallAccuracyPercentage,
    SUM(TotalMarks) AS TotalMarksObtained
FROM (
    SELECT 
        StudentID,
        TestID,
        SUM(MarksAwarded) AS TotalMarks
    FROM TestResults
    GROUP BY StudentID, TestID
) AS TestPerformance
GROUP BY StudentID;
