------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
----		TESTS
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------

spool E:\THOR\BDOO_EM\TP_ROO_EM_2015\TP4_ROO_NESTED_TABLE_2015\TRACE_SOL_ET_TESTS_V2.TXT

------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- IV.1. Ajouter l��tudiant num�ro 60 dans la classe num�ro 4
	inseret into TABLE(SELECT LISTE_ELEVES FROM TAB_CLASSES WHERE NUMCLASSE=4)
	VALUES ((SELECT REF(D) FROM TAB_ELEVES D WHERE D.NUMETD=60));
	
	-- VALIDATION
	COMMIT;

	-- VERIFICATION EN SELECTIONANT LES NUMETD DE TOUS LES ELEVES
	-- DE LA CLASSE 4
	
	SELECT E.NUMETD, E.NOM
	FROM TAB_ELEVES E
	WHERE REF(E) 
		IN 
		(SELECT LE.* FROM TAB_CLASSES C, TABLE(C.LISTE_ELEVES) LE WHERE NUMCLASSE=4);

------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- IV.3. Mettre la date d�inscription de tous les �tudiants de la classe 4 � 1/1/2010.

	UPDATE TAB_ELEVES E
	SET E.ANNEINSCRIP='1/1/2010'
	WHERE REF(E) IN (SELECT LE.* FROM TAB_CLASSES C, TABLE(C.LISTE_ELEVES) LE WHERE NUMCLASSE=4);    

	--VALIDATION
	COMMIT;
	
	-- VERIFICATION
	SELECT E.NUMETD, E.NOM, E.ANNEINSCRIP
	FROM TAB_ELEVES E
	WHERE REF(E) 
		IN 
		(SELECT LE.* FROM TAB_CLASSES C, TABLE(C.LISTE_ELEVES) LE WHERE NUMCLASSE=4);

------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- IV.4. Afficher, par une requ�te SQL, la liste des r�f�rences des cours 
-- programm�s et non pr�vus pour la classe num�ro 4.

	SELECT DISTINCT(REFC.COURS) 
	FROM TAB_CLASSES C1, TABLE(C1.LISTE_SEANCES) REFC 
	WHERE 	C1.NUMCLASSE=4 
		AND 
	REFC.COURS NOT IN (SELECT CP.* FROM TAB_CLASSES C2, TABLE(C2.LISTE_COURS) CP WHERE C2.NUMCLASSE=4); 


	-- AVEC MINUS
	SELECT DISTINCT(REFC.COURS) 
	FROM TAB_CLASSES C1, TABLE(C1.LISTE_SEANCES) REFC 
	WHERE 	C1.NUMCLASSE=4 
		MINUS
	SELECT CP.* 
	FROM TAB_CLASSES C2, TABLE(C2.LISTE_COURS) CP 
	WHERE C2.NUMCLASSE=4;

------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- IV.5. Afficher, par une requ�te SQL, la liste des r�f�rences des cours 
-- pr�vus et non programm�s pour la classe num�ro 4.

	SELECT DISTINCT(REFC.*) 
	FROM TAB_CLASSES C1, TABLE(C1.LISTE_COURS) REFC 
	WHERE 	C1.NUMCLASSE=4 
		AND 
	REFC.COURS NOT IN (SELECT CP.* FROM TAB_CLASSES C2, TABLE(C2.LISTE_COURS) CP WHERE C2.NUMCLASSE=4); 


	-- AVEC MINUS
	SELECT DISTINCT(REFC.COURS) 
	FROM TAB_CLASSES C1, TABLE(C1.LISTE_SEANCES) REFC 
	WHERE 	C1.NUMCLASSE=4 
		MINUS
	SELECT CP.* 
	FROM TAB_CLASSES C2, TABLE(C2.LISTE_COURS) CP 
	WHERE C2.NUMCLASSE=4;

------------------------------------------------------------------------------
------------------------------------------------------------------------------



--- inerion par requete SQL

-- QUESTION 1:
-- AJOUTER UN NOUVELLE ETUDIANT DANS LA CLASSE NUMERO 4
INSERT INTO TABLE(SELECT LISTE_ELEVES FROM TAB_CLASSES WHERE NUMCLASSE=4)
VALUES ((SELECT REF(D) FROM TAB_ELEVES D WHERE D.NUMETD=60));


-- VERIFIER L'INSERTION
--SELECT DEREF(D.*) FROM TAB_CLASSES C, TABLE(C.LISTE_ELEVES) D;
SELECT NUMETD
FROM TAB_ELEVES D
WHERE REF(D) IN (SELECT E.* FROM TAB_CLASSES C, TABLE(C.LISTE_ELEVES) E WHERE C.NUMCLASSE=4);
 
