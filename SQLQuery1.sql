create table TUVUNG(
	VocabID int IDENTITY(1,1),
	TopicID int,

	Frequency int,
	Word varchar(50),
	IPA nvarchar(100),
	Label varchar(50),
	Lemma varchar(200),
	Vietnamese nvarchar(200),
	Cluster varchar(100),
	Position varchar(100),
	Example varchar(400),
	VN_Example nvarchar(400),
	Resources varchar(400),

	Active bit,
	Learned bit, 
	Level tinyint,

	PRIMARY KEY (VocabID),
	FOREIGN KEY (TopicID) REFERENCES CHUDE(TopicID)
)

go
create table TUVUNGCANHAN(
	PersonalVocabID int IDENTITY(1,1),
	PersonalVocabName nvarchar(200),
	IsDefault bit default 0,

	PRIMARY KEY (PersonalVocabID),
)
go

create table CHITIETTUCANHAN(
	PersonalVocabID int,
	VocabID int,

	AccountID int, 

	Frequency int,
	Word varchar(50),
	IPA nvarchar(100),
	Label varchar(50),
	Lemma varchar(200),
	Vietnamese nvarchar(200),
	Cluster varchar(100),
	Position varchar(100),
	Example varchar(400),
	VN_Example nvarchar(400),
	Resources varchar(400),

	PRIMARY KEY (PersonalVocabID, VocabID),
	FOREIGN KEY (VocabID) REFERENCES TUVUNG(VocabID),
	FOREIGN KEY (PersonalVocabID) REFERENCES TUVUNGCANHAN(PersonalVocabID),
	FOREIGN KEY (AccountID) REFERENCES TAIKHOAN(AccountID)
)

go

