## Run server
cd server
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
flask run

## Run client
cd client
npm start