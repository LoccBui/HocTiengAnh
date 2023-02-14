create database HocTiengAnh
go
use HocTiengAnh
go

create table QUYEN (
	RoleID int IDENTITY(1,1),
	Priority tinyint,
	RoleName nvarchar(10),

	PRIMARY KEY(RoleID)
)
go

create table TAIKHOAN (
	AccountID int IDENTITY(1,1),
	Username varchar(50),
	Password varchar(50),
	Active bit,

	RoleID int,

	PRIMARY KEY (AccountID),
	FOREIGN KEY (RoleID) REFERENCES QUYEN(RoleID)
)
go



create table KHOA(
	IDFACULTY int IDENTITY(1,1),
	FacultyName nvarchar(100),

	PRIMARY KEY (IDFACULTY),
)

go


create table GIAOVIEN (
	MaGV int,
	Name nvarchar(100),
	Gender nvarchar(10),
	Email varchar(100) UNIQUE,
	DateCreated datetime,

	AccountID int,
	IDFACULTY int,

	PRIMARY KEY (MaGV),
	FOREIGN KEY (AccountID) REFERENCES TAIKHOAN(AccountID),
	FOREIGN KEY (IDFACULTY) REFERENCES KHOA(IDFACULTY)
)

go

create table LOP(
	IDCLASS int IDENTITY(1,1),
	ClassName varchar(50),
	MaGV int,

	PRIMARY KEY (IDCLASS),
	FOREIGN KEY (MaGV) REFERENCES GIAOVIEN(MaGV)
)

go

create table SINHVIEN (
	MaSV int,
	Name nvarchar(100),
	Gender nvarchar(10),
	Email varchar(100) UNIQUE,
	DateCreated datetime,

	IDCLASS int,
	AccountID int,

	PRIMARY KEY (MaSV),
	FOREIGN KEY (AccountID) REFERENCES TAIKHOAN(AccountID),
	FOREIGN KEY (IDCLASS) REFERENCES LOP(IDCLASS),
)
go

create table CHUDE (
	TopicID int IDENTITY(1,1),

	TopicName nvarchar(100),
	TopicDescribe nvarchar(200),
	QuantityWords smallint,
	Active bit,
	CreatedBy nvarchar(100)

	PRIMARY KEY (TopicID)
)

go

create table HOCCHUDE(
	ID int IDENTITY(1,1),
	AccountID int,
	TopicID int,

	PRIMARY KEY (ID),
	FOREIGN KEY (AccountID) REFERENCES TAIKHOAN(AccountID),
	FOREIGN KEY (TopicID) REFERENCES CHUDE(TopicID)
)
go 

create table TUVUNG(
	VocabID int IDENTITY(1,1),
	TopicID int,

	Frquency int,
	Word varchar(50),
	IPA varchar(100),
	Label varchar(50),
	Lemma varchar(200),
	Vietnamese nvarchar(200),
	Cluster varchar(100),
	Position varchar(100),
	Example varchar(400),
	VN_Example varchar(400),
	Resources varchar(400),

	Active bit,
	Learned bit, 
	Level tinyint,

	PRIMARY KEY (VocabID),
	FOREIGN KEY (TopicID) REFERENCES CHUDE(TopicID)
)


create table TUVUNGCANHAN(
	PersonalVocalID int IDENTITY(1,1),
	VocabID int,
	AccountID int, 

	Frquency int,
	Word varchar(50),
	IPA varchar(100),
	Label varchar(50),
	Lemma varchar(200),
	Vietnamese nvarchar(200),
	Cluster varchar(100),
	Position varchar(100),
	Example varchar(400),
	VN_Example varchar(400),
	Resources varchar(400),

	PRIMARY KEY (PersonalVocalID),
	FOREIGN KEY (VocabID) REFERENCES TUVUNG(VocabID),
	FOREIGN KEY (AccountID) REFERENCES TAIKHOAN(AccountID)
)


go

create table OTP(
	ID int IDENTITY(1,1),
	AccountID int,
	OTPCODE varchar(6),
	CreatedAt datetime,
	ExpiredAt datetime,

	PRIMARY KEY (ID),
	FOREIGN KEY (AccountID) REFERENCES TAIKHOAN(AccountID),
)

go


CREATE PROCEDURE generate_otp
  @user_id INT,
  @otp_length INT,
  @otp_validity INT
AS
BEGIN
  DECLARE @otp_code VARCHAR(255);
  DECLARE @current_time DATETIME;
  DECLARE @expire_time DATETIME;
  
  -- Tạo mã OTP ngẫu nhiên
  SET @otp_code = SUBSTRING(CONVERT(VARCHAR(255),HASHBYTES('MD5', NEWID()),2), 1, @otp_length);
  
  -- Lấy thời gian hiện tại
  SET @current_time = GETDATE();
  
  -- Tính thời gian hết hạn của OTP
  SET @expire_time = DATEADD(SECOND, @otp_validity, @current_time);
  
  -- Chèn mã OTP vào bảng OTP
  INSERT INTO otp (AccountID, OTPCODE, CreatedAt, ExpiredAt) 
  VALUES (@user_id, @otp_code, @current_time, @expire_time);
  
  -- Trả về mã OTP
  SELECT @otp_code;
END;