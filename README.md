# Simple jQuery form validator

Just another lightweight and flexible form validator.

## Usage

### In HTML

Specify validation rules inside "data-validation" attribute on target input.

```html
<input type="text" name="name" data-validation="required">
```

Separate multiple validation rules with `|`. Rules will checked in the order that they are arranged.

```html
<input type="text" name="email" data-validation="required|email">
```

Some rules have specific arguments, use `:` to specify arguments

```html
<input type="text" name="phone" data-validation="numeric|minLength:10">
```

### In JavaScript

To validate, call the `$.validate()` function on your form.

```javascript
var validation = $('#my-form').validate();
```

It will return the following object:

```javascript
{  
    passed: boolean
    failed: boolean
    errors: object
}
```

If there are errors, the errors object will contain an object with the input name as the key and the failed rule as the value.

```javascript
{
    passed: false
    failed: true
    errors: {
        name: "required",
        age: "numeric",
        email: "email"
    }
}
```

## Custom validation rules

You can specify your own validation rules when calling the validate method. For each custom rule, it will always return the value and the input as the first and last arguments.

```javascript
var customValidation = {
    foo: function (value, input) {
        return value === "foo";
    }
};

var validation = $('#my-form').validate(customValidation);
```

You can also use `:` to include different arguments.
```html
<div id="captcha">xAkJDE</div>
<input type="text" name="captcha" data-validation="required|captcha:#captcha">
```
```javascript
var customValidation = {
    captcha: function (value, target, input) {
        return value === $(target).text();
    }
};

var validation = $('#my-form').validate(customValidation);
```

## Pre-defined rules

*Note: All `target`s are specified with jQuery selector strings*

- __required__: *(value)* Must be `true` or have a length
- __requiredUnique__: *(value, target)* Must have a single input filled out among the current input and the targets.
- __requiredScopedUnique__: *(value, target, scope, input)* Must have a single input filled out among the current input and the targets. This is constrained to the specified scope (relative to the current input).
- __requiredIfFilled__: *(value, target)* If target is filled then current input is also required.
- __emptyIfFilled__: *(value, target)* If target is filled then current input must be empty.
- __email__: *(value)* Must be a valid e-mail
- __numeric__: *(value)* Must be a numeric value
- __length__: *(value, target)* Must have a length of specified target
- __minLength__: *(value, target)* Must have a length of at least target
- __maxLength__: *(value, target)* Must have a length no longer than target
- __twId__: *(value)* Must be a valid Taiwan id format
- __twPhone__: *(value)* Must be a valid Taiwan phone number format