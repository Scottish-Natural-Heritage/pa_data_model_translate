"""
Script to programatically create translation tables from old model to new
"""

import argparse
import os
import sys
import psycopg2
from config import config
from osgeo import ogr




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

def create_field_list(layer):

    """ Go through the layer and extract each of the field names """
    
    field_dict = {
        'Restoration_activities_line': ['ITEM_TYPE', 'NUM_INST', 'AVG_SPAN', 'AREA_IMP', 'IV_TYPE', 'IV_METH'],
        'Project_boundary': ['SITE_NAME', 'APPL_NAME', 'APPL_TYPE', 'RST_START', 'RST_FINISH', 'COST_CASH', 'LOCATION', 'FILES'],
        'Dam_points': ['ITEM_TYPE', 'IMP_AREA', 'AVG_SPAN', 'AVG_DEPTH', 'EVENT_DATE', 'IV_TYPE', 'IV_METH', 'NOTES'],
        'Other_linear_features': ['ITEM_TYPE', 'ROAD_TYPE', 'FENCE_TYPE', 'DRAIN_TYPE', 'DRAIN_ST', 'DESC_', 'HAG_ST'],
        'Area_based_restoration': ['ITEM_TYPE', 'IV_TYPE', 'TECH', 'PAST_COV', 'PAST_DATE'],
        'Bare_peat_areas': ['DESC_', 'BP_EXTENT', 'NOTES']
    }

    field_list = []
    layer_defn = layer.GetLayerDefn()

    #Add the geometry column, if there is one!
    geom_col = layer.GetGeometryColumn()
    if not geom_col =='':
        field_list.append(geom_col)

    #Add the rest of the fields from the geopackage
    for i in range(layer_defn.GetFieldCount()):
        if layer_defn.GetName() in field_dict:
            if layer_defn.GetFieldDefn(i).GetName() in field_dict[layer_defn.GetName()]:
                field_defn = layer_defn.GetFieldDefn(i).GetName().lower()
                field_list.append(field_defn)
            else:
                pass
        else:
            pass

    #add the grant_id field
    field_list.append('project_id')
    
    return field_list

'''
def create_translaion_table(tablename, cur):
    """Function to create translation table"""
    column_sql = []
  
    for column_info in cur2:
    
        column_sql.append ("{} {} {}".format(column_info[0],column_info[1],convert_nullable(column_info[2])))

    column_sql_text = (",".join(map(str, column_sql)))   

    create_table_sql_text = ("CREATE TABLE if not exists {} ({});".format(tablename, column_sql_text))

    return create_table_sql_text
'''

def create_values_string(layer, grant_id):

    values_string = ""

    field_dict = {
        'Restoration_activities_line': ['ITEM_TYPE', 'NUM_INST', 'AVG_SPAN', 'AREA_IMP', 'IV_TYPE', 'IV_METH'],
        'Project_boundary': ['SITE_NAME', 'APPL_NAME', 'APPL_TYPE', 'RST_START', 'RST_FINISH', 'COST_CASH', 'LOCATION', 'FILES'],
        'Dam_points': ['ITEM_TYPE', 'IMP_AREA', 'AVG_SPAN', 'AVG_DEPTH', 'EVENT_DATE', 'IV_TYPE', 'IV_METH', 'NOTES'],
        'Other_linear_features': ['ITEM_TYPE', 'ROAD_TYPE', 'FENCE_TYPE', 'DRAIN_TYPE', 'DRAIN_ST', 'DESC_', 'HAG_ST'],
        'Area_based_restoration': ['ITEM_TYPE', 'IV_TYPE', 'TECH', 'PAST_COV', 'PAST_DATE'],
        'Bare_peat_areas': ['DESC_', 'BP_EXTENT', 'NOTES']
    }

    #for each feature
    for j in range(1,layer.GetFeatureCount()+1):
        
        lyr_name = layer.GetName()
        values = []        
        #get the next feature (**can't use the indexed GetNextFeature(fid) as the fid does not necessarily start at 1 and increment by 1)
        feature = layer.GetNextFeature()
        
        #check it's not null
        if feature is not None:
            
            geom = feature.GetGeometryRef()
            if geom is not None:
                values+=["st_geomfromtext('"+str(geom)+"',27700)"]

            for key in feature.keys():

                if key in field_dict[lyr_name]: 
                #Get the value for each field and add it to the values array:
                # 
                    print(key)                
                    
                    fld_defn = feature.GetFieldDefnRef(feature.GetFieldIndex(key))
                    if fld_defn.GetType() == ogr.OFTInteger and fld_defn.GetSubType() == ogr.OFSTBoolean:
                        val = bool(feature.GetField(key))
                    else:
                        val = feature.GetField(key)

                    # Postgres strings must be enclosed with single quotes
                    if type(val) == str:
                    #escape apostrophes with two single quotations
                        val = val.replace("'", "''")
                        val = "'" + val + "'"
                    if val is None:
                        val = "NULL"

                    values +=[str(val)]

                else:
                    pass
            #add the grant_id to the feature
            values +=[grant_id]
        
            #make a string surrounded by brackets for each feature's values    
            values_string += "("+','.join(values)+"),\n"
    #remove the last comma and replace with a semi-colon - the end of the sql query
    values_string = values_string[:-2] + ";"
    return values_string


