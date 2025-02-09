﻿﻿alter session set "_ORACLE_SCRIPT"=true;
CREATE USER  QUANLYRAPPHIM IDENTIFIED BY Admin2004;
GRANT CONNECT, RESOURCE, DBA TO QUANLYRAPPHIM;

-- Sử dụng Schema
ALTER SESSION SET CURRENT_SCHEMA = QUANLYRAPPHIM;


------------------------- DE 4 ----------------------

-- Tạo bảng THANHVIEN
CREATE TABLE THANHVIEN(
  MATV NUMBER PRIMARY KEY,
  HOTEN VARCHAR2(50),
  NGSINH DATE,
  GIOITINH VARCHAR2(3),
  DIENTHOAI VARCHAR2(11),
  QUAN VARCHAR2(50),
  LOAITV VARCHAR(15)
);

-- Tạo bảng PHIM
CREATE TABLE PHIM(
  MAP NUMBER PRIMARY KEY,
  TENP VARCHAR2(100),
  NAMSX NUMBER,
  THELOAI VARCHAR(20),
  THOILUONG NUMBER,
  TINHTRANG NUMBER,
  SOLUOTXEM NUMBER
);

-- Tạo bảng RAPPHIM
CREATE TABLE RAPPHIM(
  MARP NUMBER PRIMARY KEY,
  TENRP VARCHAR2(100),
  SLVE NUMBER,
  DIACHI VARCHAR2(200),
  THANHPHO VARCHAR2(100)
);

-- Tạo bảng LICHCHIEU
CREATE TABLE LICHCHIEU(
  MALC NUMBER PRIMARY KEY,
  MARP NUMBER,
  MAP  NUMBER,
  PHONGCHIEU VARCHAR2(50),
  SUATCHIEU VARCHAR2(5),
  SUCCHUA NUMBER,
  TUNGAY DATE,
  DENNGAY DATE
);

-- Tạo bảng VE
CREATE TABLE VE(
  MAVE NUMBER PRIMARY KEY,
  MATV NUMBER,
  MALC NUMBER,
  NGAYMUA DATE,
  LOAIVE VARCHAR2(2),
  GIATIEN NUMBER
);

-- Thêm dữ liệu
-- Dữ liệu cho bảng THANHVIEN
INSERT INTO THANHVIEN VALUES
(1, 'Nguyen Van A', TO_DATE('01/01/1990', 'DD/MM/YYYY'), 'Nam', '0123456789', 'Quan 1', 'Star');
INSERT INTO THANHVIEN VALUES
(2, 'Tran Thi B', TO_DATE('02/02/1991', 'DD/MM/YYYY'), 'Nu', '0987654321', 'Quan 2', 'G-Star');
INSERT INTO THANHVIEN VALUES
(3, 'Le Van C', TO_DATE('03/03/1992', 'DD/MM/YYYY'), 'Nam', '0123456789', 'Quan 3', 'X-Star');
-- Thêm thêm dữ liệu cho THANHVIEN

-- Dữ liệu cho bảng PHIM
INSERT INTO PHIM VALUES
(1, 'Phim 1', 2020, 'Hanh dong', 120, 1, 100);
INSERT INTO PHIM VALUES
(2, 'Phim 2', 2019, 'Hai huoc', 90, 1, 80);
INSERT INTO PHIM VALUES
(3, 'Phim 3', 2021, 'Kinh di', 110, 0, 120);
-- Thêm thêm dữ liệu cho PHIM

-- Dữ liệu cho bảng RAPPHIM
INSERT INTO RAPPHIM VALUES
(1, 'Rap 1', 200, 'Dia chi 1', 'Thanh pho A');
INSERT INTO RAPPHIM VALUES
(2, 'Rap 2', 150, 'Dia chi 2', 'Thanh pho B');
INSERT INTO RAPPHIM VALUES
(3, 'Rap 3', 180, 'Dia chi 3', 'Thanh pho C');
-- Thêm thêm dữ liệu cho RAPPHIM

