
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
create procedure sp_AuthUser
@AccountID int
as 
BEGIN
	if EXISTS ( select * from GIAOVIEN where AccountID = @AccountID)
		begin 
			select GV.AccountID, GV.MaGV, TK.Name, TK.Email, K.IDFACULTY, NTK.Priority, TK.Active, TK.Image 
			from GIAOVIEN GV
			inner join TAIKHOAN TK on TK.AccountID = GV.AccountID
			inner join CHITIETLOP CTL on CTL.MaGV = GV.MaGV
			inner join LOP L on L.IDCLASS = CTL.IDCLASS
			inner join KHOA K on K.IDFACULTY = L.IDFACULTY
			inner join NHOMTK NTK on NTK.RoleID = TK.RoleID
			where GV.AccountID = @AccountID
		end
	else if EXISTS ( select * from SINHVIEN where AccountID = @AccountID)
		begin 
			select SV.AccountID, SV.MaSV, TK.Name, TK.Email, K.IDFACULTY, NTK.Priority, TK.Active, TK.Image  
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
select TOP 5 *
from TUVUNG
where TopicID = @TopicID and Learned = 0

go

create PROCEDURE testHocTU
@AccountID int,
@TopicID int
AS
BEGIN
	DECLARE @level tinyint	
	
	IF EXISTS(SELECT CTH.Level FROM TUVUNG TV
		inner join CHITIETHOC CTH on CTH.VocabID = TV.VocabID
		where AccountID = @AccountID and CTH.TopicID = @TopicID)
	begin
		SELECT @level = CTH.Level FROM TUVUNG TV
		inner join CHITIETHOC CTH on CTH.VocabID = TV.VocabID
		where AccountID = @AccountID and CTH.TopicID = @TopicID

		if(@level > 5 )
		begin
			return null
		end
		else
		begin
			select TOP 5 TV.VocabID,TV.TopicID, TV.Word
			from  TUVUNG TV
			LEFT JOIN CHITIETHOC CTH on CTH.TopicID = TV.TopicID
			where CTH.Level < 5 OR CTH.Level IS NULL
		end
	end
	ELSE
	begin
		return null
	end
END


--exec testHocTU
--@AccountID = 1,
--@TopicID = 4


go

create procedure sp_ShowDetailVocab
@TopicID int
as
BEGIN
	select *
	from TUVUNG
	where TopicID = @TopicID and Learned = 0
END

go

--Hiển thị chủ đề theo khoa
create procedure sp_ShowTopicByFaculty
@IDFACULTY tinyint
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
			inner join CHITIETLOP CT on CT.MaSV = SV.MaSV
			inner join LOP L on L.IDCLASS = CT.IDCLASS
			inner join KHOA K on K.IDFACULTY = L.IDFACULTY
			where SV.AccountID = @AccountID

			exec sp_ShowTopicByFaculty @IDFaculty
		end

	ELSE 
		begin
			select DISTINCT @IDFaculty = L.IDFACULTY
			from GIAOVIEN GV
			inner join CHITIETLOP CT on CT.MaGV = GV.MaGV
			inner join LOP L on L.IDCLASS = CT.IDCLASS
			inner join KHOA K on K.IDFACULTY = L.IDFACULTY
			where GV.AccountID = @AccountID;

			exec sp_ShowTopicByFaculty @IDFaculty
		end	
END

exec sp_userFalculty 2


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
@IDClass smallint
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
@IDFaculty tinyint
as 
BEGIN
	declare @lastestID int
	
	set @lastestID = COALESCE((SELECT MAX(IDCLASS) FROM LOP),1) + 1

	SET IDENTITY_INSERT LOP ON 
	
	INSERT INTO LOP(IDCLASS, ClassName, IDFACULTY)
	VALUES(@lastestID, @ClassName, @IDFaculty)


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
	@RoleID tinyint
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
create procedure sp_DeleteUser
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
@IdFaculty tinyint,
@TopicName nvarchar(100), 
@TopicDescribe nvarchar(200), 
@QuantityWords smallint, 
@CreatedBy nvarchar(100)
as
BEGIN
    DECLARE @check int
    DECLARE @TopicID int

	set @TopicID =  COALESCE((SELECT MAX(TopicID) FROM CHUDE),0) + 1

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

    DELETE FROM TUVUNG WHERE TopicID = @TopicID;
    DELETE FROM CHUDE WHERE TopicID = @TopicID;
	set @check = (select @@ROWCOUNT) 

	if(@check > 0)
		BEGIN 
			SELECT N'Xóa thành công' AS Status;
		END
	else 
		BEGIN 
			return null
		END
