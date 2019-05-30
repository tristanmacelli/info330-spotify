--WHICH students born before March 3, 1995 completed 5 credits of Information School classes in Winter 2017
--Which students completd 10 credits after 2015 of Arts & Science courses in classrooms on Steven's Way?

USE UNIVERSITY

SELECT S.StudentID, S.StudentFname, S.StudentLname, SUM(CO.Credits) AS InfoCredits
FROM tblSTUDENT S
    JOIN tblCLASS_LIST CL ON S.StudentID = CL.StudentID
    JOIN tblCLASS C ON CL.ClassID = C.ClassID
    JOIN tblCOURSE CO ON C.CourseID = CO.CourseID
    JOIN tblDEPARTMENT D ON CO.DeptID = D.DeptID
    JOIN tblCOLLEGE CG ON D.CollegeID = CG.CollegeID
    JOIN tblQuarter Q ON C.QuarterID = Q.QuarterID
    JOIN (SELECT S.StudentID, S.StudentFname, S.StudentLname, SUM(CO.Credits) AS ArtsAfterStevens2015
        FROM tblSTUDENT S
            JOIN tblCLASS_LIST CL ON S.StudentID = CL.StudentID
            JOIN tblCLASS C ON CL.ClassID = C.ClassID
            JOIN tblCOURSE CO ON C.CourseID = CO.CourseID
            JOIN tblDEPARTMENT D ON CO.DeptID = D.DeptID
            JOIN tblCOLLEGE CG ON D.CollegeID = CG.CollegeID
            JOIN tblCLASSROOM CR ON C.ClassroomID = CR.ClassroomID
            JOIN tblBUILDING B ON CR.BuildingID = B.BuildingID
            JOIN tblLOCATION L ON B.LocationID = L.LocationID
        WHERE CG.CollegeID = 1 
            AND C.[YEAR] > 2015
            AND L.LocationID = 4
            AND CL.Grade >= 0.7
        GROUP BY S.StudentID, S.StudentFname, S.StudentLname
        HAVING SUM(CO.CREDITS) >= 10) P ON S.StudentID = P.StudentID
WHERE CG.CollegeID = 9 
    AND Q.QuarterID = 1 
    AND C.[YEAR] = 2017
    AND CL.Grade >= 0.7
    AND S.StudentBirth < 'March 3, 1995'
GROUP BY S.StudentID, S.StudentFname, S.StudentLname
HAVING SUM(CO.CREDITS) >= 5



SELECT * FROM tblLOCATION