
var acf={ajaxurl:'',admin_url:'',wp_version:'',post_id:0,nonce:'',l10n:null,o:null,helpers:{get_atts:null,version_compare:null,uniqid:null,sortable:null,add_message:null,is_clone_field:null,url_to_object:null},validation:null,conditional_logic:null,media:null,fields:{date_picker:null,color_picker:null,Image:null,file:null,wysiwyg:null,gallery:null,relationship:null}};(function($){acf.helpers.isset=function(){var a=arguments,l=a.length,c=null,undef;if(l===0){throw new Error('Empty isset');}
c=a[0];for(i=1;i<l;i++){if(a[i]===undef||c[a[i]]===undef){return false;}
c=c[a[i]];}
return true;};acf.helpers.get_atts=function($el){var atts={};$.each($el[0].attributes,function(index,attr){if(attr.name.substr(0,5)=='data-')
{atts[attr.name.replace('data-','')]=attr.value;}});return atts;};acf.helpers.version_compare=function(left,right)
{if(typeof left+typeof right!='stringstring')
return false;var a=left.split('.'),b=right.split('.'),i=0,len=Math.max(a.length,b.length);for(;i<len;i++){if((a[i]&&!b[i]&&parseInt(a[i])>0)||(parseInt(a[i])>parseInt(b[i]))){return 1;}else if((b[i]&&!a[i]&&parseInt(b[i])>0)||(parseInt(a[i])<parseInt(b[i]))){return-1;}}
return 0;};acf.helpers.uniqid=function()
{var newDate=new Date;return newDate.getTime();};acf.helpers.url_to_object=function(url){var obj={},pairs=url.split('&');for(i in pairs)
{var split=pairs[i].split('=');obj[decodeURIComponent(split[0])]=decodeURIComponent(split[1]);}
return obj;};acf.helpers.sortable=function(e,ui)
{ui.children().each(function(){$(this).width($(this).width());});return ui;};acf.helpers.is_clone_field=function(input)
{if(input.attr('name')&&input.attr('name').indexOf('[acfcloneindex]')!=-1)
{return true;}
return false;};acf.helpers.add_message=function(message,div){var message=$('<div class="acf-message-wrapper"><div class="message updated"><p>'+message+'</p></div></div>');div.prepend(message);setTimeout(function(){message.animate({opacity:0},250,function(){message.remove();});},1500);};$.fn.exists=function()
{return $(this).length>0;};acf.media={div:null,frame:null,render_timout:null,clear_frame:function(){if(!this.frame)
{return;}
this.frame.detach();this.frame.dispose();this.frame=null;},type:function(){var type='thickbox';if(typeof wp!=='undefined')
{type='backbone';}
return type;},init:function(){if(this.type()!=='backbone')
{return false;}
if(!acf.helpers.isset(wp,'media','view','AttachmentCompat','prototype'))
{return false;}
var _prototype=wp.media.view.AttachmentCompat.prototype;_prototype.orig_render=_prototype.render;_prototype.orig_dispose=_prototype.dispose;_prototype.className='compat-item acf_postbox no_box';_prototype.render=function(){var _this=this;if(_this.ignore_render)
{return this;}
this.orig_render();setTimeout(function(){var $media_model=_this.$el.closest('.media-modal');if($media_model.hasClass('acf-media-modal'))
{return;}
if($media_model.find('.media-frame-router .acf-expand-details').exists())
{return;}
var button=$(['<a href="#" class="acf-expand-details">','<span class="icon"></span>','<span class="is-closed">'+acf.l10n.core.expand_details+'</span>','<span class="is-open">'+acf.l10n.core.collapse_details+'</span>','</a>'].join(''));button.on('click',function(e){e.preventDefault();if($media_model.hasClass('acf-expanded'))
{$media_model.removeClass('acf-expanded');}
else
{$media_model.addClass('acf-expanded');}});$media_model.find('.media-frame-router').append(button);},0);clearTimeout(acf.media.render_timout);acf.media.render_timout=setTimeout(function(){$(document).trigger('acf/setup_fields',[_this.$el]);},50);return this;};_prototype.dispose=function(){$(document).trigger('acf/remove_fields',[this.$el]);this.orig_dispose();};_prototype.save=function(event){var data={},names={};if(event)
event.preventDefault();_.each(this.$el.serializeArray(),function(pair){if(pair.name.slice(-2)==='[]')
{pair.name=pair.name.replace('[]','');if(typeof names[pair.name]==='undefined'){names[pair.name]=-1;}
names[pair.name]++
pair.name+='['+names[pair.name]+']';}
data[pair.name]=pair.value;});this.ignore_render=true;this.model.saveCompat(data);};}};acf.conditional_logic={items:[],init:function(){var _this=this;$(document).on('change','.field input, .field textarea, .field select',function(){if($('#acf-has-changed').exists())
{$('#acf-has-changed').val(1);}
_this.change($(this));});$(document).on('acf/setup_fields',function(e,el){_this.refresh($(el));});_this.refresh();},change:function($el){var _this=this;var $field=$el.closest('.field'),key=$field.attr('data-field_key');$.each(this.items,function(k,item){$.each(item.rules,function(k2,rule){if(rule.field==key)
{_this.refresh_field(item);}});});},refresh_field:function(item){var _this=this;var $targets=$('.field_key-'+item.field);$targets.each(function(){var show=true;if(item.allorany=='any')
{show=false;}
var $target=$(this),hide_all=true;$.each(item.rules,function(k2,rule){var $toggle=$('.field_key-'+rule.field);if($toggle.hasClass('sub_field'))
{$toggle=$target.siblings('.field_key-'+rule.field);hide_all=false;if(!$toggle.exists())
{$target.parents('tr').each(function(){$toggle=$(this).find('.field_key-'+rule.field)
if($toggle.exists())
{return false;}});hide_all=true;}}
var parent=$target.parent('tr').parent().parent('table').parent('.layout');if(parent.exists())
{hide_all=true;if($target.is('th')&&$toggle.is('th'))
{$toggle=$target.closest('.layout').find('td.field_key-'+rule.field);}}
var parent=$target.parent('tr').parent().parent('table').parent('.repeater');if(parent.exists()&&parent.attr('data-max_rows')=='1')
{hide_all=true;if($target.is('th')&&$toggle.is('th'))
{$toggle=$target.closest('table').find('td.field_key-'+rule.field);}}
var calculate=_this.calculate(rule,$toggle,$target);if(item.allorany=='all')
{if(calculate==false)
{show=false;return false;}}
else
{if(calculate==true)
{show=true;return false;}}});$target.removeClass('acf-conditional_logic-hide acf-conditional_logic-show acf-show-blank');if(show)
{$target.find('input, textarea, select').removeAttr('disabled');$target.addClass('acf-conditional_logic-show');$(document).trigger('acf/conditional_logic/show',[$target,item]);}
else
{$target.find('input, textarea, select').attr('disabled','disabled');$target.addClass('acf-conditional_logic-hide');if(!hide_all)
{$target.addClass('acf-show-blank');}
$(document).trigger('acf/conditional_logic/hide',[$target,item]);}});},refresh:function($el){$el=$el||$('body');var _this=this;$.each(this.items,function(k,item){$.each(item.rules,function(k2,rule){if(!$el.find('.field[data-field_key="'+item.field+'"]').exists())
{return;}
_this.refresh_field(item);});});},calculate:function(rule,$toggle,$target){var r=false;if($toggle.hasClass('field_type-true_false')||$toggle.hasClass('field_type-checkbox')||$toggle.hasClass('field_type-radio'))
{var exists=$toggle.find('input[value="'+rule.value+'"]:checked').exists();if(rule.operator=="==")
{if(exists)
{r=true;}}
else
{if(!exists)
{r=true;}}}
else
{var val=$toggle.find('input, textarea, select').last().val();if(!$.isArray(val))
{val=[val];}
if(rule.operator=="==")
{if($.inArray(rule.value,val)>-1)
{r=true;}}
else
{if($.inArray(rule.value,val)<0)
{r=true;}}}
return r;}};$(document).ready(function(){acf.conditional_logic.init();$('.acf_postbox > .inside > .options').each(function(){$(this).closest('.acf_postbox').addClass($(this).attr('data-layout'));});$('#metakeyselect option[value^="field_"]').remove();});$(window).load(function(){acf.media.init();setTimeout(function(){try
{if($.isNumeric(acf.o.post_id))
{wp.media.view.settings.post.id=acf.o.post_id;}}
catch(e)
{}
$(document).trigger('acf/setup_fields',[$('#poststuff')]);},10);});acf.fields.gallery={add:function(){},edit:function(){},update_count:function(){},hide_selected_items:function(){},text:{title_add:"Select Images"}};})(jQuery);(function($){acf.screen={action:'acf/location/match_field_groups_ajax',post_id:0,page_template:0,page_parent:0,page_type:0,post_category:0,post_format:0,taxonomy:0,lang:0,nonce:0};$(document).ready(function(){acf.screen.post_id=acf.o.post_id;acf.screen.nonce=acf.o.nonce;if($('#icl-als-first').length>0)
{var href=$('#icl-als-first').children('a').attr('href'),regex=new RegExp("lang=([^&#]*)"),results=regex.exec(href);acf.screen.lang=results[1];}});$(document).on('acf/update_field_groups',function(){if(!acf.screen.post_id||!$.isNumeric(acf.screen.post_id))
{return false;}
$.ajax({url:ajaxurl,data:acf.screen,type:'post',dataType:'json',success:function(result){if(!result)
{return false;}
$('.acf_postbox').addClass('acf-hidden');$('.acf_postbox-toggle').addClass('acf-hidden');if(result.length==0)
{return false;}
$.each(result,function(k,v){var $el=$('#acf_'+v),$toggle=$('#adv-settings .acf_postbox-toggle[for="acf_'+v+'-hide"]');$el.removeClass('acf-hidden hide-if-js');$toggle.removeClass('acf-hidden');$toggle.find('input[type="checkbox"]').attr('checked','checked');$el.find('.acf-replace-with-fields').each(function(){var $replace=$(this);$.ajax({url:ajaxurl,data:{action:'acf/post/render_fields',acf_id:v,post_id:acf.o.post_id,nonce:acf.o.nonce},type:'post',dataType:'html',success:function(html){$replace.replaceWith(html);$(document).trigger('acf/setup_fields',$el);}});});});$.ajax({url:ajaxurl,data:{action:'acf/post/get_style',acf_id:result[0],nonce:acf.o.nonce},type:'post',dataType:'html',success:function(result){$('#acf_style').html(result);}});}});});$(document).on('change','#page_template',function(){acf.screen.page_template=$(this).val();$(document).trigger('acf/update_field_groups');});$(document).on('change','#parent_id',function(){var val=$(this).val();if(val!="")
{acf.screen.page_type='child';acf.screen.page_parent=val;}
else
{acf.screen.page_type='parent';acf.screen.page_parent=0;}
$(document).trigger('acf/update_field_groups');});$(document).on('change','#post-formats-select input[type="radio"]',function(){var val=$(this).val();if(val=='0')
{val='standard';}
acf.screen.post_format=val;$(document).trigger('acf/update_field_groups');});function _sync_taxonomy_terms(){var values=[];$('.categorychecklist input:checked, .acf-taxonomy-field input:checked, .acf-taxonomy-field option:selected').each(function(){if($(this).is(':hidden')||$(this).is(':disabled'))
{return;}
if($(this).closest('.media-frame').exists())
{return;}
if($(this).closest('.acf-taxonomy-field').exists())
{if($(this).closest('.acf-taxonomy-field').attr('data-save')=='0')
{return;}}
if(values.indexOf($(this).val())===-1)
{values.push($(this).val());}});acf.screen.post_category=values;acf.screen.taxonomy=values;$(document).trigger('acf/update_field_groups');}
$(document).on('change','.categorychecklist input, .acf-taxonomy-field input, .acf-taxonomy-field select',function(){if($(this).closest('.acf-taxonomy-field').exists())
{if($(this).closest('.acf-taxonomy-field').attr('data-save')=='0')
{return;}}
if($(this).closest('.media-frame').exists())
{return;}
setTimeout(function(){_sync_taxonomy_terms();},1);});})(jQuery);(function($){var _cp=acf.fields.color_picker={$el:null,$input:null,set:function(o){$.extend(this,o);this.$input=this.$el.find('input[type="text"]');return this;},init:function(){var $input=this.$input;if(acf.helpers.is_clone_field($input))
{return;}
this.$input.wpColorPicker();}};$(document).on('acf/setup_fields',function(e,el){$(el).find('.acf-color_picker').each(function(){_cp.set({$el:$(this)}).init();});});})(jQuery);(function($){acf.fields.date_picker={$el:null,$input:null,$hidden:null,o:{},set:function(o){$.extend(this,o);this.$input=this.$el.find('input[type="text"]');this.$hidden=this.$el.find('input[type="hidden"]');this.o=acf.helpers.get_atts(this.$el);return this;},init:function(){if(acf.helpers.is_clone_field(this.$hidden))
{return;}
this.$input.val(this.$hidden.val());var options=$.extend({},acf.l10n.date_picker,{dateFormat:this.o.save_format,altField:this.$hidden,altFormat:this.o.save_format,changeYear:true,yearRange:"-100:+100",changeMonth:true,showButtonPanel:true,firstDay:this.o.first_day});this.$input.addClass('active').datepicker(options);this.$input.datepicker("option","dateFormat",this.o.display_format);if($('body > #ui-datepicker-div').length>0)
{$('#ui-datepicker-div').wrap('<div class="ui-acf" />');}},blur:function(){if(!this.$input.val())
{this.$hidden.val('');}}};$(document).on('acf/setup_fields',function(e,el){$(el).find('.acf-date_picker').each(function(){acf.fields.date_picker.set({$el:$(this)}).init();});});$(document).on('blur','.acf-date_picker input[type="text"]',function(e){acf.fields.date_picker.set({$el:$(this).parent()}).blur();});})(jQuery);(function($){var _media=acf.media;acf.fields.file={$el:null,$input:null,o:{},set:function(o){$.extend(this,o);this.$input=this.$el.find('input[type="hidden"]');this.o=acf.helpers.get_atts(this.$el);this.o.multiple=this.$el.closest('.repeater').exists()?true:false;this.o.query={};if(this.o.library=='uploadedTo')
{this.o.query.uploadedTo=acf.o.post_id;}
return this;},init:function(){if(acf.helpers.is_clone_field(this.$input))
{return;}},add:function(file){var div=_media.div;div.find('.acf-file-icon').attr('src',file.icon);div.find('.acf-file-title').text(file.title);div.find('.acf-file-name').text(file.name).attr('href',file.url);div.find('.acf-file-size').text(file.size);div.find('.acf-file-value').val(file.id).trigger('change');div.addClass('active');div.closest('.field').removeClass('error');},edit:function(){var id=this.$input.val();_media.div=this.$el;_media.clear_frame();_media.frame=wp.media({title:acf.l10n.file.edit,multiple:false,button:{text:acf.l10n.file.update}});_media.frame.on('open',function(){if(_media.frame.content._mode!='browse')
{_media.frame.content.mode('browse');}
_media.frame.$el.closest('.media-modal').addClass('acf-media-modal acf-expanded');var selection=_media.frame.state().get('selection'),attachment=wp.media.attachment(id);if($.isEmptyObject(attachment.changed))
{attachment.fetch();}
selection.add(attachment);});_media.frame.on('close',function(){_media.frame.$el.closest('.media-modal').removeClass('acf-media-modal');});acf.media.frame.open();},remove:function()
{this.$el.find('.acf-file-icon').attr('src','');this.$el.find('.acf-file-title').text('');this.$el.find('.acf-file-name').text('').attr('href','');this.$el.find('.acf-file-size').text('');this.$el.find('.acf-file-value').val('').trigger('change');this.$el.removeClass('active');},popup:function()
{var t=this;_media.div=this.$el;_media.clear_frame();_media.frame=wp.media({states:[new wp.media.controller.Library({library:wp.media.query(t.o.query),multiple:t.o.multiple,title:acf.l10n.file.select,priority:20,filterable:'all'})]});acf.media.frame.on('content:activate',function(){var toolbar=null,filters=null;try
{toolbar=acf.media.frame.content.get().toolbar;filters=toolbar.get('filters');}
catch(e)
{}
if(!filters)
{return false;}
if(t.o.library=='uploadedTo')
{filters.$el.find('option[value="uploaded"]').remove();filters.$el.after('<span>'+acf.l10n.file.uploadedTo+'</span>')
$.each(filters.filters,function(k,v){v.props.uploadedTo=acf.o.post_id;});}});acf.media.frame.on('select',function(){selection=_media.frame.state().get('selection');if(selection)
{var i=0;selection.each(function(attachment){i++;if(i>1)
{var $td=_media.div.closest('td'),$tr=$td.closest('.row'),$repeater=$tr.closest('.repeater'),key=$td.attr('data-field_key'),selector='td .acf-file-uploader:first';if(key)
{selector='td[data-field_key="'+key+'"] .acf-file-uploader';}
if(!$tr.next('.row').exists())
{$repeater.find('.add-row-end').trigger('click');}
_media.div=$tr.next('.row').find(selector);}
var file={id:attachment.id,title:attachment.attributes.title,name:attachment.attributes.filename,url:attachment.attributes.url,icon:attachment.attributes.icon,size:attachment.attributes.filesize};acf.fields.file.add(file);});}});acf.media.frame.open();return false;}};$(document).on('click','.acf-file-uploader .acf-button-edit',function(e){e.preventDefault();acf.fields.file.set({$el:$(this).closest('.acf-file-uploader')}).edit();});$(document).on('click','.acf-file-uploader .acf-button-delete',function(e){e.preventDefault();acf.fields.file.set({$el:$(this).closest('.acf-file-uploader')}).remove();});$(document).on('click','.acf-file-uploader .add-file',function(e){e.preventDefault();acf.fields.file.set({$el:$(this).closest('.acf-file-uploader')}).popup();});})(jQuery);(function($){acf.fields.google_map={$el:null,$input:null,o:{},ready:false,geocoder:false,map:false,maps:{},set:function(o){$.extend(this,o);this.$input=this.$el.find('.value');this.o=acf.helpers.get_atts(this.$el);if(this.maps[this.o.id])
{this.map=this.maps[this.o.id];}
return this;},init:function(){if(!this.geocoder)
{this.geocoder=new google.maps.Geocoder();}
this.ready=true;if(acf.helpers.is_clone_field(this.$input))
{return;}
this.render();},render:function(){var _this=this,_$el=this.$el;var args={zoom:parseInt(this.o.zoom),center:new google.maps.LatLng(this.o.lat,this.o.lng),mapTypeId:google.maps.MapTypeId.ROADMAP};this.map=new google.maps.Map(this.$el.find('.canvas')[0],args);var autocomplete=new google.maps.places.Autocomplete(this.$el.find('.search')[0]);autocomplete.map=this.map;autocomplete.bindTo('bounds',this.map);this.map.marker=new google.maps.Marker({draggable:true,raiseOnDrag:true,map:this.map,});this.map.$el=this.$el;var lat=this.$el.find('.input-lat').val(),lng=this.$el.find('.input-lng').val();if(lat&&lng)
{this.update(lat,lng).center();}
google.maps.event.addListener(autocomplete,'place_changed',function(e){var $el=this.map.$el;var address=$el.find('.search').val();$el.find('.input-address').val(address);$el.find('.title h4').text(address);var place=this.getPlace();if(place.geometry)
{var lat=place.geometry.location.lat(),lng=place.geometry.location.lng();_this.set({$el:$el}).update(lat,lng).center();}
else
{_this.geocoder.geocode({'address':address},function(results,status){if(status!=google.maps.GeocoderStatus.OK)
{console.log('Geocoder failed due to: '+status);return;}
if(!results[0])
{console.log('No results found');return;}
place=results[0];var lat=place.geometry.location.lat(),lng=place.geometry.location.lng();_this.set({$el:$el}).update(lat,lng).center();});}});google.maps.event.addListener(this.map.marker,'dragend',function(){var $el=this.map.$el;var position=this.map.marker.getPosition(),lat=position.lat(),lng=position.lng();_this.set({$el:$el}).update(lat,lng).sync();});google.maps.event.addListener(this.map,'click',function(e){var $el=this.$el;var lat=e.latLng.lat(),lng=e.latLng.lng();_this.set({$el:$el}).update(lat,lng).sync();});this.maps[this.o.id]=this.map;},update:function(lat,lng){var latlng=new google.maps.LatLng(lat,lng);this.$el.find('.input-lat').val(lat);this.$el.find('.input-lng').val(lng).trigger('change');this.map.marker.setPosition(latlng);this.map.marker.setVisible(true);this.$el.addClass('active');this.$el.closest('.field').removeClass('error');return this;},center:function(){var position=this.map.marker.getPosition(),lat=this.o.lat,lng=this.o.lng;if(position)
{lat=position.lat();lng=position.lng();}
var latlng=new google.maps.LatLng(lat,lng);this.map.setCenter(latlng);},sync:function(){var $el=this.$el;var position=this.map.marker.getPosition(),latlng=new google.maps.LatLng(position.lat(),position.lng());this.geocoder.geocode({'latLng':latlng},function(results,status){if(status!=google.maps.GeocoderStatus.OK)
{console.log('Geocoder failed due to: '+status);return;}
if(!results[0])
{console.log('No results found');return;}
var location=results[0];$el.find('.title h4').text(location.formatted_address);$el.find('.input-address').val(location.formatted_address).trigger('change');});return this;},locate:function(){var _this=this,_$el=this.$el;if(!navigator.geolocation)
{alert(acf.l10n.google_map.browser_support);return this;}
_$el.find('.title h4').text(acf.l10n.google_map.locating+'...');_$el.addClass('active');navigator.geolocation.getCurrentPosition(function(position){var lat=position.coords.latitude,lng=position.coords.longitude;_this.set({$el:_$el}).update(lat,lng).sync().center();});},clear:function(){this.$el.removeClass('active');this.$el.find('.search').val('');this.$el.find('.input-address').val('');this.$el.find('.input-lat').val('');this.$el.find('.input-lng').val('');this.map.marker.setVisible(false);},edit:function(){this.$el.removeClass('active');var val=this.$el.find('.title h4').text();this.$el.find('.search').val(val).focus();},refresh:function(){google.maps.event.trigger(this.map,'resize');this.center();}};$(document).on('acf/setup_fields',function(e,el){$fields=$(el).find('.acf-google-map');if(!$fields.exists())
{return;}
if(typeof google==='undefined')
{$.getScript('https://www.google.com/jsapi',function(){google.load('maps','3',{other_params:'sensor=false&libraries=places',callback:function(){$fields.each(function(){acf.fields.google_map.set({$el:$(this)}).init();});}});});}
else
{google.load('maps','3',{other_params:'sensor=false&libraries=places',callback:function(){$fields.each(function(){acf.fields.google_map.set({$el:$(this)}).init();});}});}});$(document).on('click','.acf-google-map .acf-sprite-remove',function(e){e.preventDefault();acf.fields.google_map.set({$el:$(this).closest('.acf-google-map')}).clear();$(this).blur();});$(document).on('click','.acf-google-map .acf-sprite-locate',function(e){e.preventDefault();acf.fields.google_map.set({$el:$(this).closest('.acf-google-map')}).locate();$(this).blur();});$(document).on('click','.acf-google-map .title h4',function(e){e.preventDefault();acf.fields.google_map.set({$el:$(this).closest('.acf-google-map')}).edit();});$(document).on('keydown','.acf-google-map .search',function(e){if(e.which==13)
{return false;}});$(document).on('blur','.acf-google-map .search',function(e){var $el=$(this).closest('.acf-google-map');if($el.find('.input-lat').val())
{$el.addClass('active');}});$(document).on('acf/fields/tab/show acf/conditional_logic/show',function(e,$field){if(!acf.fields.google_map.ready)
{return;}
if($field.attr('data-field_type')=='google_map')
{acf.fields.google_map.set({$el:$field.find('.acf-google-map')}).refresh();}});})(jQuery);(function($){var _media=acf.media;acf.fields.image={$el:null,$input:null,o:{},set:function(o){$.extend(this,o);this.$input=this.$el.find('input[type="hidden"]');this.o=acf.helpers.get_atts(this.$el);this.o.multiple=this.$el.closest('.repeater').exists()?true:false;this.o.query={type:'image'};if(this.o.library=='uploadedTo')
{this.o.query.uploadedTo=acf.o.post_id;}
return this;},init:function(){if(acf.helpers.is_clone_field(this.$input))
{return;}},add:function(image){var div=_media.div;div.find('.acf-image-image').attr('src',image.url);div.find('.acf-image-value').val(image.id).trigger('change');div.addClass('active');div.closest('.field').removeClass('error');},edit:function(){var id=this.$input.val();_media.div=this.$el;_media.clear_frame();_media.frame=wp.media({title:acf.l10n.image.edit,multiple:false,button:{text:acf.l10n.image.update}});_media.frame.on('open',function(){if(_media.frame.content._mode!='browse')
{_media.frame.content.mode('browse');}
_media.frame.$el.closest('.media-modal').addClass('acf-media-modal acf-expanded');var selection=_media.frame.state().get('selection'),attachment=wp.media.attachment(id);if($.isEmptyObject(attachment.changed))
{attachment.fetch();}
selection.add(attachment);});_media.frame.on('close',function(){_media.frame.$el.closest('.media-modal').removeClass('acf-media-modal');});acf.media.frame.open();},remove:function()
{this.$el.find('.acf-image-image').attr('src','');this.$el.find('.acf-image-value').val('').trigger('change');this.$el.removeClass('active');},popup:function()
{var t=this;_media.div=this.$el;_media.clear_frame();_media.frame=wp.media({states:[new wp.media.controller.Library({library:wp.media.query(t.o.query),multiple:t.o.multiple,title:acf.l10n.image.select,priority:20,filterable:'all'})]});acf.media.frame.on('content:activate',function(){var toolbar=null,filters=null;try
{toolbar=acf.media.frame.content.get().toolbar;filters=toolbar.get('filters');}
catch(e)
{}
if(!filters)
{return false;}
$.each(filters.filters,function(k,v){v.props.type='image';});if(t.o.library=='uploadedTo')
{filters.$el.find('option[value="uploaded"]').remove();filters.$el.after('<span>'+acf.l10n.image.uploadedTo+'</span>')
$.each(filters.filters,function(k,v){v.props.uploadedTo=acf.o.post_id;});}
filters.$el.find('option').each(function(){var v=$(this).attr('value');if(v=='uploaded'&&t.o.library=='all')
{return;}
if(v.indexOf('image')===-1)
{$(this).remove();}});filters.$el.val('image').trigger('change');});acf.media.frame.on('select',function(){selection=_media.frame.state().get('selection');if(selection)
{var i=0;selection.each(function(attachment){i++;if(i>1)
{var $td=_media.div.closest('td'),$tr=$td.closest('.row'),$repeater=$tr.closest('.repeater'),key=$td.attr('data-field_key'),selector='td .acf-image-uploader:first';if(key)
{selector='td[data-field_key="'+key+'"] .acf-image-uploader';}
if(!$tr.next('.row').exists())
{$repeater.find('.add-row-end').trigger('click');}
_media.div=$tr.next('.row').find(selector);}
var image={id:attachment.id,url:attachment.attributes.url};if(attachment.attributes.sizes&&attachment.attributes.sizes[t.o.preview_size])
{image.url=attachment.attributes.sizes[t.o.preview_size].url;}
acf.fields.image.add(image);});}});acf.media.frame.open();return false;},text:{title_add:"Select Image",title_edit:"Edit Image"}};$(document).on('click','.acf-image-uploader .acf-button-edit',function(e){e.preventDefault();acf.fields.image.set({$el:$(this).closest('.acf-image-uploader')}).edit();});$(document).on('click','.acf-image-uploader .acf-button-delete',function(e){e.preventDefault();acf.fields.image.set({$el:$(this).closest('.acf-image-uploader')}).remove();});$(document).on('click','.acf-image-uploader .add-image',function(e){e.preventDefault();acf.fields.image.set({$el:$(this).closest('.acf-image-uploader')}).popup();});})(jQuery);(function($){acf.fields.radio={$el:null,$input:null,$other:null,farbtastic:null,set:function(o){$.extend(this,o);this.$input=this.$el.find('input[type="radio"]:checked');this.$other=this.$el.find('input[type="text"]');return this;},change:function(){if(this.$input.val()=='other')
{this.$other.attr('name',this.$input.attr('name'));this.$other.show();}
else
{this.$other.attr('name','');this.$other.hide();}}};$(document).on('change','.acf-radio-list input[type="radio"]',function(e){acf.fields.radio.set({$el:$(this).closest('.acf-radio-list')}).change();});})(jQuery);(function($){acf.fields.relationship={$el:null,$input:null,$left:null,$right:null,o:{},timeout:null,set:function(o){$.extend(this,o);this.$input=this.$el.children('input[type="hidden"]');this.$left=this.$el.find('.relationship_left'),this.$right=this.$el.find('.relationship_right');this.o=acf.helpers.get_atts(this.$el);return this;},init:function(){var _this=this;if(acf.helpers.is_clone_field(this.$input))
{return;}
this.$right.find('.relationship_list').height(this.$left.height()-2);this.$right.find('.relationship_list').sortable({axis:'y',items:'> li',forceHelperSize:true,forcePlaceholderSize:true,scroll:true,update:function(){_this.$input.trigger('change');}});var $el=this.$el;this.$left.find('.relationship_list').scrollTop(0).on('scroll',function(e){if($el.hasClass('loading')||$el.hasClass('no-results'))
{return;}
if($(this).scrollTop()+$(this).innerHeight()>=$(this).get(0).scrollHeight)
{var paged=parseInt($el.attr('data-paged'));$el.attr('data-paged',(paged+1));_this.set({$el:$el}).fetch();}});this.fetch();},fetch:function(){var _this=this,$el=this.$el;$el.addClass('loading');$.ajax({url:acf.o.ajaxurl,type:'post',dataType:'json',data:$.extend({action:'acf/fields/relationship/query_posts',post_id:acf.o.post_id,nonce:acf.o.nonce},this.o),success:function(json){_this.set({$el:$el}).render(json);}});},render:function(json){var _this=this;this.$el.removeClass('no-results').removeClass('loading');if(this.o.paged==1)
{this.$el.find('.relationship_left li:not(.load-more)').remove();}
if(!json||!json.html)
{this.$el.addClass('no-results');return;}
this.$el.find('.relationship_left .load-more').before(json.html);if(!json.next_page_exists)
{this.$el.addClass('no-results');}
this.$left.find('a').each(function(){var id=$(this).attr('data-post_id');if(_this.$right.find('a[data-post_id="'+id+'"]').exists())
{$(this).parent().addClass('hide');}});},add:function($a){var id=$a.attr('data-post_id'),title=$a.html();if(this.$right.find('a').length>=this.o.max)
{alert(acf.l10n.relationship.max.replace('{max}',this.o.max));return false;}
if($a.parent().hasClass('hide'))
{return false;}
$a.parent().addClass('hide');var data={post_id:$a.attr('data-post_id'),title:$a.html(),name:this.$input.attr('name')},tmpl=_.template(acf.l10n.relationship.tmpl_li,data);this.$right.find('.relationship_list').append(tmpl)
this.$input.trigger('change');this.$el.closest('.field').removeClass('error');},remove:function($a){$a.parent().remove();this.$left.find('a[data-post_id="'+$a.attr('data-post_id')+'"]').parent('li').removeClass('hide');this.$input.trigger('change');}};$(document).on('acf/setup_fields',function(e,el){$(el).find('.acf_relationship').each(function(){acf.fields.relationship.set({$el:$(this)}).init();});});$(document).on('change','.acf_relationship .select-post_type',function(e){var val=$(this).val(),$el=$(this).closest('.acf_relationship');$el.attr('data-post_type',val);$el.attr('data-paged',1);acf.fields.relationship.set({$el:$el}).fetch();});$(document).on('click','.acf_relationship .relationship_left .relationship_list a',function(e){e.preventDefault();acf.fields.relationship.set({$el:$(this).closest('.acf_relationship')}).add($(this));$(this).blur();});$(document).on('click','.acf_relationship .relationship_right .relationship_list a',function(e){e.preventDefault();acf.fields.relationship.set({$el:$(this).closest('.acf_relationship')}).remove($(this));$(this).blur();});$(document).on('keyup','.acf_relationship input.relationship_search',function(e){var val=$(this).val(),$el=$(this).closest('.acf_relationship');$el.attr('data-s',val);$el.attr('data-paged',1);clearTimeout(acf.fields.relationship.timeout);acf.fields.relationship.timeout=setTimeout(function(){acf.fields.relationship.set({$el:$el}).fetch();},500);});$(document).on('keypress','.acf_relationship input.relationship_search',function(e){if(e.which==13)
{e.preventDefault();}});})(jQuery);(function($){acf.fields.tab={add_group:function($wrap){var html='';if($wrap.is('tbody'))
{html='<tr class="acf-tab-wrap"><td colspan="2"><ul class="hl clearfix acf-tab-group"></ul></td></tr>';}
else
{html='<div class="acf-tab-wrap"><ul class="hl clearfix acf-tab-group"></ul></div>';}
$wrap.children('.field_type-tab:first').before(html);},add_tab:function($tab){var $field=$tab.closest('.field'),$wrap=$field.parent(),key=$field.attr('data-field_key'),label=$tab.text();if(!$wrap.children('.acf-tab-wrap').exists())
{this.add_group($wrap);}
$wrap.children('.acf-tab-wrap').find('.acf-tab-group').append('<li><a class="acf-tab-button" href="#" data-key="'+key+'">'+label+'</a></li>');},toggle:function($a){var _this=this;var $wrap=$a.closest('.acf-tab-wrap').parent(),key=$a.attr('data-key');$a.parent('li').addClass('active').siblings('li').removeClass('active');$wrap.children('.field_type-tab').each(function(){var $tab=$(this);if($tab.attr('data-field_key')==key)
{_this.show_tab_fields($(this));}
else
{_this.hide_tab_fields($(this));}});},show_tab_fields:function($field){$field.nextUntil('.field_type-tab').each(function(){$(this).removeClass('acf-tab_group-hide').addClass('acf-tab_group-show');$(document).trigger('acf/fields/tab/show',[$(this)]);});},hide_tab_fields:function($field){$field.nextUntil('.field_type-tab').each(function(){$(this).removeClass('acf-tab_group-show').addClass('acf-tab_group-hide');$(document).trigger('acf/fields/tab/hide',[$(this)]);});},refresh:function($el){var _this=this;$el.find('.acf-tab-group').each(function(){$(this).find('.acf-tab-button:first').each(function(){_this.toggle($(this));});});}};$(document).on('acf/setup_fields',function(e,el){$(el).find('.acf-tab').each(function(){acf.fields.tab.add_tab($(this));});acf.fields.tab.refresh($(el));});$(document).on('click','.acf-tab-button',function(e){e.preventDefault();acf.fields.tab.toggle($(this));$(this).trigger('blur');});$(document).on('acf/conditional_logic/hide',function(e,$target,item){if($target.attr('data-field_type')!='tab')
{return;}
var $tab=$target.siblings('.acf-tab-wrap').find('a[data-key="'+$target.attr('data-field_key')+'"]');if($tab.is(':hidden'))
{return;}
$tab.parent().hide();if($tab.parent().siblings(':visible').exists())
{$tab.parent().siblings(':visible').first().children('a').trigger('click');}
else
{acf.fields.tab.hide_tab_fields($target);}});$(document).on('acf/conditional_logic/show',function(e,$target,item){if($target.attr('data-field_type')!='tab')
{return;}
var $tab=$target.siblings('.acf-tab-wrap').find('a[data-key="'+$target.attr('data-field_key')+'"]');if($tab.is(':visible'))
{return;}
$tab.parent().show();if($tab.parent().hasClass('active'))
{$tab.trigger('click');return;}
if($tab.parent().siblings('.active').is(':hidden'))
{$tab.trigger('click');return;}});})(jQuery);(function($){acf.validation={status:true,disabled:false,run:function(){var _this=this;_this.status=true;$('.field.required, .form-field.required').each(function(){_this.validate($(this));});},validate:function(div){var ignore=false,$tab=null;div.data('validation',true);if(div.is(':hidden'))
{ignore=true;if(div.hasClass('acf-tab_group-hide'))
{ignore=false;var $tab_field=div.prevAll('.field_type-tab:first'),$tab_group=div.prevAll('.acf-tab-wrap:first');if($tab_field.hasClass('acf-conditional_logic-hide'))
{ignore=true;}
else
{$tab=$tab_group.find('.acf-tab-button[data-key="'+$tab_field.attr('data-field_key')+'"]');}}}
if(div.hasClass('acf-conditional_logic-hide'))
{ignore=true;}
if(div.closest('.postbox.acf-hidden').exists()){ignore=true;}
if(ignore)
{return;}
if(div.find('input[type="text"], input[type="email"], input[type="number"], input[type="hidden"], textarea').val()=="")
{div.data('validation',false);}
if(div.find('.acf_wysiwyg').exists()&&typeof(tinyMCE)=="object")
{div.data('validation',true);var id=div.find('.wp-editor-area').attr('id'),editor=tinyMCE.get(id);if(editor&&!editor.getContent())
{div.data('validation',false);}}
if(div.find('select').exists())
{div.data('validation',true);if(div.find('select').val()=="null"||!div.find('select').val())
{div.data('validation',false);}}
if(div.find('input[type="radio"]').exists())
{div.data('validation',false);if(div.find('input[type="radio"]:checked').exists())
{div.data('validation',true);}}
if(div.find('input[type="checkbox"]').exists())
{div.data('validation',false);if(div.find('input[type="checkbox"]:checked').exists())
{div.data('validation',true);}}
if(div.find('.acf_relationship').exists())
{div.data('validation',false);if(div.find('.acf_relationship .relationship_right input').exists())
{div.data('validation',true);}}
if(div.find('.repeater').exists())
{div.data('validation',false);if(div.find('.repeater tr.row').exists())
{div.data('validation',true);}}
if(div.find('.acf-gallery').exists())
{div.data('validation',false);if(div.find('.acf-gallery .thumbnail').exists())
{div.data('validation',true);}}
$(document).trigger('acf/validate_field',[div]);if(!div.data('validation'))
{this.status=false;div.closest('.field').addClass('error');if(div.data('validation_message'))
{var $label=div.find('p.label:first'),$message=null;$label.children('.acf-error-message').remove();$label.append('<span class="acf-error-message"><i class="bit"></i>'+div.data('validation_message')+'</span>');}
if($tab)
{$tab.trigger('click');}}}};$(document).on('focus click','.field.required input, .field.required textarea, .field.required select',function(e){$(this).closest('.field').removeClass('error');});$(document).on('click','#save-post',function(){acf.validation.disabled=true;});$(document).on('submit','#post',function(){if(acf.validation.disabled)
{return true;}
acf.validation.run();if(!acf.validation.status)
{var $form=$(this);$form.siblings('#message').remove();$form.before('<div id="message" class="error"><p>'+acf.l10n.validation.error+'</p></div>');if($('#submitdiv').exists()){$('#submitdiv').find('.disabled').removeClass('disabled');$('#submitdiv').find('.button-disabled').removeClass('button-disabled');$('#submitdiv').find('.button-primary-disabled').removeClass('button-primary-disabled');$('#submitdiv .spinner').hide();}
return false;}
$('.acf_postbox.acf-hidden').remove();return true;});})(jQuery);(function($){var _wysiwyg=acf.fields.wysiwyg={$el:null,$textarea:null,o:{},set:function(o){$.extend(this,o);this.$textarea=this.$el.find('textarea');this.o=acf.helpers.get_atts(this.$el);this.o.id=this.$textarea.attr('id');return this;},has_tinymce:function(){var r=false;if(typeof(tinyMCE)=="object")
{r=true;}
return r;},get_toolbar:function(){if(acf.helpers.isset(this,'toolbars',this.o.toolbar)){return this.toolbars[this.o.toolbar];}
return false;},init:function(){if(acf.helpers.is_clone_field(this.$textarea))
{return;}
var toolbar=this.get_toolbar(),command='mceAddControl',setting='theme_advanced_buttons{i}';var _settings=$.extend({},tinyMCE.settings);if(tinymce.majorVersion==4){command='mceAddEditor';setting='toolbar{i}';}
if(toolbar){for(var i=1;i<5;i++){var v='';if(acf.helpers.isset(toolbar,'theme_advanced_buttons'+i)){v=toolbar['theme_advanced_buttons'+i];}
tinyMCE.settings[setting.replace('{i}',i)]=v;}}
tinyMCE.execCommand(command,false,this.o.id);$(document).trigger('acf/wysiwyg/load',this.o.id);this.add_events();tinyMCE.settings=_settings;wpActiveEditor=null;},add_events:function(){var id=this.o.id,editor=tinyMCE.get(id);if(!editor)
{return;}
var $container=$('#wp-'+id+'-wrap'),$body=$(editor.getBody());$container.on('click',function(){$(document).trigger('acf/wysiwyg/click',id);});$body.on('focus',function(){$(document).trigger('acf/wysiwyg/focus',id);});$body.on('blur',function(){$(document).trigger('acf/wysiwyg/blur',id);});},destroy:function(){var id=this.o.id,command='mceRemoveControl';try{var editor=tinyMCE.get(id);if(!editor){return;}
if(tinymce.majorVersion==4){command='mceRemoveEditor';}
var val=editor.getContent();tinyMCE.execCommand(command,false,id);this.$textarea.val(val);}catch(e){}
wpActiveEditor=null;}};$(document).on('acf/setup_fields',function(e,el){if(!_wysiwyg.has_tinymce())
{return;}
$(el).find('.acf_wysiwyg').each(function(){_wysiwyg.set({$el:$(this)}).destroy();});setTimeout(function(){$(el).find('.acf_wysiwyg').each(function(){_wysiwyg.set({$el:$(this)}).init();});},0);});$(document).on('acf/remove_fields',function(e,$el){if(!_wysiwyg.has_tinymce())
{return;}
$el.find('.acf_wysiwyg').each(function(){_wysiwyg.set({$el:$(this)}).destroy();});});$(document).on('acf/wysiwyg/click',function(e,id){wpActiveEditor=id;container=$('#wp-'+id+'-wrap').closest('.field').removeClass('error');});$(document).on('acf/wysiwyg/focus',function(e,id){wpActiveEditor=id;container=$('#wp-'+id+'-wrap').closest('.field').removeClass('error');});$(document).on('acf/wysiwyg/blur',function(e,id){wpActiveEditor=null;var editor=tinyMCE.get(id);if(!editor)
{return;}
var el=editor.getElement();editor.save();$(el).trigger('change');});$(document).on('acf/sortable_start',function(e,el){if(!_wysiwyg.has_tinymce())
{return;}
$(el).find('.acf_wysiwyg').each(function(){_wysiwyg.set({$el:$(this)}).destroy();});});$(document).on('acf/sortable_stop',function(e,el){if(!_wysiwyg.has_tinymce())
{return;}
$(el).find('.acf_wysiwyg').each(function(){_wysiwyg.set({$el:$(this)}).init();});});$(window).load(function(){if(!_wysiwyg.has_tinymce())
{return;}
var wp_content=$('#wp-content-wrap').exists(),wp_acf_settings=$('#wp-acf_settings-wrap').exists()
mode='tmce';if(wp_acf_settings)
{if($('#wp-acf_settings-wrap').hasClass('html-active'))
{mode='html';}}
setTimeout(function(){if(wp_acf_settings&&mode=='html')
{$('#acf_settings-tmce').trigger('click');}},1);setTimeout(function(){if(wp_acf_settings&&mode=='html')
{$('#acf_settings-html').trigger('click');}
if(wp_content)
{_wysiwyg.set({$el:$('#wp-content-wrap')}).add_events();}},11);});$(document).on('click','.acf_wysiwyg a.mce_fullscreen',function(){var wysiwyg=$(this).closest('.acf_wysiwyg'),upload=wysiwyg.attr('data-upload');if(upload=='no')
{$('#mce_fullscreen_container td.mceToolbar .mce_add_media').remove();}});})(jQuery);