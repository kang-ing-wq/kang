<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>声临其境 - 阅读篇</title>
    <style>
        body { background: #0a1a20; color: #e6d7b9; font-family: SimSun; margin: 0; }
        .game-container { width: 700px; margin: 40px auto; background: rgba(23,48,54,0.95); padding: 30px; border: 2px solid #c9a866; border-radius: 10px; }
        .stats { display: flex; gap: 15px; margin-bottom: 20px; flex-wrap: wrap; }
        .stat-item { background: #173036; padding: 6px 12px; border-radius: 5px; border: 1px solid #a88a44; font-size: 14px; }
        .story-text { line-height: 1.8; font-size: 18px; margin-bottom: 30px; min-height: 150px; white-space: pre-wrap; }
        .options { display: flex; flex-direction: column; gap: 10px; }
        .option-btn { padding: 12px; background: #244a52; color: #f0e2c0; border: 2px solid #c9a866; border-radius: 5px; cursor: pointer; font-size: 16px; text-align: left; }
        .option-btn:hover { background: #c9a866; color: #0d1f24; }
        .option-btn.disabled { background: #333; color: #999; border-color: #555; cursor: not-allowed; pointer-events: none; }
        .require-tip { font-size: 12px; color: #e6c888; margin-left: 8px; }
        .title { text-align: center; font-size: 28px; margin-bottom: 10px; color: #f0e2c0; }
        .action-bar { display: flex; justify-content: flex-end; gap: 10px; margin-bottom: 15px; }
        .action-btn { padding: 8px 15px; background: #244a52; color: #f0e2c0; border: 1px solid #c9a866; border-radius: 5px; cursor: pointer; font-family: SimSun; font-size: 14px; text-decoration: none; transition: all 0.3s ease; }
        .action-btn:hover { background: #c9a866; color: #0d1f24; }
        .restart-btn { background: #5a1a1a; border-color: #a83232; }
        .restart-btn:hover { background: #a83232; color: #fff; }
        .ending-panel { text-align: center; padding: 30px; background: rgba(168,166,102,0.15); border: 2px dashed #c9a866; border-radius: 10px; }
        .ending-panel h3 { color: #f0e2c0; font-size: 26px; margin-bottom: 15px; }
        .ending-panel .end-btn { display: inline-block; margin: 10px; padding: 12px 25px; background: #244a52; color: #f0e2c0; border: 2px solid #c9a866; border-radius: 5px; cursor: pointer; font-family: SimSun; font-size: 16px; text-decoration: none; transition: all 0.3s ease; }
        .ending-panel .end-btn:hover { background: #c9a866; color: #0d1f24; }
    </style>
</head>
<body>
<div class="game-container">
    <div class="title">📖 《<span id="bookTitle">载入中...</span>》</div>
    <div class="action-bar">
        <a href="${pageContext.request.contextPath}/gameList" class="action-btn">📋 返回列表</a>
        <button class="action-btn" onclick="openLoadModal()">📌 读档</button>
        <button class="action-btn restart-btn" onclick="restartGame()">🔄 重新开始</button>
    </div>
    <div class="stats" id="statsContainer"></div>
    <div class="story-text" id="storyText">正在加载剧情...</div>
    <div class="options" id="optionsContainer"></div>

    <!-- 读档弹窗 -->
    <div id="loadModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.8); z-index:1000; justify-content:center; align-items:center;">
        <div style="background:#173036; border:2px solid #c9a866; padding:20px; max-width:500px; width:90%; border-radius:10px;">
            <h3 style="color:#f0e2c0; text-align:center;">选择存档点</h3>
            <div id="saveList" style="max-height:300px; overflow-y:auto; margin:15px 0;"></div>
            <button class="option-btn" onclick="closeLoadModal()">关闭</button>
        </div>
    </div>

    <div id="endingPanel" style="display:none;" class="ending-panel">
        <h3>🏁 达成结局</h3>
        <p style="color:#d4c7b0; margin-bottom:20px;">你在这段冒险中留下了自己的足迹，期待你再次归来。</p>
        <a href="${pageContext.request.contextPath}/gameList" class="end-btn">📋 返回游戏列表</a>
        <button class="end-btn" onclick="restartGame()">🔄 重新开始</button>
    </div>
</div>

<script>
    var bookId = ${param.bookId};
    var contextPath = '${pageContext.request.contextPath}';

    window.onload = function() { startGame(); };

    function startGame() {
        var xhr = new XMLHttpRequest();
        xhr.open('POST', contextPath + '/game', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function() {
            var res = JSON.parse(xhr.responseText);
            if (res.code === 200) updateUI(res);
            else alert(res.msg);
        };
        xhr.send('action=start&bookId=' + bookId);
    }

    function restartGame() {
        if (!confirm('确定要重新开始吗？当前进度将被清除。')) return;
        var xhr = new XMLHttpRequest();
        xhr.open('POST', contextPath + '/game', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function() {
            var res = JSON.parse(xhr.responseText);
            if (res.code === 200) updateUI(res);
            else alert(res.msg);
        };
        xhr.send('action=restart&bookId=' + bookId);
    }

    function makeChoice(targetNode) {
        var xhr = new XMLHttpRequest();
        xhr.open('POST', contextPath + '/game', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function() {
            var res = JSON.parse(xhr.responseText);
            if (res.code === 200) updateUI(res);
            else alert(res.msg);
        };
        xhr.send('action=choose&bookId=' + bookId + '&targetNode=' + targetNode);
    }

    // 读档相关
    function openLoadModal() {
        var xhr = new XMLHttpRequest();
        xhr.open('POST', contextPath + '/game', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function() {
            var res = JSON.parse(xhr.responseText);
            if (res.code === 200) {
                var points = res.data;
                var html = '';
                for (var i = 0; i < points.length; i++) {
                    var p = points[i];
                    html += '<div style="margin:5px 0;"><button class="option-btn" onclick="jumpToNode(\'' + p.nodeId + '\')">' + p.nodeTitle + ' (' + p.nodeId + ')</button></div>';
                }
                if (points.length === 0) html = '<p style="color:#b8a990;">当前没有可用存档点</p>';
                document.getElementById('saveList').innerHTML = html;
                document.getElementById('loadModal').style.display = 'flex';
            } else alert('获取存档点失败');
        };
        xhr.send('action=savelist&bookId=' + bookId);
    }

    function closeLoadModal() { document.getElementById('loadModal').style.display = 'none'; }

    function jumpToNode(targetNode) {
        closeLoadModal();
        var xhr = new XMLHttpRequest();
        xhr.open('POST', contextPath + '/game', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function() {
            var res = JSON.parse(xhr.responseText);
            if (res.code === 200) updateUI(res);
            else alert(res.msg);
        };
        xhr.send('action=jump&bookId=' + bookId + '&targetNode=' + targetNode);
    }

    function getMissingReq(playerAttrs, require) {
        if (!require) return [];
        var missing = [];
        for (var key in require) {
            var need = require[key].min || require[key];
            if (!playerAttrs[key] || playerAttrs[key] < need) missing.push({ key: key, need: need });
        }
        return missing;
    }

    function updateUI(data) {
        if (data.bookTitle) document.getElementById('bookTitle').innerText = data.bookTitle;
        var attrs = data.playerAttrs;
        var statsHtml = '';
        for (var key in attrs) statsHtml += '<div class="stat-item">' + key + ': ' + attrs[key] + '</div>';
        document.getElementById('statsContainer').innerHTML = statsHtml;
        document.getElementById('storyText').innerText = data.storyText;

        var options = JSON.parse(data.options || '[]');
        var optionsContainer = document.getElementById('optionsContainer');
        var endingPanel = document.getElementById('endingPanel');

        if (options.length === 0) {
            optionsContainer.style.display = 'none';
            endingPanel.style.display = 'block';
        } else {
            endingPanel.style.display = 'none';
            optionsContainer.style.display = 'flex';
            var html = '';
            for (var i = 0; i < options.length; i++) {
                var opt = options[i];
                var missing = getMissingReq(attrs, opt.require);
                if (missing.length > 0) {
                    var tip = '';
                    for (var j = 0; j < missing.length; j++) tip += '（需' + missing[j].key + '≥' + missing[j].need + '）';
                    html += '<button class="option-btn disabled">' + opt.text + '<span class="require-tip">' + tip + '</span></button>';
                } else {
                    html += '<button class="option-btn" onclick="makeChoice(\'' + opt.target + '\')">' + opt.text + '</button>';
                }
            }
            optionsContainer.innerHTML = html;
        }
    }
</script>
</body>
</html>