/*+++++++++++++++++++++++ FARMACIA SAN ANTONIO COMPLETO +++++++++++++++++++++++++++++++++++++++++++++++*/
CREATE DATABASE FarmSAntonio
USE FarmSAntonioCompras
DROP DATABASE FarmSAntonio
--------------------------------------------------------
		FRAGMENTO DE VENTAS
--------------------------------------------------------
CREATE TABLE EMPLEADOS (
	CVEMP INT PRIMARY KEY
	,NOMEMP VARCHAR(50) NOT NULL
	,DIREMP VARCHAR(20) NOT NULL
	,CORREOEMP VARCHAR(30) NOT NULL
	,TELEMP VARCHAR(15) NOT NULL
	,EDADEMP INT CHECK (EDADEMP LIKE '[1-6][0-9]') NOT NULL
	/*actualizacion del 03 de mayo 2020 se modifico estepedo y se agrego la tabla de usuarios*/
	,PUESTO VARCHAR(30) NOT NULL CHECK (PUESTO='CAJERO(A)' OR PUESTO ='MOSTRADOR' OR PUESTO = 'ENC. DE TIENDA' 
	OR PUESTO='ADMINISTRADOR(A)' OR PUESTO='AUX. CONTABLE' OR PUESTO='CONTADOR(A)')/*asi lo tenia mi ma :,v*/
	,DEPTO VARCHAR (10) NOT NULL check (depto='GERENCIA' or depto='VENTAS' or depto='COMPRAS')
	,ACTIVO INT
	)

CREATE TABLE VENTAS (
	CVEVTA INT PRIMARY KEY
	,SUBTOTAL MONEY DEFAULT(0)
	,IVA MONEY DEFAULT(0)
	,TIPOPAG VARCHAR(20)
	,FECHAVTA DATE DEFAULT(GETDATE())
	)

/*MODIFICACION DEL 03 DE MAYO DEL 2020*/
CREATE TABLE USUARIOS (
NUSUARIO VARCHAR (10) UNIQUE NOT NULL,
CONTRASENA varchar (12) unique not null,
TIPODEPTO VARCHAR (1) NOT NULL CHECK (TIPODEPTO='C' OR TIPODEPTO='V' OR TIPODEPTO='G'),
SESION INT DEFAULT 0 NOT NULL,
CVEMP INT FOREIGN KEY REFERENCES EMPLEADOS NOT NULL
)

CREATE TABLE DETVTAEMP (
	CVEVTA INT FOREIGN KEY REFERENCES VENTAS NOT NULL
	,CVEMP INT FOREIGN KEY REFERENCES EMPLEADOS NOT NULL
	,COMISION INT DEFAULT(0)
	)

CREATE TABLE DETVTAMED (
	CVEVTA INT FOREIGN KEY REFERENCES VENTAS NOT NULL
	,CVEMED INT FOREIGN KEY REFERENCES MEDICAMENTOS NOT NULL
	,CANTVM INT NOT NULL
	,PREVENDIDOM MONEY DEFAULT (0)
	,IMGRECT VARCHAR(100) NOT NULL --LA RUTA DE LA IMAGEN ESCANEADA
	)

CREATE TABLE DETVTAPRO (
	CVEVTA INT FOREIGN KEY REFERENCES VENTAS NOT NULL
	,CVEPROD INT FOREIGN KEY REFERENCES PRODUCTOS NOT NULL
	,PREVENDIDOP MONEY DEFAULT (0)
	,CANTVP INT NOT NULL
	)

--------------------------------------------------------
--			SECCION DE COMPRAS
--------------------------------------------------------
CREATE TABLE PROVEEDORES (
	CVEPROV INT PRIMARY KEY
	,NOMPROV VARCHAR(50) NOT NULL
	,EMPRESA VARCHAR(30) NOT NULL
	,DIRPROV VARCHAR(50)
	,DIREMPSA VARCHAR(50) NOT NULL
	,TELPROV VARCHAR(15) NOT NULL
	,ESTADO VARCHAR(20) NOT NULL
	,CODIGOP VARCHAR(8) NOT NULL
	,LOCALIDAD VARCHAR(30) NOT NULL
	,CORREOPROV VARCHAR(30) NOT NULL
	,ACTIVO INT
	)

CREATE TABLE CADUCIDAD (
	CVECAD INT PRIMARY KEY
	,FECHACAD DATE NOT NULL
	)
CREATE TABLE MEDICAMENTOS (
	CVEMED INT PRIMARY KEY
	,NOMED VARCHAR(30) NOT NULL
	,DESCRIPCIONM VARCHAR(60) NOT NULL
	,PRECIOCOMPM MONEY DEFAULT(0)
	,PRECIOVTAM MONEY DEFAULT(0)
	,EXISTENCIASM INT DEFAULT(0)
	,ESTADO INT
	)
CREATE TABLE PRODUCTOS (
	CVEPROD INT PRIMARY KEY
	,NOMP VARCHAR(30) NOT NULL
	,DESCRIP VARCHAR(60) NOT NULL
	,PRECIOCOMP MONEY DEFAULT(0)
	,PRECIOVTAP MONEY DEFAULT(0)
	,EXISTENCIASP INT DEFAULT(0)
	,ESTADO INT
	)
CREATE TABLE COMPRAS (
	CVECOMP INT PRIMARY KEY
	,TOTALCOMP MONEY DEFAULT(0)
	,FECHACOMP DATE DEFAULT(GETDATE())
	)
--TABLAS INTERMEDIAS
CREATE TABLE DETCOMPRV (
	CVECOMP INT FOREIGN KEY REFERENCES COMPRAS NOT NULL
	,CVEPROV INT FOREIGN KEY REFERENCES PROVEEDORES NOT NULL
	)
CREATE TABLE DETCOMPRO --Las siguientes dos tablas fueron modificadas
	(
	CVECOMP INT FOREIGN KEY REFERENCES COMPRAS NOT NULL
	,CVEPROD INT FOREIGN KEY REFERENCES PRODUCTOS NOT NULL
	,CANTCOMP INT NOT NULL
	,CAD DATE NOT NULL
	,PRECOMP MONEY NOT NULL
	,LOTE VARCHAR(10)
	,GANANCIAP MONEY DEFAULT(0)
	)
CREATE TABLE DETCOMMED (
	CVECOMP INT FOREIGN KEY REFERENCES COMPRAS NOT NULL
	,CVEMED INT FOREIGN KEY REFERENCES MEDICAMENTOS NOT NULL
	,CANTCOMPM INT NOT NULL
	,TIPOMED VARCHAR(30) NOT NULL
	,CADM DATE NOT NULL
	,PRECOMPM MONEY NOT NULL
	,LOTE VARCHAR(10)
	,GANANCIAM MONEY DEFAULT(0)
	)
CREATE TABLE DETCADMED (
	CVECAD INT FOREIGN KEY REFERENCES CADUCIDAD NOT NULL
	,CVEMED INT FOREIGN KEY REFERENCES MEDICAMENTOS NOT NULL
	,LOTE VARCHAR(10) NOT NULL
	,FECHALIMT DATE NOT NULL
	)
CREATE TABLE DETCADPRO (
	CVECAD INT FOREIGN KEY REFERENCES CADUCIDAD NOT NULL
	,CVEPROD INT FOREIGN KEY REFERENCES PRODUCTOS NOT NULL
	,LOTE VARCHAR(10) NOT NULL
	)
