prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_220100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.0'
,p_default_workspace_id=>3805326530312898
,p_default_application_id=>2200
,p_default_id_offset=>147968117284853169
,p_default_owner=>'CSWEB'
);
end;
/

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/apex_notification
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(138494323700459718664)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'APEX.NOTIFICATION'
,p_display_name=>'APEX Notification Menu'
,p_category=>'NOTIFICATION'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'FUNCTION F_GETBINDEDREFCURSOR(',
'   PI_SQL IN CLOB',
') RETURN SYS_REFCURSOR AS',
'   V_APEX_ITEMS_NAMES    DBMS_SQL.VARCHAR2_TABLE;',
'   V_CURSOR              PLS_INTEGER;',
'   V_STATUS              NUMBER;',
'   V_VALUE               VARCHAR2(4000);',
'BEGIN',
'   V_APEX_ITEMS_NAMES := WWV_FLOW_UTILITIES.GET_BINDS(PI_SQL);',
'   ',
'   V_CURSOR := DBMS_SQL.OPEN_CURSOR;',
'',
'   DBMS_SQL.PARSE (V_CURSOR, PI_SQL, DBMS_SQL.NATIVE);',
'',
'   FOR i IN 1..V_APEX_ITEMS_NAMES.COUNT LOOP',
'      V_VALUE := V(TRIM(BOTH '':'' FROM V_APEX_ITEMS_NAMES(i)));',
'      DBMS_SQL.BIND_VARIABLE (V_CURSOR, V_APEX_ITEMS_NAMES(i), V_VALUE);',
'   END LOOP;',
'',
'   V_STATUS := DBMS_SQL.EXECUTE(V_CURSOR);',
'',
'   RETURN DBMS_SQL.TO_REFCURSOR(V_CURSOR);',
'END;',
'',
'FUNCTION F_AJAX (',
'    P_DYNAMIC_ACTION   IN APEX_PLUGIN.T_DYNAMIC_ACTION,',
'    P_PLUGIN           IN APEX_PLUGIN.T_PLUGIN',
') RETURN APEX_PLUGIN.T_DYNAMIC_ACTION_AJAX_RESULT IS',
'    VR_RESULT         APEX_PLUGIN.T_DYNAMIC_ACTION_AJAX_RESULT;',
'    VC_CURSOR         SYS_REFCURSOR;',
'',
'BEGIN',
'    VC_CURSOR := F_GETBINDEDREFCURSOR(P_DYNAMIC_ACTION.ATTRIBUTE_04);',
'',
'    APEX_JSON.OPEN_OBJECT;',
'    APEX_JSON.WRITE(''row'', VC_CURSOR);',
'    APEX_JSON.CLOSE_OBJECT;  ',
'',
'    RETURN VR_RESULT;',
'END;',
'',
'FUNCTION F_RENDER (',
'    P_DYNAMIC_ACTION   IN APEX_PLUGIN.T_DYNAMIC_ACTION,',
'    P_PLUGIN           IN APEX_PLUGIN.T_PLUGIN',
') RETURN APEX_PLUGIN.T_DYNAMIC_ACTION_RENDER_RESULT AS',
'    VR_RESULT         APEX_PLUGIN.T_DYNAMIC_ACTION_RENDER_RESULT;',
'    VR_REQUIRE_ESCAPE BOOLEAN := TRUE;',
'    VR_SANITIZE       BOOLEAN := TRUE;',
'BEGIN',
'    APEX_CSS.ADD_FILE(  ',
'        P_NAME        => ''anm.pkgd.min'',',
'        P_DIRECTORY   => P_PLUGIN.FILE_PREFIX,',
'        P_VERSION     => NULL,',
'        P_KEY         => ''noteMenuStyle''',
'    );',
'',
'    APEX_JAVASCRIPT.ADD_LIBRARY(',
'        P_NAME        => ''anm.pkgd.min'',',
'        P_DIRECTORY   => P_PLUGIN.FILE_PREFIX,',
'        P_VERSION     => NULL,',
'        P_KEY         => ''noteMenuSource''',
'    );',
'',
'    IF',
'        P_DYNAMIC_ACTION.ATTRIBUTE_05 = ''N''',
'    THEN',
'        VR_REQUIRE_ESCAPE   := FALSE;',
'    ELSE',
'        VR_REQUIRE_ESCAPE   := TRUE;',
'    END IF;',
'    ',
'    IF',
'        P_DYNAMIC_ACTION.ATTRIBUTE_06 = ''N''',
'    THEN',
'        VR_SANITIZE   := FALSE;',
'    ELSE',
'        VR_SANITIZE   := TRUE;',
'    END IF;',
'',
'    VR_RESULT.JAVASCRIPT_FUNCTION   := ''function () {',
'  notificationMenu.initialize('' ||',
'    APEX_JAVASCRIPT.ADD_VALUE( P_DYNAMIC_ACTION.ATTRIBUTE_02, TRUE ) ||',
'    APEX_JAVASCRIPT.ADD_VALUE( APEX_PLUGIN.GET_AJAX_IDENTIFIER, TRUE ) ||',
'    APEX_JAVASCRIPT.ADD_VALUE( P_DYNAMIC_ACTION.ATTRIBUTE_01, TRUE ) ||',
'    APEX_JAVASCRIPT.ADD_VALUE( APEX_PLUGIN_UTIL.PAGE_ITEM_NAMES_TO_JQUERY(P_DYNAMIC_ACTION.ATTRIBUTE_03), TRUE ) ||',
'    APEX_JAVASCRIPT.ADD_VALUE( VR_REQUIRE_ESCAPE, TRUE ) ||',
'    APEX_JAVASCRIPT.ADD_VALUE( VR_SANITIZE, TRUE ) ||',
'    APEX_JAVASCRIPT.ADD_VALUE( P_DYNAMIC_ACTION.ATTRIBUTE_07, FALSE ) ||',
'    '');}'';',
'',
'    RETURN VR_RESULT;',
'END;'))
,p_api_version=>1
,p_render_function=>'F_RENDER'
,p_ajax_function=>'F_AJAX'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'This dynamic action plugin allows to render a notification menu which gets its information through an SQL statement. It also has many configuration options and an automatic refresh (if desired). Unfortunately, it is only available with the Universal '
||'Theme 1.1 in Apex 5.1.1 or above. If you want to use it in older Themes then you have to customize the CSS style.',
'',
'To Trigger a manual refresh just create a dynmic action e.g. on button click with the action "Refresh" and set as "Affected Element" a jQuery Selector. Then enter the ID that was set as Element ID for Notification Menu.'))
,p_version_identifier=>'1.6.5'
,p_about_url=>'https://github.com/RonnyWeiss/Apex-Notification-Menu-for-NavBar'
,p_files_version=>1360
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(233149235967766145)
,p_plugin_id=>wwv_flow_imp.id(138494323700459718664)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>4
,p_prompt=>'ConfigJSON'
,p_attribute_type=>'JAVASCRIPT'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'{',
'    "refresh": 0,',
'    "mainIcon": "fa-bell",',
'    "mainIconColor": "white",',
'    "mainIconBackgroundColor": "rgba(70,70,70,0.9)",',
'    "mainIconBlinking": false,',
'    "counterBackgroundColor": "rgb(232, 55, 55 )",',
'    "counterFontColor": "white",',
'    "linkTargetBlank": false,',
'    "showAlways": false,',
'    "browserNotifications": {',
'        "enabled": true,',
'        "cutBodyTextAfter": 100,',
'        "link": false',
'    },',
'    "accept": {',
'        "color": "#44e55c",',
'        "icon": "fa-check"',
'    },',
'    "decline": {',
'        "color": "#b73a21",',
'        "icon": "fa-close"',
'    },',
'    "hideOnRefresh": true',
'}'))
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'{',
'    "refresh": 0,',
'    "mainIcon": "fa-bell",',
'    "mainIconColor": "white",',
'    "mainIconBackgroundColor": "rgba(70,70,70,0.9)",',
'    "mainIconBlinking": false,',
'    "counterBackgroundColor": "rgb(232, 55, 55 )",',
'    "counterFontColor": "white",',
'    "linkTargetBlank": false,',
'    "showAlways": false,',
'    "browserNotifications": {',
'        "enabled": true,',
'        "cutBodyTextAfter": 100,',
'        "link": false',
'    },',
'    "accept": {',
'        "color": "#44e55c",',
'        "icon": "fa-check"',
'    },',
'    "decline": {',
'        "color": "#b73a21",',
'        "icon": "fa-close"',
'    },',
'    "hideOnRefresh": true',
'}',
'</pre>',
'<br>',
'<h3>Explanation:</h3>',
'  <dl>',
'  <dt>refresh (number)</dt>',
'  <dd>refresh time of cards in seconds if 0 then no refresh will be set</dd>',
'  <dl>',
'  <dt>mainIcon(string)</dt>',
'  <dd>icon of the menu</dd>',
'  <dl>',
'  <dt>mainIconColor(string)</dt>',
'  <dd>color of the icon e.g. #ffffff, green...</dd>',
'  <dl>',
'  <dt>counterBackgroundColor(string)</dt>',
'  <dd>color of the icon background e.g. #ffffff, green...</dd>',
'  <dl>',
'  <dt>mainIconBlinking(boolean)</dt>',
'  <dd>used to get icon blinking</dd>',
'  <dl>',
'  <dt>counterBackgroundColor(string)</dt>',
'  <dd>color of the counter background e.g. #ffffff, green...</dd>',
'  <dl>',
'  <dt>counterFontColor(string)</dt>',
'  <dd>color of the counter font color e.g. #ffffff, green...</dd>',
'  <dl>',
'  <dt>linkTargetBlank(boolean)</dt>',
'  <dd>link to target blank or not</dd>',
'  <dl>',
'  <dt>showAlways(boolean)</dt>',
'  <dd>Use to set if also shown when no notifications occured</dd>',
'  <dt>browserNotifications.enable(boolean)</dt>',
'  <dd>Use the notification API of the browser to show notifications</dd>',
'  <dt>browserNotifications.cutBodyTextAfter(number)</dt>',
'  <dd>Set max length of shown body text</dd>',
'  <dt>browserNotifications.link(boolean)</dt>',
'  <dd>set if link of node entry is directly called or if just when click on notification the browser tab is openend where notification was fired</dd>',
'  <dt>accept.color(string)</dt>',
'  <dd>color of accept icon</dd>',
'  <dt>accept.icon(string)</dt>',
'  <dd>accept icon</dd>',
'  <dt>decline.color(string)</dt>',
'  <dd>color of decline icon</dd>',
'  <dt>decline.icon(string)</dt>',
'  <dd>decline icon</dd>',
'  <dt>hideOnRefresh(boolean)</dt>',
'  <dd>Set if Notification menu should hide on Refresh.</dd>'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(233149655140766146)
,p_plugin_id=>wwv_flow_imp.id(138494323700459718664)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>3
,p_prompt=>'Element ID'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'notification-menu'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(233150040057766146)
,p_plugin_id=>wwv_flow_imp.id(138494323700459718664)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>2
,p_prompt=>'Items to Submit'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(233150422444766146)
,p_plugin_id=>wwv_flow_imp.id(138494323700459718664)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>1
,p_prompt=>'SQL Source'
,p_attribute_type=>'SQL'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT /* sets the icon of the list item */',
'    ''fa-exclamation-triangle'' AS NOTE_ICON, ',
'    /* sets the color of the list icon */',
'    ''rgb(192,0,15)'' AS NOTE_ICON_COLOR, ',
'    /* sets the title of the list item (html possible) */',
'    ''Alarm occurred'' AS NOTE_HEADER,',
'    /* sets the text of the list item (html possible) */',
'    ''There''''s an alarm in <b>Station 3</b>. Error code is <b style="color:rgba(192,0,15);">#304-AD. </b>'' AS NOTE_TEXT, ',
'    /* set the link when click on list item */',
'    ''javascript:alert("Click on Notification Entry");void(0);'' AS NOTE_LINK, ',
'    /* sets the color of the left box shadow */',
'    ''rgb(192,0,15)'' AS NOTE_COLOR,',
'    /* Link or js that is executed when press accept link (if left or null not accept is shown) */ ',
'    ''javascript:alert("Accepted");void(0);'' AS NOTE_ACCEPT,',
'    /* Link or js that is executed when press decline link (if left or null not decline is shown) */ ',
'    ''javascript:alert("Declined");void(0);'' AS NOTE_DECLINE,',
'    /* sets the icon of the accept link (if left or null not accept is shown) */ ',
'    ''fa-check'' AS ACCEPT_ICON,',
'    /* sets the color of the accept link (if left or null not accept is shown) */ ',
'    ''#44e55c'' AS ACCEPT_ICON_COLOR,',
'    /* sets the icon of the decline link (if left or null not decline is shown) */ 	',
'    ''fa-close'' AS DECLINE_ICON,',
'    /* sets the color of the decline link (if left or null not decline is shown) */ ',
'    ''#b73a21'' AS DECLINE_ICON_COLOR,',
'    /* When enable Browser Notifications in ConfigJSON then you can select which notifications should not be fire browser not. */',
'    0 AS NO_BROWSER_NOTIFICATION',
'FROM',
'    DUAL',
'UNION ALL',
'SELECT',
'    ''fa-wrench'' AS NOTE_ICON,',
'    ''#3e6ebc'' AS NOTE_ICON_COLOR,',
'    ''System maintenance'' AS NOTE_HEADER,',
'    ''In the time between <b>08:30</b> and <b>11:00</b> a system maintenance takes place. The systems can only be used in read-only mode and are limited in use'' AS NOTE_TEXT,',
'    ''https://apex.world'' AS NOTE_LINK,',
'    ''#3e6ebc'' AS NOTE_COLOR,',
'    NULL AS NOTE_ACCEPT,',
'    ''javascript:alert("Declined");void(0);'' AS NOTE_DECLINE,',
'    ''fa-check'' AS ACCEPT_ICON,',
'    ''#44e55c'' AS ACCEPT_ICON_COLOR,',
'    ''fa-close'' AS DECLINE_ICON,',
'    ''#b73a21'' AS DECLINE_ICON_COLOR,',
'    0 AS NO_BROWSER_NOTIFICATION',
'FROM',
'    DUAL',
'WHERE',
'    2 = ROUND(',
'        DBMS_RANDOM.VALUE(',
'            1,',
'            2',
'        )',
'    )   '))
,p_sql_min_column_count=>1
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'SELECT /* sets the icon of the list item */',
'    ''fa-exclamation-triangle'' AS NOTE_ICON, ',
'    /* sets the color of the list icon */',
'    ''rgb(192,0,15)'' AS NOTE_ICON_COLOR, ',
'    /* sets the title of the list item (html possible) */',
'    ''Alarm occurred'' AS NOTE_HEADER,',
'    /* sets the text of the list item (html possible) */',
'    ''There''''s an alarm in <b>Station 3</b>. Error code is <b style="color:rgba(192,0,15);">#304-AD. </b>'' AS NOTE_TEXT, ',
'    /* set the link when click on list item */',
'    ''javascript:alert("Click on Notification Entry");void(0);'' AS NOTE_LINK, ',
'    /* sets the color of the left box shadow */',
'    ''rgb(192,0,15)'' AS NOTE_COLOR,',
'    /* Link or js that is executed when press accept link (if left or null not accept is shown) */ ',
'    ''javascript:alert("Accepted");void(0);'' AS NOTE_ACCEPT,',
'    /* Link or js that is executed when press decline link (if left or null not decline is shown) */ ',
'    ''javascript:alert("Declined");void(0);'' AS NOTE_DECLINE,',
'    /* sets the icon of the accept link (if left or null not accept is shown) */ ',
'    ''fa-check'' AS ACCEPT_ICON,',
'    /* sets the color of the accept link (if left or null not accept is shown) */ ',
'    ''#44e55c'' AS ACCEPT_ICON_COLOR,',
'    /* sets the icon of the decline link (if left or null not decline is shown) */ 	',
'    ''fa-close'' AS DECLINE_ICON,',
'    /* sets the color of the decline link (if left or null not decline is shown) */ ',
'    ''#b73a21'' AS DECLINE_ICON_COLOR,',
'    /* When enable Browser Notifications in ConfigJSON then you can select which notifications should not be fire browser not. */',
'    0 AS NO_BROWSER_NOTIFICATION',
'FROM',
'    DUAL',
'UNION ALL',
'SELECT',
'    ''fa-wrench'' AS NOTE_ICON,',
'    ''#3e6ebc'' AS NOTE_ICON_COLOR,',
'    ''System maintenance'' AS NOTE_HEADER,',
'    ''In the time between <b>08:30</b> and <b>11:00</b> a system maintenance takes place. The systems can only be used in read-only mode and are limited in use'' AS NOTE_TEXT,',
'    ''https://apex.world'' AS NOTE_LINK,',
'    ''#3e6ebc'' AS NOTE_COLOR,',
'    NULL AS NOTE_ACCEPT,',
'    ''javascript:alert("Declined");void(0);'' AS NOTE_DECLINE,',
'    ''fa-check'' AS ACCEPT_ICON,',
'    ''#44e55c'' AS ACCEPT_ICON_COLOR,',
'    ''fa-close'' AS DECLINE_ICON,',
'    ''#b73a21'' AS DECLINE_ICON_COLOR,',
'    0 AS NO_BROWSER_NOTIFICATION',
'FROM',
'    DUAL',
'WHERE',
'    2 = ROUND(',
'        DBMS_RANDOM.VALUE(',
'            1,',
'            2',
'        )',
'    )',
'</pre>'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(233150884564766146)
,p_plugin_id=>wwv_flow_imp.id(138494323700459718664)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Escape special Characters'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_help_text=>'This value determines whether all texts that the plug-in inserts into the page should be escaped. This is necessary if texts come from user input or insecure sources to prevent XSS.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(233151236982766146)
,p_plugin_id=>wwv_flow_imp.id(138494323700459718664)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Sanitize HTML'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(233150884564766146)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Sanitizes HTML e.g. &lt;script&gt; tags will be removed.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(233151716334766147)
,p_plugin_id=>wwv_flow_imp.id(138494323700459718664)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Sanitize HTML Options'
,p_attribute_type=>'JAVASCRIPT'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'{',
'  "ALLOWED_ATTR": [',
'    "accesskey",',
'    "align",',
'    "alt",',
'    "always",',
'    "autocomplete",',
'    "autoplay",',
'    "border",',
'    "cellpadding",',
'    "cellspacing",',
'    "charset",',
'    "class",',
'    "colspan",',
'    "dir",',
'    "height",',
'    "href",',
'    "id",',
'    "lang",',
'    "name",',
'    "rel",',
'    "required",',
'    "rowspan",',
'    "src",',
'    "style",',
'    "summary",',
'    "tabindex",',
'    "target",',
'    "title",',
'    "type",',
'    "value",',
'    "width"',
'  ],',
'  "ALLOWED_TAGS": [',
'    "a",',
'    "address",',
'    "b",',
'    "blockquote",',
'    "br",',
'    "caption",',
'    "code",',
'    "dd",',
'    "div",',
'    "dl",',
'    "dt",',
'    "em",',
'    "figcaption",',
'    "figure",',
'    "h1",',
'    "h2",',
'    "h3",',
'    "h4",',
'    "h5",',
'    "h6",',
'    "hr",',
'    "i",',
'    "img",',
'    "label",',
'    "li",',
'    "nl",',
'    "ol",',
'    "p",',
'    "pre",',
'    "s",',
'    "span",',
'    "strike",',
'    "strong",',
'    "sub",',
'    "sup",',
'    "table",',
'    "tbody",',
'    "td",',
'    "th",',
'    "thead",',
'    "tr",',
'    "u",',
'    "ul"',
'  ]',
'}'))
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(233151236982766146)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'This Clob Loader includes a sanitizer for HTML as option to use:',
'A Full Description you will find on: https://github.com/cure53/DOMPurify',
'Example: ',
'<pre>',
'{',
'  "ALLOWED_ATTR": [',
'    "accesskey",',
'    "align",',
'    "alt",',
'    "always",',
'    "autocomplete",',
'    "autoplay",',
'    "border",',
'    "cellpadding",',
'    "cellspacing",',
'    "charset",',
'    "class",',
'    "colspan",',
'    "dir",',
'    "height",',
'    "href",',
'    "id",',
'    "lang",',
'    "name",',
'    "rel",',
'    "required",',
'    "rowspan",',
'    "src",',
'    "style",',
'    "summary",',
'    "tabindex",',
'    "target",',
'    "title",',
'    "type",',
'    "value",',
'    "width"',
'  ],',
'  "ALLOWED_TAGS": [',
'    "a",',
'    "address",',
'    "b",',
'    "blockquote",',
'    "br",',
'    "caption",',
'    "code",',
'    "dd",',
'    "div",',
'    "dl",',
'    "dt",',
'    "em",',
'    "figcaption",',
'    "figure",',
'    "h1",',
'    "h2",',
'    "h3",',
'    "h4",',
'    "h5",',
'    "h6",',
'    "hr",',
'    "i",',
'    "img",',
'    "label",',
'    "li",',
'    "nl",',
'    "ol",',
'    "p",',
'    "pre",',
'    "s",',
'    "span",',
'    "strike",',
'    "strong",',
'    "sub",',
'    "sup",',
'    "table",',
'    "tbody",',
'    "td",',
'    "th",',
'    "thead",',
'    "tr",',
'    "u",',
'    "ul"',
'  ]',
'}',
'</pre>',
'<pre>',
'# make output safe for usage in jQuery''s $()/html() method (default is false)',
'SAFE_FOR_JQUERY: true',
'',
'# strip {{ ... }} and &amp;lt;% ... %&amp;gt; to make output safe for template systems',
'# be careful please, this mode is not recommended for production usage.',
'# allowing template parsing in user-controlled HTML is not advised at all.',
'# only use this mode if there is really no alternative.',
'SAFE_FOR_TEMPLATES: true',
'',
'# allow only &amp;lt;b&amp;gt;',
'ALLOWED_TAGS: [''b'']',
'',
'# allow only &amp;lt;b&amp;gt; and &amp;lt;q&amp;gt; with style attributes (for whatever reason)',
'ALLOWED_TAGS: [''b'', ''q''], ALLOWED_ATTR: [''style'']',
'',
'# allow all safe HTML elements but neither SVG nor MathML',
'USE_PROFILES: {html: true}',
'',
'# allow all safe SVG elements and SVG Filters',
'USE_PROFILES: {svg: true, svgFilters: true}',
'',
'# allow all safe MathML elements and SVG',
'USE_PROFILES: {mathMl: true, svg: true}',
'',
'# leave all as it is but forbid &amp;lt;style&amp;gt;',
'FORBID_TAGS: [''style'']',
'',
'# leave all as it is but forbid style attributes',
'FORBID_ATTR: [''style'']',
'',
'# extend the existing array of allowed tags',
'ADD_TAGS: [''my-tag'']',
'',
'# extend the existing array of attributes',
'ADD_ATTR: [''my-attr'']',
'',
'# prohibit HTML5 data attributes (default is true)',
'ALLOW_DATA_ATTR: false',
'',
'# allow external protocol handlers in URL attributes (default is false)',
'# by default only http, https, ftp, ftps, tel, mailto, callto, cid and xmpp are allowed.',
'ALLOW_UNKNOWN_PROTOCOLS: true',
'</pre>'))
);
wwv_flow_imp_shared.create_plugin_event(
 p_id=>wwv_flow_imp.id(233153325376766150)
,p_plugin_id=>wwv_flow_imp.id(138494323700459718664)
,p_name=>'refresh-apex-notification-menu'
,p_display_name=>'Refresh Notification Menu'
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '4D4954204C6963656E73650A0A436F7079726967687420286329203230323220526F6E6E792057656973730A0A5065726D697373696F6E20697320686572656279206772616E7465642C2066726565206F66206368617267652C20746F20616E79207065';
wwv_flow_imp.g_varchar2_table(2) := '72736F6E206F627461696E696E67206120636F70790A6F66207468697320736F66747761726520616E64206173736F63696174656420646F63756D656E746174696F6E2066696C657320287468652022536F66747761726522292C20746F206465616C0A';
wwv_flow_imp.g_varchar2_table(3) := '696E2074686520536F66747761726520776974686F7574207265737472696374696F6E2C20696E636C7564696E6720776974686F7574206C696D69746174696F6E20746865207269676874730A746F207573652C20636F70792C206D6F646966792C206D';
wwv_flow_imp.g_varchar2_table(4) := '657267652C207075626C6973682C20646973747269627574652C207375626C6963656E73652C20616E642F6F722073656C6C0A636F70696573206F662074686520536F6674776172652C20616E6420746F207065726D697420706572736F6E7320746F20';
wwv_flow_imp.g_varchar2_table(5) := '77686F6D2074686520536F6674776172652069730A6675726E697368656420746F20646F20736F2C207375626A65637420746F2074686520666F6C6C6F77696E6720636F6E646974696F6E733A0A0A5468652061626F766520636F70797269676874206E';
wwv_flow_imp.g_varchar2_table(6) := '6F7469636520616E642074686973207065726D697373696F6E206E6F74696365207368616C6C20626520696E636C7564656420696E20616C6C0A636F70696573206F72207375627374616E7469616C20706F7274696F6E73206F662074686520536F6674';
wwv_flow_imp.g_varchar2_table(7) := '776172652E0A0A54484520534F4654574152452049532050524F564944454420224153204953222C20574954484F55542057415252414E5459204F4620414E59204B494E442C2045585052455353204F520A494D504C4945442C20494E434C5544494E47';
wwv_flow_imp.g_varchar2_table(8) := '20425554204E4F54204C494D4954454420544F205448452057415252414E54494553204F46204D45524348414E544142494C4954592C0A4649544E45535320464F52204120504152544943554C415220505552504F534520414E44204E4F4E494E465249';
wwv_flow_imp.g_varchar2_table(9) := '4E47454D454E542E20494E204E4F204556454E54205348414C4C205448450A415554484F5253204F5220434F5059524947485420484F4C44455253204245204C4941424C4520464F5220414E5920434C41494D2C2044414D41474553204F52204F544845';
wwv_flow_imp.g_varchar2_table(10) := '520A4C494142494C4954592C205748455448455220494E20414E20414354494F4E204F4620434F4E54524143542C20544F5254204F52204F54484552574953452C2041524953494E472046524F4D2C0A4F5554204F46204F5220494E20434F4E4E454354';
wwv_flow_imp.g_varchar2_table(11) := '494F4E20574954482054484520534F465457415245204F522054484520555345204F52204F54484552204445414C494E475320494E205448450A534F4654574152452E0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(233154989801766152)
,p_plugin_id=>wwv_flow_imp.id(138494323700459718664)
,p_file_name=>'LICENSE'
,p_mime_type=>'application/octet-stream'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '4C617374207570646174653A20323032302D30322D32320D0A0D0A68747470733A2F2F6769746875622E636F6D2F6375726535332F444F4D5075726966790D0A0D0A444F4D5075726966790D0A436F707972696768742032303135204D6172696F204865';
wwv_flow_imp.g_varchar2_table(2) := '696465726963680D0A0D0A444F4D507572696679206973206672656520736F6674776172653B20796F752063616E2072656469737472696275746520697420616E642F6F72206D6F6469667920697420756E646572207468650D0A7465726D73206F6620';
wwv_flow_imp.g_varchar2_table(3) := '6569746865723A0D0A0D0A61292074686520417061636865204C6963656E73652056657273696F6E20322E302C206F720D0A622920746865204D6F7A696C6C61205075626C6963204C6963656E73652056657273696F6E20322E300D0A0D0A2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(4) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A0D0A4C6963656E73656420756E64657220746865204170616368';
wwv_flow_imp.g_varchar2_table(5) := '65204C6963656E73652C2056657273696F6E20322E30202874686520224C6963656E736522293B0D0A796F75206D6179206E6F742075736520746869732066696C652065786365707420696E20636F6D706C69616E6365207769746820746865204C6963';
wwv_flow_imp.g_varchar2_table(6) := '656E73652E0D0A596F75206D6179206F627461696E206120636F7079206F6620746865204C6963656E73652061740D0A0D0A20202020687474703A2F2F7777772E6170616368652E6F72672F6C6963656E7365732F4C4943454E53452D322E300D0A0D0A';
wwv_flow_imp.g_varchar2_table(7) := '20202020556E6C657373207265717569726564206279206170706C696361626C65206C6177206F722061677265656420746F20696E2077726974696E672C20736F6674776172650D0A20202020646973747269627574656420756E64657220746865204C';
wwv_flow_imp.g_varchar2_table(8) := '6963656E7365206973206469737472696275746564206F6E20616E20224153204953222042415349532C0D0A20202020574954484F55542057415252414E54494553204F5220434F4E444954494F4E53204F4620414E59204B494E442C20656974686572';
wwv_flow_imp.g_varchar2_table(9) := '2065787072657373206F7220696D706C6965642E0D0A2020202053656520746865204C6963656E736520666F7220746865207370656369666963206C616E677561676520676F7665726E696E67207065726D697373696F6E7320616E640D0A202020206C';
wwv_flow_imp.g_varchar2_table(10) := '696D69746174696F6E7320756E64657220746865204C6963656E73652E0D0A0D0A2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(11) := '2D2D2D2D2D2D2D2D2D2D0D0A4D6F7A696C6C61205075626C6963204C6963656E73652C2076657273696F6E20322E300D0A0D0A312E20446566696E6974696F6E730D0A0D0A312E312E2093436F6E7472696275746F72940D0A0D0A20202020206D65616E';
wwv_flow_imp.g_varchar2_table(12) := '73206561636820696E646976696475616C206F72206C6567616C20656E74697479207468617420637265617465732C20636F6E747269627574657320746F207468650D0A20202020206372656174696F6E206F662C206F72206F776E7320436F76657265';
wwv_flow_imp.g_varchar2_table(13) := '6420536F6674776172652E0D0A0D0A312E322E2093436F6E7472696275746F722056657273696F6E940D0A0D0A20202020206D65616E732074686520636F6D62696E6174696F6E206F662074686520436F6E747269627574696F6E73206F66206F746865';
wwv_flow_imp.g_varchar2_table(14) := '72732028696620616E7929207573656420627920610D0A2020202020436F6E7472696275746F7220616E64207468617420706172746963756C617220436F6E7472696275746F72927320436F6E747269627574696F6E2E0D0A0D0A312E332E2093436F6E';
wwv_flow_imp.g_varchar2_table(15) := '747269627574696F6E940D0A0D0A20202020206D65616E7320436F766572656420536F667477617265206F66206120706172746963756C617220436F6E7472696275746F722E0D0A0D0A312E342E2093436F766572656420536F667477617265940D0A0D';
wwv_flow_imp.g_varchar2_table(16) := '0A20202020206D65616E7320536F7572636520436F646520466F726D20746F2077686963682074686520696E697469616C20436F6E7472696275746F7220686173206174746163686564207468650D0A20202020206E6F7469636520696E204578686962';
wwv_flow_imp.g_varchar2_table(17) := '697420412C207468652045786563757461626C6520466F726D206F66207375636820536F7572636520436F646520466F726D2C20616E640D0A20202020204D6F64696669636174696F6E73206F66207375636820536F7572636520436F646520466F726D';
wwv_flow_imp.g_varchar2_table(18) := '2C20696E2065616368206361736520696E636C7564696E6720706F7274696F6E730D0A202020202074686572656F662E0D0A0D0A312E352E2093496E636F6D70617469626C652057697468205365636F6E64617279204C6963656E736573940D0A202020';
wwv_flow_imp.g_varchar2_table(19) := '20206D65616E730D0A0D0A2020202020612E20746861742074686520696E697469616C20436F6E7472696275746F722068617320617474616368656420746865206E6F746963652064657363726962656420696E0D0A2020202020202020457868696269';
wwv_flow_imp.g_varchar2_table(20) := '74204220746F2074686520436F766572656420536F6674776172653B206F720D0A0D0A2020202020622E20746861742074686520436F766572656420536F66747761726520776173206D61646520617661696C61626C6520756E64657220746865207465';
wwv_flow_imp.g_varchar2_table(21) := '726D73206F662076657273696F6E0D0A2020202020202020312E31206F72206561726C696572206F6620746865204C6963656E73652C20627574206E6F7420616C736F20756E64657220746865207465726D73206F6620610D0A20202020202020205365';
wwv_flow_imp.g_varchar2_table(22) := '636F6E64617279204C6963656E73652E0D0A0D0A312E362E209345786563757461626C6520466F726D940D0A0D0A20202020206D65616E7320616E7920666F726D206F662074686520776F726B206F74686572207468616E20536F7572636520436F6465';
wwv_flow_imp.g_varchar2_table(23) := '20466F726D2E0D0A0D0A312E372E20934C617267657220576F726B940D0A0D0A20202020206D65616E73206120776F726B207468617420636F6D62696E657320436F766572656420536F6674776172652077697468206F74686572206D6174657269616C';
wwv_flow_imp.g_varchar2_table(24) := '2C20696E20612073657061726174650D0A202020202066696C65206F722066696C65732C2074686174206973206E6F7420436F766572656420536F6674776172652E0D0A0D0A312E382E20934C6963656E7365940D0A0D0A20202020206D65616E732074';
wwv_flow_imp.g_varchar2_table(25) := '68697320646F63756D656E742E0D0A0D0A312E392E20934C6963656E7361626C65940D0A0D0A20202020206D65616E7320686176696E672074686520726967687420746F206772616E742C20746F20746865206D6178696D756D20657874656E7420706F';
wwv_flow_imp.g_varchar2_table(26) := '737369626C652C2077686574686572206174207468650D0A202020202074696D65206F662074686520696E697469616C206772616E74206F722073756273657175656E746C792C20616E7920616E6420616C6C206F66207468652072696768747320636F';
wwv_flow_imp.g_varchar2_table(27) := '6E76657965642062790D0A202020202074686973204C6963656E73652E0D0A0D0A312E31302E20934D6F64696669636174696F6E73940D0A0D0A20202020206D65616E7320616E79206F662074686520666F6C6C6F77696E673A0D0A0D0A202020202061';
wwv_flow_imp.g_varchar2_table(28) := '2E20616E792066696C6520696E20536F7572636520436F646520466F726D207468617420726573756C74732066726F6D20616E206164646974696F6E20746F2C2064656C6574696F6E0D0A202020202020202066726F6D2C206F72206D6F646966696361';
wwv_flow_imp.g_varchar2_table(29) := '74696F6E206F662074686520636F6E74656E7473206F6620436F766572656420536F6674776172653B206F720D0A0D0A2020202020622E20616E79206E65772066696C6520696E20536F7572636520436F646520466F726D207468617420636F6E746169';
wwv_flow_imp.g_varchar2_table(30) := '6E7320616E7920436F766572656420536F6674776172652E0D0A0D0A312E31312E2093506174656E7420436C61696D7394206F66206120436F6E7472696275746F720D0A0D0A2020202020206D65616E7320616E7920706174656E7420636C61696D2873';
wwv_flow_imp.g_varchar2_table(31) := '292C20696E636C7564696E6720776974686F7574206C696D69746174696F6E2C206D6574686F642C2070726F636573732C0D0A202020202020616E642061707061726174757320636C61696D732C20696E20616E7920706174656E74204C6963656E7361';
wwv_flow_imp.g_varchar2_table(32) := '626C65206279207375636820436F6E7472696275746F7220746861740D0A202020202020776F756C6420626520696E6672696E6765642C2062757420666F7220746865206772616E74206F6620746865204C6963656E73652C20627920746865206D616B';
wwv_flow_imp.g_varchar2_table(33) := '696E672C0D0A2020202020207573696E672C2073656C6C696E672C206F66666572696E6720666F722073616C652C20686176696E67206D6164652C20696D706F72742C206F72207472616E73666572206F660D0A20202020202065697468657220697473';
wwv_flow_imp.g_varchar2_table(34) := '20436F6E747269627574696F6E73206F722069747320436F6E7472696275746F722056657273696F6E2E0D0A0D0A312E31322E20935365636F6E64617279204C6963656E7365940D0A0D0A2020202020206D65616E73206569746865722074686520474E';
wwv_flow_imp.g_varchar2_table(35) := '552047656E6572616C205075626C6963204C6963656E73652C2056657273696F6E20322E302C2074686520474E55204C65737365720D0A20202020202047656E6572616C205075626C6963204C6963656E73652C2056657273696F6E20322E312C207468';
wwv_flow_imp.g_varchar2_table(36) := '6520474E552041666665726F2047656E6572616C205075626C69630D0A2020202020204C6963656E73652C2056657273696F6E20332E302C206F7220616E79206C617465722076657273696F6E73206F662074686F7365206C6963656E7365732E0D0A0D';
wwv_flow_imp.g_varchar2_table(37) := '0A312E31332E2093536F7572636520436F646520466F726D940D0A0D0A2020202020206D65616E732074686520666F726D206F662074686520776F726B2070726566657272656420666F72206D616B696E67206D6F64696669636174696F6E732E0D0A0D';
wwv_flow_imp.g_varchar2_table(38) := '0A312E31342E2093596F759420286F722093596F757294290D0A0D0A2020202020206D65616E7320616E20696E646976696475616C206F722061206C6567616C20656E746974792065786572636973696E672072696768747320756E6465722074686973';
wwv_flow_imp.g_varchar2_table(39) := '0D0A2020202020204C6963656E73652E20466F72206C6567616C20656E7469746965732C2093596F759420696E636C7564657320616E7920656E74697479207468617420636F6E74726F6C732C2069730D0A202020202020636F6E74726F6C6C65642062';
wwv_flow_imp.g_varchar2_table(40) := '792C206F7220697320756E64657220636F6D6D6F6E20636F6E74726F6C207769746820596F752E20466F7220707572706F736573206F6620746869730D0A202020202020646566696E6974696F6E2C2093636F6E74726F6C94206D65616E732028612920';
wwv_flow_imp.g_varchar2_table(41) := '74686520706F7765722C20646972656374206F7220696E6469726563742C20746F2063617573650D0A20202020202074686520646972656374696F6E206F72206D616E6167656D656E74206F66207375636820656E746974792C20776865746865722062';
wwv_flow_imp.g_varchar2_table(42) := '7920636F6E7472616374206F720D0A2020202020206F74686572776973652C206F7220286229206F776E657273686970206F66206D6F7265207468616E2066696674792070657263656E74202835302529206F66207468650D0A2020202020206F757473';
wwv_flow_imp.g_varchar2_table(43) := '74616E64696E6720736861726573206F722062656E6566696369616C206F776E657273686970206F66207375636820656E746974792E0D0A0D0A0D0A322E204C6963656E7365204772616E747320616E6420436F6E646974696F6E730D0A0D0A322E312E';
wwv_flow_imp.g_varchar2_table(44) := '204772616E74730D0A0D0A20202020204561636820436F6E7472696275746F7220686572656279206772616E747320596F75206120776F726C642D776964652C20726F79616C74792D667265652C0D0A20202020206E6F6E2D6578636C7573697665206C';
wwv_flow_imp.g_varchar2_table(45) := '6963656E73653A0D0A0D0A2020202020612E20756E64657220696E74656C6C65637475616C2070726F70657274792072696768747320286F74686572207468616E20706174656E74206F722074726164656D61726B290D0A20202020202020204C696365';
wwv_flow_imp.g_varchar2_table(46) := '6E7361626C65206279207375636820436F6E7472696275746F7220746F207573652C20726570726F647563652C206D616B6520617661696C61626C652C0D0A20202020202020206D6F646966792C20646973706C61792C20706572666F726D2C20646973';
wwv_flow_imp.g_varchar2_table(47) := '747269627574652C20616E64206F7468657277697365206578706C6F6974206974730D0A2020202020202020436F6E747269627574696F6E732C20656974686572206F6E20616E20756E6D6F6469666965642062617369732C2077697468204D6F646966';
wwv_flow_imp.g_varchar2_table(48) := '69636174696F6E732C206F722061730D0A202020202020202070617274206F662061204C617267657220576F726B3B20616E640D0A0D0A2020202020622E20756E64657220506174656E7420436C61696D73206F66207375636820436F6E747269627574';
wwv_flow_imp.g_varchar2_table(49) := '6F7220746F206D616B652C207573652C2073656C6C2C206F6666657220666F720D0A202020202020202073616C652C2068617665206D6164652C20696D706F72742C20616E64206F7468657277697365207472616E736665722065697468657220697473';
wwv_flow_imp.g_varchar2_table(50) := '20436F6E747269627574696F6E730D0A20202020202020206F722069747320436F6E7472696275746F722056657273696F6E2E0D0A0D0A322E322E2045666665637469766520446174650D0A0D0A2020202020546865206C6963656E736573206772616E';
wwv_flow_imp.g_varchar2_table(51) := '74656420696E2053656374696F6E20322E312077697468207265737065637420746F20616E7920436F6E747269627574696F6E206265636F6D650D0A202020202065666665637469766520666F72206561636820436F6E747269627574696F6E206F6E20';
wwv_flow_imp.g_varchar2_table(52) := '74686520646174652074686520436F6E7472696275746F722066697273742064697374726962757465730D0A20202020207375636820436F6E747269627574696F6E2E0D0A0D0A322E332E204C696D69746174696F6E73206F6E204772616E742053636F';
wwv_flow_imp.g_varchar2_table(53) := '70650D0A0D0A2020202020546865206C6963656E736573206772616E74656420696E20746869732053656374696F6E20322061726520746865206F6E6C7920726967687473206772616E74656420756E64657220746869730D0A20202020204C6963656E';
wwv_flow_imp.g_varchar2_table(54) := '73652E204E6F206164646974696F6E616C20726967687473206F72206C6963656E7365732077696C6C20626520696D706C6965642066726F6D2074686520646973747269627574696F6E0D0A20202020206F72206C6963656E73696E67206F6620436F76';
wwv_flow_imp.g_varchar2_table(55) := '6572656420536F66747761726520756E6465722074686973204C6963656E73652E204E6F74776974687374616E64696E672053656374696F6E0D0A2020202020322E312862292061626F76652C206E6F20706174656E74206C6963656E73652069732067';
wwv_flow_imp.g_varchar2_table(56) := '72616E746564206279206120436F6E7472696275746F723A0D0A0D0A2020202020612E20666F7220616E7920636F64652074686174206120436F6E7472696275746F72206861732072656D6F7665642066726F6D20436F766572656420536F6674776172';
wwv_flow_imp.g_varchar2_table(57) := '653B206F720D0A0D0A2020202020622E20666F7220696E6672696E67656D656E7473206361757365642062793A2028692920596F757220616E6420616E79206F7468657220746869726420706172747992730D0A20202020202020206D6F646966696361';
wwv_flow_imp.g_varchar2_table(58) := '74696F6E73206F6620436F766572656420536F6674776172652C206F7220286969292074686520636F6D62696E6174696F6E206F66206974730D0A2020202020202020436F6E747269627574696F6E732077697468206F7468657220736F667477617265';
wwv_flow_imp.g_varchar2_table(59) := '20286578636570742061732070617274206F662069747320436F6E7472696275746F720D0A202020202020202056657273696F6E293B206F720D0A0D0A2020202020632E20756E64657220506174656E7420436C61696D7320696E6672696E6765642062';
wwv_flow_imp.g_varchar2_table(60) := '7920436F766572656420536F66747761726520696E2074686520616273656E6365206F66206974730D0A2020202020202020436F6E747269627574696F6E732E0D0A0D0A202020202054686973204C6963656E736520646F6573206E6F74206772616E74';
wwv_flow_imp.g_varchar2_table(61) := '20616E792072696768747320696E207468652074726164656D61726B732C2073657276696365206D61726B732C206F720D0A20202020206C6F676F73206F6620616E7920436F6E7472696275746F722028657863657074206173206D6179206265206E65';
wwv_flow_imp.g_varchar2_table(62) := '6365737361727920746F20636F6D706C792077697468207468650D0A20202020206E6F7469636520726571756972656D656E747320696E2053656374696F6E20332E34292E0D0A0D0A322E342E2053756273657175656E74204C6963656E7365730D0A0D';
wwv_flow_imp.g_varchar2_table(63) := '0A20202020204E6F20436F6E7472696275746F72206D616B6573206164646974696F6E616C206772616E7473206173206120726573756C74206F6620596F75722063686F69636520746F0D0A2020202020646973747269627574652074686520436F7665';
wwv_flow_imp.g_varchar2_table(64) := '72656420536F66747761726520756E64657220612073756273657175656E742076657273696F6E206F662074686973204C6963656E73650D0A2020202020287365652053656374696F6E2031302E3229206F7220756E64657220746865207465726D7320';
wwv_flow_imp.g_varchar2_table(65) := '6F662061205365636F6E64617279204C6963656E736520286966207065726D69747465640D0A2020202020756E64657220746865207465726D73206F662053656374696F6E20332E33292E0D0A0D0A322E352E20526570726573656E746174696F6E0D0A';
wwv_flow_imp.g_varchar2_table(66) := '0D0A20202020204561636820436F6E7472696275746F7220726570726573656E747320746861742074686520436F6E7472696275746F722062656C69657665732069747320436F6E747269627574696F6E730D0A202020202061726520697473206F7269';
wwv_flow_imp.g_varchar2_table(67) := '67696E616C206372656174696F6E287329206F72206974206861732073756666696369656E742072696768747320746F206772616E74207468650D0A202020202072696768747320746F2069747320436F6E747269627574696F6E7320636F6E76657965';
wwv_flow_imp.g_varchar2_table(68) := '642062792074686973204C6963656E73652E0D0A0D0A322E362E2046616972205573650D0A0D0A202020202054686973204C6963656E7365206973206E6F7420696E74656E64656420746F206C696D697420616E792072696768747320596F7520686176';
wwv_flow_imp.g_varchar2_table(69) := '6520756E646572206170706C696361626C650D0A2020202020636F7079726967687420646F637472696E6573206F662066616972207573652C2066616972206465616C696E672C206F72206F74686572206571756976616C656E74732E0D0A0D0A322E37';
wwv_flow_imp.g_varchar2_table(70) := '2E20436F6E646974696F6E730D0A0D0A202020202053656374696F6E7320332E312C20332E322C20332E332C20616E6420332E342061726520636F6E646974696F6E73206F6620746865206C6963656E736573206772616E74656420696E0D0A20202020';
wwv_flow_imp.g_varchar2_table(71) := '2053656374696F6E20322E312E0D0A0D0A0D0A332E20526573706F6E736962696C69746965730D0A0D0A332E312E20446973747269627574696F6E206F6620536F7572636520466F726D0D0A0D0A2020202020416C6C20646973747269627574696F6E20';
wwv_flow_imp.g_varchar2_table(72) := '6F6620436F766572656420536F66747761726520696E20536F7572636520436F646520466F726D2C20696E636C7564696E6720616E790D0A20202020204D6F64696669636174696F6E73207468617420596F7520637265617465206F7220746F20776869';
wwv_flow_imp.g_varchar2_table(73) := '636820596F7520636F6E747269627574652C206D75737420626520756E646572207468650D0A20202020207465726D73206F662074686973204C6963656E73652E20596F75206D75737420696E666F726D20726563697069656E74732074686174207468';
wwv_flow_imp.g_varchar2_table(74) := '6520536F7572636520436F646520466F726D0D0A20202020206F662074686520436F766572656420536F66747761726520697320676F7665726E656420627920746865207465726D73206F662074686973204C6963656E73652C20616E6420686F770D0A';
wwv_flow_imp.g_varchar2_table(75) := '2020202020746865792063616E206F627461696E206120636F7079206F662074686973204C6963656E73652E20596F75206D6179206E6F7420617474656D707420746F20616C746572206F720D0A20202020207265737472696374207468652072656369';
wwv_flow_imp.g_varchar2_table(76) := '7069656E7473922072696768747320696E2074686520536F7572636520436F646520466F726D2E0D0A0D0A332E322E20446973747269627574696F6E206F662045786563757461626C6520466F726D0D0A0D0A2020202020496620596F75206469737472';
wwv_flow_imp.g_varchar2_table(77) := '696275746520436F766572656420536F66747761726520696E2045786563757461626C6520466F726D207468656E3A0D0A0D0A2020202020612E207375636820436F766572656420536F667477617265206D75737420616C736F206265206D6164652061';
wwv_flow_imp.g_varchar2_table(78) := '7661696C61626C6520696E20536F7572636520436F646520466F726D2C0D0A202020202020202061732064657363726962656420696E2053656374696F6E20332E312C20616E6420596F75206D75737420696E666F726D20726563697069656E7473206F';
wwv_flow_imp.g_varchar2_table(79) := '66207468650D0A202020202020202045786563757461626C6520466F726D20686F7720746865792063616E206F627461696E206120636F7079206F66207375636820536F7572636520436F646520466F726D2062790D0A2020202020202020726561736F';
wwv_flow_imp.g_varchar2_table(80) := '6E61626C65206D65616E7320696E20612074696D656C79206D616E6E65722C206174206120636861726765206E6F206D6F7265207468616E2074686520636F73740D0A20202020202020206F6620646973747269627574696F6E20746F20746865207265';
wwv_flow_imp.g_varchar2_table(81) := '63697069656E743B20616E640D0A0D0A2020202020622E20596F75206D6179206469737472696275746520737563682045786563757461626C6520466F726D20756E64657220746865207465726D73206F662074686973204C6963656E73652C0D0A2020';
wwv_flow_imp.g_varchar2_table(82) := '2020202020206F72207375626C6963656E736520697420756E64657220646966666572656E74207465726D732C2070726F7669646564207468617420746865206C6963656E736520666F720D0A20202020202020207468652045786563757461626C6520';
wwv_flow_imp.g_varchar2_table(83) := '466F726D20646F6573206E6F7420617474656D707420746F206C696D6974206F7220616C7465722074686520726563697069656E7473920D0A202020202020202072696768747320696E2074686520536F7572636520436F646520466F726D20756E6465';
wwv_flow_imp.g_varchar2_table(84) := '722074686973204C6963656E73652E0D0A0D0A332E332E20446973747269627574696F6E206F662061204C617267657220576F726B0D0A0D0A2020202020596F75206D61792063726561746520616E6420646973747269627574652061204C6172676572';
wwv_flow_imp.g_varchar2_table(85) := '20576F726B20756E646572207465726D73206F6620596F75722063686F6963652C0D0A202020202070726F7669646564207468617420596F7520616C736F20636F6D706C7920776974682074686520726571756972656D656E7473206F66207468697320';
wwv_flow_imp.g_varchar2_table(86) := '4C6963656E736520666F72207468650D0A2020202020436F766572656420536F6674776172652E20496620746865204C617267657220576F726B206973206120636F6D62696E6174696F6E206F6620436F766572656420536F6674776172650D0A202020';
wwv_flow_imp.g_varchar2_table(87) := '202077697468206120776F726B20676F7665726E6564206279206F6E65206F72206D6F7265205365636F6E64617279204C6963656E7365732C20616E642074686520436F76657265640D0A2020202020536F667477617265206973206E6F7420496E636F';
wwv_flow_imp.g_varchar2_table(88) := '6D70617469626C652057697468205365636F6E64617279204C6963656E7365732C2074686973204C6963656E7365207065726D6974730D0A2020202020596F7520746F206164646974696F6E616C6C792064697374726962757465207375636820436F76';
wwv_flow_imp.g_varchar2_table(89) := '6572656420536F66747761726520756E64657220746865207465726D73206F660D0A202020202073756368205365636F6E64617279204C6963656E73652873292C20736F20746861742074686520726563697069656E74206F6620746865204C61726765';
wwv_flow_imp.g_varchar2_table(90) := '7220576F726B206D61792C2061740D0A20202020207468656972206F7074696F6E2C206675727468657220646973747269627574652074686520436F766572656420536F66747761726520756E64657220746865207465726D73206F660D0A2020202020';
wwv_flow_imp.g_varchar2_table(91) := '6569746865722074686973204C6963656E7365206F722073756368205365636F6E64617279204C6963656E73652873292E0D0A0D0A332E342E204E6F74696365730D0A0D0A2020202020596F75206D6179206E6F742072656D6F7665206F7220616C7465';
wwv_flow_imp.g_varchar2_table(92) := '7220746865207375627374616E6365206F6620616E79206C6963656E7365206E6F74696365732028696E636C7564696E670D0A2020202020636F70797269676874206E6F74696365732C20706174656E74206E6F74696365732C20646973636C61696D65';
wwv_flow_imp.g_varchar2_table(93) := '7273206F662077617272616E74792C206F72206C696D69746174696F6E730D0A20202020206F66206C696162696C6974792920636F6E7461696E65642077697468696E2074686520536F7572636520436F646520466F726D206F662074686520436F7665';
wwv_flow_imp.g_varchar2_table(94) := '7265640D0A2020202020536F6674776172652C20657863657074207468617420596F75206D617920616C74657220616E79206C6963656E7365206E6F746963657320746F2074686520657874656E740D0A2020202020726571756972656420746F207265';
wwv_flow_imp.g_varchar2_table(95) := '6D656479206B6E6F776E206661637475616C20696E616363757261636965732E0D0A0D0A332E352E204170706C69636174696F6E206F66204164646974696F6E616C205465726D730D0A0D0A2020202020596F75206D61792063686F6F736520746F206F';
wwv_flow_imp.g_varchar2_table(96) := '666665722C20616E6420746F2063686172676520612066656520666F722C2077617272616E74792C20737570706F72742C0D0A2020202020696E64656D6E697479206F72206C696162696C697479206F626C69676174696F6E7320746F206F6E65206F72';
wwv_flow_imp.g_varchar2_table(97) := '206D6F726520726563697069656E7473206F6620436F76657265640D0A2020202020536F6674776172652E20486F77657665722C20596F75206D617920646F20736F206F6E6C79206F6E20596F7572206F776E20626568616C662C20616E64206E6F7420';
wwv_flow_imp.g_varchar2_table(98) := '6F6E20626568616C660D0A20202020206F6620616E7920436F6E7472696275746F722E20596F75206D757374206D616B65206974206162736F6C7574656C7920636C656172207468617420616E7920737563680D0A202020202077617272616E74792C20';
wwv_flow_imp.g_varchar2_table(99) := '737570706F72742C20696E64656D6E6974792C206F72206C696162696C697479206F626C69676174696F6E206973206F66666572656420627920596F750D0A2020202020616C6F6E652C20616E6420596F752068657265627920616772656520746F2069';
wwv_flow_imp.g_varchar2_table(100) := '6E64656D6E69667920657665727920436F6E7472696275746F7220666F7220616E790D0A20202020206C696162696C69747920696E637572726564206279207375636820436F6E7472696275746F72206173206120726573756C74206F66207761727261';
wwv_flow_imp.g_varchar2_table(101) := '6E74792C20737570706F72742C0D0A2020202020696E64656D6E697479206F72206C696162696C697479207465726D7320596F75206F666665722E20596F75206D617920696E636C756465206164646974696F6E616C0D0A2020202020646973636C6169';
wwv_flow_imp.g_varchar2_table(102) := '6D657273206F662077617272616E747920616E64206C696D69746174696F6E73206F66206C696162696C69747920737065636966696320746F20616E790D0A20202020206A7572697364696374696F6E2E0D0A0D0A342E20496E6162696C69747920746F';
wwv_flow_imp.g_varchar2_table(103) := '20436F6D706C792044756520746F2053746174757465206F7220526567756C6174696F6E0D0A0D0A202020496620697420697320696D706F737369626C6520666F7220596F7520746F20636F6D706C79207769746820616E79206F662074686520746572';
wwv_flow_imp.g_varchar2_table(104) := '6D73206F662074686973204C6963656E73650D0A20202077697468207265737065637420746F20736F6D65206F7220616C6C206F662074686520436F766572656420536F6674776172652064756520746F20737461747574652C206A7564696369616C0D';
wwv_flow_imp.g_varchar2_table(105) := '0A2020206F726465722C206F7220726567756C6174696F6E207468656E20596F75206D7573743A2028612920636F6D706C79207769746820746865207465726D73206F662074686973204C6963656E73650D0A202020746F20746865206D6178696D756D';
wwv_flow_imp.g_varchar2_table(106) := '20657874656E7420706F737369626C653B20616E642028622920646573637269626520746865206C696D69746174696F6E7320616E642074686520636F64650D0A20202074686579206166666563742E2053756368206465736372697074696F6E206D75';
wwv_flow_imp.g_varchar2_table(107) := '737420626520706C6163656420696E206120746578742066696C6520696E636C75646564207769746820616C6C0D0A202020646973747269627574696F6E73206F662074686520436F766572656420536F66747761726520756E6465722074686973204C';
wwv_flow_imp.g_varchar2_table(108) := '6963656E73652E2045786365707420746F207468650D0A202020657874656E742070726F686962697465642062792073746174757465206F7220726567756C6174696F6E2C2073756368206465736372697074696F6E206D7573742062650D0A20202073';
wwv_flow_imp.g_varchar2_table(109) := '756666696369656E746C792064657461696C656420666F72206120726563697069656E74206F66206F7264696E61727920736B696C6C20746F2062652061626C6520746F0D0A202020756E6465727374616E642069742E0D0A0D0A352E205465726D696E';
wwv_flow_imp.g_varchar2_table(110) := '6174696F6E0D0A0D0A352E312E2054686520726967687473206772616E74656420756E6465722074686973204C6963656E73652077696C6C207465726D696E617465206175746F6D61746963616C6C7920696620596F750D0A20202020206661696C2074';
wwv_flow_imp.g_varchar2_table(111) := '6F20636F6D706C79207769746820616E79206F6620697473207465726D732E20486F77657665722C20696620596F75206265636F6D6520636F6D706C69616E742C0D0A20202020207468656E2074686520726967687473206772616E74656420756E6465';
wwv_flow_imp.g_varchar2_table(112) := '722074686973204C6963656E73652066726F6D206120706172746963756C617220436F6E7472696275746F720D0A2020202020617265207265696E737461746564202861292070726F766973696F6E616C6C792C20756E6C65737320616E6420756E7469';
wwv_flow_imp.g_varchar2_table(113) := '6C207375636820436F6E7472696275746F720D0A20202020206578706C696369746C7920616E642066696E616C6C79207465726D696E6174657320596F7572206772616E74732C20616E6420286229206F6E20616E206F6E676F696E672062617369732C';
wwv_flow_imp.g_varchar2_table(114) := '0D0A20202020206966207375636820436F6E7472696275746F72206661696C7320746F206E6F7469667920596F75206F6620746865206E6F6E2D636F6D706C69616E636520627920736F6D650D0A2020202020726561736F6E61626C65206D65616E7320';
wwv_flow_imp.g_varchar2_table(115) := '7072696F7220746F203630206461797320616674657220596F75206861766520636F6D65206261636B20696E746F20636F6D706C69616E63652E0D0A20202020204D6F72656F7665722C20596F7572206772616E74732066726F6D206120706172746963';
wwv_flow_imp.g_varchar2_table(116) := '756C617220436F6E7472696275746F7220617265207265696E737461746564206F6E20616E0D0A20202020206F6E676F696E67206261736973206966207375636820436F6E7472696275746F72206E6F74696669657320596F75206F6620746865206E6F';
wwv_flow_imp.g_varchar2_table(117) := '6E2D636F6D706C69616E63652062790D0A2020202020736F6D6520726561736F6E61626C65206D65616E732C2074686973206973207468652066697273742074696D6520596F752068617665207265636569766564206E6F74696365206F660D0A202020';
wwv_flow_imp.g_varchar2_table(118) := '20206E6F6E2D636F6D706C69616E636520776974682074686973204C6963656E73652066726F6D207375636820436F6E7472696275746F722C20616E6420596F75206265636F6D650D0A2020202020636F6D706C69616E74207072696F7220746F203330';
wwv_flow_imp.g_varchar2_table(119) := '206461797320616674657220596F75722072656365697074206F6620746865206E6F746963652E0D0A0D0A352E322E20496620596F7520696E697469617465206C697469676174696F6E20616761696E737420616E7920656E7469747920627920617373';
wwv_flow_imp.g_varchar2_table(120) := '657274696E67206120706174656E740D0A2020202020696E6672696E67656D656E7420636C61696D20286578636C7564696E67206465636C617261746F7279206A7564676D656E7420616374696F6E732C20636F756E7465722D636C61696D732C0D0A20';
wwv_flow_imp.g_varchar2_table(121) := '20202020616E642063726F73732D636C61696D732920616C6C6567696E672074686174206120436F6E7472696275746F722056657273696F6E206469726563746C79206F720D0A2020202020696E6469726563746C7920696E6672696E67657320616E79';
wwv_flow_imp.g_varchar2_table(122) := '20706174656E742C207468656E2074686520726967687473206772616E74656420746F20596F7520627920616E7920616E640D0A2020202020616C6C20436F6E7472696275746F727320666F722074686520436F766572656420536F6674776172652075';
wwv_flow_imp.g_varchar2_table(123) := '6E6465722053656374696F6E20322E31206F662074686973204C6963656E73650D0A20202020207368616C6C207465726D696E6174652E0D0A0D0A352E332E20496E20746865206576656E74206F66207465726D696E6174696F6E20756E646572205365';
wwv_flow_imp.g_varchar2_table(124) := '6374696F6E7320352E31206F7220352E322061626F76652C20616C6C20656E6420757365720D0A20202020206C6963656E73652061677265656D656E747320286578636C7564696E67206469737472696275746F727320616E6420726573656C6C657273';
wwv_flow_imp.g_varchar2_table(125) := '292077686963682068617665206265656E0D0A202020202076616C69646C79206772616E74656420627920596F75206F7220596F7572206469737472696275746F727320756E6465722074686973204C6963656E7365207072696F7220746F0D0A202020';
wwv_flow_imp.g_varchar2_table(126) := '20207465726D696E6174696F6E207368616C6C2073757276697665207465726D696E6174696F6E2E0D0A0D0A362E20446973636C61696D6572206F662057617272616E74790D0A0D0A202020436F766572656420536F6674776172652069732070726F76';
wwv_flow_imp.g_varchar2_table(127) := '6964656420756E6465722074686973204C6963656E7365206F6E20616E20936173206973942062617369732C20776974686F75740D0A20202077617272616E7479206F6620616E79206B696E642C20656974686572206578707265737365642C20696D70';
wwv_flow_imp.g_varchar2_table(128) := '6C6965642C206F72207374617475746F72792C20696E636C7564696E672C0D0A202020776974686F7574206C696D69746174696F6E2C2077617272616E7469657320746861742074686520436F766572656420536F667477617265206973206672656520';
wwv_flow_imp.g_varchar2_table(129) := '6F6620646566656374732C0D0A2020206D65726368616E7461626C652C2066697420666F72206120706172746963756C617220707572706F7365206F72206E6F6E2D696E6672696E67696E672E2054686520656E746972650D0A2020207269736B206173';
wwv_flow_imp.g_varchar2_table(130) := '20746F20746865207175616C69747920616E6420706572666F726D616E6365206F662074686520436F766572656420536F667477617265206973207769746820596F752E0D0A20202053686F756C6420616E7920436F766572656420536F667477617265';
wwv_flow_imp.g_varchar2_table(131) := '2070726F76652064656665637469766520696E20616E7920726573706563742C20596F7520286E6F7420616E790D0A202020436F6E7472696275746F722920617373756D652074686520636F7374206F6620616E79206E65636573736172792073657276';
wwv_flow_imp.g_varchar2_table(132) := '6963696E672C207265706169722C206F720D0A202020636F7272656374696F6E2E205468697320646973636C61696D6572206F662077617272616E747920636F6E737469747574657320616E20657373656E7469616C2070617274206F6620746869730D';
wwv_flow_imp.g_varchar2_table(133) := '0A2020204C6963656E73652E204E6F20757365206F662020616E7920436F766572656420536F66747761726520697320617574686F72697A656420756E6465722074686973204C6963656E73650D0A20202065786365707420756E646572207468697320';
wwv_flow_imp.g_varchar2_table(134) := '646973636C61696D65722E0D0A0D0A372E204C696D69746174696F6E206F66204C696162696C6974790D0A0D0A202020556E646572206E6F2063697263756D7374616E63657320616E6420756E646572206E6F206C6567616C207468656F72792C207768';
wwv_flow_imp.g_varchar2_table(135) := '657468657220746F72742028696E636C7564696E670D0A2020206E65676C6967656E6365292C20636F6E74726163742C206F72206F74686572776973652C207368616C6C20616E7920436F6E7472696275746F722C206F7220616E796F6E652077686F0D';
wwv_flow_imp.g_varchar2_table(136) := '0A202020646973747269627574657320436F766572656420536F667477617265206173207065726D69747465642061626F76652C206265206C6961626C6520746F20596F7520666F7220616E790D0A2020206469726563742C20696E6469726563742C20';
wwv_flow_imp.g_varchar2_table(137) := '7370656369616C2C20696E636964656E74616C2C206F7220636F6E73657175656E7469616C2064616D61676573206F6620616E790D0A20202063686172616374657220696E636C7564696E672C20776974686F7574206C696D69746174696F6E2C206461';
wwv_flow_imp.g_varchar2_table(138) := '6D6167657320666F72206C6F73742070726F666974732C206C6F7373206F660D0A202020676F6F6477696C6C2C20776F726B2073746F70706167652C20636F6D7075746572206661696C757265206F72206D616C66756E6374696F6E2C206F7220616E79';
wwv_flow_imp.g_varchar2_table(139) := '20616E6420616C6C0D0A2020206F7468657220636F6D6D65726369616C2064616D61676573206F72206C6F737365732C206576656E2069662073756368207061727479207368616C6C2068617665206265656E0D0A202020696E666F726D6564206F6620';
wwv_flow_imp.g_varchar2_table(140) := '74686520706F73736962696C697479206F6620737563682064616D616765732E2054686973206C696D69746174696F6E206F66206C696162696C6974790D0A2020207368616C6C206E6F74206170706C7920746F206C696162696C69747920666F722064';
wwv_flow_imp.g_varchar2_table(141) := '65617468206F7220706572736F6E616C20696E6A75727920726573756C74696E672066726F6D20737563680D0A20202070617274799273206E65676C6967656E636520746F2074686520657874656E74206170706C696361626C65206C61772070726F68';
wwv_flow_imp.g_varchar2_table(142) := '69626974732073756368206C696D69746174696F6E2E0D0A202020536F6D65206A7572697364696374696F6E7320646F206E6F7420616C6C6F7720746865206578636C7573696F6E206F72206C696D69746174696F6E206F6620696E636964656E74616C';
wwv_flow_imp.g_varchar2_table(143) := '206F720D0A202020636F6E73657175656E7469616C2064616D616765732C20736F2074686973206578636C7573696F6E20616E64206C696D69746174696F6E206D6179206E6F74206170706C7920746F20596F752E0D0A0D0A382E204C69746967617469';
wwv_flow_imp.g_varchar2_table(144) := '6F6E0D0A0D0A202020416E79206C697469676174696F6E2072656C6174696E6720746F2074686973204C6963656E7365206D61792062652062726F75676874206F6E6C7920696E2074686520636F75727473206F660D0A20202061206A75726973646963';
wwv_flow_imp.g_varchar2_table(145) := '74696F6E2077686572652074686520646566656E64616E74206D61696E7461696E7320697473207072696E636970616C20706C616365206F6620627573696E6573730D0A202020616E642073756368206C697469676174696F6E207368616C6C20626520';
wwv_flow_imp.g_varchar2_table(146) := '676F7665726E6564206279206C617773206F662074686174206A7572697364696374696F6E2C20776974686F75740D0A2020207265666572656E636520746F2069747320636F6E666C6963742D6F662D6C61772070726F766973696F6E732E204E6F7468';
wwv_flow_imp.g_varchar2_table(147) := '696E6720696E20746869732053656374696F6E207368616C6C0D0A20202070726576656E7420612070617274799273206162696C69747920746F206272696E672063726F73732D636C61696D73206F7220636F756E7465722D636C61696D732E0D0A0D0A';
wwv_flow_imp.g_varchar2_table(148) := '392E204D697363656C6C616E656F75730D0A0D0A20202054686973204C6963656E736520726570726573656E74732074686520636F6D706C6574652061677265656D656E7420636F6E6365726E696E6720746865207375626A656374206D61747465720D';
wwv_flow_imp.g_varchar2_table(149) := '0A202020686572656F662E20496620616E792070726F766973696F6E206F662074686973204C6963656E73652069732068656C6420746F20626520756E656E666F72636561626C652C20737563680D0A20202070726F766973696F6E207368616C6C2062';
wwv_flow_imp.g_varchar2_table(150) := '65207265666F726D6564206F6E6C7920746F2074686520657874656E74206E656365737361727920746F206D616B652069740D0A202020656E666F72636561626C652E20416E79206C6177206F7220726567756C6174696F6E2077686963682070726F76';
wwv_flow_imp.g_varchar2_table(151) := '69646573207468617420746865206C616E6775616765206F6620610D0A202020636F6E7472616374207368616C6C20626520636F6E73747275656420616761696E7374207468652064726166746572207368616C6C206E6F74206265207573656420746F';
wwv_flow_imp.g_varchar2_table(152) := '20636F6E73747275650D0A20202074686973204C6963656E736520616761696E7374206120436F6E7472696275746F722E0D0A0D0A0D0A31302E2056657273696F6E73206F6620746865204C6963656E73650D0A0D0A31302E312E204E65772056657273';
wwv_flow_imp.g_varchar2_table(153) := '696F6E730D0A0D0A2020202020204D6F7A696C6C6120466F756E646174696F6E20697320746865206C6963656E736520737465776172642E204578636570742061732070726F766964656420696E2053656374696F6E0D0A20202020202031302E332C20';
wwv_flow_imp.g_varchar2_table(154) := '6E6F206F6E65206F74686572207468616E20746865206C6963656E73652073746577617264206861732074686520726967687420746F206D6F64696679206F720D0A2020202020207075626C697368206E65772076657273696F6E73206F662074686973';
wwv_flow_imp.g_varchar2_table(155) := '204C6963656E73652E20456163682076657273696F6E2077696C6C20626520676976656E20610D0A20202020202064697374696E6775697368696E672076657273696F6E206E756D6265722E0D0A0D0A31302E322E20456666656374206F66204E657720';
wwv_flow_imp.g_varchar2_table(156) := '56657273696F6E730D0A0D0A202020202020596F75206D617920646973747269627574652074686520436F766572656420536F66747761726520756E64657220746865207465726D73206F66207468652076657273696F6E206F660D0A20202020202074';
wwv_flow_imp.g_varchar2_table(157) := '6865204C6963656E736520756E64657220776869636820596F75206F726967696E616C6C792072656365697665642074686520436F766572656420536F6674776172652C206F720D0A202020202020756E64657220746865207465726D73206F6620616E';
wwv_flow_imp.g_varchar2_table(158) := '792073756273657175656E742076657273696F6E207075626C697368656420627920746865206C6963656E73650D0A202020202020737465776172642E0D0A0D0A31302E332E204D6F6469666965642056657273696F6E730D0A0D0A2020202020204966';
wwv_flow_imp.g_varchar2_table(159) := '20796F752063726561746520736F667477617265206E6F7420676F7665726E65642062792074686973204C6963656E73652C20616E6420796F752077616E7420746F0D0A2020202020206372656174652061206E6577206C6963656E736520666F722073';
wwv_flow_imp.g_varchar2_table(160) := '75636820736F6674776172652C20796F75206D61792063726561746520616E64207573652061206D6F6469666965640D0A20202020202076657273696F6E206F662074686973204C6963656E736520696620796F752072656E616D6520746865206C6963';
wwv_flow_imp.g_varchar2_table(161) := '656E736520616E642072656D6F766520616E790D0A2020202020207265666572656E63657320746F20746865206E616D65206F6620746865206C6963656E73652073746577617264202865786365707420746F206E6F7465207468617420737563680D0A';
wwv_flow_imp.g_varchar2_table(162) := '2020202020206D6F646966696564206C6963656E736520646966666572732066726F6D2074686973204C6963656E7365292E0D0A0D0A31302E342E20446973747269627574696E6720536F7572636520436F646520466F726D207468617420697320496E';
wwv_flow_imp.g_varchar2_table(163) := '636F6D70617469626C652057697468205365636F6E64617279204C6963656E7365730D0A202020202020496620596F752063686F6F736520746F206469737472696275746520536F7572636520436F646520466F726D207468617420697320496E636F6D';
wwv_flow_imp.g_varchar2_table(164) := '70617469626C6520576974680D0A2020202020205365636F6E64617279204C6963656E73657320756E64657220746865207465726D73206F6620746869732076657273696F6E206F6620746865204C6963656E73652C207468650D0A2020202020206E6F';
wwv_flow_imp.g_varchar2_table(165) := '746963652064657363726962656420696E20457868696269742042206F662074686973204C6963656E7365206D7573742062652061747461636865642E0D0A0D0A457868696269742041202D20536F7572636520436F646520466F726D204C6963656E73';
wwv_flow_imp.g_varchar2_table(166) := '65204E6F746963650D0A0D0A2020202020205468697320536F7572636520436F646520466F726D206973207375626A65637420746F207468650D0A2020202020207465726D73206F6620746865204D6F7A696C6C61205075626C6963204C6963656E7365';
wwv_flow_imp.g_varchar2_table(167) := '2C20762E0D0A202020202020322E302E204966206120636F7079206F6620746865204D504C20776173206E6F740D0A2020202020206469737472696275746564207769746820746869732066696C652C20596F752063616E0D0A2020202020206F627461';
wwv_flow_imp.g_varchar2_table(168) := '696E206F6E652061740D0A202020202020687474703A2F2F6D6F7A696C6C612E6F72672F4D504C2F322E302F2E0D0A0D0A4966206974206973206E6F7420706F737369626C65206F7220646573697261626C6520746F2070757420746865206E6F746963';
wwv_flow_imp.g_varchar2_table(169) := '6520696E206120706172746963756C61722066696C652C207468656E0D0A596F75206D617920696E636C75646520746865206E6F7469636520696E2061206C6F636174696F6E2028737563682061732061204C4943454E53452066696C6520696E206120';
wwv_flow_imp.g_varchar2_table(170) := '72656C6576616E740D0A6469726563746F727929207768657265206120726563697069656E7420776F756C64206265206C696B656C7920746F206C6F6F6B20666F7220737563682061206E6F746963652E0D0A0D0A596F75206D61792061646420616464';
wwv_flow_imp.g_varchar2_table(171) := '6974696F6E616C206163637572617465206E6F7469636573206F6620636F70797269676874206F776E6572736869702E0D0A0D0A457868696269742042202D2093496E636F6D70617469626C652057697468205365636F6E64617279204C6963656E7365';
wwv_flow_imp.g_varchar2_table(172) := '7394204E6F746963650D0A0D0A2020202020205468697320536F7572636520436F646520466F726D2069732093496E636F6D70617469626C650D0A20202020202057697468205365636F6E64617279204C6963656E736573942C20617320646566696E65';
wwv_flow_imp.g_varchar2_table(173) := '642062790D0A202020202020746865204D6F7A696C6C61205075626C6963204C6963656E73652C20762E20322E302E';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(233155359974766152)
,p_plugin_id=>wwv_flow_imp.id(138494323700459718664)
,p_file_name=>'LICENSE4LIBS'
,p_mime_type=>'application/octet-stream'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E746F67676C654E6F74696669636174696F6E737B6D617267696E2D72696768743A3870783B706F736974696F6E3A72656C61746976653B646973706C61793A2D7765626B69742D696E6C696E652D626F783B646973706C61793A2D6D732D696E6C696E';
wwv_flow_imp.g_varchar2_table(2) := '652D666C6578626F783B646973706C61793A696E6C696E652D666C65783B666C6F61743A72696768743B6865696768743A323870783B77696474683A323870783B2D7765626B69742D757365722D73656C6563743A6E6F6E653B2D6D6F7A2D757365722D';
wwv_flow_imp.g_varchar2_table(3) := '73656C6563743A6E6F6E653B2D6D732D757365722D73656C6563743A6E6F6E653B757365722D73656C6563743A6E6F6E653B637572736F723A706F696E7465727D2E746F67676C654E6F74696669636174696F6E73202E73686F777B2D7765626B69742D';
wwv_flow_imp.g_varchar2_table(4) := '626F782D666C65783A313B2D6D732D666C65783A313B666C65783A313B6D617267696E3A6175746F3B6865696768743A323870783B6D61782D77696474683A323870783B746578742D616C69676E3A63656E7465723B626F726465722D7261646975733A';
wwv_flow_imp.g_varchar2_table(5) := '3530253B6261636B67726F756E643A7267626128302C302C302C2E35293B666F6E742D73697A653A323870783B2D7765626B69742D7472616E736974696F6E3A616C6C2031733B7472616E736974696F6E3A616C6C2031733B637572736F723A706F696E';
wwv_flow_imp.g_varchar2_table(6) := '7465727D2E746F67676C654E6F74696669636174696F6E73202E73686F773A686F7665727B6261636B67726F756E643A233030307D2E746F67676C654E6F74696669636174696F6E73202E73686F7720697B6C696E652D6865696768743A323870783B63';
wwv_flow_imp.g_varchar2_table(7) := '6F6C6F723A236666667D2E746F67676C654E6F74696669636174696F6E73202E636F756E747B706F736974696F6E3A6162736F6C7574653B746F703A2D3270783B72696768743A3770783B637572736F723A706F696E7465727D2E746F67676C654E6F74';
wwv_flow_imp.g_varchar2_table(8) := '696669636174696F6E73202E636F756E74202E6E756D7B706F736974696F6E3A6162736F6C7574653B746F703A303B6C6566743A303B6261636B67726F756E643A236632323B626F726465722D7261646975733A3530253B77696474683A313870783B68';
wwv_flow_imp.g_varchar2_table(9) := '65696768743A313870783B746578742D616C69676E3A63656E7465723B6C696E652D6865696768743A313470783B666F6E742D73697A653A313170783B2D7765626B69742D626F782D736861646F773A302031707820337078207267626128302C302C30';
wwv_flow_imp.g_varchar2_table(10) := '2C2E3235293B626F782D736861646F773A302031707820337078207267626128302C302C302C2E3235293B626F726465723A31707820736F6C696420726762612837302C37302C37302C2E32293B2D7765626B69742D7472616E736974696F6E3A616C6C';
wwv_flow_imp.g_varchar2_table(11) := '202E33733B7472616E736974696F6E3A616C6C202E33733B636F6C6F723A236666667D2E6E6F74696669636174696F6E737B706F736974696F6E3A66697865643B746F703A343270783B72696768743A313070783B77696474683A34303070783B626163';
wwv_flow_imp.g_varchar2_table(12) := '6B67726F756E643A72676261283235302C3235302C3235302C31293B626F726465722D7261646975733A3270783B2D7765626B69742D626F782D736861646F773A302033707820367078207267626128302C302C302C2E35293B626F782D736861646F77';
wwv_flow_imp.g_varchar2_table(13) := '3A302033707820367078207267626128302C302C302C2E35293B7A2D696E6465783A393939393B6D61782D6865696768743A373576683B6F766572666C6F773A6175746F7D406D65646961206F6E6C792073637265656E20616E6420286D61782D776964';
wwv_flow_imp.g_varchar2_table(14) := '74683A3638307078297B2E6E6F74696669636174696F6E737B77696474683A383576773B6D61782D77696474683A34303070787D7D2E6E6F74696669636174696F6E73202E6E6F74657B6D617267696E3A30203570783B626F726465722D626F74746F6D';
wwv_flow_imp.g_varchar2_table(15) := '3A31707820736F6C696420236536653665363B6C696E652D6865696768743A313070783B6F766572666C6F773A68696464656E3B636F6C6F723A233436343634363B70616464696E672D6C6566743A3570783B706F736974696F6E3A72656C6174697665';
wwv_flow_imp.g_varchar2_table(16) := '7D2E6E6F74696669636174696F6E73202E6E6F7465202E6163636570742D612C2E6E6F74696669636174696F6E73202E6E6F7465202E6465636C696E652D617B706F736974696F6E3A6162736F6C7574653B626F74746F6D3A313070783B72696768743A';
wwv_flow_imp.g_varchar2_table(17) := '3570787D2E6E6F74696669636174696F6E73202E6E6F7465202E6E6F74652D696E666F7B646973706C61793A626C6F636B3B70616464696E673A302033307078203230707820343070783B6F766572666C6F772D777261703A627265616B2D776F72643B';
wwv_flow_imp.g_varchar2_table(18) := '776F72642D777261703A627265616B2D776F72643B2D6D732D68797068656E733A6175746F3B2D6D6F7A2D68797068656E733A6175746F3B2D7765626B69742D68797068656E733A6175746F3B68797068656E733A6175746F3B77696474683A31303025';
wwv_flow_imp.g_varchar2_table(19) := '3B6C696E652D6865696768743A323070787D406B65796672616D65732066612D626C696E6B7B30257B6F7061636974793A317D3530257B6F7061636974793A307D313030257B6F7061636974793A317D7D2E66612D626C696E6B7B2D7765626B69742D61';
wwv_flow_imp.g_varchar2_table(20) := '6E696D6174696F6E3A66612D626C696E6B203273206C696E65617220696E66696E6974653B2D6D6F7A2D616E696D6174696F6E3A66612D626C696E6B203273206C696E65617220696E66696E6974653B2D6D732D616E696D6174696F6E3A66612D626C69';
wwv_flow_imp.g_varchar2_table(21) := '6E6B203273206C696E65617220696E66696E6974653B2D6F2D616E696D6174696F6E3A66612D626C696E6B203273206C696E65617220696E66696E6974653B616E696D6174696F6E3A66612D626C696E6B203273206C696E65617220696E66696E697465';
wwv_flow_imp.g_varchar2_table(22) := '7D2E6E6F74696669636174696F6E7320617B746578742D6465636F726174696F6E3A6E6F6E657D2E6E6F74696669636174696F6E73202E6E6F7465202E6E6F74652D6865616465727B666F6E742D7765696768743A3730303B746578742D6F766572666C';
wwv_flow_imp.g_varchar2_table(23) := '6F773A656C6C69707369733B6F766572666C6F773A68696464656E3B77686974652D73706163653A6E6F777261703B77696474683A313030253B70616464696E672D72696768743A313070783B6C696E652D6865696768743A343070787D2E6E6F746966';
wwv_flow_imp.g_varchar2_table(24) := '69636174696F6E73202E6E6F74653A66697273742D6F662D747970657B6D617267696E2D746F703A307D2E6E6F74696669636174696F6E73202E6E6F74653A686F7665727B626F782D736861646F773A2D35707820302030203020233436343634362169';
wwv_flow_imp.g_varchar2_table(25) := '6D706F7274616E747D2E6E6F74696669636174696F6E73202E6E6F7465202E6E6F74652D68656164657220697B706F736974696F6E3A72656C61746976653B746F703A2D3170783B6D617267696E2D72696768743A313070783B766572746963616C2D61';
wwv_flow_imp.g_varchar2_table(26) := '6C69676E3A6D6964646C653B77696474683A333070783B746578742D616C69676E3A63656E7465727D2E746F67676C654C6973747B7669736962696C6974793A68696464656E7D2E742D4E617669676174696F6E4261722D6974656D7B76657274696361';
wwv_flow_imp.g_varchar2_table(27) := '6C2D616C69676E3A6D6964646C657D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(233155800567766153)
,p_plugin_id=>wwv_flow_imp.id(138494323700459718664)
,p_file_name=>'anm.pkgd.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2166756E6374696F6E28652C74297B226F626A656374223D3D747970656F66206578706F727473262622756E646566696E656422213D747970656F66206D6F64756C653F6D6F64756C652E6578706F7274733D7428293A2266756E6374696F6E223D3D74';
wwv_flow_imp.g_varchar2_table(2) := '7970656F6620646566696E652626646566696E652E616D643F646566696E652874293A28653D657C7C73656C662C652E444F4D5075726966793D742829297D28746869732C66756E6374696F6E28297B2275736520737472696374223B66756E6374696F';
wwv_flow_imp.g_varchar2_table(3) := '6E20652865297B72657475726E2066756E6374696F6E2874297B666F7228766172206E3D617267756D656E74732E6C656E6774682C723D4172726179286E3E313F6E2D313A30292C613D313B613C6E3B612B2B29725B612D315D3D617267756D656E7473';
wwv_flow_imp.g_varchar2_table(4) := '5B615D3B72657475726E206728652C742C72297D7D66756E6374696F6E207428652C74297B6C26266C28652C6E756C6C293B666F7228766172206E3D742E6C656E6774683B6E2D2D3B297B76617220723D745B6E5D3B69662822737472696E67223D3D74';
wwv_flow_imp.g_varchar2_table(5) := '7970656F662072297B76617220613D762872293B61213D3D72262628732874297C7C28745B6E5D3D61292C723D61297D655B725D3D21307D72657475726E20657D66756E6374696F6E206E2865297B76617220743D6D286E756C6C292C6E3D766F696420';
wwv_flow_imp.g_varchar2_table(6) := '303B666F72286E20696E2065296728692C652C5B6E5D29262628745B6E5D3D655B6E5D293B72657475726E20747D66756E6374696F6E207228742C6E297B666F72283B6E756C6C213D3D743B297B76617220723D7528742C6E293B69662872297B696628';
wwv_flow_imp.g_varchar2_table(7) := '722E6765742972657475726E206528722E676574293B6966282266756E6374696F6E223D3D747970656F6620722E76616C75652972657475726E206528722E76616C7565297D743D632874297D72657475726E2066756E6374696F6E2865297B72657475';
wwv_flow_imp.g_varchar2_table(8) := '726E20636F6E736F6C652E7761726E282266616C6C6261636B2076616C756520666F72222C65292C6E756C6C7D7D66756E6374696F6E20612865297B69662841727261792E69734172726179286529297B666F722876617220743D302C6E3D4172726179';
wwv_flow_imp.g_varchar2_table(9) := '28652E6C656E677468293B743C652E6C656E6774683B742B2B296E5B745D3D655B745D3B72657475726E206E7D72657475726E2041727261792E66726F6D2865297D66756E6374696F6E206F28297B76617220653D617267756D656E74732E6C656E6774';
wwv_flow_imp.g_varchar2_table(10) := '683E302626766F69642030213D3D617267756D656E74735B305D3F617267756D656E74735B305D3A5728292C693D66756E6374696F6E2865297B72657475726E206F2865297D3B696628692E76657273696F6E3D22322E332E34222C692E72656D6F7665';
wwv_flow_imp.g_varchar2_table(11) := '643D5B5D2C21657C7C21652E646F63756D656E747C7C39213D3D652E646F63756D656E742E6E6F6465547970652972657475726E20692E6973537570706F727465643D21312C693B766172206C3D652E646F63756D656E742C733D652E646F63756D656E';
wwv_flow_imp.g_varchar2_table(12) := '742C633D652E446F63756D656E74467261676D656E742C753D652E48544D4C54656D706C617465456C656D656E742C663D652E4E6F64652C6D3D652E456C656D656E742C703D652E4E6F646546696C7465722C673D652E4E616D65644E6F64654D61702C';
wwv_flow_imp.g_varchar2_table(13) := '683D766F696420303D3D3D673F652E4E616D65644E6F64654D61707C7C652E4D6F7A4E616D6564417474724D61703A672C583D652E48544D4C466F726D456C656D656E742C4B3D652E444F4D5061727365722C563D652E7472757374656454797065732C';
wwv_flow_imp.g_varchar2_table(14) := '593D6D2E70726F746F747970652C5A3D7228592C22636C6F6E654E6F646522292C513D7228592C226E6578745369626C696E6722292C65653D7228592C226368696C644E6F64657322292C74653D7228592C22706172656E744E6F646522293B69662822';
wwv_flow_imp.g_varchar2_table(15) := '66756E6374696F6E223D3D747970656F662075297B766172206E653D732E637265617465456C656D656E74282274656D706C61746522293B6E652E636F6E74656E7426266E652E636F6E74656E742E6F776E6572446F63756D656E74262628733D6E652E';
wwv_flow_imp.g_varchar2_table(16) := '636F6E74656E742E6F776E6572446F63756D656E74297D7661722072653D4A28562C6C292C61653D7265262646653F72652E63726561746548544D4C282222293A22222C6F653D732C69653D6F652E696D706C656D656E746174696F6E2C6C653D6F652E';
wwv_flow_imp.g_varchar2_table(17) := '6372656174654E6F64654974657261746F722C73653D6F652E637265617465446F63756D656E74467261676D656E742C63653D6F652E676574456C656D656E747342795461674E616D652C75653D6C2E696D706F72744E6F64652C64653D7B7D3B747279';
wwv_flow_imp.g_varchar2_table(18) := '7B64653D6E2873292E646F63756D656E744D6F64653F732E646F63756D656E744D6F64653A7B7D7D63617463682865297B7D7661722066653D7B7D3B692E6973537570706F727465643D2266756E6374696F6E223D3D747970656F662074652626696526';
wwv_flow_imp.g_varchar2_table(19) := '26766F69642030213D3D69652E63726561746548544D4C446F63756D656E74262639213D3D64653B766172206D653D242C70653D422C67653D7A2C68653D552C4E653D6A2C79653D472C54653D502C76653D6E756C6C2C45653D74287B7D2C5B5D2E636F';
wwv_flow_imp.g_varchar2_table(20) := '6E63617428612841292C61286B292C612878292C61284C292C6128492929292C62653D6E756C6C2C4F653D74287B7D2C5B5D2E636F6E63617428612852292C61284D292C612846292C6128482929292C43653D4F626A6563742E7365616C284F626A6563';
wwv_flow_imp.g_varchar2_table(21) := '742E637265617465286E756C6C2C7B7461674E616D65436865636B3A7B7772697461626C653A21302C636F6E666967757261626C653A21312C656E756D657261626C653A21302C76616C75653A6E756C6C7D2C6174747269627574654E616D6543686563';
wwv_flow_imp.g_varchar2_table(22) := '6B3A7B7772697461626C653A21302C636F6E666967757261626C653A21312C656E756D657261626C653A21302C76616C75653A6E756C6C7D2C616C6C6F77437573746F6D697A65644275696C74496E456C656D656E74733A7B7772697461626C653A2130';
wwv_flow_imp.g_varchar2_table(23) := '2C636F6E666967757261626C653A21312C656E756D657261626C653A21302C76616C75653A21317D7D29292C5F653D6E756C6C2C77653D6E756C6C2C41653D21302C6B653D21302C78653D21312C44653D21312C4C653D21312C53653D21312C49653D21';
wwv_flow_imp.g_varchar2_table(24) := '312C52653D21312C4D653D21312C46653D21312C48653D21302C24653D21302C42653D21312C7A653D7B7D2C55653D6E756C6C2C50653D74287B7D2C5B22616E6E6F746174696F6E2D786D6C222C22617564696F222C22636F6C67726F7570222C226465';
wwv_flow_imp.g_varchar2_table(25) := '7363222C22666F726569676E6F626A656374222C2268656164222C22696672616D65222C226D617468222C226D69222C226D6E222C226D6F222C226D73222C226D74657874222C226E6F656D626564222C226E6F6672616D6573222C226E6F7363726970';
wwv_flow_imp.g_varchar2_table(26) := '74222C22706C61696E74657874222C22736372697074222C227374796C65222C22737667222C2274656D706C617465222C227468656164222C227469746C65222C22766964656F222C22786D70225D292C6A653D6E756C6C2C47653D74287B7D2C5B2261';
wwv_flow_imp.g_varchar2_table(27) := '7564696F222C22766964656F222C22696D67222C22736F75726365222C22696D616765222C22747261636B225D292C71653D6E756C6C2C57653D74287B7D2C5B22616C74222C22636C617373222C22666F72222C226964222C226C6162656C222C226E61';
wwv_flow_imp.g_varchar2_table(28) := '6D65222C227061747465726E222C22706C616365686F6C646572222C22726F6C65222C2273756D6D617279222C227469746C65222C2276616C7565222C227374796C65222C22786D6C6E73225D292C4A653D22687474703A2F2F7777772E77332E6F7267';
wwv_flow_imp.g_varchar2_table(29) := '2F313939382F4D6174682F4D6174684D4C222C58653D22687474703A2F2F7777772E77332E6F72672F323030302F737667222C4B653D22687474703A2F2F7777772E77332E6F72672F313939392F7868746D6C222C56653D4B652C59653D21312C5A653D';
wwv_flow_imp.g_varchar2_table(30) := '766F696420302C51653D5B226170706C69636174696F6E2F7868746D6C2B786D6C222C22746578742F68746D6C225D2C65743D766F696420302C74743D6E756C6C2C6E743D732E637265617465456C656D656E742822666F726D22292C72743D66756E63';
wwv_flow_imp.g_varchar2_table(31) := '74696F6E2865297B72657475726E206520696E7374616E63656F66205265674578707C7C6520696E7374616E63656F662046756E6374696F6E7D2C61743D66756E6374696F6E2865297B7474262674743D3D3D657C7C28652626226F626A656374223D3D';
wwv_flow_imp.g_varchar2_table(32) := '3D28766F696420303D3D3D653F22756E646566696E6564223A71286529297C7C28653D7B7D292C653D6E2865292C76653D22414C4C4F5745445F5441475322696E20653F74287B7D2C652E414C4C4F5745445F54414753293A45652C62653D22414C4C4F';
wwv_flow_imp.g_varchar2_table(33) := '5745445F4154545222696E20653F74287B7D2C652E414C4C4F5745445F41545452293A4F652C71653D224144445F5552495F534146455F4154545222696E20653F74286E285765292C652E4144445F5552495F534146455F41545452293A57652C6A653D';
wwv_flow_imp.g_varchar2_table(34) := '224144445F444154415F5552495F5441475322696E20653F74286E284765292C652E4144445F444154415F5552495F54414753293A47652C55653D22464F524249445F434F4E54454E545322696E20653F74287B7D2C652E464F524249445F434F4E5445';
wwv_flow_imp.g_varchar2_table(35) := '4E5453293A50652C5F653D22464F524249445F5441475322696E20653F74287B7D2C652E464F524249445F54414753293A7B7D2C77653D22464F524249445F4154545222696E20653F74287B7D2C652E464F524249445F41545452293A7B7D2C7A653D22';
wwv_flow_imp.g_varchar2_table(36) := '5553455F50524F46494C455322696E20652626652E5553455F50524F46494C45532C41653D2131213D3D652E414C4C4F575F415249415F415454522C6B653D2131213D3D652E414C4C4F575F444154415F415454522C78653D652E414C4C4F575F554E4B';
wwv_flow_imp.g_varchar2_table(37) := '4E4F574E5F50524F544F434F4C537C7C21312C44653D652E534146455F464F525F54454D504C415445537C7C21312C4C653D652E57484F4C455F444F43554D454E547C7C21312C52653D652E52455455524E5F444F4D7C7C21312C4D653D652E52455455';
wwv_flow_imp.g_varchar2_table(38) := '524E5F444F4D5F465241474D454E547C7C21312C46653D652E52455455524E5F545255535445445F545950457C7C21312C49653D652E464F5243455F424F44597C7C21312C48653D2131213D3D652E53414E4954495A455F444F4D2C24653D2131213D3D';
wwv_flow_imp.g_varchar2_table(39) := '652E4B4545505F434F4E54454E542C42653D652E494E5F504C4143457C7C21312C54653D652E414C4C4F5745445F5552495F5245474558507C7C54652C56653D652E4E414D4553504143457C7C4B652C652E435553544F4D5F454C454D454E545F48414E';
wwv_flow_imp.g_varchar2_table(40) := '444C494E472626727428652E435553544F4D5F454C454D454E545F48414E444C494E472E7461674E616D65436865636B2926262843652E7461674E616D65436865636B3D652E435553544F4D5F454C454D454E545F48414E444C494E472E7461674E616D';
wwv_flow_imp.g_varchar2_table(41) := '65436865636B292C652E435553544F4D5F454C454D454E545F48414E444C494E472626727428652E435553544F4D5F454C454D454E545F48414E444C494E472E6174747269627574654E616D65436865636B2926262843652E6174747269627574654E61';
wwv_flow_imp.g_varchar2_table(42) := '6D65436865636B3D652E435553544F4D5F454C454D454E545F48414E444C494E472E6174747269627574654E616D65436865636B292C652E435553544F4D5F454C454D454E545F48414E444C494E47262622626F6F6C65616E223D3D747970656F662065';
wwv_flow_imp.g_varchar2_table(43) := '2E435553544F4D5F454C454D454E545F48414E444C494E472E616C6C6F77437573746F6D697A65644275696C74496E456C656D656E747326262843652E616C6C6F77437573746F6D697A65644275696C74496E456C656D656E74733D652E435553544F4D';
wwv_flow_imp.g_varchar2_table(44) := '5F454C454D454E545F48414E444C494E472E616C6C6F77437573746F6D697A65644275696C74496E456C656D656E7473292C5A653D5A653D2D313D3D3D51652E696E6465784F6628652E5041525345525F4D454449415F54595045293F22746578742F68';
wwv_flow_imp.g_varchar2_table(45) := '746D6C223A652E5041525345525F4D454449415F545950452C65743D226170706C69636174696F6E2F7868746D6C2B786D6C223D3D3D5A653F66756E6374696F6E2865297B72657475726E20657D3A762C44652626286B653D2131292C4D652626285265';
wwv_flow_imp.g_varchar2_table(46) := '3D2130292C7A6526262876653D74287B7D2C5B5D2E636F6E636174286128492929292C62653D5B5D2C21303D3D3D7A652E68746D6C262628742876652C41292C742862652C5229292C21303D3D3D7A652E737667262628742876652C6B292C742862652C';
wwv_flow_imp.g_varchar2_table(47) := '4D292C742862652C4829292C21303D3D3D7A652E73766746696C74657273262628742876652C78292C742862652C4D292C742862652C4829292C21303D3D3D7A652E6D6174684D6C262628742876652C4C292C742862652C46292C742862652C48292929';
wwv_flow_imp.g_varchar2_table(48) := '2C652E4144445F5441475326262876653D3D3D456526262876653D6E28766529292C742876652C652E4144445F5441475329292C652E4144445F4154545226262862653D3D3D4F6526262862653D6E28626529292C742862652C652E4144445F41545452';
wwv_flow_imp.g_varchar2_table(49) := '29292C652E4144445F5552495F534146455F415454522626742871652C652E4144445F5552495F534146455F41545452292C652E464F524249445F434F4E54454E545326262855653D3D3D506526262855653D6E28556529292C742855652C652E464F52';
wwv_flow_imp.g_varchar2_table(50) := '4249445F434F4E54454E545329292C246526262876655B222374657874225D3D2130292C4C652626742876652C5B2268746D6C222C2268656164222C22626F6479225D292C76652E7461626C65262628742876652C5B2274626F6479225D292C64656C65';
wwv_flow_imp.g_varchar2_table(51) := '7465205F652E74626F6479292C642626642865292C74743D65297D2C6F743D74287B7D2C5B226D69222C226D6F222C226D6E222C226D73222C226D74657874225D292C69743D74287B7D2C5B22666F726569676E6F626A656374222C2264657363222C22';
wwv_flow_imp.g_varchar2_table(52) := '7469746C65222C22616E6E6F746174696F6E2D786D6C225D292C6C743D74287B7D2C6B293B74286C742C78292C74286C742C44293B7661722073743D74287B7D2C4C293B742873742C53293B7661722063743D66756E6374696F6E2865297B5428692E72';
wwv_flow_imp.g_varchar2_table(53) := '656D6F7665642C7B656C656D656E743A657D293B7472797B652E706172656E744E6F64652E72656D6F76654368696C642865297D63617463682874297B7472797B652E6F7574657248544D4C3D61657D63617463682874297B652E72656D6F766528297D';
wwv_flow_imp.g_varchar2_table(54) := '7D7D2C75743D66756E6374696F6E28652C74297B7472797B5428692E72656D6F7665642C7B6174747269627574653A742E6765744174747269627574654E6F64652865292C66726F6D3A747D297D63617463682865297B5428692E72656D6F7665642C7B';
wwv_flow_imp.g_varchar2_table(55) := '6174747269627574653A6E756C6C2C66726F6D3A747D297D696628742E72656D6F76654174747269627574652865292C226973223D3D3D6526262162655B655D2969662852657C7C4D65297472797B63742874297D63617463682865297B7D656C736520';
wwv_flow_imp.g_varchar2_table(56) := '7472797B742E73657441747472696275746528652C2222297D63617463682865297B7D7D2C64743D66756E6374696F6E2865297B76617220743D766F696420302C6E3D766F696420303B696628496529653D223C72656D6F76653E3C2F72656D6F76653E';
wwv_flow_imp.g_varchar2_table(57) := '222B653B656C73657B76617220723D4528652C2F5E5B5C725C6E5C74205D2B2F293B6E3D722626725B305D7D226170706C69636174696F6E2F7868746D6C2B786D6C223D3D3D5A65262628653D273C68746D6C20786D6C6E733D22687474703A2F2F7777';
wwv_flow_imp.g_varchar2_table(58) := '772E77332E6F72672F313939392F7868746D6C223E3C686561643E3C2F686561643E3C626F64793E272B652B223C2F626F64793E3C2F68746D6C3E22293B76617220613D72653F72652E63726561746548544D4C2865293A653B69662856653D3D3D4B65';
wwv_flow_imp.g_varchar2_table(59) := '297472797B743D286E6577204B292E706172736546726F6D537472696E6728612C5A65297D63617463682865297B7D69662821747C7C21742E646F63756D656E74456C656D656E74297B743D69652E637265617465446F63756D656E742856652C227465';
wwv_flow_imp.g_varchar2_table(60) := '6D706C617465222C6E756C6C293B7472797B742E646F63756D656E74456C656D656E742E696E6E657248544D4C3D59653F22223A617D63617463682865297B7D7D766172206F3D742E626F64797C7C742E646F63756D656E74456C656D656E743B726574';
wwv_flow_imp.g_varchar2_table(61) := '75726E206526266E26266F2E696E736572744265666F726528732E637265617465546578744E6F6465286E292C6F2E6368696C644E6F6465735B305D7C7C6E756C6C292C56653D3D3D4B653F63652E63616C6C28742C4C653F2268746D6C223A22626F64';
wwv_flow_imp.g_varchar2_table(62) := '7922295B305D3A4C653F742E646F63756D656E74456C656D656E743A6F7D2C66743D66756E6374696F6E2865297B72657475726E206C652E63616C6C28652E6F776E6572446F63756D656E747C7C652C652C702E53484F575F454C454D454E547C702E53';
wwv_flow_imp.g_varchar2_table(63) := '484F575F434F4D4D454E547C702E53484F575F544558542C6E756C6C2C2131297D2C6D743D66756E6374696F6E2865297B72657475726E226F626A656374223D3D3D28766F696420303D3D3D663F22756E646566696E6564223A71286629293F6520696E';
wwv_flow_imp.g_varchar2_table(64) := '7374616E63656F6620663A652626226F626A656374223D3D3D28766F696420303D3D3D653F22756E646566696E6564223A71286529292626226E756D626572223D3D747970656F6620652E6E6F646554797065262622737472696E67223D3D747970656F';
wwv_flow_imp.g_varchar2_table(65) := '6620652E6E6F64654E616D657D2C70743D66756E6374696F6E28652C742C6E297B66655B655D26264E2866655B655D2C66756E6374696F6E2865297B652E63616C6C28692C742C6E2C7474297D297D2C67743D66756E6374696F6E2865297B766172206E';
wwv_flow_imp.g_varchar2_table(66) := '3D766F696420303B696628707428226265666F726553616E6974697A65456C656D656E7473222C652C6E756C6C292C66756E6374696F6E2865297B72657475726E206520696E7374616E63656F66205826262822737472696E6722213D747970656F6620';
wwv_flow_imp.g_varchar2_table(67) := '652E6E6F64654E616D657C7C22737472696E6722213D747970656F6620652E74657874436F6E74656E747C7C2266756E6374696F6E22213D747970656F6620652E72656D6F76654368696C647C7C2128652E6174747269627574657320696E7374616E63';
wwv_flow_imp.g_varchar2_table(68) := '656F662068297C7C2266756E6374696F6E22213D747970656F6620652E72656D6F76654174747269627574657C7C2266756E6374696F6E22213D747970656F6620652E7365744174747269627574657C7C22737472696E6722213D747970656F6620652E';
wwv_flow_imp.g_varchar2_table(69) := '6E616D6573706163655552497C7C2266756E6374696F6E22213D747970656F6620652E696E736572744265666F7265297D2865292972657475726E2063742865292C21303B6966284528652E6E6F64654E616D652C2F5B5C75303038302D5C7546464646';
wwv_flow_imp.g_varchar2_table(70) := '5D2F292972657475726E2063742865292C21303B76617220723D657428652E6E6F64654E616D65293B6966287074282275706F6E53616E6974697A65456C656D656E74222C652C7B7461674E616D653A722C616C6C6F776564546167733A76657D292C21';
wwv_flow_imp.g_varchar2_table(71) := '6D7428652E6669727374456C656D656E744368696C6429262628216D7428652E636F6E74656E74297C7C216D7428652E636F6E74656E742E6669727374456C656D656E744368696C64292926265F282F3C5B2F5C775D2F672C652E696E6E657248544D4C';
wwv_flow_imp.g_varchar2_table(72) := '2926265F282F3C5B2F5C775D2F672C652E74657874436F6E74656E74292972657475726E2063742865292C21303B6966282273656C656374223D3D3D7226265F282F3C74656D706C6174652F692C652E696E6E657248544D4C292972657475726E206374';
wwv_flow_imp.g_varchar2_table(73) := '2865292C21303B6966282176655B725D7C7C5F655B725D297B696628246526262155655B725D297B76617220613D74652865297C7C652E706172656E744E6F64652C6F3D65652865297C7C652E6368696C644E6F6465733B6966286F26266129666F7228';
wwv_flow_imp.g_varchar2_table(74) := '766172206C3D6F2E6C656E6774682D313B6C3E3D303B2D2D6C29612E696E736572744265666F7265285A286F5B6C5D2C2130292C51286529297D696628215F655B725D26264E74287229297B69662843652E7461674E616D65436865636B20696E737461';
wwv_flow_imp.g_varchar2_table(75) := '6E63656F662052656745787026265F2843652E7461674E616D65436865636B2C72292972657475726E21313B69662843652E7461674E616D65436865636B20696E7374616E63656F662046756E6374696F6E262643652E7461674E616D65436865636B28';
wwv_flow_imp.g_varchar2_table(76) := '72292972657475726E21317D72657475726E2063742865292C21307D72657475726E206520696E7374616E63656F66206D26262166756E6374696F6E2865297B766172206E3D74652865293B6E26266E2E7461674E616D657C7C286E3D7B6E616D657370';
wwv_flow_imp.g_varchar2_table(77) := '6163655552493A4B652C7461674E616D653A2274656D706C617465227D293B76617220723D7628652E7461674E616D65292C613D76286E2E7461674E616D65293B696628652E6E616D6573706163655552493D3D3D58652972657475726E206E2E6E616D';
wwv_flow_imp.g_varchar2_table(78) := '6573706163655552493D3D3D4B653F22737667223D3D3D723A6E2E6E616D6573706163655552493D3D3D4A653F22737667223D3D3D7226262822616E6E6F746174696F6E2D786D6C223D3D3D617C7C6F745B615D293A426F6F6C65616E286C745B725D29';
wwv_flow_imp.g_varchar2_table(79) := '3B696628652E6E616D6573706163655552493D3D3D4A652972657475726E206E2E6E616D6573706163655552493D3D3D4B653F226D617468223D3D3D723A6E2E6E616D6573706163655552493D3D3D58653F226D617468223D3D3D72262669745B615D3A';
wwv_flow_imp.g_varchar2_table(80) := '426F6F6C65616E2873745B725D293B696628652E6E616D6573706163655552493D3D3D4B65297B6966286E2E6E616D6573706163655552493D3D3D586526262169745B615D2972657475726E21313B6966286E2E6E616D6573706163655552493D3D3D4A';
wwv_flow_imp.g_varchar2_table(81) := '652626216F745B615D2972657475726E21313B766172206F3D74287B7D2C5B227469746C65222C227374796C65222C22666F6E74222C2261222C22736372697074225D293B72657475726E2173745B725D2626286F5B725D7C7C216C745B725D297D7265';
wwv_flow_imp.g_varchar2_table(82) := '7475726E21317D2865293F2863742865292C2130293A226E6F73637269707422213D3D722626226E6F656D62656422213D3D727C7C215F282F3C5C2F6E6F287363726970747C656D626564292F692C652E696E6E657248544D4C293F2844652626333D3D';
wwv_flow_imp.g_varchar2_table(83) := '3D652E6E6F6465547970652626286E3D652E74657874436F6E74656E742C6E3D62286E2C6D652C222022292C6E3D62286E2C70652C222022292C652E74657874436F6E74656E74213D3D6E2626285428692E72656D6F7665642C7B656C656D656E743A65';
wwv_flow_imp.g_varchar2_table(84) := '2E636C6F6E654E6F646528297D292C652E74657874436F6E74656E743D6E29292C70742822616674657253616E6974697A65456C656D656E7473222C652C6E756C6C292C2131293A2863742865292C2130297D2C68743D66756E6374696F6E28652C742C';
wwv_flow_imp.g_varchar2_table(85) := '6E297B6966284865262628226964223D3D3D747C7C226E616D65223D3D3D74292626286E20696E20737C7C6E20696E206E74292972657475726E21313B6966286B6526262177655B745D26265F2867652C7429293B656C736520696628416526265F2868';
wwv_flow_imp.g_varchar2_table(86) := '652C7429293B656C7365206966282162655B745D7C7C77655B745D297B69662821284E7428652926262843652E7461674E616D65436865636B20696E7374616E63656F662052656745787026265F2843652E7461674E616D65436865636B2C65297C7C43';
wwv_flow_imp.g_varchar2_table(87) := '652E7461674E616D65436865636B20696E7374616E63656F662046756E6374696F6E262643652E7461674E616D65436865636B2865292926262843652E6174747269627574654E616D65436865636B20696E7374616E63656F662052656745787026265F';
wwv_flow_imp.g_varchar2_table(88) := '2843652E6174747269627574654E616D65436865636B2C74297C7C43652E6174747269627574654E616D65436865636B20696E7374616E63656F662046756E6374696F6E262643652E6174747269627574654E616D65436865636B287429297C7C226973';
wwv_flow_imp.g_varchar2_table(89) := '223D3D3D74262643652E616C6C6F77437573746F6D697A65644275696C74496E456C656D656E747326262843652E7461674E616D65436865636B20696E7374616E63656F662052656745787026265F2843652E7461674E616D65436865636B2C6E297C7C';
wwv_flow_imp.g_varchar2_table(90) := '43652E7461674E616D65436865636B20696E7374616E63656F662046756E6374696F6E262643652E7461674E616D65436865636B286E2929292972657475726E21317D656C73652069662871655B745D293B656C7365206966285F2854652C62286E2C79';
wwv_flow_imp.g_varchar2_table(91) := '652C22222929293B656C7365206966282273726322213D3D74262622786C696E6B3A6872656622213D3D742626226872656622213D3D747C7C22736372697074223D3D3D657C7C30213D3D4F286E2C22646174613A22297C7C216A655B655D297B696628';
wwv_flow_imp.g_varchar2_table(92) := '78652626215F284E652C62286E2C79652C22222929293B656C7365206966286E2972657475726E21317D656C73653B72657475726E21307D2C4E743D66756E6374696F6E2865297B72657475726E20652E696E6465784F6628222D22293E307D2C79743D';
wwv_flow_imp.g_varchar2_table(93) := '66756E6374696F6E2865297B76617220743D766F696420302C6E3D766F696420302C723D766F696420302C613D766F696420303B707428226265666F726553616E6974697A6541747472696275746573222C652C6E756C6C293B766172206F3D652E6174';
wwv_flow_imp.g_varchar2_table(94) := '74726962757465733B6966286F297B766172206C3D7B617474724E616D653A22222C6174747256616C75653A22222C6B656570417474723A21302C616C6C6F776564417474726962757465733A62657D3B666F7228613D6F2E6C656E6774683B612D2D3B';
wwv_flow_imp.g_varchar2_table(95) := '297B76617220733D743D6F5B615D2C633D732E6E616D652C753D732E6E616D6573706163655552493B6966286E3D4328742E76616C7565292C723D65742863292C6C2E617474724E616D653D722C6C2E6174747256616C75653D6E2C6C2E6B6565704174';
wwv_flow_imp.g_varchar2_table(96) := '74723D21302C6C2E666F7263654B656570417474723D766F696420302C7074282275706F6E53616E6974697A65417474726962757465222C652C6C292C6E3D6C2E6174747256616C75652C216C2E666F7263654B65657041747472262628757428632C65';
wwv_flow_imp.g_varchar2_table(97) := '292C6C2E6B6565704174747229296966285F282F5C2F3E2F692C6E2929757428632C65293B656C73657B44652626286E3D62286E2C6D652C222022292C6E3D62286E2C70652C22202229293B76617220643D657428652E6E6F64654E616D65293B696628';
wwv_flow_imp.g_varchar2_table(98) := '687428642C722C6E29297472797B753F652E7365744174747269627574654E5328752C632C6E293A652E73657441747472696275746528632C6E292C7928692E72656D6F766564297D63617463682865297B7D7D7D70742822616674657253616E697469';
wwv_flow_imp.g_varchar2_table(99) := '7A6541747472696275746573222C652C6E756C6C297D7D2C54743D66756E6374696F6E20652874297B766172206E3D766F696420302C723D66742874293B666F7228707428226265666F726553616E6974697A65536861646F77444F4D222C742C6E756C';
wwv_flow_imp.g_varchar2_table(100) := '6C293B6E3D722E6E6578744E6F646528293B297074282275706F6E53616E6974697A65536861646F774E6F6465222C6E2C6E756C6C292C6774286E297C7C286E2E636F6E74656E7420696E7374616E63656F662063262665286E2E636F6E74656E74292C';
wwv_flow_imp.g_varchar2_table(101) := '7974286E29293B70742822616674657253616E6974697A65536861646F77444F4D222C742C6E756C6C297D3B72657475726E20692E73616E6974697A653D66756E6374696F6E28742C6E297B76617220723D766F696420302C613D766F696420302C6F3D';
wwv_flow_imp.g_varchar2_table(102) := '766F696420302C733D766F696420302C753D766F696420303B6966282859653D217429262628743D225C783363212D2D5C78336522292C22737472696E6722213D747970656F6620742626216D74287429297B6966282266756E6374696F6E22213D7479';
wwv_flow_imp.g_varchar2_table(103) := '70656F6620742E746F537472696E67297468726F7720772822746F537472696E67206973206E6F7420612066756E6374696F6E22293B69662822737472696E6722213D747970656F6628743D742E746F537472696E67282929297468726F772077282264';
wwv_flow_imp.g_varchar2_table(104) := '69727479206973206E6F74206120737472696E672C2061626F7274696E6722297D69662821692E6973537570706F72746564297B696628226F626A656374223D3D3D7128652E746F53746174696348544D4C297C7C2266756E6374696F6E223D3D747970';
wwv_flow_imp.g_varchar2_table(105) := '656F6620652E746F53746174696348544D4C297B69662822737472696E67223D3D747970656F6620742972657475726E20652E746F53746174696348544D4C2874293B6966286D742874292972657475726E20652E746F53746174696348544D4C28742E';
wwv_flow_imp.g_varchar2_table(106) := '6F7574657248544D4C297D72657475726E20747D69662853657C7C6174286E292C692E72656D6F7665643D5B5D2C22737472696E67223D3D747970656F66207426262842653D2131292C4265293B656C7365206966287420696E7374616E63656F662066';
wwv_flow_imp.g_varchar2_table(107) := '29313D3D3D28613D28723D647428225C783363212D2D2D2D5C7833652229292E6F776E6572446F63756D656E742E696D706F72744E6F646528742C213029292E6E6F646554797065262622424F4459223D3D3D612E6E6F64654E616D653F723D613A2248';
wwv_flow_imp.g_varchar2_table(108) := '544D4C223D3D3D612E6E6F64654E616D653F723D613A722E617070656E644368696C642861293B656C73657B69662821526526262144652626214C6526262D313D3D3D742E696E6465784F6628223C22292972657475726E207265262646653F72652E63';
wwv_flow_imp.g_varchar2_table(109) := '726561746548544D4C2874293A743B6966282128723D6474287429292972657475726E2052653F6E756C6C3A61657D72262649652626637428722E66697273744368696C64293B666F722876617220643D66742842653F743A72293B6F3D642E6E657874';
wwv_flow_imp.g_varchar2_table(110) := '4E6F646528293B29333D3D3D6F2E6E6F64655479706526266F3D3D3D737C7C6774286F297C7C286F2E636F6E74656E7420696E7374616E63656F66206326265474286F2E636F6E74656E74292C7974286F292C733D6F293B696628733D6E756C6C2C4265';
wwv_flow_imp.g_varchar2_table(111) := '2972657475726E20743B6966285265297B6966284D6529666F7228753D73652E63616C6C28722E6F776E6572446F63756D656E74293B722E66697273744368696C643B29752E617070656E644368696C6428722E66697273744368696C64293B656C7365';
wwv_flow_imp.g_varchar2_table(112) := '20753D723B72657475726E2062652E736861646F77726F6F74262628753D75652E63616C6C286C2C752C213029292C757D766172206D3D4C653F722E6F7574657248544D4C3A722E696E6E657248544D4C3B72657475726E2044652626286D3D62286D2C';
wwv_flow_imp.g_varchar2_table(113) := '6D652C222022292C6D3D62286D2C70652C22202229292C7265262646653F72652E63726561746548544D4C286D293A6D7D2C692E736574436F6E6669673D66756E6374696F6E2865297B61742865292C53653D21307D2C692E636C656172436F6E666967';
wwv_flow_imp.g_varchar2_table(114) := '3D66756E6374696F6E28297B74743D6E756C6C2C53653D21317D2C692E697356616C69644174747269627574653D66756E6374696F6E28652C742C6E297B74747C7C6174287B7D293B76617220723D65742865292C613D65742874293B72657475726E20';
wwv_flow_imp.g_varchar2_table(115) := '687428722C612C6E297D2C692E616464486F6F6B3D66756E6374696F6E28652C74297B2266756E6374696F6E223D3D747970656F66207426262866655B655D3D66655B655D7C7C5B5D2C542866655B655D2C7429297D2C692E72656D6F7665486F6F6B3D';
wwv_flow_imp.g_varchar2_table(116) := '66756E6374696F6E2865297B66655B655D2626792866655B655D297D2C692E72656D6F7665486F6F6B733D66756E6374696F6E2865297B66655B655D26262866655B655D3D5B5D297D2C692E72656D6F7665416C6C486F6F6B733D66756E6374696F6E28';
wwv_flow_imp.g_varchar2_table(117) := '297B66653D7B7D7D2C697D76617220693D4F626A6563742E6861734F776E50726F70657274792C6C3D4F626A6563742E73657450726F746F747970654F662C733D4F626A6563742E697346726F7A656E2C633D4F626A6563742E67657450726F746F7479';
wwv_flow_imp.g_varchar2_table(118) := '70654F662C753D4F626A6563742E6765744F776E50726F706572747944657363726970746F722C643D4F626A6563742E667265657A652C663D4F626A6563742E7365616C2C6D3D4F626A6563742E6372656174652C703D22756E646566696E656422213D';
wwv_flow_imp.g_varchar2_table(119) := '747970656F66205265666C65637426265265666C6563742C673D702E6170706C792C683D702E636F6E7374727563743B677C7C28673D66756E6374696F6E28652C742C6E297B72657475726E20652E6170706C7928742C6E297D292C647C7C28643D6675';
wwv_flow_imp.g_varchar2_table(120) := '6E6374696F6E2865297B72657475726E20657D292C667C7C28663D66756E6374696F6E2865297B72657475726E20657D292C687C7C28683D66756E6374696F6E28652C74297B72657475726E206E65772846756E6374696F6E2E70726F746F747970652E';
wwv_flow_imp.g_varchar2_table(121) := '62696E642E6170706C7928652C5B6E756C6C5D2E636F6E6361742866756E6374696F6E2865297B69662841727261792E69734172726179286529297B666F722876617220743D302C6E3D417272617928652E6C656E677468293B743C652E6C656E677468';
wwv_flow_imp.g_varchar2_table(122) := '3B742B2B296E5B745D3D655B745D3B72657475726E206E7D72657475726E2041727261792E66726F6D2865297D2874292929297D293B766172204E3D652841727261792E70726F746F747970652E666F7245616368292C793D652841727261792E70726F';
wwv_flow_imp.g_varchar2_table(123) := '746F747970652E706F70292C543D652841727261792E70726F746F747970652E70757368292C763D6528537472696E672E70726F746F747970652E746F4C6F77657243617365292C453D6528537472696E672E70726F746F747970652E6D61746368292C';
wwv_flow_imp.g_varchar2_table(124) := '623D6528537472696E672E70726F746F747970652E7265706C616365292C4F3D6528537472696E672E70726F746F747970652E696E6465784F66292C433D6528537472696E672E70726F746F747970652E7472696D292C5F3D65285265674578702E7072';
wwv_flow_imp.g_varchar2_table(125) := '6F746F747970652E74657374292C773D66756E6374696F6E2865297B72657475726E2066756E6374696F6E28297B666F722876617220743D617267756D656E74732E6C656E6774682C6E3D41727261792874292C723D303B723C743B722B2B296E5B725D';
wwv_flow_imp.g_varchar2_table(126) := '3D617267756D656E74735B725D3B72657475726E206828652C6E297D7D28547970654572726F72292C413D64285B2261222C2261626272222C226163726F6E796D222C2261646472657373222C2261726561222C2261727469636C65222C226173696465';
wwv_flow_imp.g_varchar2_table(127) := '222C22617564696F222C2262222C22626469222C2262646F222C22626967222C22626C696E6B222C22626C6F636B71756F7465222C22626F6479222C226272222C22627574746F6E222C2263616E766173222C2263617074696F6E222C2263656E746572';
wwv_flow_imp.g_varchar2_table(128) := '222C2263697465222C22636F6465222C22636F6C222C22636F6C67726F7570222C22636F6E74656E74222C2264617461222C22646174616C697374222C226464222C226465636F7261746F72222C2264656C222C2264657461696C73222C2264666E222C';
wwv_flow_imp.g_varchar2_table(129) := '226469616C6F67222C22646972222C22646976222C22646C222C226474222C22656C656D656E74222C22656D222C226669656C64736574222C2266696763617074696F6E222C22666967757265222C22666F6E74222C22666F6F746572222C22666F726D';
wwv_flow_imp.g_varchar2_table(130) := '222C226831222C226832222C226833222C226834222C226835222C226836222C2268656164222C22686561646572222C226867726F7570222C226872222C2268746D6C222C2269222C22696D67222C22696E707574222C22696E73222C226B6264222C22';
wwv_flow_imp.g_varchar2_table(131) := '6C6162656C222C226C6567656E64222C226C69222C226D61696E222C226D6170222C226D61726B222C226D617271756565222C226D656E75222C226D656E756974656D222C226D65746572222C226E6176222C226E6F6272222C226F6C222C226F707467';
wwv_flow_imp.g_varchar2_table(132) := '726F7570222C226F7074696F6E222C226F7574707574222C2270222C2270696374757265222C22707265222C2270726F6772657373222C2271222C227270222C227274222C2272756279222C2273222C2273616D70222C2273656374696F6E222C227365';
wwv_flow_imp.g_varchar2_table(133) := '6C656374222C22736861646F77222C22736D616C6C222C22736F75726365222C22737061636572222C227370616E222C22737472696B65222C227374726F6E67222C227374796C65222C22737562222C2273756D6D617279222C22737570222C22746162';
wwv_flow_imp.g_varchar2_table(134) := '6C65222C2274626F6479222C227464222C2274656D706C617465222C227465787461726561222C2274666F6F74222C227468222C227468656164222C2274696D65222C227472222C22747261636B222C227474222C2275222C22756C222C22766172222C';
wwv_flow_imp.g_varchar2_table(135) := '22766964656F222C22776272225D292C6B3D64285B22737667222C2261222C22616C74676C797068222C22616C74676C797068646566222C22616C74676C7970686974656D222C22616E696D617465636F6C6F72222C22616E696D6174656D6F74696F6E';
wwv_flow_imp.g_varchar2_table(136) := '222C22616E696D6174657472616E73666F726D222C22636972636C65222C22636C697070617468222C2264656673222C2264657363222C22656C6C69707365222C2266696C746572222C22666F6E74222C2267222C22676C797068222C22676C79706872';
wwv_flow_imp.g_varchar2_table(137) := '6566222C22686B65726E222C22696D616765222C226C696E65222C226C696E6561726772616469656E74222C226D61726B6572222C226D61736B222C226D65746164617461222C226D70617468222C2270617468222C227061747465726E222C22706F6C';
wwv_flow_imp.g_varchar2_table(138) := '79676F6E222C22706F6C796C696E65222C2272616469616C6772616469656E74222C2272656374222C2273746F70222C227374796C65222C22737769746368222C2273796D626F6C222C2274657874222C227465787470617468222C227469746C65222C';
wwv_flow_imp.g_varchar2_table(139) := '2274726566222C22747370616E222C2276696577222C22766B65726E225D292C783D64285B226665426C656E64222C226665436F6C6F724D6174726978222C226665436F6D706F6E656E745472616E73666572222C226665436F6D706F73697465222C22';
wwv_flow_imp.g_varchar2_table(140) := '6665436F6E766F6C76654D6174726978222C226665446966667573654C69676874696E67222C226665446973706C6163656D656E744D6170222C22666544697374616E744C69676874222C226665466C6F6F64222C22666546756E6341222C2266654675';
wwv_flow_imp.g_varchar2_table(141) := '6E6342222C22666546756E6347222C22666546756E6352222C226665476175737369616E426C7572222C226665496D616765222C2266654D65726765222C2266654D657267654E6F6465222C2266654D6F7270686F6C6F6779222C2266654F6666736574';
wwv_flow_imp.g_varchar2_table(142) := '222C226665506F696E744C69676874222C22666553706563756C61724C69676874696E67222C22666553706F744C69676874222C22666554696C65222C22666554757262756C656E6365225D292C443D64285B22616E696D617465222C22636F6C6F722D';
wwv_flow_imp.g_varchar2_table(143) := '70726F66696C65222C22637572736F72222C2264697363617264222C22666564726F70736861646F77222C22666F6E742D66616365222C22666F6E742D666163652D666F726D6174222C22666F6E742D666163652D6E616D65222C22666F6E742D666163';
wwv_flow_imp.g_varchar2_table(144) := '652D737263222C22666F6E742D666163652D757269222C22666F726569676E6F626A656374222C226861746368222C22686174636870617468222C226D657368222C226D6573686772616469656E74222C226D6573687061746368222C226D657368726F';
wwv_flow_imp.g_varchar2_table(145) := '77222C226D697373696E672D676C797068222C22736372697074222C22736574222C22736F6C6964636F6C6F72222C22756E6B6E6F776E222C22757365225D292C4C3D64285B226D617468222C226D656E636C6F7365222C226D6572726F72222C226D66';
wwv_flow_imp.g_varchar2_table(146) := '656E636564222C226D66726163222C226D676C797068222C226D69222C226D6C6162656C65647472222C226D6D756C746973637269707473222C226D6E222C226D6F222C226D6F766572222C226D706164646564222C226D7068616E746F6D222C226D72';
wwv_flow_imp.g_varchar2_table(147) := '6F6F74222C226D726F77222C226D73222C226D7370616365222C226D73717274222C226D7374796C65222C226D737562222C226D737570222C226D737562737570222C226D7461626C65222C226D7464222C226D74657874222C226D7472222C226D756E';
wwv_flow_imp.g_varchar2_table(148) := '646572222C226D756E6465726F766572225D292C533D64285B226D616374696F6E222C226D616C69676E67726F7570222C226D616C69676E6D61726B222C226D6C6F6E67646976222C226D7363617272696573222C226D736361727279222C226D736772';
wwv_flow_imp.g_varchar2_table(149) := '6F7570222C226D737461636B222C226D736C696E65222C226D73726F77222C2273656D616E74696373222C22616E6E6F746174696F6E222C22616E6E6F746174696F6E2D786D6C222C226D70726573637269707473222C226E6F6E65225D292C493D6428';
wwv_flow_imp.g_varchar2_table(150) := '5B222374657874225D292C523D64285B22616363657074222C22616374696F6E222C22616C69676E222C22616C74222C226175746F6361706974616C697A65222C226175746F636F6D706C657465222C226175746F70696374757265696E706963747572';
wwv_flow_imp.g_varchar2_table(151) := '65222C226175746F706C6179222C226261636B67726F756E64222C226267636F6C6F72222C22626F72646572222C2263617074757265222C2263656C6C70616464696E67222C2263656C6C73706163696E67222C22636865636B6564222C226369746522';
wwv_flow_imp.g_varchar2_table(152) := '2C22636C617373222C22636C656172222C22636F6C6F72222C22636F6C73222C22636F6C7370616E222C22636F6E74726F6C73222C22636F6E74726F6C736C697374222C22636F6F726473222C2263726F73736F726967696E222C226461746574696D65';
wwv_flow_imp.g_varchar2_table(153) := '222C226465636F64696E67222C2264656661756C74222C22646972222C2264697361626C6564222C2264697361626C6570696374757265696E70696374757265222C2264697361626C6572656D6F7465706C61796261636B222C22646F776E6C6F616422';
wwv_flow_imp.g_varchar2_table(154) := '2C22647261676761626C65222C22656E6374797065222C22656E7465726B657968696E74222C2266616365222C22666F72222C2268656164657273222C22686569676874222C2268696464656E222C2268696768222C2268726566222C22687265666C61';
wwv_flow_imp.g_varchar2_table(155) := '6E67222C226964222C22696E7075746D6F6465222C22696E74656772697479222C2269736D6170222C226B696E64222C226C6162656C222C226C616E67222C226C697374222C226C6F6164696E67222C226C6F6F70222C226C6F77222C226D6178222C22';
wwv_flow_imp.g_varchar2_table(156) := '6D61786C656E677468222C226D65646961222C226D6574686F64222C226D696E222C226D696E6C656E677468222C226D756C7469706C65222C226D75746564222C226E616D65222C226E6F6E6365222C226E6F7368616465222C226E6F76616C69646174';
wwv_flow_imp.g_varchar2_table(157) := '65222C226E6F77726170222C226F70656E222C226F7074696D756D222C227061747465726E222C22706C616365686F6C646572222C22706C617973696E6C696E65222C22706F73746572222C227072656C6F6164222C2270756264617465222C22726164';
wwv_flow_imp.g_varchar2_table(158) := '696F67726F7570222C22726561646F6E6C79222C2272656C222C227265717569726564222C22726576222C227265766572736564222C22726F6C65222C22726F7773222C22726F777370616E222C227370656C6C636865636B222C2273636F7065222C22';
wwv_flow_imp.g_varchar2_table(159) := '73656C6563746564222C227368617065222C2273697A65222C2273697A6573222C227370616E222C227372636C616E67222C227374617274222C22737263222C22737263736574222C2273746570222C227374796C65222C2273756D6D617279222C2274';
wwv_flow_imp.g_varchar2_table(160) := '6162696E646578222C227469746C65222C227472616E736C617465222C2274797065222C227573656D6170222C2276616C69676E222C2276616C7565222C227769647468222C22786D6C6E73222C22736C6F74225D292C4D3D64285B22616363656E742D';
wwv_flow_imp.g_varchar2_table(161) := '686569676874222C22616363756D756C617465222C226164646974697665222C22616C69676E6D656E742D626173656C696E65222C22617363656E74222C226174747269627574656E616D65222C2261747472696275746574797065222C22617A696D75';
wwv_flow_imp.g_varchar2_table(162) := '7468222C22626173656672657175656E6379222C22626173656C696E652D7368696674222C22626567696E222C2262696173222C226279222C22636C617373222C22636C6970222C22636C697070617468756E697473222C22636C69702D70617468222C';
wwv_flow_imp.g_varchar2_table(163) := '22636C69702D72756C65222C22636F6C6F72222C22636F6C6F722D696E746572706F6C6174696F6E222C22636F6C6F722D696E746572706F6C6174696F6E2D66696C74657273222C22636F6C6F722D70726F66696C65222C22636F6C6F722D72656E6465';
wwv_flow_imp.g_varchar2_table(164) := '72696E67222C226378222C226379222C2264222C226478222C226479222C2264696666757365636F6E7374616E74222C22646972656374696F6E222C22646973706C6179222C2264697669736F72222C22647572222C22656467656D6F6465222C22656C';
wwv_flow_imp.g_varchar2_table(165) := '65766174696F6E222C22656E64222C2266696C6C222C2266696C6C2D6F706163697479222C2266696C6C2D72756C65222C2266696C746572222C2266696C746572756E697473222C22666C6F6F642D636F6C6F72222C22666C6F6F642D6F706163697479';
wwv_flow_imp.g_varchar2_table(166) := '222C22666F6E742D66616D696C79222C22666F6E742D73697A65222C22666F6E742D73697A652D61646A757374222C22666F6E742D73747265746368222C22666F6E742D7374796C65222C22666F6E742D76617269616E74222C22666F6E742D77656967';
wwv_flow_imp.g_varchar2_table(167) := '6874222C226678222C226679222C226731222C226732222C22676C7970682D6E616D65222C22676C797068726566222C226772616469656E74756E697473222C226772616469656E747472616E73666F726D222C22686569676874222C2268726566222C';
wwv_flow_imp.g_varchar2_table(168) := '226964222C22696D6167652D72656E646572696E67222C22696E222C22696E32222C226B222C226B31222C226B32222C226B33222C226B34222C226B65726E696E67222C226B6579706F696E7473222C226B657973706C696E6573222C226B657974696D';
wwv_flow_imp.g_varchar2_table(169) := '6573222C226C616E67222C226C656E67746861646A757374222C226C65747465722D73706163696E67222C226B65726E656C6D6174726978222C226B65726E656C756E69746C656E677468222C226C69676874696E672D636F6C6F72222C226C6F63616C';
wwv_flow_imp.g_varchar2_table(170) := '222C226D61726B65722D656E64222C226D61726B65722D6D6964222C226D61726B65722D7374617274222C226D61726B6572686569676874222C226D61726B6572756E697473222C226D61726B65727769647468222C226D61736B636F6E74656E74756E';
wwv_flow_imp.g_varchar2_table(171) := '697473222C226D61736B756E697473222C226D6178222C226D61736B222C226D65646961222C226D6574686F64222C226D6F6465222C226D696E222C226E616D65222C226E756D6F637461766573222C226F6666736574222C226F70657261746F72222C';
wwv_flow_imp.g_varchar2_table(172) := '226F706163697479222C226F72646572222C226F7269656E74222C226F7269656E746174696F6E222C226F726967696E222C226F766572666C6F77222C227061696E742D6F72646572222C2270617468222C22706174686C656E677468222C2270617474';
wwv_flow_imp.g_varchar2_table(173) := '65726E636F6E74656E74756E697473222C227061747465726E7472616E73666F726D222C227061747465726E756E697473222C22706F696E7473222C227072657365727665616C706861222C227072657365727665617370656374726174696F222C2270';
wwv_flow_imp.g_varchar2_table(174) := '72696D6974697665756E697473222C2272222C227278222C227279222C22726164697573222C2272656678222C2272656679222C22726570656174636F756E74222C22726570656174647572222C2272657374617274222C22726573756C74222C22726F';
wwv_flow_imp.g_varchar2_table(175) := '74617465222C227363616C65222C2273656564222C2273686170652D72656E646572696E67222C2273706563756C6172636F6E7374616E74222C2273706563756C61726578706F6E656E74222C227370726561646D6574686F64222C2273746172746F66';
wwv_flow_imp.g_varchar2_table(176) := '66736574222C22737464646576696174696F6E222C2273746974636874696C6573222C2273746F702D636F6C6F72222C2273746F702D6F706163697479222C227374726F6B652D646173686172726179222C227374726F6B652D646173686F6666736574';
wwv_flow_imp.g_varchar2_table(177) := '222C227374726F6B652D6C696E65636170222C227374726F6B652D6C696E656A6F696E222C227374726F6B652D6D697465726C696D6974222C227374726F6B652D6F706163697479222C227374726F6B65222C227374726F6B652D7769647468222C2273';
wwv_flow_imp.g_varchar2_table(178) := '74796C65222C22737572666163657363616C65222C2273797374656D6C616E6775616765222C22746162696E646578222C2274617267657478222C2274617267657479222C227472616E73666F726D222C22746578742D616E63686F72222C2274657874';
wwv_flow_imp.g_varchar2_table(179) := '2D6465636F726174696F6E222C22746578742D72656E646572696E67222C22746578746C656E677468222C2274797065222C227531222C227532222C22756E69636F6465222C2276616C756573222C2276696577626F78222C227669736962696C697479';
wwv_flow_imp.g_varchar2_table(180) := '222C2276657273696F6E222C22766572742D6164762D79222C22766572742D6F726967696E2D78222C22766572742D6F726967696E2D79222C227769647468222C22776F72642D73706163696E67222C2277726170222C2277726974696E672D6D6F6465';
wwv_flow_imp.g_varchar2_table(181) := '222C22786368616E6E656C73656C6563746F72222C22796368616E6E656C73656C6563746F72222C2278222C227831222C227832222C22786D6C6E73222C2279222C227931222C227932222C227A222C227A6F6F6D616E6470616E225D292C463D64285B';
wwv_flow_imp.g_varchar2_table(182) := '22616363656E74222C22616363656E74756E646572222C22616C69676E222C22626576656C6C6564222C22636C6F7365222C22636F6C756D6E73616C69676E222C22636F6C756D6E6C696E6573222C22636F6C756D6E7370616E222C2264656E6F6D616C';
wwv_flow_imp.g_varchar2_table(183) := '69676E222C226465707468222C22646972222C22646973706C6179222C22646973706C61797374796C65222C22656E636F64696E67222C2266656E6365222C226672616D65222C22686569676874222C2268726566222C226964222C226C617267656F70';
wwv_flow_imp.g_varchar2_table(184) := '222C226C656E677468222C226C696E65746869636B6E657373222C226C7370616365222C226C71756F7465222C226D6174686261636B67726F756E64222C226D617468636F6C6F72222C226D61746873697A65222C226D61746876617269616E74222C22';
wwv_flow_imp.g_varchar2_table(185) := '6D617873697A65222C226D696E73697A65222C226D6F7661626C656C696D697473222C226E6F746174696F6E222C226E756D616C69676E222C226F70656E222C22726F77616C69676E222C22726F776C696E6573222C22726F7773706163696E67222C22';
wwv_flow_imp.g_varchar2_table(186) := '726F777370616E222C22727370616365222C227271756F7465222C227363726970746C6576656C222C227363726970746D696E73697A65222C2273637269707473697A656D756C7469706C696572222C2273656C656374696F6E222C2273657061726174';
wwv_flow_imp.g_varchar2_table(187) := '6F72222C22736570617261746F7273222C227374726574636879222C227375627363726970747368696674222C227375707363726970747368696674222C2273796D6D6574726963222C22766F6666736574222C227769647468222C22786D6C6E73225D';
wwv_flow_imp.g_varchar2_table(188) := '292C483D64285B22786C696E6B3A68726566222C22786D6C3A6964222C22786C696E6B3A7469746C65222C22786D6C3A7370616365222C22786D6C6E733A786C696E6B225D292C243D66282F5C7B5C7B5B5C735C535D2A7C5B5C735C535D2A5C7D5C7D2F';
wwv_flow_imp.g_varchar2_table(189) := '676D292C423D66282F3C255B5C735C535D2A7C5B5C735C535D2A253E2F676D292C7A3D66282F5E646174612D5B5C2D5C772E5C75303042372D5C75464646465D2F292C553D66282F5E617269612D5B5C2D5C775D2B242F292C503D66282F5E283F3A283F';
wwv_flow_imp.g_varchar2_table(190) := '3A283F3A667C6874297470733F7C6D61696C746F7C74656C7C63616C6C746F7C6369647C786D7070293A7C5B5E612D7A5D7C5B612D7A2B2E5C2D5D2B283F3A5B5E612D7A2B2E5C2D3A5D7C2429292F69292C6A3D66282F5E283F3A5C772B736372697074';
wwv_flow_imp.g_varchar2_table(191) := '7C64617461293A2F69292C473D66282F5B5C75303030302D5C75303032305C75303041305C75313638305C75313830455C75323030302D5C75323032395C75323035465C75333030305D2F67292C713D2266756E6374696F6E223D3D747970656F662053';
wwv_flow_imp.g_varchar2_table(192) := '796D626F6C26262273796D626F6C223D3D747970656F662053796D626F6C2E6974657261746F723F66756E6374696F6E2865297B72657475726E20747970656F6620657D3A66756E6374696F6E2865297B72657475726E206526262266756E6374696F6E';
wwv_flow_imp.g_varchar2_table(193) := '223D3D747970656F662053796D626F6C2626652E636F6E7374727563746F723D3D3D53796D626F6C262665213D3D53796D626F6C2E70726F746F747970653F2273796D626F6C223A747970656F6620657D2C573D66756E6374696F6E28297B7265747572';
wwv_flow_imp.g_varchar2_table(194) := '6E22756E646566696E6564223D3D747970656F662077696E646F773F6E756C6C3A77696E646F777D2C4A3D66756E6374696F6E28652C74297B696628226F626A65637422213D3D28766F696420303D3D3D653F22756E646566696E6564223A7128652929';
wwv_flow_imp.g_varchar2_table(195) := '7C7C2266756E6374696F6E22213D747970656F6620652E637265617465506F6C6963792972657475726E206E756C6C3B766172206E3D6E756C6C2C723D22646174612D74742D706F6C6963792D737566666978223B742E63757272656E74536372697074';
wwv_flow_imp.g_varchar2_table(196) := '2626742E63757272656E745363726970742E6861734174747269627574652872292626286E3D742E63757272656E745363726970742E676574417474726962757465287229293B76617220613D22646F6D707572696679222B286E3F2223222B6E3A2222';
wwv_flow_imp.g_varchar2_table(197) := '293B7472797B72657475726E20652E637265617465506F6C69637928612C7B63726561746548544D4C3A66756E6374696F6E2865297B72657475726E20657D7D297D63617463682865297B72657475726E20636F6E736F6C652E7761726E282254727573';
wwv_flow_imp.g_varchar2_table(198) := '746564547970657320706F6C69637920222B612B2220636F756C64206E6F7420626520637265617465642E22292C6E756C6C7D7D3B72657475726E206F28297D293B766172206E6F74696669636174696F6E4D656E753D66756E6374696F6E28297B2275';
wwv_flow_imp.g_varchar2_table(199) := '736520737472696374223B76617220743D7B6665617475726544657461696C733A7B6E616D653A2241504558204E6F74696669636174696F6E204D656E75222C73637269707456657273696F6E3A22312E362E35222C7574696C56657273696F6E3A2231';
wwv_flow_imp.g_varchar2_table(200) := '2E34222C75726C3A2268747470733A2F2F6769746875622E636F6D2F526F6E6E795765697373222C6C6963656E73653A224D4954227D2C65736361706548544D4C3A66756E6374696F6E2865297B6966286E756C6C3D3D3D652972657475726E206E756C';
wwv_flow_imp.g_varchar2_table(201) := '6C3B696628766F69642030213D3D65297B696628226F626A656374223D3D747970656F662065297472797B653D4A534F4E2E737472696E676966792865297D63617463682865297B7D72657475726E20617065782E7574696C2E65736361706548544D4C';
wwv_flow_imp.g_varchar2_table(202) := '28537472696E67286529297D7D2C6A736F6E53617665457874656E643A66756E6374696F6E28652C74297B766172206E3D7B7D2C723D7B7D3B69662822737472696E67223D3D747970656F662074297472797B723D4A534F4E2E70617273652874297D63';
wwv_flow_imp.g_varchar2_table(203) := '617463682865297B617065782E64656275672E6572726F72287B6D6F64756C653A227574696C2E6A73222C6D73673A224572726F72207768696C652074727920746F20706172736520746172676574436F6E6669672E20506C6561736520636865636B20';
wwv_flow_imp.g_varchar2_table(204) := '796F757220436F6E666967204A534F4E2E205374616E6461726420436F6E6669672077696C6C20626520757365642E222C6572723A652C746172676574436F6E6669673A747D297D656C736520723D242E657874656E642821302C7B7D2C74293B747279';
wwv_flow_imp.g_varchar2_table(205) := '7B6E3D242E657874656E642821302C7B7D2C652C72297D63617463682874297B6E3D242E657874656E642821302C7B7D2C65292C617065782E64656275672E6572726F72287B6D6F64756C653A227574696C2E6A73222C6D73673A224572726F72207768';
wwv_flow_imp.g_varchar2_table(206) := '696C652074727920746F206D657267652032204A534F4E7320696E746F207374616E64617264204A534F4E20696620616E7920617474726962757465206973206D697373696E672E20506C6561736520636865636B20796F757220436F6E666967204A53';
wwv_flow_imp.g_varchar2_table(207) := '4F4E2E205374616E6461726420436F6E6669672077696C6C20626520757365642E222C6572723A742C66696E616C436F6E6669673A6E7D297D72657475726E206E7D2C6C696E6B3A66756E6374696F6E28652C74297B69662821742972657475726E2077';
wwv_flow_imp.g_varchar2_table(208) := '696E646F772E706172656E742E6C6F636174696F6E2E687265663D653B77696E646F772E6F70656E28652C225F626C616E6B22297D2C637574537472696E673A66756E6374696F6E28652C74297B7472797B72657475726E20743C303F653A652E6C656E';
wwv_flow_imp.g_varchar2_table(209) := '6774683E743F652E737562737472696E6728302C742D33292B222E2E2E223A657D63617463682874297B72657475726E20657D7D2C72656D6F766548544D4C3A66756E6374696F6E2865297B72657475726E20617065782626617065782E7574696C2626';
wwv_flow_imp.g_varchar2_table(210) := '617065782E7574696C2E737472697048544D4C3F617065782E7574696C2E737472697048544D4C2865293A2428223C6469762F3E22292E68746D6C2865292E7465787428297D7D3B72657475726E7B696E697469616C697A653A66756E6374696F6E286E';
wwv_flow_imp.g_varchar2_table(211) := '2C722C612C6F2C692C6C2C73297B66756E6374696F6E20632865297B72657475726E2131213D3D693F742E65736361706548544D4C2865293A2131213D3D6C3F444F4D5075726966792E73616E6974697A6528652C6D293A657D66756E6374696F6E2075';
wwv_flow_imp.g_varchar2_table(212) := '2865297B617065782E7365727665722E706C7567696E28722C7B706167654974656D733A6F7D2C7B737563636573733A66756E6374696F6E286E297B617065782E64656275672E696E666F287B6663743A742E6665617475726544657461696C732E6E61';
wwv_flow_imp.g_varchar2_table(213) := '6D652B22202D2067657444617461222C6D73673A22414A41582064617461207265636569766564222C70446174613A6E2C6665617475726544657461696C733A742E6665617475726544657461696C737D292C703D302C65286E297D2C6572726F723A66';
wwv_flow_imp.g_varchar2_table(214) := '756E6374696F6E286E297B696628303D3D3D70297B76617220723D7B726F773A5B7B4E4F54455F49434F4E3A2266612D6578636C616D6174696F6E2D747269616E676C65222C4E4F54455F49434F4E5F434F4C4F523A2223464630303030222C4E4F5445';
wwv_flow_imp.g_varchar2_table(215) := '5F4845414445523A6E2E726573706F6E73654A534F4E26266E2E726573706F6E73654A534F4E2E6572726F723F6E2E726573706F6E73654A534F4E2E6572726F723A224572726F72206F636375726564222C4E4F54455F544558543A6E756C6C2C4E4F54';
wwv_flow_imp.g_varchar2_table(216) := '455F434F4C4F523A2223464630303030227D5D7D3B652872292C617065782E64656275672E6572726F72287B6663743A742E6665617475726544657461696C732E6E616D652B22202D2067657444617461222C6D73673A22414A41582064617461206572';
wwv_flow_imp.g_varchar2_table(217) := '726F72222C726573706F6E73653A6E2C6665617475726544657461696C733A742E6665617475726544657461696C737D297D702B2B7D2C64617461547970653A226A736F6E227D297D66756E6374696F6E20642865297B76617220723D2223222B6E2B22';
wwv_flow_imp.g_varchar2_table(218) := '5F746F67676C654E6F7465223B696628242872292E6869646528292C652E726F77297B76617220613D2223222B6E2B225F6E756D646976222C6F3D2223222B6E2B225F756C223B652E726F772E6C656E6774683E303F28242861292E6373732822626163';
wwv_flow_imp.g_varchar2_table(219) := '6B67726F756E64222C682E636F756E7465724261636B67726F756E64436F6C6F72292C242872292E73686F7728292C242861292E73686F7728292C242861292E7465787428652E726F772E6C656E677468292C24286F292E656D70747928292C66756E63';
wwv_flow_imp.g_varchar2_table(220) := '74696F6E28652C72297B76617220612C6F3D21313B24282223222B6E2B225F756C22292E6C656E6774683F28613D24282223222B6E2B225F756C22292C6F3D2130293A2828613D2428223C756C3E3C2F756C3E2229292E6174747228226964222C6E2B22';
wwv_flow_imp.g_varchar2_table(221) := '5F756C22292C612E616464436C61737328226E6F74696669636174696F6E7322292C612E616464436C6173732822746F67676C654C6973742229293B6F2626682E686964654F6E52656672657368262621313D3D3D242861292E686173436C6173732822';
wwv_flow_imp.g_varchar2_table(222) := '746F67676C654C69737422292626242861292E616464436C6173732822746F67676C654C69737422293B722E726F772626242E6561636828722E726F772C66756E6374696F6E28652C6E297B696628682E62726F777365724E6F74696669636174696F6E';
wwv_flow_imp.g_varchar2_table(223) := '732E656E61626C6564262631213D6E2E4E4F5F42524F575345525F4E4F54494649434154494F4E297472797B76617220722C6F3B6E2E4E4F54455F484541444552262628723D742E72656D6F766548544D4C286E2E4E4F54455F48454144455229292C6E';
wwv_flow_imp.g_varchar2_table(224) := '2E4E4F54455F544558542626286F3D742E72656D6F766548544D4C286E2E4E4F54455F54455854292C6F3D742E637574537472696E67286F2C682E62726F777365724E6F74696669636174696F6E732E637574426F647954657874416674657229292C73';
wwv_flow_imp.g_varchar2_table(225) := '657454696D656F75742866756E6374696F6E28297B696628224E6F74696669636174696F6E22696E2077696E646F7729696628226772616E746564223D3D3D4E6F74696669636174696F6E2E7065726D697373696F6E297B76617220653D6E6577204E6F';
wwv_flow_imp.g_varchar2_table(226) := '74696669636174696F6E28722C7B626F64793A6F2C72657175697265496E746572616374696F6E3A682E62726F777365724E6F74696669636174696F6E732E72657175697265496E746572616374696F6E7D293B682E62726F777365724E6F7469666963';
wwv_flow_imp.g_varchar2_table(227) := '6174696F6E732E6C696E6B26266E2E4E4F54455F4C494E4B262628652E6F6E636C69636B3D66756E6374696F6E2865297B742E6C696E6B286E2E4E4F54455F4C494E4B297D297D656C73652264656E69656422213D3D4E6F74696669636174696F6E2E70';
wwv_flow_imp.g_varchar2_table(228) := '65726D697373696F6E26264E6F74696669636174696F6E2E726571756573745065726D697373696F6E2866756E6374696F6E2865297B696628226772616E746564223D3D3D65297B76617220613D6E6577204E6F74696669636174696F6E28722C7B626F';
wwv_flow_imp.g_varchar2_table(229) := '64793A6F2C72657175697265496E746572616374696F6E3A682E62726F777365724E6F74696669636174696F6E732E72657175697265496E746572616374696F6E7D293B682E62726F777365724E6F74696669636174696F6E732E6C696E6B26266E2E4E';
wwv_flow_imp.g_varchar2_table(230) := '4F54455F4C494E4B262628612E6F6E636C69636B3D66756E6374696F6E2865297B742E6C696E6B286E2E4E4F54455F4C494E4B297D297D7D293B656C736520617065782E64656275672E6572726F72287B6663743A742E6665617475726544657461696C';
wwv_flow_imp.g_varchar2_table(231) := '732E6E616D652B22202D20647261774C697374222C6D73673A22546869732062726F7773657220646F6573206E6F7420737570706F72742073797374656D206E6F74696669636174696F6E73222C6665617475726544657461696C733A742E6665617475';
wwv_flow_imp.g_varchar2_table(232) := '726544657461696C737D297D2C3135302A65297D63617463682865297B617065782E64656275672E6572726F72287B6663743A742E6665617475726544657461696C732E6E616D652B22202D20647261774C697374222C6D73673A224572726F72207768';
wwv_flow_imp.g_varchar2_table(233) := '696C652074727920746F20676574206E6F74696669636174696F6E207065726D697373696F6E222C6572723A652C6665617475726544657461696C733A742E6665617475726544657461696C737D297D6E2E4E4F54455F4845414445522626286E2E4E4F';
wwv_flow_imp.g_varchar2_table(234) := '54455F4845414445523D63286E2E4E4F54455F48454144455229292C6E2E4E4F54455F49434F4E2626286E2E4E4F54455F49434F4E3D63286E2E4E4F54455F49434F4E29292C6E2E4E4F54455F49434F4E5F434F4C4F522626286E2E4E4F54455F49434F';
wwv_flow_imp.g_varchar2_table(235) := '4E5F434F4C4F523D63286E2E4E4F54455F49434F4E5F434F4C4F5229292C6E2E4E4F54455F544558542626286E2E4E4F54455F544558543D63286E2E4E4F54455F5445585429293B76617220693D2428223C613E3C2F613E22293B6E2E4E4F54455F4C49';
wwv_flow_imp.g_varchar2_table(236) := '4E4B262628692E61747472282268726566222C6E2E4E4F54455F4C494E4B292C682E6C696E6B546172676574426C616E6B2626692E617474722822746172676574222C225F626C616E6B22292C692E6F6E2822746F75636820636C69636B222C66756E63';
wwv_flow_imp.g_varchar2_table(237) := '74696F6E2865297B242861292E616464436C6173732822746F67676C654C69737422297D29293B766172206C3D2428223C6C693E3C2F6C693E22293B6966286C2E616464436C61737328226E6F746522292C6E2E4E4F54455F434F4C4F5226266C2E6373';
wwv_flow_imp.g_varchar2_table(238) := '732822626F782D736861646F77222C222D35707820302030203020222B6E2E4E4F54455F434F4C4F52292C6E2E4E4F54455F4143434550547C7C6E2E4E4F54455F4445434C494E45297B6966286C2E637373282270616464696E672D7269676874222C22';
wwv_flow_imp.g_varchar2_table(239) := '3332707822292C6E2E4E4F54455F414343455054297B76617220733D2428223C613E3C2F613E22293B732E616464436C61737328226163636570742D6122292C732E61747472282268726566222C6E2E4E4F54455F414343455054293B76617220753D24';
wwv_flow_imp.g_varchar2_table(240) := '28223C693E3C2F693E22293B752E616464436C6173732822666122292C752E616464436C617373286E2E4143434550545F49434F4E203F3F20682E6163636570742E69636F6E292C752E6373732822636F6C6F72222C6E2E4143434550545F49434F4E5F';
wwv_flow_imp.g_varchar2_table(241) := '434F4C4F52203F3F20682E6163636570742E636F6C6F72292C752E6373732822666F6E742D73697A65222C223230707822292C732E617070656E642875292C6C2E617070656E642873297D6966286E2E4E4F54455F4445434C494E45297B76617220643D';
wwv_flow_imp.g_varchar2_table(242) := '2428223C613E3C2F613E22293B642E616464436C61737328226465636C696E652D6122292C642E61747472282268726566222C6E2E4E4F54455F4445434C494E45292C6E2E4E4F54455F4143434550542626642E6373732822626F74746F6D222C223430';
wwv_flow_imp.g_varchar2_table(243) := '707822293B76617220663D2428223C693E3C2F693E22293B662E616464436C6173732822666122292C662E616464436C617373286E2E4445434C494E455F49434F4E203F3F20682E6465636C696E652E69636F6E292C662E6373732822636F6C6F72222C';
wwv_flow_imp.g_varchar2_table(244) := '6E2E4445434C494E455F49434F4E5F434F4C4F52203F3F20682E6465636C696E652E636F6C6F72292C662E6373732822666F6E742D73697A65222C223234707822292C642E617070656E642866292C6C2E617070656E642864297D7D766172206D3D2428';
wwv_flow_imp.g_varchar2_table(245) := '223C6469763E3C2F6469763E22293B6D2E616464436C61737328226E6F74652D68656164657222293B76617220703D2428223C693E3C2F693E22293B702E616464436C6173732822666122292C6E2E4E4F54455F49434F4E2626702E616464436C617373';
wwv_flow_imp.g_varchar2_table(246) := '286E2E4E4F54455F49434F4E292C6E2E4E4F54455F49434F4E5F434F4C4F522626702E6373732822636F6C6F72222C6E2E4E4F54455F49434F4E5F434F4C4F52292C702E616464436C617373282266612D6C6722292C6D2E617070656E642870292C6E2E';
wwv_flow_imp.g_varchar2_table(247) := '4E4F54455F48454144455226266D2E617070656E64286E2E4E4F54455F484541444552292C6C2E617070656E64286D293B76617220673D2428223C7370616E3E3C2F7370616E3E22293B672E616464436C61737328226E6F74652D696E666F22292C6E2E';
wwv_flow_imp.g_varchar2_table(248) := '4E4F54455F544558542626672E68746D6C286E2E4E4F54455F54455854292C6C2E617070656E642867292C692E617070656E64286C292C612E617070656E642869297D293B242822626F647922292E617070656E642861297D28242872292C6529293A28';
wwv_flow_imp.g_varchar2_table(249) := '682E73686F77416C77617973262628242872292E73686F7728292C242861292E686964652829292C24286F292E656D7074792829297D7D617065782E64656275672E696E666F287B6663743A742E6665617475726544657461696C732E6E616D652B2220';
wwv_flow_imp.g_varchar2_table(250) := '2D20696E697469616C697A65222C617267756D656E74733A7B656C656D656E7449443A6E2C616A617849443A722C7564436F6E6669674A534F4E3A612C6974656D73325375626D69743A6F2C65736361706552657175697265643A692C73616E6974697A';
wwv_flow_imp.g_varchar2_table(251) := '653A6C2C73616E6974697A65724F7074696F6E733A737D2C6665617475726544657461696C733A742E6665617475726544657461696C737D293B76617220662C6D2C703D302C673D7B414C4C4F5745445F415454523A5B226163636573736B6579222C22';
wwv_flow_imp.g_varchar2_table(252) := '616C69676E222C22616C74222C22616C77617973222C226175746F636F6D706C657465222C226175746F706C6179222C22626F72646572222C2263656C6C70616464696E67222C2263656C6C73706163696E67222C2263686172736574222C22636C6173';
wwv_flow_imp.g_varchar2_table(253) := '73222C22636F6C7370616E222C22646972222C22686569676874222C2268726566222C226964222C226C616E67222C226E616D65222C2272656C222C227265717569726564222C22726F777370616E222C22737263222C227374796C65222C2273756D6D';
wwv_flow_imp.g_varchar2_table(254) := '617279222C22746162696E646578222C22746172676574222C227469746C65222C2274797065222C2276616C7565222C227769647468225D2C414C4C4F5745445F544147533A5B2261222C2261646472657373222C2262222C22626C6F636B71756F7465';
wwv_flow_imp.g_varchar2_table(255) := '222C226272222C2263617074696F6E222C22636F6465222C226464222C22646976222C22646C222C226474222C22656D222C2266696763617074696F6E222C22666967757265222C226831222C226832222C226833222C226834222C226835222C226836';
wwv_flow_imp.g_varchar2_table(256) := '222C226872222C2269222C22696D67222C226C6162656C222C226C69222C226E6C222C226F6C222C2270222C22707265222C2273222C227370616E222C22737472696B65222C227374726F6E67222C22737562222C22737570222C227461626C65222C22';
wwv_flow_imp.g_varchar2_table(257) := '74626F6479222C227464222C227468222C227468656164222C227472222C2275222C22756C225D7D3B2131213D3D6C2626286D3D733F742E6A736F6E53617665457874656E6428672C73293A67293B76617220683D7B7D3B683D742E6A736F6E53617665';
wwv_flow_imp.g_varchar2_table(258) := '457874656E64287B726566726573683A302C6D61696E49636F6E3A2266612D62656C6C222C6D61696E49636F6E436F6C6F723A227768697465222C6D61696E49636F6E4261636B67726F756E64436F6C6F723A22726762612837302C37302C37302C302E';
wwv_flow_imp.g_varchar2_table(259) := '3929222C6D61696E49636F6E426C696E6B696E673A21312C636F756E7465724261636B67726F756E64436F6C6F723A22726762283233322C2035352C2035352029222C636F756E746572466F6E74436F6C6F723A227768697465222C6C696E6B54617267';
wwv_flow_imp.g_varchar2_table(260) := '6574426C616E6B3A21312C73686F77416C776179733A21312C62726F777365724E6F74696669636174696F6E733A7B656E61626C65643A21302C637574426F64795465787441667465723A3130302C6C696E6B3A21317D2C6163636570743A7B636F6C6F';
wwv_flow_imp.g_varchar2_table(261) := '723A2223343465353563222C69636F6E3A2266612D636865636B227D2C6465636C696E653A7B636F6C6F723A2223623733613231222C69636F6E3A2266612D636C6F7365227D2C686964654F6E526566726573683A21307D2C61293B766172204E3D6675';
wwv_flow_imp.g_varchar2_table(262) := '6E6374696F6E2865297B76617220743D2428223C6C693E3C2F6C693E22293B742E616464436C6173732822742D4E617669676174696F6E4261722D6974656D22293B766172206E3D2428223C6469763E3C2F6469763E22293B72657475726E206E2E6174';
wwv_flow_imp.g_varchar2_table(263) := '747228226964222C65292C6E2E62696E6428226170657872656672657368222C66756E6374696F6E28297B303D3D4E2E6368696C6472656E28227370616E22292E6C656E6774682626752864297D292C742E617070656E64286E292C2428222E742D4E61';
wwv_flow_imp.g_varchar2_table(264) := '7669676174696F6E42617222292E70726570656E642874292C6E7D286E293B696628682E62726F777365724E6F74696669636174696F6E732E656E61626C6564297472797B224E6F74696669636174696F6E22696E2077696E646F773F4E6F7469666963';
wwv_flow_imp.g_varchar2_table(265) := '6174696F6E2E726571756573745065726D697373696F6E28293A617065782E64656275672E6572726F72287B6663743A742E6665617475726544657461696C732E6E616D652B22202D20647261774C697374222C6D73673A22546869732062726F777365';
wwv_flow_imp.g_varchar2_table(266) := '7220646F6573206E6F7420737570706F72742073797374656D206E6F74696669636174696F6E73222C6572723A652C6665617475726544657461696C733A742E6665617475726544657461696C737D297D63617463682865297B617065782E6465627567';
wwv_flow_imp.g_varchar2_table(267) := '2E6572726F72287B6663743A742E6665617475726544657461696C732E6E616D652B22202D20696E697469616C697A65222C6D73673A224572726F72207768696C652074727920746F20676574206E6F74696669636174696F6E207065726D697373696F';
wwv_flow_imp.g_varchar2_table(268) := '6E222C6572723A652C6665617475726544657461696C733A742E6665617475726544657461696C737D297D752866756E6374696F6E2865297B682E636F756E7465724261636B67726F756E64436F6C6F723D6328682E636F756E7465724261636B67726F';
wwv_flow_imp.g_varchar2_table(269) := '756E64436F6C6F72292C682E636F756E746572466F6E74436F6C6F723D6328682E636F756E746572466F6E74436F6C6F72292C682E6D61696E49636F6E3D6328682E6D61696E49636F6E292C682E6D61696E49636F6E4261636B67726F756E64436F6C6F';
wwv_flow_imp.g_varchar2_table(270) := '723D6328682E6D61696E49636F6E4261636B67726F756E64436F6C6F72292C682E6D61696E49636F6E436F6C6F723D6328682E6D61696E49636F6E436F6C6F72293B76617220743D2428223C6469763E3C2F6469763E22293B742E616464436C61737328';
wwv_flow_imp.g_varchar2_table(271) := '22746F67676C654E6F74696669636174696F6E7322292C742E6174747228226964222C6E2B225F746F67676C654E6F746522293B76617220723D2223222B6E2B225F756C223B742E6F6E2822746F75636820636C69636B222C66756E6374696F6E28297B';
wwv_flow_imp.g_varchar2_table(272) := '242872292E746F67676C65436C6173732822746F67676C654C69737422297D292C2428646F63756D656E74292E6F6E2822746F75636820636C69636B222C66756E6374696F6E2865297B21742E697328652E746172676574292626303D3D3D742E686173';
wwv_flow_imp.g_varchar2_table(273) := '28652E746172676574292E6C656E6774682626212428652E746172676574292E706172656E74732872292E6C656E6774683E30262621313D3D3D242872292E686173436C6173732822746F67676C654C69737422292626242872292E746F67676C65436C';
wwv_flow_imp.g_varchar2_table(274) := '6173732822746F67676C654C69737422297D293B76617220613D2428223C6469763E3C2F6469763E22293B612E616464436C6173732822636F756E7422292C742E617070656E642861293B766172206F3D2428223C6469763E3C2F6469763E22293B6F2E';
wwv_flow_imp.g_varchar2_table(275) := '616464436C61737328226E756D22292C6F2E63737328226261636B67726F756E64222C682E636F756E7465724261636B67726F756E64436F6C6F72292C6F2E6373732822636F6C6F72222C682E636F756E746572466F6E74436F6C6F72292C6F2E617474';
wwv_flow_imp.g_varchar2_table(276) := '7228226964222C6E2B225F6E756D64697622292C6F2E68746D6C28652E726F772E6C656E677468292C612E617070656E64286F293B76617220693D2428223C6C6162656C3E3C2F6C6162656C3E22293B692E616464436C617373282273686F7722292C69';
wwv_flow_imp.g_varchar2_table(277) := '2E63737328226261636B67726F756E64222C682E6D61696E49636F6E4261636B67726F756E64436F6C6F72293B766172206C3D2428223C693E3C2F693E22293B6C2E616464436C6173732822666122292C6C2E616464436C61737328682E6D61696E4963';
wwv_flow_imp.g_varchar2_table(278) := '6F6E292C6C2E6373732822636F6C6F72222C682E6D61696E49636F6E436F6C6F72292C682E6D61696E49636F6E426C696E6B696E6726266C2E616464436C617373282266612D626C696E6B22292C692E617070656E64286C292C742E617070656E642869';
wwv_flow_imp.g_varchar2_table(279) := '292C4E2E617070656E642874292C642865297D292C682E726566726573683E30262628663D736574496E74657276616C2866756E6374696F6E28297B303D3D3D24282223222B6E292E6C656E6774682626636C656172496E74657276616C2866292C703E';
wwv_flow_imp.g_varchar2_table(280) := '3D322626636C656172496E74657276616C2866292C303D3D4E2E6368696C6472656E28227370616E22292E6C656E677468262628723F752864293A6428646174614A534F4E29297D2C3165332A682E7265667265736829297D7D7D28293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(233156194043766153)
,p_plugin_id=>wwv_flow_imp.id(138494323700459718664)
,p_file_name=>'anm.pkgd.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
