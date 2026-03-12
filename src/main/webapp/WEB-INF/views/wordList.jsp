<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>MVP VOCA DAY 01</title>
</head>
<script>

</script>

<body>
<h1>Day 01 단어 리스트</h1>
<h2><a href="/quiz/setup/${dayNum}">퀴즈풀러가기</a></h2>
<table border="1">
    <tr>
        <th>번호</th>
        <th>단어</th>
        <th>뜻</th>
    </tr>
    <c:forEach var="word" items="${words}">
        <tr>
            <td>${word.id}</td>
            <td>${word.word}</td>
            <td>${word.meaning}</td>
        </tr>
    </c:forEach>
</table>
</body>
</html>