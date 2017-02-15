# Records component
@Records = React.createClass
  # generate the initial state of the component
  getInitialState: ->
    records: @props.data
  # will intitiate the components properties
  getDefaultProps: ->
    records: []
  # adds new record and updates state with the newly created record
  addRecord: (record) ->
    records = React.addons.update(@state.records, { $push: [record] })
    @setState records: records

  # updates state with new record version
  updateRecord: (record, data) ->
    index = @state.records.indexOf record
    records = React.addons.update(@state.records, { $splice: [[index, 1, data]] })
    @replaceState records: records

  # deletes record from the state
  # this method copies the current component's records state, performs an index search of the record, splices it
  # from the array and updates the component's state
  deleteRecord: (record) ->
    index = @state.records.indexOf record
    records = React.addons.update(@state.records, { $splice: [[index, 1]] })
    @replaceState records: records
  # calculator methods
  credits: ->
    credits = @state.records.filter (val) -> val.amount >= 0
    credits.reduce ((prev, curr) ->
      prev + parseFloat(curr.amount)
    ), 0
  debits: ->
    debits = @state.records.filter (val) -> val.amount < 0
    debits.reduce ((prev, curr) ->
      prev + parseFloat(curr.amount)
    ), 0
  balance: ->
    @debits() + @credits()
  # will render the component, the component will save in virtual memory
  # when it re-renders, it will optimely render an already saved component

  # this a good example of nesting built-in components with a custom component
  render: ->
    React.DOM.div
      className: 'records'
      React.DOM.h2
        className: 'title'
        'Records'
      # AmountBox elements
      React.DOM.div
        className: 'row'
        React.createElement AmountBox, type: 'success', amount: @credits(), text: 'Credit'
        React.createElement AmountBox, type: 'danger', amount: @debits(), text: 'Debit'
        React.createElement AmountBox, type: 'info', amount: @balance(), text: 'Balance'
      # pass the handleNewRecord property with a method reference into it
      React.createElement RecordForm, handleNewRecord: @addRecord
      React.DOM.hr null
      # this will display a tablerow containing table cells for each record
      # null means we are not sending attributes to the components
      React.DOM.table
        className: 'table table-bordered'
        React.DOM.thead null,
          React.DOM.tr null,
            React.DOM.th null, 'Date'
            React.DOM.th null, 'Title'
            React.DOM.th null, 'Amount'
            React.DOM.th null, 'Actions'
        React.DOM.tbody null,
          # will loop through the State and fetch individual records
          # keys are so React won't have a hard time refreshing the UI
          # not doing so will trigger an error message
          for record in @state.records
            React.createElement Record,
              key: record.id,
              record: record,
              handleDeleteRecord: @deleteRecord,
              handleEditRecord: @updateRecord
