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
- [ ] Insert sample data. (Each table have one or two meaning record).
- [x] Define all query, trigger, procedure, function for report.
- [x] Implement query, trigger, procedure, function.
    - [x] Insert, update, delete records to 1 table.
    - [x] 2 Trigger 
    - [x] 2 Procedure
    - [x] 2 Function
- [x] Create skeleton app.
- [ ] Implement app.
    - [ ] 1 Screen insert/update/delete in 1.2.1
    - [ ] 1 screen for list of book, 1.2.3. Allow search, sort, validate, logic in update ,and delete.
    - [ ] 1 screen for another 1.2.3, 1.2.4. 
