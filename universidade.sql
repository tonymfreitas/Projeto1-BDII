prompt Criando tablespaces. Por favor aguarde... 


CREATE TABLESPACE universidade LOGGING DATAFILE
'C:\APP\FFCOSTA\ORADATA\ORCL\universidade.dbf' size 100m
AUTOEXTEND ON NEXT 100m EXTENT MANAGEMENT LOCAL;


CREATE TEMPORARY TABLESPACE universidade_temp TEMPFILE
'C:\APP\FFCOSTA\ORADATA\ORCL\universidade_temp.dbf' size 100m
AUTOEXTEND ON NEXT 100m EXTENT MANAGEMENT LOCAL;


prompt Criando usuario. Por favor aguarde... 

create user user_univers identified by 123456  
default tablespace universidade quota unlimited on universidade
temporary tablespace universidade_temp;

alter user user_univers account unlock;
GRANT CREATE SESSION TO user_univers;
GRANT ALL PRIVILEGES TO user_univers;

connect user_univers/123456


prompt Criando TABELAS. Por favor aguarde... 


CREATE TABLE ENDERECO (
  IdEnd number(8) NOT NULL ,
  logradouro varchar(30) NOT NULL,
  num NUMBER(6) DEFAULT NULL,
  complemento varchar(30) DEFAULT NULL,
  bairro varchar(30) DEFAULT NULL,
  cidade varchar(30) DEFAULT NULL,
  cep varchar(12) DEFAULT NULL,
  estado varchar(30) DEFAULT NULL,
  pais varchar(30) DEFAULT NULL,
CONSTRAINT ENDERECO_PK PRIMARY KEY (IdEnd));

CREATE TABLE PESSOA (
  Matricula char(10) NOT NULL,
  DtMat date ,
  Cpf char(11) NOT NULL,
  Num_Idt varchar2(12),
  OrgaoExp_Idt varchar2(10),
  NomeComp varchar2(40) NOT NULL,
  Dt_Nasc date,
  Sexo char(1),
  Login varchar2(15),
  Senha varchar2(15),
  IdEnd number(8),
 CONSTRAINT PESSOA_PK PRIMARY KEY (Matricula),
CONSTRAINT ENDERECO_FK FOREIGN KEY(IdEnd) REFERENCES ENDERECO(IdEnd)
ON DELETE CASCADE ENABLE);

CREATE TABLE INSTITUTO (
  CodInst number(5) NOT NULL,
  NomeInst varchar2(30) NOT NULL,
  CONSTRAINT INSTITUTO_PK PRIMARY KEY (CodInst)
);

CREATE TABLE COORDENADOR (
  Matricula char(10) NOT NULL,
  AdicionalCoord NUMBER(11,2) DEFAULT NULL,
  CodInst number(5) DEFAULT NULL,
  CONSTRAINT COORDENADOR_PK PRIMARY KEY (Matricula),
CONSTRAINT COORDENADOR_PESSOA_FK1 FOREIGN KEY(MATRICULA) REFERENCES PESSOA(MATRICULA) ON DELETE CASCADE ENABLE,
CONSTRAINT COORDENADOR_INSTITUTO_FK1 FOREIGN KEY(CODINST) REFERENCES INSTITUTO(CODINST)
ON DELETE CASCADE ENABLE);

CREATE TABLE TECNICO_ADM(
  Matricula char(10) NOT NULL,
  Salario number(11,2) DEFAULT NULL,
  Funcao varchar2(20) DEFAULT NULL,
  CodInst number(5) DEFAULT NULL,
  CONSTRAINT TECNICO_ADM_PK PRIMARY KEY (Matricula),
CONSTRAINT TECNICO_ADM_PESSOA_FK1 FOREIGN KEY(MATRICULA) REFERENCES PESSOA(MATRICULA) ON DELETE CASCADE ENABLE,
CONSTRAINT TECNICO_ADM_INSTITUTO_FK1 FOREIGN KEY(CODINST) REFERENCES INSTITUTO(CODINST) ON DELETE CASCADE ENABLE
); 

CREATE TABLE PROFESSOR (
  Matricula char(10) NOT NULL,
  Salario number(11,2) DEFAULT NULL,
  Titulo varchar2(50) DEFAULT NULL,
  CodInst number(5) DEFAULT NULL,
CONSTRAINT PROFESSOR_PK PRIMARY KEY (Matricula),
  CONSTRAINT PROFESSOR_PESSOA_FK1 FOREIGN KEY(MATRICULA) REFERENCES PESSOA(MATRICULA) ON DELETE CASCADE ENABLE,
CONSTRAINT PROFESSOR_INSTITUTO_FK1 FOREIGN KEY(CODINST) REFERENCES INSTITUTO(CODINST) ON DELETE CASCADE ENABLE
);