END

  
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

	set @lastestID =  COALESCE((SELECT MAX(VocabID) FROM TUVUNG), 0) + 1;

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

--exec sp_AddVocabToNewTopic
--@TopicID = 1,
--@Word='test',
--@IPA ='test',
--@Label ='test',
--@Lemma ='test',
--@Vietnamese='test',
--@Cluster ='test',
--@Position ='test',
--@Example='test',
--@VN_Example ='test',
--@Resources ='test'



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
create PROCEDURE sp_AddNewUser
    @Username VARCHAR(50),
    @Password VARCHAR(100),
    @Email VARCHAR(100),
    @RoleID tinyint
AS
BEGIN 
    DECLARE @lastestID INT
	DECLARE @check int
    DECLARE @password_binary VARBINARY(100)

    SET @lastestID = COALESCE((SELECT MAX(AccountID) FROM TAIKHOAN) , 0) + 1
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

create PROCEDURE sp_AddNewGiaoVien
    @Username VARCHAR(50),
    @Password VARCHAR(100),
    @Email VARCHAR(100),
    @RoleID tinyint
AS
BEGIN 
    DECLARE @lastestID INT
	DECLARE @check int
    DECLARE @password_binary VARBINARY(100)

    SET @lastestID = COALESCE((SELECT MAX(AccountID) FROM TAIKHOAN),0) + 1
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

create procedure sp_AddNewSinhVien
@AccountID int,
@Gender nvarchar(10),
@IDCLASS smallint
as
BEGIN
	DECLARE @check int
    DECLARE @lastestMaSV INT

    SET @lastestMaSV = COALESCE((SELECT MAX(MaSV) FROM SINHVIEN), 0) + 1

	UPDATE TAIKHOAN
	SET Active = 1
	where AccountID = @AccountID


	INSERT INTO SINHVIEN(MaSV, AccountID, Gender, DateCreated, IDCLASS)
	VALUES (@lastestMaSV, @AccountID, @Gender, GETDATE(), @IDCLASS)
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
@Gender nvarchar(10)
as
BEGIN
	DECLARE @check int
    DECLARE @lastestMaGV INT

    SET @lastestMaGV = (SELECT MAX(MaGV) FROM GIAOVIEN) + 1

	UPDATE TAIKHOAN
	SET Active = 1
	where AccountID = @AccountID

	if not EXISTS (select * from GIAOVIEN where AccountID = @AccountID)
	BEGIN
		INSERT INTO GIAOVIEN(MaGV, AccountID, Gender, DateCreated)
		VALUES (@lastestMaGV, @AccountID, @Gender, GETDATE())
		set @check = (select @@ROWCOUNT) 
	END

	if(@check > 0 )
		begin 
			SELECT MaGV from GIAOVIEN where AccountID = @AccountID
		end
	else
		begin
			return null
		end
END

go

create procedure sp_AddGiaoVienToClass
@ClassName varchar(50),
@IDFACULTY tinyint
as
BEGIN 
	DECLARE @check int
    DECLARE @lastestIDCLASS INT

    SET @lastestIDCLASS = COALESCE((SELECT MAX(IDCLASS) FROM LOP),0) + 1
	SET IDENTITY_INSERT LOP ON 


	INSERT INTO LOP(IDCLASS, ClassName, IDFACULTY)
	VALUES(@lastestIDCLASS, @ClassName, @IDFACULTY )
	set @check = (select @@ROWCOUNT) 

	if(@check > 0 )
	begin 
			SELECT N'Thêm giáo viên vào lớp thành công'
		end
	else
		begin
			return null
		end
END

go

--Lọc lớp theo id khoa
create procedure sp_FilterClassByFacultyID
@IDFACULTY tinyint
as
BEGIN
	select DISTINCT ClassName, IDCLASS
	from LOP 
	where IDFACULTY = @IDFACULTY
