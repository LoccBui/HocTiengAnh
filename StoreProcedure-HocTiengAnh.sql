-- Login so sánh usesrname và pass
create procedure sp_LoginAccount
	@UserName varchar(50),
	@UserPass varchar(50)
as
BEGIN
	if exists (select AccountID from TAIKHOAN where UserName = @UserName and PWDCOMPARE(@UserPass, Password) = 1)
		begin
			select AccountID
			from TAIKHOAN
			where UserName = @UserName and PWDCOMPARE(@UserPass, Password) = 1 
		end
	else
		begin
			Select 0 as AccountID
		end
END

go



-- Phân loại user theo admin hoặc giáo viên hoặc sinh viên
alter procedure sp_AuthUser
@AccountID int
as 
BEGIN
	if EXISTS ( select * from GIAOVIEN where AccountID = @AccountID)
		begin 
			select GV.AccountID, GV.MaGV, GV.Name, TK.Email, K.IDFACULTY 
			from GIAOVIEN GV
			inner join TAIKHOAN TK on TK.AccountID = GV.AccountID
			inner join LOP L on L.MaGV = GV.MaGV
			inner join KHOA K on K.IDFACULTY = L.IDFACULTY
			where GV.AccountID = @AccountID
		end
	else 
		begin 
			select SV.AccountID, SV.MaSV, SV.Name, TK.Email, K.IDFACULTY
			from SINHVIEN SV
			inner join TAIKHOAN TK on TK.AccountID = SV.AccountID
			inner join LOP L on L.IDCLASS = SV.IDCLASS
			inner join KHOA K on K.IDFACULTY = L.IDFACULTY
			where SV.AccountID = @AccountID
		end
END
--exec sp_AuthUser 1


go

--Hiển thị tất cả chủ đề
create procedure sp_ShowAllTopic
as
select * from CHUDE

go

-- Hiển thị tất cả từ vựng
create procedure sp_SelectAllTuVung
as
select * from TUVUNG

go

--Hiển thị từ vựng theo chủ đề
create procedure sp_SelectTuVungByTopicID
@TopicID int
as
select * 
from TUVUNG
where TopicID = @TopicID

--exec sp_SelectTuVungByTopicID 3

go

--Hiển thị chủ đề theo khoa
create procedure sp_ShowTopicByFaculty
@IDFACULTY int
as
BEGIN
	select CD.TopicID, CD.TopicDescribe, CD.TopicName, CD.CreatedBy, CD.QuantityWords
	from CHUDE CD
	where CD.IDFACULTY = @IDFACULTY
END

go

-- Lọc ra khoa của User(GV,SV) lưu vào biến @IDFaculty, sau đó chạy thủ tục sau để lấy ra topic của khoa đó
create procedure sp_userFalculty
@AccountID int
as
BEGIN
	DECLARE @IDFaculty INT


	IF EXISTS (
		select *
		from SINHVIEN SV
		inner join LOP L on L.IDCLASS = SV.IDCLASS
		where SV.AccountID = @AccountID )

		begin
			select @IDFaculty = L.IDFACULTY
			from SINHVIEN SV
			inner join LOP L on L.IDCLASS = SV.IDCLASS
			where SV.AccountID = @AccountID

			exec sp_ShowTopicByFaculty @IDFaculty
		end

	ELSE 
		begin
			select @IDFaculty = L.IDFACULTY
			from GIAOVIEN GV
			inner join LOP L on L.MaGV = GV.MaGV
			where GV.AccountID = @AccountID;

			exec sp_ShowTopicByFaculty @IDFaculty
		end	
END

--exec sp_userFalculty 1
--exec sp_ShowTopicByFaculty 1


go


--Tạo mã OTP
create PROCEDURE sp_GenerateOTP
    @AccountID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Tạo mã OTP ngẫu nhiên
    DECLARE @OTP CHAR(6) = CONVERT(CHAR(6), ABS(CHECKSUM(NEWID())) % 900000 + 100000);

    -- Thêm OTP vào bảng
    INSERT INTO OTP (AccountID, OTPCode, ExpiredAt) 
    VALUES (@AccountID, @OTP, DATEADD(MINUTE, 2, GETDATE()));

    -- Xóa các mã OTP đã hết hạn
    DELETE FROM OTP WHERE ExpiredAt < GETDATE();
    
    -- Lấy thông tin OTP vừa được thêm vào bảng
    SELECT ID, AccountID, OTPCode, CreatedAt, ExpiredAt 
    FROM OTP 
    WHERE ID = SCOPE_IDENTITY();
