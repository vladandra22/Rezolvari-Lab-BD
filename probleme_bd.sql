------- LAB4 ------

-- 1. Alegeti angajatii care nu au comision, afisand "ANGAJATUL x ARE SALARIUL.."
-- SELECT 'ANGAJATUL ' || ename || ' ARE SALARIUL ' || sal salariu from emp
-- WHERE nvl(comm, 0) = 0;

-- 2. Pt fiecare angajat care are un job diferit de o valoare citita de la tastatura 
-- si care are are un comision, sa se afiseze output de forma 
-- 'ANGAJATUL x ARE BONUS ... COMM'    |     JOB. (2 coloane dif.)

-- SELECT 'ANGAJATUL ' || ename ||' ARE BONUS ' || comm bonus, job 
-- FROM emp
-- WHERE job NOT LIKE '&1' AND nvl(comm, 0) != 0;


-- 3. Sa se afiseze pentru fiecare angajat care a venit in firma in anul citit
-- de la tastatura si care are sef: numele angajatului, id-ul sefului, data angajarii.

-- SELECT ename, mgr, hiredate FROM emp
-- WHERE TO_CHAR(HIREDATE, 'YYYY') LIKE '&1' AND MGR IS NOT NULL;

------ LAB 5 ------
-- 1. Pentru toti angajatii care NU lucreaza in New York si care NU au in interiorul
-- numelor lor litera C si care primesc comision, sa se afiseze:
--  numele, denumirea departamentului si venitul.

-- SELECT a.ename, d.dname, a.sal + nvl(a.comm, 0) venit 
-- FROM emp a 
-- JOIN dept d ON a.deptno = d.deptno 
-- WHERE d.loc NOT LIKE 'NEW YORK' AND MGR not LIKE '%C' AND nvl(a.comm, 0) != 0;

-- 2. Pentru toti angajatii care fac parte dintr-un departament cu denumirea 
-- citita de la tastatura si care au venit din firma incepand cu anul 1981, 
-- sa se selecteze: numele, denumirea departamentului si data angajarii.

-- !! Puteam face si cu JOIN dept d ON a.deptno = d.deptno, dar sunt singurele coloane egale
-- deci putem folosi natural join.

-- !! Putem folosi si a.hiredate > TO_DATE('31-12-1980', 'DD-MM-YYYY')
-- ACCEPT departament CHAR PROMPT 'Introduceti departamentul: ';
-- SELECT a.ename, d.dname, a.hiredate FROM emp a
-- NATURAL JOIN dept d
-- WHERE d.dname = '&departament' AND TO_CHAR(a.hiredate, 'YYYY') >= 1981
-- ORDER BY a.hiredate;

-- 3. Pentru toti angajatii care castiga mai putin decat seful lor, sa se afiseze:
-- numele angajatului, numele sefului si gradul salarial al angajatului.
-- SELECT a.ename, s.ename, g.grade 
-- FROM emp a 
-- JOIN emp s ON a.mgr = s.empno
-- JOIN salgrade g ON a.sal BETWEEN g.losal AND g.hisal
-- WHERE a.sal + nvl(a.comm, 0) < s.sal + nvl(s.comm, 0);

-- 4. Outer join: Daca ramane vreun departament neatribuit nimanui, afisam NULL in stanga.
-- Folosim right outer join pt. a include toate randurile din tabela dept,
-- chiar daca nu au corespondenta.
-- SELECT a.ename, d.dname 
-- FROM emp a RIGHT OUTER JOIN dept d ON a.deptno = d.deptno;

-- 5 (TEST): Pentru toti angajatii care au venit in firma inainte de sefii lor, 
-- care au un grad salarial mai mic decat sefii lor sa se afiseze: numele angajatului,
-- data angajarii, gradul salarial, numele sefului, gradul salarial al sefului.
-- SELECT a.ename, a.hiredate, g1.grade, s.ename, g2.grade
-- FROM emp a
-- JOIN emp s ON a.mgr = s.empno
-- JOIN salgrade g1 ON a.sal BETWEEN g1.losal AND g1.hisal
-- JOIN salgrade g2 ON s.sal BETWEEN g2.losal AND g2.hisal
-- WHERE g1.grade < g2.grade 
-- AND a.hiredate < s.hiredate;

----- LAB 6 -----
-- 1. Pentru toti angajatii care au venit in firma inainte de sefii lor,
-- selectati: numele angajatului, numele sefului, salariul angajatului,
-- salariul impartit la 3, valoarea rotunjita la sute din salariul impartit la 3 
-- (valoarea intreaga), valoarea rotunjita la sutimi din salariul impartit la 3.
-- SELECT a.ename, s.ename, a.sal, a.sal / 3, ROUND(a.sal / 3), 
-- ROUND(a.sal / 3, -2), ROUND(a.sal / 3, 2) FROM emp a 
-- JOIN emp s ON a.mgr = s.empno;

