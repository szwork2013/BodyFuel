angular.module('colors_controller', [])
.controller 'ColorsCtrl', ($scope, DataSeed, Color) ->
  DataSeed.then (data) ->
    _.extend $scope, colors: data.colors
    _.extend $scope, data.dependencies

  $scope.is_editing_color = false
  $scope.color_errors = {}

  $scope.save_color = ->
    color = {
      hex_value: $scope.format_color $scope.new_color_value
    }

    $scope.reset_errors()
    $scope.validate()
    if $scope.is_valid()
      Color.save(
        color: color
        authenticity_token: $scope.authenticity_token
      , $scope.success, $scope.error)

  $scope.is_valid = ->
    _.isEmpty $scope.color_errors

  $scope.reset_errors = ->
    $scope.color_errors = {}

  $scope.full_error_messages = ->
    messages = _.reduce $scope.color_errors, ((memo, error) -> memo.push(error); memo), []
    messages.join(',')

  $scope.validate = ->
    $scope.color_errors.hex_value = 'Color is not a valid hex value' unless /^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/.test $scope.format_color($scope.new_color_value)

  $scope.success = (response) ->
    $scope.colors.push response.color
    $scope.is_editing_color = false
    $scope.new_color_value = ''

  $scope.error = (response) ->
    return $scope.color_errors = response.data.errors if response.status == 422
    $scope.color_errors.general = 'There were errors trying to save the color. Please try again'

  $scope.format_color = (hex_value) ->
    "##{hex_value?.replace('#', '').toUpperCase()}"