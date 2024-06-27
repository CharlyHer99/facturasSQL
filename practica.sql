USE master
GO

CREATE DATABASE practica
GO

USE practica
GO

CREATE TABLE ciudades(
idCiudad int not null primary key identity(1,1),
nombre varchar(50)
)
GO
INSERT INTO ciudades VALUES
('Purísima'), ('León'), ('San Francisco'), ('Guanajuato'), ('Silao')

CREATE TABLE vendedores(
idVendedor int not null primary key identity(1,1),
nombre varchar(100),
direccion varchar(150),
codigoPostal int,
idPueblo int,
CONSTRAINT fk_idPueblo_vendedores FOREIGN KEY (idPueblo) REFERENCES ciudades(idCiudad)
)
GO
INSERT INTO vendedores VALUES
('Pedro', 'Rosal #123', 36123, 5), ('Valedor', 'Cristal #13', 36131, 4), ('Miguel', 'Veneros #112', 36567, 2),
('Ramón', 'Morelos #812', 36400, 1), ('Juan', 'Madero #321', 36138, 1), ('Jesús', 'Pedro Moreno #123', 36123, 2)
GO

CREATE TABLE clientes(
idCliente int not null primary key identity(1,1),
nombre varchar(50),
direccion varchar(150),
estatus int,
codigoPostal int,
ciudad int,
vendedorActual int,
CONSTRAINT fk_venddedorActual_cliente FOREIGN KEY (vendedorActual) REFERENCES vendedores(idVendedor),
CONSTRAINT fk_ciudad_cliente FOREIGN KEY (ciudad) REFERENCES ciudades(idCiudad)
)
GO
INSERT INTO clientes VALUES
('Carlos Hernández', 'Gardenia #168', 1, 36416, 1, 1), 
('Miguel Hernández', 'Gardenia #168', 1, 36416, 1, 4),
('´Ramiro Rendon', 'Morelos #16', 0, 36400, 1, 5),
('Paulina Guerrero', 'Veneros #132', 1, 35600, 2, 1),
('Bruno Pinilla', 'Torres #220', 0, 35400, 5, 2)
GO

CREATE TABLE articulos(
idArticulo int not null primary key identity(1,1),
descripcion varchar(200),
precio decimal(10,2),
stock int,
stockMinimo int
)
GO
INSERT INTO articulos VALUES 
('Pelota', 12.00, 50, 30), ('Balón', 50.00, 30, 30), ('Guantes', 30.00, 20, 20),
('Tachones', 200.00, 50, 30), ('Mochila', 70.00, 40, 40), ('Gorra', 40.00, 20, 10),
('pulsera', 5.00, 5, 10)
GO

CREATE TABLE facturas(
idFactura int not null primary key identity(1,1),
importe decimal(10, 2),
fecha date,
idCliente int,
idVendedor int,
iva decimal(10, 2),
descuento decimal(10, 2),
CONSTRAINT fk_idCliente_facturas FOREIGN KEY (idCliente) REFERENCES clientes(idCliente),
CONSTRAINT fk_idVendedor_facturas FOREIGN KEY (idVendedor) REFERENCES vendedores(idVendedor)
)
GO
INSERT INTO facturas VALUES
(2000.00, '2024-05-20', 1, 1, 20.00, 10), (1500.00, '2024-04-28', 2, 4, 20.00, 5),
(300.00, '2024-01-10', 3, 5, 20.00, 15), (23300.00, '2024-05-12', 4, 1, 20.00, 30),
(2900.00, '2024-03-07', 5, 2, 20.00, 9), (12900.00, '2024-02-16', 1, 1, 20.00, 20),
(20.00, '2024-02-16', 2, 4, 20.00, 5)
GO

CREATE TABLE detalleFacturas(
idDetalleFactura int not null primary key identity(1,1),
idFactura int,
idProducto int,
cantidadSolicitada int,
subtotal decimal(10,2),
CONSTRAINT fk_idFactura_detalleFactura FOREIGN KEY(idFactura) REFERENCES facturas(idFactura),
CONSTRAINT fk_idProducto_detalleFactura FOREIGN KEY(idProducto) REFERENCES articulos(idArticulo)
)
GO
INSERT INTO detalleFacturas VALUES
(1, 4, 5, 1000), (1, 2, 20, 1000),
(2, 6, 15, 600), (2, 3, 30, 900),
(3, 1, 12, 300), 
(4, 1, 150, 1800), (4, 2, 15, 2500), (4, 3, 150, 4500),(4, 4, 30, 6000),  (4, 5, 25, 3500), (4, 6, 200, 5000),
(5, 1, 75, 900), (5, 2, 20, 1000), (5, 4, 5, 1000), 
(6, 1, 100, 1200), (6, 2, 20, 1000), (6, 3, 100, 3000), (6, 4, 15, 3000),  (6, 5, 10, 700), (6, 6, 100, 4000),
(7, 7, 4, 20)
GO


