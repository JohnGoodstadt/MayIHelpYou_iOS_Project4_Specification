# May I Help You Project 4
Minimal May I Help You iOS app ready for translation to Android

The 4th of 4 Projects to build an Android App similar to an iOS one.

The full iOS app has 5 tabs:Home, Lessons, Phrases, Practice, Account.

This iOS branch is completing all tasks to enable a pilot project to complete

1. Login

• When app launches and the user has never logged in, then show the login screen.
• When app launches and the user has logged in previously then show the Data Loading screen. Load all data and exit to reveal the app.

After the user has logged in, they should never have to login again.

2. Data Loading View

• A full page modal view that waits for the async getting-of-data from the Firebase database.
• This page load everytime the app starts, after the user has logged in. The logging-in process (on first use) saves all data necessary to load the full database in the Loading View, on all subsequent occaisions.
