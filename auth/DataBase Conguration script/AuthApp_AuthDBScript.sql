USE [master]
GO
/****** Object:  Database [AuthDB]    Script Date: 28-09-2025 18:43:28 ******/
CREATE DATABASE [AuthDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'AuthDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\AuthDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'AuthDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\AuthDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [AuthDB] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AuthDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [AuthDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [AuthDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [AuthDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [AuthDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [AuthDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [AuthDB] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [AuthDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [AuthDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [AuthDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [AuthDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [AuthDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [AuthDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [AuthDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [AuthDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [AuthDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [AuthDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [AuthDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [AuthDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [AuthDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [AuthDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [AuthDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [AuthDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [AuthDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [AuthDB] SET  MULTI_USER 
GO
ALTER DATABASE [AuthDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [AuthDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [AuthDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [AuthDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [AuthDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [AuthDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [AuthDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [AuthDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [AuthDB]
GO
/****** Object:  User [AuthUser]    Script Date: 28-09-2025 18:43:28 ******/
CREATE USER [AuthUser] FOR LOGIN [AuthUser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [AuthUser]
GO
/****** Object:  Table [dbo].[Login]    Script Date: 28-09-2025 18:43:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Login](
	[LoginId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[Username] [varchar](50) NOT NULL,
	[PasswordHash] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[LoginId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoginDetails]    Script Date: 28-09-2025 18:43:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoginDetails](
	[LoginId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[Username] [varchar](50) NULL,
	[LoginTime] [datetime] NULL,
	[IpAddress] [varchar](50) NULL,
	[DeviceInfo] [varchar](200) NULL,
	[Status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[LoginId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SessionToken]    Script Date: 28-09-2025 18:43:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SessionToken](
	[TokenId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[Token] [varchar](255) NOT NULL,
	[IpAddress] [varchar](50) NULL,
	[ExpiryTime] [datetime] NOT NULL,
	[CreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[TokenId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Token] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserDetails]    Script Date: 28-09-2025 18:43:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserDetails](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [varchar](100) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[PhoneNumber] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LoginDetails] ADD  DEFAULT (getdate()) FOR [LoginTime]
GO
ALTER TABLE [dbo].[SessionToken] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Login]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[UserDetails] ([UserId])
GO
ALTER TABLE [dbo].[LoginDetails]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[UserDetails] ([UserId])
GO
ALTER TABLE [dbo].[SessionToken]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[UserDetails] ([UserId])
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateUser_Alt]    Script Date: 28-09-2025 18:43:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CreateUser_Alt]
    @FullName VARCHAR(100),
    @Email VARCHAR(100),
    @PhoneNumber VARCHAR(20),
    @Username VARCHAR(50),
    @PasswordHash VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NewUserId TABLE (UserId INT);

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insert user and capture UserId
        INSERT INTO UserDetails (FullName, Email, PhoneNumber)
        OUTPUT INSERTED.UserId INTO @NewUserId
        VALUES (@FullName, @Email, @PhoneNumber);

        DECLARE @UserId INT;
        SELECT @UserId = UserId FROM @NewUserId;

        -- Insert login using captured UserId
        INSERT INTO Login (UserId, Username, PasswordHash)
        VALUES (@UserId, @Username, @PasswordHash);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteSession]    Script Date: 28-09-2025 18:43:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteSession]
    @Token VARCHAR(255),
    @RequestIp VARCHAR(50) = NULL
AS
BEGIN
    DELETE FROM SessionToken
    WHERE Token = @Token
    AND (@RequestIp IS NULL OR IpAddress = @RequestIp);
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUserByToken]    Script Date: 28-09-2025 18:43:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetUserByToken]
    @Token VARCHAR(255),
    @RequestIp VARCHAR(50) = NULL  -- optional: the IP of the incoming request
AS
BEGIN
    SET NOCOUNT ON;

    -- 1️ Update the session expiry by 1 hour if token is valid and not expired
    UPDATE SessionToken
    SET ExpiryTime = DATEADD(HOUR, 1, GETDATE())
    WHERE Token = @Token
      AND ExpiryTime > GETDATE()  -- token not expired
      AND (@RequestIp IS NULL OR IpAddress = @RequestIp);

    -- 2️ Return the user and session info
    SELECT 
        u.UserId, 
        u.FullName, 
        u.Email, 
        u.PhoneNumber, 
        s.IpAddress AS SessionIp, 
        s.ExpiryTime
    FROM SessionToken s
    JOIN UserDetails u ON s.UserId = u.UserId
    WHERE s.Token = @Token
      AND s.ExpiryTime > GETDATE()  -- check token is still valid
      AND (@RequestIp IS NULL OR s.IpAddress = @RequestIp);
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ValidateLogin_Secure]    Script Date: 28-09-2025 18:43:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ValidateLogin_Secure]
    @Username VARCHAR(50),
    @PasswordHash VARCHAR(255), -- already hashed
    @IpAddress VARCHAR(50),
    @Token VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId INT;

    -- 1️ Validate login
    SELECT @UserId = l.UserId
    FROM Login l
    WHERE l.Username = @Username
      AND l.PasswordHash = @PasswordHash;

    IF @UserId IS NOT NULL
    BEGIN

        SELECT TOP 1 @Token=[Token] FROM [AuthDB].[dbo].[SessionToken] WHERE [UserId]=@UserId AND [ExpiryTime] > GETDATE() AND [IpAddress]=@IpAddress;
        IF @Token IS NULL
        BEGIN
        -- 2️ Generate secure token
        DECLARE @RawToken NVARCHAR(100) = CONVERT(NVARCHAR(36), NEWID()) 
                                         + CAST(GETDATE() AS NVARCHAR(50));

        DECLARE @HashedToken VARBINARY(32) = HASHBYTES('SHA2_256', @RawToken);

        SET @Token = LOWER(CONVERT(VARCHAR(64), @HashedToken, 2));
        

        -- 3️ Insert into SessionToken
        INSERT INTO SessionToken(UserId, Token, IpAddress, ExpiryTime)
        VALUES (@UserId, @Token, @IpAddress, DATEADD(HOUR, 1, GETDATE()));

        -- 4️ Log successful login
        INSERT INTO LoginDetails(UserId, Username, IpAddress, Status)
        VALUES (@UserId, @Username, @IpAddress, 1);
        END
        -- 5️ Return success
        SELECT 1 AS Status, @Token AS SessionToken, @UserId AS UserId;
    END
    ELSE
    BEGIN
        -- 6️ Log failed login
        INSERT INTO LoginDetails(UserId, Username, IpAddress, Status)
        VALUES (@UserId, @Username, @IpAddress, 0);

        -- 7️ Return failure
        SET @Token = NULL;
        SELECT 0 AS Status;
    END
END
GO
USE [master]
GO
ALTER DATABASE [AuthDB] SET  READ_WRITE 
GO
