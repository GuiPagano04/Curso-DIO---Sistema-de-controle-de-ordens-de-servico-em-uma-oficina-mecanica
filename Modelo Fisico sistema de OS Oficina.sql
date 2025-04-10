-- Criando modelo físico do projeto de Sistema de Controle de OS de uma Oficina

CREATE DATABASE Oficina;
USE Oficina;

-- CRIANDO AS TABELAS PRINCIPAIS
-- Criando a tabela de clientes
CREATE TABLE IF NOT EXISTS Clientes(
	idCliente INT AUTO_INCREMENT NOT NULL,
    Nome VARCHAR(45) NOT NULL,
    CPF VARCHAR(11) NOT NULL,
    Endereco VARCHAR(45) NOT NULL,
    CNH VARCHAR(11) NOT NULL,
    CONSTRAINT pk_idcliente_clientes PRIMARY KEY(idCliente),
    CONSTRAINT un_cpf_clientes UNIQUE(CPF),
    CONSTRAINT un_cnh_clientes UNIQUE(CNH)
);

-- Criando a tabela de Veiculos
CREATE TABLE IF NOT EXISTS Veiculos(
	idVeiculo INT AUTO_INCREMENT NOT NULL,
    idCliente INT NOT NULL,
    Marca VARCHAR(45) NOT NULL,
    Modelo VARCHAR(14) NOT NULL ,
    Placa VARCHAR(7) NOT NULL,
    Cor VARCHAR(45) NOT NULL,
    CONSTRAINT pk_idveiculo_veiculos PRIMARY KEY(idVeiculo),
    CONSTRAINT fk_idcliente_veiculos FOREIGN KEY(idCliente) REFERENCES Clientes(idCliente),
    CONSTRAINT un_placa_veiculos UNIQUE(Placa),
    CONSTRAINT ck_cor_veiculos CHECK(Cor IN ('Branco', 'Preto', 'Prata', 'Cinza', 'Vermelho', 'Azul', 'Verde', 'Amarelo', 'Laranja'))
);

-- Criando a tabela de Peças
CREATE TABLE IF NOT EXISTS Pecas(
	idPeca INT AUTO_INCREMENT NOT NULL,
    Nome VARCHAR(45) NOT NULL,
    Fornecedor VARCHAR(45) NOT NULL,
    CustoUnitario FLOAT NOT NULL,
    PrecoUnitario FLOAT NOT NULL,
    CONSTRAINT pk_idpecas_pecas PRIMARY KEY(idPeca)
);

-- Criando a tabela de Serviços
CREATE TABLE IF NOT EXISTS Servicos(
	idServico INT AUTO_INCREMENT NOT NULL,
    TipoDeServico VARCHAR(45) NOT NULL,
    Valor FLOAT NOT NULL,
    NomeServico VARCHAR(45) NOT NULL,
    CONSTRAINT pk_idservico_servicos PRIMARY KEY(idServico),
    CONSTRAINT ck_tipodeservico_servicos CHECK(TipoDeServico IN('Conserto', 'Revisão Periodica'))
);

-- Criando a tabela de Mecânicos
CREATE TABLE IF NOT EXISTS Mecanicos(
	idMecanico INT AUTO_INCREMENT NOT NULL,
    Nome VARCHAR(45) NOT NULL,
    Endereco VARCHAR(45) NOT NULL,
    Especialidade VARCHAR(45) NOT NULL,
    CONSTRAINT pk_idmecanico_mecanicos PRIMARY KEY(idMecanico),
    CONSTRAINT ck_especialidade_mecanicos CHECK(
		Especialidade IN (
        'Mecânica Geral', 
        'Suspensão', 
        'Freios', 
        'Motor', 
        'Transmissão', 
        'Câmbio', 
        'Alinhamento e Balanceamento', 
        'Pneus', 
        'Lataria e Pintura', 
        'Funilaria'
	))
);

-- Criando a tabela de Ordens de serviços
CREATE TABLE IF NOT EXISTS OrdensDeServico(
	idOS INT AUTO_INCREMENT NOT NULL,
    idVeiculo INT NOT NULL,
    DataDeEmissao DATE NOT NULL,
    DataDeEntrega DATE,
    StatusOS VARCHAR(45) NOT NULL,
    ValorTotal FLOAT NOT NULL CHECK(ValorTotal > 0),
    CONSTRAINT pk_idos_ordensdeservico PRIMARY KEY(idOS),
    CONSTRAINT fk_idveiculo_ordensdeservico FOREIGN KEY(idVeiculo) REFERENCES Veiculos(idVeiculo),
    CONSTRAINT ck_statusos_ordensdeservico CHECK(StatusOS IN ('Em Aberto', 'Finalizado'))
);