CREATE TABLE CURSO (
  CodC number(6) NOT NULL,
  NomeCurso varchar2(30) NOT NULL,
  MatCoor char(10) DEFAULT NULL,
  DtInicoor date DEFAULT NULL,
  CodInst number(5) DEFAULT NULL,
CONSTRAINT CURSO_PK PRIMARY KEY (CodC) ENABLE,
  CONSTRAINT CURSO_COORDENADOR_FK1 FOREIGN KEY(MAtCoor) REFERENCES COORDENADOR(MATRICULA) ON DELETE CASCADE ENABLE,
CONSTRAINT CURSO_INSTITUTO_FK1 FOREIGN KEY(COdInst) REFERENCES INSTITUTO(CODINST) ON DELETE CASCADE ENABLE
);

CREATE TABLE ALUNO (
  Matricula char(10) NOT NULL,
  AtendEsp varchar(5) DEFAULT NULL,
  CodC number(6) NOT NULL,
CONSTRAINT ALUNO_PK PRIMARY KEY (Matricula) ENABLE,
CONSTRAINT ALUNO_PESSOA_FK1 FOREIGN KEY(MATRICULA) REFERENCES PESSOA(MATRICULA) ON DELETE CASCADE ENABLE,
 CONSTRAINT ALUNO_CURSO_FK1 FOREIGN KEY(CodC) REFERENCES CURSO(CODC) ON DELETE CASCADE ENABLE
);

CREATE TABLE DISCIPLINA (
  CodDisc number(6) NOT NULL,
  NomeDisc varchar2(50) NOT NULL,
  CargaHoraria number(4) DEFAULT NULL,
CONSTRAINT DISCIPLINA_PK PRIMARY KEY (CodDisc) ENABLE
);

CREATE TABLE TURMA(
  CODDISC NUMBER(6) NOT NULL, 
  SEMESTRE VARCHAR(5) NOT NULL,
 ANO NUMBER(4) NOT NULL,
 MATP CHAR(10),
 CONSTRAINT TURMA_PK PRIMARY KEY(CODDISC, SEMESTRE, ANO) ENABLE,
CONSTRAINT TURMA_DISCIPLINA_FK1 FOREIGN KEY(CODDISC) REFERENCES DISCIPLINA(CODDISC) ON DELETE CASCADE ENABLE,
CONSTRAINT TURMA_PROFESSOR_FK1 FOREIGN KEY(MATP) REFERENCES PROFESSOR(MATRICULA) ON DELETE CASCADE ENABLE 
);
CREATE TABLE GRADUACAO (
  SituacaoGrad varchar2(15) NOT NULL,
  Matricula char(10) NOT NULL,
  DtMudancaSit date NOT NULL,
  CONSTRAINT GRADUACAO_PK PRIMARY KEY (SituacaoGrad, Matricula, DtMudancaSit),
  CONSTRAINT GRADUACAO_ALUNO_FK1 FOREIGN KEY(Matricula) REFERENCES ALUNO(MATRICULA) ON DELETE CASCADE ENABLE
);

CREATE TABLE GRADE_CURRICULAR(
  CodDisc number(6) NOT NULL,
  CodC number(6) NOT NULL,
  PeriodoFluxo varchar2(10) DEFAULT NULL,
  CONSTRAINT GRADE_CURRICULAR_PK PRIMARY KEY (CodDisc, CodC),
CONSTRAINT GRADE_CURRICULAR_ALUNO_FK1 FOREIGN KEY(CodDisc) REFERENCES DISCIPLINA(CodDisc) ON DELETE CASCADE ENABLE,
CONSTRAINT GRADE_CURRICULAR_ALUNO_FK2 FOREIGN KEY(CodC) REFERENCES CURSO(CodC) ON DELETE CASCADE ENABLE
);

CREATE TABLE TELEFONE_PESSOA(
  Matricula char(10) NOT NULL,
  Telefone varchar2(20) NOT NULL,
  CONSTRAINT TELEFONE_PESSOA_PK PRIMARY KEY (Matricula, Telefone),
CONSTRAINT TELEFONE_PESSOA_PESSOA_FK1 FOREIGN KEY(Matricula) REFERENCES PESSOA(Matricula) ON DELETE CASCADE ENABLE
);