-- 2. Pentru angajatii care au salariul mai mare decat 1000 sa se afiseze:
-- numele angajatului, denumirea departamentului sau, 
-- numele angajatului unde paritucla 'AR' e inlocuita cu 'XY',
-- numele angajatului une inlocuim 'A' cu 'X" si 'R' cu nimic.

-- SELECT a.ename, d.dname, REPLACE(a.ename, 'AR', 'XY'), 
-- TRANSLATE(a.ename, 'AR', 'X') 
-- FROM emp a JOIN dept d ON a.deptno = d.deptno
-- WHERE a.sal > 1000;

-- 3 (SUBIECT COLOCVIU): Sa se afiseze pentru fiecare angajat numarul de 
-- aparitii ale ultimelor doua litere din nume in job-ul angajatului.
-- SELECT a.ename, (length(a.job) - length(replace(a.job, substr(a.ename, -2), ''))) / 2 
-- FROM emp a;

-- 4 (TEST): Selectati toti angajatii din departamente diferite cu o valoare citita de la tastatura,
--- angajati ce contin in numele lor litera 'C' si care nu primesc comision.
--- Numele angajatului se va concatena cu denumirea departamentului intr-un sir de forma
--- 'Angajatul ENAME lucreaza in departamentul DNAME' afisandu-se si salariu si comision in
--- valori rotunjite la zeci

-- ACCEPT dep CHAR PROMPT 'Introduceti departamentul: '
-- SELECT 'ANGAJATUL ' || a.ename || ' LUCREAZA IN DEPARTAMENTUL ' || d.dname "PROP", 
-- ROUND(a.sal, -1) "SALARIU ROTUNJIT",
-- ROUND(NVL(a.comm, 0), -1) "COMISION ROTUNJIT"
-- FROM emp a
-- JOIN dept d ON a.deptno = d.deptno
-- WHERE a.ename NOT LIKE '%C%'
-- AND d.dname NOT LIKE '&dep'
-- AND nvl(a.comm, 0) = 0;

-- 5 (TEST):
--- Selectati angajatii care au litera 'E' in nume afisand numele angajatului intre '='
--- afisandu-se vechimea angajatului in ani rotunjita la intregi si salariu
--- formatat la un sir de 6 caractere umplut din stanga cu caractere 'X'. (ex: 'XX5000')
-- SELECT '=' || a.ename || '=' "NUME ANGAJAT", EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM A.HIREDATE) "VECHIME",
-- LPAD(a.sal, 6, 'X') "SALARIU_FORMATAT"
-- FROM emp a
-- WHERE a.ename LIKE '%E';

--- 6. Faceti o lista cu data testarii angajatilor din cadrul departamentului 'SALES'
--- testarea va avea loc la 2 luni dupa data angajarii si se va tine
--- in ultima zi din saptamana aceea
--- Sa se afiseze numele angajatului, departamentul, data angajarii si data testarii
-- SELECT a.ename, d.dname, a.hiredate, NEXT_DAY(ADD_MONTHS(a.hiredate, 2), 'SUNDAY') "DATA_TESTARII"
-- FROM emp a JOIN dept d ON a.deptno = d.deptno
-- AND d.dname = 'SALES';

----- LAB 7 -----
-- 1. Pentru toti angajatii care au venit in firma inainte de sefii lor si nu primesc comision, 
-- sa se afiseze: numele angajatului, numele sefului, data de angajare a sefului si un calificativ
-- al salariului: <= 2500 = slabut, > 2500 = maricel
-- SELECT a.ename, s.ename, s.hiredate, DECODE(SIGN(a.sal - 2500), 1, 'MARICEL', 0, 'SLABUT', -1, 'SLABUT')
-- FROM emp a JOIN emp s ON a.mgr = s.empno
-- WHERE a.hiredate < s.hiredate
-- AND nvl(a.comm, 0) = 0;

-- 2. Pentru toti angajatii care au venit in firma dupa ALLEN sa se acorde o prima altfel: 
-- Cei care castiga comision primesc prima 500, cei care nu castiga comision primesc prima 1000,
-- presedintii si directorii nu primeste nicio prima.

-- !!! X NOT IN (OBIECT1, OBIECT2, OBIECT3)
-- SELECT a.ename, a.hiredate, al.hiredate,
-- CASE
--     WHEN a.job IN ('PRESIDENT', 'MANAGER') THEN 0
--     WHEN nvl(a.comm, 0) = 0 THEN 1000
--     ELSE 500
-- END prima
-- FROM emp a JOIN emp al ON a.hiredate > al.hiredate
-- WHERE al.ename = 'ALLEN'
-- ORDER BY prima desc;

