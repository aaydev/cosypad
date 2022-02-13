BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "options" (
	"make"	TEXT(10),
	"model"	TEXT(4),
	"code"	TEXT(4),
	"type"	TEXT(1),
	"description"	TEXT
);
INSERT INTO "options" VALUES ('BMW','1B51','0000','P','OHNE FARBE');
CREATE INDEX IF NOT EXISTS "index1" ON "options" (
	"make"	ASC,
	"model"	ASC,
	"type"	ASC
);
COMMIT;
