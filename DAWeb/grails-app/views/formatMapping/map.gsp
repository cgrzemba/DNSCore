<%@ page contentType="text/html; charset=UTF-8" %>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'formatMapping.label', default: 'Format-Mapping')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
 		<r:require modules="periodicalupdater, jqueryui"/>		
	</head>
	<body>
		<div id="page-body">
			<a href="#list-formatMapping" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
			<br>
			<div class="nav" role="navigation">
				<ul>
					<li><a class="listl" href="${createLink(uri: '/cbtalk/index')}"><g:message message="zurück zur Administrationsseite"/></a></li>
				</ul>
			</div>
			
			<h1 class="page-header">Format-Mapping</h1> 
			<g:form  name="map" url="[controller: 'formatMapping', action:'deleteAndFill']"  update="refreshView" >
				<g:actionSubmit value="Tabelle leeren und neu laden" action="deleteAndFill"  
							onclick="return confirm('Tabelle wirklich aktualisieren?')"/>
				<g:if test="${msg}">
					<div class="message" role="status">${msg}</div> 
				</g:if>		
			</g:form> <br>
			
			<div style="overflow:auto; height: 600px">
			  <table>
				 <thead>							
						<tr>
							<g:sortableColumn property="puid" title="${message(code: 'formatMapping.puid', default: 'PUID')}" />
							<g:sortableColumn property="extension" title="${message(code: 'formatMapping.extension', default: 'Erweiterung')}" />
							<g:sortableColumn property="mimeType" title="${message(code: 'formatMapping.mimeType', default: 'MIME-Type')}" />
							<g:sortableColumn property="formatName" title="${message(code: 'formatMapping.formatName', default: 'Bezeichnung')}" />
						</tr>
				</thead>
				<tbody>
					<g:each in="${formatMappings}" var="formatMappingInstance" status="i">
			       		<tr class="${ ((i % 2) == 0 ? 'odd' : 'even') }">
			       			<td>${formatMappingInstance.puid}</td>
			       			<td>${formatMappingInstance.extension}</td>
			       			<td>${formatMappingInstance.mimeType}</td>
			       			<td>${formatMappingInstance.formatName}</td>
						</tr>
					</g:each>
				</tbody>
			  </table>
			</div>
		</div>
	</body>
</html>
