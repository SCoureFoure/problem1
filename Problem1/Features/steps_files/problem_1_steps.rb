require 'pp'

Given(/^Given that I goto '([^"]*)' exercise webpage$/) do |exercise_number|
  # Navigate to the url that was supplied in the BDD
  if exercise_number == 'first'
    $browser.goto 'https://www.exercise1.com/values'
  elsif exercise_number == 'second'
    $browser.goto 'https://www.exercise2.com/values'
  elsif exercise_number == 'third'
    $browser.goto 'https://www.exercise3.com/values'
  end
end

And(/^I check the total number of Labels in the table$/) do
  # grab the text values and add them to an array.
  # SO I'm not going to lie here, because I saw a bug in the txt_val_3 is missing
  # I decided that the best way to make sure that there is coverage on that front
  # is to make [tag, text] pairs so that we can make sure
  # that the lbl_tag count matches the val_tag count on an index loop.

  # grab the label values and add them to an array.
  $lbl_val_pairs = []
  $browser.tags(id: /'lbl_val_'/).each do |tag|
    # capture the tag element.
    # I'm expecting this to be 'lbl_val_1' but without proper debug tools, I can tell.
    tag_attr = tag.attribute 'id'
    # I'm expecting this to be 'Value 1'
    tag_text = tag.text

    # Add both of the tag values to a row.
    row = [tag_attr, tag_text]
    $lbl_val_pairs.push(row)
  end

  # Set the count of the label array to a variable to compare to later.
  $label_count = $lbl_val_pairs.count
end

And(/^I check the total number of Values in the table$/) do
  $txt_val_pairs = []
  $browser.tags(id: /'txt_val_'/).each do |tag|
    # capture the tag element.
    # I'm expecting this to be 'txt_val_1' but without proper debug tools, I can tell.
    tag_attr = tag.attribute 'id'
    # I'm expecting this to be '$122,365.24'
    tag_text = tag.text

    # Add both of the tag values to a row.
    row = [tag_attr, tag_text]
    $txt_val_pairs.push(row)
  end

  # Set the count of the value array to a variable to compare to later.
  $value_count = $txt_val_pairs.count
end

Then(/^I should have the same number of Values$/) do
  # Compare the array sized to check that there are the
  # correct number of values on the screen for the amount of labels.
  if $value_count == $label_count
    # Pass the test whatever way you would want to do that,
    # this is a super basic way to track that.
    $TestResults.push('pass')
  else
    # Pass the test whatever way you would want to do that,
    # this is a super basic way to track that.
    $TestResults.push('fail')
  end
end

And(/^And I check all the values in to be over 0$/) do
  # Since we already have this array lying around-
  # we can just loop through it and check the text values.
  # Declare a variable to falsify if there is any item at or under 0
  @over_zero = true
  $txt_val_pairs.each do |pair|
    p pair[1] # Might help to debug if we wanted to do that.
    pair[1] = pair[1].gsub('$','') # Get rid of the $ to normalize the string
    pair[1] = pair[1].gsub(',','')
    # I'm not entirely sure if because these are float nums
    # that they might break here, but it's pseudo code, so it's okay.
    if pair[1].to_f > 0
      next
    else
      # Once you find one that is failable,
      # then it should fail overall.
      @over_zero = false
    end
  end
end

Then(/^they all should be over 0$/) do
  # If you didn't have to fail because you found a int <= 0,
  # pass the test.
  if @over_zero
    $TestResults.push('pass')
  else
    $TestResults.push('fail')
  end
end
And(/^I capture the totals for labels and values/) do
  # Capture some of these fields in variables to compare to.
  $total_balance_label  = $browser.tag(id: 'lbl_ttl_val').text
  $total_balance_text   = $browser.tag(id: 'txt_ttl_val').text
end