-- QUESTION 1: ECRIRE UN BLOC PL/SQL POUR AFFICHER LA LISTE DES ELEVES DE LA 
-- CLASSE NUMERO 1: NUMETD ET NOM

-- QUESTION: AFFICHER DANS UN BLOC PL/SQL LA LSITE DES ETUDIANTS: 

DECLARE
	TYPE RECORD_ELEVE IS RECORD (
		NUMETD		NUMBER(10),
 		NOM             VARCHAR2(20)
	); 

	ELEVE		RECORD_ELEVE;
	TAB_TEMP	T_LISTE_ELEVES;
	NBR		NUMBER:=0;
	ELE		NUMBER;
BEGIN

	SELECT LISTE_ELEVES INTO TAB_TEMP
	FROM TAB_CLASSES
	WHERE NUMCLASSE=1;

	NBR := TAB_TEMP.COUNT();
	DBMS_OUTPUT.PUT_LINE (NBR);

	FOR ELE IN TAB_TEMP.FIRST..TAB_TEMP.LAST LOOP
		SELECT NUMETD, NOM INTO ELEVE
		FROM TAB_ELEVES D
		WHERE REF(D)=TAB_TEMP(ELE);
		DBMS_OUTPUT.PUT_LINE (ELEVE.NUMETD||'  '||ELEVE.NOM);
	END LOOP;
	
END;
/

------------------------------------------------------------------------------
----		TEST  V2
------------------------------------------------------------------------------

-- QUESTION: AFFICHER PAR UNE REQUETE LA LISTE DES ELEVES

SELECT E.*
FROM TAB_ELEVES E
WHERE REF(E) 
	IN 
	(SELECT LE.* FROM TAB_CLASSES C, TABLE(C.LISTE_ELEVES) LE WHERE NUMCLASSE=1);

-- MEME CHOSE AVEC UN CURSSEUR
-- TEST AVEC L'APPLATISSEUR TABLE ET UN CURSOR

DECLARE
	CURSOR LISTE_ELEVES_CLASSE_1 IS
	SELECT E.*
	FROM TAB_ELEVES E
	WHERE REF(E) 
			IN 
		(SELECT LE.* FROM TAB_CLASSES C, TABLE(C.LISTE_ELEVES) LE WHERE NUMCLASSE=1);
	
	TYPE RECORD_ELEVE IS RECORD (
		NUMETD		NUMBER(10),
 		NOM             VARCHAR2(20),
 		PRENOM          VARCHAR2(20),
 		ANNEINSCRIP     DATE
	); 

	ELEVE	RECORD_ELEVE;
BEGIN
	OPEN LISTE_ELEVES_CLASSE_1;
	FETCH LISTE_ELEVES_CLASSE_1 INTO ELEVE;
	WHILE (LISTE_ELEVES_CLASSE_1%FOUND) LOOP
		--DBMS_OUTPUT.PUT_LINE ('NBR ELEVES:'||'  '||ELE.LESELEVES.COUNT());
		DBMS_OUTPUT.PUT_LINE (ELEVE.NUMETD||'  '||ELEVE.NOM);
		FETCH LISTE_ELEVES_CLASSE_1 INTO ELEVE;
	END LOOP;
END;
/

------------------------------------------------------------------------------
----		TEST  V3
------------------------------------------------------------------------------
--  QUESTION: LA LSITE DES COURS PROGRAMMES ET NON PREVUS PAR REQUETES POUR LA CLASSE NUMERO 4

-- OK
SELECT DISTINCT(REFC.COURS) 
FROM TAB_CLASSES C1, TABLE(C1.LISTE_SEANCES) REFC 
WHERE 	C1.NUMCLASSE=4 
		AND 
	REFC.COURS NOT IN (SELECT CP.* FROM TAB_CLASSES C2, TABLE(C2.LISTE_COURS) CP WHERE C2.NUMCLASSE=4); 
-- MEME CHOSE PLUS SIMPLE AVEC MINUS
--ok

SELECT DISTINCT(REFC.COURS) 
FROM TAB_CLASSES C1, TABLE(C1.LISTE_SEANCES) REFC 
WHERE 	C1.NUMCLASSE=4 
	MINUS
SELECT CP.* 
FROM TAB_CLASSES C2, TABLE(C2.LISTE_COURS) CP 
WHERE C2.NUMCLASSE=4;

-- MEME CHOSE AVEC L'INTITULE
-- QUESTION: LA LSITE DES COURS (NUMCOURS ET INTIT) PROGRAMMES ET NON PREVUS PAR REQUETES POUR LA CLASSE NUMERO 4

