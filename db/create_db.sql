BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "models" (
	"make"	TEXT(10),
	"code"	TEXT(10),
	"description"	TEXT,
	PRIMARY KEY("make","code")
);
CREATE TABLE IF NOT EXISTS "options" (
	"make"	TEXT(10),
	"model"	TEXT(10),
	"code"	TEXT(10),
	"type"	TEXT(10),
	"description"	TEXT,
	PRIMARY KEY("make","model","code","type")
);
CREATE INDEX IF NOT EXISTS "models_index" ON "models" (
	"make"	ASC,
	"code"	ASC
);
CREATE INDEX IF NOT EXISTS "options_index" ON "options" (
	"make"	ASC,
	"model"	ASC,
	"type"	ASC
);
COMMIT;