-- Dữ liệu cho bảng LICHCHIEU
INSERT INTO LICHCHIEU VALUES
(1, 1, 1, 'Phong 1', '09:00', 150, TO_DATE('01/01/2024', 'DD/MM/YYYY'), TO_DATE('01/01/2024', 'DD/MM/YYYY'));
INSERT INTO LICHCHIEU VALUES
(2, 2, 2, 'Phong 2', '14:30', 120, TO_DATE('02/01/2024', 'DD/MM/YYYY'), TO_DATE('02/01/2024', 'DD/MM/YYYY'));
INSERT INTO LICHCHIEU VALUES
(3, 3, 3, 'Phong 3', '18:45', 180, TO_DATE('03/01/2024', 'DD/MM/YYYY'), TO_DATE('03/01/2024', 'DD/MM/YYYY'));
-- Thêm thêm dữ liệu cho LICHCHIEU

-- Dữ liệu cho bảng VE
INSERT INTO VE VALUES
(1, 1, 1, TO_DATE('01/01/2024', 'DD/MM/YYYY'), '2D', 80000);
INSERT INTO VE VALUES
(2, 2, 2, TO_DATE('02/01/2024', 'DD/MM/YYYY'), '3D', 120000);
INSERT INTO VE VALUES
(3, 3, 3, TO_DATE('03/01/2024', 'DD/MM/YYYY'), '2D', 100000);
INSERT INTO VE VALUES
(4, 1, 2, TO_DATE('05/02/2024', 'DD/MM/YYYY'), '2D', 100000);

--- tạo stored procedure
CREATE OR REPLACE PROCEDURE KQ1(
  N_THANG IN NUMBER,
  N_NAM IN NUMBER
) AS
BEGIN
  SELECT TV.MATV, TV.HOTEN, COUNT(*) 
  FROM THANHVIEN AS TV, VE
  WHERE TV.MATV = VE.MATV AND EXTRACT(MONTH FROM {VE.NGAY}) = N_THANG AND EXTRACT(YEAR FROM {VE.NGAY}) = N_NAM
  GROUP BY TV.MATV, TV.HOTEN
END;

CREATE OR REPLACE PROCEDURE KQ2(
  N_MONTH IN NUMBER,
  N_YEAR  IN NUMBER
) 
IS
  V_MATV VE.MATV%TYPE;
  V_HOTEN THANHVIEN.HOTEN%TYPE;
  V_STT NUMBER := 0;

  CURSOR CUR IS
    SELECT DISTINCT(VE.MATV ) FROM VE
    WHERE EXTRACT(YEAR FROM VE.NGAYMUA) = N_YEAR AND EXTRACT(MONTH FROM VE.NGAYMUA) = N_MONTH;
BEGIN
  DBMS_OUTPUT.PUT_LINE('DANH SÁCH TẤT CẢ THÀNH VIÊN XEM PHIM THANG '||N_MONTH || ' NAM ' ||N_YEAR);
  OPEN CUR;
  FETCH CUR INTO V_MATV;
  WHILE CUR%FOUND
  LOOP
    V_STT := V_STT + 1;

    SELECT HOTEN INTO V_HOTEN FROM THANHVIEN
    WHERE MATV = V_MATV;

    DBMS_OUTPUT.PUT_LINE('STT:' || V_STT ||' Mã thành viên: '||V_MATV || ', Họ tên: ' || V_HOTEN);

    FETCH CUR INTO V_MATV;
  END LOOP;
  CLOSE CUR;

DBMS_OUTPUT.PUT_LINE('TONG SO LUONG THANH VIEN MUA VE '||V_STT);
END;
/
DECLARE
  N_MONTH NUMBER := 1;
  N_YEAR NUMBER := 2024;
BEGIN
  KQ2(N_MONTH, N_YEAR);
END;
/

-------------------------
CREATE OR REPLACE PROCEDURE QASSS(
  N_MONTH IN NUMBER,
  N_YEAR  IN NUMBER
)
IS
  V_MATV VE.MATV%TYPE;
  V_HOTEN THANHVIEN.HOTEN%TYPE;
  V_STT NUMBER := 0;

  CURSOR SR IS
    SELECT DISTINCT(MATV) FROM VE
    WHERE EXTRACT(YEAR FROM NGAYMUA) = N_YEAR AND EXTRACT(MONTH FROM NGAYMUA) = N_MONTH;