def shp_lyr_list(dir_path, shp_driver):
    """return list of layers in directory that have features associated"""

    shp_list = [os.path.join(dir_path, l) for l in os.listdir(dir_path) if l.endswith('.shp')]

    feat_class_lst = []

    for shp in shp_list:
        data_source = shp_driver.Open(shp, 0)
        layer = data_source.GetLayer()
        print(type(layer))
        feat_count = layer.GetFeatureCount()
        if feat_count > 0:
            print(feat_count)
            feat_class_lst.append(layer)
        else:
            pass

    return feat_class_lst



def gdb_lyr_list(gdb_path, gdb_driver):
    """returns list of layers from esri gdb that contain features"""
    ogr.UseExeceptions()
  
    try:
        gdb = driver.Open(gdb_path, 0)
    except Exception as e:
        print(e)
        sys.exit()

    feat_class_lst = []

    for feat_class_idx in range(gdb.GetLayerCount()):
        feat_class = gdb.GetLayerByIndex(feats_class_idx)
        if feat_class.GetFeatureCount() > 0:
            feat_class_lst.append(feat_class.GetName())
        else:
            pass

    return feat_class_lst


def main():

    parser = argparse.ArgumentParser()
    parser.add_argument("dir_path", help="path of the directory/geodatabase to be imported to database")
    parser.add_argument("grantID", help="The grant ID for the spatial data - ensure this is already present in the database (pa_metadata.grant_reference table)")
    parser.add_argument("schemaname", help="The name of the schema to add the data into - ie pa_final_report or pa_application", choices =['pa_final_report','pa_application','test_data_model', 'table_translate_testing'])

    args = parser.parse_args()



    dir_path = args.dir_path 
    grant_id = args.grantID 
    schema_name = args.schemaname


    metadata_schema = 'test_data_model'
    #metadata_schema = 'pa_metadata'

    shp_lst = [os.path.join(dir_path, l) for l in os.listdir(dir_path) if l.endswith('.shp')]

    '''
    TDOO - Add functionality for geodatabase
    if dir_path.endswith('.gdb'):
        driver = ogr.GetDriverByName('OpenFileGDB')
        lyr_lst = gdb_lyr_list(dir_path, driver)
    else:
        driver = ogr.GetDriverByName('ESRI Shapefile')
        lyr_lst = shp_lyr_list(dir_path, driver)
    '''
        

    pg_conn = connect_postgres()

    '''
    with pg_conn:
        with pg_conn.cursor() as cur:
            #Check that the grant reference is present in the database, and if not, prompt user to do something about it.
            cur.execute("SELECT count(*) from {}.grant_reference where grant_id = %s".format(metadata_schema), (grant_id,))
            count_grant_id = cur.fetchone()
    '''

    #if count_grant_id[0] > 0:
    with pg_conn:
        with pg_conn.cursor() as cur:    

            #Iterate shapefiles and open
            for shp in shp_lst:

                shp_driver = ogr.GetDriverByName('ESRI Shapefile')
                
                data_source = shp_driver.Open(shp)

                da_layer = data_source.GetLayer(0)

                layer_def = da_layer.GetLayerDefn()

                for i in range(layer_def.GetFieldCount()):
                    print(layer_def.GetFieldDefn(i).GetName())
                        
                table_name = da_layer.GetName()
                print ("Layer being processed: {}; feature count = {}".format(table_name, da_layer.GetFeatureCount()))

                #check there are features in the layer (count needs to be > 1 because there is a 'spatial filter' which is always included in the count - see ogr.py line 1517)
                if da_layer.GetFeatureCount() > 1 and not table_name.startswith('lu_'):
                    
                    #Get the list of fields for the layer:
                    field_list = create_field_list(da_layer)

                    #Get the features from the layer and insert them into the database, adding in grant ref:
                    values_string = create_values_string(da_layer, grant_id)

                    sql_string = cur.mogrify("INSERT INTO {}.{} ({})\n VALUES {}".format(schema_name, table_name, ','.join(field_list), values_string))
                    print(sql_string)
                    cur.execute(sql_string)


        #with pg_conn:
        #    with pg_conn.cursor() as cur:
        #        cur.execute(final_transaction_sql)
              
    #else:
       # print("The grant reference {} was not found in the database, please ensure it is added to the grant_reference table".format(grant_id))

    pg_conn.close()
        
if __name__ == '__main__':
    main()