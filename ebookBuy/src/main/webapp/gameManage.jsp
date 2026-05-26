<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>剧情管理 - 声临其境</title>
    <style>
        body { background: #0a1a20; color: #e6d7b9; font-family: SimSun; margin: 0; }
        .container { width: 90%; max-width: 1000px; margin: 20px auto; }
        h2 { color: #f0e2c0; text-align: center; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; background: rgba(23,48,54,0.9); }
        th, td { border: 1px solid #a88a44; padding: 8px; text-align: left; }
        th { background: #173036; color: #f0e2c0; }
        .btn { padding: 6px 12px; background: #244a52; color: #f0e2c0; border: 1px solid #c9a866; border-radius: 3px; cursor: pointer; font-family: SimSun; margin-right: 5px; font-size:14px; }
        .btn:hover { background: #c9a866; color: #0d1f24; }
        .btn-remove { background: #5a1a1a; border-color: #a83232; }
        .btn-remove:hover { background: #a83232; color: #fff; }
        .btn-small { padding: 2px 8px; font-size:12px; }
        .form-group { margin: 10px 0; }
        label { display: inline-block; width: 100px; vertical-align: top; }
        input, textarea { width: 300px; padding: 5px; background: rgba(255,255,255,0.1); border: 1px solid #a88a44; color: #f0e2c0; font-family: SimSun; }
        textarea { resize: vertical; height: 60px; }
        #editForm { display: none; margin-top: 20px; padding: 15px; background: #173036; border: 1px solid #c9a866; }
        .back-link { color: #c9a866; text-decoration: none; float: right; }
        .back-link:hover { text-shadow: 0 0 10px; }
        .dynamic-row { display: flex; align-items: center; gap: 8px; margin: 5px 0; }
        .dynamic-row input { width: 160px; }
        .notice { color: #a88a44; font-size: 13px; margin-left: 10px; }
        input[disabled], textarea[disabled] { opacity: 0.6; cursor: not-allowed; }
        .option-block { border: 1px solid #4a5a4a; padding: 8px; margin: 6px 0; border-radius: 4px; background: rgba(0,0,0,0.2); }
        .option-conditions { margin-left: 20px; display: none; padding: 5px 0; }
        .option-conditions .dynamic-row input { width: 120px; }
    </style>
</head>
<body>
<div class="container">
    <h2>剧情管理 - 典籍ID: ${bookId} <a href="${pageContext.request.contextPath}/gameList" class="back-link">返回游戏列表</a></h2>
    <button class="btn" onclick="showAddForm()">新增节点</button>
    <a href="${pageContext.request.contextPath}/gameMap.jsp?bookId=${bookId}" class="btn" style="float:right; margin-left:10px;">🗺️ 查看剧情地图</a>
    <hr>
    <table id="storyTable">
        <thead><tr><th>节点ID</th><th>标题</th><th>文本预览</th><th>操作</th></tr></thead>
        <tbody>
        <c:forEach items="${storyList}" var="node">
            <tr>
                <td>${node.nodeId}</td>
                <td>${node.nodeTitle}</td>
                <td>
                    <c:choose>
                        <c:when test="${fn:length(node.storyText) > 20}">${fn:substring(node.storyText, 0, 20)}...</c:when>
                        <c:otherwise>${node.storyText}</c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <button class="btn edit-btn"
                            data-id="${node.id}" data-nodeid="${node.nodeId}" data-title="${node.nodeTitle}"
                            data-text="${fn:escapeXml(node.storyText)}" data-options="${fn:escapeXml(node.options)}"
                            data-requirements="${fn:escapeXml(node.requirements)}" data-rewards="${fn:escapeXml(node.rewards)}"
                            data-chapterid="${node.chapterId != null ? node.chapterId : ''}">编辑</button>
                    <button class="btn" onclick="deleteNode(${node.id})">删除</button>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty storyList}">
            <tr><td colspan="4" style="text-align:center;color:#b8a990;">暂无剧情节点，点击“新增节点”开始编写</td></tr>
        </c:if>
        </tbody>
    </table>

    <div id="editForm">
        <h3 id="formTitle">新增节点</h3>
        <input type="hidden" id="nodeId_hidden">

        <div class="form-group" id="initialAttrGroup">
            <label>初始属性:</label>
            <span class="notice" id="attrNotice">起始节点可编辑，其他节点只读</span>
            <div id="initialAttrsContainer"></div>
            <button class="btn" id="addAttrBtn" onclick="addInitialAttr()">+ 添加属性</button>
        </div>

        <div class="form-group"><label>节点编号:</label><input type="text" id="nodeId" placeholder="如 1-1" oninput="onNodeIdChange()"></div>
        <div class="form-group"><label>标题:</label><input type="text" id="nodeTitle"></div>
        <div class="form-group"><label>剧情文本:</label><textarea id="storyText"></textarea></div>

        <div class="form-group">
            <label>选项设置:</label>
            <div id="optionsContainer"></div>
            <button class="btn" onclick="addOption()">+ 添加选项</button>
        </div>

        <div class="form-group" id="rewardGroup">
            <label>奖励设置:</label>
            <div id="rewardsContainer"></div>
            <button class="btn" onclick="addReward()">+ 添加奖励</button>
        </div>

        <div class="form-group">
            <label>📌 存档点:</label>
            <input type="checkbox" id="isSavePoint"> 勾选后该节点可作为回档目标
        </div>

        <div class="form-group"><label>关联章节ID:</label><input type="number" id="chapterId"></div>
        <button class="btn" onclick="submitForm()">保存</button>
        <button class="btn" onclick="hideForm()">取消</button>
    </div>
</div>

<c:forEach items="${storyList}" var="node">
    <c:if test="${node.nodeId eq '1-1'}">
        <c:set var="startRewards" value="${node.rewards}" />
    </c:if>
</c:forEach>

<script>
    var bookId = ${bookId};
    var isEdit = false;
    var editId = null;
    var DEFAULT_ATTRS = { "拳意":10, "剑意":0, "体魄":100, "灵气":50, "气运":7, "境界":1 };
    var startRewardsStr = '<c:out value="${startRewards}" default="" />';

    function parseJson(str) { if (!str) return null; try { return JSON.parse(str); } catch(e) { return null; } }

    // ========== 初始属性管理 ==========
    function addInitialAttr(key, value, disabled) {
        var container = document.getElementById('initialAttrsContainer');
        var row = document.createElement('div');
        row.className = 'dynamic-row';
        row.innerHTML = '<input type="text" placeholder="属性名" class="init-key" value="' + (key||'') + '" ' + (disabled ? 'disabled' : '') + '>' +
            '<input type="number" placeholder="初始值" class="init-value" value="' + (value !== undefined ? value : '') + '" style="width:80px;" ' + (disabled ? 'disabled' : '') + '>' +
            (disabled ? '' : '<button class="btn btn-remove" onclick="this.parentElement.remove()">删除</button>');
        container.appendChild(row);
    }
    function clearInitialAttrs() { document.getElementById('initialAttrsContainer').innerHTML = ''; }
    function fillDefaultInitialAttrs(disabled) {
        clearInitialAttrs();
        for (var k in DEFAULT_ATTRS) addInitialAttr(k, DEFAULT_ATTRS[k], disabled);
    }
    function fillInitialAttrsFromJson(jsonStr, disabled) {
        clearInitialAttrs();
        var obj = parseJson(jsonStr);
        if (obj) { for (var k in obj) addInitialAttr(k, obj[k], disabled); }
        else fillDefaultInitialAttrs(disabled);
    }
    function buildInitialAttrsJson() {
        var keys = document.querySelectorAll('#initialAttrsContainer .init-key');
        var vals = document.querySelectorAll('#initialAttrsContainer .init-value');
        var obj = {};
        for (var i = 0; i < keys.length; i++) {
            var k = keys[i].value.trim(), v = parseInt(vals[i].value);
            if (k && !isNaN(v)) obj[k] = v;
        }
        return JSON.stringify(obj);
    }
    function toggleInitialAttrsEditable(editable) {
        var container = document.getElementById('initialAttrsContainer');
        var inputs = container.querySelectorAll('input');
        var addBtn = document.getElementById('addAttrBtn');
        var notice = document.getElementById('attrNotice');
        for (var i = 0; i < inputs.length; i++) inputs[i].disabled = !editable;
        addBtn.style.display = editable ? 'inline-block' : 'none';
        notice.innerText = editable ? '可修改初始属性' : '仅展示初始属性，不可修改';
        var removeBtns = container.querySelectorAll('.btn-remove');
        for (var j = 0; j < removeBtns.length; j++) removeBtns[j].style.display = editable ? 'inline-block' : 'none';
    }
    function onNodeIdChange() {
        var isStart = document.getElementById('nodeId').value.trim() === '1-1';
        toggleInitialAttrsEditable(isStart);
        document.getElementById('rewardGroup').style.display = isStart ? 'none' : 'block';
    }

    // ========== 选项（带条件） ==========
    function addOption(text, target, requireObj) {
        var container = document.getElementById('optionsContainer');
        var block = document.createElement('div');
        block.className = 'option-block';
        var blockId = 'optBlock_' + Date.now() + Math.random();
        block.id = blockId;
        var row = document.createElement('div');
        row.className = 'dynamic-row';
        row.innerHTML = '<input type="text" placeholder="选项文本" class="opt-text" value="' + (text||'') + '">' +
            '<input type="text" placeholder="目标节点" class="opt-target"  value="' + (target||'') + '">' +
            '<button class="btn btn-small" onclick="toggleOptionConditions(\'' + blockId + '\')">⚙️条件</button>' +
            '<button class="btn btn-remove btn-small" onclick="this.closest(\'.option-block\').remove()">删除选项</button>';
        block.appendChild(row);
        var condDiv = document.createElement('div');
        condDiv.className = 'option-conditions';
        condDiv.id = blockId + '_conds';
        condDiv.innerHTML = '<button class="btn btn-small" onclick="addOptionCondition(\'' + blockId + '\')">+ 添加条件</button>';
        block.appendChild(condDiv);
        container.appendChild(block);
        if (requireObj) {
            for (var key in requireObj) {
                var need = requireObj[key].min || requireObj[key];
                addOptionConditionRow(blockId, key, need);
            }
            document.getElementById(blockId + '_conds').style.display = 'block';
        }
    }
    function toggleOptionConditions(blockId) {
        var condDiv = document.getElementById(blockId + '_conds');
        condDiv.style.display = (condDiv.style.display === 'block') ? 'none' : 'block';
    }
    function addOptionCondition(blockId) { addOptionConditionRow(blockId, '', ''); }
    function addOptionConditionRow(blockId, key, value) {
        var condDiv = document.getElementById(blockId + '_conds');
        var row = document.createElement('div');
        row.className = 'dynamic-row';
        row.innerHTML = '<input type="text" placeholder="属性名" class="cond-key" value="' + (key||'') + '">' +
            '<input type="number" placeholder="最小值" class="cond-value" value="' + (value !== undefined ? value : '') + '" style="width:80px;">' +
            '<button class="btn btn-remove btn-small" onclick="this.parentElement.remove()">删除</button>';
        var addBtn = condDiv.querySelector('button');
        condDiv.insertBefore(row, addBtn);
    }
    function parseOptions(jsonStr) {
        if (!jsonStr) return;
        try { JSON.parse(jsonStr).forEach(function(opt) { addOption(opt.text, opt.target, opt.require); }); } catch(e) {}
    }
    function buildOptionsJson() {
        var blocks = document.querySelectorAll('#optionsContainer .option-block');
        var arr = [];
        blocks.forEach(function(block) {
            var text = block.querySelector('.opt-text').value.trim();
            var target = block.querySelector('.opt-target').value.trim();
            if (!text || !target) return;
            var opt = { text: text, target: target };
            var condKeys = block.querySelectorAll('.cond-key');
            var condValues = block.querySelectorAll('.cond-value');
            var require = {};
            for (var i = 0; i < condKeys.length; i++) {
                var k = condKeys[i].value.trim(), v = parseInt(condValues[i].value);
                if (k && !isNaN(v)) require[k] = { min: v };
            }
            if (Object.keys(require).length > 0) opt.require = require;
            arr.push(opt);
        });
        return JSON.stringify(arr);
    }

    // ========== 奖励行 ==========
    function addReward(key, value) {
        var row = document.createElement('div'); row.className = 'dynamic-row';
        row.innerHTML = '<input type="text" placeholder="属性名" class="reward-key" value="' + (key||'') + '">' +
            '<input type="number" placeholder="变化量" class="reward-value" value="' + (value !== undefined ? value : '') + '" style="width:80px;">' +
            '<button class="btn btn-remove" onclick="this.parentElement.remove()">删除</button>';
        document.getElementById('rewardsContainer').appendChild(row);
    }
    function parseRewards(json) { if(json) try { var o=JSON.parse(json); for(var k in o) addReward(k, o[k]); } catch(e){} }
    function buildRewardsJson() {
        var keys = document.querySelectorAll('#rewardsContainer .reward-key');
        var vals = document.querySelectorAll('#rewardsContainer .reward-value');
        var obj = {};
        for (var i = 0; i < keys.length; i++) {
            var k = keys[i].value.trim(), v = parseInt(vals[i].value);
            if (k && !isNaN(v)) obj[k] = v;
        }
        return JSON.stringify(obj);
    }

    // ========== 表单逻辑 ==========
    function showAddForm() {
        document.getElementById('optionsContainer').innerHTML = '';
        document.getElementById('rewardsContainer').innerHTML = '';
        fillDefaultInitialAttrs(true);
        toggleInitialAttrsEditable(true);
        document.getElementById('editForm').style.display = 'block';
        document.getElementById('formTitle').innerText = '新增节点';
        document.getElementById('nodeId').value = '';
        document.getElementById('nodeTitle').value = '';
        document.getElementById('storyText').value = '';
        document.getElementById('chapterId').value = '';
        document.getElementById('nodeId_hidden').value = '';
        document.getElementById('rewardGroup').style.display = 'block';
        document.getElementById('isSavePoint').checked = false;
        isEdit = false; editId = null;
    }
    function hideForm() { document.getElementById('editForm').style.display = 'none'; }

    document.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('.edit-btn').forEach(function(btn) {
            btn.addEventListener('click', function() {
                var ds = this.dataset;
                document.getElementById('optionsContainer').innerHTML = '';
                document.getElementById('rewardsContainer').innerHTML = '';
                document.getElementById('editForm').style.display = 'block';
                document.getElementById('formTitle').innerText = '编辑节点';
                document.getElementById('nodeId_hidden').value = ds.id;
                document.getElementById('nodeId').value = ds.nodeid;
                document.getElementById('nodeTitle').value = ds.title;
                document.getElementById('storyText').value = ds.text;
                document.getElementById('chapterId').value = ds.chapterid;
                parseOptions(ds.options);
                var isStart = (ds.nodeid === '1-1');
                if (isStart) {
                    fillInitialAttrsFromJson(ds.rewards, false);
                    toggleInitialAttrsEditable(true);
                    document.getElementById('rewardGroup').style.display = 'none';
                } else {
                    fillInitialAttrsFromJson(startRewardsStr, true);
                    toggleInitialAttrsEditable(false);
                    document.getElementById('rewardGroup').style.display = 'block';
                    parseRewards(ds.rewards);
                }
                var reqObj = {};
                try { reqObj = JSON.parse(ds.requirements || '{}'); } catch(e) {}
                document.getElementById('isSavePoint').checked = (reqObj.save === true);
                isEdit = true; editId = ds.id;
            });
        });
    });

    function submitForm() {
        var action = isEdit ? 'update' : 'add';
        var nodeIdValue = document.getElementById('nodeId').value.trim();
        var isStart = (nodeIdValue === '1-1');
        var rewardsJson = isStart ? buildInitialAttrsJson() : buildRewardsJson();
        var savePoint = document.getElementById('isSavePoint').checked;
        var reqObj = {};
        if (savePoint) reqObj.save = true;
        var requirementsStr = JSON.stringify(reqObj);
        var params = 'action=' + action +
            '&bookId=' + bookId +
            '&chapterId=' + document.getElementById('chapterId').value +
            '&nodeId=' + encodeURIComponent(nodeIdValue) +
            '&nodeTitle=' + encodeURIComponent(document.getElementById('nodeTitle').value) +
            '&storyText=' + encodeURIComponent(document.getElementById('storyText').value) +
            '&options=' + encodeURIComponent(buildOptionsJson()) +
            '&requirements=' + encodeURIComponent(requirementsStr) +
            '&rewards=' + encodeURIComponent(rewardsJson);
        if (isEdit) params += '&id=' + editId;
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/gameManage', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function() {
            try { var res = JSON.parse(xhr.responseText); alert(res.msg); if(res.code===200) location.reload(); }
            catch(e) { alert('操作失败，请重试'); }
        };
        xhr.send(params);
    }

    function deleteNode(id) {
        if (!confirm('确定删除此节点吗？')) return;
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/gameManage', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function() {
            try { var res = JSON.parse(xhr.responseText); alert(res.msg); if(res.code===200) location.reload(); }
            catch(e) { alert('删除失败，请重试'); }
        };
        xhr.send('action=delete&id=' + id);
    }
</script>
</body>
</html>