BEGIN
  DBMS_OUTPUT.PUT_LINE('DANH SACH CAC THANH VIEN THAM GIA MUA VE TRONG THANG '||N_MONTH||' NAM '||N_YEAR);

  OPEN SR;
  FETCH SR INTO V_MATV;

  WHILE(SR%FOUND)
  LOOP
      V_STT := V_STT + 1;

      SELECT HOTEN INTO V_HOTEN FROM THANHVIEN
      WHERE MATV = V_MATV;
      
      DBMS_OUTPUT.PUT_LINE('STT: '||V_STT||' MATV: '||V_MATV||' HOTEN: '||V_HOTEN);
  END LOOP;
  CLOSE SR;
  
  DBMS_OUTPUT.PUT_LINE('TONG SO THANH VIEN THAM GIA MUA VE: '||V_STT);
END;
/
DECLARE 
  N_MONTH NUMBER := 1;
  N_YEAR  NUMBER := 2024;
BEGIN
  QASSS(N_MONTH, N_YEAR);
END;
/

-----------------------------------Đề 1---------------

﻿alter session set "_ORACLE_SCRIPT"=true;
CREATE USER  QUANLYVPATGT IDENTIFIED BY admin123;
GRANT CONNECT, RESOURCE, DBA TO QUANLYVPATGT;

-- Sử dụng Schema
ALTER SESSION SET CURRENT_SCHEMA = QUANLYVPATGT;

CREATE TABLE LOI(
  MALOI VARCHAR(5) PRIMARY KEY,
  NOIDUNG VARCHAR(50),
  MUCTIENPHAT NUMBER
);  

CREATE TABLE DOITUONG(
  MADT VARCHAR(5) PRIMARY KEY,
  HOTEN VARCHAR2(50),
  CMND VARCHAR(5) UNIQUE,
  DIACHI VARCHAR(50),
  BIENKS VARCHAR(10),
  TONGTIENPHAT NUMBER
);

CREATE TABLE VIPHAM(
  MALOI VARCHAR2(5),
  MADT VARCHAR(5),
  THOIDIEMVP DATE,
  NGAYHEN DATE,

  CONSTRAINT PK_VIPHAM PRIMARY KEY (MALOI, MADT)
);

INSERT INTO LOI VALUES
('L001', 'QUA TOC DO', 200000);
INSERT INTO LOI VALUES
('L002', 'VUOT DEN DO', 250000);
INSERT INTO LOI VALUES
('L003', 'KO BAT DEN PHA', 150000);
INSERT INTO LOI VALUES
('L004', 'KHONG GUONG CHIEU HAU', 100000);

INSERT INTO DOITUONG VALUES
('DT001', 'FAKER', '2023', 'AAA - 22', 'ORI20', 100000);
INSERT INTO DOITUONG VALUES
('DT002', 'LEVI', '2022', 'BBB - 23', 'WUKHONG10', 200000);
INSERT INTO DOITUONG VALUES
('DT003', 'ZEUS', '2024', 'CCC - 33', 'JAYCE26', 300000);
INSERT INTO DOITUONG VALUES
('DT004', 'KERIA', '2021', 'DD - 44', 'BARD25', 250000);

INSERT INTO VIPHAM VALUES
('L001', 'DT002', TO_DATE('01/01/2024', 'DD/MM/YYYY'), TO_DATE('10/01/2024', 'DD/MM/YYYY'));
INSERT INTO VIPHAM VALUES
('L001', 'DT001', TO_DATE('01/12/2023', 'DD/MM/YYYY'), TO_DATE('30/12/2023', 'DD/MM/YYYY'));
INSERT INTO VIPHAM VALUES
('L002', 'DT003', TO_DATE('10/01/2024', 'DD/MM/YYYY'), TO_DATE('15/01/2024', 'DD/MM/YYYY'));
INSERT INTO VIPHAM VALUES
('L003', 'DT004', TO_DATE('30/12/2023', 'DD/MM/YYYY'), TO_DATE('05/01/2024', 'DD/MM/YYYY'));

--A TRIGGER
--             THEM    XOA    SUA
--  DOITUONG    +(1)    -      +(TONGTIENPHAT)
--  LOI         -       -      +(MUCTIENPHAT)
--  VIPHAM      +       +      -(*)
-- (1) TONGTIENPHAT := 0;

