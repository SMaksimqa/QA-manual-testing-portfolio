# Test Cases: Login Flow on demoqa.com

## Summary
Testing login functionality on https://demoqa.com/login  
Focus: Positive and negative scenarios for username/password validation.

| Test Case ID | Test Case Name              | Preconditions                          | Steps                                                                 | Expected Result                                      | Actual Result                                      | Status   |
|--------------|-----------------------------|----------------------------------------|-----------------------------------------------------------------------|------------------------------------------------------|----------------------------------------------------|----------|
| TC-001       | Valid Login (Positive)      | User is on login page with valid credentials | 1. Enter valid username<br>2. Enter valid password<br>3. Click Login | User is redirected to dashboard / profile page      | Redirect to dashboard (test passed)                | Passed   |
| TC-002       | Invalid Password (Negative) | User is on login page with valid username    | 1. Enter valid username<br>2. Enter invalid password<br>3. Click Login | Error message "Invalid username or password" shown, no redirect | Error message "Invalid username or password" shown, page stays on login | Passed   |
| TC-003       | Invalid Username (Negative) | User is on login page                        | 1. Enter invalid username<br>2. Enter any password<br>3. Click Login   | Error message "Invalid username or password" shown, no redirect | Error message "Invalid username or password" shown, page stays on login | Passed   |