-- CRIANDO AS TABELAS COMPLEMENTARES
-- Criando a tabela de consulta peças
CREATE TABLE IF NOT EXISTS ConsultaPecas(
	idOS INT NOT NULL,
    idPeca INT NOT NULL,
    CONSTRAINT pk_idos_idpeca_consultapecas PRIMARY KEY(idOS, idPeca),
    CONSTRAINT fk_idos_consultapecas FOREIGN KEY(idOS) REFERENCES OrdensDeServico(idOS),
    CONSTRAINT fk_idpeca_consultapecas FOREIGN KEY(idPeca) REFERENCES Pecas(idPeca)
);

-- Criando a tabela de consulta servicos
CREATE TABLE IF NOT EXISTS ConsultaServicos(
	idOS INT NOT NULL,
    idServico INT NOT NULL,
    CONSTRAINT pk_idos_idservico_consultaservicos PRIMARY KEY(idOS, idServico),
    CONSTRAINT fk_idos_consultaservicos FOREIGN KEY(idOS) REFERENCES OrdensDeServico(idOS),
    CONSTRAINT fk_idservico_consultaservicos FOREIGN KEY(idServico) REFERENCES Servicos(idServico)
);

-- Criando a tabela de consulta Ordens de Servico
CREATE TABLE IF NOT EXISTS ConsultaOrdensDeServico(
	idOS INT NOT NULL,
    idMecanico INT NOT NULL,
    CONSTRAINT pk_idos_idmecanico_consultaordensdeservico PRIMARY KEY(idOS, idMecanico),
    CONSTRAINT fk_idos_consultaordensdeservico FOREIGN KEY(idOS) REFERENCES OrdensDeServico(idOS),
    CONSTRAINT fk_idmecanico_consultaordemdeservicos FOREIGN KEY(idMecanico) REFERENCES Mecanicos(idMecanico)
);


-- Persistindo dados nas tabelas(principais)
INSERT INTO Clientes(Nome, CPF, Endereco, CNH)
VALUES 
('Ana Souza', '12345678901', 'Rua das Flores, 123', '98765432100'),
('Bruno Lima', '23456789012', 'Av. Brasil, 456', '87654321099'),
('Carlos Pereira', '34567890123', 'Rua A, 789', '76543210988'),
('Daniela Rocha', '45678901234', 'Travessa B, 101', '65432109877'),
('Eduardo Silva', '56789012345', 'Rua Central, 202', '54321098766'),
('Fernanda Costa', '67890123456', 'Av. Paulista, 303', '43210987655'),
('Gabriel Martins', '78901234567', 'Rua Verde, 404', '32109876544'),
('Helena Dias', '89012345678', 'Rua Azul, 505', '21098765433'),
('Igor Freitas', '90123456789', 'Rua das Laranjeiras, 606', '10987654322'),
('Juliana Teixeira', '11223344556', 'Rua do Sol, 707', '99887766550'),
('Karen Mendes', '22334455667', 'Rua do Norte, 808', '88776655449'),
('Leonardo Alves', '33445566778', 'Rua do Sul, 909', '77665544338'),
('Marina Oliveira', '44556677889', 'Av. Independência, 1001', '66554433227'),
('Nicolas Gomes', '55667788990', 'Rua das Palmeiras, 1112', '55443322116'),
('Olívia Ramos', '66778899001', 'Rua do Cedro, 1213', '44332211005'),
('Pedro Barros', '77889900112', 'Rua das Acácias, 1314', '33221100994'),
('Quésia Antunes', '88990011223', 'Rua da Paz, 1415', '22110099883'),
('Rafael Nunes', '99001122334', 'Av. Horizonte, 1516', '11009988772'),
('Sabrina Luz', '10111213141', 'Rua das Pedras, 1617', '00998877661'),
('Thiago Monteiro', '12131415161', 'Rua das Montanhas, 1718', '99887766540'),
('Ursula Lima', '13141516171', 'Rua do Campo, 1819', '88776655430'),
('Victor Diniz', '14151617181', 'Av. dos Lagos, 1920', '77665544320'),
('Wesley Souza', '15161718191', 'Rua do Mar, 2021', '66554433210'),
('Xuxa Alves', '16171819201', 'Travessa das Rosas, 2122', '55443322100'),
('Yasmin Moreira', '17181920311', 'Rua das Violetas, 2223', '44332211090'),
('Zeca Camargo', '18192031421', 'Rua do Café, 2324', '33221100980'),
('Alana Furtado', '19203142531', 'Rua do Pôr do Sol, 2425', '22110099870'),
('Bruno Gama', '20314253641', 'Rua do Amanhecer, 2526', '11009988760'),
('Clara Borges', '21425364751', 'Rua do Vento, 2627', '00998877650'),
('Diego Couto', '22536475861', 'Av. São João, 2728', '99887766520');


