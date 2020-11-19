﻿<%--
    Myrtille: A native HTML4/5 Remote Desktop Protocol client.

    Copyright(c) 2014-2020 Cedric Coste

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

	    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
--%>

<%@ Page Language="C#" Inherits="Myrtille.Web.Default" CodeBehind="Default.aspx.cs" AutoEventWireup="true" Culture="auto" UICulture="auto" %>

<%@ OutputCache Location="None" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Web.Optimization" %>
<%@ Import Namespace="Myrtille.Web" %>
<%@ Import Namespace="Myrtille.Services.Contracts" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>

    <!-- force IE out of compatibility mode -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />

    <!-- mobile devices -->
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0" />

    <title>Myrtille<%=RemoteSession != null && !RemoteSession.ConnectionService && (RemoteSession.State == RemoteSessionState.Connecting || RemoteSession.State == RemoteSessionState.Connected) && !string.IsNullOrEmpty(RemoteSession.ServerAddress) ? " - " + RemoteSession.ServerAddress.ToString() : ""%></title>

    <link rel="icon" type="image/x-icon" href="favicon.ico" />
    <link rel="stylesheet" type="text/css" href="<%=BundleTable.Bundles.ResolveBundleUrl("~/css/Default.css", true)%>" />
    <link rel="stylesheet" type="text/css" href="<%=BundleTable.Bundles.ResolveBundleUrl("~/css/xterm.css", true)%>" />

    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/tools/common.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/tools/convert.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/myrtille.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/config.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/dialog.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/display.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/display/canvas.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/display/divs.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/display/terminaldiv.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/network.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/network/buffer.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/network/eventsource.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/network/longpolling.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/network/websocket.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/network/xmlhttp.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/user.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/user/keyboard.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/user/mouse.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/user/touchscreen.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/xterm/xterm.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/xterm/addons/fit/fit.js", true)%>"></script>
    <script language="javascript" type="text/javascript" src="<%=BundleTable.Bundles.ResolveBundleUrl("~/js/audio/audiowebsocket.js", true)%>"></script>
    <script type="text/javascript" src="/js/jquery.js"></script>
    <script type="text/javascript" src="/js/js-tilt.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/interactjs/dist/interact.min.js"></script>


</head>