END

go

-- lấy username dựa vào email
create procedure sp_GetUsername
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

go
--Logic Học từ
create procedure sp_GetDataListenAndChoose
@Word varchar(50)
as
BEGIN
	DECLARE @firstCharacter varchar(1)

	SET @firstCharacter = (LEFT(@Word,1))

	select distinct Word
	from TUVUNG
    WHERE Word LIKE '%' + @firstCharacter + '%' and Word not like @Word
END


go

--Choose right meaning -> Chọn đúng nghĩa của từ
create procedure sp_GetVietNameseRightMeaning
@Word varchar(50),
@Vietnamese nvarchar(200)
as
BEGIN
	DECLARE @firstCharacter varchar(1)

	SET @firstCharacter = (LEFT(@Vietnamese,1))

	select TOP 20 Word, Vietnamese
	from TUVUNG
	where  Vietnamese like '%' + @firstCharacter + '%'
END

go

--QUẢN LÝ TÀI KHOẢN

create procedure sp_GetDataAccount
@AccountID int
as 
BEGIN
	if EXISTS ( select * from GIAOVIEN where AccountID = @AccountID)
		begin 
			select GV.AccountID, GV.MaGV,  TK.Name, GV.Gender, TK.Email, L.ClassName, K.FacultyName, TK.Image, TK.RoleID, NTK.Priority
			from GIAOVIEN GV
			inner join TAIKHOAN TK on TK.AccountID = GV.AccountID
			inner join CHITIETLOP CTL on CTL.MaGV = CTL.MaGV
			inner join LOP L on L.IDCLASS = CTL.IDCLASS
			inner join KHOA K on K.IDFACULTY = L.IDFACULTY
			inner join NHOMTK NTK on NTK.RoleID = TK.RoleID
			where GV.AccountID = @AccountID
		end
	else if EXISTS ( select * from SINHVIEN where AccountID = @AccountID)
		begin 
			select SV.AccountID, SV.MaSV, TK.Name, SV.Gender, TK.Email, L.ClassName, K.FacultyName, TK.Image, TK.RoleID, NTK.Priority
			from SINHVIEN SV
			inner join TAIKHOAN TK on TK.AccountID = SV.AccountID
			inner join CHITIETLOP CTL on CTL.MaGV = CTL.MaGV
			inner join LOP L on L.IDCLASS = CTL.IDCLASS
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

go

create procedure sp_ChangeAvatar
@AccountID int,
@Image varchar(200)
as
BEGIN
	DECLARE @check int

	UPDATE TAIKHOAN
	SET Image = @Image
	WHERE AccountID = @AccountID
	set @check = (select @@ROWCOUNT) 

	if(@check > 0 )
		begin 
			SELECT N'Cập nhật ảnh đại diện thành công'
		end
	else
		begin
			return null
		end
END

go

create procedure sp_ChangePassword
@Password varchar(100),
@AccountID  int
as
BEGIN
    DECLARE @password_binary VARBINARY(100)
	DECLARE @check int

	
    -- Chuyển đổi mật khẩu sang kiểu varbinary
    SET @password_binary = PWDENCRYPT(@Password )

	UPDATE TAIKHOAN
	SET Password = @password_binary
	WHERE AccountID = @AccountID
	set @check = (select @@ROWCOUNT) 

	if(@check > 0 )
		begin 
			SELECT N'Đổi mật khẩu thành công' as Status
		end
	else
		begin
			return null
		end
END
exec sp_ChangePassword '123', 1

	


go
--Update bảng tài khoản 
create procedure sp_UpdateInfoAccount
@AccountID int,
@Email varchar(100),
@Name nvarchar(100)
as
BEGIN
	DECLARE @check int
	
	UPDATE TAIKHOAN 
	SET Email = @Email, Name = @Name
	WHERE AccountID = @AccountID

	set @check = (select @@ROWCOUNT) 

	if(@check > 0 )
		begin 
			SELECT N'Cập nhật thông tin tài khoản thành công'
		end
	else
		begin
			return null
		end
END

go