INSERT INTO Veiculos(idCliente, Marca, Modelo, Placa, Cor)
VALUES
(1, 'Toyota', 'Corolla', 'ABC1D23', 'Prata'),
(2, 'Honda', 'Civic', 'DEF2E34', 'Preto'),
(3, 'Ford', 'Ka', 'GHI3F45', 'Branco'),
(4, 'Chevrolet', 'Onix', 'JKL4G56', 'Cinza'),
(5, 'Fiat', 'Argo', 'MNO5H67', 'Vermelho'),
(6, 'Volkswagen', 'Gol', 'PQR6I78', 'Preto'),
(7, 'Hyundai', 'HB20', 'STU7J89', 'Branco'),
(8, 'Renault', 'Kwid', 'VWX8K90', 'Prata'),
(9, 'Jeep', 'Renegade', 'YZA9L01', 'Cinza'),
(10, 'Nissan', 'Versa', 'BCD0M12', 'Prata'),
(11, 'Peugeot', '208', 'EFG1N23', 'Azul'),
(12, 'Citroën', 'C3', 'HIJ2O34', 'Branco'),
(13, 'Mitsubishi', 'ASX', 'KLM3P45', 'Preto'),
(14, 'Kia', 'Sportage', 'NOP4Q56', 'Vermelho'),
(15, 'Chevrolet', 'Cruze', 'QRS5R67', 'Cinza'),
(16, 'Volkswagen', 'Polo', 'TUV6S78', 'Branco'),
(17, 'Toyota', 'Yaris', 'WXY7T89', 'Prata'),
(18, 'Honda', 'Fit', 'ZAB8U90', 'Cinza'),
(19, 'Fiat', 'Mobi', 'CDE9V01', 'Preto'),
(20, 'Ford', 'EcoSport', 'FGH0W12', 'Prata'),
(21, 'Jeep', 'Compass', 'IJK1X23', 'Cinza'),
(22, 'Renault', 'Sandero', 'LMN2Y34', 'Vermelho'),
(23, 'Hyundai', 'Creta', 'OPQ3Z45', 'Branco'),
(24, 'Nissan', 'Kicks', 'RST4A56', 'Prata'),
(25, 'Peugeot', '2008', 'UVW5B67', 'Azul'),
(26, 'Chevrolet', 'Spin', 'XYZ6C78', 'Branco'),
(27, 'Fiat', 'Toro', 'ABC7D89', 'Cinza'),
(28, 'Volkswagen', 'T-Cross', 'DEF8E90', 'Laranja'),
(29, 'Toyota', 'Hilux', 'GHI9F01', 'Preto'),
(30, 'Kia', 'Cerato', 'JKL0G12', 'Verde');

