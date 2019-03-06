% knowledge base - facts

%Example calls

%conflicts(cse341, cse343).
%conflicts(cse341, cse341).
%assign(z06, cse331).
%assign(RoomID, cse341).
%assign(RoomID, X).
%enroll(1, cse331).
%enroll(3, X).

%I DIDNT IMPLEMENT THE ADD FUNCTIONS BECAUSE YOU CAN EASILY ADD SOMETHING TO DATABASE WITH ASSERT --- Ex/  assert(student(16, [cse343], no)).

room(z06, 10, [hcapped, projector]).	%There is a room named z06, capacity = 10 and also has handicapped support and projector
room(z11, 10, [hcapped, smartboard]).	%There is a room named z11, capacity = 10 and also has handicapped support and smartboard

occupancy(z06, 8, cse341).	%z06 is the class, 8 is the class time, cse341 is the lesson
occupancy(z06, 9, cse341).
occupancy(z06, 10, cse341).
occupancy(z06, 11, cse341).
occupancy(z06, 13, cse331).
occupancy(z06, 14, cse331).
occupancy(z06, 15, cse331).
occupancy(z06, 8, cse343).
occupancy(z11, 9, cse343).
occupancy(z11, 10, cse343).
occupancy(z11, 11, cse343).
occupancy(z11, 14, cse321).
occupancy(z11, 15, cse321).
occupancy(z11, 16, cse321).

course(cse341, genc, 10, 4, z06, []).	%Course = CSE341, Instructor = Genc, capacity=10, hours=4, class=z06, needs = Nothing
course(cse343, turker, 6, 3, z11, []).
course(cse331, bayrakci, 5, 3, z06, []).
course(cse321, gozupek, 10, 4, z11, []).

student(1, [cse341, cse343, cse331], no).	%StudentID = 1, Courses of that student, Handicapped = no
student(2, [cse341, cse343], no).
student(3, [cse341, cse331], no).
student(4, [cse341], no).
student(5, [cse343, cse331], no).
student(6, [cse341, cse343, cse331], yes).
student(7, [cse341, cse343], no).
student(8, [cse341, cse331], yes).
student(9, [cse341], no).
student(10, [cse341, cse321], no).
student(11, [cse341, cse321], no).
student(12, [cse343, cse321], no).
student(13, [cse343, cse321], no).
student(14, [cse343, cse321], no).
student(15, [cse343, cse321], yes).

instructor(genc, cse341, [projector]).	%Instructor=Genc, Course=CSE341, Needs=Projector
instructor(turker, cse343, [smartboard]).
instructor(bayrakci, cse331, []).
instructor(gozupek, cse321, [smartboard]).

% rules

conflicts(CourseID1, CourseID2) :-		%If 2 different classes in same hour and same class, that means these are conflicted.So, i checked the occupancies of courses and compare their class and hours
	CourseID1 == CourseID2 -> write("CourseID1, CourseID2 ile ayni olamaz."), fail ; not(CourseID1 == CourseID2), %If courseID's are same the conflicts check is not necessary.There for i displayed an error and it returns false.
	occupancy(Class, Hour, CourseID1),
	occupancy(Class, Hour, CourseID2). %Checks the Class And Hour is same or not with CourseID1

assign(RoomID, CourseID) :-		%If the instructors needs is meets by the class and the course capacity is less than or equal to class capacity that means the course can assigned to this room.
	instructor(Instructor, CourseID, Needs1),
	course(CourseID, Instructor, Capacity1, _, _, _),  %I dont need the other 3 information about that course therefore i passed them _.
	room(RoomID, Capacity2, Needs2),
	subset(Needs1, Needs2),  %Checks the instructor needs is meet by the room
	Capacity2 >= Capacity1.

enroll(StudentID,CourseID) :-  %If the course is didnt taken by the student and if the student is handicapped and also the room is has handicapped support. That means the student can enroll to the course.
	student(StudentID, StudentCourses, Handicap),
	course(CourseID, _, _, _, Room, _),   %I only need the CourseID and the Room info for check the room and course.
	room(Room, _, Equipment),
	(Handicap == yes -> member(hcapped, Equipment) ; Handicap == no), %If student is handicapped and the class is support handicapped students OR the student isnt handicapped this returns True.
	not(member(CourseID, StudentCourses)).