--Update dữ liệu tài khoản GIÁO VIÊN
create procedure sp_UpdateInfoAccountGiaoVien
@MaGV smallint,
@Gender nvarchar(10)
as
BEGIN
	DECLARE @check int
	 
	UPDATE GIAOVIEN
	SET Gender = @Gender
	where MaGV = @MaGV
	set @check = (select @@ROWCOUNT) 
	
	if(@check > 0 )
		begin 
			SELECT N'Cập nhật thông tin tài khoản thành công'
		end
	else
		begin
			return null
		end
END


go

--Update dữ liệu tài khoản SINH VIÊN

create procedure sp_UpdateInfoAccountSinhVien
@MaSV int,
@Gender nvarchar(10)
as
BEGIN
	DECLARE @check int

	UPDATE SINHVIEN
	SET Gender = @Gender
	where MaSV = @MaSV
	set @check = (select @@ROWCOUNT) 

	if(@check > 0 )
		begin 
			SELECT N'Cập nhật thông tin tài khoản thành công'
		end
	else
		begin
			return null
		end
END

go

-- CHI TIẾT LỚP
create procedure sp_ShowDetailClass
@IDCLASS smallint
as
BEGIN
	DECLARE @check int

	select CTL.DetailID, SV.MaSV, TK.Name, SV.Gender, CTL.IsApproved
	from CHITIETLOP CTL
	inner join SINHVIEN SV on SV.MaSV = CTL.MaSV
	inner join TAIKHOAN TK on TK.AccountID = SV.AccountID
	where CTL.IDCLASS = @IDCLASS

	set @check = (select @@ROWCOUNT) 

	if(@check < 0 )
		begin 
			return null
		end

END

go

create procedure sp_UpdateApprovedStudent
@DetailID int
as
BEGIN
	DECLARE @check int
	UPDATE CHITIETLOP 	
	SET IsApproved = 1
	where DetailID = @DetailID

	set @check = (select @@ROWCOUNT) 

	if(@check > 0 )
		begin 
			SELECT N'Cập nhật phê duyệt thành công'
		end
	else
		begin
			return null
		end
END

go

create procedure sp_AddClass
@ClassName varchar(50),
@FacultyName nvarchar(100)
as
BEGIN

  DECLARE @lastestIDCLASS INT
  DECLARE @findIDFACULTY INT
  DECLARE @check int

  SET @lastestIDCLASS = COALESCE((SELECT MAX(IDCLASS) FROM LOP),0) + 1

  set @findIDFACULTY = (SELECT IDFACULTY FROM KHOA WHERE FacultyName like @FacultyName)
  
  IF NOT EXISTS (SELECT * FROM LOP WHERE ClassName = @ClassName)
	BEGIN
		SET IDENTITY_INSERT LOP ON 

	  INSERT INTO LOP(IDCLASS, ClassName, IDFACULTY)
	  VALUES(@lastestIDCLASS, @ClassName, @findIDFACULTY)
	  set @check = (select @@ROWCOUNT) 
    END

	if(@check > 0 )
		begin 
			SELECT N'Thêm lớp thành công'
		end
	else
		begin
			return null
		end
END

go

create procedure sp_GetRanking
@TopicID int
as
BEGIN 
		SELECT CHITIETHOC.AccountID, TK.Name, TK.Image, SUM(Score) AS TotalScore
		FROM CHITIETHOC
		INNER JOIN TAIKHOAN TK ON TK.AccountID = CHITIETHOC.AccountID
		WHERE TopicID = @TopicID
		GROUP BY CHITIETHOC.AccountID, TK.Name, TK.Image
		ORDER BY TotalScore DESC
END

go

create procedure sp_MostWrongWordByTopic
@TopicID int
as
BEGIN
    DECLARE @check int
	
	select CHITIETHOC.VocabID, TV.Word, SUM(WrongTimes) as TotalWrong
	from CHITIETHOC 
	inner join TUVUNG TV on TV.VocabID = CHITIETHOC.VocabID
	where CHITIETHOC.TopicID = @TopicID
	group by CHITIETHOC.VocabID, TV.Word
	order by TotalWrong desc

	set @check = (select @@ROWCOUNT) 
	if(@check > 0 )
		begin 
			SELECT N'Thành công'
		end
	else
		begin
			return null
		end