<body onload="startMyrtille(
        <%=(RemoteSession != null ? "'" + RemoteSession.State.ToString().ToUpper() + "'" : "null")%>,
        getToggleCookie((parent != null && window.name != '' ? window.name + '_' : '') + 'stat'),
        getToggleCookie((parent != null && window.name != '' ? window.name + '_' : '') + 'debug'),
        getToggleCookie((parent != null && window.name != '' ? window.name + '_' : '') + 'browser'),
        <%=(RemoteSession != null && RemoteSession.BrowserResize.HasValue ? "'" + RemoteSession.BrowserResize.Value.ToString().ToUpper() + "'" : "null")%>,
        <%=(RemoteSession != null ? RemoteSession.ClientWidth.ToString() : "null")%>,
        <%=(RemoteSession != null ? RemoteSession.ClientHeight.ToString() : "null")%>,
        '<%=(RemoteSession != null ? RemoteSession.HostType.ToString() : HostType.RDP.ToString())%>',
        <%=(RemoteSession != null && !string.IsNullOrEmpty(RemoteSession.VMGuid) && !RemoteSession.VMEnhancedMode).ToString().ToLower()%>);">

    <!-- custom UI: all elements below, including the logo, are customizable into Default.css -->

    <form method="post" runat="server" id="mainForm">

        <!-- display resolution -->
        <input type="hidden" runat="server" id="width" />
        <input type="hidden" runat="server" id="height" />

        <!-- ********************************************************************************************************************************************************************************** -->
        <!-- *** LOGIN                                                                                                                                                                      *** -->
        <!-- ********************************************************************************************************************************************************************************** -->

        <div runat="server" id="login" class="container-login100" visible="false">
            <div id="loginMainPage" class="wrap-login100" visible="false">
                <!-- customizable logo -->
                <%--<div runat="server" id="logo"></div>--%>
                <div runat="server" id="logo" class="login100-pic js-tilt"></div>
                <div class="login100-form validate-form">
                    <span class="login100-form-title">RDP Login</span>
                    <!-- show or hide advanced controls -->
                    <div class="inputDiv" id="toggleAdvancedDiv">
                        <label id="advancedControlLabel" class="wrap-label100">Advanced Controls</label>
                        <label class="switch">
                            <input id="advancedControlInput" type="checkbox" runat="server" onclick="toggleAdvancedControls(this);" />
                            <span class="slider"></span>
                        </label>

                        <%--<input id="advancedControlInput" type="checkbox" runat="server" onclick="toggleAdvancedControls();" />--%>
                    </div>

                    <!-- standard mode -->
                    <div runat="server" id="hostConnectDiv">

                        <!-- type -->
                        <div id="hostTypeDiv" style="display: none;" class="inputDiv wrap-input100 validate-input">
                            <label id="hostTypeLabel" for="hostType" class="wrap-label100">Protocol</label>
                            <select runat="server" id="hostType" onchange="onHostTypeChange(this);" title="host type" class="drop-input100">
                                <option value="0" selected="selected">RDP</option>
                                <option value="0">RDP over VM bus (Hyper-V)</option>
                                <option value="1">SSH</option>
                            </select>
                        </div>

                        <!-- security -->
                        <div id="securityProtocolDiv" style="display: none;" class="inputDiv wrap-input100 validate-input">
                            <label id="securityProtocolLabel" for="securityProtocol" class="wrap-label100">Security</label>
                            <select runat="server" id="securityProtocol" class="drop-input100" title="NLA = safest, RDP = backward compatibility (if the server doesn't enforce NLA) and interactive logon (leave user and password empty); AUTO for Hyper-V VM or if not sure">
                                <option value="0" selected="selected">AUTO</option>
                                <option value="1">RDP</option>
                                <option value="2">TLS</option>
                                <option value="3">NLA</option>
                                <option value="4">NLA-EXT</option>
                            </select>
                        </div>

                        <!-- server -->
                        <div class="inputDiv" id="serverPortDiv" style="display: none;">
                            <label id="serverLabel" for="server" class="wrap-label100">Server (:port)</label>
                            <input type="text" runat="server" id="server" class="wrap-text-input100" title="host name or address (:port, if other than the standard 3389 (rdp), 2179 (rdp over vm bus) or 22 (ssh)). use [] for ipv6. CAUTION! if using a hostname or if you have a connection broker, make sure the DNS is reachable by myrtille (or myrtille has joined the domain)" />
                        </div>

                        <!-- hyper-v -->
                        <div id="vmDiv" style="display: none;">

                            <!-- vm guid -->
                            <div class="inputDiv" id="vmGuidDiv">
                                <label id="vmGuidLabel" for="vmGuid" class="wrap-label100">VM GUID</label>
                                <input type="text" runat="server" id="vmGuid" class="wrap-text-input100" title="guid of the Hyper-V VM to connect" />
                            </div>

                            <!-- enhanced mode -->
                            <%--                        <div class="inputDiv" id="vmEnhancedModeDiv">
                            <label id="vmEnhancedModeLabel" for="vmEnhancedMode" class="wrap-label100" >VM Enhanced Mode</label>
                            <input type="checkbox" runat="server" id="vmEnhancedMode" class="wrap-text-input100" title="faster display and clipboard/printer redirection, if supported by the guest VM" />
                        </div>--%>

                            <div class="inputDiv" id="vmEnhancedModeDiv">
                                <label id="vmEnhancedModeLabel" class="wrap-label100">VM Enhanced Mode</label>
                                <label class="switch">
                                    <input id="vmEnhancedMode" type="checkbox" runat="server" title="faster display and clipboard/printer redirection, if supported by the guest VM" />
                                    <span class="slider"></span>
                                </label>

                                <%--<input id="advancedControlInput" type="checkbox" runat="server" onclick="toggleAdvancedControls();" />--%>
                            </div>

                        </div>

                        <!-- domain -->
                        <div class="inputDiv" id="domainDiv" style="display: none;">
                            <label id="domainLabel" for="domain" class="wrap-label100">Domain (optional)</label>
                            <input type="text" runat="server" id="domain" class="wrap-text-input100" title="user domain (if applicable)" />
                        </div>

                    </div>

                    <!-- user -->
                    <div class="inputDiv">
                        <label id="userLabel" for="user" class="wrap-label100">User</label>
                        <input type="text" runat="server" id="user" class="wrap-text-input100" title="user name" />
                    </div>

                    <!-- password -->
                    <div class="inputDiv">
                        <label id="passwordLabel" for="password" class="wrap-label100">Password</label>
                        <input type="password" runat="server" id="password" class="wrap-text-input100" title="user password" />
                    </div>

                    <!-- hashed password (aka password 51) -->
                    <input type="hidden" runat="server" id="passwordHash" />

                    <!-- MFA password -->
                    <div class="inputDiv" runat="server" id="mfaDiv" visible="false">
                        <a runat="server" id="mfaProvider" href="#" target="_blank" tabindex="-1" title="MFA provider"></a>
                        <input type="text" runat="server" id="mfaPassword" class="wrap-text-input100" title="MFA password" />
                    </div>

                    <!-- program to run -->
                    <div class="inputDiv">
                        <label id="programLabel" for="program" class="wrap-label100">Program to run (optional)</label>
                        <input type="text" runat="server" id="program" class="wrap-text-input100" title="executable path, name and parameters (double quotes must be escaped) (optional)" />
                    </div>

                    <!-- connect -->
                    <input type="submit" runat="server" id="connect" value="Connect!" onserverclick="ConnectButtonClick" title="Click to Join Session" class="login100-form validate-form input100-submit" />

                    <!-- myrtille version -->
                    <div id="version" class="version100-field">
                        <a href="https://www.myrtille.io/" target="_blank" title="myrtille">
                            <img src="img/myrtille.png" alt="myrtille" width="15px" height="15px" />
                        </a>
                        <span class="versionText">
                            <%=typeof(Default).Assembly.GetName().Version%>
                        </span>
                    </div>

                    <!-- hosts management -->
                    <div runat="server" id="adminDiv" visible="false">
                        <a runat="server" id="adminUrl" href="?mode=admin">
                            <span runat="server" id="adminText">Hosts management</span>
                        </a>
                    </div>

                    <!-- connect error -->
                    <div id="errorDiv">
                        <span runat="server" id="connectError"></span>
                    </div>
                </div>
            </div>

        </div>

        <!-- ********************************************************************************************************************************************************************************** -->
        <!-- *** HOSTS                                                                                                                                                                      *** -->
        <!-- ********************************************************************************************************************************************************************************** -->

        <div runat="server" id="hosts" visible="false">

            <div id="hostsControl">

                <!-- enterprise user info -->
                <input type="text" runat="server" id="enterpriseUserInfo" title="logged in user" disabled="disabled" />

                <!-- new rdp host -->
                <input type="button" runat="server" id="newRDPHost" value="New RDP Host" onclick="openPopup('editHostPopup', 'EditHost.aspx?hostType=RDP');" title="New RDP Host (standard or over VM bus)" />

                <!-- new ssh host -->
                <input type="button" runat="server" id="newSSHHost" value="New SSH Host" onclick="openPopup('editHostPopup', 'EditHost.aspx?hostType=SSH');" title="New SSH Host" />

                <!-- logout -->
                <input type="button" runat="server" id="logout" value="Logout" onserverclick="LogoutButtonClick" title="Logout" />

            </div>

            <!-- hosts list -->
            <asp:Repeater runat="server" ID="hostsList" OnItemDataBound="hostsList_ItemDataBound">
                <ItemTemplate>
                    <div class="hostDiv">
                        <a runat="server" id="hostLink" title="connect">
                            <img src="<%# Eval("HostImage").ToString() %>" alt="host" width="128px" height="128px" />
                        </a>
                        <br />
                        <span runat="server" id="hostName"></span>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

        </div>

        <!-- ********************************************************************************************************************************************************************************** -->
        <!-- *** TOOLBAR                                                                                                                                                                    *** -->
        <!-- ********************************************************************************************************************************************************************************** -->

        <div runat="server" id="toolbarToggle" visible="false">
            <!-- icon from: https://icons8.com/ -->
            <img src="img/icons8-menu-horizontal-21.png" alt="show/hide toolbar" width="21px" height="21px" onclick="toggleToolbar();" />
        </div>

        <div runat="server" id="toolbar" visible="false" style="visibility: hidden; display: none;">

            <!-- server info -->
            <input type="text" runat="server" id="serverInfo" title="connected server" disabled="disabled" />

            <!-- user info -->
            <input type="text" runat="server" id="userInfo" title="connected user" disabled="disabled" />

            <!-- stat bar -->
            <input type="button" id="stat" value="Stat OFF" onclick="toggleStatMode();" title="display network and rendering info" />

            <!-- debug log -->
            <input type="button" id="debug" value="Debug OFF" onclick="toggleDebugMode();" title="display debug info" />

            <!-- browser mode -->
            <input type="button" id="browser" value="HTML5 OFF" onclick="toggleCompatibilityMode();" title="rendering mode" />

            <!-- scale display -->
            <input type="button" runat="server" id="scale" value="Scale OFF" onclick="toggleScaleDisplay();" title="scale the remote session to the browser size" disabled="disabled" />

            <!-- reconnect session -->
            <input type="button" runat="server" id="reconnect" value="Reconnect OFF" onclick="toggleReconnectSession();" title="reconnect the remote session to the browser size" disabled="disabled" />

            <!-- device keyboard. on devices without a physical keyboard, forces the device virtual keyboard to pop up, then allow to send text (a text target must be focused) -->
            <input type="button" runat="server" id="keyboard" value="Text" onclick="openPopup('virtualKeyboardPopup', 'VirtualKeyboard.aspx', false);" title="send some text into the remote session" disabled="disabled" />

            <!-- on-screen keyboard. on devices without a physical keyboard, display an on-screen keyboard, then allow to send characters (a text target must be focused) -->
            <input type="button" runat="server" id="osk" value="Keyboard" onclick="openPopup('onScreenKeyboardPopup', 'onScreenKeyboard.aspx', false);" title="on-screen keyboard" disabled="disabled" />

            <!-- clipboard synchronization -->
            <!-- this is a fallback/manual action if the async clipboard API is not supported/enabled/allowed (requires read/write access and HTTPS) -->
            <input type="button" runat="server" id="clipboard" value="Clipboard" onclick="openPopup('pasteClipboardPopup', 'PasteClipboard.aspx', false);" title="send some text into the remote clipboard" disabled="disabled" />

            <!-- upload/download file(s). only enabled if the connected server is localhost or if a domain is specified (so file(s) can be accessed within the remote session) -->
            <input type="button" runat="server" id="files" value="Files" onclick="openPopup('fileStoragePopup', 'FileStorage.aspx');" title="upload/download files to/from the user documents folder" disabled="disabled" />

            <!-- send ctrl+alt+del. may be useful to change the user password, for example -->
            <input type="button" runat="server" id="cad" value="Ctrl+Alt+Del" onclick="sendCtrlAltDel();" title="send Ctrl+Alt+Del" disabled="disabled" />

            <!-- send a right-click on the next touch or left-click action. may be useful on touchpads or iOS devices -->
            <input type="button" runat="server" id="mrc" value="Right-Click OFF" onclick="toggleRightClick(this);" title="if toggled on, send a Right-Click on the next touch or left-click action" disabled="disabled" />

            <!-- swipe up/down gesture management for touchscreen devices. emulate vertical scroll in applications -->
            <input type="button" runat="server" id="vswipe" value="VSwipe ON" onclick="toggleVerticalSwipe(this);" title="if toggled on, allow vertical scroll on swipe (experimental feature, disabled on IE/Edge)" disabled="disabled" />

            <!-- share session -->
            <input type="button" runat="server" id="share" value="Share" onclick="openPopup('shareSessionPopup', 'ShareSession.aspx');" title="share session" disabled="disabled" />

            <!-- disconnect -->
            <input type="button" runat="server" id="disconnect" value="Disconnect" onclick="doDisconnect();" title="disconnect session" disabled="disabled" />

            <!-- image quality -->
            <input type="range" runat="server" id="imageQuality" min="5" max="90" step="5" onchange="changeImageQuality(this.value);" title="image quality (lower quality = lower bandwidth usage)" disabled="disabled" />

            <!-- connection info -->
            <div id="statDiv"></div>

            <!-- debug info -->
            <div id="debugDiv"></div>

        </div>

        <!-- remote session display -->
        <div id="displayDiv"></div>

        <!-- remote session helpers -->
        <div id="cacheDiv"></div>
        <div id="msgDiv"></div>
        <div id="kbhDiv"></div>
        <div id="bgfDiv"></div>

        <!-- draggable popup -->
        <div id="dragDiv">
            <div id="dragHandle"></div>
        </div>

    </form>

    <script type="text/javascript" language="javascript" defer="defer">

        var dragDiv = document.getElementById('dragDiv');
        var dragHandle = document.getElementById('dragHandle');

        interact(dragDiv)
            .draggable({
                allowFrom: dragHandle,
                onmove: onDragMove
            });

        initDisplay();

        // auto-connect / start program from url
        // if the display resolution isn't set, the remote session isn't able to start; redirect with the client resolution
        if (window.location.href.indexOf('&connect=') != -1 && (window.location.href.indexOf('&width=') == -1 || window.location.href.indexOf('&height=') == -1)) {
            var width = document.getElementById('<%=width.ClientID%>').value;
            var height = document.getElementById('<%=height.ClientID%>').value;

            var redirectUrl = window.location.href;

            if (window.location.href.indexOf('&width=') == -1) {
                redirectUrl += '&width=' + width;
            }

            if (window.location.href.indexOf('&height=') == -1) {
                redirectUrl += '&height=' + height;
            }

            //alert('reloading page with url:' + redirectUrl);

            window.location.href = redirectUrl;
        }

        function initDisplay() {
            try {
                var display = new Display();

                // detect the browser width & height
                setClientResolution(display);

                // remote session toolbar
                if (<%=(RemoteSession != null && (RemoteSession.State == RemoteSessionState.Connecting || RemoteSession.State == RemoteSessionState.Connected)).ToString(CultureInfo.InvariantCulture).ToLower()%>) {
                    // the toolbar is enabled (web.config)
                    if (document.getElementById('<%=toolbar.ClientID%>') != null) {
                        // resume the saved toolbar state
                        if (getToggleCookie((parent != null && window.name != '' ? window.name + '_' : '') + 'toolbar')) {
                            toggleToolbar();
                        }

                        // in addition to having their states also saved into a cookie, stat, debug and compatibility buttons are always available into the toolbar (even for guest(s) if the remote session is shared)
                        document.getElementById('stat').value = getToggleCookie((parent != null && window.name != '' ? window.name + '_' : '') + 'stat') ? 'Stat ON' : 'Stat OFF';
                        document.getElementById('debug').value = getToggleCookie((parent != null && window.name != '' ? window.name + '_' : '') + 'debug') ? 'Debug ON' : 'Debug OFF';
                        document.getElementById('browser').value = getToggleCookie((parent != null && window.name != '' ? window.name + '_' : '') + 'browser') ? 'HTML5 OFF' : 'HTML5 ON';

                        // swipe is disabled on IE/Edge because it emulates mouse events by default (experimental)
                        document.getElementById('<%=vswipe.ClientID%>').disabled = document.getElementById('<%=vswipe.ClientID%>').disabled || display.isIEBrowser();
                    }
                }
            }
            catch (exc) {
                alert('myrtille initDisplay error: ' + exc.message);
            }
        }

        function onHostTypeChange(hostType) {
            var securityProtocolDiv = document.getElementById('securityProtocolDiv');
            if (securityProtocolDiv != null) {
                securityProtocolDiv.style.visibility = (hostType.selectedIndex == 0 || hostType.selectedIndex == 1 ? 'visible' : 'hidden');
                securityProtocolDiv.style.display = (hostType.selectedIndex == 0 || hostType.selectedIndex == 1 ? 'block' : 'none');
            }

            var vmDiv = document.getElementById('vmDiv');
            if (vmDiv != null) {
                vmDiv.style.visibility = (hostType.selectedIndex == 1 ? 'visible' : 'hidden');
                vmDiv.style.display = (hostType.selectedIndex == 1 ? 'block' : 'none');
            }
        }

        function setClientResolution(display) {
            // browser size. default 1024x768
            var width = display.getBrowserWidth() - display.getHorizontalOffset();
            var height = display.getBrowserHeight() - display.getVerticalOffset();

            //alert('client width: ' + width + ', height: ' + height);

            document.getElementById('<%=width.ClientID%>').value = width;
            document.getElementById('<%=height.ClientID%>').value = height;
        }

        function disableControl(controlId) {
            var control = document.getElementById(controlId);
            if (control != null) {
                control.disabled = true;
            }
        }

        function disableToolbar() {
            disableControl('stat');
            disableControl('debug');
            disableControl('browser');
            disableControl('<%=scale.ClientID%>');
            disableControl('<%=reconnect.ClientID%>');
            disableControl('<%=keyboard.ClientID%>');
            disableControl('<%=osk.ClientID%>');
            disableControl('<%=clipboard.ClientID%>');
            disableControl('<%=files.ClientID%>');
            disableControl('<%=cad.ClientID%>');
            disableControl('<%=mrc.ClientID%>');
            disableControl('<%=vswipe.ClientID%>');
            disableControl('<%=share.ClientID%>');
            disableControl('<%=disconnect.ClientID%>');
            disableControl('<%=imageQuality.ClientID%>');
        }

        function toggleToolbar() {
            var toolbar = document.getElementById('<%=toolbar.ClientID%>');

            if (toolbar == null)
                return;

            if (toolbar.style.visibility == 'visible') {
                toolbar.style.visibility = 'hidden';
                toolbar.style.display = 'none';
            }
            else {
                toolbar.style.visibility = 'visible';
                toolbar.style.display = 'block';
            }

            setCookie((parent != null && window.name != '' ? window.name + '_' : '') + 'toolbar', toolbar.style.visibility == 'visible' ? 1 : 0);
        }

        function getToggleCookie(name) {
            if (<%=(RemoteSession == null).ToString().ToLower()%>)
                return false;

            var value = getCookie(name);
            if (value == null)
                return false;

            return (value == '1' ? true : false);
        }

        function onDragMove(event) {
            var target = event.target,
                x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx,
                y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy;

            if ('webkitTransform' in target.style || 'transform' in target.style) {
                target.style.webkitTransform =
                    target.style.transform =
                    'translate(' + x + 'px, ' + y + 'px)';
            }
            else {
                target.style.left = x + 'px';
                target.style.top = y + 'px';
            }

            target.setAttribute('data-x', x);
            target.setAttribute('data-y', y);
        }

        function toggleAdvancedControls(advancedControlInputShow) {

            // Set Default & Hide Host Type
            var hostTypeDiv = document.getElementById('hostTypeDiv'); //Represent (UI Option) Protocol Selection
            var hostType = document.getElementById('hostType'); //to default set teh value to RDP
            var securityProtocolDiv = document.getElementById('securityProtocolDiv'); //Represent (UI Option) Security Selection
            var serverPortDiv = document.getElementById('serverPortDiv'); //Represent (UI Option) Server (:port) Selection
            var vmDiv = document.getElementById('vmDiv'); //Represent (UI Option) VM GUID & VM Enhanced Mode Selection
            var domainDiv = document.getElementById('domainDiv'); //Represent (UI Option) Domain (optional) Selection
            //Set default host to RDP

            hostType.value = '0';
            if (advancedControlInputShow.checked) {
                hostTypeDiv.style.visibility = 'visible';
                hostTypeDiv.style.display = 'block';
                securityProtocolDiv.style.visibility = 'visible';
                securityProtocolDiv.style.display = 'block';
                serverPortDiv.style.visibility = 'visible';
                serverPortDiv.style.display = 'block';
                //vmDiv.style.visibility = 'hidden';
                //vmDiv.style.display = 'none';
                domainDiv.style.visibility = 'visible';
                domainDiv.style.display = 'block';
            } else {
                hostTypeDiv.style.visibility = 'hidden';
                hostTypeDiv.style.display = 'none';
                securityProtocolDiv.style.visibility = 'hidden';
                securityProtocolDiv.style.display = 'none';
                serverPortDiv.style.visibility = 'hidden';
                serverPortDiv.style.display = 'none';
                vmDiv.style.visibility = 'hidden';
                vmDiv.style.display = 'none';
                domainDiv.style.visibility = 'hidden';
                domainDiv.style.display = 'none';
            }

            //$('#hostTypeDiv').toggle();
            //$('#securityProtocolDiv').toggle();
            //$('#serverPortDiv').toggle();
            //$('#domainDiv').toggle();
            //$('#vmDiv').toggle();
            return false;
        }
        function ConnectButtonClick() {
            document.getElementById('loginMainPage').style.visibility = 'hidden';
        }

    </script>

    <script>

        $('.js-tilt').tilt({
            scale: 1.1
        })

    </script>

</body>

</html>