--ejercicio 3
ALTER PROCEDURE spListarFacturasPorAño
	@date varchar(4)
AS
	SELECT f.*
	from facturas f
	WHERE fecha like CONCAT(@date,'%') 
	AND f.importe < (SELECT CONVERT(DECIMAL(10,2), AVG(importe)) from facturas WHERE idCliente = f.idCliente)
	GROUP BY f.idFactura, f.importe, f.fecha, f.idCliente, f.idVendedor, f.iva, f.descuento
GO
EXEC spListarFacturasPorAño '2024'
GO

--ejercicio #4
SELECT v.*,
	(SELECT COUNT(idCliente) 
		FROM clientes 
		WHERE vendedorActual = v.idVendedor) 
	AS clientesAsignados
from vendedores v
GO

--ejercicio 5
CREATE PROCEDURE spClinteVendedorCiudad
	-- 0 = inactivo, 1 = activo, 2 = todos
	@estatus int
AS
	IF @estatus < 2
		SELECT DISTINCT c.nombre, cc.nombre AS CiudadCliente, cv.nombre ciudadVendedor 
		FROM clientes c 
		INNER JOIN vendedores v ON c.vendedorActual = v.idVendedor
		INNER JOIN ciudades cc ON c.ciudad = cc.idCiudad
		INNER JOIN ciudades cv ON v.idPueblo= cv.idCiudad
		WHERE cc.idCiudad <> cv.idCiudad
		AND estatus = @estatus
	ELSE
		SELECT DISTINCT c.nombre, cc.nombre AS CiudadCliente, cv.nombre ciudadVendedor 
		FROM clientes c 
		INNER JOIN vendedores v ON c.vendedorActual = v.idVendedor
		INNER JOIN ciudades cc ON c.ciudad = cc.idCiudad
		INNER JOIN ciudades cv ON v.idPueblo= cv.idCiudad
		WHERE cc.idCiudad <> cv.idCiudad
GO
EXEC spClinteVendedorCiudad 2
GO


--ejercicio 6
CREATE FUNCTION rankingArticulos()
	RETURNS TABLE
AS
	RETURN
			SELECT SUM(df.cantidadSolicitada) cantidadVendida, df.idProducto, 
				a.precio, (SELECT fecha FROM facturas WHERE idFactura =
							(SELECT MAX(idFactura) from detalleFacturas WHERE idProducto = a.idArticulo)) AS ultimaFechaVendida,
				ROW_NUMBER() OVER (ORDER BY SUM(df.cantidadSolicitada) DESC) AS ranking
			FROM detalleFacturas df
			INNER JOIN articulos as a ON df.idProducto = a.idArticulo
			GROUP BY df.idProducto, a.precio, a.idArticulo
GO
SELECT * from dbo.rankingArticulos() 
GO


--ejercicio 7
CREATE VIEW articuloStockMenorAlMinimo
AS
	SELECT a.*,(SELECT fecha FROM facturas WHERE idFactura =
					(SELECT MAX(idFactura) from detalleFacturas WHERE idProducto = a.idArticulo)) AS ultimaFechaVendida,
					(SELECT ranking from dbo.rankingArticulos() WHERE idProducto = a.idArticulo) AS ranking
	FROM articulos a
	RIGHT JOIN detalleFacturas df ON a.idArticulo = df.idProducto
	LEFT JOIN facturas f ON df.idFactura = f.idFactura 
		WHERE a.stock < a.stockMinimo
GO
SELECT * from articuloStockMenorAlMinimo
GO

--ejercicio 8
CREATE FUNCTION obtenerPromedioImportePorVendedor
	(
		@idVendedor int, @mes varchar(2)
	) 
	RETURNS DECIMAL(10, 2)
AS
BEGIN
	RETURN 
		(SELECT CONVERT(DECIMAL(10,2), AVG(importe)) promedio from facturas WHERE idVendedor = 1 AND fecha like CONCAT('%-',@mes,'-%'))
END
GO
SELECT dbo.obtenerPromedioImportePorVendedor(1, '02') as promedio
GO


