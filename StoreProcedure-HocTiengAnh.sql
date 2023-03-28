--drop database HocTiengAnh

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
			select GV.AccountID, GV.MaGV, GV.Name, TK.Email, K.IDFACULTY, NTK.Priority, TK.Active 
			from GIAOVIEN GV
			inner join TAIKHOAN TK on TK.AccountID = GV.AccountID
			inner join LOP L on L.MaGV = GV.MaGV
			inner join KHOA K on K.IDFACULTY = L.IDFACULTY
			inner join NHOMTK NTK on NTK.RoleID = TK.RoleID
			where GV.AccountID = @AccountID
		end
	else if EXISTS ( select * from SINHVIEN where AccountID = @AccountID)
		begin 
			select SV.AccountID, SV.MaSV, SV.Name, TK.Email, K.IDFACULTY, NTK.Priority, TK.Active  
			from SINHVIEN SV
			inner join TAIKHOAN TK on TK.AccountID = SV.AccountID
			inner join LOP L on L.IDCLASS = SV.IDCLASS
			inner join KHOA K on K.IDFACULTY = L.IDFACULTY
			inner join NHOMTK NTK on NTK.RoleID = TK.RoleID
			where SV.AccountID = @AccountID
		end
	else
		begin
			select '1' as isNewUser,AccountID, RoleID, Active from TAIKHOAN
			where AccountID =  @AccountID
		end
END
exec sp_AuthUser 8



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
alter PROCEDURE sp_InsertNewAccount
    @Username varchar(50),
	@Password varchar(100),
	@Email varchar(100),
	@RoleID smallint
as
BEGIN
    DECLARE @password_binary VARBINARY(100)
	DECLARE @check int

    -- Chuyển đổi mật khẩu sang kiểu varbinary
    SET @password_binary = PWDENCRYPT(@Password)

    IF NOT EXISTS (SELECT * FROM TAIKHOAN WHERE Username = @Username)
	BEGIN
		INSERT INTO TAIKHOAN(Username, Password, Email, Active, RoleID)
		VALUES(@Username, @password_binary, @Email, 1, @RoleID)
		set @check = (select @@ROWCOUNT) 

	END

	if(@check > 0 )
		begin 
			SELECT N'Thêm tài khoản thành công' as Status
		end
	else
		begin
			return null
		end
END

go
--- xóa Account theo id
alter procedure sp_DeleteUser
@AccountID int
as 
BEGIN
    DECLARE @check int

	delete 
	from TAIKHOAN
	where AccountID = @AccountID
	set @check = (select @@ROWCOUNT) 

	delete 
	from SINHVIEN
	where AccountID = @AccountID 

	IF(@check > 0 )
	begin 
		 SELECT N'Xóa tài khoản thành công'
	end
	ELSE
		begin
			return null
		end

END
--exec sp_DeleteUser 6

go

--Thêm một chủ đề mới
create PROCEDURE sp_AddTopic
@IdFaculty int,
@TopicName nvarchar(100), 
@TopicDescribe nvarchar(200), 
@QuantityWords smallint, 
@CreatedBy nvarchar(100)
as
BEGIN
    DECLARE @check int
    DECLARE @TopicID int

	set @TopicID =  (SELECT MAX(TopicID) FROM CHUDE) + 1

	SET IDENTITY_INSERT CHUDE ON 


	INSERT INTO CHUDE(TopicID, IDFACULTY, TopicName, TopicDescribe, QuantityWords, Active, CreatedBy)
	VALUES(@TopicID ,@IdFaculty, @TopicName, @TopicDescribe, @QuantityWords, 1, @CreatedBy)

	set @check = (select @@ROWCOUNT) 

	IF(@check > 0 )
	begin 
		 SELECT MAX(TopicID)  as Data FROM CHUDE
	end
	ELSE
		begin
			return null
		end
END


--exec sp_AddTopic 1,'Topic 2', '123', 20, 'Loc'

go

-- Xóa chủ đề theo id
create PROCEDURE sp_DeleteTopicByID
    @TopicID INT
AS
BEGIN
	DECLARE @check int

    BEGIN TRY
        UPDATE TUVUNG SET TopicID = NULL WHERE TopicID = @TopicID;
        DELETE FROM CHUDE WHERE TopicID = @TopicID;
		set @check = (select @@ROWCOUNT) 
        DELETE FROM TUVUNG WHERE TopicID = @TopicID;


		if(@check > 0)
			BEGIN 
				SELECT N'Xóa thành công' AS Status;
			END
		else 
			BEGIN 
				return null
			END
    END TRY
    BEGIN CATCH
       return null
    END CATCH
