<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("loginUser") == null) {
        response.setContentType("text/html;charset=UTF-8");
        out.println("<script>");
        out.println("alert('道友请先登录，方可使用剧情地图功能！');");
        out.println("window.top.location.href = '" + request.getContextPath() + "/login.jsp';");
        out.println("</script>");
        out.flush();
        return;
    }
%>
<html>
<head>
    <title>剧情地图 - 声临其境</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: #0a1a20;
            color: #e6d7b9;
            font-family: SimSun, serif;
            padding: 15px;
            overflow-x: hidden;
        }
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .btn {
            padding: 8px 18px;
            background: #244a52;
            color: #f0e2c0;
            border: 1px solid #c9a866;
            border-radius: 5px;
            text-decoration: none;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn:hover { background: #c9a866; color: #0d1f24; }

        .tree { margin-left: 20px; }
        .node-block { margin: 10px 0; }
        .node-card {
            display: inline-block;
            padding: 10px 18px;
            background: #173036;
            border: 2px solid #c9a866;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            min-width: 180px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.5);
            color: #f0e2c0;
            font-size: 16px;
            font-weight: bold;
        }
        .node-card:hover { background: #244a52; border-color: #f0e2c0; }
        .node-card .node-id { font-size: 12px; color: #a88a44; margin-top: 4px; }
        .node-card .chapter-badge {
            margin-left: 10px;
            font-size: 12px;
            color: #8ab88a;
        }
        .children {
            margin-left: 40px;
            border-left: 2px dashed #a88a44;
            padding-left: 20px;
            padding-top: 5px;
            padding-bottom: 5px;
            display: none;
        }
        .children.open { display: block; }

        /* 选项行：采用弹性布局，右侧信息自然对齐 */
        .option-item {
            display: flex;
            align-items: center;
            margin: 6px 0;
            padding: 6px 12px;
            background: rgba(255,255,255,0.05);
            border-radius: 4px;
            color: #d4c7b0;
            font-size: 14px;
            min-height: 36px;
        }
        .option-text {
            flex: 1;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .option-right {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-left: 16px;
            flex-shrink: 0;
        }
        .option-right .chapter-badge {
            color: #8ab88a;
            font-size: 12px;
        }
        .option-right .arrow {
            color: #c9a866;
        }
        .option-right .target-node {
            color: #e6c888;
            font-weight: bold;
            min-width: 45px;
            text-align: right;
        }

        /* 详情面板 */
        .detail-panel {
            position: fixed;
            top: 80px;
            right: 20px;
            width: 380px;
            max-height: 75vh;
            background: linear-gradient(180deg, #173036, #0a1a20);
            border: 3px solid #c9a866;
            border-radius: 10px;
            padding: 20px;
            display: none;
            z-index: 1000;
            box-shadow: 0 0 30px rgba(0,0,0,0.8);
            overflow-y: auto;
        }
        .detail-panel.show { display: block; }
        .detail-panel .close-btn { float: right; color: #a86666; font-size: 22px; cursor: pointer; }
        .detail-panel .close-btn:hover { color: #ff6666; }
        .detail-panel h3 {
            color: #f0e2c0;
            margin-bottom: 15px;
            border-bottom: 1px solid #a88a44;
            padding-bottom: 10px;
        }
        .detail-panel .opt-list { margin-bottom: 15px; }
        .detail-panel .no-option { color: #b8a990; text-align: center; padding: 10px; }

        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: #0a1a20; border-radius: 3px; }
        ::-webkit-scrollbar-thumb { background: #a88a44; border-radius: 3px; }
        ::-webkit-scrollbar-thumb:hover { background: #c9a866; }
    </style>
</head>
<body>
<div class="top-bar">
    <h2 style="color:#f0e2c0;">🗺️ 剧情地图 - 典籍ID: ${param.bookId}</h2>
    <a href="${pageContext.request.contextPath}/gameManage?bookId=${param.bookId}" class="btn">返回剧情管理</a>
</div>

<div id="treeRoot" class="tree"></div>

<div class="detail-panel" id="detailPanel">
    <span class="close-btn" onclick="closeDetail()">✖</span>
    <h3 id="detailNodeTitle"></h3>
    <div class="opt-list" id="detailOptions"></div>
    <div id="detailChapter" style="color:#8ab88a; font-size:14px; margin-top: 10px;"></div>
</div>

<script>
    var bookId = ${param.bookId};
    var contextPath = '${pageContext.request.contextPath}';
    var nodeMap = {};

    // 获取地图数据
    fetch(contextPath + '/game?action=map&bookId=' + bookId, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        credentials: 'same-origin'
    })
        .then(res => {
            if (res.redirected || res.url.includes('login.jsp')) {
                alert('道友请先登录，方可使用剧情地图功能！');
                window.top.location.href = contextPath + '/login.jsp';
                return;
            }
            return res.json();
        })
        .then(res => {
            if (res.code === 200) {
                res.data.forEach(n => { nodeMap[n.id] = n; });
                var startId = '1-1';
                if (nodeMap[startId]) {
                    const rootBlock = createNodeBlock(startId, new Set());
                    document.getElementById('treeRoot').appendChild(rootBlock);
                } else {
                    document.getElementById('treeRoot').innerHTML = '<p style="color:#a88a44; padding:20px;">暂无剧情数据</p>';
                }
            } else {
                alert('获取地图数据失败：' + res.msg);
            }
        })
        .catch(err => {
            console.error(err);
            document.getElementById('treeRoot').innerHTML = '<p style="color:#a86666; padding:20px;">网络请求失败</p>';
        });

    function closeDetail() { document.getElementById('detailPanel').classList.remove('show'); }

    function showNodeDetail(nodeId) {
        var node = nodeMap[nodeId];
        if (!node) return;
        document.getElementById('detailNodeTitle').innerText = node.title + ' (' + nodeId + ')';
        var options = [];
        try { options = JSON.parse(node.options || '[]'); } catch(e) {}

        var html = '';
        if (options.length === 0) {
            html = '<div class="no-option">🏁 结局节点</div>';
        } else {
            options.forEach(function(opt) {
                var targetNode = nodeMap[opt.target];
                var chapterBadge = '';
                if (targetNode && targetNode.chapterId) {
                    chapterBadge = '<span class="chapter-badge">📖第' + targetNode.chapterId + '章</span>';
                }
                html += '<div class="option-item">' +
                    '<span class="option-text">' + opt.text + '</span>' +
                    '<div class="option-right">' +
                    chapterBadge +
                    '<span class="arrow">→</span>' +
                    '<span class="target-node">' + opt.target + '</span>' +
                    '</div>' +
                    '</div>';
            });
        }
        document.getElementById('detailOptions').innerHTML = html;

        var chapterInfo = node.chapterId ? '📖 关联章节：第' + node.chapterId + '章' : '📖 暂无关联章节';
        document.getElementById('detailChapter').innerText = chapterInfo;
        document.getElementById('detailPanel').classList.add('show');
    }

    function createNodeBlock(nodeId, visited) {
        if (visited.has(nodeId)) {
            var ref = document.createElement('div');
            ref.className = 'node-card';
            ref.innerHTML = '🔗 ' + nodeId + '<div class="node-id">循环引用</div>';
            ref.style.opacity = 0.5;
            ref.style.cursor = 'not-allowed';
            return ref;
        }
        visited.add(nodeId);

        var node = nodeMap[nodeId];
        if (!node) return document.createElement('div');

        var block = document.createElement('div');
        block.className = 'node-block';

        var card = document.createElement('div');
        card.className = 'node-card';
        card.innerHTML = node.title + '<div class="node-id">' + nodeId + '</div>';
        if (node.chapterId) {
            var chapterSpan = document.createElement('span');
            chapterSpan.className = 'chapter-badge';
            chapterSpan.innerText = '📖第' + node.chapterId + '章';
            card.appendChild(chapterSpan);
        }

        var childrenDiv = document.createElement('div');
        childrenDiv.className = 'children';
        block.appendChild(card);
        block.appendChild(childrenDiv);

        var options = [];
        try { options = JSON.parse(node.options || '[]'); } catch(e) {}

        if (options.length > 0) {
            card.onclick = function(e) {
                e.stopPropagation();
                if (childrenDiv.classList.contains('open')) {
                    childrenDiv.classList.remove('open');
                } else {
                    if (childrenDiv.children.length === 0) {
                        options.forEach(function(opt) {
                            var optionRow = document.createElement('div');
                            optionRow.className = 'option-item';

                            var textSpan = document.createElement('span');
                            textSpan.className = 'option-text';
                            textSpan.innerText = opt.text;

                            var rightDiv = document.createElement('div');
                            rightDiv.className = 'option-right';

                            if (nodeMap[opt.target] && nodeMap[opt.target].chapterId) {
                                var badge = document.createElement('span');
                                badge.className = 'chapter-badge';
                                badge.innerText = '📖第' + nodeMap[opt.target].chapterId + '章';
                                rightDiv.appendChild(badge);
                            }

                            var arrowSpan = document.createElement('span');
                            arrowSpan.className = 'arrow';
                            arrowSpan.innerText = '→';
                            rightDiv.appendChild(arrowSpan);

                            var targetSpan = document.createElement('span');
                            targetSpan.className = 'target-node';
                            targetSpan.innerText = opt.target;
                            rightDiv.appendChild(targetSpan);

                            optionRow.appendChild(textSpan);
                            optionRow.appendChild(rightDiv);
                            childrenDiv.appendChild(optionRow);

                            if (nodeMap[opt.target]) {
                                var targetBlock = createNodeBlock(opt.target, new Set(visited));
                                childrenDiv.appendChild(targetBlock);
                            }
                        });
                    }
                    childrenDiv.classList.add('open');
                }
                showNodeDetail(nodeId);
            };
        } else {
            card.style.opacity = 0.7;
            card.innerHTML += '<br><span style="font-size:12px;color:#b8a990;">🏁 结局</span>';
            card.onclick = function(e) {
                e.stopPropagation();
                showNodeDetail(nodeId);
            };
        }

        return block;
    }

    document.addEventListener('click', function(e) {
        var panel = document.getElementById('detailPanel');
        if (!panel.contains(e.target) && !e.target.closest('.node-card')) {
            panel.classList.remove('show');
        }
    });
</script>
</body>
</html>