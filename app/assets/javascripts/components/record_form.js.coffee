# This component will handle the creation of new records
@RecordForm = React.createClass
  # this component will also have it's own state to store title, date and amount
  getInitialState: ->
    title: ''
    date: ''
    amount: ''
  # handler method called on keystroke
  # this handler will use the name attribute to detect the input triggered and update the state value
  handleChange: (e) ->
    name = e.target.name
    # @setState will perform 2 actions: update component, schedule a UI verification/refresh based on the new state
    @setState "#{ name }": e.target.value
  # handle validation
  valid: ->
    @state.title && @state.date && @state.amount
    # this component sends data back to the parent component through @props.handleNewRecord to notify about the
    # existence of a new record
  handleSubmit: (e) ->
    # Prevent the form's HTTP submit
    e.preventDefault()
    # post the new record information to the current URL
    # success callback
    $.post '', { record: @state }, (data) =>
      @props.handleNewRecord data
      @setState @getInitialState(),
      'JSON'
  render: ->
    React.DOM.form
      className: 'form-inline'
      onSubmit: @handleSubmit
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          className: 'form-control'
          placeholder: 'Date'
          name: 'date'
          # sets inputs value
          value: @state.date
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          className: 'form-control'
          placeholder: 'Title'
          name: 'title'
          value: @state.title
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'number'
          className: 'form-control'
          placeholder: 'Amount'
          name: 'amount'
          value: @state.amount
          onChange: @handleChange
      React.DOM.button
        type: 'submit'
        className: 'btn btn-primary'
        # the !@valid() will detect if the post is valid based on our validation method
        # true if valid, false if not valid
        disabled: !@valid()
        'Create record'
