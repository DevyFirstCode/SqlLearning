/*
    Created By: I.S.C Martin Cruz Medinilla
    Database: cloverbd
    Creation Date: November 2023
    Modifications:
    Fix default date
    Date: November 23, 2023
    Changes: Additional tables are add
*/

CREATE TABLE Client(
        ClientId INTEGER NOT NULL AUTO_INCREMENT,
        UpdatedBy INTEGER NOT NULL,
        Name VARCHAR(50) NOT NULL,
        LastName VARCHAR(50) NOT NULL,
        Cell VARCHAR(10) NULL,
        Email VARCHAR(50) NULL,
        Observations VARCHAR(300),
        Active BIT DEFAULT 1,
        CreatedDate DATETIME DEFAULT CURDATE(),
        UpdatedDate DATETIME DEFAULT CURDATE(),
        CONSTRAINT PK_Client PRIMARY KEY (ClientId),
        CONSTRAINT UC_Client UNIQUE (Cell)
);

CREATE TABLE UserUc(
        UserUcId INTEGER NOT NULL AUTO_INCREMENT,
        CreatedDate DATETIME DEFAULT CURDATE(),
        UpdatedBy INTEGER,
        UserName VARCHAR(100) NOT NULL,
        Password VARCHAR(100) NOT NULL,
        LastAccess DATETIME,
        Active BIT DEFAULT 1,
        CreatedBy INTEGER,
        UpdatedDate DATETIME DEFAULT CURDATE(),
        CONSTRAINT PK_UserUC PRIMARY KEY (UserUCId)
);

INSERT INTO UserUc (UserName, Password) VALUES('codemcm', MD5(12345));
UPDATE UserUC AS DESTINO, (SELECT UserUcId FROM UserUc WHERE UserName = 'codemcm') AS ORIGIN
    SET DESTINO.CreatedBy = ORIGIN.UserUcId, DESTINO.UpdatedBy = ORIGIN.UserUcId 
    WHERE DESTINO.UserName= 'codemcm';

CREATE TABLE Raffle(
    RaffleId INTEGER NOT NULL AUTO_INCREMENT,
    CreatedBy INTEGER,
    UpdatedBy INTEGER,
    Description VARCHAR(300),
    StartDate DATETIME DEFAULT CURDATE(),
    RaffleDate DATETIME,
    Active BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT CURDATE(),
    UpdatedDate DATETIME DEFAULT CURDATE(),
    CONSTRAINT PK_Raffle PRIMARY KEY (RaffleId)
);

CREATE TABLE Ticket(
    TicketId INTEGER NOT NULL AUTO_INCREMENT,
    RaffleId INTEGER NOT NULL,
    ClientId INTEGER NOT NULL,
    CreatedBy INTEGER,
    UpdatedBy INTEGER,
    Active BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT CURDATE(),
    UpdatedDate DATETIME DEFAULT CURDATE(),
    CONSTRAINT PK_Ticket PRIMARY KEY (TicketId),
    CONSTRAINT FK_RaffleTicket FOREIGN KEY (RaffleId) REFERENCES Raffle(RaffleId),
    CONSTRAINT FK_ClientTicket FOREIGN KEY (ClientId) REFERENCES Client(ClientId)
);

CREATE TABLE Prize(
    PrizeId INTEGER NOT NULL AUTO_INCREMENT,
    RaffleId INTEGER NOT NULL,
    CreatedBy INTEGER NOT NULL,
    UpdatedBy INTEGER NOT NULL,
    Product VARCHAR(100) NOT NULL,
    Active BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT CURDATE(),
    UpdatedDate DATETIME DEFAULT CURDATE(),
    CONSTRAINT PK_Prize PRIMARY KEY (PrizeId),
    CONSTRAINT FK_RafflePrize FOREIGN KEY (RaffleId) REFERENCES Raffle(RaffleId)
);

CREATE TABLE Winner(
    WinnerId INTEGER NOT NULL AUTO_INCREMENT,
    TicketId INTEGER NOT NULL,
    PrizeId INTEGER NOT NULL,
    CreatedBy INTEGER,
    UpdatedBy INTEGER,
    Active BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT CURDATE(),
    UpdatedDate DATETIME DEFAULT CURDATE(),
    CONSTRAINT PK_Winner PRIMARY KEY (WinnerId),
    CONSTRAINT FK_WinnerTicket FOREIGN KEY (TicketId) REFERENCES Ticket(TicketId),
    CONSTRAINT FK_PrizeTicket FOREIGN KEY (PrizeId) REFERENCES Prize(PrizeId)

);