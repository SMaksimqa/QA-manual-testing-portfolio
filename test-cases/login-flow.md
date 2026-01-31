# Test Cases: Login Flow on demoqa.com

## Test Case 1: Valid Login (Positive Scenario)

- Preconditions: User is on login page with valid credentials available
- Steps:
  1. Enter valid username
  2. Enter valid password
  3. Click Login
- Expected Result: User is redirected to dashboard / profile page
- Actual Result: Redirect to dashboard (test passed)

## Test Case 2: Invalid Password (Negative Scenario)

- Preconditions: User is on login page with valid username
- Steps:
  1. Enter valid username
  2. Enter invalid password
  3. Click Login
- Expected Result: Error message is displayed (e.g. "Invalid username or password"), no redirect to dashboard
- Actual Result: Error message "Invalid username or password" is shown, page stays on login form

## Test Case 3: Invalid Username (Negative Scenario)

- Preconditions: User is on login page
- Steps:
  1. Enter invalid username
  2. Enter any password
  3. Click Login
- Expected Result: Error message is displayed (e.g. "Invalid username or password"), no redirect
- Actual Result: Error message "Invalid username or password" is shown, page stays on login form