END

--exec sp_GenerateOTP 1

go

-- kiểm tra email có tồn tại trong tài khoản ( 0 = không tồn tại, != 0 tồn tại) 
create procedure sp_CheckEmailValid
@Email varchar(100)
as
BEGIN
	DECLARE @result varchar(100)
		SET @result = @Email + '@gmail.com' 


	if EXISTS (SELECT * from TAIKHOAN  where lower(Email) like @result )
		begin
			select AccountID
			from TAIKHOAN 
			where lower(Email) like  @result
		end
	else
		begin
			select 0
			as AccountID 
		end
END

--exec sp_CheckEmailValid @Email='buihuuloc2001a@gmail.com'


go

-- xóa xong lấy mã code mới nhất theo id account và so sánh với mã nhập vào
create procedure sp_confirmOTPCode
@OTPCODE int,
@AccountID int
as 
BEGIN
	DECLARE @lastestCode INT

	DELETE FROM OTP WHERE ExpiredAt < GETDATE();

	SET @lastestCode = (select  TOP 1 OTPCODE
	from OTP
	where AccountID = @AccountID and ExpiredAt > CreatedAt
	order by CreatedAt DESC	)

	if(@lastestCode = @OTPCODE)
		begin 
			select '200' as VerifyStatus
		end
	else
		begin 
			select '404' as VerifyStatus
		end	
END
--exec sp_confirmOTPCode 977704, 1

go

--Show all class -  ADMIN ROLE
create procedure sp_ShowAllClass
as
BEGIN
	select L.IDCLASS, L.ClassName, K.FacultyName
	from LOP L
	inner join KHOA K on K.IDFACULTY = L.IDFACULTY
END

go

-- Show Faculty on Select Box - Manage Class Component
create procedure sp_SelectAllFaculty
as
BEGIN
	SELECT * FROM KHOA
END

go

-- Xóa Class theo ID
create procedure sp_DeleteClassByID
@IDClass int
as 
BEGIN
	delete 
	from LOP
	where IDCLASS = @IDClass
	SELECT @@ROWCOUNT as RowDelete
END

go

--Thêm Class mới
create procedure sp_AddNewClass
@ClassName varchar(50),
@MaGV int,
@IDFaculty int
as 
BEGIN
	declare @lastestID int
	
	set @lastestID = (SELECT MAX(IDCLASS) FROM LOP) + 1

	SET IDENTITY_INSERT LOP ON 
	
	INSERT INTO LOP(IDCLASS, ClassName, MaGV, IDFACULTY)
	VALUES(@lastestID, @ClassName, @MaGV, @IDFaculty)


	SELECT @@ROWCOUNT as RowAdd
END

--exec sp_AddNewClass '19MD222', 1, 2

go
--- lấy tất cả thông tin tài khoản
create procedure sp_SelectAllUsers
as
BEGIN
	select AccountID, UserName, Email, Active, RoleID
	from TAIKHOAN
END

go

-- thêm tài khoản mới
create PROCEDURE sp_InsertNewAccount
    @Username varchar(50),
	@Password varchar(100),
	@Email varchar(100),
	@RoleID smallint
as
BEGIN
    DECLARE @password_binary VARBINARY(100)

    -- Chuyển đổi mật khẩu sang kiểu varbinary
    SET @password_binary = PWDENCRYPT(@Password)

	INSERT INTO TAIKHOAN(Username, Password, Email, Active, RoleID)
	VALUES(@Username, @password_binary, @Email, 1, @RoleID)
END

go
--- xóa Account theo id
create procedure sp_DeleteUser
@AccountID int
as 
BEGIN
	delete 
	from TAIKHOAN
	where AccountID = @AccountID
	SELECT @@ROWCOUNT as RowDelete
END

--exec sp_DeleteUser 35
go
--Thêm một chủ đề mới
create procedure sp_AddNewTopic
@IDFACULTY int,
@TopicName nvarchar(100), 
@TopicDescribe nvarchar(200), 
@QuantityWords smallint, 
@CreatedBy nvarchar(100)
as
BEGIN
	INSERT INTO CHUDE(IDFACULTY, TopicName, TopicDescribe, QuantityWords,Active, CreatedBy)
	VALUES(@IDFACULTY, @TopicName, @TopicDescribe, @QuantityWords,1, @CreatedBy)

	SELECT @@ROWCOUNT as RowAdd
END

--exec sp_AddNewTopic 1,'Topic 2', '123', '20', 'Loc'





----------------- TESTING AREA
select* from CHUDE
select * from TUVUNG
