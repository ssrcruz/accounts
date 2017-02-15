# this will format amount to a string and make it accessible to all coffee files
@amountFormat = (amount) ->
  '$' + Number(amount).toLocaleString()
