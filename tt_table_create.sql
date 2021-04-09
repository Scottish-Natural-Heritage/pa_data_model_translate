-- Creation of test translation tables from current spatial data model to new
-- format outlined in https://github.com/edwardsmarc/postTranslationEngine

CREATE TABLE table_translate_testing.revegetation_and_stabilisation_tt(
	rule_id	serial unique,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);

CREATE TABLE table_translate_testing.stabilisation_by_turfing_tt(
	rule_id	serial unique,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);

CREATE TABLE table_translate_testing.stabilisation_by_geotextile_tt(
	rule_id	serial unique,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);

CREATE TABLE table_translate_testing.stabilisation_by_turfing_tt(
	rule_id	serial unique,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);

CREATE TABLE table_translate_testing.area_based_tt(
	rule_id	serial unique,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);

CREATE TABLE table_translate_testing.dam_points_tt(
	rule_id	serial unique,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);

CREATE TABLE table_translate_testing.restoration_activities_line_tt(
	rule_id	serial unique,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);
	
CREATE TABLE table_translate_testing.bare_peat_areas_tt(
	rule_id	serial unique,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);
	
CREATE TABLE table_translate_testing.photo_points_tt(
	rule_id	serial unique,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);
	
CREATE TABLE table_translate_testing.mixtures_tt(
	rule_id	serial unique,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);
	
CREATE TABLE table_translate_testing.subsite_boundaries_tt(
	rule_id	serial unique,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);
	
CREATE TABLE table_translate_testing.project_boundaries_tt(
	rule_id	serial unique,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);

CREATE TABLE table_translate_testing.lu_point_technique(
	source_val int,
	target_val text	
	);

CREATE TABLE table_translate_testing.lu_point_material(
	source_val int,
	target_val text	
	);
	
INSERT INTO table_translate_testing.lu_point_technique(source_val, target_val)
	VALUES(1, 'Dam'), (2, 'Dam'), (3, 'Dam'), (4, 'Dam'),
	(5, 'Dam'), (7, 'Gully blocking'), (8, 'Other')
	


-- configure created tables with translato rules for each
-- see https://github.com/edwardsmarc/PostgreSQL-Table-Translation-Framework/blob/master/README.md

INSERT INTO table_translate_testing.revegetation_and_stabilisation_tt(
	target_attribute, target_attribute_type, 
	validation_rules, translation_rules, description,
	desc_uptodate_with_rules)
	VALUES('ROW_TRANSLATION_RULE', 'NA', notNull('ITEM_TYPE'),
		   'NA', 'Translate row when ITEM_TYPE is not NULL', TRUE),
		   


INSERT INTO table_translate_testing.point_translate(
	rule_id, target_attribute, target_attribute_type, 
	validation_rules, translation_rules, description,
	desc_uptodate_with_rules)
	VALUES
	