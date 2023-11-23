## Run server
``` bash
cd server 
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
flask run
```

## Run client
``` bash
cd client
npm start
```

## Project process
- [x] Create all table and reference, and constraints of each table.
- [x] Insert sample data. (Each table have one or two meaning record).
- [x] Define all query, trigger, procedure, function for report.
- [ ] Implement query, trigger, procedure, function.
    - [ ] Insert, update, delete records to 1 table.
    - [ ] 2 Trigger 
    - [ ] 2 Procedure
    - [ ] 2 Function
- [x] Create skeleton app.
- [ ] Implement app.