--DOITUONG
CREATE OR REPLACE TRIGGER TRG_DOITUONG_INSERT_CAUA
BEFORE INSERT ON DOITUONG
FOR EACH ROW
DECLARE
  V_MADT DOITUONG.MADT%TYPE := :NEW.MADT;
BEGIN
  DBMS_OUTPUT.PUT_LINE('THEM DOI TUONG THANH CONG');
  UPDATE DOITUONG 
  SET TONGTIENPHAT = 0;
  WHERE MADT = V_MADT;
END;
--
CREATE OR REPLACE TRIGGER TRG_DOITUONG_UPDATE_CAUA
BEFORE UPDATE ON DOITUONG
FOR EACH ROW
DECLARE
  N_OLDTTP DOITUONG.TONGTIENPHAT%TYPE := :OLD.TONGTIENPHAT;
  N_NEWTTP DOITUONG.TONGTIENPHAT%TYPE := :NEW.TONGTIENPHAT;
BEGIN
  IF N_OLDTTP <> N_NEWTTP 
  THEN
    RAISE_APPLICATION_ERROR(-20001, 'ERROR: TONG TIEN PHAT KO HOP LE');  
  ELSE
    DBMS_OUTPUT.PUT_LINE('CAP NHAP THANH CONG');
  END IF;
END;
-- LOI
CREATE OR REPLACE TRIGGER TRG_LOI_UPDATE_CAUA
BEFORE UPDATE ON LOI
FOR EACH ROW
DECLARE
  N_OLD_MTP LOI.MUCTIENPHAT%TYPE := :OLD.MUCTIENPHAT;
  N_NEW_MTP LOI.MUCTIENPHAT%TYPE := :NEW.MUCTIENPHAT;
  V_MADT DOITUONG.MADT%TYPE;

  CURSOR CUR IS
    SELECT MADT FROM VIPHAM
    WHERE MALOI = :NEW.MALOI;
BEGIN

  OPEN CUR;
    FETCH CUR INTO V_MADT;

    WHILE CUR%FOUND 
    LOOP
      UPDATE DOITUONG
      SET TONGTIENPHAT = TONGTIENPHAT - N_OLD_MTP + N_NEW_MTP
      WHERE MADT = V_MADT;

      FETCH CUR INTO V_MADT;
    END LOOP;
  END CUR;

  DBMS_OUTPUT.PUT_LINE('CAP NHAP LOI THANH CONG');
END;
-- VIPHAM
CREATE OR REPLACE TRIGGER TRG_VIPHAM_INSERT_CAUA
BEFORE INSERT ON VIPHAM
FOR EACH ROW
DECLARE
  N_MUCTIENPHAT LOI.MUCTIENPHAT%TYPE;
  N_MADT DOITUONG.MADT%TYPE := :NEW.MADT;

  SELECT MUCTIENPHAT INTO N_MUCTIENPHAT ON LOI
  WHERE MALOI = :NEW.MALOI;
BEGIN
  DBMS_OUTPUT.PUT_LINE('THEM VIPHAM THANH CONG');

  UPDATE DOITUONG
  SET TONGTIENPHAT = TONGTIENPHAT + N_MUCTIENPHAT
  WHERE MADT = N_MADT;
END;

CREATE OR REPLACE TRIGGER TRG_VIPHAM_DELETE_CAUA
BEFORE DELETE ON VIPHAM
FOR EACH ROW
DECLARE
  N_MUCTIENPHAT LOI.MUCTIENPHAT%TYPE;
  N_MADT DOITUONG.MADT%TYPE := :OLD.MADT;

  SELECT MUCTIENPHAT INTO N_MUCTIENPHAT ON LOI
  WHERE MALOI = :OLD.MALOI;
BEGIN
  DBMS_OUTPUT.PUT_LINE('XOA VIPHAM THANH CONG');

  UPDATE DOITUONG
  SET TONGTIENPHAT = TONGTIENPHAT - N_MUCTIENPHAT
  WHERE MADT = N_MADT;
END;

--B

