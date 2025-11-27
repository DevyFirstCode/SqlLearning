CREATE TABLE Usuario(
    UsuarioId INT AUTO_INCREMENT NOT NULL,
    nickname VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    UltimoAcceso DATETIME,
    Activo BOOLEAN DEFAULT TRUE,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FechaActualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (UsuarioId),
    INDEX idx_nickname (nickname),
    INDEX idx_activo (Activo)
);

CREATE TABLE Cliente(
    ClienteId INT AUTO_INCREMENT NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Apellidos VARCHAR(120) NOT NULL,
    Celular VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    Notas TEXT,
    Activo BOOLEAN DEFAULT TRUE,
    CreadoPor INT NOT NULL,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FechaActualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (ClienteId),
    FOREIGN KEY (CreadoPor) REFERENCES Usuario(UsuarioId),
    INDEX idx_nombre_apellidos (Nombre, Apellidos),
    INDEX idx_celular (Celular),
    INDEX idx_email (Email),
    INDEX idx_activo (Activo)
);

CREATE TABLE EstadoSorteo(
    EstadoId INT AUTO_INCREMENT NOT NULL,
    NombreEstado VARCHAR(30) NOT NULL UNIQUE,
    Descripcion VARCHAR(100),
    PRIMARY KEY (EstadoId)
);

INSERT INTO EstadoSorteo (NombreEstado, Descripcion) VALUES
('PROGRAMADO', 'Sorteo programado, aún no iniciado'),
('ACTIVO', 'Sorteo en curso, vendiendo boletos'),
('CERRADO', 'Venta de boletos cerrada'),
('REALIZADO', 'Sorteo ya realizado'),
('CANCELADO', 'Sorteo cancelado');

CREATE TABLE Sorteo(
    SorteoId INT AUTO_INCREMENT NOT NULL,
    NombreRifa VARCHAR(70) NOT NULL UNIQUE,
    Descripcion VARCHAR(255),
    FechaInicio DATE NOT NULL,
    FechaDelSorteo DATETIME NOT NULL,
    EstadoId INT NOT NULL DEFAULT 1,
    PrecioBoleto DECIMAL(10,2),
    MaximoBoletos INT,
    CreadoPor INT NOT NULL,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FechaActualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (SorteoId),
    FOREIGN KEY (EstadoId) REFERENCES EstadoSorteo(EstadoId),
    FOREIGN KEY (CreadoPor) REFERENCES Usuario(UsuarioId),
    INDEX idx_nombre_rifa (NombreRifa),
    INDEX idx_estado (EstadoId),
    INDEX idx_fecha_sorteo (FechaDelSorteo),
    CONSTRAINT chk_fechas CHECK (FechaDelSorteo >= FechaInicio)
);

CREATE TABLE Boleto(
    BoletoId INT AUTO_INCREMENT NOT NULL,
    NumeroBoleto VARCHAR(20) NOT NULL,
    SorteoId INT NOT NULL,
    ClienteId INT NOT NULL,
    PrecioVenta DECIMAL(10,2),
    FechaVenta DATETIME DEFAULT CURRENT_TIMESTAMP,
    Activo BOOLEAN DEFAULT TRUE,
    CreadoPor INT NOT NULL,
    FechaActualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (BoletoId),
    UNIQUE KEY uk_numero_sorteo (NumeroBoleto, SorteoId),
    FOREIGN KEY (SorteoId) REFERENCES Sorteo(SorteoId) ON DELETE CASCADE,
    FOREIGN KEY (ClienteId) REFERENCES Cliente(ClienteId),
    FOREIGN KEY (CreadoPor) REFERENCES Usuario(UsuarioId),
    INDEX idx_sorteo (SorteoId),
    INDEX idx_cliente (ClienteId),
    INDEX idx_numero (NumeroBoleto),
    INDEX idx_fecha_venta (FechaVenta)
);

CREATE TABLE Premio(
    PremioId INT AUTO_INCREMENT NOT NULL,
    SorteoId INT NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(255),
    ValorPremio DECIMAL(10,2),
    Posicion INT NOT NULL,
    Activo BOOLEAN DEFAULT TRUE,
    CreadoPor INT NOT NULL,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FechaActualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (PremioId),
    UNIQUE KEY uk_sorteo_posicion (SorteoId, Posicion),
    FOREIGN KEY (SorteoId) REFERENCES Sorteo(SorteoId) ON DELETE CASCADE,
    FOREIGN KEY (CreadoPor) REFERENCES Usuario(UsuarioId),
    INDEX idx_sorteo (SorteoId),
    INDEX idx_posicion (Posicion)
);

CREATE TABLE Ganadores(
    GanadorId INT AUTO_INCREMENT NOT NULL,
    PremioId INT NOT NULL,
    BoletoId INT NOT NULL,
    FechaSorteo DATETIME NOT NULL,
    Entregado BOOLEAN DEFAULT FALSE,
    FechaEntrega DATETIME NULL,
    Observaciones TEXT,
    RegistradoPor INT NOT NULL,
    FechaRegistro DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (GanadorId),
    UNIQUE KEY uk_premio_ganador (PremioId),
    FOREIGN KEY (PremioId) REFERENCES Premio(PremioId),
    FOREIGN KEY (BoletoId) REFERENCES Boleto(BoletoId),
    FOREIGN KEY (RegistradoPor) REFERENCES Usuario(UsuarioId),
    INDEX idx_premio (PremioId),
    INDEX idx_boleto (BoletoId),
    INDEX idx_fecha_sorteo (FechaSorteo),
    INDEX idx_entregado (Entregado)
);

CREATE TABLE AuditoriaGeneral(
    AuditoriaId BIGINT AUTO_INCREMENT NOT NULL,
    Tabla VARCHAR(50) NOT NULL,
    RegistroId INT NOT NULL,
    Operacion ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    ValoresAnteriores JSON,
    ValoresNuevos JSON,
    UsuarioId INT NOT NULL,
    FechaOperacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    DireccionIP VARCHAR(45),
    PRIMARY KEY (AuditoriaId),
    FOREIGN KEY (UsuarioId) REFERENCES Usuario(UsuarioId),
    INDEX idx_tabla_registro (Tabla, RegistroId),
    INDEX idx_operacion (Operacion),
    INDEX idx_fecha (FechaOperacion),
    INDEX idx_usuario (UsuarioId)
);