And(/^I calculate the total amounts for the table/) do
  # We want to loop through all the values,
  # and make sure that we add the txt_vals to a running total.
  #
  # Set up some variables
  @running_table_total = 0
  $table_errors        = 0
  $error_rows          = []
  i = 0

  $lbl_val_pairs.count.times do |i| # I don't normally use '.times', so I'm hoping it starts at a 0 index.
    p $lbl_val_pairs[i] # example of first index [[0]'lbl_val_1',[1]'Value 1']
    p $txt_val_pairs[i] # example of first index [[0]'txt_val_1',[1]'$122,365.24']

    # So here is where I think it would be a good idea to just confirm
    # that the correct txt_val is matched with the right lbl_val
    # Because on increment 3 of this loop, we will have lbl_val_3 and txt_val_4,
    # Which is wrong.
    #
    # So a basic way to do this is just to check the tag text for the increment value.
    # (plus 1 because starts at 0)
    correct_index = false
    table_row = (i + 1).to_s
    # I'm sure there are prettier ways of doing this- but for now this works.
    # "Get it working, then get it working better. Repeat."
    if ($lbl_val_pairs[i][0].include?   table_row) # Check for lbl condition.
      if ($txt_val_pairs[i][0].include? table_row) # Check for val condition.
        correct_index = true
      end
    end

    # Make a temp version of the txt_val_i[1] string
    # normalize and add total to the @running_table_total
    temp_value = $txt_val_pairs[i][1]
    temp_value = temp_value.gsub('$','').gsub(',','')
    temp_value = temp_value.to_f # Make it an float to add to other flow values, it may already be a float. Who knows.

    # if both are satified, you can total that value into the running total.
    if correct_index
      @running_table_total = @running_table_total + temp_value
    else
      # We are still going to want to test if the total is calculating correctly -
      # But we will throw another couple variable to grab later
      # to say if it should have or not.
      $table_errors += 1
      rows_in_question = [$lbl_val_pairs[i], $txt_val_pairs[i]]
      $error_rows.push(rows_in_question)

      # Actually run the numbers
      @running_table_total = @running_table_total + temp_value
    end

    # Not sure why it would lose it's correct rounding-
    # but I figure it's a good idea to keep it consistent.
    # If I was actually doing this test- I wouldn't need to do this
    # - more of a logical check than anything.
    @running_table_total = @running_table_total.round(2)

  end # of count.times loop.

 # That loop should go for as many rows as there are values.
 # Results @running_table_total = 977000
 # Results $table_errors        = 3
 # Results $error_rows          = many
end # of step.

Then(/^the total balance matches the sum of the values/) do
  # Now simply compare that running total from the step above,
  # with the total from the table total.

  # First Check that they are equal- because that is pretty important.
  if $total_balance_text.eql? @running_table_total
    # Then if they are equal(In the current example they are not, so it will fail)
    # Lets pretend it works.
    # If there was no issues, and the calculation was correct and there were no errors,
    # Pass the test.
    $TestResults.push('pass') # This one won't pass... sad.
  else
    # If they are not equal - fail the test.
    $TestResults.push('fail')
  end
end

Then(/^the total balance is correct based on the values listed/) do
  # Check to see if there were any table errors.
  # Which there were, so the total we got was
  # not acutally the correct table evaluation. Also fails the test.
  # We did most of the leg work for this test in a previous step.
  if $table_errors > 0
    $TestResults.push('fail')
    puts "The table had errors in the following rows:"
    pp   $error_rows # This will give us a nicely formatted console.
  else
    $TestResults.push('fail')
  end
end

Then(/^I should find that they are all currencies/) do
  # Check the currency array for any failed rows. fail if you find one.
  should_fail = false
  @is_currency.each do |row|
    if not row # Row is a trueClass, so if it is false, fail the test.
      $TestResults.push('fail')
      should_fail = true
      return 'There was a failure in the currency array! Fail the test.'
    end
  end

  # If you didn't feel the need to fail any rows, Pass the test.
  unless should_fail
    $TestResults.push('fail')
  end
end

And(/^I check each text value row in the table/) do
  # For reference.
  # p $lbl_val_pairs[i] # example of first index [[0]'lbl_val_1',[1]'Value 1']
  # p $txt_val_pairs[i] # example of first index [[0]'txt_val_1',[1]'$122,365.24']

  # For this test we are going to do some strage format checking type things,
  # it may be my utter lack of disipline- but I think we can totally do what we
  # are trying to do with some string manipulation.
  is_dollar = false
  is_decimal_2 = false
  @is_currency = []
  $txt_val_pairs.each do |pair|
    # see if it has a $ at the start.
    is_dollar = true if pair[1].starts_with? '$'

    # Then see if there are only two numbers after the .
    temp_check_for_rounding = pair[1].split('.')
    is_decimal_2 = true if (temp_check_for_rounding[1].count == 2) # paratheses are optional I believe.

    # I'm sure there are other ways to check for currency-
    # this one is pretty bare bones, but so is the table... so I think we will be okay for now.
    if is_dollar && is_decimal_2
      is_currency.push(true)
    else
      is_currency.push(false)
    end
  end
end