-- 3. Pentru fiecare departament sa se afiseze denumirea departamentului si numarul de angajati 
-- care nu primesc comision.
-- SELECT d.dname, COUNT(*)
-- FROM dept d JOIN emp a ON a.deptno = d.deptno
-- WHERE nvl(a.comm, 0) = 0
-- GROUP by d.dname;

-- 4. Pentru fiecare sef care nu lucreaza in dep. lui BLAKE sa se afiseze numele sefului, numarul
-- de subordonati. Sa se afiseze doar sefii care au mai mult de un subordonat.
-- SELECT s.ename, COUNT(*)
-- FROM emp s JOIN emp a ON a.mgr = s.empno
-- JOIN emp bl ON s.deptno != bl.deptno
-- WHERE bl.ename = 'BLAKE'
-- GROUP BY s.ename
-- HAVING COUNT(*) > 1;

-- 5 (TEST): Pt toti angajatii care au un grad salarial diferit de gradul sefului lui ALLEN, sa se afiseze
-- numele angajatului, gradul salarial, gradul salarial al sefului lui Allen, data angajarii si 
-- un calificativ al vechimii astfel: daca a venit < 1982, 'VECHI', daca a venit dupa 1982 'NOU' 
-- + oricine primeste comsiion va avea afisat 'PREMIAT'. 
-- SELECT a.ename, g1.grade, g2.grade, a.hiredate, 
-- CASE
--     WHEN nvl(a.comm, 0) != 0 THEN'PREMIAT'
--     WHEN EXTRACT(YEAR from a.hiredate) < 1982 THEN 'VECHI'
--     WHEN EXTRACT(YEAR from a.hiredate) >= 1982 THEN 'NOU'
-- END calif
-- FROM emp a, emp al, emp s, salgrade g1, salgrade g2
-- WHERE a.sal BETWEEN g1.losal AND g1.hisal
-- AND al.ename = 'ALLEN'
-- AND al.mgr = s.empno
-- AND s.sal BETWEEN g2.losal AND g2.hisal
-- AND g1.grade != g2.grade;

-- 6 (TEST): Pentru toate departamentele diferite de cele ale lui BLAKE sa se afiseze
-- denumirea departamentului, nr. de angajati care fac parte din el si care nu sunt
-- nici presedinti, nici directori.
-- SELECT d.dname, COUNT(*)
-- FROM dept d JOIN emp a ON d.deptno = a.deptno
-- JOIN emp al ON a.deptno != al.deptno
-- WHERE al.ename = 'BLAKE'
-- AND a.job NOT IN ('PRESIDENT', 'MANAGER')
-- GROUP BY d.dname;

----- LAB 8 -----
-- 1. Sa se selecteze toti angajatii care au un venit mai mare decat media
-- veniturilor din firma si care castiga mai mult decat 'CLARK'.
-- SELECT a.ename, a.sal + nvl(a.comm, 0) venit
-- FROM emp a 
-- WHERE a.sal + nvl(a.comm, 0) > (SELECT avg(sal + nvl(comm, 0)) FROM emp)
-- AND a.sal + nvl(a.comm, 0) > (SELECT sal + nvl(comm, 0) FROM emp WHERE ename = 'CLARK');

-- 2. Sa se selecteze toti angajatii care fac parte din acelasi grad salarial
-- cu 'CLARK' si care au venit in firma dupa acesta.
-- SELECT a.ename, a.sal, a.hiredate, ga.grade
-- FROM emp a JOIN salgrade ga ON a.sal BETWEEN ga.losal AND ga.hisal
-- WHERE ga.grade = (SELECT gc.grade FROM emp cl JOIN salgrade gc ON cl.sal BETWEEN gc.losal AND gc.hisal WHERE cl.ename = 'CLARK')
-- AND a.hiredate < (SELECT hiredate FROM emp WHERE ename = 'CLARK');

-- 3. Pentru toti angajatii care au un venit peste media veniturilor din departamentul
-- lor si care au venit in firma dupa seful lor, sa se selecteze:
-- numele angajatului, venitul si data angajarii.

-- !!OBS nu ar fi mers (AVG (SELECT ...))
-- SELECT a.ename, a.sal + nvl(a.comm, 0) venit, a.hiredate
-- FROM emp a JOIN emp s ON a.mgr = s.empno
-- WHERE a.sal + nvl(a.comm, 0) > (SELECT AVG(a2.sal + nvl(a2.comm, 0)) FROM emp a2 WHERE a2.deptno = a.deptno)
-- AND a.hiredate > s.hiredate;


