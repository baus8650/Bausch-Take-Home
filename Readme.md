
# Welcome to my unnamed recipe app

This app was built to practice API calls to themealdb.com to list the recipes organized into categories. What made this tricky was implementing sequential API calls to get the list of meals for each category. After getting the sequential calls to work using a Semaphore, I eventually ended up calling the API request for each category in the didSet{} closure in the category list variable. This, for me, was a lot cleaner and easier to trace.

The search functionality currently accepts multiple queries (separated by a space) of both full and partial words. As of right now, the search only applies to categories and I am currently working out a way to search for meals independant of categories.

Future work on this app will include overall UI/UX Improvements for a more attractive and aesthetically pleasing app.
