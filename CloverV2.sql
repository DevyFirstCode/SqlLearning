-- Tabla Usuario
CREATE TABLE Usuario(
    UsuarioId INT AUTO_INCREMENT NOT NULL,
    nickname VARCHAR(50),
    Password VARCHAR(32),
    UltimoAcceso DATETIME,
    Activo BOOLEAN,
    CreadoPor INT,
    FechaActualizacion DATETIME,
    PRIMARY KEY (UsuarioId)
);

-- Tabla Cliente
CREATE TABLE Cliente(
    ClienteId INT AUTO_INCREMENT NOT NULL,
    Nombre VARCHAR(50),
    Apellidos VARCHAR(120),
    Celular VARCHAR(12) UNIQUE,
    Email VARCHAR(60),
    Notas VARCHAR(100),
    Activo BOOLEAN,
    CreadoPor INT,
    FechaActualizacion DATETIME,
    PRIMARY KEY (ClienteId),
    FOREIGN KEY (CreadoPor) REFERENCES Usuario(UsuarioId)
);

-- Tabla Sorteo
CREATE TABLE Sorteo(
    SorteoId INT AUTO_INCREMENT NOT NULL,
    NombreRifa VARCHAR(70) UNIQUE,
    Descripcion VARCHAR(150),
    FechaInicio DATE,
    FechaDelSorteo DATETIME,
    Activo BOOLEAN,
    FechaActualizacion DATETIME,
    PRIMARY KEY (SorteoId)
);

-- Tabla Boleto
CREATE TABLE Boleto(
    BoletoId INT AUTO_INCREMENT NOT NULL,
    SorteoId INT,
    ClienteId INT,
    CreadoPor INT,
    Activo BOOLEAN,
    FechaActualizacion DATETIME,
    PRIMARY KEY (BoletoId),
    FOREIGN KEY (SorteoId) REFERENCES Sorteo(SorteoId),
    FOREIGN KEY (ClienteId) REFERENCES Cliente(ClienteId),
    FOREIGN KEY (CreadoPor) REFERENCES Usuario(UsuarioId)
);

-- Tabla Premio
CREATE TABLE Premio(
    PremioId INT AUTO_INCREMENT NOT NULL,
    Nombre VARCHAR(50),
    Descripcion VARCHAR(100),
    Activo BOOLEAN,
    CreadoPor INT,
    FechaActualizacion DATETIME,
    BoletoGanadorId INT,
    SorteoId INT,
    PRIMARY KEY (PremioId),
    FOREIGN KEY (CreadoPor) REFERENCES Usuario(UsuarioId),
    FOREIGN KEY (BoletoGanadorId) REFERENCES Boleto(BoletoId),
    FOREIGN KEY (SorteoId) REFERENCES Sorteo(SorteoId)
);