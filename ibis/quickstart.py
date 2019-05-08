import ibis

con = ibis.bigquery.connect(project_id='gn-data-science-project02', dataset_id='grm')
t = con.table('trade_area')
print(t.ship_zip_number.sum().execute())
