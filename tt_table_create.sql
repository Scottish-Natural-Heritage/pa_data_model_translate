/* Creation of test translation tables from current spatial data model to new
format outlined in https://github.com/edwardsmarc/postTranslationEngine

Glossary
Source table - The table to be validated and translated.
Target table - The table created by the translation process.
Source attribute/value - The attribute or value stored in the source table.
Target attribute/value - The attribute or value to be stored in the translated target table.
Translation table - User created table read by the translation engine and defining the structure of the target table, the validation rules and the translation rules.
Translation row - One row of the translation table.
Validation rule - The set of validation helper functions used to validate the source values of an attribute. There is one set of validation rules per row in the translation table.
Translation rule - The translation helper function used to translate the source values to the target values. There is only one translation rule per translation row in the translation table.
Lookup table - User created table of lookup values used by some helper functions to convert source values into target values.*/

DROP TABLE table_translate_testing.reveg_and_stab_tt;
CREATE TABLE table_translate_testing.reveg_and_stab_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);


DROP TABLE table_translate_testing.stab_by_turf_tt;
CREATE TABLE table_translate_testing.stab_by_turf_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);


DROP TABLE table_translate_testing.stab_by_geotext_tt;
CREATE TABLE table_translate_testing.stab_by_geotext_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);


DROP TABLE table_translate_testing.area_based_tt;
CREATE TABLE table_translate_testing.area_based_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);


DROP TABLE table_translate_testing.dam_points_tt;
CREATE TABLE table_translate_testing.dam_points_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);


DROP TABLE table_translate_testing.lu_point;
CREATE TABLE table_translate_testing.lu_point(
	s_val text,
	t_val text
);


INSERT INTO table_translate_testing.lu_point(s_val, t_val1, t_val2)
	VALUES
	('1', 'Dam', 'Plastic'), ('2', 'Dam', 'Timber'), ('3', 'Dam', 'Stone'), ('4', 'Dam', 'Heather'),
	('5', 'Dam', 'Composite'), ('7', 'Gully blocking', 'NULL'), ('99', 'Other', 'Unknown');


DROP TABLE IF EXISTS table_translate_testing.dam_points_tt;
CREATE TABLE table_translate_testing.dam_points_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);


DROP TABLE  IF EXISTS table_translate_testing.lu_point;
CREATE TABLE table_translate_testing.lu_point(
	s_val text,
	technique text,
	material text
);


INSERT INTO table_translate_testing.lu_point(s_val, technique, material)
	VALUES
	('1', 'Dam', 'Plastic'), ('2', 'Dam', 'Timber'), ('3', 'Dam', 'Stone'), ('4', 'Dam', 'Heather'),
	('5', 'Dam', 'Composite'), ('7', 'Gully blocking', ''), ('99', 'Other', 'Unknown');


INSERT INTO table_translate_testing.dam_points_tt(target_attribute, target_attribute_type, validation_rules, translation_rules, description, desc_uptodate_with_rules)
VALUES 	('uid', 'int', 'notNull(objectid)', 'copyInt(objectid)', 'copies objectid to new model', TRUE),
		('grant_id', 'text', 'notNull(project_id)', 'copyText(project_id)', 'copies project_id',TRUE),
		('restoration_technique', 'text', 
		'notNull(item_type);matchTable(item_type::text,''table_translate_testing'',''lu_point'', ''s_val'')',
		'lookupText(item_type::text, ''table_translate_testing'', ''lu_point'', ''s_val'', ''technique'')',
		'Maps source technique to target technique using lookup table', TRUE),
	    ('material_used', 'text',
		'notNull(item_type);matchTable(item_type::text,''table_translate_testing'',''lu_point'', ''s_val'')',
		'lookupText(item_type::text, ''table_translate_testing'', ''lu_point'', ''s_val'', ''material'')',
		'Maps source technique to target technique using lookup table', TRUE),
		('notes', 'text', 'notNull(notes)', 'copyText(notes)',  'copy notes', TRUE),
		('width', 'double precision', 'False()', 'nothingDouble()', 'copy avg_span', TRUE),
		('depth', 'double precision', 'False()', 'NothingDouble()', 'copy avg_depth', TRUE),
		('geom', 'geometry',
		 'notNull(shape)', 'copyText(shape)', 'geometry field', TRUE);
 
SELECT TT_Prepare('table_translate_testing', 'dam_points_tt');

DROP TABLE table_translate_testing.test_points;
CREATE TABLE table_translate_testing.test_points AS
SELECT * FROM TT_Translate('old_restoration_data_model', 'dam_points');

SELECT * FROM table_translate_testing.test_points limit(100)

DROP TABLE table_translate_testing.rest_line_tt;
CREATE TABLE table_translate_testing.rest_line_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);
	

