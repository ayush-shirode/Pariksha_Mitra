use Pariksha_mitra;

db.Students_Collection.insertOne({
    _id: "S001",
    name: "John Doe",
    grade: 10,
    email: "john.doe@example.com",
    phoneNumber: "+1234567890",
    enrolledSubjects: ["Math", "Science"],
    dateCreated: new Date(),
    lastLogin: new Date()
});

// Chapters Collection

db.chapters.insertOne({
    _id: "C001",
    subjectID: "Math101",
    title: "Algebra Basics",
    description: "Introduction to algebraic expressions and equations.",
    createdDate: ISODate("2024-12-15T00:00:00Z")
});


// Exercise Collection
db.Exercise.insertOne({
    _id: "E001",
    chapterID: "C001",
    title: "Algebra Quiz 1",
    description: "Test your understanding of basic algebra.",
    difficultyLevel: "Easy",
    totalQuestions: 10,
    timeLimit: 30
});


// Question Collection
db.Question.insertOne({
    _id: "Q001",
    exerciseID: "E001",
    questionText: "What is the value of x if 2x + 5 = 15?",
    options: ["5", "7", "10", "12"],
    correctOption: "5",
    marks: 2.0,
    tags: ["Algebra", "Equations"]
});


// Result of the student
db.Result.insertOne({
    _id: "R001",
    testID: "T001",
    studentID: "S001",
    score: 85.5,
    timeTaken: 25,
    submissionDate: ISODate("2024-12-15T10:30:00Z")
});


// Performance Analysis
db.Performance.insertOne({
    _id: "S001",
    subjectID: "Math101",
    averageScore: 78.2,
    timeSpent: 120,
    weakAreas: ["C002", "C003"],
    improvementSuggestions: "Focus on equations and geometry basics."
});

// Question Randomization
db.Question.findOne({}, {ordered: false});


// Aggregate Performance Analysis
db.TestResults.aggregate([
    { $match: { studentID: "S001" } },
    {
        $group: {
            _id: "$studentID",
            averageScore: { $avg: "$score" },
            totalTimeSpent: { $sum: "$timeTaken" }
        }
    },
    {
        $lookup: {
            from: "Chapters",
            localField: "_id",
            foreignField: "_id",
            as: "weakChapters"
        }
    },
    {
        $project: {
            studentID: "$_id",
            averageScore: 1,
            totalTimeSpent: 1,
            weakChapters: 1
        }
    }
]);