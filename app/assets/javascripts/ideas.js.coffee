ready = ->
  $('button.add-asset').click (event)->
    event.preventDefault()
    data_target = $(this).data('target')
    console.log(data_target)
    $(data_target).append($(this).data('element-to-add').replace(/&quot;/g,'"'))
  $('div.upload-rows').on 'click', 'button.remove-asset', (event)->
    event.preventDefault()
    data_target = $(this).data('target')
    $(this).parents(data_target).remove()
  $('div.upload-rows').on 'click', 'button.remove-existing-asset', (event)->
    event.preventDefault()
    data_target_selector= $(this).data('target')
    data_target=$(this).parents(data_target_selector)
    data_target.hide()
    set_to_true_target_selector=$(this).data('set-to-true-target')
    set_to_true_target=data_target.children(set_to_true_target_selector)
    set_to_true_target.val('true')
  $('div.upload-rows').on 'change', '.btn.file input[type="file"]', (event)->
    input = $(this)
    numFiles = if input.get(0).files then input.get(0).files.length else 1
    label = input.val().replace(/\\/g, '/').replace(/.*\//, '')
    input.trigger('fileselect', [numFiles, label])
  $('div.upload-rows').on 'fileselect', '.btn.file :file', (event, numFiles, label)->
    input = $(this).parents('.input-group').find('.form-control')
    log = if numFiles > 1 then numFiles + ' files selected' else label
    input.val(log)

$(document).ready(ready)
$(document).on('page:load',ready)