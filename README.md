Simple Money
#### Video Demo:  <URL HERE>
#### Description:
Super simple budget planner mobile app written in Swift.
SwiftUI for the front end
Supabase for the backend
Supabase Auth handles the login and sign up flows
Users can open the settings via the settings button to input their annual income. 
The landing page shows the users daily history of expenses and compares it to their "daily" income, which is simple calculated by their annual income divided by 365. Accounting for leap year could be future enhancement.
The user can click the + button to open a screen to add a new expense. In this add expense view, the user can select a day and add the expense name and description.

Auth: Leverages Supabase Authentication and its built in users table. 
Database: Two tables. 1) users table that stores the user id, date of account creation, annual income and email. 2) expenses table storing expense id, created timestamp, user_id (foreign key), amount, description, expense date.