END

go

create procedure sp_MostScoreInTopic
@TopicID int
as
BEGIN
    DECLARE @check int

	select CHITIETHOC.AccountID, TK.Name, L.ClassName, SUM(Score) as TotalScore
	from CHITIETHOC 
	inner join TUVUNG TV on TV.VocabID = CHITIETHOC.VocabID
	inner join TAIKHOAN TK on TK.AccountID = CHITIETHOC.AccountID
	inner join SINHVIEN SV on SV.AccountID = TK.AccountID
	inner join LOP L on L.IDCLASS = SV.IDCLASS
	where CHITIETHOC.TopicID = @TopicID
	group by CHITIETHOC.AccountID, TK.Name, L.ClassName
	order by TotalScore desc

	set @check = (select @@ROWCOUNT) 
	if(@check > 0 )
		begin 
			SELECT N'Thành công'
		end
	else
		begin
			return null
		end
END

go

create procedure sp_GetPersonalWordCollection
@AccountID int
as
BEGIN
    DECLARE @check int

	select PersonalVocabID, PersonalVocabName, IsDefault
	from TUVUNGCANHAN
	where AccountID = @AccountID
	set @check = (select @@ROWCOUNT) 

	if(@check > 0 )
		begin 
			SELECT N'Thành công'
		end
	else
		begin
			return null
		end
END

go

create procedure sp_AddToPersonalVocab
@PersonalVocabID int, 
@VocabID int, 
@AccountID int
as
BEGIN
	DECLARE @check int
	INSERT INTO CHITIETTUCANHAN(PersonalVocabID, VocabID, AccountID)
	VALUES(@PersonalVocabID, @VocabID, @AccountID)
	
	set @check = (select @@ROWCOUNT) 
	if(@check > 0 )
		begin 
			SELECT N'Thành công'
		end
	else
		begin
			return null
		end

END

go

create procedure sp_CheckWordPersonExists
@PersonalVocabID int, 
@VocabID int, 
@AccountID int
as
BEGIN
	IF EXISTS(select * from CHITIETTUCANHAN where AccountID = @AccountID and PersonalVocabID = @PersonalVocabID and VocabID = @VocabID)
		BEGIN
			Select VocabID as VocabExists 
			from CHITIETTUCANHAN  
			where AccountID = @AccountID and PersonalVocabID = @PersonalVocabID and VocabID = @VocabID
		END
	ELSE
		BEGIN
			Select '0' as VocabExists 
		END
END


go

create procedure sp_UpdateDefaultPersonalVocab
@AccountID int,
@PersonalVocabID int
as
BEGIN
	DECLARE @check int
	UPDATE TUVUNGCANHAN SET IsDefault = 0 where AccountID = 1

	UPDATE TUVUNGCANHAN SET IsDefault = 1
	where AccountID = @AccountID and PersonalVocabID = @PersonalVocabID

	set @check = (select @@ROWCOUNT) 
	if(@check > 0 )
		begin 
			SELECT N'Thành công'
		end
	else
		begin
			return null
		end
END


go

create procedure sp_CreateNewPersonalVocab
@AccountID int,
@PersonalVocabName nvarchar(200)
as
BEGIN
	DECLARE @check int

	INSERT INTO TUVUNGCANHAN(PersonalVocabName, AccountID)
	VALUES(@PersonalVocabName, @AccountID)
	set @check = (select @@ROWCOUNT) 

	if(@check > 0 )
		begin 
			SELECT N'Thành công'
		end
	else
		begin
			return null
		end
END

go

create procedure sp_SelectAllPersonalVocab
@AccountID int
as
BEGIN
	DECLARE @check int
	select * from TUVUNGCANHAN where AccountID = @AccountID

	set @check = (select @@ROWCOUNT) 

	if(@check > 0 )
		begin 
			SELECT N'Thành công'
		end
	else
		begin
			return null
		end
END

go

create procedure sp_DeletePersonalVocab
@AccountID int,
@PersonalVocabID int 
as
BEGIN

	DELETE from TUVUNGCANHAN where AccountID = @AccountID and PersonalVocabID = @PersonalVocabID
	SELECT @@ROWCOUNT as RowDelete

END

