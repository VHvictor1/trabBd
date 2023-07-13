CREATE TABLE `departamento` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(1000) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `professor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) NOT NULL,
  `codDepartamento` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `nome_UNIQUE` (`nome`),
  KEY `fk_departamento_idx` (`codDepartamento`),
  CONSTRAINT `fk_departamento` FOREIGN KEY (`codDepartamento`) REFERENCES `departamento` (`id`) ON DELETE CASCADE
);

CREATE TABLE `disciplina` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(1000) NOT NULL,
  `codigo` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
);

CREATE TABLE `turma` (
  `id` int NOT NULL AUTO_INCREMENT,
  `turno` varchar(45) NOT NULL,
  `numero` int NOT NULL,
  `periodo` varchar(45) NOT NULL,
  `codDisciplina` int NOT NULL,
  `codProfessor` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_disciplina_idx` (`codDisciplina`),
  KEY `fk_professor_idx` (`codProfessor`),
  CONSTRAINT `fk_codDisciplinaTurma` FOREIGN KEY (`codDisciplina`) REFERENCES `disciplina` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_codProfessorTurma` FOREIGN KEY (`codProfessor`) REFERENCES `professor` (`id`) ON DELETE CASCADE
);

CREATE TABLE `estudante` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) NOT NULL,
  `curso` varchar(45) NOT NULL,
  `matricula` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `senha` varchar(45) NOT NULL,
  `isAdmin` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`)
);

CREATE TABLE `avaliacaoDisciplina` (
  `id` int NOT NULL AUTO_INCREMENT,
  `codDisciplina` int NOT NULL,
  `valor` varchar(45) NOT NULL,
  `comentario` varchar(45) DEFAULT NULL,
  `codEstudante` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_codDisciplina_idx` (`codDisciplina`),
  KEY `fk_codEstudante_idx` (`codEstudante`),
  CONSTRAINT `fk_codDisciplina` FOREIGN KEY (`codDisciplina`) REFERENCES `disciplina` (`id`),
  CONSTRAINT `fk_codEstudante` FOREIGN KEY (`codEstudante`) REFERENCES `estudante` (`id`) ON DELETE CASCADE
);

CREATE TABLE `avaliacaoProf` (
  `id` int NOT NULL AUTO_INCREMENT,
  `valor` int NOT NULL,
  `comentario` varchar(45) DEFAULT NULL,
  `codProfessorAvaliacao` int NOT NULL,
  `codEstudanteAvaliacao` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_professor_idx` (`codProfessorAvaliacao`),
  KEY `fk_avaliacaoEstudante_idx` (`codEstudanteAvaliacao`),
  CONSTRAINT `fk_avaliacaoEstudante` FOREIGN KEY (`codEstudanteAvaliacao`) REFERENCES `estudante` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_avaliacaoProf` FOREIGN KEY (`codProfessorAvaliacao`) REFERENCES `professor` (`id`)
);

CREATE TABLE `denunciaAvaliacaoDisciplina` (
  `id` int NOT NULL AUTO_INCREMENT,
  `comentario` varchar(45) NOT NULL,
  `codAvaliacaoDisciplina` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_denunciaAvaliacaoDisciplina_idx` (`codAvaliacaoDisciplina`),
  CONSTRAINT `fk_denunciaAvaliacaoDisciplina` FOREIGN KEY (`codAvaliacaoDisciplina`) REFERENCES `avaliacaoDisciplina` (`id`) ON DELETE CASCADE
);