INSERT INTO Pecas(Nome, Fornecedor, CustoUnitario, PrecoUnitario)
VALUES
('Pastilha de Freio', 'Bosch', 80.00, 130.00),
('Pastilha de Freio', 'TRW', 75.00, 125.00),
('Filtro de Óleo', 'Fram', 20.00, 35.00),
('Filtro de Óleo', 'Tecfil', 22.00, 38.00),
('Filtro de Ar', 'Mann', 30.00, 50.00),
('Filtro de Ar', 'Fram', 28.00, 45.00),
('Correia Dentada', 'Gates', 90.00, 140.00),
('Correia Dentada', 'Dayco', 85.00, 135.00),
('Velas de Ignição', 'NGK', 15.00, 30.00),
('Velas de Ignição', 'Bosch', 18.00, 32.00),
('Amortecedor Dianteiro', 'Cofap', 250.00, 370.00),
('Amortecedor Traseiro', 'Cofap', 230.00, 350.00),
('Bateria 60Ah', 'Moura', 380.00, 530.00),
('Bateria 60Ah', 'Heliar', 390.00, 540.00),
('Disco de Freio', 'Bosch', 120.00, 180.00),
('Disco de Freio', 'Fremax', 115.00, 175.00),
('Kit Embreagem', 'Sachs', 350.00, 520.00),
('Kit Embreagem', 'Valeo', 330.00, 500.00),
('Radiador', 'Behr', 300.00, 470.00),
('Bomba d’Água', 'SKF', 110.00, 160.00),
('Bico Injetor', 'Bosch', 200.00, 290.00),
('Sensor de Oxigênio', 'NGK', 140.00, 210.00),
('Sensor de Temperatura', 'Delphi', 60.00, 95.00),
('Bobina de Ignição', 'Bosch', 180.00, 260.00),
('Coxim do Motor', 'Mopar', 90.00, 140.00),
('Pneu 195/55R15', 'Pirelli', 320.00, 480.00),
('Pneu 195/55R15', 'Goodyear', 310.00, 470.00),
('Palheta Dianteira', 'Bosch', 35.00, 60.00),
('Palheta Traseira', 'Bosch', 25.00, 45.00),
('Lanterna Traseira', 'Arteb', 120.00, 180.00),
('Farol Dianteiro', 'Valeo', 200.00, 290.00),
('Termostato', 'Mahle', 70.00, 110.00),
('Sensor de Estacionamento', 'Multilaser', 60.00, 100.00),
('Retrovisor Elétrico', 'Magneti Marelli', 180.00, 260.00),
('Reservatório de Expansão', 'Viemar', 65.00, 100.00),
('Interruptor de Freio', 'Hella', 25.00, 40.00),
('Modulo ABS', 'Bosch', 900.00, 1300.00),
('Central de Injeção', 'Magneti Marelli', 1200.00, 1800.00),
('Cabo de Velas', 'NGK', 80.00, 120.00),
('Parafuso de Roda', 'SKF', 10.00, 18.00),
('Kit Junta Homocinética', 'Spicer', 150.00, 230.00),
('Lâmpada H7', 'Philips', 15.00, 28.00),
('Lâmpada H4', 'Osram', 13.00, 24.00),
('Sensor de Pressão dos Pneus', 'VDO', 120.00, 190.00),
('Cilindro Mestre', 'TRW', 220.00, 330.00),
('Radiador de Ar Quente', 'Valeo', 140.00, 210.00),
('Kit de Reparo Pinça Freio', 'TRW', 60.00, 100.00),
('Eixo Homocinético', 'Spicer', 300.00, 450.00),
('Chave de Seta', 'Magneti Marelli', 95.00, 145.00),
('Interruptor de Luz Ré', 'Hella', 22.00, 35.00);


INSERT INTO Servicos(TipoDeServico, NomeServico, Valor)
VALUES
-- Revisões periódicas
('Revisão Periodica', 'Revisão de 10.000 km', 250.00),
('Revisão Periodica', 'Revisão de 20.000 km', 300.00),
('Revisão Periodica', 'Revisão de 30.000 km', 350.00),
('Revisão Periodica', 'Revisão de 40.000 km', 400.00),
('Revisão Periodica', 'Revisão de 50.000 km', 450.00),
('Revisão Periodica', 'Revisão de 60.000 km', 500.00),
('Revisão Periodica', 'Revisão Completa A', 550.00),
('Revisão Periodica', 'Revisão Completa B', 600.00),
-- Consertos variados
('Conserto', 'Troca de pastilhas de freio', 120.00),
('Conserto', 'Troca de amortecedores', 200.00),
('Conserto', 'Substituição de correia dentada', 180.00),
('Conserto', 'Troca de velas de ignição', 150.00),
('Conserto', 'Substituição de embreagem', 300.00),
('Conserto', 'Conserto de radiador', 250.00),
('Conserto', 'Troca de disco de freio', 220.00),
('Conserto', 'Troca de bomba d’água', 280.00),
('Conserto', 'Substituição de sensor', 100.00),
('Conserto', 'Troca de bobina de ignição', 180.00),
('Conserto', 'Alinhamento e balanceamento', 160.00),
('Conserto', 'Troca de lâmpadas ou palhetas', 90.00);