END

exec sp_DeleteTopicByID NULL

go

--Thêm từ vựng vào chủ đề mới tạo
create procedure sp_AddVocabToNewTopic
@TopicID int,
@Word varchar(50),
@IPA varchar(100),
@Label varchar(50),
@Lemma varchar(200),
@Vietnamese nvarchar(200),
@Cluster varchar(100),
@Position varchar(100),
@Example varchar(400),
@VN_Example nvarchar(400),
@Resources varchar(400)
as
BEGIN
	DECLARE @check int

	DECLARE @lastestID int

	set @lastestID =  (SELECT MAX(VocabID) FROM TUVUNG) + 1

	SET IDENTITY_INSERT TUVUNG ON 

	INSERT INTO TUVUNG(VocabID, TopicID, Frequency, Word, IPA, Label, Lemma, Vietnamese, Cluster, Position, Example, VN_Example, Resources, Active, Learned, Level)
	VALUES(@lastestID, @TopicID, 0, @Word, @IPA, @Label, @Lemma, @Vietnamese, @Cluster, @Position, @Example, @VN_Example, @Resources, 1, 0, 0)

	set @check = (select @@ROWCOUNT) 

	if(@check > 0 )
		begin 
			SELECT N'Thêm thành công' as Status
		end
	else
		begin
			return null
		end
END


go
-- Cập nhật từ vựng của chủ đề
create procedure sp_UpdateVocab
@VocabID int,
@TopicID int,

@Word varchar(50), @IPA varchar(100), @Label varchar(50),
@Lemma varchar(200), @Vietnamese nvarchar(200), @Cluster varchar(100),
@Position varchar(100), @Example varchar(400), @VN_Example nvarchar(400),
@Resources varchar(400), @Active bit
as
BEGIN
	DECLARE @check int

	UPDATE TUVUNG
	SET Word = @Word, IPA = @IPA, Label = @Label,
		Lemma = @Lemma, Vietnamese = @Vietnamese, Cluster = @Cluster,
		Position = @Position, Example = @Example, VN_Example = @VN_Example,
		Resources = @Resources, Active = @Active
	WHERE VocabID = @VocabID and TopicID = @TopicID

	set @check = (select @@ROWCOUNT) 

	if(@check > 0 )
		begin 
			SELECT N'Cập nhật thành công' as Status
		end
	else
		begin
			return null
		end
END


-- Cập nhập thông tin chủ đề
go
create procedure sp_UpdateTopic
@TopicID int, 
@TopicName nvarchar(100),
@TopicDescribe nvarchar(200)
as
BEGIN
	DECLARE @QuantityWords smallint
	DECLARE @check int


	-- kiểm tra lại tổng từ --> phòng trường hợp đã xóa hoặc thêm từ
	set @QuantityWords = (select COUNT(VocabID) From TUVUNG where TopicID = @TopicID)

	UPDATE CHUDE
	SET	TopicName =  @TopicName,
		TopicDescribe  = @TopicDescribe,
		QuantityWords = @QuantityWords
	where TopicID = @TopicID

	set @check = (select @@ROWCOUNT) 

	if(@check > 0 )
		begin 
			SELECT N'Cập nhật chủ đề thành công' as Status
		end
	else
		begin
			return null
		end
END

--exec sp_UpdateTopic 
--@TopicID = 4,
--@TopicName = N'Học thêm',
--@TopicDescribe= N'Học thêm miêu tả'


go


--Tạo tài khoản mới
alter PROCEDURE sp_AddNewUser
    @Username VARCHAR(50),
    @Password VARCHAR(100),
    @Email VARCHAR(100),
    @RoleID SMALLINT
AS
BEGIN 
    DECLARE @lastestID INT
	DECLARE @check int
    DECLARE @password_binary VARBINARY(100)

    SET @lastestID = (SELECT MAX(AccountID) FROM TAIKHOAN) + 1
    SET @password_binary = PWDENCRYPT(@Password)-- Chuyển đổi mật khẩu sang kiểu varbinary

	SET IDENTITY_INSERT TAIKHOAN ON 

    IF NOT EXISTS (SELECT * FROM TAIKHOAN WHERE Username = @Username)
    BEGIN
        INSERT INTO TAIKHOAN (AccountID, Username, Password, Email, Active, RoleID)
        VALUES (@lastestID, @Username, @password_binary, @Email, 0, @RoleID)

		set @check = (select @@ROWCOUNT) 
    END

	if(@check > 0 )
		begin 
			SELECT N'Thêm tài khoản thành công' as Status
		end
	else
		begin
			return null
		end