-- 4. Sa se selecteze al 5-lea cel mai mare salariu.
-- SELECT a.ename, a.sal 
-- FROM emp a 
-- WHERE 4 = (SELECT COUNT(DISTINCT b.sal) FROM emp b WHERE b.sal > a.sal);


-- 5. Sa se selecteze toti angajatii care au un salariu mai mic decat media salariilor angajatilor 
-- care au acelasi grad salarial cu angajatul respectiv si care au venit in firma inainte de sefii lor.
-- SELECT a.ename 
-- FROM emp a JOIN salgrade ga ON a.sal BETWEEN ga.losal AND ga.hisal
-- JOIN emp s ON s.empno = a.mgr
-- WHERE a.sal < (SELECT avg(b.sal) FROM emp b
--             JOIN salgrade gb ON b.sal BETWEEN gb.losal AND gb.hisal WHERE ga.grade = gb.grade)
-- AND a.hiredate < s.hiredate;

-- 6. Sa se selecteze toti angajatii care au venit in firma dupa CLARK
-- si au un grad salarial diferit de CLARK, afisandu-se numele angajatului, gradul sau 
-- salarial, data angajarii sale, gradul salarial al lui CLARK, jobul lui CLARK
-- si data angajarii lui CLARK
-- SELECT a.ename, g.grade, a.hiredate, cl.grade, cl.hiredate, cl.job
-- FROM emp a JOIN salgrade g ON (a.sal >= g.losal AND a.sal <= g.hisal),
--     (SELECT c.hiredate, c.job, gc.grade FROM emp c JOIN salgrade gc ON c.sal BETWEEN gc.losal AND gc.hisal
--     WHERE c.ename = 'CLARK') CL 
-- WHERE g.grade != cl.grade AND a.hiredate > cl.hiredate
-- ORDER BY a.ename;

-- SELECT a.ename, g.grade, a.hiredate, gcl.grade, cl.hiredate, cl.job
-- FROM emp a, emp cl, salgrade g, salgrade gcl
-- WHERE cl.ename = 'CLARK' 
-- AND a.sal BETWEEN g.losal AND g.hisal
-- AND cl.sal BETWEEN gcl.losal AND gcl.hisal
-- AND g.grade != gcl.grade
-- AND a.hiredate > cl.hiredate
-- ORDER BY a.ename;

-- 7 (TEST/SUBIECT COLOCVIU): Pt fiecare angajat care nu face parte din departamentul angajatului cu cel mai mic
-- salariu si care nu a venit in firma in luna februarie (indif de an), selectati
-- numele, denumirea departamentului sau, numele sefului sau, luna angajarii,
-- dif dintre venitul sefului si venitul sau si gradul sau salarial.
-- (ar trb obtinute 6 inregistrari)
-- SELECT a.ename, d.dname, s.ename, EXTRACT(MONTH from a.hiredate), s.sal + nvl(s.comm, 0) - a.sal - nvl(a.comm, 0), g.grade
-- FROM emp a 
-- JOIN emp s ON s.empno = a.mgr
-- JOIN dept d On d.deptno = a.deptno
-- JOIN salgrade g ON a.sal BETWEEN g.losal AND g.hisal
-- WHERE a.deptno != (SELECT deptno FROM emp
--                     WHERE sal = (SELECT MIN(sal) FROM emp))
-- AND EXTRACT(MONTH from a.hiredate) NOT LIKE '2';

-- 8 (TEST): Sa se selecteze toti angajatii departamrntelor research sau sales care au venit
-- in firma cu cel putin 3 luni dupa seful lor direct, afisand pt fiecare angajat
-- numele angajatului, numele sefului, data de angajare pt angajat, data de angajare
-- pentru sef, valoarea intreaga a numarului de luni dintre cele doua date si
-- traducerea in limba romana a denumirii departamentului
-- SELECT a.ename, s.ename, a.hiredate, s.hiredate, TRUNC(MONTHS_BETWEEN(s.hiredate, a.hiredate)), 
-- CASE
--     WHEN d.dname = 'RESEARCH' THEN 'CERCETARE'
--     WHEN d.dname = 'SALES' THEN 'VANZARI'
-- END calif
-- FROM emp a JOIN emp s ON s.empno = a.mgr
-- JOIN dept d ON a.deptno = d.deptno
-- WHERE (d.dname = 'RESEARCH' OR d.dname = 'SALES')
-- AND MONTHS_BETWEEN(s.hiredate, a.hiredate) >= 3;

