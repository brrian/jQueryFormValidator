'use strict'

$ = jQuery

$.fn.validate = (customValidation = {}) ->
	hasErrors = false

	errorBag = {}

	validationFunctions =
		required: (value) ->
			switch typeof value
				when 'string' then value.length isnt 0
				when 'boolean' then value

		requiredUnique: (value, target) ->
			hasFilledInput = false
			isUnique = true

			$(target).each (index, element) =>
				targetInput = $(element)
				targetValue = getInputValue targetInput

				if @required(targetValue) is true
					if hasFilledInput is false
						hasFilledInput = true
					else return isUnique = false

			return if isUnique is false then false else hasFilledInput

		requiredScopedUnique: (value, target, scope, input) ->
			hasFilledInput = false
			isUnique = true

			input.parents(scope).find(target).each (index, element) =>
				targetInput = $(element)
				targetValue = getInputValue targetInput

				if @required(targetValue) is true
					if hasFilledInput is false
						hasFilledInput = true
					else return isUnique = false

			return if isUnique is false then false else hasFilledInput

		requiredIfFilled: (value, target) ->
			if @required(getInputValue($(target))) is true then return @required value
			return true

		emptyIfFilled: (value, target) ->
			if @required(getInputValue($(target))) then return !@required value
			return true

		email: (value) ->
			/^(?:\w+\.?\+?)*\w+@(?:\w+\.)+\w+$/.test value

		numeric: (value) ->
			return if value.length then /^\d+$/.test value else true

		length: (value, target) ->
			value.length is parseInt(target, 10)

		minLength: (value, target) ->
			return if value.length then value.length >= target else true

		maxLength: (value, target) ->
			return if value.length then value.length <= target else true

		twId: (value) ->
			@length(value, 10) and /[a-zA-Z]{1,2}\d{8,9}/.test value

		twPhone: (value) ->
			@numeric(value) and @length(value, 10)

	getInputValue = (input) ->
		if input.attr('type') in ['radio', 'checkbox'] then input.prop('checked') else input.val()

	# Merge in custom validation rules
	$.extend validationFunctions, customValidation

	@find('[data-validation]').each (index, element) ->
		input = $(element)

		rules = input.data('validation').split '|'

		return unless rules.length > 0

		value = getInputValue(input)

		for rule in rules
			[rule, args...] = rule.split ':'
			args.unshift value
			args.push input

			if !validationFunctions.hasOwnProperty rule then throw "Validation rule [#{rule}] does not exist."

			if (validationFunctions[rule].apply validationFunctions, args) is false
				hasErrors = true
				return errorBag[input.attr('name')] = rule

	passed: !hasErrors
	failed: hasErrors
	errors: errorBag