CREATE OR REPLACE PROCEDURE PRO_CAUB(
  V_MONTH IN NUMBER,
  V_YEAR IN NUMBER
)
IS
  V_MADT DOITUONG.MADT%TYPE;
  V_HOTEN DOITUONG.MADT%TYPE;
  N_STT NUMBER := 0;

  CURSOR CUR IS
    SELECT DISTINCT(MADT) FROM VIPHAM 
    WHERE EXTRACT(MONTH FROM THOIDIEMVP) = V_MONTH AND EXTRACT(YEAR FROM THOIDIEMVP) = V_YEAR;
BEGIN
  IF V_MONTH IS NULL OR V_YEAR IS NULL
  THEN
    RAISE_APPLICATION_ERROR(-20001, 'ERROR: INPUT KHONG DUOC NULL');
  END IF;

  IF V_MONTH < 1 OR V_MONTH > 12
  THEN
    RAISE_APPLICATION_ERROR(-20001, 'ERROR: THANG KO HOP LE');
  END IF;
 
  DBMS_OUTPUT.PUT_LINE('DANH SACH CAC DOI TUONG VI PHAM TRONG THANG '||V_MONTH||' NAM '||V_YEAR);

  OPEN CUR;
    FETCH CUR INTO V_MADT;

    WHILE CUR%FOUND 
    LOOP
      N_STT = N_STT + 1;
      
      SELECT HOTEN INTO V_HOTEN FROM DOITUONG
        WHERE MADT = V_MADT;

      DBMS_OUTPUT.PUT_LINE('STT: '||N_STT||' MADT: '||V_MADT||' HOTEN: '||V_HOTEN);    
 
      FETCH CUR INTO V_MADT;
    END LOOP;
  END CUR;
END;

 --C

CREATE OR REPLACE PROCEDURE PRO_CAUC
(
  V_YEAR IN NUMBER  
)
IS
  MAX_SLVP NUMBER := 0;
  N_SLVP NUMBER;
  V_MADT VIPHAM.MADT%TYPE;

  N_STT NUMBER := 0;
  V_HOTEN DOITUONG.HOTEN%TYPE;

  CURSOR CUR IS
    SELECT DISTINCT(MADT) FROM VIPHAM
    WHERE EXTRACT (YEAR FROM THOIDIEMVP) = V_YEAR;
  CURSOR CUR_LOOP IS
    SELECT DISTINCT(MADT) FROM VIPHAM
    WHERE EXTRACT (YEAR FROM THOIDIEMVP) = V_YEAR;
BEGIN
  DBMS_OUTPUT.PUT_LINE('DANH SACH CAC DOI TUONG CO SO LUONG VI PHAM NHIEU NHAT TRONG NAM '||V_YEAR);

  -- TIM SO LUONG VI PHAM MAX (MAX_SLVP)
  OPEN CUR;  
    FETCH CUR INTO V_MADT;

    WHILE CUR%FOUND
    LOOP
      SELECT COUNT(*) INTO N_SLVP FROM VIPHAM 
      WHERE MADT = V_MADT;

      IF MAX_SLVP < N_SLVP THEN
        MAX_SLVP = N_SLVP;
      END IF;

      FETCH CUR INTO V_MADT;
    END LOOP;
  END CUR;

  -- TIM CAC DOI TUONG CO SO LAN VI PHAM = MAX_SLVP
  OPEN CUR_LOOP;
    FETCH CUR_LOOP INTO V_MADT;

    WHILE CUR_LOOP%FOUND
    LOOP
      SELECT COUNT(*) INTO N_SLVP FROM VIPHAM 
      WHERE MADT = V_MADT;

      IF MAX_SLVP = N_SLVP THEN
        N_STT = N_STT + 1;
        
        SELECT HOTEN INTO V_HOTEN FROM DOITUONG
        WHERE MADT = V_MADT;

        DBMS_OUTPUT.PUT_LINE('STT: '||N_STT||' HOTEN: '||V_HOTEN ||' TONG SO LAN VI PHAM: '||MAX_SLVP);    
      END IF;

      FETCH CUR_LOOP INTO V_MADT;
    END LOOP;
  END CUR_LOOP;
END;

SELECT * FROM VIPHAM;