----- LAB 9 -----
-- 1. Sa se selecteze toti angajatii care au venit dupa 'CLARK' si castiga mai mult decat acesta.
-- Afisati nume angajat, venit 'CLARK', venitul mediu din departamentul angajatului.
-- SELECT a.ename, cl.venit venit_clark, 
-- (SELECT AVG(a1.sal + nvl(a1.comm, 0)) FROM emp a1 WHERE a1.deptno = a.deptno) venit_mediu
-- FROM emp a, (SELECT c.hiredate, c.sal + nvl(c.comm, 0) venit FROM emp c WHERE c.ename = 'CLARK') cl
-- WHERE a.hiredate > cl.hiredate AND a.sal + nvl(a.comm, 0) > cl.venit;

-- 2. Sa se selecteze toti angajatii care au acelasi grad salarial ca 
-- seful lui 'CLARK' afisand numele angajatului, gradul sau salarial si suma totala
-- a salariilor din departmanetul 'RESEARCH'
-- SELECT a.ename, g.grade, (SELECT SUM(b.sal) FROM emp b JOIN dept d ON b.deptno = d.deptno WHERE d.dname = 'RESEARCH') suma
-- FROM emp a, salgrade g, salgrade gscl, emp cl, emp scl
-- WHERE a.sal BETWEEN g.losal AND g.hisal
-- AND cl.ename = 'CLARK'
-- AND scl.empno = cl.mgr
-- AND scl.sal BETWEEN gscl.losal AND gscl.hisal
-- AND g.grade = gscl.grade;

-- SELECT a.ename, g.grade, (SELECT sum(b.sal)
-- FROM emp b
-- JOIN dept c on b.deptno = c.deptno WHERE c.dname = 'RESEARCH') suma
-- FROM emp a 
-- JOIN salgrade g ON (a.sal + NVL(a.comm, 0)) BETWEEN g.losal AND g.hisal
-- WHERE g.grade = (SELECT gr.grade FROM emp boss
--                 JOIN salgrade gr ON (boss.sal + nvl(boss.comm, 0)) BETWEEN gr.losal and gr.hisal
--                 JOIN emp e ON e.mgr = boss.empno AND e.ename = 'CLARK');

-- 3. Sa se selecteze departamentul care are cei mai multi angajati.
-- SELECT d.dname, COUNT(*)
-- FROM dept d JOIN emp a ON a.deptno = d.deptno
-- GROUP BY d.dname
-- HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM emp GROUP BY deptno);

-- 4. Sa se selecteze seful cu cei mai multi subordonati, afisand numele sefului si nr de subordonati.
-- SELECT s.ename, COUNT(*)
-- FROM emp s JOIN emp a ON a.mgr = s.empno
-- GROUP BY s.ename
-- HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM emp GROUP BY mgr);

-- 5. Sa se selecteze departamentul in care s-au angajat cei mai multi angajati
-- in acelasi an, afisand den departament, anul respectiv si nr de angajati
-- care au venit in acel departament in acel an.
-- SELECT d.dname, EXTRACT(YEAR from a.hiredate) an, COUNT(*)
-- FROM dept d JOIN emp a ON a.deptno = d.deptno
-- GROUP BY d.dname, EXTRACT(YEAR from a.hiredate)
-- HAVING COUNT(*) = (SELECT max(count(*)) 
--                     FROM emp
--                     GROUP by deptno, EXTRACT(year FROM hiredate));

-- 6. Sa se selecteze pentru fiecare angajat numele si denumirea departamentului
-- din care face el parte, dar angajatii trb sortati in ordinea descrescatoare
-- a dimensiunii departamentelor lor.
-- SELECT a.ename, d.dname
-- FROM emp a JOIN dept d ON a.deptno = d.deptno
-- ORDER BY (SELECT COUNT(*) FROM emp b WHERE b.deptno = a.deptno) DESC;

-- 7. Sa se selecteze departamentele in care nu se afla niciun angajat in gradele
-- salariale 4 si 5.
-- SELECT d.dname
-- FROM dept d
-- LEFT JOIN emp a ON a.deptno = d.deptno
-- LEFT JOIN salgrade gr ON a.sal BETWEEN gr.losal AND gr.hisal
-- GROUP BY d.dname
-- HAVING COUNT(CASE WHEN gr.grade IN (4, 5) THEN 1 ELSE NULL END) = 0;


-- SELECT d.dname 
-- FROM dept d 
-- WHERE NOT EXISTS(SELECT b.ename 
--                 FROM emp b JOIN salgrade g ON b.sal BETWEEN g.losal AND g.hisal
--                 WHERE b.deptno = d.deptno AND g.grade IN (4,5));

