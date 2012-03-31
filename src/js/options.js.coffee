ENTER_KEY = 13
SAVED_SUCCESS_MESSAGE = "Saved successfully!\n\nReload any open reason.com pages to reflect any changes you've made."
$save     = $("#save")
$add      = $("#add")
$troll    = $("#troll")
bg        = chrome.extension.getBackgroundPage()

# This relies on the implicit sort order in Chrome JS hashes, where items are
# ordered by when they're added to the hash (first in first out)
sortTrolls = (trolls) ->
  # Organizes trolls alphabetically and case-insensitive
  sortFunction = (x, y) ->
    a = x.toUpperCase()
    b = y.toUpperCase()
    if a > b then 1
    else if a < b then -1
    else 0

  black = []
  white = []
  auto  = []
  temp  = {}

  # Categorize trolls based on blacklist/whitelist
  for key, value of trolls
    switch value
      when actions.black.value then black.push key
      when actions.white.value then white.push key
      when actions.auto.value  then auto.push  key

  # Sort lists alphabetically without regard to case
  black.sort sortFunction
  white.sort sortFunction
  auto.sort  sortFunction

  temp[value] = actions.black.value for index, value of black
  temp[value] = actions.white.value for index, value of white
  temp[value] = actions.auto.value  for index, value of auto

  localStorage.trolls = JSON.stringify temp
  temp

buildControll = ($td, key, value, comp) ->
  $td.append "<input id='#{key}_#{comp.value}' type='radio' name='#{key}'#{if value is comp.value then " checked"} value='#{comp.value}'>" +
             "<label for='#{key}_#{comp.value}' class='actions'>#{comp.label}</label>"

buildTroll = (key, value) ->
  $trollConstructor = $("<tr><td class='name'>#{key}</td></tr>")
  $td = $('<td class="actions"></td>')
  $td = buildControll $td, key, value, actions.black
  $td = buildControll $td, key, value, actions.white
  $td = buildControll $td, key, value, actions.auto
  $td = $td.append $('<button class="remove">X</button>').click () -> $(this).closest("tr").remove()
  $trollConstructor.append $td

addTroll = ->
  $("#trolls tbody").append buildTroll $troll.val(), actions.black.value
  $troll.val null
  false

load = ->
  for key of localStorage
    try
      value = JSON.parse localStorage[key]
    catch error
      value = localStorage[key]

    $option = $("##{key}")

    switch $option.attr "id"
      when "trolls"
        trolls = sortTrolls value
      when "name", "sensitivity"
        $option.val value
        $("##{$option.attr "id"}_helper").val value
      else
        $option.prop "checked", value

  $("#trolls").append buildTroll tKey, tValue for tKey, tValue of trolls

  if window.location.hash is "#popup"
    $(".scrollContent").fitToWindow 400
  else
    $(".scrollContent").fitToWindow().keepFitToWindow()

save = () ->
  # Handle checkboxes (generic options)
  for checkbox in $("#options input:checkbox")
    $checkbox = $(checkbox)
    localStorage[$checkbox.attr "id"] = JSON.stringify $checkbox.prop("checked")

  # Handle text and range inputs (name and sensitivity)
  for textbox in $("#options input:text, #options input[type=range]")
    localStorage[textbox.id] = JSON.stringify textbox.value

  # Handle trolls (those buttons are actually heavily styled radio buttons)
  temp = {}
  temp[radio.name] = radio.value for radio in $("input:radio:checked")
  localStorage.trolls = JSON.stringify temp

  # Update settings variable
  bg.parseSettings()

  # Alert user and exit popup or options page
  alert SAVED_SUCCESS_MESSAGE
  bg.location.reload()
  window.close()

  # Prevent form submission
  false

updateHelper = (event) ->
  $target = $(event.target)
  $("##{$target.attr("id")}_helper").val $target.val()

updateRange = (event) ->
  $target = $(event.target)
  $("##{$target.attr("id").replace("_helper", "")}").val $target.val()

attachClickEvents = ->
  $save.click save
  $add.click  addTroll
  $("#options input[type=range]").change(updateHelper)
  $("#options .range_helper").change(updateRange).keyup(updateRange)

$ ->
  load()
  $troll.bind "keydown", (event) ->
    addTroll() if event.which is ENTER_KEY
  attachClickEvents()