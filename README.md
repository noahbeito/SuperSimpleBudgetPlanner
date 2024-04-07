# Simple Money
## Video Demo:  [Click here](https://youtu.be/JPBNKzk2Pvs)
## Description:
The Simple Budget Planner is a user-friendly mobile application designed to help users manage their finances effectively. Developed in Swift, the app utilizes SwiftUI for the front-end interface, providing a clean and intuitive user experience.

The backend is powered by Supabase, a scalable and reliable solution for data management. User authentication, including login and sign-up flows, is handled seamlessly by Supabase Auth.

Users can personalize the app by inputting their annual income in the settings, accessed via the settings button. The landing page provides a comprehensive view of the user's daily expense history, juxtaposed with their daily income. The daily income is calculated by dividing the user's annual income by 365, with potential future enhancements to account for leap years.

Adding a new expense is made simple with the + button. This opens a new screen where users can select a date and add details about the expense, including its name and description.

The app's database comprises two tables. The 'users' table stores user-specific information such as user id, account creation date, annual income, and email. The 'expenses' table records expense-related data, including expense id, creation timestamp, user_id (as a foreign key), amount, description, and expense date.

## File Descriptions
SuperSimpleBudgetPlannerApp.swift
This file houses the App. Here, we initialize a UserSession State Object and pass it to the ContentView as an Environment Object, so that the app has access to the information stored in the UserSession.

### ContentView.swift
This view checks if a user is logged in. If logged in, it shows the landing page, ExpenseListView. If not logged in, it shows the LoginView.

### Assets
This folder stores Colors and Logo assets.

### Supabase.swift
This file initializes the Supabase Client and Authentication.

### LoginView.swift
This view allows returning users to input their email and password to login to the app. There is also an option to go to the SignupView for new users.

### SignupView.swift
This view allows a new user to sign up for an account and log in. If they already have an account, they can navigate back to the LoginView.

### ExpenseListView.swift
This is the landing page for the app. It shows a list, with each cell representing a day. The current day shows at the top of the list. In each cell, it shows the overview of the users spending for that day, compared to their average daily income. It also shows a net profit or loss for that day. The settings button in the leading edge of the nav bar opens the SettingsView as a sheet. The plus button in the trailing edge of the nav bar opens the AddExpenseView as a sheet.

### UserSession.swift
This class manages the current user's session data. It is an observable object, meaning SwiftUI can observe it for any changes and update the UI accordingly. The user property is @Published, marking it as a single source of truth for the app. When there is a change to the user property, any views that depend on its data will be recomputed. The user property is initialized with an empty user by default.

### AddExpenseView.swift
This view is displayed as a SwiftUI sheet. It shows two buttons in the navigation bar: a cancel button and an add button. The cancel button closes the sheet and returns the user to the ExpenseListView. The Add button adds whatever info the user has added into the form for their new expense to the database table expenses and updates the expense amounts in the ExpenseListView for the date of the expense. The form allows the user to input a text name and text description of the expense. It also uses the built-in date picker to allow the user to pick a date for the expense.

### User.swift
This file defines a User struct. It is a simple data model representing a user of the app. It conforms to the Codable protocol allowing for encoding to and decoding from a serialized format like JSON. This makes it easier to save and load User instances.

### Expense.swift
This file defines a data model that represents an expense in the app. Other than the properties for the expense itself (id, amount, date, and description), it has a computed property called dateAsDate which converts the date string to a Date object.

### DateFormatter.swift
This file contains an extension of the DateFormatter class to format the date string in specific ways to be used throughout the app.

### ExpensesData.swift
This file defines a ViewModel that provides the data and behavior needed by the View to display and manipulate the expenses. It helps the View interact with the Expense model. This handles the data fetching and transformation.

### SettingsView.swift
This view allows the user to update their annual income amount. It consists of a navigation bar with a cancel button to close the sheet. It also has an input bar where the user can update their annual income amount and a save button that updates the database and the ExpenseListView.

## Roadmap:

#### Daily Expense Detail View
This would provide users with a more detailed breakdown of their expenses on a particular day. It could help users understand their spending habits better and make more informed financial decisions.

#### Recurring Expenses
This feature would be very useful for users to track regular payments like rent, utilities, subscriptions, etc. It could help ensure that users are always aware of these recurring expenses and account for them in their budget.

#### Credit Card Integration
This would automate the process of entering expenses into the app, making it easier for users to keep their expense tracking up-to-date. It could also provide real-time updates on spending, which could help users avoid overspending.
