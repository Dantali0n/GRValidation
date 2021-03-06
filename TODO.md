- [X] Type safety
- [X] Value validation
- [X] Object property validation
- [X] Custom validations
- [X] Validations may transform their input
- [ ] Built-in error localization
- [ ] Custom localization of built-in & custom errors
- [X] Global validation of an object (like "Please provide a phone number or an email")
- [ ] It is possible to identify the properties involved in a failed global validation (and, for example, select the email text field after the "Please provide a phone number or an email" error).
- [ ] Full list of validation errors in a value ("Value should be odd. Value should be less than 10.")
- [ ] Full list of validation errors in an object ("Email is empty. Password is empty.")
- [ ] Full list of validation errors for a property name
- [X] Validate that a value may be missing (nil), but, if present, must conform to some rules.
- [ ] Distinguish property validation error from named validation error ("User has invalid name" vs. "Name is invalid" which applies to UITextFields for example)
- [X] A model should be able, in the same time, to 1. store transformed properties (through a phone number validation that returns an internationally formatted phone number) 2. get a full list of validation errors on the model. Without having to write a complex do catch dance.
- [ ] One can change the description of a value validation. This is not the same as localizing a validation error. Example: "should contain the @ sign" is a better description for ValidationRegularExpression(pattern:"@").
- [X] Operator ~= so that one can make a boolean check of a validation. Implies operator !
- [ ] Model Validation should be a case of Value Validation. What prevent us from doing that: mutating validations + we'd like model validation code to avoid using `self` or `$0` everywhere.
- [X] `v1 && v2` should return the result of v2, regardless of v1 output.