END

--exec sp_AddNewUser
--    @Username  = '12323',
--    @Password = '12323',
--    @Email = '12323@gmail.com',
--    @RoleID = 1
go

alter PROCEDURE sp_AddNewGiaoVien
    @Username VARCHAR(50),
    @Password VARCHAR(100),
    @Email VARCHAR(100),
    @RoleID SMALLINT
AS
BEGIN 
    DECLARE @lastestID INT
	DECLARE @check int
    DECLARE @password_binary VARBINARY(100)

    SET @lastestID = (SELECT MAX(AccountID) FROM TAIKHOAN) + 1
    SET @password_binary = PWDENCRYPT(@Password)-- Chuyển đổi mật khẩu sang kiểu varbinary

	SET IDENTITY_INSERT TAIKHOAN ON 

    IF NOT EXISTS (SELECT * FROM TAIKHOAN WHERE Username = @Username)
    BEGIN
        INSERT INTO TAIKHOAN (AccountID, Username, Password, Email, Active, RoleID)
        VALUES (@lastestID, @Username, @password_binary, @Email, 0, @RoleID)

		set @check = (select @@ROWCOUNT) 
    END

	if(@check > 0 )
		begin 
			SELECT N'Thêm tài khoản thành công' as Status
		end
	else
		begin
			return null
		end
END



go

alter procedure sp_AddNewSinhVien
@AccountID int,
@Name nvarchar(100),
@Gender nvarchar(10),
@IDCLASS int
as
BEGIN
	DECLARE @check int
    DECLARE @lastestMaSV INT

    SET @lastestMaSV = (SELECT MAX(MaSV) FROM SINHVIEN) + 1

	UPDATE TAIKHOAN
	SET Active = 1
	where AccountID = @AccountID


	INSERT INTO SINHVIEN(MaSV, AccountID, Name, Gender, DateCreated, IDCLASS)
	VALUES (@lastestMaSV, @AccountID, @Name, @Gender, GETDATE(), @IDCLASS)
	set @check = (select @@ROWCOUNT) 

	if(@check > 0 )
		begin 
			SELECT N'Cập nhật thông tin tài khoản thành công' as Status
		end
	else
		begin
			return null
		end
END

go
--Cập nhật thông tin giáo viên
create procedure sp_AddInfoGiaoVien
@AccountID int,
@Name nvarchar(100),
@Gender nvarchar(10)
as
BEGIN
	DECLARE @check int
    DECLARE @lastestMaGV INT

    SET @lastestMaGV = (SELECT MAX(MaGV) FROM GIAOVIEN) + 1

	UPDATE TAIKHOAN
	SET Active = 1
	where AccountID = @AccountID


	INSERT INTO GIAOVIEN(MaGV, AccountID, Name, Gender, DateCreated)
	VALUES (@lastestMaGV, @AccountID, @Name, @Gender, GETDATE())
	set @check = (select @@ROWCOUNT) 

	if(@check > 0 )
		begin 
			SELECT N'Cập nhật thông tin giáo viên thành công' as Status
		end
	else
		begin
			return null
		end
END

go

--Lọc lớp theo id khoa
create procedure sp_FilterClassByFacultyID
@IDFACULTY int
as
BEGIN
	select IDCLASS, ClassName
	from LOP 
	where IDFACULTY = @IDFACULTY

END


-- lấy username dựa vào email
alter procedure sp_GetUsername
@Email varchar(100)
as
BEGIN
	DECLARE @check int
	DECLARE @result varchar(100)

	set @result = (select Username
	from TAIKHOAN
	where Email like @Email)
	set @check = (select @@ROWCOUNT) 

	if(@check > 0 )
		begin 
			select @result as Username
		end
	else
		begin
			return null
		end
END







----------------- TESTING AREA
select* from CHUDE
select * from TUVUNG



select * from LOP
select * from GIAOVIEN

select * from NHOMTK
select * from TAIKHOAN

select * from SINHVIEN
select * from KHOA


