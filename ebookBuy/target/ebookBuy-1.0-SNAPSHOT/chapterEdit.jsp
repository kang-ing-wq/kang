<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>编辑章节 - 玄元宗藏书阁</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        :root {
            --bg-deepest: #0a1a20;
            --bg-dark: #0f252b;
            --bg-mid: #1a3a3f;
            --bg-light: #173036;
            --gold-dark: #a88a44;
            --gold-mid: #c9a866;
            --gold-light: #e6c888;
            --text-primary: #f0e2c0;
            --text-secondary: #d4c7b0;
        }
        body {
            font-family: "SimSun", "Times New Roman", serif;
            background:
                    radial-gradient(ellipse at 30% 20%, rgba(26, 58, 63, 0.8) 0%, transparent 50%),
                    linear-gradient(135deg, var(--bg-deepest) 0%, var(--bg-mid) 50%, var(--bg-dark) 100%);
            color: var(--text-secondary);
            min-height: 100vh;
            padding: 50px;
        }
        .page-title {
            font-size: 48px;
            text-align: center;
            color: var(--text-primary);
            margin-bottom: 50px;
            letter-spacing: 10px;
            text-shadow: 0 0 25px var(--gold-mid), 0 0 50px rgba(201, 168, 102, 0.7);
            animation: titleBreath 4s ease-in-out infinite;
            border-bottom: 2px solid rgba(201, 168, 102, 0.5);
            padding-bottom: 20px;
        }
        @keyframes titleBreath {
            0%, 100% { text-shadow: 0 0 25px var(--gold-mid), 0 0 50px rgba(201, 168, 102, 0.7); }
            50% { text-shadow: 0 0 35px var(--gold-light), 0 0 70px rgba(230, 200, 136, 0.9); }
        }
        .form-card {
            width: 800px;
            margin: 0 auto;
            background: linear-gradient(180deg, var(--bg-light) 0%, var(--bg-deepest) 100%);
            border: 3px solid var(--gold-mid);
            border-radius: 15px;
            padding: 50px 40px;
            box-shadow: 0 0 50px rgba(201, 168, 102, 0.35);
        }
        .form-row {
            margin-bottom: 25px;
        }
        .form-row label {
            display: block;
            font-size: 20px;
            color: var(--text-primary);
            margin-bottom: 10px;
            letter-spacing: 2px;
        }
        .form-row input, .form-row textarea {
            width: 100%;
            padding: 12px 15px;
            background: rgba(255,255,255,0.1);
            border: 2px solid var(--gold-dark);
            border-radius: 5px;
            color: var(--text-primary);
            font-size: 16px;
            font-family: "SimSun", serif;
        }
        .form-row input:focus, .form-row textarea:focus {
            outline: none;
            border-color: var(--gold-mid);
            box-shadow: 0 0 12px rgba(201, 168, 102, 0.5);
        }
        .form-row textarea {
            resize: vertical;
            min-height: 400px;
            line-height: 1.8;
        }
        .form-btn-group {
            display: flex;
            gap: 30px;
            justify-content: center;
            margin-top: 40px;
        }
        .magic-btn {
            padding: 15px 40px;
            background: linear-gradient(90deg, #173036, #244a52);
            color: var(--text-primary);
            text-decoration: none;
            font-size: 20px;
            border: 2px solid var(--gold-dark);
            border-radius: 5px;
            transition: all 0.3s ease;
            letter-spacing: 3px;
            cursor: pointer;
            font-family: "SimSun", serif;
            box-shadow: 0 4px 15px rgba(0,0,0,0.5);
        }
        .magic-btn:hover {
            background: linear-gradient(90deg, var(--gold-mid), var(--gold-light));
            color: var(--bg-deepest);
            font-weight: bold;
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(201, 168, 102, 0.6);
        }
        /* 滚动条样式 */
        ::-webkit-scrollbar {
            width: 8px;
        }
        ::-webkit-scrollbar-track {
            background: var(--bg-deepest);
        }
        ::-webkit-scrollbar-thumb {
            background: var(--gold-dark);
            border-radius: 4px;
        }
    </style>
</head>
<body>
<h1 class="page-title">编辑典籍章节</h1>

<div class="form-card">
    <form action="${pageContext.request.contextPath}/chapterEdit" method="post">
        <!-- 隐藏域，存章节ID，提交要用 -->
        <input type="hidden" name="chapterId" value="${chapter.id}">

        <div class="form-row">
            <label>章节序号（不可修改）</label>
            <input type="number" value="${chapter.chapterNum}" readonly disabled>
        </div>

        <div class="form-row">
            <label>章节标题</label>
            <input type="text" name="chapterTitle" value="${chapter.chapterTitle}" required>
        </div>

        <div class="form-row">
            <label>章节正文内容（直接在这里补全/修改）</label>
            <textarea name="chapterContent" required>${chapter.chapterContent}</textarea>
        </div>

        <div class="form-btn-group">
            <button type="submit" class="magic-btn">保存修改</button>
            <a href="tushuguan" class="magic-btn">返回藏书阁</a>
        </div>
    </form>
</div>

<!-- 保留点击符文+剑气波纹特效 -->
<%--<style>--%>
<%--    .sword-wave {--%>
<%--        position: fixed;--%>
<%--        width: 60px;--%>
<%--        height: 60px;--%>
<%--        border: 3px solid #c9a866;--%>
<%--        border-radius: 50%;--%>
<%--        pointer-events: none;--%>
<%--        z-index: 99998;--%>
<%--        box-shadow: 0 0 15px #c9a866, 0 0 30px rgba(201, 168, 102, 0.6);--%>
<%--    }--%>
<%--    @keyframes waveExpand {--%>
<%--        0% { opacity: 1; transform: translate(-50%, -50%) scale(0.5); }--%>
<%--        100% { opacity: 0; transform: translate(-50%, -50%) scale(2.0); }--%>
<%--    }--%>
<%--    .wave-animate { animation: waveExpand 0.8s ease-out forwards; }--%>
<%--    .rune-text {--%>
<%--        position: fixed;--%>
<%--        font-family: "SimSun", "KaiTi", serif;--%>
<%--        font-size: 32px;--%>
<%--        font-weight: bold;--%>
<%--        color: #c9a866;--%>
<%--        text-shadow: 0 0 10px #c9a866, 0 0 20px rgba(201, 168, 102, 0.8);--%>
<%--        pointer-events: none;--%>
<%--        z-index: 99999;--%>
<%--        user-select: none;--%>
<%--        white-space: nowrap;--%>
<%--    }--%>
<%--    @keyframes runeFloat {--%>
<%--        0% { opacity: 1; transform: translateY(0) scale(1); }--%>
<%--        100% { opacity: 0; transform: translateY(-120px) scale(1.2); }--%>
<%--    }--%>
<%--    .rune-animate { animation: runeFloat 0.9s ease-out forwards; }--%>
<%--</style>--%>
<%--<script type="text/javascript">--%>
<%--    var runeLibrary = ['临', '兵', '斗', '者', '皆', '列', '阵', '在', '前'];--%>
<%--    document.addEventListener('click', function(e) {--%>
<%--        var clickX = e.clientX;--%>
<%--        var clickY = e.clientY;--%>
<%--        var wave = document.createElement('div');--%>
<%--        wave.className = 'sword-wave';--%>
<%--        wave.style.left = clickX + 'px';--%>
<%--        wave.style.top = clickY + 'px';--%>
<%--        document.body.appendChild(wave);--%>
<%--        setTimeout(function() { wave.classList.add('wave-animate'); }, 10);--%>
<%--        wave.addEventListener('animationend', function() { this.remove(); });--%>
<%--        var randomIndex = Math.floor(Math.random() * runeLibrary.length);--%>
<%--        var randomRune = runeLibrary[randomIndex];--%>
<%--        var runeElement = document.createElement('div');--%>
<%--        runeElement.className = 'rune-text';--%>
<%--        runeElement.innerText = randomRune;--%>
<%--        runeElement.style.left = (clickX - 16) + 'px';--%>
<%--        runeElement.style.top = (clickY - 20) + 'px';--%>
<%--        document.body.appendChild(runeElement);--%>
<%--        setTimeout(function() { runeElement.classList.add('rune-animate'); }, 10);--%>
<%--        runeElement.addEventListener('animationend', function() { this.remove(); });--%>
<%--    });--%>
<%--</script>--%>
</body>
</html>