-- 8. Sa se selecteze toti angajatii din departamentul cu cei mai putini angajati
-- care au gradul salarial = cel al sefului lui ALLEN. Se va afisa numele angajatului,
-- denumirea departamentului, gradul salarial si anul in care s-a angajat.
-- SELECT a.ename, d.dname, g.grade, EXTRACT(YEAR from a.hiredate) an
-- FROM emp a, dept d, salgrade g, (SELECT gs1.grade FROM salgrade gs1
--                                                         JOIN emp s1 ON s1.sal BETWEEN gs1.losal AND gs1.hisal
--                                                         JOIN emp al1 ON al1.mgr = s1.empno
--                                                         WHERE al1.ename = 'ALLEN')  grad_sef
-- WHERE a.deptno = d.deptno
-- AND a.sal BETWEEN g.losal AND g.hisal
-- AND d.deptno IN (SELECT deptno FROM emp
--                     JOIN salgrade ON sal BETWEEN losal AND hisal
--                     WHERE grade = grad_sef.grade
--                     GROUP BY deptno
--                     HAVING COUNT(*) = (SELECT MIN(COUNT(*)) FROM emp 
--                                         JOIN salgrade ON sal between losal and hisal 
--                                         WHERE grade = grad_sef.grade
--                                         GROUP BY deptno)
--                 );

---- LAB 10 ----
-- 1. Sa se creeze o tabela intitulata THE_BEST in care sa selectati toti angajatii care au 
-- cel mai mare venit din departamentul lor.
-- Tabela va avea structura Nume Angajat, Venit si DenDepartament
-- CREATE TABLE THE_BEST AS
--     SELECT a.ename NUME_ANGAJAT, a.sal + NVL(a.comm, 0) VENIT, d.dname DEN_DEPARTAMENT
--     FROM emp a JOIN dept d ON a.deptno = d.deptno
--     WHERE a.sal = (SELECT MAX(a1.sal + nvl(a1.comm, 0)) FROM emp a1 WHERE a1.deptno = d.deptno);
--     SELECT * from THE_BEST;
-- DROP TABLE THE_BEST;
    
-- 2. Sa se creeze o tabela denumita ANG_BLAKE care sa contina toti angajatii
-- din departamentul sefului cu cei mai multi subordonati. structura tabelei
-- este urmatoarea: nume angajat, den departament, an angajare, venit
-- si anii vechime. vechimea se va calcula ca si numar natural.
-- CREATE TABLE ANG_BLAKE AS
-- SELECT a.ename, d.dname, EXTRACT(year from a.hiredate) an, a.sal + nvl(a.comm, 0) venit,
-- EXTRACT(year from sysdate) - EXTRACT(year from a.hiredate) vechime
-- FROM emp a JOIN dept d On a.deptno = d.deptno
-- AND a.mgr = (SELECT s.empno FROM emp s
--             JOIN emp a2 ON s.empno = a2.mgr
--             GROUP BY s.empno
--             HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM emp GROUP by mgr));
-- SELECT * FROM ANG_BLAKE;
-- DROP TABLE ANG_BLAKE;

-- 3. (SUBIECT COLOCVIU)
-- Sa se creeze un view denumit angajati_grad_allen care sa contina primii 2 angajati ca ordin de marime al veniturilor
-- care au ac grad salarial ca ALLEN. view-ul va avea urm structura: nume angajat, grad salarial, venit.

-- CREATE OR REPLACE VIEW ANGAJATI_GRAD_ALLEN AS
-- SELECT a.ename, g.grade, a.sal + nvl(a.comm, 0) venit
-- FROM emp a JOIN salgrade g ON a.sal BETWEEN g.losal AND g.hisal
-- WHERE g.grade = (SELECT gr.grade FROM emp al JOIN salgrade gr ON al.sal BETWEEN gr.losal AND gr.hisal WHERE al.ename = 'ALLEN')
-- AND 1 >= (SELECT COUNT(*) FROM emp c JOIN salgrade i ON c.sal BETWEEN i.losal AND i.hisal WHERE i.grade = g.grade AND c.sal + nvl(c.comm, 0) > a.sal + nvl(a.comm, 0));
-- SELECT * FROM ANGAJATI_GRAD_ALLEN;
-- DROP VIEW ANGAJATI_GRAD_ALLEN;

----- EXERCITII DATE LA COLOCVIU -----
-- 1. Selectati toti angajatii care nu au primit comision si care lucreaza in departamentul
-- care are cei mai multi angajati incadrati in gradul 1 din grila de salariu. Se va
-- afisa den. departament, nume angajat, salariu, comision, ordonati dupa salariu crescator.
-- Antetul listei este den_dep, nume_ang, salariu, comision.
-- SELECT d.dname den_dep, a.ename nume_ang, a.sal salariu, nvl(a.comm, 0) comision
-- FROM dept d
-- JOIN emp a ON a.deptno = d.deptno
-- WHERE nvl(a.comm, 0) = 0
-- AND d.deptno = (SELECT deptno FROM emp e JOIN salgrade ge ON e.sal BETWEEN ge.losal AND ge.hisal
--                     WHERE ge.grade = 1
--                     GROUP BY deptno
--                     HAVING COUNT(*) = (SELECT MAX(COUNT(*)) from emp c 
--                                         JOIN salgrade gc ON c.sal BETWEEN gc.losal AND gc.hisal
--                                         WHERE gc.grade = 1
--                                         GROUP by deptno))
-- ORDER BY a.sal ASC;

