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

## Login Flow Details
The view is a chat interface similar to 'Change My Settings'. It proceeds through these states:
1. The user is then prompted for there email address. After inputting a provided email address, by us, it will look up to see if it is a valid and known address. and it will return the available LibraryCodes for this logon. e.g. SC01 and JA65. Each of these represent a complete set of phrases/lessons/conversation etc. Note there is no password requirement for the user to input. It is hard coded in the app for the initial pilot.

2. The user is prompted to tap on which Library Code to use. If there is only 1 then it will choose it automatically.
3. The user is prompted to type in their Name e.g. Peter, John or Julia etc. This will be spoken out by the default Google Voice.
4. After this they confirm they are happt with the choice, or redo again.
5. They then choose a 'male' or 'female' speaker, presumably matching their gender.
6. After this they exit to reveal the app view underneath.