SELECT D.NUMCOURS, D.INTIT
FROM TAB_COURS D
WHERE REF(D) IN (
	SELECT DISTINCT(REFC.COURS) 
	FROM TAB_CLASSES C1, TABLE(C1.LISTE_SEANCES) REFC 
	WHERE 	C1.NUMCLASSE=4 
	MINUS
	SELECT CP.* 
	FROM TAB_CLASSES C2, TABLE(C2.LISTE_COURS) CP 
	WHERE C2.NUMCLASSE=4
);

----



------------------------------------------------------------------------------
----		TEST  1
------------------------------------------------------------------------------


-- OLD VERSION AVEC TABLE DES ELEVES IMBRIQUEES
------------------------------------------------------------------------------
----		TEST  1
------------------------------------------------------------------------------
--RECUPERATION DE LA TABLE IMBRIQUEE DANS UNE VARIABLE
SET SERVEROUTPUT ON;
DECLARE
	TAB_TEMP	T_LISTE_ELEVES;
	NBR		NUMBER:=0;
BEGIN

	SELECT LESELEVES INTO TAB_TEMP
	FROM TAB_CLASSES
	WHERE NUMCLASSE=3;

	NBR := TAB_TEMP.COUNT();
	DBMS_OUTPUT.PUT_LINE (NBR);

	/* FOR ELE IN 1..NBR LOOP
		DBMS_OUTPUT.PUT_LINE ('ELE.NUMELEVE');
	END LOOP;
	*/
END;
/

-- REMARQUE: CA MARCHE. ON PEUT RECUPERER UNE TABLE IMBRIQUEE
-- DANS UNE VARIABLE LOCALE ET LUI APPLIQUER DES FTCS COMME COUNT
-- EST CE LA BONNE FACON DE FAIRE????

------------------------------------------------------------------------------
----		TEST  2
------------------------------------------------------------------------------

--TEST D'ACCES a CHAQUE LIGNE D'UNE TABLE

-- QUESTION: AFFICHER DANS UN BLOC PL/SQL LA LSITE DES ETUDIANTS: NUMETD ET NOM

DECLARE
	TAB_TEMP	T_LISTE_ELEVES;
	NBR		NUMBER:=0;
BEGIN

	SELECT LESELEVES INTO TAB_TEMP
	FROM TAB_CLASSES
	WHERE NUMCLASSE=3;

	NBR := TAB_TEMP.COUNT();
	DBMS_OUTPUT.PUT_LINE (NBR);

	FOR ELE IN TAB_TEMP.FIRST..TAB_TEMP.LAST LOOP
		DBMS_OUTPUT.PUT_LINE (TAB_TEMP(ELE).NUMETD||'  '||TAB_TEMP(ELE).NOM);
	END LOOP;
	
END;
/

--REMARQUE: POUR ACCEDER A UNE LIGNE D'UNE TABLE IMBRIQUEE, IL FAUT 
-- NOM_TABLE(INDICE).CHAMPS

------------------------------------------------------------------------------
----		TEST  3
------------------------------------------------------------------------------
-- MEME CHOSE AVEC UN CURSSEUR

-- QUESTION: AFFICHER DANS UN BLOC PL/SQL LA LSITE DES ETUDIANTS DE CHAQUE CLASSE: 
--	NUMETD ET NOM

DECLARE
	CURSOR LISTE_ELEVES_CLASSE_3 IS
	SELECT NUMCLASSE, LESELEVES FROM TAB_CLASSES ; --WHERE NUMCLASSE=3
	TAB_TEMP	T_LISTE_ELEVES;
BEGIN

	FOR ELE IN LISTE_ELEVES_CLASSE_3 LOOP
		DBMS_OUTPUT.PUT_LINE ('CLASSE NUMERO : '|| ELE.NUMCLASSE||'  '||' NBR ELEVES:'||'  '||ELE.LESELEVES.COUNT());
		DBMS_OUTPUT.PUT_LINE ('LA LISTE DES ELEVES : ');
		TAB_TEMP:=ELE.LESELEVES;
		IF TAB_TEMP.COUNT>0  --IS NOT NULL 
		THEN
			FOR I IN TAB_TEMP.FIRST..TAB_TEMP.LAST LOOP
				DBMS_OUTPUT.PUT_LINE (TAB_TEMP(I).NUMETD||'  '||TAB_TEMP(I).NOM);
			END LOOP;
		ELSE DBMS_OUTPUT.PUT_LINE ('LA LISTE DES VIDE');
		END IF;
	END LOOP;
	
END;
/

-- REMARQUE: CA MARCHAIT. l'ERREUR ETAIT A CAUSE DE LA LISTE DES ELEVES VIDE
-- L AFFECTATION ENTRE LES TABLES MARCHE
-- IS NOT NULL NE MARCHE PAS POUR TESTER SI UNETABLE IMBRIQUEE EST VIDE
-- AVEC LE TEST TAB_TEMP.COUNT>0 CA MARCHE