CREATE TABLE `denunciaAvaliacaoProf` (
  `id` int NOT NULL AUTO_INCREMENT,
  `comentario` varchar(45) NOT NULL,
  `codAvaliacaoProf` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_denunciaAvaliacaoProf_idx` (`codAvaliacaoProf`),
  CONSTRAINT `fk_denunciaAvaliacaoProf` FOREIGN KEY (`codAvaliacaoProf`) REFERENCES `avaliacaoProf` (`id`) ON DELETE CASCADE
);

CREATE VIEW view_denuncia_avaliacao AS
SELECT 'denunciaAvaliacaoDisciplina' AS origem, d.id AS denuncia_id, d.comentario AS denuncia_comentario, ad.id AS avaliacao_id,
       ad.codDisciplina, ad.valor, ad.comentario AS avaliacao_comentario, ad.codEstudante
FROM denunciaAvaliacaoDisciplina d
JOIN avaliacaoDisciplina ad ON d.codAvaliacaoDisciplina = ad.id
UNION
SELECT 'denunciaAvaliacaoProf' AS origem, dp.id AS denuncia_id, dp.comentario AS denuncia_comentario, ap.id AS avaliacao_id,
       ap.codProfessorAvaliacao AS codDisciplina, ap.valor, ap.comentario AS avaliacao_comentario, ap.codEstudanteAvaliacao AS codEstudante
FROM denunciaAvaliacaoProf dp
JOIN avaliacaoProf ap ON dp.codAvaliacaoProf = ap.id;


INSERT INTO departamento (nome) VALUES ('Departamento de Apoio ao desenvolvimento tecnológico - Brasília');
INSERT INTO departamento (nome) VALUES ('Centro de excelência em turismo - Brasília');
INSERT INTO departamento (nome) VALUES ('Centro UNB Cerrado - Brasília');
INSERT INTO departamento (nome) VALUES ('Departamento de Pesquisa Científica');
INSERT INTO departamento (nome) VALUES ('Departamento de Negócios e Empreendedorismo');
INSERT INTO departamento (nome) VALUES ('Departamento de Humanidades e Ciências Sociais');
INSERT INTO departamento (nome) VALUES ('Departamento de Engenharia e Computação');
INSERT INTO departamento (nome) VALUES ('Departamento de Saúde e Bem-Estar');

INSERT INTO professor (nome, codDepartamento) VALUES ('João Silva', 1);
INSERT INTO professor (nome, codDepartamento) VALUES ('Maria Santos', 2);
INSERT INTO professor (nome, codDepartamento) VALUES ('Pedro Almeida', 3);
INSERT INTO professor (nome, codDepartamento) VALUES ('Ana Oliveira', 4);
INSERT INTO professor (nome, codDepartamento) VALUES ('Carlos Pereira', 1);
INSERT INTO professor (nome, codDepartamento) VALUES ('Mariana Costa', 2);
INSERT INTO professor (nome, codDepartamento) VALUES ('José Santos', 3);
INSERT INTO professor (nome, codDepartamento) VALUES ('Fernanda Alves', 4);
INSERT INTO professor (nome, codDepartamento) VALUES ('André Ribeiro', 1);
INSERT INTO professor (nome, codDepartamento) VALUES ('Sara Carvalho', 2);
INSERT INTO professor (nome, codDepartamento) VALUES ('Ricardo Fernandes', 3);
INSERT INTO professor (nome, codDepartamento) VALUES ('Patrícia Sousa', 4);
INSERT INTO professor (nome, codDepartamento) VALUES ('Hugo Gomes', 1);
INSERT INTO professor (nome, codDepartamento) VALUES ('Camila Santos', 2);
INSERT INTO professor (nome, codDepartamento) VALUES ('Guilherme Silva', 3);
INSERT INTO professor (nome, codDepartamento) VALUES ('Laura Almeida', 4);

INSERT INTO disciplina (nome, codigo) VALUES ('Prática de pesquisa 1', 'ART101');
INSERT INTO disciplina (nome, codigo) VALUES ('Legislação turística', 'DAN201');
INSERT INTO disciplina (nome, codigo) VALUES ('Enoturismo', 'CUL301');
INSERT INTO disciplina (nome, codigo) VALUES ('Design de Jogos Digitais', 'GAM401');
INSERT INTO disciplina (nome, codigo) VALUES ('Fotografia Experimental', 'ART102');
INSERT INTO disciplina (nome, codigo) VALUES ('Criação de Roteiros', 'FIL202');
INSERT INTO disciplina (nome, codigo) VALUES ('Arquitetura Sustentável', 'ARC302');
INSERT INTO disciplina (nome, codigo) VALUES ('Design de Moda Futurista', 'FAS402');

INSERT INTO turma (turno, numero, periodo, codDisciplina, codProfessor) 
SELECT 
  'Manhã' AS turno,
  1 AS numero,
  '2023-1' AS periodo,
  id AS codDisciplina,
  (SELECT id FROM professor ORDER BY RAND() LIMIT 1) AS codProfessor
FROM disciplina
ORDER BY RAND() LIMIT 1;
INSERT INTO turma (turno, numero, periodo, codDisciplina, codProfessor) 
SELECT 
  'Tarde' AS turno,
  2 AS numero,
  '2023-1' AS periodo,
  id AS codDisciplina,
  (SELECT id FROM professor ORDER BY RAND() LIMIT 1) AS codProfessor
FROM disciplina
ORDER BY RAND() LIMIT 1;
INSERT INTO turma (turno, numero, periodo, codDisciplina, codProfessor) 
SELECT 
  'Noite' AS turno,
  3 AS numero,
  '2023-2' AS periodo,
  id AS codDisciplina,
  (SELECT id FROM professor ORDER BY RAND() LIMIT 1) AS codProfessor
FROM disciplina
ORDER BY RAND() LIMIT 1;
INSERT INTO turma (turno, numero, periodo, codDisciplina, codProfessor) 
SELECT 
  'Manhã' AS turno,
  1 AS numero,
  '2023-2' AS periodo,
  id AS codDisciplina,
  (SELECT id FROM professor ORDER BY RAND() LIMIT 1) AS codProfessor
FROM disciplina
ORDER BY RAND() LIMIT 1;
INSERT INTO turma (turno, numero, periodo, codDisciplina, codProfessor) 
SELECT 
  'Tarde' AS turno,
  2 AS numero,
  '2023-2' AS periodo,
  id AS codDisciplina,
  (SELECT id FROM professor ORDER BY RAND() LIMIT 1) AS codProfessor
FROM disciplina
ORDER BY RAND() LIMIT 1;
INSERT INTO turma (turno, numero, periodo, codDisciplina, codProfessor) 
SELECT 
  'Noite' AS turno,
  3 AS numero,
  '2023-1' AS periodo,
  id AS codDisciplina,
  (SELECT id FROM professor ORDER BY RAND() LIMIT 1) AS codProfessor
FROM disciplina
ORDER BY RAND() LIMIT 1;
INSERT INTO turma (turno, numero, periodo, codDisciplina, codProfessor) 
SELECT 
  'Manhã' AS turno,
  1 AS numero,
  '2023-2' AS periodo,
  id AS codDisciplina,
  (SELECT id FROM professor ORDER BY RAND() LIMIT 1) AS codProfessor
FROM disciplina
ORDER BY RAND() LIMIT 1;
INSERT INTO turma (turno, numero, periodo, codDisciplina, codProfessor) 
SELECT 
  'Tarde' AS turno,
  2 AS numero,
  '2023-2' AS periodo,
  id AS codDisciplina,
  (SELECT id FROM professor ORDER BY RAND() LIMIT 1) AS codProfessor
FROM disciplina
ORDER BY RAND() LIMIT 1;
INSERT INTO turma (turno, numero, periodo, codDisciplina, codProfessor) 
SELECT 
  'Noite' AS turno,
  3 AS numero,
  '2023-2' AS periodo,
  id AS codDisciplina,
  (SELECT id FROM professor ORDER BY RAND() LIMIT 1) AS codProfessor
FROM disciplina
ORDER BY RAND() LIMIT 1;
INSERT INTO turma (turno, numero, periodo, codDisciplina, codProfessor) 
SELECT 
  'Manhã' AS turno,
  1 AS numero,
  '2023-3' AS periodo,
  id AS codDisciplina,
  (SELECT id FROM professor ORDER BY RAND() LIMIT 1) AS codProfessor
FROM disciplina;

INSERT INTO estudante (nome, curso, matricula, email, senha, isAdmin)
VALUES ('Admin', 'Administração', '2023001', 'admin@example.com', 'senhaadmin', 1);
INSERT INTO estudante (nome, curso, matricula, email, senha, isAdmin)
VALUES ('João Silva', 'Engenharia Civil', '2023002', 'joao@example.com', 'senhajoao', 0);
INSERT INTO estudante (nome, curso, matricula, email, senha, isAdmin)
VALUES ('Maria Santos', 'Medicina', '2023003', 'maria@example.com', 'senhamaria', 0);
INSERT INTO estudante (nome, curso, matricula, email, senha, isAdmin)
VALUES ('Pedro Almeida', 'Arquitetura', '2023004', 'pedro@example.com', 'senhapedro', 0);
INSERT INTO estudante (nome, curso, matricula, email, senha, isAdmin)
VALUES ('Ana Oliveira', 'Direito', '2023005', 'ana@example.com', 'senhaana', 0);

INSERT INTO avaliacaoDisciplina (codDisciplina, valor, comentario, codEstudante)
VALUES (1, '5', 'Ótima disciplina!', 2);

INSERT INTO avaliacaoDisciplina (codDisciplina, valor, comentario, codEstudante)
VALUES (3, '4', 'Gostei do conteúdo abordado.', 3);

INSERT INTO avaliacaoDisciplina (codDisciplina, valor, comentario, codEstudante)
VALUES (2, '3', 'Poderia ter mais exemplos práticos.', 4);

INSERT INTO avaliacaoDisciplina (codDisciplina, valor, comentario, codEstudante)
VALUES (1, '4', 'Bom professor.', 5);

INSERT INTO avaliacaoDisciplina (codDisciplina, valor, comentario, codEstudante)
VALUES (4, '5', 'Recomendo esta disciplina.', 2);

INSERT INTO avaliacaoDisciplina (codDisciplina, valor, comentario, codEstudante)
VALUES (3, '3', 'Achei o conteúdo um pouco confuso.', 3);

INSERT INTO avaliacaoDisciplina (codDisciplina, valor, comentario, codEstudante)
VALUES (2, '4', 'O professor explica bem.', 4);

INSERT INTO avaliacaoDisciplina (codDisciplina, valor, comentario, codEstudante)
VALUES (1, '5', 'Disciplina interessante.', 5);

INSERT INTO avaliacaoDisciplina (codDisciplina, valor, comentario, codEstudante)
VALUES (4, '4', 'Aprendi bastante com esta disciplina.', 2);

INSERT INTO avaliacaoDisciplina (codDisciplina, valor, comentario, codEstudante)
VALUES (3, '4', 'Boa interação em sala de aula.', 3);

INSERT INTO avaliacaoProf (valor, comentario, codProfessorAvaliacao, codEstudanteAvaliacao)
VALUES (5, 'Excelente professor!', 1, 2);

INSERT INTO avaliacaoProf (valor, comentario, codProfessorAvaliacao, codEstudanteAvaliacao)
VALUES (4, 'Bom professor, explica bem.', 2, 3);

INSERT INTO avaliacaoProf (valor, comentario, codProfessorAvaliacao, codEstudanteAvaliacao)
VALUES (3, 'Professor mediano.', 3, 4);

INSERT INTO avaliacaoProf (valor, comentario, codProfessorAvaliacao, codEstudanteAvaliacao)
VALUES (5, 'Ótimo professor, domina o assunto.', 4, 5);

INSERT INTO avaliacaoProf (valor, comentario, codProfessorAvaliacao, codEstudanteAvaliacao)
VALUES (4, 'Professor acessível e disposto a ajudar.', 1, 2);

INSERT INTO avaliacaoProf (valor, comentario, codProfessorAvaliacao, codEstudanteAvaliacao)
VALUES (3, 'Professor com dificuldades de explicação.', 2, 3);

INSERT INTO avaliacaoProf (valor, comentario, codProfessorAvaliacao, codEstudanteAvaliacao)
VALUES (5, 'Professor motivador e inspirador.', 3, 4);

INSERT INTO avaliacaoProf (valor, comentario, codProfessorAvaliacao, codEstudanteAvaliacao)
VALUES (4, 'Professor com bom conhecimento teórico.', 4, 5);

INSERT INTO avaliacaoProf (valor, comentario, codProfessorAvaliacao, codEstudanteAvaliacao)
VALUES (3, 'Professor desorganizado em suas aulas.', 1, 2);

INSERT INTO avaliacaoProf (valor, comentario, codProfessorAvaliacao, codEstudanteAvaliacao)
VALUES (5, 'Professor dedicado e comprometido.', 2, 3);

INSERT INTO denunciaAvaliacaoDisciplina (comentario, codAvaliacaoDisciplina)
VALUES ('Esta avaliação contém informações falsas.', 1);

INSERT INTO denunciaAvaliacaoDisciplina (comentario, codAvaliacaoDisciplina)
VALUES ('Avaliação com linguagem ofensiva.', 2);

INSERT INTO denunciaAvaliacaoDisciplina (comentario, codAvaliacaoDisciplina)
VALUES ('Suspeita de plágio nesta avaliação.', 3);

INSERT INTO denunciaAvaliacaoProf (comentario, codAvaliacaoProf)
VALUES ('Avaliação com informações enganosas.', 1);

INSERT INTO denunciaAvaliacaoProf (comentario, codAvaliacaoProf)
VALUES ('Comentário ofensivo na avaliação.', 3);

INSERT INTO denunciaAvaliacaoProf (comentario, codAvaliacaoProf)
VALUES ('Suspeita de plágio na avaliação realizada.', 2);