INSERT INTO Mecanicos(Nome, Endereco, Especialidade)
VALUES
('Carlos Henrique', 'Rua Miguel de Cervantes, 123', 'Mecânica Geral'),
('Fernanda Lima', 'Avenida São João, 456', 'Suspensão'),
('João Batista', 'Rua das Hortênsias, 789', 'Freios'),
('Luciana Souza', 'Rua Bela Vista, 102', 'Motor'),
('Ricardo Alves', 'Travessa União, 310', 'Transmissão'),
('Amanda Ferreira', 'Rua Francisco Alves, 88', 'Câmbio'),
('Eduardo Ramos', 'Rua Nova Esperança, 504', 'Alinhamento e Balanceamento'),
('Beatriz Andrade', 'Alameda dos Pinhais, 210', 'Pneus'),
('Marcos Silva', 'Rua Industrial, 35', 'Lataria e Pintura'),
('Tatiane Rocha', 'Rua do Progresso, 740', 'Funilaria'),
('Juliano Costa', 'Rua Primavera, 64', 'Pneus'),
('Paulo Mendes', 'Rua Capitão Nascimento, 1177', 'Mecânica Geral'),
('Renata Borges', 'Avenida Paulista, 900', 'Freios'),
('Daniel Oliveira', 'Rua das Andorinhas, 401', 'Suspensão'),
('Aline Martins', 'Rua do Bosque, 777', 'Motor');

INSERT INTO OrdensDeServico(idVeiculo, DataDeEmissao, DataDeEntrega, StatusOS, ValorTotal)
VALUES
(1, '2024-12-01', '2024-12-05', 'Finalizado', 850.00),
(2, '2024-12-03', NULL, 'Em Aberto', 430.00),
(3, '2024-11-15', '2024-11-17', 'Finalizado', 1200.00),
(4, '2025-01-10', NULL, 'Em Aberto', 290.00),
(5, '2024-10-22', '2024-10-26', 'Finalizado', 1980.00),
(6, '2024-11-01', '2024-11-02', 'Finalizado', 300.00),
(7, '2024-09-14', '2024-09-15', 'Finalizado', 540.00),
(8, '2024-12-28', NULL, 'Em Aberto', 160.00),
(9, '2025-02-05', '2025-02-10', 'Finalizado', 2675.00),
(10, '2025-03-01', NULL, 'Em Aberto', 180.00),
(11, '2025-01-19', '2025-01-23', 'Finalizado', 2250.00),
(12, '2025-01-01', '2025-01-05', 'Finalizado', 1430.00),
(13, '2025-02-12', NULL, 'Em Aberto', 490.00),
(14, '2025-02-20', '2025-02-21', 'Finalizado', 200.00),
(15, '2024-12-15', '2024-12-18', 'Finalizado', 1790.00),
(16, '2025-03-05', NULL, 'Em Aberto', 760.00),
(17, '2024-11-10', '2024-11-13', 'Finalizado', 980.00),
(18, '2025-01-28', '2025-02-02', 'Finalizado', 2480.00),
(19, '2025-02-15', NULL, 'Em Aberto', 390.00),
(20, '2024-10-10', '2024-10-12', 'Finalizado', 620.00);

-- Persistindo dados nas tabelas(Complementares)
INSERT INTO ConsultaPecas(idOS, idPeca)
VALUES
(1, 3), (1, 5),
(2, 12),
(3, 7), (3, 9),
(4, 2),
(5, 15), (5, 18), (5, 20),
(6, 4),
(7, 10), (7, 11),
(8, 6),
(9, 8), (9, 21),
(10, 13),
(11, 19), (11, 22),
(12, 1),
(13, 24),
(14, 16), (14, 25),
(15, 14), (15, 28), (15, 29),
(16, 30),
(17, 17),
(18, 31), (18, 32), (18, 33),
(19, 26),
(20, 23), (20, 27);

INSERT INTO ConsultaServicos(idOS, idServico)
VALUES
(1, 2), (1, 5),
(2, 1),
(3, 3), (3, 6),
(4, 4),
(5, 7), (5, 9),
(6, 1), (6, 8),
(7, 10),
(8, 2),
(9, 3), (9, 11),
(10, 12),
(11, 4), (11, 13),
(12, 14),
(13, 5), (13, 6),
(14, 7),
(15, 15), (15, 8),
(16, 9), (16, 10),
(17, 11),
(18, 12), (18, 13),
(19, 14),
(20, 15);