-- 2. Sa se selecteze angajatii care respecta urmatoarele conditii:
-- a) au venit in firma in anul in care s-au facut cele mai multe angajari
-- b) fac parte din departamentul cu cei mai multi angajati din firma
--  coloane : nume angajat, denumire departament, salariu, data angajarii
-- SELECT a.ename nume_angajat, d.dname den_dept, a.sal sal, a.hiredate data_ang
-- FROM emp a JOIN dept d ON d.deptno = a.deptno
-- WHERE EXTRACT(YEAR from a.hiredate) = (SELECT EXTRACT(YEAR from hiredate) FROM emp 
--                     GROUP BY EXTRACT(YEAR from hiredate)
--                     HAVING COUNT(*) = (SELECT MAX(COUNT(*)) from emp c
--                                         GROUP BY EXTRACT(YEAR from c.hiredate)))
-- AND a.deptno = (SELECT deptno FROM emp 
--                     GROUP BY deptno
--                     HAVING COUNT(*) = (SELECT MAX(COUNT(*)) from emp GROUP by deptno));

-- SELECT d.dname, a.ename, a.hiredate FROM emp a 
-- JOIN dept d ON a.deptno = d.deptno
-- WHERE a.deptno = (SELECT deptno FROM emp 
--                     WHERE EXTRACT(MONTH from hiredate) NOT IN (12, 1, 2)
--                     GROUP BY deptno
--                     HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM emp 
--                     WHERE EXTRACT(MONTH from hiredate) NOT IN (12, 1, 2) GROUP BY deptno))
-- ORDER BY a.hiredate ASC; 

-- 4. (SUB 8) Sa se creeze un VIEW denumit ANGAJATI_SPEC care sa contina toti angajatii
-- care 1) au gradul salarial al angajatului cel mai bine platit din RESEARCH
-- (venitul maxim si vezi in ce grad se incadreaza)
-- 2) nu au JOB-ul sefului lui SCOTT.
-- View-ul trebuie sa aiba structura: Nume_angajat, Grad_salarial, Job, Den_departament.
-- Veti include si operatiile de selectare si stergere a view-ului.
-- CREATE OR REPLACE VIEW ANGAJATI_SPEC AS
-- SELECT a.ename Nume_angajat, g.grade Grad_Salarial, a.job Job, d.dname Den_departament
-- FROM emp a JOIN salgrade g ON a.sal BETWEEN g.losal AND g.hisal
-- JOIN dept d ON a.deptno = d.deptno
-- AND g.grade IN (SELECT gb.grade FROM salgrade gb
--                 JOIN emp b ON b.sal BETWEEN gb.losal AND gb.hisal
--                 JOIN dept db ON b.deptno = db.deptno
--                 WHERE b.sal + nvl(b.comm, 0) = (SELECT MAX(sal + nvl(comm, 0)) from emp c
--                                                 JOIN dept dc ON c.deptno = dc.deptno 
--                                                 WHERE dc.dname = 'RESEARCH')
--                 AND db.dname = 'RESEARCH')
-- AND a.job != (SELECT s.job FROM emp s
--                 JOIN emp sc ON sc.mgr = s.empno
--                 WHERE sc.ename = 'SCOTT');
-- SELECT * FROM ANGAJATI_SPEC;
-- DROP VIEW ANGAJATI_SPEC;

-- 5. (SUB 6) Sa se selecteze toti angajatii care au venit in firma in acelasi an cu 
-- angajatul (subaltern al sefului lui ALLEN) care are cel mai mare grad salarial
-- din randul subalternilor sefilor lui ALLEN.
-- Afisati Nume_Angajat, Den_Departament, An_Angajare

-- SELECT a.ename Nume_Angajat, d.dname Den_Departament, EXTRACT(YEAR from a.hiredate) An_Angajare
-- FROM emp a 
-- JOIN dept d ON d.deptno = a.deptno
-- WHERE EXTRACT (YEAR from a.hiredate) IN (SELECT EXTRACT (YEAR from b.hiredate) from emp b
--                                         JOIN salgrade gb ON b.sal BETWEEN gb.losal AND gb.hisal
--                                         WHERE gb.grade IN (SELECT MAX(sub_gr.grade) FROM salgrade sub_gr
--                                                         JOIN emp sub ON sub.sal BETWEEN sub_gr.losal AND sub_gr.hisal
--                                                         WHERE sub.mgr = (SELECT sefi.empno FROM emp sefi
--                                                                             JOIN emp al ON al.mgr = sefi.empno
--                                                                             WHERE al.ename = 'ALLEN'))
--                                         );

