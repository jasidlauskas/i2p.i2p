<%@page contentType="text/html" import="net.i2p.i2ptunnel.web.EditBean"
%><%@page trimDirectiveWhitespaces="true"
%><?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<jsp:useBean class="net.i2p.i2ptunnel.web.EditBean" id="editBean" scope="request" />
<jsp:useBean class="net.i2p.i2ptunnel.web.Messages" id="intl" scope="request" />
<% String tun = request.getParameter("tunnel");
   int curTunnel = -1;
   if (tun != null) {
     try {
       curTunnel = Integer.parseInt(tun);
     } catch (NumberFormatException nfe) {
       curTunnel = -1;
     }
   }
%>

<%
    response.setHeader("Content-Security-Policy", "default-src 'self'; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline'");
%>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <title><%=intl._t("Hidden Services Manager")%> - <%=intl._t("Edit Hidden Service")%></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="Content-Type" content="application/xhtml+xml; charset=UTF-8" />
    <link href="/themes/console/images/favicon.ico" type="image/x-icon" rel="shortcut icon" />

    <% if (editBean.allowCSS()) {
  %><link rel="icon" href="<%=editBean.getTheme()%>images/favicon.ico" />
    <link href="<%=editBean.getTheme()%>i2ptunnel.css?<%=net.i2p.CoreVersion.VERSION%>" rel="stylesheet" type="text/css" /> 
    <% }
  %>
<style type='text/css'>
input.default { width: 1px; height: 1px; visibility: hidden; }
</style>
<script src="/js/resetScroll.js" type="text/javascript"></script>
</head>
<body id="tunnelEditPage">