INSERT INTO ConsultaOrdensDeServico(idOS, idMecanico)
VALUES
(1, 3), (1, 5),
(2, 2),
(3, 4), (3, 6),
(4, 1),
(5, 7), (5, 9),
(6, 8),
(7, 10),
(8, 2), (8, 11),
(9, 3),
(10, 12), (10, 5),
(11, 6),
(12, 13), (12, 14),
(13, 7),
(14, 8), (14, 15),
(15, 9),
(16, 10), (16, 11),
(17, 12),
(18, 13), (18, 14),
(19, 15),
(20, 1), (20, 2);

-- Criando QUERIES!!!

-- ANÁLISE ORDENS DE SERVIÇO

-- Qual o total de ordens geradas?
SELECT COUNT(*) FROM OrdensDeServico;

-- Qual o total de ordens em aberto e finalizados no sistema?
SELECT 
	StatusOS, 
	COUNT(*) AS Total
FROM OrdensDeServico
GROUP BY StatusOS;

-- Qual o tipo de serviço que mais gerou valor e qual a média de cada tipo? 
SELECT 
	S.TipoDeServico, 
    ROUND(SUM(OS.ValorTotal), 2) AS SomaValor,
    ROUND(AVG(OS.ValorTotal), 2) AS MediaValor
FROM OrdensDeServico OS
	LEFT JOIN ConsultaServicos CS 
		ON OS.idOS = CS.idOS
			LEFT JOIN Servicos S 
				ON CS.idServico = S.idServico
GROUP BY S.TipoDeServico
ORDER BY MediaValor DESC;

-- Quais OS que estão aberto há mais de 15 dias?
SELECT 
	OS.idOS, 
	C.Nome AS Cliente, 
    V.Modelo, 
    OS.DataDeEmissao
FROM OrdensDeServico OS
	LEFT JOIN Veiculos V 
		ON OS.idVeiculo = V.idVeiculo
			LEFT JOIN Clientes C 
				ON V.idCliente = C.idCliente
WHERE OS.StatusOS = 'Em Aberto'
  AND DATEDIFF(CURDATE(), OS.DataDeEmissao) > 15;


-- ANÁLISE VEÍCULOS

-- Quais os modelos de veículos mais atendidos na oficina?
SELECT 
	V.Modelo, 
	COUNT(*) AS TotalServicos
	FROM OrdensDeServico OS
		LEFT JOIN Veiculos V 
			ON OS.idVeiculo = V.idVeiculo
GROUP BY V.Modelo
ORDER BY TotalServicos DESC;

-- Quais as peças mais utilizadas na oficina?
SELECT 
	P.Nome, 
    COUNT(*) AS TotalUtilizacoes
	FROM ConsultaPecas CP
		LEFT JOIN Pecas P 
			ON CP.idPeca = P.idPeca
GROUP BY P.idPeca
ORDER BY TotalUtilizacoes DESC;

-- ANÁLISE DE MECÂNICOS

-- Qual a quantidade de ordens de serviço por mecânicos?
SELECT 
	M.Nome, 
    COUNT(*) AS TotalServicos
FROM ConsultaOrdensDeServico COS
	LEFT JOIN Mecanicos M 
		ON COS.idMecanico = M.idMecanico
GROUP BY M.idMecanico
ORDER BY TotalServicos DESC;

-- Qual a especialidade mais requisitada nas ordens de serviços da oficina? Desconsidere a área de mecânica em geral!
SELECT 
	M.Especialidade, 
	COUNT(*) AS Frequencia
FROM ConsultaOrdensDeServico COS
	LEFT JOIN Mecanicos M 
		ON COS.idMecanico = M.idMecanico
GROUP BY M.Especialidade
HAVING M.Especialidade <> 'Mecânica Geral'
ORDER BY Frequencia DESC;

-- ANÁLISE FINANCEIRA

-- Qual o total faturado pela oficina?
SELECT SUM(ValorTotal) FROM OrdensDeServico;

-- Qual o faturamento total por mês da oficina?
SELECT 
    DATE_FORMAT(DataDeEmissao, '%Y-%m') AS Mes,
    SUM(ValorTotal) AS Faturamento
FROM OrdensDeServico
WHERE StatusOS = 'Finalizado'
GROUP BY Mes
ORDER BY Mes;
	
-- Qual lucro médio que temos por peça?
SELECT 
    Nome,
    AVG(PrecoUnitario - CustoUnitario) AS LucroMedioPorUnidade
FROM Pecas
GROUP BY Nome
ORDER BY LucroMedioPorUnidade DESC;




















