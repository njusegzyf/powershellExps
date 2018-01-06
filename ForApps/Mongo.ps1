$mongoBinPath = 'C:\Program Files\mongodb\server\3.2\bin'
cd $mongoBinPath

# run the monog server
.\mongod

# run the monog shell
.\mongo

# close the mongod
# use admin, 执行db.shutdownServer()