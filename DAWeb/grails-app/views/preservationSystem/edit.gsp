<%@ page import="daweb3.PreservationSystem" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'preservationSystem.label', default: 'PreservationSystem')}" />
		<title><g:message code="default.edit.label" args="[entityName]" /></title>
	</head>
	<body>
		<div id=page-body>
			<a href="#edit-preservationSystem" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
			<div class="nav" role="navigation">
				<ul>
					<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
			</ul>
			</div>
			<div id="edit-preservationSystem" class="content scaffold-edit" role="main">
				<h1><g:message code="default.edit.label" args="[entityName]" /></h1>
				<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
				</g:if>
				<g:hasErrors bean="${preservationSystemInstance}">
				<ul class="errors" role="alert">
					<g:eachError bean="${preservationSystemInstance}" var="error">
					<li> <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
					</g:eachError>
				</ul>
				</g:hasErrors>
				<g:form url="[resource:preservationSystemInstance, action:'update']" method="PUT" >
					<g:hiddenField name="version" value="${preservationSystemInstance?.version}" />
					<fieldset class="form">
						<g:render template="form"/>
					</fieldset>
					<fieldset class="buttons">
						<g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" />
						<g:actionSubmit class="cancel" action="cancel" value="${message(code: 'default.button.cancel.label', default: 'Cancel')}" />
					</fieldset>
				</g:form>
			</div>
		</div>
	</body>
</html>