-- 6. CERINTA COLOCVU (Rezolvare de 8-9):
-- Sa se selecteze toti angajatii care au venit in firma in acelasi an cu
-- angajatul/angajatii care are/au cel mai mare venit in randul angajatilor care au 
-- jobul cel mai raspandit din firma.
-- Sa va afisa: Nume_angajat, Den_departament, Job, Venit, An_Angajare
-- SELECT a.ename Nume_angajat, d.dname Den_departament, a.job Job, 
-- a.sal + nvl(a.comm, 0) Venit, EXTRACT(YEAR from a.hiredate) An_Angajare
-- FROM emp a, dept d, (SELECT e.job FROM emp e
--                     GROUP BY e.job
--                     HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM emp GROUP BY job)) job_nr_max
-- WHERE a.deptno = d.deptno
-- AND EXTRACT(YEAR from a.hiredate) = 
--     (SELECT EXTRACT(YEAR FROM b.hiredate) FROM emp b
--     WHERE b.sal + nvl(b.comm, 0) = (SELECT MAX(c.sal + nvl(c.comm, 0)) FROM emp c
--                                     WHERE c.job IN job_nr_max.job)
--     AND b.job IN job_nr_max.job);

---- LAB 9 OCW ----
-- 1. Să se determine care departament are cei mai mulți angajați pe aceeași funcție.
-- SELECT d.dname, COUNT(*) FROM dept d
-- JOIN emp a ON a.deptno = d.deptno
-- GROUP BY d.dname, a.job
-- HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM emp GROUP BY deptno, job);

-- 2. Să se determine angajații care au comisionul maxim 
-- pentru un departament introdus de la tastatură.
-- ACCEPT dept CHAR PROMPT 'Introduceti departamentul: '
-- SELECT a.ename
-- FROM emp a JOIN dept d ON a.deptno = d.deptno
-- WHERE d.dname = '&dept'
-- AND nvl(a.comm, 0) = (SELECT MAX(nvl(b.comm, 0)) comision 
--                     FROM emp b JOIN dept d2 ON b.deptno = d.deptno);

-- 3. Să se afle ce angajat are salariul maxim în firmă
-- SELECT a.ename 
-- FROM emp a 
-- WHERE a.sal = (SELECT MAX(sal) FROM emp);

-- 4. Să se afișeze șefii angajaților din departamentul 20.
-- SELECT s.ename 
-- FROM emp a JOIN emp s ON a.mgr = s.empno
-- JOIN dept d ON a.deptno = d.deptno
-- WHERE d.deptno = 20;

-- 5.Să se facă o listă cu angajații din departamentele 10 și 20,
-- ordonați descrescător după numărul de angajați din fiecare departament.
-- SELECT a.ename
-- FROM emp a 
-- WHERE a.deptno IN (10, 20)
-- ORDER BY (SELECT COUNT(*) FROM emp b
--             WHERE a.deptno = b.deptno) ASC;
-- SELECT COUNT(*) FROM emp b WHERE a.deptno = b.deptno  = selecteaza nr de angajati din acelasi
-- departament cu a.

-- 6. Să se afle care sunt angajații care au salariul mai mare decât 
-- salariul cel mai mic pentru funcția de SALESMAN.
-- SELECT a.ename 
-- FROM emp a 
-- WHERE a.sal > (SELECT MIN(b.sal) FROM emp b WHERE b.job = 'SALESMAN')
-- ORDER BY a.ename;

-- Asta verifica daca salariul este mai mare decat cel putin una dintre valorile 
-- cu functia 'SALESMAN' => daca e mai mare decat cel putin una, e mai mare si decat
-- cea mai mica.
-- SELECT a.ename 
-- FROM emp a 
-- WHERE a.sal > SOME(SELECT DISTINCT b.sal FROM emp b WHERE b.job = 'SALESMAN')
-- ORDER BY a.ename;

-- 8. Să se determine departamentele care au cel puțin un angajat.
-- SELECT d.dname 
-- FROM dept d 
-- WHERE 1 <= (SELECT COUNT(*) FROM emp a WHERE a.deptno = d.deptno);

-- SELECT d.dname 
-- FROM dept d 
-- WHERE EXISTS(SELECT a.ename FROM emp a WHERE a.deptno = d.deptno);
