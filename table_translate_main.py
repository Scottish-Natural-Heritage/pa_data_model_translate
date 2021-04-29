"""
Script to programatically create translation tables from old model to new
"""

import psycopg2
from config import config
from psycopg2 import AsIs




def connect_postgres():
    """Connect to the PostgreSQL database server"""
    conn = None
    try:

        # read connection parameters
        params = config()

        # connect to the PostgreSQL server
        print('Connecting to the PostgreSQL database...')
        conn = psycopg2.connect(**params)

        return conn
       
    except (Exception, psycopg2.DatabaseError) as e:
        print(e)


def create_translaion_table(tablename, cur):
    """Function to create translation table"""
    column_sql = []
  
    for column_info in cur2:
    
        column_sql.append ("{} {} {}".format(column_info[0],column_info[1],convert_nullable(column_info[2])))

    column_sql_text = (",".join(map(str, column_sql)))   

    create_table_sql_text = ("CREATE TABLE if not exists {} ({});".format(tablename, column_sql_text))

    return create_table_sql_text



def main():

    query = """
        CREATE TABLE table_translate_testing.%s_tt(
            rule_id	serial unique,
            target_attribute text,
            target_attribute_type text,
            validation_rules text,
            translation_rules text,
            description text,
            desc_uptodate_with_rules boolean
	    );
        """
    
    tables = []

    

    pg_conn = connect_postgres()

if __name__ == '__main__':
    main()