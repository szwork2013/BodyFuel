angular.module('shirts_service', ['ngResource'])
.factory 'Shirt', ($resource) ->
  $resource '/admin/products/shirts/:id', { id: '@id' },
    update: { method: 'PUT', params: {} },
    save: { method: 'POST', params: {} }
.factory 'Color', ($resource) ->
  $resource '/admin/colors/:id', { id: '@id' },
    save: { method: 'POST', params: {} }
.factory 'Size', ($resource) ->
  $resource '/admin/sizes/:id', { id: '@id' },
    save: { method: 'POST', params: {} }