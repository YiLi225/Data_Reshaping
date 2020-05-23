---- 1. Pivot -> Long to Wide
---- MS SQL server 2017
---- sql fiddle playground: http://sqlfiddle.com/#!18/14047/2
SELECT 
  *
FROM 
  gunpermit 
PIVOT (
      SUM(permit) FOR month IN ([2020-04-30], [2020-03-31], 
                                [2020-02-29], [2020-01-31])
      -- If we want the STATE as columns, use the following 
      -- SUM(permit) FOR state IN ([Alabama], [Alaska], [California], [Massachusetts], [North Dakota])
  ) AS pvt_tab;

---- MySQL
---- sql fiddle playground: http://sqlfiddle.com/#!9/36e0e5/1
SELECT
  state,
  -- the SUM can be replaced by other agg functions, like AVG
  SUM(IF(month = '2020-04-30', permit, NULL)) AS '2020-04-30', 
  SUM(IF(month = '2020-03-31', permit, NULL)) AS '2020-03-31', 
  SUM(IF(month = '2020-02-29', permit, NULL)) AS '2020-02-29', 
  SUM(IF(month = '2020-01-31', permit, NULL)) AS '2020-01-31' 
FROM
  gunpermit
GROUP BY
  state
ORDER BY 
  state;


---- 2. Un-Pivot -> Wide to Long
---- MS SQL server 2017
---- sql fiddle playground: http://sqlfiddle.com/#!18/45c51/5
SELECT 
  *
FROM   
  gunpermit 
UNPIVOT  
   (
    permit FOR month IN ([2020-04-30], [2020-03-31], 
                         [2020-02-29], [2020-01-31])
) AS unpvt_tab; 
   
   
---- Appendix:
---- 1.1 Pivot: CREATE TABLE in MS SQL server 2017
CREATE TABLE GunPermit
    ([month] date, 
     [state] varchar(15), 
     [permit] int
    )
;

INSERT INTO GunPermit
    ([month], [state], [permit])
VALUES
    ('2020-04-30','Alabama',21276),
    ('2020-04-30','Alaska',85),
    ('2020-04-30','California',24460),
    ('2020-04-30','Massachusetts',5074),
    ('2020-04-30','North Dakota',280),
    ('2020-03-31','Alabama',31205),
    ('2020-03-31','Alaska',143),
    ('2020-03-31','California',27792),
    ('2020-03-31','Massachusetts',Null),
    ('2020-03-31','North Dakota',587),
    ('2020-02-29','Alabama',29633),
    ('2020-02-29','Alaska',139),
    ('2020-02-29','California',32002),
    ('2020-02-29','Massachusetts',9173),
    ('2020-02-29','North Dakota',396),
    ('2020-01-31','Alabama',37140),
    ('2020-01-31','Alaska',223),
    ('2020-01-31','California',34694),
    ('2020-01-31','Massachusetts',9289),
    ('2020-01-31','North Dakota',370)
;

---- 1.2 Pivot: CREATE TABLE in MySQL 
CREATE TABLE IF NOT EXISTS `gunpermit` (
  `month` date NOT NULL,
  `state` varchar(60) NOT NULL,
  `permit` int(5) unsigned NOT NULL
) ;
INSERT INTO `gunpermit` (`month`, `state`, `permit`) VALUES
    ('2020-04-30','Alabama',21276),
    ('2020-04-30','Alaska',85),
    ('2020-04-30','California',24460),
    ('2020-04-30','Massachusetts',5074),
    ('2020-04-30','North Dakota',280),
    ('2020-03-31','Alabama',31205),
    ('2020-03-31','Alaska',143),
    ('2020-03-31','California',27792),
    ('2020-03-31','Massachusetts',999),
    ('2020-03-31','North Dakota',587),
    ('2020-02-29','Alabama',29633),
    ('2020-02-29','Alaska',139),
    ('2020-02-29','California',32002),
    ('2020-02-29','Massachusetts',9173),
    ('2020-02-29','North Dakota',396),
    ('2020-01-31','Alabama',37140),
    ('2020-01-31','Alaska',223),
    ('2020-01-31','California',34694),
    ('2020-01-31','Massachusetts',9289),
    ('2020-01-31','North Dakota',370)
;

---- 2. Un-Pivot: CREATE TABLE in MS SQL Server 2017
CREATE TABLE GunPermit
    ([state] varchar(15), 
     [2020-04-30] int,
     [2020-03-31] int,
     [2020-02-29] int, 
     [2020-01-31] int
    )
;

INSERT INTO GunPermit
    ([state], [2020-04-30], [2020-03-31], [2020-02-29], [2020-01-31])
VALUES
    ('Alabama',21276,31205,29633,37140),
    ('Alaska',85,143,139,223),
    ('California',24460,27792,32002,34694),
    ('Massachusetts',5074,null,9173,9289),
    ('North Dakota',280,587,396,370)
    ;
    
    
    