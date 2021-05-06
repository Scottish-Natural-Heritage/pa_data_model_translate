/*

Peatland Action - Table Translation Tool - based on https://github.com/edwardsmarc/PostgreSQL-Table-Translation-Framework

Translation between current (hereafter old) model and proposed (hereafter new) spatial data models

Glossary (See https://github.com/edwardsmarc/PostgreSQL-Table-Translation-Framework/blob/master/README.md for further detail)
Source table - The table to be validated and translated.
Target table - The table created by the translation process.
Source attribute/value - The attribute or value stored in the source table.
Target attribute/value - The attribute or value to be stored in the translated target table.
Translation table - User created table read by the translation engine and defining the structure of the target table, the validation rules and the translation rules.
Translation row - One row of the translation table.
Validation rule - The set of validation helper functions used to validate the source values of an attribute. There is one set of validation rules per row in the translation table.
Translation rule - The translation helper function used to translate the source values to the target values. There is only one translation rule per translation row in the translation table.
Lookup table - User created table of lookup values used by some helper functions to convert source values into target values.

** Note: The tables should be derived by the output (new model) - i.e. if the new model splits an old table into two, you would need two separate translation tables

*/

-- project wide lookup table creation

-- intervention type

DROP TABLE IF EXISTS table_translate_testing.lu_iv_type;
CREATE TABLE table_translate_testing.lu_iv_type(
	s_val text,
	intervention text
);

INSERT INTO table_translate_testing.lu_iv_type(s_val, intervention)
	VALUES
	(1, 'Instillation'),
	(2, 'Maintenance'),
	(3, 'Major repair'),
	(4, 'Removal'),
	(99, NULL)
;


-- layer specific lookup table creation

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

-- layer translation table creation

/* Create translation rule table - uses following format:
	rule_id - no purpose other than pk
	target_attribute - field of target table
	target_attribute_type - attribute of target field
	validation_rules - validation checks that source value must pass before translation
	translation_rules - translation rules to apply to translate source to target
	description - text description of translation rules
	desc_update_with_rules - boolean describing whether the translation rules are up to date with the description */

DROP TABLE IF EXISTS table_translate_testing.reveg_and_stab_tt;
CREATE TABLE table_translate_testing.reveg_and_stab_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);


DROP TABLE IF EXISTS table_translate_testing.stab_by_turf_tt;
CREATE TABLE table_translate_testing.stab_by_turf_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);


DROP TABLE IF EXISTS table_translate_testing.stab_by_geotext_tt;
CREATE TABLE table_translate_testing.stab_by_geotext_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);


DROP TABLE IF EXISTS table_translate_testing.area_based_tt;
CREATE TABLE table_translate_testing.area_based_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);


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

DROP TABLE IF EXISTS table_translate_testing.rest_line_tt;
CREATE TABLE table_translate_testing.rest_line_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);
	

DROP TABLE IF EXISTS table_translate_testing.bare_peat_tt;
CREATE TABLE table_translate_testing.bare_peat_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);


DROP TABLE IF EXISTS table_translate_testing.photo_points_tt;
CREATE TABLE table_translate_testing.photo_points_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);


DROP TABLE IF EXISTS table_translate_testing.mixtures_tt;
CREATE TABLE table_translate_testing.mixtures_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);


DROP TABLE IF EXISTS table_translate_testing.sub_bound_tt;
CREATE TABLE table_translate_testing.sub_bound_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);


DROP TABLE IF EXISTS table_translate_testing.proj_bound_tt
CREATE TABLE table_translate_testing.proj_bound_tt(
	rule_id	serial primary key,
	target_attribute text,
	target_attribute_type text,
	validation_rules text,
	translation_rules text,
	description text,
	desc_uptodate_with_rules boolean
	);

-- translation table population

-- area_based_tt

-- dam_points_tt

INSERT INTO table_translate_testing.dam_points_tt(target_attribute, target_attribute_type, validation_rules, translation_rules, description, desc_uptodate_with_rules) 
	VALUES 	
	('uid', 'int', 'notNull(objectid)', 'copyInt(objectid)', 'copies objectid to new model', TRUE),
	('grant_id', 'text', 'notNull(project_id)', 'copyText(project_id)', 'copies project_id',TRUE),
	('site_id', 'int', 'isInt(subsite);notNull(subsite)', 'copyInt(subsite)', 'copies subsite_id', TRUE),
	('restoration_technique', 'text','notNull(item_type);matchTable(item_type::text,''table_translate_testing'',''lu_point'', ''s_val'')','lookupText(item_type::text, ''table_translate_testing'', ''lu_point'', ''s_val'', ''technique'')','Maps source technique to target technique using lookup table', TRUE),
	('material_used', 'text', 'notNull(item_type);matchTable(item_type::text,''table_translate_testing'',''lu_point'', ''s_val'')','lookupText(item_type::text, ''table_translate_testing'', ''lu_point'', ''s_val'', ''material'')','Maps source technique to target technique using lookup table', TRUE),
	('notes', 'text', 'NotNull(notes)', 'CopyText(notes)',  'copy notes', TRUE),
	('intervention_type', 'text', 'notNull(item_type);matchTable(iv_type,''table_translate_testing'',''lu_iv_type'', ''s_val'')', 'lookupText(iv_type, ''table_translate_testing'', ''lu_iv_type'', ''s_val'', ''intervention'')','Maps source technique to target technique using lookup table', TRUE),
	('width', 'double precision', 'NotNull(avg_span)', 'copyDouble(avg_span)', 'copy avg_span', TRUE),
	('depth', 'double precision', 'NotNull(avg_depth)', 'copyDouble(avg_depth)', 'copy avg_depth', TRUE),
	('geom', 'geometry', 'True()', 'copyText(shape)', 'geometry field', TRUE)
;

-- linear_features

INSERT INTO table_translate_testing.rest_line_tt(target_attribute, target_attribute_type, validation_rules, translation_rules, description, desc_uptodate_with_rules)
    VALUES
    ('uid'),
    ('grant_id'),
    ('site_id'),
    ('restoration_technique'),
    ('material_used'),
    ('notes'),
    ('intervention_type'),
    ('average_spacing_m'),
    ('width_m'),
    ('depth_m'),
    ('geom')
;

-- sub_bound

INSERT INTO table_translate_testing.linear_restoration_tt(target_attribute, target_attribute_type, validation_rules, translation_rules, description, desc_uptodate_with_rules)
    VALUES
    ('uid'),
    ('grant_id'),
    ('site_id'),
    ('restoration_technique'),
    ('material_used'),
    ('notes'),
    ('intervention_type'),
    ('average_spacing_m'),
    ('width_m'),
    ('depth_m'),
    ('geom')
;

-- forest to bog

INSERT INTO table_translate_testing.linear_restoration_tt(target_attribute, target_attribute_type, validation_rules, translation_rules, description, desc_uptodate_with_rules)
    VALUES
    ('uid'),
    ('grant_id'),
    ('site_id'),
    ('restoration_technique'),
    ('previous_cover'),
    ('average_stump_size_m'),
    ('notes'),
    ('geom')
;


-- bare_peat_tt

INSERT INTO table_translate_testing.bare_peat_tt(target_attribute, target_attribute_type, validation_rules, translation_rules, description, desc_uptodate_with_rules)
    VALUES
    ('uid'),
    ('grant_id'),
    ('site_id'),


-- proj_bound_tt

-- reveg_and_stab_tt

-- stab_by_turf_tt

-- stab by geotext_tt

-- photo_points_tt
