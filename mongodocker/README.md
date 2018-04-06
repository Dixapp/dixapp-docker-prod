# Dixapp mongo database

Container with mongo and loaded cards, just for dixapp app

## Usage

Run
`sudo docker build . -t dix_mongo` , then
`sudo docker run -p 2717:27017 --name mongo-test dix_mongo`.

Service should appeal at localhost:2717