<%

  if (editBean.isInitialized()) {

%>
    <form method="post" action="list">

<div class="panel">

                <%
                String tunnelTypeName;
                String tunnelType;
                if (curTunnel >= 0) {
                    tunnelTypeName = editBean.getTunnelType(curTunnel);
                    tunnelType = editBean.getInternalType(curTunnel);
                  %><h2><%=intl._t("Edit Server Settings")%> (<%=editBean.getTunnelName(curTunnel)%>)</h2><% 
                } else {
                    tunnelTypeName = editBean.getTypeName(request.getParameter("type"));
                    tunnelType = net.i2p.data.DataHelper.stripHTML(request.getParameter("type"));
                  %><h2><%=intl._t("New Server Settings")%></h2><% 
                } %>
                <input type="hidden" name="tunnel" value="<%=curTunnel%>" />
                <input type="hidden" name="nonce" value="<%=net.i2p.i2ptunnel.web.IndexBean.getNextNonce()%>" />
                <input type="hidden" name="type" value="<%=tunnelType%>" />
                <%
                // these are four keys that are generated automatically on first save,
                // and we want to persist in i2ptunnel.config, but don't want to
                // show clogging up the custom options form.
                String key = editBean.getKey1(curTunnel);
                if (key != null && key.length() > 0) { %>
                    <input type="hidden" name="key1" value="<%=key%>" />
                <% }
                key = editBean.getKey2(curTunnel);
                if (key != null && key.length() > 0) { %>
                    <input type="hidden" name="key2" value="<%=key%>" />
                <% }
                key = editBean.getKey3(curTunnel);
                if (key != null && key.length() > 0) { %>
                    <input type="hidden" name="key3" value="<%=key%>" />
                <% }
                key = editBean.getKey4(curTunnel);
                if (key != null && key.length() > 0) { %>
                    <input type="hidden" name="key4" value="<%=key%>" />
                <% } %>
                <input type="submit" class="default" name="action" value="Save changes" />

    <table id="serverTunnelEdit" class="tunnelConfig">
        <tr>
            <th>
                <%=intl._t("Name")%>
            </th>
            <th>
                <%=intl._t("Type")%>
            </th>
        </tr>

        <tr>
            <td>
                <input type="text" size="30" maxlength="50" name="name" title="<%=intl._t("Name of tunnel to be displayed on Tunnel Manager home page and the router console sidebar")%>" value="<%=editBean.getTunnelName(curTunnel)%>" class="freetext tunnelName" />
            </td>
            <td>
                <%=tunnelTypeName%>
            </td>
        </tr>

        <tr>
            <th>
                <%=intl._t("Description")%>
            </th>

            <th>
                <%=intl._t("Auto Start Tunnel")%>
            </th>
        </tr>

        <tr>
            <td>
                <input type="text" size="60" maxlength="80" name="nofilter_description" title="<%=intl._t("Description of tunnel to be displayed on Tunnel Manager home page")%>" value="<%=editBean.getTunnelDescription(curTunnel)%>" class="freetext tunnelDescriptionText" />
            </td>

            <td>
                <label title="<%=intl._t("Enable this option to ensure this service is available when the router starts")%>"><input value="1" type="checkbox" name="startOnLoad"<%=(editBean.startAutomatically(curTunnel) ? " checked=\"checked\"" : "")%> class="tickbox" />
                <%=intl._t("Automatically start tunnel when router starts")%></label>
            </td>
        </tr>

        <tr>
            <th colspan="2">
         <% if ("streamrserver".equals(tunnelType)) { %>
                <%=intl._t("Access Point")%>
         <% } else { %>
                <%=intl._t("Target")%>
         <% } %>
            </th>
        </tr>

        <tr>
         <% if (!"streamrserver".equals(tunnelType)) { %>
            <td>
                <b><%=intl._t("Host")%>:</b>
                <input type="text" size="20" name="targetHost" title="<%=intl._t("Hostname or IP address of the target server")%>" value="<%=editBean.getTargetHost(curTunnel)%>" class="freetext host" />
            </td>
         <% } /* !streamrserver */ %>

            <td>
                <b><%=intl._t("Port")%>:</b>
                    <% String value = editBean.getTargetPort(curTunnel);
                       if (value == null || "".equals(value.trim())) {
                           out.write(" <span class=\"required\"><font color=\"red\">(");
                           out.write(intl._t("required"));
                           out.write(")</font></span>");
                       }
                     %>
                <input type="text" size="6" maxlength="5" id="targetPort" name="targetPort" title="<%=intl._t("Specify the port the server is running on")%>" value="<%=editBean.getTargetPort(curTunnel)%>" class="freetext port" placeholder="required" />
         <% if (!"streamrserver".equals(tunnelType)) { %>
                <label title="<%=intl._t("To avoid traffic sniffing if connecting to a remote server, you can enable an SSL connection. Note that the target server must be configured to accept SSL connections.")%>"><input value="1" type="checkbox" name="useSSL"<%=(editBean.isSSLEnabled(curTunnel) ? " checked=\"checked\"" : "")%> class="tickbox" />
                <%=intl._t("Use SSL to connect to target")%></label>
         <% } /* !streamrserver */ %>
            </td>
         <% if ("httpbidirserver".equals(tunnelType)) { %>
        </tr>

        <tr>
            <th colspan="2">
                <%=intl._t("Access Point")%>
            </th>
        </tr>

        <tr>
            <td>
                <b><%=intl._t("Port")%>:</b>

           	     <% String value4 = editBean.getClientPort(curTunnel);
           	        if (value4 == null || "".equals(value4.trim())) {
           	            out.write(" <span class=\"required\"><font color=\"red\">(");
           	            out.write(intl._t("required"));
           	            out.write(")</font></span>");
           	        }
               	      %>

                 <input type="text" size="6" maxlength="5" name="port" title="<%=intl._t("Port required to access service (this can be a different port to the port the service is hosted on)")%>" value="<%=editBean.getClientPort(curTunnel)%>" class="freetext port" placeholder="required" />
            </td>
         <% } /* httpbidirserver */ %>
         <% if ("httpbidirserver".equals(tunnelType) || "streamrserver".equals(tunnelType)) { %>

            <td>
                <b><%=intl._t("Reachable by")%>:</b>

                <select id="reachableBy" name="reachableBy" title="<%=intl._t("Listening interface (IP address) for client access (normally 127.0.0.1)")%>" class="selectbox">
              <%
                    String clientInterface = editBean.getClientInterface(curTunnel);
                    for (String ifc : editBean.interfaceSet()) {
                        out.write("<option value=\"");
                        out.write(ifc);
                        out.write('\"');
                        if (ifc.equals(clientInterface))
                            out.write(" selected=\"selected\"");
                        out.write('>');
                        out.write(ifc);
                        out.write("</option>\n");
                    }
              %>
                </select>
            </td>
         <% } /* httpbidirserver || streamrserver */ %>
        </tr>


            <% if (("httpserver".equals(tunnelType)) || ("httpbidirserver".equals(tunnelType))) {
          %>

        <tr>
            <th>
                <%=intl._t("Website Hostname")%>
            </th>
            <th></th>
        </tr>

        <tr>
            <td colspan="2">
                <input type="text" size="20" id="websiteName" name="spoofedHost" title="<%=intl._t("Website Hostname e.g. mysite.i2p")%>" value="<%=editBean.getSpoofedHost(curTunnel)%>" class="freetext" />
                <%=intl._t("(leave blank for outproxies)")%>
            </td>
        </tr>
            <% }
          %>

        <tr>
            <th>
                <%=intl._t("Local destination")%>
            </th>
            <th>
                <%=intl._t("Private key file")%>
            </th>
        </tr>

        <tr>
            <td>
                <div class="displayText" title="<%=intl._t("Read Only: Local Destination (if known)")%>" tabindex="0" onblur="resetScrollLeft(this)"><%=editBean.getDestinationBase64(curTunnel)%></div>
            </td>
            <td>
                    <% String value3 = editBean.getPrivateKeyFile(curTunnel);
                       if (value3 == null || "".equals(value3.trim())) {
                           out.write(" <span class=\"required\"><font color=\"red\">(");
                           out.write(intl._t("required"));
                           out.write(")</font></span>");
                       }
                     %>
                <input type="text" size="30" id="privKeyFile" name="privKeyFile" title="<%=intl._t("Path to Private Key File")%>" value="<%=editBean.getPrivateKeyFile(curTunnel)%>" class="freetext" placeholder="required" />
            </td>
        </tr>

<%
  /******
%>
            <% if (("httpserver".equals(tunnelType)) || ("httpbidirserver".equals(tunnelType))) {
                   String sig = editBean.getNameSignature(curTunnel);
                   if (sig.length() > 0) {
          %><div id="sigField" class="rowItem">
                    <%=intl._t("Hostname Signature")%>
                <input type="text" size="30" readonly="readonly" title="<%=intl._t("Use to prove that the website name is for this destination")%>" value="<%=sig%>" wrap="off" class="freetext" />
            </div>
         <%
                   }  // sig
               }  // type
  ****/

            String b64 = editBean.getDestinationBase64(curTunnel);
            if (!"".equals(b64)) {
         %>
        <tr>

        <%
                b64 = b64.replace("=", "%3d");
                String name = editBean.getSpoofedHost(curTunnel);
                if (name == null || name.equals(""))
                    name = editBean.getTunnelName(curTunnel);
                // mysite.i2p is set in the installed i2ptunnel.config
                if (name != null && !name.equals("") && !name.equals("mysite.i2p") && !name.contains(" ") && name.endsWith(".i2p")) {
         %>

            <td class="buttons" colspan="2">
              <a class="control" title="<%=intl._t("Generate a QR Code for this domain")%>" href="/imagegen/qr?s=320&amp;t=<%=name%>&amp;c=http%3a%2f%2f<%=name%>%2f%3fi2paddresshelper%3d<%=b64%>" target="_top"><%=intl._t("Generate QR Code")%></a>
              <a class="control" title="<%=intl._t("Add to Private addressbook")%>" href="/susidns/addressbook.jsp?book=private&amp;hostname=<%=name%>&amp;destination=<%=b64%>#add"><%=intl._t("Add to local addressbook")%></a>
              <a class="control" title="<%=intl._t("Register, unregister or change details for hostname")%>" href="register?tunnel=<%=curTunnel%>"><%=intl._t("Registration Authentication")%></a>
            </td>
        <%
                } else {
          %>
            <td class="infohelp" colspan="2">
                <%=intl._t("Note: In order to enable QR code generation or registration authentication, configure the Website Hostname field (for websites) or the Name field (everything else) above with an .i2p suffixed hostname e.g. mynewserver.i2p")%>
            </td>
        <%
                }  // name
         %>
        </tr>

        <%
            }  // b64

         %>
    </table>

    <h3><%=intl._t("Advanced networking options")%></h3>

    <table id="#advancedServerTunnelOptions" class="tunnelConfig">
        <tr>
            <th colspan="2">
                <%=intl._t("Tunnel Options")%>
            </th>
        </tr>

        <tr>
            <td>
                <b><%=intl._t("Length")%></b>
            </td>

            <td>
                <b><%=intl._t("Variance")%></b>
            </td>
        </tr>

        <tr>
            <td>
                <select id="tunnelDepth" name="tunnelDepth" title="<%=intl._t("Length of each Tunnel")%>" class="selectbox">
                    <% int tunnelDepth = editBean.getTunnelDepth(curTunnel, 3);
                  %><option value="0"<%=(tunnelDepth == 0 ? " selected=\"selected\"" : "") %>><%=intl._t("0 hop tunnel (no anonymity)")%></option>
                    <option value="1"<%=(tunnelDepth == 1 ? " selected=\"selected\"" : "") %>><%=intl._t("1 hop tunnel (low anonymity)")%></option>
                    <option value="2"<%=(tunnelDepth == 2 ? " selected=\"selected\"" : "") %>><%=intl._t("2 hop tunnel (medium anonymity)")%></option>
                    <option value="3"<%=(tunnelDepth == 3 ? " selected=\"selected\"" : "") %>><%=intl._t("3 hop tunnel (high anonymity)")%></option>
                <% if (editBean.isAdvanced()) {
                  %><option value="4"<%=(tunnelDepth == 4 ? " selected=\"selected\"" : "") %>>4 hop tunnel</option>
                    <option value="5"<%=(tunnelDepth == 5 ? " selected=\"selected\"" : "") %>>5 hop tunnel</option>
                    <option value="6"<%=(tunnelDepth == 6 ? " selected=\"selected\"" : "") %>>6 hop tunnel</option>
                    <option value="7"<%=(tunnelDepth == 7 ? " selected=\"selected\"" : "") %>>7 hop tunnel</option>
                <% } else if (tunnelDepth > 3) { 
                %>    <option value="<%=tunnelDepth%>" selected="selected"><%=tunnelDepth%> <%=intl._t("hop tunnel (very poor performance)")%></option>
                <% }
              %></select>
            </td>

            <td>
                <select id="tunnelVariance" name="tunnelVariance" title="<%=intl._t("Level of Randomization for Tunnel Depth")%>" class="selectbox">
                    <% int tunnelVariance = editBean.getTunnelVariance(curTunnel, 0);
                  %><option value="0"<%=(tunnelVariance  ==  0 ? " selected=\"selected\"" : "") %>><%=intl._t("0 hop variance (no randomization, consistent performance)")%></option>
                    <option value="1"<%=(tunnelVariance  ==  1 ? " selected=\"selected\"" : "") %>><%=intl._t("+ 0-1 hop variance (medium additive randomization, subtractive performance)")%></option>
                    <option value="2"<%=(tunnelVariance  ==  2 ? " selected=\"selected\"" : "") %>><%=intl._t("+ 0-2 hop variance (high additive randomization, subtractive performance)")%></option>
                    <option value="-1"<%=(tunnelVariance == -1 ? " selected=\"selected\"" : "") %>><%=intl._t("+/- 0-1 hop variance (standard randomization, standard performance)")%></option>
                    <option value="-2"<%=(tunnelVariance == -2 ? " selected=\"selected\"" : "") %>><%=intl._t("+/- 0-2 hop variance (not recommended)")%></option>
                <% if (tunnelVariance > 2 || tunnelVariance < -2) {
                %>    <option value="<%=tunnelVariance%>" selected="selected"><%= (tunnelVariance > 2 ? "+ " : "+/- ") %>0-<%=tunnelVariance%> <%=intl._t("hop variance")%></option>
                <% }
              %></select>
            </td>
        </tr>

        <tr>
            <td>
                <b><%=intl._t("Count")%></b>
            </td>

            <td>
                <b><%=intl._t("Backup Count")%></b>
            </td>
        </tr>

        <tr>
            <td>
                <select id="tunnelQuantity" name="tunnelQuantity" title="<%=intl._t("Number of Tunnels in Group")%>" class="selectbox">
                    <%=editBean.getQuantityOptions(curTunnel)%>
                </select>
            </td>

            <td>
                <select id="tunnelBackupQuantity" name="tunnelBackupQuantity" title="<%=intl._t("Number of Reserve Tunnels")%>" class="selectbox">
                    <% int tunnelBackupQuantity = editBean.getTunnelBackupQuantity(curTunnel, 0);
                  %><option value="0"<%=(tunnelBackupQuantity == 0 ? " selected=\"selected\"" : "") %>><%=intl._t("0 backup tunnels (0 redundancy, no added resource usage)")%></option>
                    <option value="1"<%=(tunnelBackupQuantity == 1 ? " selected=\"selected\"" : "") %>><%=intl._t("1 backup tunnel each direction (low redundancy, low resource usage)")%></option>
                    <option value="2"<%=(tunnelBackupQuantity == 2 ? " selected=\"selected\"" : "") %>><%=intl._t("2 backup tunnels each direction (medium redundancy, medium resource usage)")%></option>
                    <option value="3"<%=(tunnelBackupQuantity == 3 ? " selected=\"selected\"" : "") %>><%=intl._t("3 backup tunnels each direction (high redundancy, high resource usage)")%></option>
                <% if (tunnelBackupQuantity > 3) {
                %>    <option value="<%=tunnelBackupQuantity%>" selected="selected"><%=tunnelBackupQuantity%> <%=intl._t("backup tunnels")%></option>
                <% }
              %></select>
            </td>
        </tr>

         <% if (!"streamrserver".equals(tunnelType)) { %>

        <tr>
            <th colspan="2">
                <%=intl._t("Profile")%>
            </th>
        </tr>

        <tr>
            <td colspan="2">
                <select id="profile" name="profile" title="<%=intl._t("Connection Profile")%>" class="selectbox">
                    <% boolean interactiveProfile = editBean.isInteractive(curTunnel);
                  %><option <%=(interactiveProfile == true  ? "selected=\"selected\" " : "")%>value="interactive"><%=intl._t("interactive connection")%> </option>
                    <option <%=(interactiveProfile == false ? "selected=\"selected\" " : "")%>value="bulk"><%=intl._t("bulk connection (downloads/websites/BT)")%> </option>
                </select>
            </td>
        </tr>

         <% } /* !streamrserver */ %>

        <tr>
            <th colspan="2">
                <%=intl._t("Router I2CP Address")%>
            </th>
        </tr>
        <tr>
            <td>
                <b><%=intl._t("Host")%>:</b>
                <input type="text" id="clientHost" name="clientHost" size="20" title="<%=intl._t("I2CP Hostname or IP")%>" value="<%=editBean.getI2CPHost(curTunnel)%>" class="freetext" <% if (editBean.isRouterContext()) { %> readonly="readonly" <% } %> />
            </td>
            <td>
                <b><%=intl._t("Port")%>:</b>
                <input type="text" id="clientPort" name="clientport" size="20" title="<%=intl._t("I2CP Port Number")%>" value="<%=editBean.getI2CPPort(curTunnel)%>" class="freetext" <% if (editBean.isRouterContext()) { %> readonly="readonly" <% } %> />
            </td>
        </tr>

        <tr>
            <th colspan="2">
                <%=intl._t("Encrypt Leaseset")%>
            </th>
        </tr>

        <tr>
            <td colspan="2">
                <label title="<%=intl._t("Only clients with the encryption key will be able to connect")%>"><input value="1" type="checkbox" id="startOnLoad" name="encrypt"<%=(editBean.getEncrypt(curTunnel) ? " checked=\"checked\"" : "")%> class="tickbox" />
                <%=intl._t("Only allow clients with the encryption key to connect to this server")%></label>
            </td>
        </tr>

        <tr>
            <td>
                <b><%=intl._t("Encryption Key")%></b>
            </td>

            <td>
                <b><%=intl._t("Generate New Key")%></b> (<%=intl._t("Tunnel must be stopped first")%>)
            </td>
        </tr>

        <tr>
            <td>
                <textarea rows="1" style="height: 3em;" cols="44" id="leasesetKey" name="encryptKey" title="<%=intl._t("Encryption key required to access this service")%>" wrap="off" spellcheck="false"><%=editBean.getEncryptKey(curTunnel)%></textarea>
            </td>

            <td>
                <button class="control" type="submit" name="action" value="Generate" title="<%=intl._t("Generate new encryption key")%>"><%=intl._t("Generate")%></button>
            </td>
        </tr>

        <tr>
            <th colspan="2">
                <%=intl._t("Restricted Access List")%>
            </th>
        </tr>

        <tr>
            <td colspan="2">
                <span class="multiOption"><label title="<%=intl._t("Allow all clients to connect to this service")%>"><input value="0" type="radio" name="accessMode"<%=(editBean.getAccessMode(curTunnel).equals("0") ? " checked=\"checked\"" : "")%> class="tickbox" />
                    <%=intl._t("Disable")%></label></span>
                <span class="multiOption"><label title="<%=intl._t("Prevent listed clients from connecting to this service")%>"><input value="2" type="radio" name="accessMode"<%=(editBean.getAccessMode(curTunnel).equals("2") ? " checked=\"checked\"" : "")%> class="tickbox" />
                    <%=intl._t("Blacklist")%></label></span>
                <span class="multiOption"><label title="<%=intl._t("Only allow listed clients to connect to this service")%>"><input value="1" type="radio" name="accessMode"<%=(editBean.getAccessMode(curTunnel).equals("1") ? " checked=\"checked\"" : "")%> class="tickbox" />
                    <%=intl._t("Whitelist")%></label></span>
            </td>
        </tr>

        <tr>
            <td colspan="2">
                <b><%=intl._t("Access List")%></b> (<%=intl._t("Specify clients, 1 per line")%>)
            </td>
        </tr>

        <tr>
            <td colspan="2">
                <textarea rows="2" style="height: 8em;" cols="60" name="accessList" title="<%=intl._t("Control access to this service")%>" wrap="off" spellcheck="false"><%=editBean.getAccessList(curTunnel)%></textarea>
            </td>
        </tr>

        <tr>
            <th colspan="2">
                <%=intl._t("Server Access Options")%>
            </th>
        </tr>

            <% if (("httpserver".equals(tunnelType)) || ("httpbidirserver".equals(tunnelType))) {
            %>

        <tr>
            <td>
                <label title="<%=intl._t("Prevent clients from accessing this service via an inproxy")%>"><input value="1" type="checkbox" name="rejectInproxy"<%=(editBean.isRejectInproxy(curTunnel) ? " checked=\"checked\"" : "")%> class="tickbox" />
                <%=intl._t("Block Access via Inproxies")%></label>
            </td>

            <td>
                <label title="<%=intl._t("Deny accesseses with referers (probably from inproxies)")%>"><input value="1" type="checkbox" name="rejectReferer"<%=(editBean.isRejectReferer(curTunnel) ? " checked=\"checked\"" : "")%> class="tickbox" />
                <%=intl._t("Block Accesses containing Referers")%></label>
            </td>
        </tr>

        <tr>
            <td>
                <label title="<%=intl._t("Deny User-Agents matching these strings (probably from inproxies)")%>"><input value="1" type="checkbox" name="rejectUserAgents"<%=(editBean.isRejectUserAgents(curTunnel) ? " checked=\"checked\"" : "")%> class="tickbox" />
                <%=intl._t("Block these User-Agents")%></label>
            </td>

            <td>
                <input type="text" id="userAgents" name="userAgents" size="20" title="<%=intl._t("comma separated, e.g. Mozilla,Opera (case-sensitive)")%>" value="<%=editBean.getUserAgents(curTunnel)%>" class="freetext" />
            </td>
        </tr>
            <% } // httpserver
            %>

        <tr>
            <td>
                <label title="<%=intl._t("Use unique IP addresses for each connecting client (local non-SSL servers only)")%>"><input value="1" type="checkbox" name="uniqueLocal"<%=(editBean.getUniqueLocal(curTunnel) ? " checked=\"checked\"" : "")%> class="tickbox" />
                <%=intl._t("Unique Local Address per Client")%></label>
            </td>

            <td>
                <label title="<%=intl._t("Only enable if you are hosting this service on multiple routers")%>"><input value="1" type="checkbox" name="multihome"<%=(editBean.getMultihome(curTunnel) ? " checked=\"checked\"" : "")%> class="tickbox" />
                <%=intl._t("Optimize for Multihoming")%></label>
            </td>
        </tr>

        <tr>
            <th colspan="2">
                <%=intl._t("Server Throttling")%>
            </th>
        </tr>
        <tr>
            <td id="throttle" colspan="4">

                <table id="throttler">
                    <tr>
                        <th colspan="5">
                            <%=intl._t("Inbound connection limits (0=unlimited)")%>
                        </th>
                    </tr>
                    <tr>
                        <td></td>
                        <td><b><%=intl._t("Per Minute")%></b></td>
                        <td><b><%=intl._t("Per Hour")%></b></td>
                        <td><b><%=intl._t("Per Day")%></b></td>
                        <td class="blankColumn"></td>
                    </tr>
                    <tr>
                        <td><b><%=intl._t("Per Client")%></b></td>
                        <td>
                            <input type="text" name="limitMinute" title="<%=intl._t("Maximum number of web page requests per minute for a unique client before access to the server is blocked")%>" value="<%=editBean.getLimitMinute(curTunnel)%>" class="freetext" />
                        </td>
                        <td>
                            <input type="text" name="limitHour" title="<%=intl._t("Maximum number of web page requests per hour for a unique client before access to the server is blocked")%>" value="<%=editBean.getLimitHour(curTunnel)%>" class="freetext" />
                        </td>
                        <td>
                            <input type="text" name="limitDay" title="<%=intl._t("Maximum number of web page requests per day for a unique client before access to the server is blocked")%>" value="<%=editBean.getLimitDay(curTunnel)%>" class="freetext" />
                        </td>
                        <td class="blankColumn"></td>
                    </tr>
                    <tr>
                        <td><b><%=intl._t("Total")%></b></td>
                        <td>
                            <input type="text" name="totalMinute" title="<%=intl._t("Total number of web page requests per minute before access to the server is blocked")%>" value="<%=editBean.getTotalMinute(curTunnel)%>" class="freetext" />
                        </td>
                        <td>
                            <input type="text" name="totalHour" title="<%=intl._t("Total number of web page requests per hour before access to the server is blocked")%>" value="<%=editBean.getTotalHour(curTunnel)%>" class="freetext" />
                        </td>
                        <td>
                            <input type="text" name="totalDay" title="<%=intl._t("Total number of web page requests per day before access to the server is blocked")%>" value="<%=editBean.getTotalDay(curTunnel)%>" class="freetext" />
                        </td>
                        <td class="blankColumn"></td>
                    </tr>
                    <tr>
                        <th colspan="5"><%=intl._t("Max concurrent connections (0=unlimited)")%></th>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <input type="text" name="maxStreams" title="<%=intl._t("Maximum number of simultaneous client connections")%>" value="<%=editBean.getMaxStreams(curTunnel)%>" class="freetext" />
                        </td>
                        <td></td>
                        <td></td>
                        <td class="blankColumn"></td>
                    </tr>

            <% if (("httpserver".equals(tunnelType)) || ("httpbidirserver".equals(tunnelType))) {
              %>
                    <tr>
                        <th colspan="5">
                            <%=intl._t("POST limits (0=unlimited)")%>
                        </th>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <b><%=intl._t("Per Period")%></b>
                        </td>
                        <td>
                            <b><%=intl._t("Ban Duration")%></b>
                        </td>
                        <td></td>
                        <td class="blankColumn"></td>
                    </tr>
                    <tr>
                        <td>
                            <b><%=intl._t("Per Client")%>
                            </b>
                        </td>
                        <td>
                            <input type="text" name="postMax" title="<%=intl._t("Maximum number of post requests permitted for a unique client for the configured timespan")%>" value="<%=editBean.getPostMax(curTunnel)%>" class="freetext quantity"/>
                        </td>
                        <td colspan="2">
                            <input type="text" name="postBanTime" title="<%=intl._t("If a client exceeds the maximum number of post requests per allocated period, enforce a ban for this number of minutes")%>" value="<%=editBean.getPostBanTime(curTunnel)%>" class="freetext period"/>
                            <%=intl._t("minutes")%>
                        </td>
                        <td class="blankColumn"></td>
                    </tr>
                    <tr>
                        <td>
                            <b><%=intl._t("Total")%>
                            </b>
                        </td>
                        <td>
                            <input type="text" name="postTotalMax" title="<%=intl._t("Total number of post requests permitted for the configured timespan")%>" value="<%=editBean.getPostTotalMax(curTunnel)%>" class="freetext quantity"/>
                        </td>
                        <td colspan="2">
                            <input type="text" name="postTotalBanTime" title="<%=intl._t("If the maximum number of post requests per allocated period is exceeded, enforce a global access ban for this number of minutes")%>" value="<%=editBean.getPostTotalBanTime(curTunnel)%>" class="freetext period"/>
                            <%=intl._t("minutes")%>
                        </td>
                        <td class="blankColumn"></td>
                    </tr>
                    <tr>
                        <td>
                            <b><%=intl._t("POST limit period")%>
                            </b>
                        </td>
                        <td colspan="2">
                            <input type="text" name="postCheckTime" title="<%=intl._t("Timespan for the maximum number of post requests to be reached before a ban is triggered")%>" value="<%=editBean.getPostCheckTime(curTunnel)%>" class="freetext period"/>
                            <%=intl._t("minutes")%>
                        </td>
                        <td></td>
                        <td class="blankColumn"></td>
                    </tr>

            <% } // httpserver
          %>

                </table>
            </td>
        </tr>

        <tr>
            <th colspan="2">
                <%=intl._t("Reduce tunnel quantity when idle")%>
            </th>
        </tr>

        <tr>
            <td colspan="2">
                <label><input value="1" type="checkbox" id="startOnLoad" name="reduce" <%=(editBean.getReduce(curTunnel) ? " checked=\"checked\"" : "")%> class="tickbox" />
                <%=intl._t("Reduce tunnel quantity when idle to conserve resources")%></label>
            </td>
        </tr>
        <tr>
            <td>
                <b><%=intl._t("Reduced tunnel count")%>:</b>
                <input type="text" id="reduceCount" name="reduceCount" size="1" maxlength="1" title="<%=intl._t("Number of tunnels to keep open to maintain availability of service")%>" value="<%=editBean.getReduceCount(curTunnel)%>" class="freetext quantity" />
            </td>

            <td>
                <b><%=intl._t("Idle period")%>:</b>
                <input type="text" id="reduceTime" name="reduceTime" size="4" maxlength="4" title="<%=intl._t("Period of inactivity before tunnel number is reduced")%>" value="<%=editBean.getReduceTime(curTunnel)%>" class="freetext period" />
                <%=intl._t("minutes")%>
            </td>
        </tr>

<% /***************** %>

        <tr>
            <th colspan="2">
                <%=intl._t("New Certificate type")%>
            </th>
        </tr>

        <tr>
            <td colspan="2">
                <span class="multiOption"><label title="<%=intl._t("No Certificate")%>"><%=intl._t("None")%>
                <input value="0" type="radio" id="startOnLoad" name="cert"<%=(editBean.getCert(curTunnel)==0 ? " checked=\"checked\"" : "")%> class="tickbox" /></label></span>
                <span class="multiOption"><label title="<%=intl._t("Hashcash Certificate")%>"><%=intl._t("Hashcash (effort)")%>
                <input value="1" type="radio" id="startOnLoad" name="cert"<%=(editBean.getCert(curTunnel)==1 ? " checked=\"checked\"" : "")%> class="tickbox" /></label>
                <input type="text" id="port" name="effort" size="2" maxlength="2" title="<%=intl._t("Hashcash Effort")%>" value="<%=editBean.getEffort(curTunnel)%>" class="freetext" /></span>
            </td>
        </tr>

        <tr>
            <th>
                <%=intl._t("Hashcash Calc Time")%>
            </th>
            <th>
                <%=intl._t("Hidden")%>
            </th>
        </tr>

        <tr>
            <td>
                <button class="control" type="submit" name="action" value="Estimate" title="<%=intl._t("Estimate Calculation Time")%>"><%=intl._t("Estimate")%></button>
            </td>
            <td>
                <input value="2" type="radio" id="startOnLoad" name="cert" title="<%=intl._t("Hidden Certificate")%>"<%=(editBean.getCert(curTunnel)==2 ? " checked=\"checked\"" : "")%> class="tickbox" />
            </td>
        </tr>

        <tr>
            <th colspan="2">
                <%=intl._t("Signed Certificate")%>
            </th>
        </tr>

        <tr>
            <td colspan="2">
                <label title="<%=intl._t("Signed Certificate")%>"><%=intl._t("Signed (signed by)")%>:
                <input value="3" type="radio" id="startOnLoad" name="cert"<%=(editBean.getCert(curTunnel)==3 ? " checked=\"checked\"" : "")%> class="tickbox" /></label>
                <input type="text" id="port" name="signer" size="50" title="<%=intl._t("Cert Signer")%>" value="<%=editBean.getSigner(curTunnel)%>" class="freetext" />
            </td>
        </tr>

        <tr>
            <th colspan="2">
                <%=intl._t("Modify Certificate")%>&nbsp;<%=intl._t("(Tunnel must be stopped first)")%>
            </th>
        </tr>

        <tr>
            <td colspan="2">
                <button class="control" type="submit" name="action" value="Modify" title="<%=intl._t("Force new Certificate now")%>"><%=intl._t("Modify")%></button>
            </td>
        </tr>

<% **********************/ %>

         <%
            int currentSigType = editBean.getSigType(curTunnel, tunnelType);
            if (true /* editBean.isAdvanced() */ ) {
           %>
        <tr>
            <th colspan="2">
                <%=intl._t("Signature type")%> (<%=intl._t("Experts only! Changes B32!")%>)
            </th>
        </tr>
        <tr>
            <td colspan="2">
                <span class="multiOption">
                    <label title="<%=intl._t("Legacy option (deprecated), provided for backward compatibility")%>"><input value="0" type="radio" id="startOnLoad" name="sigType"<%=(currentSigType==0 ? " checked=\"checked\"" : "")%> class="tickbox" />
                    DSA-SHA1</label>
                </span>
           <% if (editBean.isSigTypeAvailable(1)) { %>
                <span class="multiOption">
                    <label><input value="1" type="radio" id="startOnLoad" name="sigType"<%=(currentSigType==1 ? " checked=\"checked\"" : "")%> class="tickbox" />
                    ECDSA-P256</label>
                </span>
           <% }
              if (editBean.isSigTypeAvailable(2)) { %>
                <span class="multiOption">
                    <label><input value="2" type="radio" id="startOnLoad" name="sigType"<%=(currentSigType==2 ? " checked=\"checked\"" : "")%> class="tickbox" />
                    ECDSA-P384</label>
                </span>
           <% }
              if (editBean.isSigTypeAvailable(3)) { %>
                <span class="multiOption">
                    <label><input value="3" type="radio" id="startOnLoad" name="sigType"<%=(currentSigType==3 ? " checked=\"checked\"" : "")%> class="tickbox" />
                    ECDSA-P521</label>
                </span>
           <% }
              if (editBean.isSigTypeAvailable(7)) { %>
                <span class="multiOption">
                    <label title="<%=intl._t("This is the default, recommended option")%>"><input value="7" type="radio" id="startOnLoad" name="sigType"<%=(currentSigType==7 ? " checked=\"checked\"" : "")%> class="tickbox" />
                    Ed25519-SHA-512</label>
                </span>
           <% }   // isAvailable %>

            </td>
        </tr>

         <% } // isAdvanced %>

         <%
            /* alternate dest, only if current dest is set and is DSA_SHA1 */

            if (currentSigType == 0 && !"".equals(b64) && !"streamrserver".equals(tunnelType)) {
          %>

        <tr>
            <th colspan="2">
                <%=intl._t("Alternate private key file")%> (Ed25519-SHA-512)
            </th>
        </tr>

        <tr>
            <td colspan="2">
                <input type="text" class="freetext" size="30" id="altPrivKeyFile" name="altPrivKeyFile" title="<%=intl._t("Path to Private Key File")%>" value="<%=editBean.getAltPrivateKeyFile(curTunnel)%>" />
            </td>
        </tr>

         <%
              String ab64 = editBean.getAltDestinationBase64(curTunnel);
              if (!"".equals(ab64)) {
          %>

        <tr>
            <th colspan="2">
                <%=intl._t("Alternate local destination")%>
            </th>
        </tr>

        <tr>
            <td colspan="2">
                <div class="displayText" title="<%=intl._t("Read Only: Alternate Local Destination")%>" onblur="resetScrollLeft(this)"><%=ab64%></div>
            </td>
        </tr>

        <tr>
            <td colspan="2">
                <%=editBean.getAltDestHashBase32(curTunnel)%>
            </td>
        </tr>

        <%
                ab64 = ab64.replace("=", "%3d");
                String name = editBean.getSpoofedHost(curTunnel);
                if (name == null || name.equals(""))
                    name = editBean.getTunnelName(curTunnel);
                // mysite.i2p is set in the installed i2ptunnel.config
                if (name != null && !name.equals("") && !name.equals("mysite.i2p") && !name.contains(" ") && name.endsWith(".i2p")) {
           %>

        <tr>
            <td class="buttons" colspan="2">
              <a class="control" title="<%=intl._t("Generate QR Code")%>" href="/imagegen/qr?s=320&amp;t=<%=name%>&amp;c=http%3a%2f%2f<%=name%>%2f%3fi2paddresshelper%3d<%=ab64%>" target="_top"><%=intl._t("Generate QR Code")%></a>
              <a class="control" title="<%=intl._t("Add to Private addressbook")%>" href="/susidns/addressbook.jsp?book=private&amp;hostname=<%=name%>&amp;destination=<%=ab64%>#add"><%=intl._t("Add to local addressbook")%></a>
        <%
                } else {
            %>

        <tr>
            <td colspan="2">
                <%=intl._t("Note: In order to enable QR code generation or registration authentication, configure the Website Hostname field (for websites) or the Name field (everything else) above with an .i2p suffixed hostname e.g. mynewserver.i2p")%>
            </td>
        </tr>

        <%
                }  // name
            %>
        <%
              }  // ab64
            %>
         <% } // currentSigType %>

        <tr>
            <th colspan="2">
                <%=intl._t("Custom options")%>
            </th>
        </tr>
        <tr>
            <td colspan="2">
                <input type="text" class="freetext" id="customOptions" name="nofilter_customOptions" size="60" title="<%=intl._t("Advanced options to control tunnel priority etc")%>" value="<%=editBean.getCustomOptions(curTunnel)%>" />
            </td>
        </tr>

        <tr>
            <td class="buttons" colspan="2">
                    <input type="hidden" value="true" name="removeConfirm" />
                    <button id="controlCancel" class="control" type="submit" name="action" value=""><%=intl._t("Cancel")%></button>
                    <button id="controlDelete" <%=(editBean.allowJS() ? "onclick=\"if (!confirm('Are you sure you want to delete?')) { return false; }\" " : "")%>class="control" type="submit" name="action" value="Delete this proxy" title="<%=intl._t("Delete this Proxy (cannot be undone)")%>"><%=intl._t("Delete")%></button>
                    <button id="controlSave" class="control" type="submit" name="action" value="Save changes"><%=intl._t("Save")%></button>
            </td>
        </tr>
    </table>
</div>
    </form>

<%

  } else {
     %><div id="notReady"><%=intl._t("Tunnels not initialized yet; please retry in a few moments.")%></div><%
  }  // isInitialized()

%>
</body>
</html>