DROP TABLE table_translate_testing.bare_peat_tt;
CREATE TABLE table_translate_testing.bare_peat_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);


DROP TABLE table_translate_testing.photo_points_tt;
CREATE TABLE table_translate_testing.photo_points_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);


DROP TABLE table_translate_testing.mixtures_tt;
CREATE TABLE table_translate_testing.mixtures_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);


DROP TABLE table_translate_testing.sub_bound_tt;
CREATE TABLE table_translate_testing.sub_bound_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);


DROP TABLE table_translate_testing.proj_bound_tt
CREATE TABLE table_translate_testing.proj_bound_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);


	
INSERT INTO table_translate_testing.lu_point_technique(source_val, target_val)
	VALUES
	(1, 'Dam'), (2, 'Dam'), (3, 'Dam'), (4, 'Dam'),
	(5, 'Dam'), (7, 'Hag blocking') (7, 'Gully blocking'), 
	(99, 'Other')
	


-- configure created tables with translato rules for each
-- see https://github.com/edwardsmarc/PostgreSQL-Table-Translation-Framework/blob/master/README.md

INSERT INTO table_translate_testing.revegetation_and_stabilisation_tt(
	target_attribute, target_attribute_type, 
	validation_rules, translation_rules, description,
	desc_uptodate_with_rules)
	VALUES('ROW_TRANSLATION_RULE', 'NA', notNull('ITEM_TYPE'),
		   'NA', 'Translate row when ITEM_TYPE is not NULL', TRUE),
		   


INSERT INTO table_translate_testing.point_translate(
	target_attribute, target_attribute_type, 
	validation_rules, translation_rules, description,
	desc_uptodate_with_rules)
	VALUES('ROW_TRANSLATION_RULE', 'NA', notNull(item_type),
		   'NA', 'Translation desc', TRUE)
		   ('restoration_technique', 'text',notNull(item_type); matchTable(item_type, table_translate_testing, lu_point_technique, source_val))


/*MatchTable(text srcVal, text lookupSchemaName[default 'public'], 
text lookupTableName, text lookupColumnName[default 'source_val'], 
boolean ignoreCase[default FALSE], boolean acceptNull[default FALSE])*/

CREATE TABLE table_translate_testing.point_translate AS
SELECT 1 AS rule_id, 
       'restoration_technique' AS target_attribute, 
       'text' AS target_attribute_type, 
       'notNull(item_type);matchTable(item_type,''table_translate'',''lu_point'', ''source_val'')' AS validation_rules, 
       'lookupText(item_type, ''table_translate'', ''lu_point'', ''source_val'', ''target_val'')' AS translation_rules, 
       'Maps source value to target value using lookup table' AS description, 
       TRUE AS desc_uptodate_with_rules
UNION ALL
SELECT 2, 'geom', 
          'geometry', 
          'notNull(shape)', 
          'copyGeometry(shape)', 
          'Copies shape to geom', 
          TRUE;


DROP TABLE table_translate_testing.point_translate;

CREATE TABLE table_translate_testing.point_translate(
	rule_id serial PRIMARY KEY
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
)

INSERT INTO table_translate_testing.point_translate()

SELECT 1 AS rule_id, 
       'restoration_technique' AS target_attribute, 
       'text' AS target_attribute_type, 
       'notNull(item_type);matchTable(item_type::text,''table_translate_testing'',''lu_point'', ''s_val'')' AS validation_rules, 
       'lookupText(item_type::text, ''table_translate_testing'', ''lu_point'', ''s_val'', ''t_val'')' AS translation_rules, 
       'Maps source value to target value using lookup table' AS description, 
       TRUE AS desc_uptodate_with_rules;


CREATE TABLE table_translate_testing.point_translate AS
SELECT 1 AS rule_id, 
       'restoration_technique' AS target_attribute, 
       'text' AS target_attribute_type, 
       'notNull(item_type);matchTable(item_type::text,''table_translate_testing'',''lu_point'', ''s_val'')' AS validation_rules, 
       'lookupText(item_type::text, ''table_translate_testing'', ''lu_point'', ''s_val'', ''t_val'')' AS translation_rules, 
       'Maps source value to target value using lookup table' AS description, 
       TRUE AS desc_uptodate_with_rules;
--UNION ALL;
/*SELECT 2, 'geom', 
          'geometry', 
          'GeoIsValid(shape, TRUE)', 
          'shape', 
          'Copies shape to geom', 
          TRUE;*/
		  


	
SELECT TT_Prepare('table_translate_testing', 'point_translate');	

CREATE TABLE table_translate_testing.test_points AS
SELECT * FROM TT_Translate('old_restoration_data_model', 'dam_points')

SELECT * FROM table_translate_testing.test_points