------------------------------------------------------------------------------
----		TEST  4
------------------------------------------------------------------------------
-- J ESSAIE LA MEME CHOSE AVEC ELE.LESELEVES DIRECTEMENT


DECLARE
	CURSOR LISTE_ELEVES_CLASSE_3 IS
	SELECT NUMCLASSE, LESELEVES FROM TAB_CLASSES ; --WHERE NUMCLASSE=3
	TAB_TEMP	T_LISTE_ELEVES;
BEGIN

	FOR ELE IN LISTE_ELEVES_CLASSE_3 LOOP
		DBMS_OUTPUT.PUT_LINE ('CLASSE NUMERO : '|| ELE.NUMCLASSE||'  '||' NBR ELEVES:'||'  '||ELE.LESELEVES.COUNT());
		DBMS_OUTPUT.PUT_LINE ('LA LISTE DES ELEVES : ');
		--TAB_TEMP:=ELE.LESELEVES;
		IF ELE.LESELEVES.COUNT>0  --IS NOT NULL 
		THEN
			FOR I IN ELE.LESELEVES.FIRST..ELE.LESELEVES.LAST LOOP
				DBMS_OUTPUT.PUT_LINE (ELE.LESELEVES(I).NUMETD||'  '||ELE.LESELEVES(I).NOM);
			END LOOP;
		ELSE DBMS_OUTPUT.PUT_LINE ('LA LISTE DES VIDE');
		END IF;
	END LOOP;
	
END;
/

-- CA MARCHE

------------------------------------------------------------------------------
----		TEST  5
------------------------------------------------------------------------------
-- JE FAIS LA MEME CHOSE AVEC UN CURSOR ET UNIQUEMENT LA CLASSE 3
-- ET JE RECUPERE DANS LE CURSSEUR UNIQUEMENT LA TABLE IMBRIQUE LESELEVES

DECLARE
	CURSOR LISTE_ELEVES_CLASSE_3 IS
	SELECT LESELEVES FROM TAB_CLASSES WHERE NUMCLASSE=3;
BEGIN

	FOR ELE IN LISTE_ELEVES_CLASSE_3 LOOP
		DBMS_OUTPUT.PUT_LINE ('NBR ELEVES:'||'  '||ELE.LESELEVES.COUNT());
		DBMS_OUTPUT.PUT_LINE ('LA LISTE DES ELEVES : ');
		IF ELE.LESELEVES.COUNT>0  --IS NOT NULL 
		THEN
			FOR I IN ELE.LESELEVES.FIRST..ELE.LESELEVES.LAST LOOP
				DBMS_OUTPUT.PUT_LINE (ELE.LESELEVES(I).NUMETD||'  '||ELE.LESELEVES(I).NOM);
			END LOOP;
		ELSE DBMS_OUTPUT.PUT_LINE ('LA LISTE DES VIDE');
		END IF;
	END LOOP;
	
END;
/

-- CA MARCHE. POUR ACCEDER A LA TABLE IMBRIQUEE: NOM_CURSOR.NOM_ATT_TAB_IMBRIQUEE

------------------------------------------------------------------------------
----		TEST  6
------------------------------------------------------------------------------
-- TEST AVEC L'APPLATISSEUR TABLE ET UN CURSOR

DECLARE
	CURSOR LISTE_ELEVES_CLASSE_3 IS
	SELECT E.* FROM TAB_CLASSES C, TABLE(C.LESELEVES) E WHERE C.NUMCLASSE=3;

	TYPE RECORD_ELEVE IS RECORD (
		NUMETD		NUMBER(10),
 		NOM             VARCHAR2(20),
 		PRENOM          VARCHAR2(20),
 		ANNEINSCRIP     DATE
	); 

	ELEVE	RECORD_ELEVE;
BEGIN
	OPEN LISTE_ELEVES_CLASSE_3;
	FETCH LISTE_ELEVES_CLASSE_3 INTO ELEVE;
	WHILE (LISTE_ELEVES_CLASSE_3%FOUND) LOOP
		--DBMS_OUTPUT.PUT_LINE ('NBR ELEVES:'||'  '||ELE.LESELEVES.COUNT());
		DBMS_OUTPUT.PUT_LINE (ELEVE.NUMETD||'  '||ELEVE.NOM);
		FETCH LISTE_ELEVES_CLASSE_3 INTO ELEVE;
	END LOOP;
END;
/

-- POUR LE TYPE DU RECUPERATION D'uN ELEMENT DU CURSSEUR
-- LE T_ELEVE NE MARCHE PAS
-- ESSAYONS LE TYPE DE LA TABLE IMBRIQUE
-- MEME T_LISTE_ELEVES%ROWTYPE NE MARCHE PAS;