go

create procedure sp_SelectVocabFromCollection
@AccountID int,
@PersonalVocabID int 
as
BEGIN
	DECLARE @check int

	select CT.PersonalDetailID, TVCN.PersonalVocabID, TVCN.PersonalVocabName, CT.VocabID, TV.Word, TV.IPA, TV.Label, TV.Lemma, TV.Vietnamese, TV.Cluster, TV.Position, TV.Example, TV.VN_Example
	from TUVUNGCANHAN TVCN
	inner join CHITIETTUCANHAN CT on TVCN.PersonalVocabID = CT.PersonalVocabID
	inner join TUVUNG TV on TV.VocabID = CT.VocabID
	where CT.AccountID = @AccountID and CT.PersonalVocabID = @PersonalVocabID

	set @check = (select @@ROWCOUNT) 

	if(@check > 0 )
		begin 
			SELECT N'Thành công'
		end
	else
		begin
			return null
		end
END

go

create procedure sp_DeleteVocabOfPerson
@AccountID int,
@PersonalDetailID int
as
BEGIN 
	DELETE FROM CHITIETTUCANHAN
	where AccountID = @AccountID and PersonalDetailID = @PersonalDetailID
	SELECT @@ROWCOUNT as RowDelete
END

go

create procedure sp_ChangePersonalVocabName
@PersonalVocabID int,
@PersonalVocabName nvarchar(200)
as
BEGIN
	UPDATE TUVUNGCANHAN
	SET PersonalVocabName = @PersonalVocabName
	where PersonalVocabID = @PersonalVocabID
	SELECT @@ROWCOUNT as RowDelete
END


go

create PROCEDURE sp_GetStatusLearning
    @AccountID int,
    @TopicID int
AS
BEGIN 
    DECLARE @learned tinyint
    DECLARE @total tinyint

    SET @total = (SELECT COUNT(*) FROM TUVUNG WHERE TopicID = @TopicID)
	
    SELECT @learned = COUNT(*) FROM CHITIETHOC WHERE AccountID = @AccountID AND TopicID = @TopicID
    
    SELECT @TopicID as TopicID,  @learned AS Learned, @total AS Total
END

go

create PROCEDURE sp_GetStatusPersonalLearning
    @AccountID int,
    @TopicID int
AS
BEGIN 
    DECLARE @learned tinyint
    DECLARE @total tinyint

    SET @total = (SELECT COUNT(*) FROM TUVUNGCANHAN WHERE AccountID = @AccountID)
	
    SELECT @learned = COUNT(*) FROM [dbo].[CHITIETTUCANHAN] WHERE AccountID = @AccountID
    
    SELECT @TopicID as PersonalTopicID,  @learned AS Learned, @total AS Total
END

go

create procedure sp_AddVocabToDetailLearning
@AccountID int, 
@VocabID int,
@TopicID int,
@Level tinyint,
@WrongTimes smallint,
@Score int
as
BEGIN
	DECLARE @check int
	
	IF EXISTS( select * from CHITIETHOC where AccountID = @AccountID and VocabID = @VocabID and TopicID = @TopicID)
		begin
			IF @Level <= 5
				BEGIN
					UPDATE CHITIETHOC
					SET Level = @Level, WrongTimes = @WrongTimes, Score = @Score
					where AccountID = @AccountID  and VocabID = @VocabID and TopicID = @TopicID
					set @check = (select @@ROWCOUNT) 
				END
			ELSE 
				BEGIN
					SELECT N'Đã thuộc'
				END
		end
	ELSE
		begin
			INSERT INTO CHITIETHOC(AccountID, VocabID, TopicID, Learned, Level, WrongTimes, Score)
			VALUES(@AccountID, @VocabID, @TopicID, 1, @Level, @WrongTimes, @Score)
			set @check = (select @@ROWCOUNT) 
		end

	if(@check > 0 )
		begin 
			SELECT N'Thành công'
		end
	else
		begin
			return null
		end
END 

--exec sp_AddVocabToDetailLearning
--@AccountID = 1,
--@VocabID=  2,
--@TopicID = 4,
--@Level= 6,
--@WrongTimes = 1,
--@Score = 1000



----------------- TESTING AREA