CREATE TABLE EMAIL_PESSOA(
  Matricula char(10) NOT NULL,
  Email varchar2(40) NOT NULL,
  CONSTRAINT EMAIL_PESSOA_PK PRIMARY KEY (Matricula, Email),
CONSTRAINT EMAIL_PESSOA_PESSOA_FK1 FOREIGN KEY(Matricula) REFERENCES PESSOA(Matricula) ON DELETE CASCADE ENABLE
);

CREATE TABLE HORARIO_TURMA(
 CODDISC NUMBER(6) NOT NULL, 
  SEMESTRE VARCHAR(1) NOT NULL,
 ANO NUMBER(4) NOT NULL,
HORARIO VARCHAR2(10) NOT NULL,
  CONSTRAINT HORARIO_TURMA_PK PRIMARY KEY (CODDISC, SEMESTRE, ANO, HORARIO),
CONSTRAINT HORARIO_TURMA_FK1 FOREIGN KEY(CODDISC, SEMESTRE, ANO) REFERENCES TURMA(CODDISC, SEMESTRE, ANO) ON DELETE CASCADE ENABLE
);


CREATE TABLE SALA_TURMA(
 CODDISC NUMBER(6) NOT NULL, 
  SEMESTRE VARCHAR(1) NOT NULL,
 ANO NUMBER(4) NOT NULL,
SALA VARCHAR2(20) NOT NULL,
  CONSTRAINT SALA_TURMA_PK PRIMARY KEY (CODDISC, SEMESTRE, ANO, SALA),
CONSTRAINT SALA_TURMA_FK1 FOREIGN KEY(CODDISC, SEMESTRE, ANO) REFERENCES TURMA(CODDISC, SEMESTRE, ANO) ON DELETE CASCADE ENABLE
);

CREATE TABLE TURMAS_SEMESTRE(
 CODDISC NUMBER(6) NOT NULL, 
  SEMESTRE VARCHAR(1) NOT NULL,
 ANO NUMBER(4) NOT NULL,
Matricula CHAR(10) NOT NULL,
HORASFALTAS NUMBER(4),
STATUSALUNO VARCHAR2(15),
  CONSTRAINT TURMAS_SEMESTRE_PK PRIMARY KEY (CODDISC, SEMESTRE, ANO, Matricula),
CONSTRAINT TURMAS_SEMESTRE_FK1 FOREIGN KEY(CODDISC, SEMESTRE, ANO) REFERENCES TURMA(CODDISC, SEMESTRE, ANO) ON DELETE CASCADE ENABLE,
CONSTRAINT TURMAS_SEMESTRE_FK2 FOREIGN KEY(Matricula) REFERENCES ALUNO(MATRICULA) ON DELETE CASCADE ENABLE
);

CREATE TABLE NOTAS_TURMAS(
 CODDISC NUMBER(6) NOT NULL, 
  SEMESTRE VARCHAR(1) NOT NULL,
 ANO NUMBER(4) NOT NULL,
Matricula CHAR(10) NOT NULL,
NOTA NUMBER(5,2),
  CONSTRAINT NOTAS_TURMAS_PK PRIMARY KEY (CODDISC, SEMESTRE, ANO, Matricula, NOTA),
CONSTRAINT NOTAS_TURMAS_FK1 FOREIGN KEY(CODDISC, SEMESTRE, ANO) REFERENCES TURMA(CODDISC, SEMESTRE, ANO) ON DELETE CASCADE ENABLE,
CONSTRAINT NOTAS_TURMAS_FK2 FOREIGN KEY(Matricula) REFERENCES ALUNO(MATRICULA) ON DELETE CASCADE ENABLE
);

prompt Criando tablespace indices e os index. Por favor aguarde... 


CREATE TABLESPACE indices LOGGING DATAFILE
'C:\APP\FFCOSTA\ORADATA\ORCL\indices.dbf' size 100m
AUTOEXTEND ON NEXT 100m EXTENT MANAGEMENT LOCAL;

Create index nota
on notas_turmas (nota)
tablespace indices;


Create index horas
on turmas_semestre (horasfaltas)
tablespace indices;


Create index atendimentoesp
on aluno (Matricula, AtendEsp)
tablespace indices;


Create index salarioProf
on professor (CodInst, Salario)
tablespace indices;


Create index sexo
on pessoa (sexo)
tablespace indices;


Create index Cpf
on pessoa (Cpf)
tablespace indices;


Create index dataNasc
on pessoa (NomeComp, Dt_Nasc)
tablespace indices;

Create index dataIni
on pessoa (NomeComp, DtMat)
tablespace indices;




