USE [team6]
GO
/****** Object:  StoredProcedure [dbo].[GetConditionSubjectsByMainSubjectID]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Nhan>
-- Create date: <25/06/2017>
-- Description:	<Get Condition Subjects List By Main SubjectID>
-- =============================================
CREATE PROCEDURE [dbo].[GetConditionSubjectsByMainSubjectID] 
	@SubjectID INT
AS
BEGIN
	SELECT * 
	FROM Subjects s
			JOIN ConditionRelateSubjects crs ON s.ID = crs.ConditionSubjectID
	WHERE crs.SubjectID = @SubjectID
END

GO
/****** Object:  StoredProcedure [dbo].[GetFacultiesExistSubject]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,NHAN>
-- Create date: <24/06/2017>
-- Description:	<Get Faculties Exist Subject>
-- =============================================
CREATE PROCEDURE [dbo].[GetFacultiesExistSubject]
AS
BEGIN
	SELECT DISTINCT facu.ID, facu.VietNameseName, facu.EnglishName, facu.TrainingTime, facu.CreationTime
	FROM SubjectsOfFaculties sof
					JOIN Faculties facu ON sof.FacultyID = facu.ID
END

GO
/****** Object:  StoredProcedure [dbo].[GetFormAndSubjectTypeBySubjectID]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Nhan>
-- Create date: <Create Date,,>
-- Description:	<Get Form And SubjectType by SubjectID>
-- =============================================
CREATE PROCEDURE [dbo].[GetFormAndSubjectTypeBySubjectID]
	@SubjectID INT
AS
BEGIN
	SELECT *		
	FROM SubjectTypes st
	LEFT JOIN Subjects s ON st.ID = s.SubjectTypeID
	WHERE s.ID = @SubjectID
	--GROUP BY st.ID, st.Name	
END

GO
/****** Object:  StoredProcedure [dbo].[GetProgramContentByFacultyID]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,NhanNgo>
-- Create date: <22/06/2017>
-- Description:	<Get Program Content>
-- =============================================
CREATE PROCEDURE [dbo].[GetProgramContentByFacultyID]
	@FacultyID INT
AS
BEGIN
	SELECT st.ID, st.Name AS SubjectTypeName, 
	SubjectsList = STUFF(
								(SELECT '|' + CAST(su1.ID AS NVARCHAR(MAX)) + '|' + su1.PartialCode + '|' + su1.Name + '|' + CAST(su1.CreditNumber AS NVARCHAR(MAX)) + '|' + CAST(su1.SemesterNumber AS NVARCHAR(MAX)) + '|'
								FROM Subjects su1
								WHERE su1.SubjectTypeID = st.ID AND su1.FacultyID = @FacultyID
								ORDER BY su1.SemesterNumber ASC
								FOR XML PATH('')	
							), 1, 1,''
						), 
					SUM(temp.CreditNumber) AS CreditNumberTotal
			
	FROM SubjectTypes st
				LEFT JOIN ( SELECT sb.SubjectTypeID, sb.CreditNumber
							FROM Subjects sb
							WHERE sb.FacultyID = @FacultyID
						   ) AS temp ON st.ID = temp.SubjectTypeID 
	GROUP BY st.ID, st.Name	
END

GO
/****** Object:  StoredProcedure [dbo].[GetProgramContentByFacultyID02]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,NhanNgo>
-- Create date: <22/06/2017>
-- Description:	<Get Program Content>
-- =============================================
CREATE PROCEDURE [dbo].[GetProgramContentByFacultyID02]
	@FacultyID INT
AS
BEGIN
	SELECT st.ID, st.Name AS SubjectTypeName, 
	SubjectsList = STUFF(
								(SELECT '|' + CAST(su1.ID AS NVARCHAR(MAX)) + '|' + su1.PartialCode + '|' + su1.Name + '|' + CAST(su1.CreditNumber AS NVARCHAR(MAX)) + '|' + CAST(su1.SemesterNumber AS NVARCHAR(MAX)) + '|'
								FROM Subjects su1
								WHERE su1.SubjectTypeID = st.ID
								ORDER BY su1.SemesterNumber ASC
								FOR XML PATH('')	
							), 1, 1,''
						)
					--SUM(temp.CreditNumber) AS CreditNumberTotal
			
	FROM SubjectTypes st
				--LEFT JOIN ( SELECT sb.SubjectTypeID, sb.CreditNumber, sb.ID
				--			FROM Subjects sb
				--			WHERE sb.FacultyID = @FacultyID
				--		   ) AS temp ON st.ID = temp.SubjectTypeID 
	GROUP BY st.ID, st.Name	
END
GO
/****** Object:  StoredProcedure [dbo].[GetSubjectKnowledgeTypeBySubjectID]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Nhan>
-- Create date: <01/07/2017>
-- Description:	<Get Subject Knowledge Type By SubjectID>
-- =============================================
CREATE PROCEDURE [dbo].[GetSubjectKnowledgeTypeBySubjectID] 
	@SubjectID INT
AS
BEGIN
	SELECT distinct sb.*, s.Name, s.Form
	FROM Subjects s
	left JOIN SubjectTypes sb ON sb.ID = s.SubjectTypeID AND s.ID = @SubjectID
END

GO
/****** Object:  StoredProcedure [dbo].[GetTotalCreditNumberByFacultyID]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Nhan>
-- Create date: <22/06/2017>
-- Description:	<Get Total CreditNumber By Faculty>
-- =============================================
CREATE PROCEDURE [dbo].[GetTotalCreditNumberByFacultyID] 
	@FacultyID int,
	@Result int OUTPUT
AS
BEGIN
	
	SET @Result = (SELECT SUM(sb.CreditNumber)
	FROM Subjects sb
			JOIN SubjectsOfFaculties sof ON sb.ID = sof.SubjectID
	WHERE sof.FacultyID = @FacultyID)

END

GO
/****** Object:  StoredProcedure [dbo].[GetTrainingPlanByFacultyID]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Nhan>
-- Create date: <23/06/2017>
-- Description:	<Get Training Plan by FacultyID>
-- =============================================
CREATE PROCEDURE [dbo].[GetTrainingPlanByFacultyID]
	@FacultyID INT
AS
BEGIN
	SELECT sj.SemesterNumber,
					SubjectsList = STUFF (
											(SELECT '|' + CAST(sj1.ID AS NVARCHAR(MAX)) + '|' + sj1.PartialCode + '|'+ sj1.Name + '|' + CAST(sj1.CreditNumber AS NVARCHAR(MAX)) + '|' + CAST(sj1.TheoryNumber AS NVARCHAR(MAX)) + '|' + CAST(sj1.PracticeNumber AS NVARCHAR(MAX)) + '|'
											 FROM Subjects sj1																								
											 WHERE sj1.SemesterNumber = sj.SemesterNumber
											 FOR XML PATH('')	
											), 1, 1,''
										 ), 
										 SUM(sj.CreditNumber) AS CreditNumberTotal,
										 SUM(sj.TheoryNumber + sj.PracticeNumber) AS LessonNumber
	FROM Subjects sj
				JOIN SubjectsOfFaculties sof ON sj.ID = sof.SubjectID
	WHERE sof.FacultyID = @FacultyID
	GROUP BY sj.SemesterNumber
	ORDER BY sj.SemesterNumber ASC
END

GO
/****** Object:  StoredProcedure [dbo].[GetTrainingPlanByFacultyIDdemo]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Nhan>
-- Create date: <23/06/2017>
-- Description:	<Get Training Plan by FacultyID>
-- =============================================
CREATE PROCEDURE [dbo].[GetTrainingPlanByFacultyIDdemo]
	@FacultyID INT
AS
BEGIN
		SELECT sj.SemesterNumber,
					SubjectsList = STUFF (
											(SELECT '|' + CAST(sj1.ID AS NVARCHAR(MAX)) + '|' + sj1.PartialCode + '|'+ sj1.Name + '|' + CAST(sj1.CreditNumber AS NVARCHAR(MAX)) + '|' + CAST(sj1.TheoryNumber AS NVARCHAR(MAX)) + '|' + CAST(sj1.PracticeNumber AS NVARCHAR(MAX)) + '|'
											 FROM Subjects sj1
											 			--JOIN ConditionRelateSubjects crs ON sj1.ID = crs.ConditionSubjectID									
											 WHERE sj1.SemesterNumber = sj.SemesterNumber
											 FOR XML PATH('')		
											), 1, 1,''
										 ),
										 
					
										SUM(sj.CreditNumber) AS CreditNumberTotal,
										SUM(sj.TheoryNumber + sj.PracticeNumber) AS LessonNumber

	FROM Subjects sj
				JOIN ConditionRelateSubjects crs ON sj.ID = crs.ConditionSubjectID
				JOIN SubjectsOfFaculties sof ON crs.SubjectID = sj.ID
	WHERE sof.FacultyID = @FacultyID
	GROUP BY sj.SemesterNumber
	ORDER BY sj.SemesterNumber ASC
END

GO
/****** Object:  Table [dbo].[AccountRoles]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccountRoles](
	[AccountID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
 CONSTRAINT [PK_AccountRoles] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC,
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Accounts]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Accounts](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](max) NOT NULL,
	[Password] [nvarchar](max) NOT NULL,
	[FullName] [nvarchar](500) NOT NULL,
	[Degree] [nvarchar](max) NULL,
	[PhoneNumber] [varchar](15) NOT NULL,
	[Email] [varchar](500) NOT NULL,
	[FacultyID] [int] NULL,
	[CreationTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Lecturers] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Classrooms]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Classrooms](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[IsOfficeFacility] [bit] NOT NULL,
	[FacilityID] [int] NOT NULL,
	[CreationTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Classrooms] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ConditionRelateSubjects]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConditionRelateSubjects](
	[SubjectID] [int] NOT NULL,
	[ConditionSubjectID] [int] NOT NULL,
 CONSTRAINT [PK_ConditionRelateSubjects] PRIMARY KEY CLUSTERED 
(
	[SubjectID] ASC,
	[ConditionSubjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Facilities]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Facilities](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Address] [nvarchar](max) NOT NULL,
	[CreationTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Facilities] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Faculties]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Faculties](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[VietNameseName] [nvarchar](max) NOT NULL,
	[EnglishName] [nvarchar](max) NOT NULL,
	[PhoneNumber] [nvarchar](15) NOT NULL,
	[ClassroomID] [int] NOT NULL,
	[TrainingTime] [int] NOT NULL,
	[CreationTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Faculties] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Programs]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Programs](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[TrainingLevel] [nvarchar](max) NOT NULL,
	[BranchName] [nvarchar](max) NOT NULL,
	[EducationType] [nvarchar](max) NOT NULL,
	[TrainingPurpose] [nvarchar](max) NOT NULL,
	[EntranceStudent] [nvarchar](max) NOT NULL,
	[TrainingTimeDetail] [nvarchar](max) NOT NULL,
	[KnowledgeTotal] [nvarchar](max) NOT NULL,
	[GraduateCondition] [nvarchar](max) NOT NULL,
	[PointLadder] [int] NOT NULL,
	[TrainingSupport] [nvarchar](max) NOT NULL,
	[Content] [nvarchar](max) NOT NULL,
	[TrainingPlan] [nvarchar](max) NOT NULL,
	[Status] [bit] NOT NULL,
	[ShortContentDescription] [nvarchar](max) NOT NULL,
	[LecturerList] [nvarchar](max) NOT NULL,
	[FacultyID] [int] NOT NULL,
	[CreationTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Programs] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Roles]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[CreationTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Subjects]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Subjects](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[PartialCode] [varchar](50) NOT NULL,
	[CreditNumber] [int] NOT NULL,
	[TheoryNumber] [int] NOT NULL,
	[PracticeNumber] [int] NOT NULL,
	[LearningLevel] [nvarchar](max) NOT NULL,
	[SemesterNumber] [int] NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[Purpose] [nvarchar](max) NOT NULL,
	[FacultyID] [int] NULL,
	[SubjectTypeID] [int] NOT NULL,
	[Form] [bit] NOT NULL,
	[CreationTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Subjects] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SubjectsAccounts]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubjectsAccounts](
	[SubjectID] [int] NOT NULL,
	[AccountID] [int] NOT NULL,
	[IsSyllabusEditor] [bit] NOT NULL,
 CONSTRAINT [PK_SubjectsAccounts] PRIMARY KEY CLUSTERED 
(
	[SubjectID] ASC,
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubjectTypes]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubjectTypes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SubSubjectTypeID] [int] NULL,
	[SubTwoSubjectTypeID] [int] NULL,
	[Name] [nvarchar](max) NOT NULL,
	[CreationTime] [datetime] NOT NULL,
 CONSTRAINT [PK_SubjectTypes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Syllabuses]    Script Date: 7/11/2017 11:56:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Syllabuses](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[VietnameseName] [nvarchar](max) NOT NULL,
	[EnglishName] [nvarchar](max) NOT NULL,
	[KnowldgeType] [nvarchar](max) NOT NULL,
	[LearningTimeDetail] [nvarchar](max) NOT NULL,
	[Requirement] [nvarchar](max) NOT NULL,
	[Planning] [nvarchar](max) NOT NULL,
	[DocumentReference] [nvarchar](max) NOT NULL,
	[LearningOutcomeEvaluate] [nvarchar](max) NOT NULL,
	[LecturerContact] [nvarchar](max) NOT NULL,
	[ShortDescription] [nvarchar](max) NOT NULL,
	[OutcomeContent] [nvarchar](max) NOT NULL,
	[OutcomeMaxtrixMapping] [nvarchar](max) NOT NULL,
	[OutcomeMappingDescription] [nvarchar](max) NOT NULL,
	[CreatedAccountID] [int] NOT NULL,
	[ClassroomID] [int] NOT NULL,
	[SubjectID] [int] NOT NULL,
	[CreationTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Syllabuses] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (3, 5)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (4, 3)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (5, 4)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (9, 5)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (11, 4)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (11, 5)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (12, 5)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (18, 5)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (19, 4)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (20, 4)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (21, 5)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (22, 5)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (23, 5)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (24, 5)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (25, 5)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (26, 5)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (27, 3)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (28, 3)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (29, 3)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (30, 5)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (31, 6)
INSERT [dbo].[AccountRoles] ([AccountID], [RoleID]) VALUES (32, 5)
SET IDENTITY_INSERT [dbo].[Accounts] ON 

INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (3, N'lecturer', N'123', N'Nguyễn Văn Giảng Viên', N'ThS', N'01234567', N'nguyenvana@gmail.com', 1, CAST(0x0000A79200AC12E3 AS DateTime))
INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (4, N'admin', N'123', N'Nguyễn Admin', N'ADmin', N'123123123', N'admin@gmail.com', NULL, CAST(0x0000A79200AC37E8 AS DateTime))
INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (5, N'deanery', N'123', N'Nguyễn Trưởng Khoa', N'TS', N'123123123', N'truongkhoa@gmail.com', 3, CAST(0x0000A79801556A48 AS DateTime))
INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (9, N'lecturer2', N'123', N'Nguyễn Lecturer2', N'Ths', N'123123123', N'lecturer2@gmail.com', 1, CAST(0x0000A79B00744C9B AS DateTime))
INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (11, N'lecturer3', N'123', N'nguuyen lecturer3', N'Ths', N'123123', N'123123@gmail.com', 4, CAST(0x0000A79C00AD1F9D AS DateTime))
INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (12, N'lecturer4', N'123', N'nguuyen lecturer4', N'Ths', N'123123', N'123123@gmail.com', 1, CAST(0x0000A79C00AD1F9D AS DateTime))
INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (18, N'huunhan', N'123', N'ngo huu nhan 123', N'Ths', N'123123123', N'huunhan@gmail.com', 3, CAST(0x0000A79E000DE6F1 AS DateTime))
INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (19, N'12', N'123', N'qqqqq', N'qqqqq', N'111111', N'qqqqq@gmai.com', 4, CAST(0x0000A79E000EA50F AS DateTime))
INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (20, N'nvan a', N'123', N'ten dau dy', N'TS', N'123123', N'asda@gmail.com', 4, CAST(0x0000A7A100CCB054 AS DateTime))
INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (21, N'bb', N'123', N'qwe', N'qwe', N'123', N'123@gmail.com', 5, CAST(0x0000A7A100D0A1CC AS DateTime))
INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (22, N'vangvanqui', N'123', N'văng văn quí#', N'thac si', N'0966885557', N'quivangvan@gmail.com', 1, CAST(0x0000A7A200F11744 AS DateTime))
INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (23, N'vangvanqui', N'123', N'văng văn quí#', N'thac si', N'0966885557', N'quivangvan@gmail.com', 1, CAST(0x0000A7A200F12739 AS DateTime))
INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (24, N'vangvanqui', N'123', N'văng văn quí#', N'thac si', N'0966885557', N'quivangvan@gmail.com', 1, CAST(0x0000A7A200F12F8B AS DateTime))
INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (25, N'vangvanqui', N'123', N'văng văn quí', N'thac si', N'0966885557', N'quivangvan@gmail.com', 1, CAST(0x0000A7A200F13E82 AS DateTime))
INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (26, N'vangvanqui', N'123', N'văng văn quí', N'thac si', N'0966885557', N'quivangvan@gmail.com', 1, CAST(0x0000A7A200F14297 AS DateTime))
INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (27, N'admin12', N'123', N'vangvanqui', N'thac si', N'0966885557', N'quivangvan@gmail.com', 1, CAST(0x0000A7A200F1EABF AS DateTime))
INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (28, N'admin12', N'123', N'vangvanquissda#########', N'thac si', N'0966885557', N'quivangvan@gmail.com', 1, CAST(0x0000A7A200F1F9ED AS DateTime))
INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (29, N'admin12', N'123', N'vangvanquissda#########', N'thac si', N'0966885557', N'quivangvan@gmail.com', 1, CAST(0x0000A7A200F20350 AS DateTime))
INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (30, N'vang ban', N'123', N'văng văn quí', N'thạc sỹ', N'0966885557', N'quivangvan@gmail.com', 1, CAST(0x0000A7A400040825 AS DateTime))
INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (31, N'editor', N'123', N'Nguyễn Editor', N'ThS', N'123456798', N'nguyeneditor@gmail.com', NULL, CAST(0x0000A7A70128E177 AS DateTime))
INSERT [dbo].[Accounts] ([ID], [UserName], [Password], [FullName], [Degree], [PhoneNumber], [Email], [FacultyID], [CreationTime]) VALUES (32, N'lecturer7', N'123', N'abc', N'Ths', N'21355342', N'abc@gmail.com', 1, CAST(0x0000A7A800C34A54 AS DateTime))
SET IDENTITY_INSERT [dbo].[Accounts] OFF
SET IDENTITY_INSERT [dbo].[Classrooms] ON 

INSERT [dbo].[Classrooms] ([ID], [Name], [IsOfficeFacility], [FacilityID], [CreationTime]) VALUES (1, N'301A', 0, 2, CAST(0x0000A79E00C3F179 AS DateTime))
INSERT [dbo].[Classrooms] ([ID], [Name], [IsOfficeFacility], [FacilityID], [CreationTime]) VALUES (2, N'104B', 0, 3, CAST(0x0000A79E00C5935A AS DateTime))
INSERT [dbo].[Classrooms] ([ID], [Name], [IsOfficeFacility], [FacilityID], [CreationTime]) VALUES (3, N'703B', 1, 2, CAST(0x0000A79E00C5FD1F AS DateTime))
INSERT [dbo].[Classrooms] ([ID], [Name], [IsOfficeFacility], [FacilityID], [CreationTime]) VALUES (4, N'209B', 1, 2, CAST(0x0000A79E00C615CC AS DateTime))
INSERT [dbo].[Classrooms] ([ID], [Name], [IsOfficeFacility], [FacilityID], [CreationTime]) VALUES (5, N'909A', 1, 2, CAST(0x0000A79E00C70F0E AS DateTime))
INSERT [dbo].[Classrooms] ([ID], [Name], [IsOfficeFacility], [FacilityID], [CreationTime]) VALUES (11, N'202B', 0, 2, CAST(0x0000A79A00D704A8 AS DateTime))
INSERT [dbo].[Classrooms] ([ID], [Name], [IsOfficeFacility], [FacilityID], [CreationTime]) VALUES (12, N'303A', 0, 2, CAST(0x0000A79A00D704A8 AS DateTime))
INSERT [dbo].[Classrooms] ([ID], [Name], [IsOfficeFacility], [FacilityID], [CreationTime]) VALUES (14, N'304B', 0, 2, CAST(0x0000A79A00D704A8 AS DateTime))
INSERT [dbo].[Classrooms] ([ID], [Name], [IsOfficeFacility], [FacilityID], [CreationTime]) VALUES (15, N'402B', 1, 2, CAST(0x0000A79A00D704A8 AS DateTime))
INSERT [dbo].[Classrooms] ([ID], [Name], [IsOfficeFacility], [FacilityID], [CreationTime]) VALUES (16, N'503C', 1, 2, CAST(0x0000A79A00D704A8 AS DateTime))
INSERT [dbo].[Classrooms] ([ID], [Name], [IsOfficeFacility], [FacilityID], [CreationTime]) VALUES (17, N'603C', 1, 2, CAST(0x0000A79A00D704A8 AS DateTime))
INSERT [dbo].[Classrooms] ([ID], [Name], [IsOfficeFacility], [FacilityID], [CreationTime]) VALUES (19, N'702B', 0, 2, CAST(0x0000A79A00D704A8 AS DateTime))
INSERT [dbo].[Classrooms] ([ID], [Name], [IsOfficeFacility], [FacilityID], [CreationTime]) VALUES (20, N'703A', 0, 2, CAST(0x0000A79A00D704A8 AS DateTime))
INSERT [dbo].[Classrooms] ([ID], [Name], [IsOfficeFacility], [FacilityID], [CreationTime]) VALUES (21, N'509G', 1, 3, CAST(0x0000A7990105E2FF AS DateTime))
INSERT [dbo].[Classrooms] ([ID], [Name], [IsOfficeFacility], [FacilityID], [CreationTime]) VALUES (23, N'309C', 1, 3, CAST(0x0000A7990105E2FF AS DateTime))
INSERT [dbo].[Classrooms] ([ID], [Name], [IsOfficeFacility], [FacilityID], [CreationTime]) VALUES (24, N'208A', 1, 2, CAST(0x0000A7990105E2FF AS DateTime))
INSERT [dbo].[Classrooms] ([ID], [Name], [IsOfficeFacility], [FacilityID], [CreationTime]) VALUES (27, N'904B', 0, 3, CAST(0x0000A7990105E2FF AS DateTime))
SET IDENTITY_INSERT [dbo].[Classrooms] OFF
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (10, 11)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (11, 9)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (11, 10)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (14, 9)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (14, 10)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (14, 11)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (15, 14)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (16, 9)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (16, 14)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (16, 15)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (17, 8)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (17, 9)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (17, 22)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (18, 9)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (20, 9)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (20, 22)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (23, 10)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (23, 11)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (42, 17)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (43, 17)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (52, 8)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (52, 9)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (56, 8)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (56, 10)
INSERT [dbo].[ConditionRelateSubjects] ([SubjectID], [ConditionSubjectID]) VALUES (57, 14)
SET IDENTITY_INSERT [dbo].[Facilities] ON 

INSERT [dbo].[Facilities] ([ID], [Name], [Address], [CreationTime]) VALUES (2, N'Cơ sở 1', N'45 Nguyễn Khắc Nhu, P. Cô Giang, Q.1, Tp. Hồ Chí Minh', CAST(0x0000A79701851AFB AS DateTime))
INSERT [dbo].[Facilities] ([ID], [Name], [Address], [CreationTime]) VALUES (3, N'Cơ sở 2', N'233A Phan Văn Trị , P.11, Q. Bình Thạnh, Tp. Hồ Chí Minh', CAST(0x0000A7990105E2FF AS DateTime))
SET IDENTITY_INSERT [dbo].[Facilities] OFF
SET IDENTITY_INSERT [dbo].[Faculties] ON 

INSERT [dbo].[Faculties] ([ID], [VietNameseName], [EnglishName], [PhoneNumber], [ClassroomID], [TrainingTime], [CreationTime]) VALUES (1, N'Kỹ Thuật Phần Mềm', N'(Software Engineering)', N'123345123', 3, 2, CAST(0x0000A79200AA9B81 AS DateTime))
INSERT [dbo].[Faculties] ([ID], [VietNameseName], [EnglishName], [PhoneNumber], [ClassroomID], [TrainingTime], [CreationTime]) VALUES (3, N'Ngôn Ngữ Anh', N'Foreign English Language', N'21785785', 17, 4, CAST(0x0000A79200ABE0A9 AS DateTime))
INSERT [dbo].[Faculties] ([ID], [VietNameseName], [EnglishName], [PhoneNumber], [ClassroomID], [TrainingTime], [CreationTime]) VALUES (4, N'Công nghệ và quản lý môi trường', N'Technologies and enviroment management', N'7171747', 16, 4, CAST(0x0000A79A00D63A23 AS DateTime))
INSERT [dbo].[Faculties] ([ID], [VietNameseName], [EnglishName], [PhoneNumber], [ClassroomID], [TrainingTime], [CreationTime]) VALUES (5, N'Kiến xây', N'Architech', N'42452782', 15, 5, CAST(0x0000A79A00D6B022 AS DateTime))
INSERT [dbo].[Faculties] ([ID], [VietNameseName], [EnglishName], [PhoneNumber], [ClassroomID], [TrainingTime], [CreationTime]) VALUES (6, N'Nhiệt lạnh', N'English', N'2727272', 2, 5, CAST(0x0000A79A00D704A8 AS DateTime))
INSERT [dbo].[Faculties] ([ID], [VietNameseName], [EnglishName], [PhoneNumber], [ClassroomID], [TrainingTime], [CreationTime]) VALUES (7, N'Công nghệ sinh học', N'Biology', N'11111111111', 5, 4, CAST(0x0000A79E00A429F8 AS DateTime))
SET IDENTITY_INSERT [dbo].[Faculties] OFF
SET IDENTITY_INSERT [dbo].[Programs] ON 

INSERT [dbo].[Programs] ([ID], [Name], [TrainingLevel], [BranchName], [EducationType], [TrainingPurpose], [EntranceStudent], [TrainingTimeDetail], [KnowledgeTotal], [GraduateCondition], [PointLadder], [TrainingSupport], [Content], [TrainingPlan], [Status], [ShortContentDescription], [LecturerList], [FacultyID], [CreationTime]) VALUES (1, N'Ngôn Ngữ Anh (Foreign English Language)', N'7878', N'ádasdasd', N'ádasd', N'<p>&nbsp;</p>
<p>Đ&agrave;o tạo nguồn nh&acirc;n lực ph&aacute;t triển c&ocirc;ng nghệ th&ocirc;ng tin cho x&atilde; hội. Sinh vi&ecirc;n được cung cấp c&aacute;c kiến thức kỹ năng về x&acirc;y dựng v&agrave; ph&aacute;t triển phần mềm:</p>
<p><strong>- Về kiến thức:</strong></p>
<ul>
<li>C&oacute; hiểu biết v&agrave; khả năng vận dụng c&aacute;c kiến thức cơ bản về khoa học tự nhi&ecirc;n, kiến thức về khoa học x&atilde; hội để đ&aacute;p ứng việc tiếp thu c&aacute;c kiến thức gi&aacute;o dục chuy&ecirc;n nghiệp, v&agrave; tiếp tục học tập ở tr&igrave;nh độ cao hơn</li>
<li>C&oacute; c&aacute;c kiến thức cơ sở về c&ocirc;ng nghệ th&ocirc;ng tin như kiến tr&uacute;c m&aacute;y t&iacute;nh, cấu tr&uacute;c dữ liệu v&agrave; giải thuật, lập tr&igrave;nh hướng đối tượng, mạng m&aacute;y t&iacute;nh, an ninh mạng, cơ sở dữ liệu, lập tr&igrave;nh tr&ecirc;n c&aacute;c thiết bị di động. Đặc biệt, c&oacute; hiểu biết s&acirc;u rộng trong ng&agrave;nh kỹ thuật phần mềm</li>
</ul>
<p>- <strong>Về kỹ năng, th&aacute;i độ v&agrave; đạo đức nghề nghiệp:</strong></p>
<ul>
<li>C&oacute; th&aacute;i độ đ&uacute;ng đắn tu&acirc;n thủ luật ph&aacute;p</li>
<li>C&oacute; th&aacute;i độ nghi&ecirc;m t&uacute;c, &yacute; thức l&agrave;m việc v&agrave; t&aacute;c phong chuy&ecirc;n nghiệp</li>
<li>C&oacute; phương ph&aacute;p l&agrave;m việc khoa học, tư tưởng l&agrave;m việc cộng t&aacute;c v&agrave; chia sẻ</li>
<li>C&oacute; kỹ năng l&agrave;m việc nh&oacute;m, kỹ năng giao tiếp, kỹ năng l&atilde;nh đạo cấp trung, c&oacute; tinh thần đạo đức trong kinh doanh v&agrave; quản trị th&ocirc;ng tin, c&oacute; tinh thần cộng đồng</li>
</ul>
<p>&nbsp;</p>
<p><strong>- Về khả năng c&ocirc;ng t&aacute;c:</strong> &nbsp;Sau khi tốt nghiệp, c&aacute;c kỹ sư ng&agrave;nh kỹ thuật phần mềm c&oacute; thể:</p>
<ul>
<li>Giảng dạy c&aacute;c m&ocirc;n li&ecirc;n quan đến c&ocirc;ng nghệ th&ocirc;ng tin tại c&aacute;c trường đại học, cao đẳng, trung học chuy&ecirc;n nghiệp, dạy nghề v&agrave; c&aacute;c trường phổ th&ocirc;ng</li>
<li>Hoặc l&agrave;m việc tại c&aacute;c c&ocirc;ng ty sản xuất, gia c&ocirc;ng phần mềm trong nước cũng như nước ngo&agrave;i trong c&aacute;c vai tr&ograve;:
<ul>
<li>Lập tr&igrave;nh vi&ecirc;n, trưởng nh&oacute;m lập tr&igrave;nh</li>
<li>Ph&acirc;n t&iacute;ch vi&ecirc;n hệ thống</li>
<li>Kỹ sư thiết kế phần mềm</li>
<li>Kỹ sư kiểm thử v&agrave; đảm bảo chất lượng phần mềm</li>
<li>C&aacute;n bộ quản l&yacute; dự &aacute;n phần mềm</li>
</ul>
</li>
</ul>
<p>&nbsp;</p>', N'qưdqwdq', N'4 năm (gồm 8 học kỳ)', N'Đại học 4 năm: 13 tín chỉ (TC)', N'qưdqwd', 2, N'<p>&nbsp;</p>
<p>&nbsp;</p>
<table width="642">
<tbody>
<tr>
<td width="48">
<p><strong>STT</strong></p>
</td>
<td width="192">
<p><strong>Họ v&agrave; t&ecirc;n</strong></p>
</td>
<td width="54">
<p><strong>Năm sinh</strong></p>
</td>
<td width="156">
<p><strong>Văn bằng cao nhất, ng&agrave;nh đ&agrave;o tạo</strong></p>
</td>
<td width="192">
<p><strong>C&aacute;c m&ocirc;n sẽ đảm tr&aacute;ch (*)</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>1</strong></p>
</td>
<td width="192">
<p><strong>Huỳnh Thị Kim Ho&agrave;ng</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>CN/English</strong></p>
</td>
<td width="192">
<p><strong>English</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>2</strong></p>
</td>
<td width="192">
<p><strong>Nguyễn Hải H&ugrave;ng</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>CN/Economics</strong></p>
</td>
<td width="192">
<p><strong>IS,Management</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>3</strong></p>
</td>
<td width="192">
<p><strong>Phạm Thị Diệu Hường</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>Th.S/Mathematics</strong></p>
</td>
<td width="192">
<p><strong>&nbsp;Mathematics</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>4</strong></p>
</td>
<td width="192">
<p><strong>Phạm Thị H&agrave; Mi</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>&nbsp;</strong></p>
</td>
<td width="192">
<p><strong>English</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>5</strong></p>
</td>
<td width="192">
<p><strong>B&ugrave;i Quốc Nam</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>THS/Economics</strong></p>
</td>
<td width="192">
<p><strong>IS,Management</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>6</strong></p>
</td>
<td width="192">
<p><strong>Vũ Thế Nam</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>CN/IT</strong></p>
</td>
<td width="192">
<p><strong>Programming&nbsp; </strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>7</strong></p>
</td>
<td width="192">
<p><strong>L&ecirc; Hồng Ngọc</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>CN/English</strong></p>
</td>
<td width="192">
<p><strong>English</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>8</strong></p>
</td>
<td width="192">
<p><strong>B&ugrave;i Minh Phụng</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>Th.S/IT</strong></p>
</td>
<td width="192">
<p><strong>Network,Programming</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>9</strong></p>
</td>
<td width="192">
<p><strong>Nguyễn Thị Thu Quy&ecirc;n</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>Th.S/Physics</strong></p>
</td>
<td width="192">
<p><strong>Physics</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>10</strong></p>
</td>
<td width="192">
<p><strong>L&ecirc; Viết Thắng</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>Th.S/English</strong></p>
</td>
<td width="192">
<p><strong>Network</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>11</strong></p>
</td>
<td width="192">
<p><strong>L&ecirc; Hùng Ti&ecirc;́n</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>TS</strong></p>
</td>
<td width="192">
<p><strong>&nbsp;</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>12</strong></p>
</td>
<td width="192">
<p><strong>Nguy&ecirc;̃n Hữu Qu&ocirc;́c</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>CN</strong></p>
</td>
<td width="192">
<p><strong>&nbsp;</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>13</strong></p>
</td>
<td width="192">
<p><strong>Nguyễn Đắc Quỳnh Mi</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>Th.S</strong></p>
</td>
<td width="192">
<p><strong>&nbsp;</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>14</strong></p>
</td>
<td width="192">
<p><strong>Phạm Ngọc Duy</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>Th.S</strong></p>
</td>
<td width="192">
<p><strong>&nbsp;</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>15</strong></p>
</td>
<td width="192">
<p><strong>T&ocirc; Đình Hi&ecirc;́u</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>CN</strong></p>
</td>
<td width="192">
<p><strong>&nbsp;</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>16</strong></p>
</td>
<td width="192">
<p><strong>Lý Thị Huy&ecirc;̀n Ch&acirc;u</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>ThS</strong></p>
</td>
<td width="192">
<p><strong>&nbsp;</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>17</strong></p>
</td>
<td width="192">
<p><strong>Phạm Minh Huy&ecirc;n</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>CN</strong></p>
</td>
<td width="192">
<p><strong>&nbsp;</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>18</strong></p>
</td>
<td width="192">
<p><strong>Nguy&ecirc;̃n Th&ecirc;́ Quang</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>Th.S</strong></p>
</td>
<td width="192">
<p><strong>&nbsp;</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>19</strong></p>
</td>
<td width="192">
<p><strong>Phan Thị H&ocirc;̀ng</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>CN</strong></p>
</td>
<td width="192">
<p><strong>&nbsp;</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>21</strong></p>
</td>
<td width="192">
<p><strong>Đặng Đ&igrave;nh H&ograve;a</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>CN</strong></p>
</td>
<td width="192">
<p><strong>&nbsp;</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>22</strong></p>
</td>
<td width="192">
<p><strong>Trần C&ocirc;ng Thanh</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>THS</strong></p>
</td>
<td width="192">
<p><strong>&nbsp;</strong></p>
</td>
</tr>
<tr>
<td width="48">
<p><strong>23</strong></p>
</td>
<td width="192">
<p><strong>L&ecirc; Sĩ Ph&uacute;</strong></p>
</td>
<td width="54">
<p><strong>&nbsp;</strong></p>
</td>
<td width="156">
<p><strong>THS</strong></p>
</td>
<td width="192">
<p><strong>&nbsp;</strong></p>
</td>
</tr>
</tbody>
</table>
<p><strong>&nbsp;</strong></p>
<p><strong>&nbsp;</strong></p>
<ol start="11">
<li><strong> Cơ sở vật chất phục vụ học tập:</strong></li>
</ol>
<p>11.1 C&aacute;c ph&ograve;ng th&iacute; nghiệm v&agrave; c&aacute;c hệ thống thiết bị th&iacute; nghiệm quan trọng</p>
<ul>
<li>Trang bị cho c&ocirc;ng t&aacute;c giảng dạy: Hiện nay hầu hết c&aacute;c m&ocirc;n học của Khoa được trang bị máy chi&ecirc;́u v&agrave; m&aacute;y t&iacute;nh để c&aacute;c giảng vi&ecirc;n thực hiện thiết kế b&agrave;i giảng điện tử ph&ugrave; hợp với c&ocirc;ng nghệ v&agrave; ng&agrave;nh nghề của Khoa</li>
<li>Trang bị cho c&ocirc;ng t&aacute;c nghi&ecirc;n cứu: tăng cường hơn nữa về chế độ ưu ti&ecirc;n cho sinh vi&ecirc;n chuy&ecirc;n ng&agrave;nh c&ocirc;ng nghệ th&ocirc;ng tin được v&agrave;o t&igrave;m t&agrave;i liệu internet trong ph&ograve;ng internet của nh&agrave; trường. Đồng thời tiếp x&uacute;c với hệ thống e &ndash; learning (<a href="http://www.hoctructuyen.vanlanguni.edu.vn">hoctructuyen.vanlanguni.edu.vn</a>) hiện c&oacute; của nh&agrave; trường</li>
<li>Trang bị ph&ograve;ng th&iacute; nghiệm chuy&ecirc;n ng&agrave;nh Khoa nhằm phục vụ cho việc nghi&ecirc;n cứu của giảng vi&ecirc;n cơ hữu v&agrave; c&aacute;c m&ocirc;n học đ&ograve;i hỏi c&ocirc;ng nghệ cao trong chương tr&igrave;nh đ&agrave;o tạo của Khoa</li>
<li>Trang bị ph&ograve;ng Lab gồm 24 - 60 m&aacute;y tính &ndash; c&oacute; chức năng chạy c&aacute;c chương tr&igrave;nh Multimedia,cũng như v&agrave;o Internet gi&uacute;p c&aacute;c em sinh vi&ecirc;n c&oacute; thể học c&aacute;c b&agrave;i giảng của c&aacute;c gi&aacute;o sư của Đại học Carnegie Mellon</li>
<li>Hiện nay nh&agrave; trường c&oacute; tất cả 14 ph&ograve;ng m&aacute;y với hơn 600 m&aacute;y d&agrave;nh cho SV thực h&agrave;nh trong đ&oacute; c&oacute; cấu h&igrave;nh 65 m&aacute;y core 2 Duo d&agrave;nh cho SV thực h&agrave;nh c&aacute;c b&agrave;i to&aacute;n m&ocirc; phỏng ,thời gian thật &hellip;.</li>
</ul>
<p>&nbsp;</p>
<p>11.2 Thư viện</p>
<p>Thư viện trường gồm 2 cơ sở: một phục vụ cho khối ng&agrave;nh Kinh tế-Quản trị kinh doanh v&agrave; một phục vụ cho nh&oacute;m ng&agrave;nh Kỹ thuật-c&ocirc;ng nghệ-khoa học x&atilde; hội. Hiện nay thự viện với tổng số s&aacute;ch hơn 20.000 cuốn ( hơn 1000 đầu s&aacute;ch cho C&ocirc;ng nghệ Th&ocirc;ng Tin ) đ&atilde; đ&aacute;p ứng được nhu cầu về gi&aacute;o tr&igrave;nh học tập cũng như s&aacute;ch tham khảo trong qu&aacute; tr&igrave;nh học tập v&agrave; giảng dạy.</p>
<p>11.3 Gi&aacute;o tr&igrave;nh, tập b&agrave;i giảng:</p>
<p>Gi&aacute;o tr&igrave;nh ,tập b&agrave;i giảng hằng năm được cập nhật theo chương tr&igrave;nh giảng dạy của Đại học Carnegie Mellon .K&egrave;m theo s&aacute;ch l&agrave; c&aacute;c b&agrave;i giảng video của c&aacute;c giảng vi&ecirc;n CMU</p>
<p>&nbsp;</p>
<p>Gi&aacute;o tr&igrave;nh năm thứ 1:</p>
<table>
<tbody>
<tr>
<td width="97">
<p><strong>Số thứ tự</strong></p>
</td>
<td width="176">
<p><strong>T&ecirc;n s&aacute;ch</strong></p>
</td>
<td width="130">
<p><strong>T&aacute;c gỉa</strong></p>
</td>
<td width="84">
<p><strong>Nh&agrave; XB</strong></p>
</td>
<td width="103">
<p><strong>Lần tb/năm t&aacute;i bản</strong></p>
</td>
</tr>
<tr>
<td width="97">
<p>1</p>
</td>
<td width="176">
<p>Caculus Early Transcendentals</p>
</td>
<td width="130">
<p>James Stewart</p>
</td>
<td width="84">
<p>Brooks Cole</p>
</td>
<td width="103">
<p>6 th</p>
</td>
</tr>
<tr>
<td width="97">
<p>2</p>
</td>
<td width="176">
<p>Computer networks and Internet</p>
</td>
<td width="130">
<p>Douglas .E.Comer</p>
</td>
<td width="84">
<p>Pearson (Prentice Hall)</p>
</td>
<td width="103">
<p>2009</p>
</td>
</tr>
<tr>
<td width="97">
<p>3</p>
</td>
<td width="176">
<p>Objects,Abstraction,Data Structures and Design using Java version 5.0</p>
</td>
<td width="130">
<p>- Elliot B. Koffman</p>
<p>- Paul A.T. Wolfgang</p>
</td>
<td width="84">
<p>John Wiley</p>
</td>
<td width="103">
<p>2 nd ; 2005</p>
</td>
</tr>
<tr>
<td width="97">
<p>4</p>
</td>
<td width="176">
<p>Java 6 Illuminated .an Active Learning Approach</p>
</td>
<td width="130">
<p>- Julie Anderson</p>
<p>- Herve Franceschi</p>
</td>
<td width="84">
<p>Jones &amp; Bartlett</p>
</td>
<td width="103">
<p>2008</p>
</td>
</tr>
<tr>
<td width="97">
<p>&nbsp;</p>
</td>
<td width="176">
<p>&nbsp;</p>
</td>
<td width="130">
<p>&nbsp;</p>
</td>
<td width="84">
<p>&nbsp;</p>
</td>
<td width="103">
<p>&nbsp;</p>
</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>
<p><strong>&nbsp;</strong></p>', N'<p>&nbsp;</p>
<table style="width: 508.75pt; margin-left: 5.15pt; border-collapse: collapse;" width="678">
<tbody>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">
<p><strong><span style="font-size: 14.0pt; font-family: ''Times New Roman'',serif;">STT</span></strong></p>
</td>
<td style="width: 93.45pt; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><strong><span style="font-size: 14.0pt; font-family: ''Times New Roman'',serif;">M&atilde; MH</span></strong></p>
</td>
<td style="width: 3.75in; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><strong><span style="font-size: 14.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n học</span></strong></p>
</td>
<td style="width: 45.0pt; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="60">
<p><strong><span style="font-size: 14.0pt; font-family: ''Times New Roman'',serif;">TC</span></strong></p>
</td>
<td style="width: 63.0pt; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="84">
<p><strong><span style="font-size: 14.0pt; font-family: ''Times New Roman'',serif;">Học kỳ</span></strong></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 400.75pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="3" width="534">
<p><strong><span style="font-family: ''Times New Roman'',serif;">Kiến thức gi&aacute;o dục đại cương</span></strong></p>
</td>
<td style="width: 1.5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><strong><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">8</span></strong></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">L&yacute; luận Mac-Lenin v&agrave; Tư tưởng HCM</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">5</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">1</span></p>
</td>
<td style="width: 93.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; background: white; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">123</span></p>
</td>
<td style="width: 3.75in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">huunhan</span></p>
</td>
<td style="width: 45.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="60">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">5</span></p>
</td>
<td style="width: 63.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="84">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">3</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Khoa học x&atilde; hội</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">3</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">2</span></p>
</td>
<td style="width: 93.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; background: white; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">NT00D</span></p>
</td>
<td style="width: 3.75in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Business Values</span></p>
</td>
<td style="width: 45.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="60">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">3</span></p>
</td>
<td style="width: 63.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="84">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">4</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Ngoại ngữ </span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 93.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></p>
</td>
<td style="width: 3.75in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Ngoại ngữ cơ bản</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 93.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></p>
</td>
<td style="width: 3.75in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Ngoại ngữ chuy&ecirc;n ng&agrave;nh</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">To&aacute;n - Tin Học - Khoa học Tự nhi&ecirc;n - C&ocirc;ng Nghệ - M&ocirc;i Trường</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Gi&aacute;o dục thể chất</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Gi&aacute;o dục quốc ph&ograve;ng - An ninh</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 400.75pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="3" width="534">
<p><strong><span style="font-family: ''Times New Roman'',serif;">Kiến thức gi&aacute;o dục chuy&ecirc;n nghiệp</span></strong></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><strong><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">5</span></strong></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="50">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></p>
</td>
<td style="width: 363.45pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Kiến thức cơ sở ng&agrave;nh</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Kiến thức ng&agrave;nh</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Thực tập tốt nghiệp v&agrave; l&agrave;m kho&aacute; luận</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">5</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">3</span></p>
</td>
<td style="width: 93.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; background: white; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">tt</span></p>
</td>
<td style="width: 3.75in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">hhhhh</span></p>
</td>
<td style="width: 45.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="60">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">5</span></p>
</td>
<td style="width: 63.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="84">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">8</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif;">Total</span></strong></p>
</td>
<td style="width: 1.5in; border: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p><strong><span style="font-family: ''Times New Roman'',serif;">13</span></strong></p>
</td>
</tr>
</tbody>
</table>', N'<p>&nbsp;</p>
<table style="width: 497.5pt; margin-left: 5.4pt; border-collapse: collapse;" width="663">
<tbody>
<tr style="height: 16.5pt;">
<td style="width: 355.5pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="474">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HỌC KỲ 2 </span></strong></p>
</td>
<td style="width: 142.0pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="4" width="189">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HK 2 2017 - 2018</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="45">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">STT</span></strong></p>
</td>
<td style="width: 48.15pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="64">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">MMH</span></strong></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">T&Ecirc;N M&Ocirc;N HỌC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ</span></strong></p>
</td>
<td style="width: 110.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="147">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ TIẾT</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TS</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">LT</span></strong></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TH/BT</span></strong></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="45">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">1</span></p>
</td>
<td style="width: 48.15pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="64">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">12</span></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="365">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">t&ecirc;n m&ocirc;n học</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">23</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: right;"><span style="font-family: ''Times New Roman'',serif; color: black;">52</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">21</span></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="63">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">31</span></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="64">&nbsp;</td>
<td style="width: 273.85pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">TỔNG SỐ </span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">23</span></strong></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: red;">52</span></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 355.5pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="474">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HỌC KỲ 4 </span></strong></p>
</td>
<td style="width: 142.0pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="4" width="189">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HK 4 2017 - 2018</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="45">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">STT</span></strong></p>
</td>
<td style="width: 48.15pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="64">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">MMH</span></strong></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">T&Ecirc;N M&Ocirc;N HỌC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ</span></strong></p>
</td>
<td style="width: 110.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="147">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ TIẾT</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TS</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">LT</span></strong></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TH/BT</span></strong></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="45">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">1</span></p>
</td>
<td style="width: 48.15pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="64">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">q?qwsqws</span></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="365">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">qứqwsqwsqws</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">9</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: right;"><span style="font-family: ''Times New Roman'',serif; color: black;">8</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">4</span></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="63">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">4</span></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="45">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">2</span></p>
</td>
<td style="width: 48.15pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="64">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">uuuu</span></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="365">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">uuuu</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">4</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: right;"><span style="font-family: ''Times New Roman'',serif; color: black;">9</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">4</span></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="63">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">5</span></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="64">&nbsp;</td>
<td style="width: 273.85pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">TỔNG SỐ </span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">13</span></strong></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: red;">17</span></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 355.5pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="474">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HỌC KỲ 5 </span></strong></p>
</td>
<td style="width: 142.0pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="4" width="189">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HK 5 2017 - 2018</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="45">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">STT</span></strong></p>
</td>
<td style="width: 48.15pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="64">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">MMH</span></strong></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">T&Ecirc;N M&Ocirc;N HỌC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ</span></strong></p>
</td>
<td style="width: 110.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="147">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ TIẾT</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TS</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">LT</span></strong></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TH/BT</span></strong></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="45">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">1</span></p>
</td>
<td style="width: 48.15pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="64">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">ui</span></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="365">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">oooooooooooooo</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">2</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: right;"><span style="font-family: ''Times New Roman'',serif; color: black;">10</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">5</span></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="63">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">5</span></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="45">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">2</span></p>
</td>
<td style="width: 48.15pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="64">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">123</span></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="365">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">teen mon hoc moi</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">3</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: right;"><span style="font-family: ''Times New Roman'',serif; color: black;">66</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">34</span></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="63">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">32</span></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="64">&nbsp;</td>
<td style="width: 273.85pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">TỔNG SỐ </span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">5</span></strong></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: red;">76</span></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="64">&nbsp;</td>
<td style="width: 273.85pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="365">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="64">&nbsp;</td>
<td style="width: 273.85pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="365">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="45">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif; color: black;">Ghi ch&uacute;</span></p>
</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="64">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif; color: black;">(1)</span></p>
</td>
<td style="width: 273.85pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="365">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif; color: black;">Chuy&ecirc;n đề: n&ecirc;n học ngay sau khi kết th&uacute;c học kỳ trước đ&oacute;</span></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="64">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif; color: black;">(2)</span></p>
</td>
<td style="width: 273.85pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="365">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif; color: black;">Capstone project được triển khai từ th&aacute;ng 09</span></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="63">&nbsp;</td>
</tr>
</tbody>
</table>', 0, N'<h1 style="margin-left: .5in; text-align: justify; text-indent: -.25in; tab-stops: list .5in;"><span style="font-size: 13.0pt; font-family: Symbol;"><span style="font: 7.0pt ''Times New Roman'';">&nbsp;&nbsp;&nbsp;&nbsp; </span></span><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">HỌC KỲ 2</span></u></h1>
<ul>
<li style="margin-left: .75in; text-indent: -.25in; tab-stops: list .75in left 5.0in;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">T&ecirc;n m&ocirc;n học: t&ecirc;n m&ocirc;n học &nbsp; &nbsp;(23 TC: 21 LT-31 TH)</span></strong></li>
</ul>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n ti&ecirc;n quyết:</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 1,Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 2,huunhan</span></p>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nội dung</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">: &lt;p&gt;&amp;aacute;dasdasd&lt;/p&gt;</span></p>
<h1 style="margin-left: .5in; text-align: justify; text-indent: -.25in; tab-stops: list .5in;"><span style="font-size: 13.0pt; font-family: Symbol;"><span style="font: 7.0pt ''Times New Roman'';">&nbsp;&nbsp;&nbsp;&nbsp; </span></span><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">HỌC KỲ 4</span></u></h1>
<ul>
<li style="margin-left: .75in; text-indent: -.25in; tab-stops: list .75in left 5.0in;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">T&ecirc;n m&ocirc;n học: qứqwsqwsqws &nbsp; &nbsp;(9 TC: 4 LT-4 TH)</span></strong></li>
</ul>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n ti&ecirc;n quyết:</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 2,Business Values</span></p>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nội dung</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">: qứqws</span></p>
<ul>
<li style="margin-left: .75in; text-indent: -.25in; tab-stops: list .75in left 5.0in;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">T&ecirc;n m&ocirc;n học: uuuu &nbsp; &nbsp;(4 TC: 4 LT-5 TH)</span></strong></li>
</ul>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n ti&ecirc;n quyết:</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Business Values,qứqwsqwsqws</span></p>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nội dung</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">: &lt;p&gt;uu&lt;/p&gt;</span></p>
<h1 style="margin-left: .5in; text-align: justify; text-indent: -.25in; tab-stops: list .5in;"><span style="font-size: 13.0pt; font-family: Symbol;"><span style="font: 7.0pt ''Times New Roman'';">&nbsp;&nbsp;&nbsp;&nbsp; </span></span><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">HỌC KỲ 5</span></u></h1>
<ul>
<li style="margin-left: .75in; text-indent: -.25in; tab-stops: list .75in left 5.0in;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">T&ecirc;n m&ocirc;n học: oooooooooooooo &nbsp; &nbsp;(2 TC: 5 LT-5 TH)</span></strong></li>
</ul>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n ti&ecirc;n quyết:</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 2,Business Values,qứqwsqwsqws</span></p>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nội dung</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">: tyutyuty</span></p>
<ul>
<li style="margin-left: .75in; text-indent: -.25in; tab-stops: list .75in left 5.0in;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">T&ecirc;n m&ocirc;n học: teen mon hoc moi &nbsp; &nbsp;(3 TC: 34 LT-32 TH)</span></strong></li>
</ul>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n ti&ecirc;n quyết:</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 2,huunhan</span></p>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nội dung</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">: &lt;p&gt;day loa mo ta mon hoc&lt;/p&gt;</span></p>', N'<p>&nbsp;</p>
<table style="margin-left: 5.4pt; border-collapse: collapse; border: none;" width="500">
<tbody>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: center;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">STT</span></strong></p>
</td>
<td style="width: 2.0in; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: center;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Họ v&agrave; t&ecirc;n</span></strong></p>
</td>
<td style="width: 40.5pt; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: center;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Năm sinh</span></strong></p>
</td>
<td style="width: 117.0pt; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: center;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Văn bằng cao nhất, ng&agrave;nh đ&agrave;o tạo</span></strong></p>
</td>
<td style="width: 2.0in; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: center;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">C&aacute;c m&ocirc;n sẽ đảm tr&aacute;ch (*)</span></strong></p>
</td>
</tr>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">1</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nguyễn Văn Giảng Vi&ecirc;n</span></strong></p>
</td>
<td style="width: 40.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></strong></p>
</td>
<td style="width: 117.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">ThS</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 1,Business Values,oooooooooooooo,dsf,qqqqq,ttvtv</span></strong></p>
</td>
</tr>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">2</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">nguuyen lecturer3</span></strong></p>
</td>
<td style="width: 40.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></strong></p>
</td>
<td style="width: 117.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Ths</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 1,Business Values,qứqwsqwsqws,qqqqq,hhhhh,yyy</span></strong></p>
</td>
</tr>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">3</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">nguuyen lecturer3</span></strong></p>
</td>
<td style="width: 40.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></strong></p>
</td>
<td style="width: 117.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Ths</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 1,Business Values,qứqwsqwsqws,qqqqq,hhhhh,yyy</span></strong></p>
</td>
</tr>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">4</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">qqqqq</span></strong></p>
</td>
<td style="width: 40.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></strong></p>
</td>
<td style="width: 117.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">qqqqq</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">hhhhh,teen mon hoc moi</span></strong></p>
</td>
</tr>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">5</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">nguuyen lecturer4</span></strong></p>
</td>
<td style="width: 40.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></strong></p>
</td>
<td style="width: 117.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Ths</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">oooooooooooooo,qqqqq,huunhan,uuuu</span></strong></p>
</td>
</tr>
</tbody>
</table>', 3, CAST(0x0000A7A2017A3239 AS DateTime))
INSERT [dbo].[Programs] ([ID], [Name], [TrainingLevel], [BranchName], [EducationType], [TrainingPurpose], [EntranceStudent], [TrainingTimeDetail], [KnowledgeTotal], [GraduateCondition], [PointLadder], [TrainingSupport], [Content], [TrainingPlan], [Status], [ShortContentDescription], [LecturerList], [FacultyID], [CreationTime]) VALUES (6, N'Kỹ Thuật Phần Mềm. (Software Engineering)..', N'Đại học', N'Đại học', N'Chính qui', N'<p>Đ&agrave;o tạo nguồn nh&acirc;n lực ph&aacute;t triển c&ocirc;ng nghệ th&ocirc;ng tin cho x&atilde; hội. Sinh vi&ecirc;n được cung cấp c&aacute;c kiến thức kỹ năng về x&acirc;y dựng v&agrave; ph&aacute;t triển phần mềm:</p>
<p><strong>- Về kiến thức:</strong></p>
<ul>
<li>C&oacute; hiểu biết v&agrave; khả năng vận dụng c&aacute;c kiến thức cơ bản về khoa học tự nhi&ecirc;n, kiến thức về khoa học x&atilde; hội để đ&aacute;p ứng việc tiếp thu c&aacute;c kiến thức gi&aacute;o dục chuy&ecirc;n nghiệp, v&agrave; tiếp tục học tập ở tr&igrave;nh độ cao hơn</li>
<li>C&oacute; c&aacute;c kiến thức cơ sở về c&ocirc;ng nghệ th&ocirc;ng tin như kiến tr&uacute;c m&aacute;y t&iacute;nh, cấu tr&uacute;c dữ liệu v&agrave; giải thuật, lập tr&igrave;nh hướng đối tượng, mạng m&aacute;y t&iacute;nh, an ninh mạng, cơ sở dữ liệu, lập tr&igrave;nh tr&ecirc;n c&aacute;c thiết bị di động. Đặc biệt, c&oacute; hiểu biết s&acirc;u rộng trong ng&agrave;nh kỹ thuật phần mềm</li>
</ul>
<p>- <strong>Về kỹ năng, th&aacute;i độ v&agrave; đạo đức nghề nghiệp:</strong></p>
<ul>
<li>C&oacute; th&aacute;i độ đ&uacute;ng đắn tu&acirc;n thủ luật ph&aacute;p</li>
<li>C&oacute; th&aacute;i độ nghi&ecirc;m t&uacute;c, &yacute; thức l&agrave;m việc v&agrave; t&aacute;c phong chuy&ecirc;n nghiệp</li>
<li>C&oacute; phương ph&aacute;p l&agrave;m việc khoa học, tư tưởng l&agrave;m việc cộng t&aacute;c v&agrave; chia sẻ</li>
<li>C&oacute; kỹ năng l&agrave;m việc nh&oacute;m, kỹ năng giao tiếp, kỹ năng l&atilde;nh đạo cấp trung, c&oacute; tinh thần đạo đức trong kinh doanh v&agrave; quản trị th&ocirc;ng tin, c&oacute; tinh thần cộng đồng</li>
</ul>
<p>&nbsp;</p>
<p><strong>- Về khả năng c&ocirc;ng t&aacute;c:</strong> &nbsp;Sau khi tốt nghiệp, c&aacute;c kỹ sư ng&agrave;nh kỹ thuật phần mềm c&oacute; thể:</p>
<ul>
<li>Giảng dạy c&aacute;c m&ocirc;n li&ecirc;n quan đến c&ocirc;ng nghệ th&ocirc;ng tin tại c&aacute;c trường đại học, cao đẳng, trung học chuy&ecirc;n nghiệp, dạy nghề v&agrave; c&aacute;c trường phổ th&ocirc;ng</li>
<li>Hoặc l&agrave;m việc tại c&aacute;c c&ocirc;ng ty sản xuất, gia c&ocirc;ng phần mềm trong nước cũng như nước ngo&agrave;i trong c&aacute;c vai tr&ograve;:
<ul>
<li>Lập tr&igrave;nh vi&ecirc;n, trưởng nh&oacute;m lập tr&igrave;nh</li>
<li>Ph&acirc;n t&iacute;ch vi&ecirc;n hệ thống</li>
<li>Kỹ sư thiết kế phần mềm</li>
<li>Kỹ sư kiểm thử v&agrave; đảm bảo chất lượng phần mềm</li>
</ul>
</li>
</ul>
<p>C&aacute;n bộ quản l&yacute; dự &aacute;n phần mềm</p>', N'Đại học', N'4 năm (gồm 8 học kỳ)', N'Đại học 4 năm: 71 tín chỉ (TC)', N'Đại học', 10, N'<p>11.1 C&aacute;c ph&ograve;ng th&iacute; nghiệm v&agrave; c&aacute;c hệ thống thiết bị th&iacute; nghiệm quan trọng</p>
<ul>
<li>Trang bị cho c&ocirc;ng t&aacute;c giảng dạy: Hiện nay hầu hết c&aacute;c m&ocirc;n học của Khoa được trang bị máy chi&ecirc;́u v&agrave; m&aacute;y t&iacute;nh để c&aacute;c giảng vi&ecirc;n thực hiện thiết kế b&agrave;i giảng điện tử ph&ugrave; hợp với c&ocirc;ng nghệ v&agrave; ng&agrave;nh nghề của Khoa</li>
<li>Trang bị cho c&ocirc;ng t&aacute;c nghi&ecirc;n cứu: tăng cường hơn nữa về chế độ ưu ti&ecirc;n cho sinh vi&ecirc;n chuy&ecirc;n ng&agrave;nh c&ocirc;ng nghệ th&ocirc;ng tin được v&agrave;o t&igrave;m t&agrave;i liệu internet trong ph&ograve;ng internet của nh&agrave; trường. Đồng thời tiếp x&uacute;c với hệ thống e &ndash; learning (<a href="http://www.hoctructuyen.vanlanguni.edu.vn">hoctructuyen.vanlanguni.edu.vn</a>) hiện c&oacute; của nh&agrave; trường</li>
<li>Trang bị ph&ograve;ng th&iacute; nghiệm chuy&ecirc;n ng&agrave;nh Khoa nhằm phục vụ cho việc nghi&ecirc;n cứu của giảng vi&ecirc;n cơ hữu v&agrave; c&aacute;c m&ocirc;n học đ&ograve;i hỏi c&ocirc;ng nghệ cao trong chương tr&igrave;nh đ&agrave;o tạo của Khoa</li>
<li>Trang bị ph&ograve;ng Lab gồm 24 - 60 m&aacute;y tính &ndash; c&oacute; chức năng chạy c&aacute;c chương tr&igrave;nh Multimedia,cũng như v&agrave;o Internet gi&uacute;p c&aacute;c em sinh vi&ecirc;n c&oacute; thể học c&aacute;c b&agrave;i giảng của c&aacute;c gi&aacute;o sư của Đại học Carnegie Mellon</li>
<li>Hiện nay nh&agrave; trường c&oacute; tất cả 14 ph&ograve;ng m&aacute;y với hơn 600 m&aacute;y d&agrave;nh cho SV thực h&agrave;nh trong đ&oacute; c&oacute; cấu h&igrave;nh 65 m&aacute;y core 2 Duo d&agrave;nh cho SV thực h&agrave;nh c&aacute;c b&agrave;i to&aacute;n m&ocirc; phỏng ,thời gian thật &hellip;.</li>
</ul>
<p>&nbsp;</p>
<p>11.2 Thư viện</p>
<p>Thư viện trường gồm 2 cơ sở: một phục vụ cho khối ng&agrave;nh Kinh tế-Quản trị kinh doanh v&agrave; một phục vụ cho nh&oacute;m ng&agrave;nh Kỹ thuật-c&ocirc;ng nghệ-khoa học x&atilde; hội. Hiện nay thự viện với tổng số s&aacute;ch hơn 20.000 cuốn ( hơn 1000 đầu s&aacute;ch cho C&ocirc;ng nghệ Th&ocirc;ng Tin ) đ&atilde; đ&aacute;p ứng được nhu cầu về gi&aacute;o tr&igrave;nh học tập cũng như s&aacute;ch tham khảo trong qu&aacute; tr&igrave;nh học tập v&agrave; giảng dạy.</p>
<p>11.3 Gi&aacute;o tr&igrave;nh, tập b&agrave;i giảng:</p>
<p>Gi&aacute;o tr&igrave;nh ,tập b&agrave;i giảng hằng năm được cập nhật theo chương tr&igrave;nh giảng dạy của Đại học Carnegie Mellon .K&egrave;m theo s&aacute;ch l&agrave; c&aacute;c b&agrave;i giảng video của c&aacute;c giảng vi&ecirc;n CMU</p>
<p>&nbsp;</p>
<p>Gi&aacute;o tr&igrave;nh năm thứ 1:</p>
<table>
<tbody>
<tr>
<td width="97">
<p><strong>Số thứ tự</strong></p>
</td>
<td width="176">
<p><strong>T&ecirc;n s&aacute;ch</strong></p>
</td>
<td width="130">
<p><strong>T&aacute;c gỉa</strong></p>
</td>
<td width="84">
<p><strong>Nh&agrave; XB</strong></p>
</td>
<td width="103">
<p><strong>Lần tb/năm t&aacute;i bản</strong></p>
</td>
</tr>
<tr>
<td width="97">
<p>1</p>
</td>
<td width="176">
<p>Caculus Early Transcendentals</p>
</td>
<td width="130">
<p>James Stewart</p>
</td>
<td width="84">
<p>Brooks Cole</p>
</td>
<td width="103">
<p>6 th</p>
</td>
</tr>
<tr>
<td width="97">
<p>2</p>
</td>
<td width="176">
<p>Computer networks and Internet</p>
</td>
<td width="130">
<p>Douglas .E.Comer</p>
</td>
<td width="84">
<p>Pearson (Prentice Hall)</p>
</td>
<td width="103">
<p>2009</p>
</td>
</tr>
<tr>
<td width="97">
<p>3</p>
</td>
<td width="176">
<p>Objects,Abstraction,Data Structures and Design using Java version 5.0</p>
</td>
<td width="130">
<p>- Elliot B. Koffman</p>
<p>- Paul A.T. Wolfgang</p>
</td>
<td width="84">
<p>John Wiley</p>
</td>
<td width="103">
<p>2 nd ; 2005</p>
</td>
</tr>
<tr>
<td width="97">
<p>4</p>
</td>
<td width="176">
<p>Java 6 Illuminated .an Active Learning Approach</p>
</td>
<td width="130">
<p>- Julie Anderson</p>
<p>- Herve Franceschi</p>
</td>
<td width="84">
<p>Jones &amp; Bartlett</p>
</td>
<td width="103">
<p>2008</p>
</td>
</tr>
<tr>
<td width="97">
<p>&nbsp;</p>
</td>
<td width="176">
<p>&nbsp;</p>
</td>
<td width="130">
<p>&nbsp;</p>
</td>
<td width="84">
<p>&nbsp;</p>
</td>
<td width="103">
<p>&nbsp;</p>
</td>
</tr>
</tbody>
</table>', N'<p><br /> <br /> </p>
<table style="width: 508.75pt; margin-left: 5.15pt; border-collapse: collapse;" width="678">
<tbody>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">
<p><strong><span style="font-size: 14.0pt; font-family: ''Times New Roman'',serif;">STT</span></strong></p>
</td>
<td style="width: 93.45pt; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><strong><span style="font-size: 14.0pt; font-family: ''Times New Roman'',serif;">M&atilde; MH</span></strong></p>
</td>
<td style="width: 3.75in; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><strong><span style="font-size: 14.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n học</span></strong></p>
</td>
<td style="width: 45.0pt; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="60">
<p><strong><span style="font-size: 14.0pt; font-family: ''Times New Roman'',serif;">TC</span></strong></p>
</td>
<td style="width: 63.0pt; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="84">
<p><strong><span style="font-size: 14.0pt; font-family: ''Times New Roman'',serif;">Học kỳ</span></strong></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 400.75pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="3" width="534">
<p><strong><span style="font-family: ''Times New Roman'',serif;">Kiến thức gi&aacute;o dục đại cương</span></strong></p>
</td>
<td style="width: 1.5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><strong><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">3</span></strong></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">L&yacute; luận Mac-Lenin v&agrave; Tư tưởng HCM</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">3</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">1</span></p>
</td>
<td style="width: 93.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; background: white; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">PL101</span></p>
</td>
<td style="width: 3.75in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 1</span></p>
</td>
<td style="width: 45.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="60">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">2</span></p>
</td>
<td style="width: 63.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="84">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">1</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">2</span></p>
</td>
<td style="width: 93.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; background: white; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">PL102</span></p>
</td>
<td style="width: 3.75in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 2</span></p>
</td>
<td style="width: 45.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="60">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">1</span></p>
</td>
<td style="width: 63.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="84">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">1</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Khoa học x&atilde; hội</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Ngoại ngữ </span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 93.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></p>
</td>
<td style="width: 3.75in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Ngoại ngữ cơ bản</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 93.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></p>
</td>
<td style="width: 3.75in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Ngoại ngữ chuy&ecirc;n ng&agrave;nh</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">To&aacute;n - Tin Học - Khoa học Tự nhi&ecirc;n - C&ocirc;ng Nghệ - M&ocirc;i Trường</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Gi&aacute;o dục thể chất</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Gi&aacute;o dục quốc ph&ograve;ng - An ninh</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 400.75pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="3" width="534">
<p><strong><span style="font-family: ''Times New Roman'',serif;">Kiến thức gi&aacute;o dục chuy&ecirc;n nghiệp</span></strong></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><strong><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">68</span></strong></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="50">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></p>
</td>
<td style="width: 363.45pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Kiến thức cơ sở ng&agrave;nh</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Kiến thức ng&agrave;nh</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">68</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">3</span></p>
</td>
<td style="width: 93.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; background: white; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">as</span></p>
</td>
<td style="width: 3.75in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">hello0</span></p>
</td>
<td style="width: 45.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="60">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">65</span></p>
</td>
<td style="width: 63.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="84">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">2</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">4</span></p>
</td>
<td style="width: 93.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; background: white; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">123</span></p>
</td>
<td style="width: 3.75in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">teen mon hoc moi</span></p>
</td>
<td style="width: 45.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="60">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">3</span></p>
</td>
<td style="width: 63.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="84">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">5</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Thực tập tốt nghiệp v&agrave; l&agrave;m kho&aacute; luận</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif;">Total</span></strong></p>
</td>
<td style="width: 1.5in; border: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p><strong><span style="font-family: ''Times New Roman'',serif;">71</span></strong></p>
</td>
</tr>
</tbody>
</table>', N'<p><br /> <br /> </p>
<table style="width: 497.5pt; margin-left: 5.4pt; border-collapse: collapse;" width="663">
<tbody>
<tr style="height: 16.5pt;">
<td style="width: 355.5pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="474">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HỌC KỲ 2 </span></strong></p>
</td>
<td style="width: 142.0pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="4" width="189">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HK 2 2017 - 2018</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="45">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">STT</span></strong></p>
</td>
<td style="width: 48.15pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="64">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">MMH</span></strong></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">T&Ecirc;N M&Ocirc;N HỌC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ</span></strong></p>
</td>
<td style="width: 110.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="147">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ TIẾT</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TS</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">LT</span></strong></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TH/BT</span></strong></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="45">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">1</span></p>
</td>
<td style="width: 48.15pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="64">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">12</span></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="365">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">t&ecirc;n m&ocirc;n học</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">23</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: right;"><span style="font-family: ''Times New Roman'',serif; color: black;">52</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">21</span></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="63">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">31</span></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="45">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">2</span></p>
</td>
<td style="width: 48.15pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="64">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">12</span></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="365">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">t&ecirc;n m&ocirc;n học</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">23</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: right;"><span style="font-family: ''Times New Roman'',serif; color: black;">52</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">21</span></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="63">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">31</span></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="64">&nbsp;</td>
<td style="width: 273.85pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">TỔNG SỐ </span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">46</span></strong></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: red;">104</span></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 355.5pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="474">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HỌC KỲ 4 </span></strong></p>
</td>
<td style="width: 142.0pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="4" width="189">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HK 4 2017 - 2018</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="45">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">STT</span></strong></p>
</td>
<td style="width: 48.15pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="64">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">MMH</span></strong></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">T&Ecirc;N M&Ocirc;N HỌC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ</span></strong></p>
</td>
<td style="width: 110.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="147">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ TIẾT</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TS</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">LT</span></strong></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TH/BT</span></strong></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="45">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">1</span></p>
</td>
<td style="width: 48.15pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="64">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">q?qwsqws</span></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="365">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">qứqwsqwsqws</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">9</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: right;"><span style="font-family: ''Times New Roman'',serif; color: black;">8</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">4</span></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="63">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">4</span></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="64">&nbsp;</td>
<td style="width: 273.85pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">TỔNG SỐ </span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">9</span></strong></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: red;">8</span></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 355.5pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="474">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HỌC KỲ 5 </span></strong></p>
</td>
<td style="width: 142.0pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="4" width="189">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HK 5 2017 - 2018</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="45">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">STT</span></strong></p>
</td>
<td style="width: 48.15pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="64">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">MMH</span></strong></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">T&Ecirc;N M&Ocirc;N HỌC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ</span></strong></p>
</td>
<td style="width: 110.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="147">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ TIẾT</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TS</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">LT</span></strong></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TH/BT</span></strong></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="45">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">1</span></p>
</td>
<td style="width: 48.15pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="64">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">ui</span></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="365">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">oooooooooooooo</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">2</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: right;"><span style="font-family: ''Times New Roman'',serif; color: black;">10</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">5</span></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="63">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">5</span></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="45">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">2</span></p>
</td>
<td style="width: 48.15pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="64">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">queqwe</span></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="365">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">qưeqwe</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">5</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: right;"><span style="font-family: ''Times New Roman'',serif; color: black;">9</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">5</span></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="63">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">4</span></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="45">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">3</span></p>
</td>
<td style="width: 48.15pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="64">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">123</span></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="365">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">teen mon hoc moi</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">3</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: right;"><span style="font-family: ''Times New Roman'',serif; color: black;">66</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">34</span></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="63">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">32</span></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="64">&nbsp;</td>
<td style="width: 273.85pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">TỔNG SỐ </span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">10</span></strong></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: red;">85</span></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 355.5pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="474">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HỌC KỲ 7 </span></strong></p>
</td>
<td style="width: 142.0pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="4" width="189">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HK 7 2018 - 2019</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="45">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">STT</span></strong></p>
</td>
<td style="width: 48.15pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="64">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">MMH</span></strong></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">T&Ecirc;N M&Ocirc;N HỌC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ</span></strong></p>
</td>
<td style="width: 110.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="147">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ TIẾT</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TS</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">LT</span></strong></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TH/BT</span></strong></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="45">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">1</span></p>
</td>
<td style="width: 48.15pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="64">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">gg</span></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="365">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">M&ocirc;n học mới</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">25</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: right;"><span style="font-family: ''Times New Roman'',serif; color: black;">50</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">25</span></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="63">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">25</span></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="45">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">2</span></p>
</td>
<td style="width: 48.15pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="64">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">gg</span></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="365">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">M&ocirc;n học mới</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">25</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: right;"><span style="font-family: ''Times New Roman'',serif; color: black;">50</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">25</span></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="63">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">25</span></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="64">&nbsp;</td>
<td style="width: 273.85pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">TỔNG SỐ </span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">50</span></strong></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: red;">100</span></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 355.5pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="474">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HỌC KỲ 8 </span></strong></p>
</td>
<td style="width: 142.0pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="4" width="189">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HK 8 2019 - 2020</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="45">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">STT</span></strong></p>
</td>
<td style="width: 48.15pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="64">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">MMH</span></strong></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">T&Ecirc;N M&Ocirc;N HỌC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ</span></strong></p>
</td>
<td style="width: 110.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="147">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ TIẾT</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TS</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">LT</span></strong></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TH/BT</span></strong></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="45">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">1</span></p>
</td>
<td style="width: 48.15pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="64">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">tt</span></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="365">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">hhhhh</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">5</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: right;"><span style="font-family: ''Times New Roman'',serif; color: black;">10</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">5</span></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="63">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">5</span></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="64">&nbsp;</td>
<td style="width: 273.85pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">TỔNG SỐ </span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">5</span></strong></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: red;">10</span></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="64">&nbsp;</td>
<td style="width: 273.85pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="365">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="64">&nbsp;</td>
<td style="width: 273.85pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="365">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="45">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif; color: black;">Ghi ch&uacute;</span></p>
</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="64">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif; color: black;">(1)</span></p>
</td>
<td style="width: 273.85pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="365">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif; color: black;">Chuy&ecirc;n đề: n&ecirc;n học ngay sau khi kết th&uacute;c học kỳ trước đ&oacute;</span></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="64">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif; color: black;">(2)</span></p>
</td>
<td style="width: 273.85pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="365">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif; color: black;">Capstone project được triển khai từ th&aacute;ng 09</span></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="63">&nbsp;</td>
</tr>
</tbody>
</table>', 0, N'<h1 style="margin-left: .5in; text-align: justify; text-indent: -.25in; tab-stops: list .5in;"><span style="font-size: 13.0pt; font-family: Symbol;"><span style="font: 7.0pt ''Times New Roman'';">&nbsp;&nbsp;&nbsp;&nbsp; </span></span><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">HỌC KỲ 2</span></u></h1>
<ul>
<li style="margin-left: .75in; text-indent: -.25in; tab-stops: list .75in left 5.0in;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">T&ecirc;n m&ocirc;n học: t&ecirc;n m&ocirc;n học &nbsp; &nbsp;(23 TC: 21 LT-31 TH)</span></strong></li>
</ul>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n ti&ecirc;n quyết:</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 1,Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 2,huunhan</span></p>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nội dung</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">: &lt;p&gt;&amp;aacute;dasdasd&lt;/p&gt;</span></p>
<ul>
<li style="margin-left: .75in; text-indent: -.25in; tab-stops: list .75in left 5.0in;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">T&ecirc;n m&ocirc;n học: t&ecirc;n m&ocirc;n học &nbsp; &nbsp;(23 TC: 21 LT-31 TH)</span></strong></li>
</ul>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n ti&ecirc;n quyết:</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 1,Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 2,huunhan</span></p>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nội dung</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">: &lt;p&gt;&amp;aacute;dasdasd&lt;/p&gt;</span></p>
<h1 style="margin-left: .5in; text-align: justify; text-indent: -.25in; tab-stops: list .5in;"><span style="font-size: 13.0pt; font-family: Symbol;"><span style="font: 7.0pt ''Times New Roman'';">&nbsp;&nbsp;&nbsp;&nbsp; </span></span><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">HỌC KỲ 4</span></u></h1>
<ul>
<li style="margin-left: .75in; text-indent: -.25in; tab-stops: list .75in left 5.0in;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">T&ecirc;n m&ocirc;n học: qứqwsqwsqws &nbsp; &nbsp;(9 TC: 4 LT-4 TH)</span></strong></li>
</ul>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n ti&ecirc;n quyết:</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 2,Business Values</span></p>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nội dung</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">: qứqws</span></p>
<h1 style="margin-left: .5in; text-align: justify; text-indent: -.25in; tab-stops: list .5in;"><span style="font-size: 13.0pt; font-family: Symbol;"><span style="font: 7.0pt ''Times New Roman'';">&nbsp;&nbsp;&nbsp;&nbsp; </span></span><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">HỌC KỲ 5</span></u></h1>
<ul>
<li style="margin-left: .75in; text-indent: -.25in; tab-stops: list .75in left 5.0in;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">T&ecirc;n m&ocirc;n học: oooooooooooooo &nbsp; &nbsp;(2 TC: 5 LT-5 TH)</span></strong></li>
</ul>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n ti&ecirc;n quyết:</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 2,Business Values,qứqwsqwsqws</span></p>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nội dung</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">: tyutyuty</span></p>
<ul>
<li style="margin-left: .75in; text-indent: -.25in; tab-stops: list .75in left 5.0in;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">T&ecirc;n m&ocirc;n học: qưeqwe &nbsp; &nbsp;(5 TC: 5 LT-4 TH)</span></strong></li>
</ul>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n ti&ecirc;n quyết:</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 2</span></p>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nội dung</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">: &lt;p&gt;qưeqw&lt;/p&gt;</span></p>
<ul>
<li style="margin-left: .75in; text-indent: -.25in; tab-stops: list .75in left 5.0in;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">T&ecirc;n m&ocirc;n học: teen mon hoc moi &nbsp; &nbsp;(3 TC: 34 LT-32 TH)</span></strong></li>
</ul>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n ti&ecirc;n quyết:</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 2,huunhan</span></p>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nội dung</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">: &lt;p&gt;day loa mo ta mon hoc&lt;/p&gt;</span></p>
<h1 style="margin-left: .5in; text-align: justify; text-indent: -.25in; tab-stops: list .5in;"><span style="font-size: 13.0pt; font-family: Symbol;"><span style="font: 7.0pt ''Times New Roman'';">&nbsp;&nbsp;&nbsp;&nbsp; </span></span><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">HỌC KỲ 7</span></u></h1>
<ul>
<li style="margin-left: .75in; text-indent: -.25in; tab-stops: list .75in left 5.0in;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">T&ecirc;n m&ocirc;n học: M&ocirc;n học mới &nbsp; &nbsp;(25 TC: 25 LT-25 TH)</span></strong></li>
</ul>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n ti&ecirc;n quyết:</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 1,Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 2</span></p>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nội dung</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">: &aacute;dasdasdasd</span></p>
<ul>
<li style="margin-left: .75in; text-indent: -.25in; tab-stops: list .75in left 5.0in;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">T&ecirc;n m&ocirc;n học: M&ocirc;n học mới &nbsp; &nbsp;(25 TC: 25 LT-25 TH)</span></strong></li>
</ul>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n ti&ecirc;n quyết:</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 1,Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 2</span></p>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nội dung</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">: &aacute;dasdasdasd</span></p>
<h1 style="margin-left: .5in; text-align: justify; text-indent: -.25in; tab-stops: list .5in;"><span style="font-size: 13.0pt; font-family: Symbol;"><span style="font: 7.0pt ''Times New Roman'';">&nbsp;&nbsp;&nbsp;&nbsp; </span></span><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">HỌC KỲ 8</span></u></h1>
<ul>
<li style="margin-left: .75in; text-indent: -.25in; tab-stops: list .75in left 5.0in;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">T&ecirc;n m&ocirc;n học: hhhhh &nbsp; &nbsp;(5 TC: 5 LT-5 TH)</span></strong></li>
</ul>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n ti&ecirc;n quyết:</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 2,oooooooooooooo,qqqqq</span></p>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nội dung</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">: rthrtgrt</span></p>', N'<p>&nbsp;</p>
<table style="margin-left: 5.4pt; border-collapse: collapse; border: none;" width="500">
<tbody>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: center;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">STT</span></strong></p>
</td>
<td style="width: 2.0in; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: center;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Họ v&agrave; t&ecirc;n</span></strong></p>
</td>
<td style="width: 40.5pt; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: center;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Năm sinh</span></strong></p>
</td>
<td style="width: 117.0pt; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: center;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Văn bằng cao nhất, ng&agrave;nh đ&agrave;o tạo</span></strong></p>
</td>
<td style="width: 2.0in; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: center;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">C&aacute;c m&ocirc;n sẽ đảm tr&aacute;ch (*)</span></strong></p>
</td>
</tr>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">1</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nguyễn Văn Giảng Vi&ecirc;n</span></strong></p>
</td>
<td style="width: 40.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></strong></p>
</td>
<td style="width: 117.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">ThS</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 1,Business Values,oooooooooooooo,dsf,qqqqq,csdcsdcsdcsdc</span></strong></p>
</td>
</tr>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">2</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">nguuyen lecturer3</span></strong></p>
</td>
<td style="width: 40.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></strong></p>
</td>
<td style="width: 117.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Ths</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 1,Business Values,qứqwsqwsqws,qqqqq,hhhhh,yyy</span></strong></p>
</td>
</tr>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">3</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nguyễn Lecturer2</span></strong></p>
</td>
<td style="width: 40.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></strong></p>
</td>
<td style="width: 117.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Ths</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 2,qqqqq,ttvtv</span></strong></p>
</td>
</tr>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">4</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">ngo huu nhan</span></strong></p>
</td>
<td style="width: 40.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></strong></p>
</td>
<td style="width: 117.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Ths</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">t&ecirc;n m&ocirc;n học,teen mon hoc moi,M&ocirc;n học mới</span></strong></p>
</td>
</tr>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">5</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">qqqqq</span></strong></p>
</td>
<td style="width: 40.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></strong></p>
</td>
<td style="width: 117.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">qqqqq</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">hhhhh,teen mon hoc moi</span></strong></p>
</td>
</tr>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">6</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">nguuyen lecturer4</span></strong></p>
</td>
<td style="width: 40.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></strong></p>
</td>
<td style="width: 117.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Ths</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">oooooooooooooo,qqqqq,huunhan,uuuu,hello0</span></strong></p>
</td>
</tr>
</tbody>
</table>', 1, CAST(0x0000A7A70132DEE0 AS DateTime))
INSERT [dbo].[Programs] ([ID], [Name], [TrainingLevel], [BranchName], [EducationType], [TrainingPurpose], [EntranceStudent], [TrainingTimeDetail], [KnowledgeTotal], [GraduateCondition], [PointLadder], [TrainingSupport], [Content], [TrainingPlan], [Status], [ShortContentDescription], [LecturerList], [FacultyID], [CreationTime]) VALUES (7, N'Kiến xây (Architech)', N'abc', N'kieesn truc', N'dai hoc', N'<ul>
<li>abcx</li>
<li>kasd</li>
<li>kjasdhjkasd</li>
<li>lkasjdlkasd</li>
<li>asdas</li>
</ul>', N'qxqwx', N'5 năm (gồm 10 học kỳ)', N'Đại học 5 năm: 35 tín chỉ (TC)', N'qwxqwx', 10, N'<p>abc</p>', N'<p><br /> <br /> </p>
<table style="width: 508.75pt; margin-left: 5.15pt; border-collapse: collapse;" width="678">
<tbody>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">
<p><strong><span style="font-size: 14.0pt; font-family: ''Times New Roman'',serif;">STT</span></strong></p>
</td>
<td style="width: 93.45pt; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><strong><span style="font-size: 14.0pt; font-family: ''Times New Roman'',serif;">M&atilde; MH</span></strong></p>
</td>
<td style="width: 3.75in; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><strong><span style="font-size: 14.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n học</span></strong></p>
</td>
<td style="width: 45.0pt; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="60">
<p><strong><span style="font-size: 14.0pt; font-family: ''Times New Roman'',serif;">TC</span></strong></p>
</td>
<td style="width: 63.0pt; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="84">
<p><strong><span style="font-size: 14.0pt; font-family: ''Times New Roman'',serif;">Học kỳ</span></strong></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 400.75pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="3" width="534">
<p><strong><span style="font-family: ''Times New Roman'',serif;">Kiến thức gi&aacute;o dục đại cương</span></strong></p>
</td>
<td style="width: 1.5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><strong><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">23</span></strong></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">L&yacute; luận Mac-Lenin v&agrave; Tư tưởng HCM</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">16</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">1</span></p>
</td>
<td style="width: 93.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; background: white; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">123</span></p>
</td>
<td style="width: 3.75in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">thai 123</span></p>
</td>
<td style="width: 45.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="60">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">4</span></p>
</td>
<td style="width: 63.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="84">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">3</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">2</span></p>
</td>
<td style="width: 93.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; background: white; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">gg</span></p>
</td>
<td style="width: 3.75in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">mon hoc moi</span></p>
</td>
<td style="width: 45.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="60">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">12</span></p>
</td>
<td style="width: 63.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="84">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">3</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Khoa học x&atilde; hội</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">2</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">3</span></p>
</td>
<td style="width: 93.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; background: white; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">ui</span></p>
</td>
<td style="width: 3.75in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">oooooooooooooo</span></p>
</td>
<td style="width: 45.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="60">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">2</span></p>
</td>
<td style="width: 63.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="84">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">5</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Ngoại ngữ </span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 93.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></p>
</td>
<td style="width: 3.75in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Ngoại ngữ cơ bản</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 93.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></p>
</td>
<td style="width: 3.75in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Ngoại ngữ chuy&ecirc;n ng&agrave;nh</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">To&aacute;n - Tin Học - Khoa học Tự nhi&ecirc;n - C&ocirc;ng Nghệ - M&ocirc;i Trường</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">5</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">4</span></p>
</td>
<td style="width: 93.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; background: white; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">rrr</span></p>
</td>
<td style="width: 3.75in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">qqqqq</span></p>
</td>
<td style="width: 45.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="60">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">5</span></p>
</td>
<td style="width: 63.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="84">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">6</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Gi&aacute;o dục thể chất</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Gi&aacute;o dục quốc ph&ograve;ng - An ninh</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 400.75pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="3" width="534">
<p><strong><span style="font-family: ''Times New Roman'',serif;">Kiến thức gi&aacute;o dục chuy&ecirc;n nghiệp</span></strong></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><strong><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">12</span></strong></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="50">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></p>
</td>
<td style="width: 363.45pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Kiến thức cơ sở ng&agrave;nh</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">12</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">5</span></p>
</td>
<td style="width: 93.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; background: white; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="125">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">qq</span></p>
</td>
<td style="width: 3.75in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="360">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">day la mon hoc vua tao</span></p>
</td>
<td style="width: 45.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="60">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">12</span></p>
</td>
<td style="width: 63.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="84">
<p style="text-align: right;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">1</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Kiến thức ng&agrave;nh</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">Thực tập tốt nghiệp v&agrave; l&agrave;m kho&aacute; luận</span></p>
</td>
<td style="width: 1.5in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p style="text-align: center;"><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif;">0</span></p>
</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 37.3pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="50">&nbsp;</td>
<td style="width: 363.45pt; border: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="485">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif;">Total</span></strong></p>
</td>
<td style="width: 1.5in; border: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" colspan="2" width="144">
<p><strong><span style="font-family: ''Times New Roman'',serif;">35</span></strong></p>
</td>
</tr>
</tbody>
</table>', N'<p><br /> <br /> </p>
<table style="width: 497.5pt; margin-left: 5.4pt; border-collapse: collapse;" width="663">
<tbody>
<tr style="height: 16.5pt;">
<td style="width: 355.5pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="474">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HỌC KỲ 1 </span></strong></p>
</td>
<td style="width: 142.0pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="4" width="189">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HK 1 2017 - 2018</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="45">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">STT</span></strong></p>
</td>
<td style="width: 48.15pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="64">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">MMH</span></strong></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">T&Ecirc;N M&Ocirc;N HỌC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ</span></strong></p>
</td>
<td style="width: 110.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="147">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ TIẾT</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TS</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">LT</span></strong></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TH/BT</span></strong></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="45">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">1</span></p>
</td>
<td style="width: 48.15pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="64">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">qq</span></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="365">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">day la mon hoc vua tao</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">12</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: right;"><span style="font-family: ''Times New Roman'',serif; color: black;">24</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">12</span></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="63">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">12</span></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="64">&nbsp;</td>
<td style="width: 273.85pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">TỔNG SỐ </span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">12</span></strong></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: red;">24</span></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 355.5pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="474">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HỌC KỲ 3 </span></strong></p>
</td>
<td style="width: 142.0pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="4" width="189">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HK 3 2018 - 2019</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="45">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">STT</span></strong></p>
</td>
<td style="width: 48.15pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="64">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">MMH</span></strong></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">T&Ecirc;N M&Ocirc;N HỌC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ</span></strong></p>
</td>
<td style="width: 110.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="147">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ TIẾT</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TS</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">LT</span></strong></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TH/BT</span></strong></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="45">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">1</span></p>
</td>
<td style="width: 48.15pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="64">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">123</span></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="365">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">thai 123</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">4</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: right;"><span style="font-family: ''Times New Roman'',serif; color: black;">90</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">45</span></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="63">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">45</span></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="45">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">2</span></p>
</td>
<td style="width: 48.15pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="64">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">gg</span></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="365">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">mon hoc moi</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">12</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: right;"><span style="font-family: ''Times New Roman'',serif; color: black;">24</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">12</span></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="63">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">12</span></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="64">&nbsp;</td>
<td style="width: 273.85pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">TỔNG SỐ </span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">16</span></strong></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: red;">114</span></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 355.5pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="474">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HỌC KỲ 5 </span></strong></p>
</td>
<td style="width: 142.0pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="4" width="189">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HK 5 2019 - 2020</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="45">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">STT</span></strong></p>
</td>
<td style="width: 48.15pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="64">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">MMH</span></strong></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">T&Ecirc;N M&Ocirc;N HỌC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ</span></strong></p>
</td>
<td style="width: 110.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="147">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ TIẾT</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TS</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">LT</span></strong></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TH/BT</span></strong></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="45">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">1</span></p>
</td>
<td style="width: 48.15pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="64">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">ui</span></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="365">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">oooooooooooooo</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">2</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: right;"><span style="font-family: ''Times New Roman'',serif; color: black;">10</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">5</span></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="63">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">5</span></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="64">&nbsp;</td>
<td style="width: 273.85pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">TỔNG SỐ </span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">2</span></strong></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: red;">10</span></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 355.5pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="474">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HỌC KỲ 6 </span></strong></p>
</td>
<td style="width: 142.0pt; border: none; border-bottom: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="4" width="189">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">HK 6 2020 - 2021</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="45">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">STT</span></strong></p>
</td>
<td style="width: 48.15pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="64">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">MMH</span></strong></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid black 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" rowspan="2" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">T&Ecirc;N M&Ocirc;N HỌC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ</span></strong></p>
</td>
<td style="width: 110.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid black 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" colspan="3" width="147">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">SỐ TIẾT</span></strong></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TC</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TS</span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">LT</span></strong></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: blue;">TH/BT</span></strong></p>
</td>
</tr>
<tr style="height: 15.75pt;">
<td style="width: 33.5pt; border-top: none; border-left: solid windowtext 1.0pt; border-bottom: solid windowtext 1.0pt; border-right: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="45">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">1</span></p>
</td>
<td style="width: 48.15pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="64">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">rrr</span></p>
</td>
<td style="width: 273.85pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="365">
<p><span style="font-family: ''Times New Roman'',serif; color: black;">qqqqq</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">5</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: right;"><span style="font-family: ''Times New Roman'',serif; color: black;">9</span></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">5</span></p>
</td>
<td style="width: 47.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.75pt;" width="63">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: black;">4</span></p>
</td>
</tr>
<tr style="height: 16.5pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="64">&nbsp;</td>
<td style="width: 273.85pt; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="365">
<p><strong><span style="font-family: ''Times New Roman'',serif; color: black;">TỔNG SỐ </span></strong></p>
</td>
<td style="width: 31.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><strong><span style="font-family: ''Times New Roman'',serif; color: black;">5</span></strong></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">
<p style="text-align: center;"><span style="font-family: ''Times New Roman'',serif; color: red;">9</span></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 16.5pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="64">&nbsp;</td>
<td style="width: 273.85pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="365">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="64">&nbsp;</td>
<td style="width: 273.85pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="365">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="45">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif; color: black;">Ghi ch&uacute;</span></p>
</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="64">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif; color: black;">(1)</span></p>
</td>
<td style="width: 273.85pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="365">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif; color: black;">Chuy&ecirc;n đề: n&ecirc;n học ngay sau khi kết th&uacute;c học kỳ trước đ&oacute;</span></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="63">&nbsp;</td>
</tr>
<tr style="height: 15.0pt;">
<td style="width: 33.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="45">&nbsp;</td>
<td style="width: 48.15pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="64">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif; color: black;">(2)</span></p>
</td>
<td style="width: 273.85pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="365">
<p><span style="font-size: 11.0pt; font-family: ''Times New Roman'',serif; color: black;">Capstone project được triển khai từ th&aacute;ng 09</span></p>
</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 31.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="42">&nbsp;</td>
<td style="width: 47.5pt; padding: 0in 5.4pt 0in 5.4pt; height: 15.0pt;" width="63">&nbsp;</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>', 0, N'<h1 style="margin-left: .5in; text-align: justify; text-indent: -.25in; tab-stops: list .5in;"><span style="font-size: 13.0pt; font-family: Symbol;"><span style="font: 7.0pt ''Times New Roman'';">&nbsp;&nbsp;&nbsp;&nbsp; </span></span><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">HỌC KỲ 1</span></u></h1>
<ul>
<li style="margin-left: .75in; text-indent: -.25in; tab-stops: list .75in left 5.0in;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">T&ecirc;n m&ocirc;n học: day la mon hoc vua tao &nbsp; &nbsp;(12 TC: 12 LT-12 TH)</span></strong></li>
</ul>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n ti&ecirc;n quyết:</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">oooooooooooooo</span></p>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nội dung</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">: ac</span></p>
<h1 style="margin-left: .5in; text-align: justify; text-indent: -.25in; tab-stops: list .5in;"><span style="font-size: 13.0pt; font-family: Symbol;"><span style="font: 7.0pt ''Times New Roman'';">&nbsp;&nbsp;&nbsp;&nbsp; </span></span><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">HỌC KỲ 3</span></u></h1>
<ul>
<li style="margin-left: .75in; text-indent: -.25in; tab-stops: list .75in left 5.0in;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">T&ecirc;n m&ocirc;n học: thai 123 &nbsp; &nbsp;(4 TC: 45 LT-45 TH)</span></strong></li>
</ul>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n ti&ecirc;n quyết:</span></u></strong></p>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nội dung</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">: abc</span></p>
<ul>
<li style="margin-left: .75in; text-indent: -.25in; tab-stops: list .75in left 5.0in;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">T&ecirc;n m&ocirc;n học: mon hoc moi &nbsp; &nbsp;(12 TC: 12 LT-12 TH)</span></strong></li>
</ul>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n ti&ecirc;n quyết:</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 1,Business Values</span></p>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nội dung</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">: qwe</span></p>
<h1 style="margin-left: .5in; text-align: justify; text-indent: -.25in; tab-stops: list .5in;"><span style="font-size: 13.0pt; font-family: Symbol;"><span style="font: 7.0pt ''Times New Roman'';">&nbsp;&nbsp;&nbsp;&nbsp; </span></span><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">HỌC KỲ 5</span></u></h1>
<ul>
<li style="margin-left: .75in; text-indent: -.25in; tab-stops: list .75in left 5.0in;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">T&ecirc;n m&ocirc;n học: oooooooooooooo &nbsp; &nbsp;(2 TC: 5 LT-5 TH)</span></strong></li>
</ul>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n ti&ecirc;n quyết:</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 2,Business Values,qứqwsqwsqws</span></p>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nội dung</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">: tyutyuty</span></p>
<h1 style="margin-left: .5in; text-align: justify; text-indent: -.25in; tab-stops: list .5in;"><span style="font-size: 13.0pt; font-family: Symbol;"><span style="font: 7.0pt ''Times New Roman'';">&nbsp;&nbsp;&nbsp;&nbsp; </span></span><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">HỌC KỲ 6</span></u></h1>
<ul>
<li style="margin-left: .75in; text-indent: -.25in; tab-stops: list .75in left 5.0in;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">T&ecirc;n m&ocirc;n học: qqqqq &nbsp; &nbsp;(5 TC: 5 LT-4 TH)</span></strong></li>
</ul>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">M&ocirc;n ti&ecirc;n quyết:</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">oooooooooooooo</span></p>
<p style="margin-left: 1.0in; text-align: justify; tab-stops: 5.0in;"><strong><u><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nội dung</span></u></strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">: etghetgertg</span></p>', N'<p>&nbsp;</p>
<table style="margin-left: 5.4pt; border-collapse: collapse; border: none;" width="500">
<tbody>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: center;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">STT</span></strong></p>
</td>
<td style="width: 2.0in; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: center;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Họ v&agrave; t&ecirc;n</span></strong></p>
</td>
<td style="width: 40.5pt; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: center;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Năm sinh</span></strong></p>
</td>
<td style="width: 117.0pt; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: center;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Văn bằng cao nhất, ng&agrave;nh đ&agrave;o tạo</span></strong></p>
</td>
<td style="width: 2.0in; border: solid windowtext 1.0pt; border-left: none; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: center;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">C&aacute;c m&ocirc;n sẽ đảm tr&aacute;ch (*)</span></strong></p>
</td>
</tr>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">1</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Nguyễn Văn Giảng Vi&ecirc;n</span></strong></p>
</td>
<td style="width: 40.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></strong></p>
</td>
<td style="width: 117.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">ThS</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 1,Business Values,oooooooooooooo,dsf,qqqqq,csdcsdcsdcsdc</span></strong></p>
</td>
</tr>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">2</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">nguuyen lecturer4</span></strong></p>
</td>
<td style="width: 40.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></strong></p>
</td>
<td style="width: 117.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Ths</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">oooooooooooooo,qqqqq,huunhan,uuuu</span></strong></p>
</td>
</tr>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">3</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">nguuyen lecturer3</span></strong></p>
</td>
<td style="width: 40.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></strong></p>
</td>
<td style="width: 117.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Ths</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 1,Business Values,qứqwsqwsqws,qqqqq,hhhhh,yyy,Hello world,thai 123</span></strong></p>
</td>
</tr>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">4</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">nguuyen lecturer4</span></strong></p>
</td>
<td style="width: 40.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></strong></p>
</td>
<td style="width: 117.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Ths</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">oooooooooooooo,qqqqq,huunhan,uuuu</span></strong></p>
</td>
</tr>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">5</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">nguuyen lecturer3</span></strong></p>
</td>
<td style="width: 40.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></strong></p>
</td>
<td style="width: 117.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Ths</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">Những nguy&ecirc;n l&yacute; cơ bản của chủ nghĩa M&aacute;c-L&ecirc;-nin 1,Business Values,qứqwsqwsqws,qqqqq,hhhhh,yyy,Hello world,thai 123</span></strong></p>
</td>
</tr>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">6</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">qwe</span></strong></p>
</td>
<td style="width: 40.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></strong></p>
</td>
<td style="width: 117.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">qwe</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">mon hoc moi,day la mon hoc vua tao</span></strong></p>
</td>
</tr>
<tr>
<td style="width: .5in; border: solid windowtext 1.0pt; border-top: none; padding: 0in 5.4pt 0in 5.4pt;" width="48">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">7</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">qwe</span></strong></p>
</td>
<td style="width: 40.5pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="54">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">&nbsp;</span></strong></p>
</td>
<td style="width: 117.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="156">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">qwe</span></strong></p>
</td>
<td style="width: 2.0in; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0in 5.4pt 0in 5.4pt;" width="192">
<p style="text-align: justify;"><strong><span style="font-size: 13.0pt; font-family: ''Times New Roman'',serif;">mon hoc moi,day la mon hoc vua tao</span></strong></p>
</td>
</tr>
</tbody>
</table>', 5, CAST(0x0000A7A800D6F2F9 AS DateTime))
SET IDENTITY_INSERT [dbo].[Programs] OFF
SET IDENTITY_INSERT [dbo].[Roles] ON 

INSERT [dbo].[Roles] ([ID], [Name], [CreationTime]) VALUES (3, N'Admin', CAST(0x0000A79200A948E9 AS DateTime))
INSERT [dbo].[Roles] ([ID], [Name], [CreationTime]) VALUES (4, N'Deanery', CAST(0x0000A7980154DE9E AS DateTime))
INSERT [dbo].[Roles] ([ID], [Name], [CreationTime]) VALUES (5, N'Lecturer', CAST(0x0000A7A100CF657C AS DateTime))
INSERT [dbo].[Roles] ([ID], [Name], [CreationTime]) VALUES (6, N'Editor', CAST(0x0000A7A7012861AF AS DateTime))
SET IDENTITY_INSERT [dbo].[Roles] OFF
SET IDENTITY_INSERT [dbo].[Subjects] ON 

INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (8, N'Những nguyên lý cơ bản của chủ nghĩa Mác-Lê-nin 1', N'PL101', 2, 30, 20, N'aaa', 1, N'aaa', N'aaa', 1, 3, 1, CAST(0x0000A79B001F27C4 AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (9, N'Những nguyên lý cơ bản của chủ nghĩa Mác-Lê-nin 2', N'PL102', 1, 45, 0, N'aaa', 1, N'aaa', N'aaa', 1, 3, 1, CAST(0x0000A79B001F749D AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (10, N'Business Values', N'NT00D', 3, 30, 30, N'aaa', 4, N'aaa', N'aaa', 3, 13, 0, CAST(0x0000A79B0021C72B AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (11, N'qứqwsqwsqws', N'q?qwsqws', 9, 4, 4, N'qứqws', 4, N'qứqws', N'<p>qứxqx</p>', 4, 12, 1, CAST(0x0000A79B00BE053E AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (14, N'oooooooooooooo', N'ui', 2, 5, 5, N'ttttt', 5, N'tyutyuty', N'<p>utyutyut</p>', 5, 13, 0, CAST(0x0000A79C00AE55C5 AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (15, N'qqqqq', N'rrr', 5, 5, 4, N'hhhh', 6, N'etghetgertg', N'<p>ẻgergergerg</p>', 5, 5, 0, CAST(0x0000A79C00AE97E2 AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (16, N'hhhhh', N'tt', 5, 5, 5, N'thththt', 8, N'rthrtgrt', N'<p>grtgrtg</p>', 3, 10, 1, CAST(0x0000A79C00AEF8BB AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (17, N'tên môn học', N'12', 23, 21, 31, N'đại học', 2, N'<p>&aacute;dasdasd</p>', N'<p>&aacute;dasdasd</p>', 6, 12, 0, CAST(0x0000A79E013D991C AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (18, N'qưeqwe', N'queqwe', 5, 5, 4, N'qưeqwe', 5, N'<p>qưeqw</p>', N'<p>qưeqwe</p>', 4, 7, 1, CAST(0x0000A79E01404393 AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (20, N'teen mon hoc moi', N'123', 3, 34, 32, N'dai hoc', 5, N'<p>day loa mo ta mon hoc</p>', N'<p>day la muc dich mon hoc</p>', 1, 8, 1, CAST(0x0000A79F00B55538 AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (21, N'yyy', N'yyy', 3, 4, 2, N'yyy', 5, N'<p>6y6y</p>', N'<p>y6y6y6</p>', 7, 12, 1, CAST(0x0000A79F00B8AF30 AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (22, N'huunhan', N'123', 5, 4, 4, N'ư', 3, N'<p>&aacute;dasd</p>', N'<p>&aacute;d</p>', 3, 3, 1, CAST(0x0000A7A0001700A0 AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (23, N'uuuu', N'uuuu', 4, 4, 5, N'uuu', 4, N'<p>uu</p>', N'<p>uu</p>', 7, 6, 1, CAST(0x0000A7A0001830A5 AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (37, N'áqweqw', N'que', 212, 21, 12, N'dâsd', 2, N'qưdqw', N'qưe', 4, 3, 1, CAST(0x0000A7A101349566 AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (38, N'dsf', N'sdfsdf', 312, 23, 4, N'sdasd', 2, N'ádas', N'ádasd', 4, 5, 1, CAST(0x0000A7A1013733E5 AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (39, N'qqqqq', N'queqwe', 12, 12, 12, N'sadasd', 2, N'ádasd', N'aád', 4, 12, 1, CAST(0x0000A7A10138782A AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (40, N'csdcsdcsdcsdc', N'dcdc', 2, 3, 4, N'asdasd', 2, N'sdsdf', N'sdf', 4, 9, 1, CAST(0x0000A7A1013E488A AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (41, N'ttvtv', N'vtvtv', 3, 4, 7, N'ubub', 3, N'fdff', N'ff', 4, 3, 1, CAST(0x0000A7A1013FE357 AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (42, N'Kỹ thuật xử lí chất liệu', N'KT0023', 4, 56, 42, N'Kết thúc năm 2', 3, N'ádasd', N'đasa', 3, 8, 1, CAST(0x0000A7A400441D1B AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (43, N'Kỹ thuật xử lí chất liệu', N'KT0023', 4, 56, 42, N'Kết thúc năm 2', 3, N'ádasd', N'đasa', 3, 8, 1, CAST(0x0000A7A400442208 AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (52, N'Môn học mới', N'gg', 25, 25, 25, N'ĐH', 7, N'ádasdasdasd', N'đâsdasd', 3, 3, 1, CAST(0x0000A7A700D591F7 AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (54, N'Hello world', N'as', 65, 44, 44, N'đg', 2, N'ádasd', N'ádasd', 1, 5, 1, CAST(0x0000A7A701085E6C AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (55, N'thai 123', N'123', 4, 45, 45, N'nam 3', 3, N'abc', N'abc', 5, 3, 1, CAST(0x0000A7A800B2BCDA AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (56, N'mon hoc moi', N'gg', 12, 12, 12, N'DDAij hoc', 3, N'qwe', N'qwe', 5, 3, 1, CAST(0x0000A7A800C7A5DE AS DateTime))
INSERT [dbo].[Subjects] ([ID], [Name], [PartialCode], [CreditNumber], [TheoryNumber], [PracticeNumber], [LearningLevel], [SemesterNumber], [Description], [Purpose], [FacultyID], [SubjectTypeID], [Form], [CreationTime]) VALUES (57, N'day la mon hoc vua tao', N'qq', 12, 12, 12, N'ddh', 1, N'ac', N'abc', 5, 7, 1, CAST(0x0000A7A800D69D83 AS DateTime))
SET IDENTITY_INSERT [dbo].[Subjects] OFF
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (8, 3, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (8, 11, 0)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (9, 9, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (10, 3, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (10, 11, 0)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (11, 11, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (14, 3, 0)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (14, 12, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (15, 11, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (15, 12, 0)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (16, 11, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (16, 19, 0)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (17, 18, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (18, 5, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (20, 18, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (20, 19, 0)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (21, 5, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (21, 11, 0)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (22, 12, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (23, 12, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (37, 5, 0)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (38, 3, 0)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (38, 5, 0)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (39, 3, 0)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (39, 9, 0)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (40, 3, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (41, 9, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (42, 5, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (43, 5, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (52, 5, 0)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (52, 18, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (54, 11, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (55, 11, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (56, 21, 1)
INSERT [dbo].[SubjectsAccounts] ([SubjectID], [AccountID], [IsSyllabusEditor]) VALUES (57, 21, 1)
SET IDENTITY_INSERT [dbo].[SubjectTypes] ON 

INSERT [dbo].[SubjectTypes] ([ID], [SubSubjectTypeID], [SubTwoSubjectTypeID], [Name], [CreationTime]) VALUES (1, NULL, NULL, N'Kiến thức giáo dục đại cương', CAST(0x0000A79900B673F9 AS DateTime))
INSERT [dbo].[SubjectTypes] ([ID], [SubSubjectTypeID], [SubTwoSubjectTypeID], [Name], [CreationTime]) VALUES (2, NULL, NULL, N'Kiến thức giáo dục chuyên nghiệp', CAST(0x0000A79900B67E11 AS DateTime))
INSERT [dbo].[SubjectTypes] ([ID], [SubSubjectTypeID], [SubTwoSubjectTypeID], [Name], [CreationTime]) VALUES (3, 1, NULL, N'Lý luận Mac-Lenin và Tư tưởng HCM', CAST(0x0000A79900B69845 AS DateTime))
INSERT [dbo].[SubjectTypes] ([ID], [SubSubjectTypeID], [SubTwoSubjectTypeID], [Name], [CreationTime]) VALUES (4, 1, NULL, N'Ngoại ngữ ', CAST(0x0000A79900B6A486 AS DateTime))
INSERT [dbo].[SubjectTypes] ([ID], [SubSubjectTypeID], [SubTwoSubjectTypeID], [Name], [CreationTime]) VALUES (5, 1, NULL, N'Toán - Tin Học - Khoa học Tự nhiên - Công Nghệ - Môi Trường', CAST(0x0000A79900B6B7C2 AS DateTime))
INSERT [dbo].[SubjectTypes] ([ID], [SubSubjectTypeID], [SubTwoSubjectTypeID], [Name], [CreationTime]) VALUES (6, 1, NULL, N'Giáo dục thể chất', CAST(0x0000A79900B6BAE2 AS DateTime))
INSERT [dbo].[SubjectTypes] ([ID], [SubSubjectTypeID], [SubTwoSubjectTypeID], [Name], [CreationTime]) VALUES (7, 2, NULL, N'Kiến thức cơ sở ngành', CAST(0x0000A79900B6C5B2 AS DateTime))
INSERT [dbo].[SubjectTypes] ([ID], [SubSubjectTypeID], [SubTwoSubjectTypeID], [Name], [CreationTime]) VALUES (8, 2, NULL, N'Kiến thức chuyên ngành', CAST(0x0000A79900B6D0CA AS DateTime))
INSERT [dbo].[SubjectTypes] ([ID], [SubSubjectTypeID], [SubTwoSubjectTypeID], [Name], [CreationTime]) VALUES (9, 2, NULL, N'Kiến thức bổ trợ', CAST(0x0000A79900B6DA86 AS DateTime))
INSERT [dbo].[SubjectTypes] ([ID], [SubSubjectTypeID], [SubTwoSubjectTypeID], [Name], [CreationTime]) VALUES (10, 2, NULL, N'Thực tập tốt nghiệp và làm khoá luận', CAST(0x0000A79900B6E251 AS DateTime))
INSERT [dbo].[SubjectTypes] ([ID], [SubSubjectTypeID], [SubTwoSubjectTypeID], [Name], [CreationTime]) VALUES (11, NULL, 4, N'Ngoại ngữ cơ bản', CAST(0x0000A79900FF34A9 AS DateTime))
INSERT [dbo].[SubjectTypes] ([ID], [SubSubjectTypeID], [SubTwoSubjectTypeID], [Name], [CreationTime]) VALUES (12, NULL, 4, N'Ngoại ngữ chuyên ngành', CAST(0x0000A79900FF4714 AS DateTime))
INSERT [dbo].[SubjectTypes] ([ID], [SubSubjectTypeID], [SubTwoSubjectTypeID], [Name], [CreationTime]) VALUES (13, 1, NULL, N'Khoa học xã hội', CAST(0x0000A79B0021794C AS DateTime))
INSERT [dbo].[SubjectTypes] ([ID], [SubSubjectTypeID], [SubTwoSubjectTypeID], [Name], [CreationTime]) VALUES (14, 1, NULL, N'Giáo dục quốc phòng - An ninh', CAST(0x0000A79B00218D4A AS DateTime))
SET IDENTITY_INSERT [dbo].[SubjectTypes] OFF
SET IDENTITY_INSERT [dbo].[Syllabuses] ON 

INSERT [dbo].[Syllabuses] ([ID], [VietnameseName], [EnglishName], [KnowldgeType], [LearningTimeDetail], [Requirement], [Planning], [DocumentReference], [LearningOutcomeEvaluate], [LecturerContact], [ShortDescription], [OutcomeContent], [OutcomeMaxtrixMapping], [OutcomeMappingDescription], [CreatedAccountID], [ClassroomID], [SubjectID], [CreationTime]) VALUES (2, N'Những nguyên lý cơ bản của chủ nghĩa Mác-Lê-nin 1(ahihi)', N'á dá đá asd á dá ', N'
        <table style="width: 698px; border-collapse: collapse">
            <tbody>
                <tr>
                    <td style="width: 220px; border: 1px solid; text-align: center; " colspan="2">Kiến thức giáo dục đại cương <input class="mycheck" type="checkbox"></td>
                    <td style="width: 463px; border: 1px solid; text-align: center;" colspan="4">Kiến thức giáo dục chuyên nghiệp <input class="mycheck" checked="checked" type="checkbox"></td>
                </tr>
                <tr>
                    <td style="width: 108.7px; border: 1px solid; text-align: center;" rowspan="2">Bắt buộc <input class="mycheck" type="checkbox"></td>
                    <td style="width: 111.3px; border: 1px solid; text-align: center;" rowspan="2">Tự chọn <input class="mycheck" type="checkbox"></td>
                    <td style="width: 242px; border: 1px solid; text-align: center;" colspan="2">Kiến thức cơ sở ngành <input class="mycheck" type="checkbox"></td>
                    <td style="width: 221px; border: 1px solid; text-align: center;" colspan="2">Kiến thức chuyên ngành <input class="mycheck" checked="checked" type="checkbox"></td>
                </tr>
                <tr>
                    <td style="width: 139px; border: 1px solid; text-align: center;">Bắt buộc <input class="mycheck" type="checkbox"></td>
                    <td style="width: 103px; border: 1px solid; text-align: center;">Tự chọn <input class="mycheck" type="checkbox"></td>
                    <td style="width: 115px; border: 1px solid; text-align: center;">Bắt buộc <input class="mycheck" type="checkbox"></td>
                    <td style="width: 106px; border: 1px solid; text-align: center;">Tự chọn <input class="mycheck" type="checkbox"></td>
                </tr>
            </tbody>
        </table>
    ', N'ádasdasd', N'<p>asd asd &aacute;</p>', N'<p>asd asd asd</p>', N'<p>asda sd &aacute;</p>', N'<p>asdasdas d</p>', N'<p>asd asdaskjdn asjknd klasmlkdm &aacute;</p>', N'<p>asdas d&aacute; d&aacute; d&aacute;</p>
<p>&aacute;d</p>
<p>&aacute;d</p>
<p>&aacute;ajlsndkjn huu nhan</p>
<p>&nbsp;</p>', N'<p>&aacute;d</p><p>&aacute;dasd</p><p>&aacute;d</p><p>&aacute;d</p><p>&aacute;d</p><p>&aacute;d</p><p>&aacute;d</p><p>&aacute;d</p><p>&aacute;das</p>', N'<p>x</p>
<table>
<tbody>
<tr>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">A</td>
<td style="width: 157.267px;">B</td>
<td style="width: 157.267px;">C</td>
<td style="width: 157.267px;">D</td>
<td style="width: 157.267px;">E</td>
<td style="width: 157.267px;">F</td>
<td style="width: 157.267px;">G</td>
<td style="width: 157.267px;">H</td>
<td style="width: 157.267px;">I</td>
</tr>
<tr>
<td style="width: 157.267px;">1</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">2</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">x </td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">3</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">4</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;x</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">xx </td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;xx</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">5</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">6</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">7</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;x</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">8</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;x</td>
<td style="width: 157.267px;">&nbsp;x</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">9</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;xx</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;x</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">10</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">x </td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">11</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;x</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">12</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;x</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">13</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>', N'<table>
<tbody>
<tr>
<td style="width: 157.267px;" rowspan="2">Chuẩn đầu ra của m&ocirc;n học</td>
<td style="width: 157.267px;" rowspan="2">Phương ph&aacute;p dạy v&agrave; học</td>
<td style="width: 157.267px;" colspan="2">Phương ph&aacute;p kiểm tra, đ&aacute;nh gi&aacute; sinh vi&ecirc;n</td>
<td style="width: 157.267px;" rowspan="2">Chuẩn đầu ra CTĐT</td>
</tr>
<tr>
<td style="width: 157.267px;">Phương ph&aacute;p</td>
<td style="width: 157.267px;">Tỷ trọng (%)</td>
</tr>
<tr>
<td style="width: 157.267px;" rowspan="3">Chuẩn A</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
<td style="width: 157.268px;">&nbsp;&aacute;d</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;đ&aacute;</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;d&aacute;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;đ&aacute;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;&aacute;das</td>
</tr>
<tr>
<td style="width: 157.267px;" rowspan="3">Chuẩn B</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
<td style="width: 157.268px;">&nbsp;d&aacute;đ&acirc;s</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;&aacute;d</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;&aacute;das</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;&aacute;das</td>
</tr>
<tr>
<td style="width: 157.267px;" rowspan="3">Chuẩn C</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
<td style="width: 157.268px;">&nbsp;&aacute;dasd</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;d&aacute;d</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;d&aacute;đ&aacute;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;&aacute;das</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;&aacute;d</td>
</tr>
<tr>
<td style="width: 157.267px;" rowspan="3">Chuẩn D</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
<td style="width: 157.268px;">&nbsp;</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;" rowspan="3">Chuẩn E</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;đ&aacute;</td>
<td style="width: 157.268px;">&nbsp;</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;" rowspan="3">Chuẩn F</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;&aacute;d</td>
<td style="width: 157.268px;">&nbsp;</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;" rowspan="3">Chuẩn G</td>
<td style="width: 157.267px;" rowspan="3">&acirc;sd&aacute;d&aacute;das</td>
<td style="width: 157.268px;">&nbsp;</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;" rowspan="3">Chuẩn H&aacute;d</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;&aacute;das</td>
<td style="width: 157.268px;">&nbsp;&aacute;d</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;&aacute;d</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;" rowspan="3">Chuẩn I</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;&aacute;dasd</td>
<td style="width: 157.268px;">&nbsp;&aacute;d</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;&aacute;d</td>
</tr>
<tr>
<td colspan="3">T&ocirc;ng cộng</td>
<td style="width: 157.267px;">100%</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>', 3, 2, 8, CAST(0x0000A7A700C57ED5 AS DateTime))
INSERT [dbo].[Syllabuses] ([ID], [VietnameseName], [EnglishName], [KnowldgeType], [LearningTimeDetail], [Requirement], [Planning], [DocumentReference], [LearningOutcomeEvaluate], [LecturerContact], [ShortDescription], [OutcomeContent], [OutcomeMaxtrixMapping], [OutcomeMappingDescription], [CreatedAccountID], [ClassroomID], [SubjectID], [CreationTime]) VALUES (3, N'Những nguyên lý cơ bản của chủ nghĩa Mác-Lê-nin 2(Kỹ Thuật Phần Mềm)', N'ádasd', N'
        <table style="width: 698px; border-collapse: collapse">
            <tbody>
                <tr>
                    <td style="width: 220px; border: 1px solid; text-align: center; " colspan="2">Kiến thức giáo dục đại cương <input class="mycheck" checked="checked" type="checkbox"></td>
                    <td style="width: 463px; border: 1px solid; text-align: center;" colspan="4">Kiến thức giáo dục chuyên nghiệp <input class="mycheck" type="checkbox"></td>
                </tr>
                <tr>
                    <td style="width: 108.7px; border: 1px solid; text-align: center;" rowspan="2">Bắt buộc <input class="mycheck" type="checkbox"></td>
                    <td style="width: 111.3px; border: 1px solid; text-align: center;" rowspan="2">Tự chọn <input class="mycheck" checked="checked" type="checkbox"></td>
                    <td style="width: 242px; border: 1px solid; text-align: center;" colspan="2">Kiến thức cơ sở ngành <input class="mycheck" type="checkbox"></td>
                    <td style="width: 221px; border: 1px solid; text-align: center;" colspan="2">Kiến thức chuyên ngành <input class="mycheck" type="checkbox"></td>
                </tr>
                <tr>
                    <td style="width: 139px; border: 1px solid; text-align: center;">Bắt buộc <input class="mycheck" type="checkbox"></td>
                    <td style="width: 103px; border: 1px solid; text-align: center;">Tự chọn <input class="mycheck" type="checkbox"></td>
                    <td style="width: 115px; border: 1px solid; text-align: center;">Bắt buộc <input class="mycheck" type="checkbox"></td>
                    <td style="width: 106px; border: 1px solid; text-align: center;">Tự chọn <input class="mycheck" type="checkbox"></td>
                </tr>
            </tbody>
        </table>
    ', N'ádasdasd', N'<p>&aacute;dasd</p>', N'<p>&aacute;dasd</p>', N'<p>&aacute;dasd</p>', N'<p>&aacute;dasd</p>', N'<p>&aacute;dasdasd</p>', N'<p>&aacute;dasdas</p>', N'<p>&aacute;das</p><p>&aacute;d</p><p>&aacute;d</p><p>&aacute;d</p>', N'<table>
<tbody>
<tr>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">A</td>
<td style="width: 157.267px;">B</td>
<td style="width: 157.267px;">C</td>
<td style="width: 157.267px;">D</td>
</tr>
<tr>
<td style="width: 157.267px;">1</td>
<td style="width: 157.267px;">&nbsp;x</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">2</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">3</td>
<td style="width: 157.267px;">&nbsp;x</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">4</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">5</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">6</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;x</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">7</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">8</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;x</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">9</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;x</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">10</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">11</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">12</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">13</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>', N'<table>
<tbody>
<tr>
<td style="width: 157.267px;" rowspan="2">Chuẩn đầu ra của m&ocirc;n học</td>
<td style="width: 157.267px;" rowspan="2">Phương ph&aacute;p dạy v&agrave; học</td>
<td style="width: 157.267px;" colspan="2">Phương ph&aacute;p kiểm tra, đ&aacute;nh gi&aacute; sinh vi&ecirc;n</td>
<td style="width: 157.267px;" rowspan="2">Chuẩn đầu ra CTĐT</td>
</tr>
<tr>
<td style="width: 157.267px;">Phương ph&aacute;p</td>
<td style="width: 157.267px;">Tỷ trọng (%)</td>
</tr>
<tr>
<td style="width: 157.267px;">A</td>
<td style="width: 157.267px;">&nbsp;x</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;đ&aacute;</td>
<td style="width: 157.267px;">&nbsp;&aacute;d</td>
</tr>
<tr>
<td style="width: 157.267px;">B</td>
<td style="width: 157.267px;">&nbsp;x</td>
<td style="width: 157.267px;">&nbsp;&acirc;csdas</td>
<td style="width: 157.267px;">&nbsp;&aacute;d</td>
<td style="width: 157.267px;">&nbsp;&aacute;das</td>
</tr>
<tr>
<td style="width: 157.267px;">C</td>
<td style="width: 157.267px;">&nbsp;&aacute;d&aacute;d</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">d&aacute;d</td>
<td style="width: 157.267px;">&nbsp;&aacute;d</td>
</tr>
<tr>
<td style="width: 157.267px;">D</td>
<td style="width: 157.267px;">&nbsp;&aacute;d</td>
<td style="width: 157.267px;">&nbsp;&aacute;d</td>
<td style="width: 157.267px;">đ&aacute;</td>
<td style="width: 157.267px;">&nbsp;&aacute;d</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>', 9, 2, 9, CAST(0x0000A7A60182E419 AS DateTime))
INSERT [dbo].[Syllabuses] ([ID], [VietnameseName], [EnglishName], [KnowldgeType], [LearningTimeDetail], [Requirement], [Planning], [DocumentReference], [LearningOutcomeEvaluate], [LecturerContact], [ShortDescription], [OutcomeContent], [OutcomeMaxtrixMapping], [OutcomeMappingDescription], [CreatedAccountID], [ClassroomID], [SubjectID], [CreationTime]) VALUES (4, N'Kỹ thuật xử lí chất liệu(Ngôn Ngữ Anh)', N'Tên tiếng anh', N'
        <table style="width: 698px; border-collapse: collapse">
            <tbody>
                <tr>
                    <td style="width: 220px; border: 1px solid; text-align: center; " colspan="2">Kiến thức giáo dục đại cương <input class="mycheck" type="checkbox"></td>
                    <td style="width: 463px; border: 1px solid; text-align: center;" colspan="4">Kiến thức giáo dục chuyên nghiệp <input class="mycheck" checked="checked" type="checkbox"></td>
                </tr>
                <tr>
                    <td style="width: 108.7px; border: 1px solid; text-align: center;" rowspan="2">Bắt buộc <input class="mycheck" type="checkbox"></td>
                    <td style="width: 111.3px; border: 1px solid; text-align: center;" rowspan="2">Tự chọn <input class="mycheck" type="checkbox"></td>
                    <td style="width: 242px; border: 1px solid; text-align: center;" colspan="2">Kiến thức cơ sở ngành <input class="mycheck" type="checkbox"></td>
                    <td style="width: 221px; border: 1px solid; text-align: center;" colspan="2">Kiến thức chuyên ngành <input class="mycheck" checked="checked" type="checkbox"></td>
                </tr>
                <tr>
                    <td style="width: 139px; border: 1px solid; text-align: center;">Bắt buộc <input class="mycheck" type="checkbox"></td>
                    <td style="width: 103px; border: 1px solid; text-align: center;">Tự chọn <input class="mycheck" type="checkbox"></td>
                    <td style="width: 115px; border: 1px solid; text-align: center;">Bắt buộc <input class="mycheck" checked="checked" type="checkbox"></td>
                    <td style="width: 106px; border: 1px solid; text-align: center;">Tự chọn <input class="mycheck" type="checkbox"></td>
                </tr>
            </tbody>
        </table>
    ', N'thứ 2', N'<p>&aacute;das</p>', N'<p>&aacute;dasdasd</p>', N'<p>Đ&acirc;y l&agrave; t&agrave;i li&ecirc;u</p>', N'<p>Y&Ecirc;u cầu chung</p>
<p>đ&aacute;ng gi&aacute;</p>', N'<p>Đ&acirc;y l&agrave; c&aacute;ch li&ecirc;n lạc với GV</p>', N'<p>Đ&acirc;y l&agrave; nội dungabc</p>', N'<ol style="list-style-type: lower-alpha;"><li>&nbsp;giải th&iacute;ch a</li><li>giải th&iacute;ch b</li><li>giải th&iacute;ch c</li><li>giai thich d</li></ol>', N'<table>
<tbody>
<tr>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">A</td>
<td style="width: 157.267px;">B</td>
<td style="width: 157.267px;">C</td>
<td style="width: 157.267px;">D</td>
</tr>
<tr>
<td style="width: 157.267px;">1</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">2</td>
<td style="width: 157.267px;">&nbsp;xx</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">3</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">4</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;x</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">5</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;xx</td>
</tr>
<tr>
<td style="width: 157.267px;">6</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;x</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">7</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">8</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">9</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">10</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">11</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">12</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">13</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">14</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>', N'<table>
<tbody>
<tr>
<td style="width: 157.267px;" rowspan="2">Chuẩn đầu ra của m&ocirc;n học</td>
<td style="width: 157.267px;" rowspan="2">Phương ph&aacute;p dạy v&agrave; học</td>
<td style="width: 157.267px;" colspan="2">Phương ph&aacute;p kiểm tra, đ&aacute;nh gi&aacute; sinh vi&ecirc;n</td>
<td style="width: 157.267px;" rowspan="2">Chuẩn đầu ra CTĐT</td>
</tr>
<tr>
<td style="width: 157.267px;">Phương ph&aacute;p</td>
<td style="width: 157.267px;">Tỷ trọng (%)</td>
</tr>
<tr>
<td style="width: 157.267px;" rowspan="3">Chuẩn A</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
<td style="width: 157.268px;">&nbsp;ascas</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;asc</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;ascasc</td>
</tr>
<tr>
<td style="width: 157.267px;" rowspan="3">Chuẩn B</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
<td style="width: 157.268px;">&nbsp;</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;asc</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;asc</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;" rowspan="3">Chuẩn C</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
<td style="width: 157.268px;">&nbsp;asc</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;" rowspan="3">Chuẩn D</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
<td style="width: 157.268px;">&nbsp;</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td colspan="3">T&ocirc;ng cộng</td>
<td style="width: 157.267px;">100%</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>', 5, 2, 42, CAST(0x0000A7A800D80EB3 AS DateTime))
INSERT [dbo].[Syllabuses] ([ID], [VietnameseName], [EnglishName], [KnowldgeType], [LearningTimeDetail], [Requirement], [Planning], [DocumentReference], [LearningOutcomeEvaluate], [LecturerContact], [ShortDescription], [OutcomeContent], [OutcomeMaxtrixMapping], [OutcomeMappingDescription], [CreatedAccountID], [ClassroomID], [SubjectID], [CreationTime]) VALUES (5, N'Business Values', N'day la ten tieng anh', N'
        <table style="width: 698px; border-collapse: collapse">
            <tbody>
                <tr>
                    <td style="width: 220px; border: 1px solid; text-align: center; " colspan="2">Kiến thức giáo dục đại cương <input class="mycheck" checked="checked" type="checkbox"></td>
                    <td style="width: 463px; border: 1px solid; text-align: center;" colspan="4">Kiến thức giáo dục chuyên nghiệp <input class="mycheck" type="checkbox"></td>
                </tr>
                <tr>
                    <td style="width: 108.7px; border: 1px solid; text-align: center;" rowspan="2">Bắt buộc <input class="mycheck" type="checkbox"></td>
                    <td style="width: 111.3px; border: 1px solid; text-align: center;" rowspan="2">Tự chọn <input class="mycheck" checked="checked" type="checkbox"></td>
                    <td style="width: 242px; border: 1px solid; text-align: center;" colspan="2">Kiến thức cơ sở ngành <input class="mycheck" type="checkbox"></td>
                    <td style="width: 221px; border: 1px solid; text-align: center;" colspan="2">Kiến thức chuyên ngành <input class="mycheck" type="checkbox"></td>
                </tr>
                <tr>
                    <td style="width: 139px; border: 1px solid; text-align: center;">Bắt buộc <input class="mycheck" type="checkbox"></td>
                    <td style="width: 103px; border: 1px solid; text-align: center;">Tự chọn <input class="mycheck" type="checkbox"></td>
                    <td style="width: 115px; border: 1px solid; text-align: center;">Bắt buộc <input class="mycheck" type="checkbox"></td>
                    <td style="width: 106px; border: 1px solid; text-align: center;">Tự chọn <input class="mycheck" type="checkbox"></td>
                </tr>
            </tbody>
        </table>
    ', N'day la thoi gian hoc', N'<p>day la Y&ecirc;u cầu m&ocirc;n học</p>', N'<p>Kế hoạch giảng dạy học tập cụ thể</p>', N'<p>&nbsp;day la &agrave;i liệu phục vụ m&ocirc;n học</p>', N'<p>day la Phương ph&aacute;p đ&aacute;nh gi&aacute; kết quả học tập của sinh vi&ecirc;n</p>', N'<p>day la C&aacute;ch li&ecirc;n lạc giảng vi&ecirc;n</p>', N'<p>dday la noi dung tom tat hoc phan</p>', N'<p>a. 2123</p><p>b. 41</p><p>c.13212</p>', N'<table>
<tbody>
<tr>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">A</td>
<td style="width: 157.267px;">B</td>
<td style="width: 157.267px;">C</td>
</tr>
<tr>
<td style="width: 157.267px;">1</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">2</td>
<td style="width: 157.267px;">&nbsp;x</td>
<td style="width: 157.267px;">&nbsp;x</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">3</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">4</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">5</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;x</td>
</tr>
<tr>
<td style="width: 157.267px;">6</td>
<td style="width: 157.267px;">&nbsp;x</td>
<td style="width: 157.267px;">&nbsp;x</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">7</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">8</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;x</td>
</tr>
<tr>
<td style="width: 157.267px;">9</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">10</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">11</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">12</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">13</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
<tr>
<td style="width: 157.267px;">14</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
<td style="width: 157.267px;">&nbsp;</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>', N'<table>
<tbody>
<tr>
<td style="width: 157.267px;" rowspan="2">Chuẩn đầu ra của m&ocirc;n học</td>
<td style="width: 157.267px;" rowspan="2">Phương ph&aacute;p dạy v&agrave; học</td>
<td style="width: 157.267px;" colspan="2">Phương ph&aacute;p kiểm tra, đ&aacute;nh gi&aacute; sinh vi&ecirc;n</td>
<td style="width: 157.267px;" rowspan="2">Chuẩn đầu ra CTĐT</td>
</tr>
<tr>
<td style="width: 157.267px;">Phương ph&aacute;p</td>
<td style="width: 157.267px;">Tỷ trọng (%)</td>
</tr>
<tr>
<td style="width: 157.267px;" rowspan="3">Chuẩn A</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;asd</td>
<td style="width: 157.268px;">&nbsp;asd</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;asd</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;asd</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;asd</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;asd</td>
</tr>
<tr>
<td style="width: 157.267px;" rowspan="3">Chuẩn B</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;asd</td>
<td style="width: 157.268px;">&nbsp;asd</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;asd</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;asd</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;asd</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;asdasd</td>
</tr>
<tr>
<td style="width: 157.267px;" rowspan="3">Chuẩn C</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;asd</td>
<td style="width: 157.268px;">&nbsp;asd</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;asd</td>
<td style="width: 157.267px;" rowspan="3">&nbsp;asd</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;asd</td>
</tr>
<tr>
<td style="width: 157.267px;">&nbsp;asd</td>
</tr>
<tr>
<td colspan="3">T&ocirc;ng cộng</td>
<td style="width: 157.267px;">100%</td>
<td style="width: 157.267px;">&nbsp;asd</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>', 3, 27, 10, CAST(0x0000A7A800DD04EB AS DateTime))
SET IDENTITY_INSERT [dbo].[Syllabuses] OFF
ALTER TABLE [dbo].[Accounts] ADD  CONSTRAINT [DF_Accounts_CreationTime]  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[Facilities] ADD  CONSTRAINT [DF_Facilities_CreationTime]  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[Faculties] ADD  CONSTRAINT [DF_Faculties_CreationTime]  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[Programs] ADD  CONSTRAINT [DF_Programs_CreationTime]  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[Roles] ADD  CONSTRAINT [DF_Roles_CreationTime]  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[SubjectTypes] ADD  CONSTRAINT [DF_SubjectTypes_CreationTime]  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[AccountRoles]  WITH CHECK ADD  CONSTRAINT [FK_AccountRoles_Accounts] FOREIGN KEY([AccountID])
REFERENCES [dbo].[Accounts] ([ID])
GO
ALTER TABLE [dbo].[AccountRoles] CHECK CONSTRAINT [FK_AccountRoles_Accounts]
GO
ALTER TABLE [dbo].[AccountRoles]  WITH CHECK ADD  CONSTRAINT [FK_AccountRoles_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Roles] ([ID])
GO
ALTER TABLE [dbo].[AccountRoles] CHECK CONSTRAINT [FK_AccountRoles_Roles]
GO
ALTER TABLE [dbo].[Accounts]  WITH CHECK ADD  CONSTRAINT [FK_Accounts_Faculties] FOREIGN KEY([FacultyID])
REFERENCES [dbo].[Faculties] ([ID])
GO
ALTER TABLE [dbo].[Accounts] CHECK CONSTRAINT [FK_Accounts_Faculties]
GO
ALTER TABLE [dbo].[Classrooms]  WITH CHECK ADD  CONSTRAINT [FK_Classrooms_Facilities] FOREIGN KEY([FacilityID])
REFERENCES [dbo].[Facilities] ([ID])
GO
ALTER TABLE [dbo].[Classrooms] CHECK CONSTRAINT [FK_Classrooms_Facilities]
GO
ALTER TABLE [dbo].[ConditionRelateSubjects]  WITH CHECK ADD  CONSTRAINT [FK_ConditionRelateSubjects_Subjects] FOREIGN KEY([SubjectID])
REFERENCES [dbo].[Subjects] ([ID])
GO
ALTER TABLE [dbo].[ConditionRelateSubjects] CHECK CONSTRAINT [FK_ConditionRelateSubjects_Subjects]
GO
ALTER TABLE [dbo].[ConditionRelateSubjects]  WITH CHECK ADD  CONSTRAINT [FK_ConditionRelateSubjects_Subjects1] FOREIGN KEY([ConditionSubjectID])
REFERENCES [dbo].[Subjects] ([ID])
GO
ALTER TABLE [dbo].[ConditionRelateSubjects] CHECK CONSTRAINT [FK_ConditionRelateSubjects_Subjects1]
GO
ALTER TABLE [dbo].[Faculties]  WITH CHECK ADD  CONSTRAINT [FK_Faculties_Classrooms] FOREIGN KEY([ClassroomID])
REFERENCES [dbo].[Classrooms] ([ID])
GO
ALTER TABLE [dbo].[Faculties] CHECK CONSTRAINT [FK_Faculties_Classrooms]
GO
ALTER TABLE [dbo].[Programs]  WITH CHECK ADD  CONSTRAINT [FK_Programs_Faculties] FOREIGN KEY([FacultyID])
REFERENCES [dbo].[Faculties] ([ID])
GO
ALTER TABLE [dbo].[Programs] CHECK CONSTRAINT [FK_Programs_Faculties]
GO
ALTER TABLE [dbo].[Subjects]  WITH CHECK ADD  CONSTRAINT [FK_Subjects_Faculties] FOREIGN KEY([FacultyID])
REFERENCES [dbo].[Faculties] ([ID])
GO
ALTER TABLE [dbo].[Subjects] CHECK CONSTRAINT [FK_Subjects_Faculties]
GO
ALTER TABLE [dbo].[Subjects]  WITH CHECK ADD  CONSTRAINT [FK_Subjects_SubjectTypes] FOREIGN KEY([SubjectTypeID])
REFERENCES [dbo].[SubjectTypes] ([ID])
GO
ALTER TABLE [dbo].[Subjects] CHECK CONSTRAINT [FK_Subjects_SubjectTypes]
GO
ALTER TABLE [dbo].[SubjectsAccounts]  WITH CHECK ADD  CONSTRAINT [FK_SubjectsAccounts_Accounts] FOREIGN KEY([AccountID])
REFERENCES [dbo].[Accounts] ([ID])
GO
ALTER TABLE [dbo].[SubjectsAccounts] CHECK CONSTRAINT [FK_SubjectsAccounts_Accounts]
GO
ALTER TABLE [dbo].[SubjectsAccounts]  WITH CHECK ADD  CONSTRAINT [FK_SubjectsAccounts_Subjects] FOREIGN KEY([SubjectID])
REFERENCES [dbo].[Subjects] ([ID])
GO
ALTER TABLE [dbo].[SubjectsAccounts] CHECK CONSTRAINT [FK_SubjectsAccounts_Subjects]
GO
ALTER TABLE [dbo].[SubjectTypes]  WITH CHECK ADD  CONSTRAINT [FK_SubjectTypes_SubjectTypes] FOREIGN KEY([SubSubjectTypeID])
REFERENCES [dbo].[SubjectTypes] ([ID])
GO
ALTER TABLE [dbo].[SubjectTypes] CHECK CONSTRAINT [FK_SubjectTypes_SubjectTypes]
GO
ALTER TABLE [dbo].[SubjectTypes]  WITH CHECK ADD  CONSTRAINT [FK_SubjectTypes_SubjectTypes1] FOREIGN KEY([SubTwoSubjectTypeID])
REFERENCES [dbo].[SubjectTypes] ([ID])
GO
ALTER TABLE [dbo].[SubjectTypes] CHECK CONSTRAINT [FK_SubjectTypes_SubjectTypes1]
GO
ALTER TABLE [dbo].[Syllabuses]  WITH CHECK ADD  CONSTRAINT [FK_Syllabuses_Accounts] FOREIGN KEY([CreatedAccountID])
REFERENCES [dbo].[Accounts] ([ID])
GO
ALTER TABLE [dbo].[Syllabuses] CHECK CONSTRAINT [FK_Syllabuses_Accounts]
GO
ALTER TABLE [dbo].[Syllabuses]  WITH CHECK ADD  CONSTRAINT [FK_Syllabuses_Classrooms] FOREIGN KEY([ClassroomID])
REFERENCES [dbo].[Classrooms] ([ID])
GO
ALTER TABLE [dbo].[Syllabuses] CHECK CONSTRAINT [FK_Syllabuses_Classrooms]
GO
ALTER TABLE [dbo].[Syllabuses]  WITH CHECK ADD  CONSTRAINT [FK_Syllabuses_Subjects] FOREIGN KEY([SubjectID])
REFERENCES [dbo].[Subjects] ([ID])
GO
ALTER TABLE [dbo].[Syllabuses] CHECK CONSTRAINT [FK_Syllabuses_Subjects]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'mô tả vắn tắt nội dung môn học' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Subjects', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Thời gian học: học kỳ 2, sáng thứ ba hàng tuần, giờ thứ 1-2-3 (từ 7:00-9:25)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Syllabuses', @level2type=N'COLUMN',@level2name=N'LearningTimeDetail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'yêu cầu môn học' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Syllabuses', @level2type=N'COLUMN',@level2name=N'Requirement'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'kế hoạch giảng dạy học tập cụ thể' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Syllabuses', @level2type=N'COLUMN',@level2name=N'Planning'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'10) tai lieu phuc vu mon hoc' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Syllabuses', @level2type=N'COLUMN',@level2name=N'DocumentReference'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'11) Phương pháp đánh giá kết quả học tập của sinh viên' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Syllabuses', @level2type=N'COLUMN',@level2name=N'LearningOutcomeEvaluate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' 8)Mô tả vắn tắt nội dung học phần ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Syllabuses', @level2type=N'COLUMN',@level2name=N'ShortDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'chuan dau ra' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Syllabuses', @level2type=N'COLUMN',@level2name=N'OutcomeContent'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'bang ma tran' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Syllabuses', @level2type=N'COLUMN',@level2name=N'OutcomeMaxtrixMapping'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'chi tiet bang ma tran' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Syllabuses', @level2type=N'COLUMN',@level2name=N'OutcomeMappingDescription'
GO
