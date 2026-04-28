<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Online藏书阁 - 玄元宗</title>
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
            --gold-gradient: linear-gradient(90deg, transparent, var(--gold-mid), var(--gold-light), var(--gold-mid), transparent);
            --purple: #9a88b0;
            --blue: #8aa3b8;
            --red: #a86666;
            --green: #7aa88a;
            --text-primary: #f0e2c0;
            --text-secondary: #d4c7b0;
            --text-tertiary: #b8a990;
        }
        body {
            font-family: "SimSun", "Times New Roman", serif;
            background: radial-gradient(ellipse at 30% 20%, rgba(26, 58, 63, 0.8) 0%, transparent 50%),
            linear-gradient(135deg, var(--bg-deepest) 0%, var(--bg-mid) 50%, var(--bg-dark) 100%);
            color: var(--text-secondary);
            overflow-x: hidden;
        }

        /* 左侧导航栏 */
        .nav-sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 280px;
            height: 100vh;
            background: linear-gradient(180deg, rgba(13, 31, 36, 0.96) 0%, rgba(23, 48, 54, 0.96) 100%);
            border-right: 3px solid var(--gold-dark);
            overflow-y: auto;
            overflow-x: hidden;
            padding: 40px 0;
            z-index: 999;
            box-shadow: 5px 0 25px rgba(0,0,0,0.85);
        }
        .nav-sidebar .logo {
            text-align: center;
            color: var(--text-primary);
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 50px;
            text-shadow: 0 0 20px var(--gold-mid), 0 0 40px rgba(201, 168, 102, 0.6);
            padding: 0 15px;
            letter-spacing: 5px;
            animation: logoBreath 3s ease-in-out infinite;
            white-space: nowrap;
        }
        @keyframes logoBreath {
            0%, 100% { text-shadow: 0 0 20px var(--gold-mid), 0 0 40px rgba(201, 168, 102, 0.6); }
            50% { text-shadow: 0 0 30px var(--gold-light), 0 0 60px rgba(230, 200, 136, 0.8); }
        }
        .nav-group-title {
            padding: 15px 25px;
            color: var(--gold-dark);
            font-size: 16px;
            font-weight: bold;
            letter-spacing: 2px;
            border-bottom: 1px solid rgba(201, 168, 102, 0.3);
            margin-top: 20px;
            white-space: nowrap;
        }
        .nav-sidebar .nav-item {
            display: block;
            width: 100%;
            padding: 18px 30px;
            color: var(--text-secondary);
            text-decoration: none;
            font-size: 20px;
            border-left: 5px solid transparent;
            transition: all 0.4s ease;
            letter-spacing: 2px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .nav-sidebar .nav-item:hover, .nav-sidebar .nav-item.active {
            background: rgba(138, 163, 184, 0.12);
            border-left: 5px solid var(--gold-mid);
            color: var(--text-primary);
            text-shadow: 0 0 10px var(--text-primary);
            transform: translateX(5px);
        }
        .nav-sidebar .nav-item:nth-child(8) { color: var(--purple); }
        .nav-sidebar .nav-item:nth-child(9) { color: var(--blue); }
        .nav-sidebar .nav-item:nth-child(10) { color: var(--red); }
        .nav-sidebar .nav-item:nth-child(11) { color: var(--green); }
        .nav-sidebar .nav-item:nth-child(n+8):hover { text-shadow: 0 0 10px currentColor; }

        /* 右侧主内容区 */
        .content-wrap {
            margin-left: 280px;
            min-height: 100vh;
            padding: 50px 60px;
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
        .btn-group {
            display: flex;
            gap: 20px;
            margin-bottom: 40px;
            justify-content: center;
            flex-wrap: wrap;
        }
        .magic-btn {
            padding: 12px 25px;
            background: linear-gradient(90deg, #173036, #244a52);
            color: var(--text-primary);
            text-decoration: none;
            font-size: 18px;
            border: 2px solid var(--gold-dark);
            border-radius: 5px;
            transition: all 0.3s ease;
            letter-spacing: 3px;
            cursor: pointer;
            font-family: "SimSun", serif;
            box-shadow: 0 4px 15px rgba(0,0,0,0.5);
            position: relative;
            overflow: hidden;
            display: inline-block;
        }
        .magic-btn::before {
            content: "";
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: var(--gold-gradient);
            opacity: 0.3;
            transition: all 0.6s ease;
        }
        .magic-btn:hover {
            background: linear-gradient(90deg, var(--gold-mid), var(--gold-light));
            color: var(--bg-deepest);
            font-weight: bold;
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(201, 168, 102, 0.6);
        }
        .magic-btn:hover::before { left: 100%; }
        .btn-sm { padding: 8px 15px; font-size: 16px; }
        .btn-danger { background: linear-gradient(90deg, #5a1a1a, #7a2a2a); border-color: #a83232; }
        .btn-danger:hover { background: linear-gradient(90deg, #a83232, #c84242); color: #fff; }
        .btn-success { background: linear-gradient(90deg, #1a5a2a, #2a7a3a); border-color: var(--green); }
        .btn-success:hover { background: linear-gradient(90deg, var(--green), #8ab89a); color: var(--bg-deepest); }
        .btn-warning {
            background: linear-gradient(90deg, #664a10, #886a20);
            border-color: #c9a866;
        }
        .btn-warning:hover {
            background: linear-gradient(90deg, #c9a866, #e6c888);
            color: #0d1f24;
        }

        /* 典籍卡片（左图右文布局） */
        .book-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 30px;
            margin-top: 30px;
        }
        .book-card {
            background: linear-gradient(180deg, rgba(23, 48, 54, 0.9) 0%, rgba(13, 31, 36, 0.94) 100%);
            border: 2px solid var(--gold-dark);
            border-radius: 10px;
            padding: 20px;
            transition: all 0.4s ease;
            box-shadow: inset 0 0 20px rgba(0,0,0,0.35), 0 6px 18px rgba(0,0,0,0.5);
            position: relative;
            overflow: hidden;
            display: flex;
            gap: 20px;
            align-items: stretch;
            min-height: 260px;
        }
        .book-card::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background: var(--gold-gradient);
            background-size: 200% 100%;
            animation: cardFlow 3s linear infinite;
        }
        @keyframes cardFlow {
            0% { background-position: 200% 0; }
            100% { background-position: -200% 0; }
        }
        .book-card:hover {
            transform: translateY(-6px);
            border-color: var(--gold-light);
            box-shadow: inset 0 0 20px rgba(0,0,0,0.35), 0 0 20px rgba(201, 168, 102, 0.4);
        }
        .card-cover-wrap {
            width: 180px;
            height: 100%;
            flex-shrink: 0;
            border-radius: 5px;
            overflow: hidden;
            border: 1px solid var(--gold-dark);
            box-shadow: 0 4px 12px rgba(0,0,0,0.4);
        }
        .card-cover-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .card-content-wrap {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 6px;
            height: 100%;
            width: 100%;
        }
        .book-card h3 {
            font-size: 28px;
            color: var(--text-primary);
            margin-bottom: 4px;
            letter-spacing: 2px;
            text-shadow: 0 0 12px rgba(201, 168, 102, 0.6);
            transition: all 0.3s ease;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .book-card:hover h3 { text-shadow: 0 0 18px var(--gold-light); }
        .book-card .author {
            font-size: 19px;
            color: var(--gold-mid);
            margin-bottom: 8px;
            font-style: italic;
            letter-spacing: 1px;
        }
        .book-card .summary {
            font-size: 16px;
            line-height: 1.5;
            color: var(--text-secondary);
            margin-bottom: 8px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .book-card .info {
            font-size: 15px;
            color: var(--text-tertiary);
            line-height: 1.6;
            margin-bottom: auto;
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
        }
        .book-card .info p { margin: 0; white-space: nowrap; }
        .book-card .info p span.hot-times {
            background: var(--gold-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-weight: bold;
            font-size: 16px;
            animation: numJump 2s ease-in-out infinite;
        }
        @keyframes numJump {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }
        .book-card .card-btn-group {
            display: flex;
            width: 100%;
            margin-top: 8px;
        }
        .book-card .card-btn-group .magic-btn {
            width: 100%;
            text-align: center;
            padding: 10px 0;
            font-size: 18px;
        }

        /* 弹窗通用样式 */
        .form-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.85);
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }
        .form-card {
            background: linear-gradient(180deg, var(--bg-light) 0%, var(--bg-deepest) 100%);
            border: 3px solid var(--gold-mid);
            border-radius: 10px;
            padding: 40px;
            box-shadow: 0 0 50px rgba(201, 168, 102, 0.35);
            max-height: 90vh;
            overflow-y: auto;
            position: relative;
        }
        .form-card h3 {
            text-align: center;
            font-size: 32px;
            color: var(--text-primary);
            margin-bottom: 30px;
            letter-spacing: 5px;
            text-shadow: 0 0 20px var(--gold-mid);
        }
        .form-row { margin-bottom: 20px; }
        .form-row label {
            display: block;
            font-size: 18px;
            color: var(--text-secondary);
            margin-bottom: 8px;
            letter-spacing: 1px;
        }
        .form-row input, .form-row select, .form-row textarea {
            width: 100%;
            padding: 12px 15px;
            background: rgba(255,255,255,0.1);
            border: 1px solid var(--gold-dark);
            border-radius: 5px;
            color: var(--text-primary);
            font-size: 16px;
            font-family: "SimSun", serif;
        }
        .form-row input:focus, .form-row select:focus, .form-row textarea:focus {
            outline: none;
            border-color: var(--gold-mid);
            box-shadow: 0 0 12px rgba(201, 168, 102, 0.5);
        }
        .form-row textarea { resize: vertical; min-height: 80px; }
        .form-btn-group {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 30px;
        }
        .add-card { width: 700px; }
        .detail-card { width: 1000px; max-width: 90vw; }

        /* 沉浸式阅读 */
        .read-page {
            display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; z-index: 99999;
            transition: all 0.3s ease;
            --read-bg: #f5f1e6; --read-text: #333333; --read-secondary: #666666; --read-border: #d9d2c3;
            --read-btn-bg: #ffffff; --read-btn-hover: #f0e6d2; --read-drawer-bg: #ffffff;
            background: var(--read-bg); color: var(--read-text);
        }
        .read-page.theme-default { --read-bg: #f5f1e6; --read-text: #333333; }
        .read-page.theme-eye { --read-bg: #e9f3e4; --read-text: #2d3e2a; }
        .read-page.theme-dark { --read-bg: #1a1a1a; --read-text: #e0e0e0; }
        .read-page.theme-blue { --read-bg: #e4edf5; --read-text: #2a3a4a; }
        .read-page.theme-zongmen { --read-bg: #0f252b; --read-text: #f0e2c0; --read-border: #a88a44; --read-drawer-bg: #173036; }

        .read-sidebar { position: fixed; top: 50%; right: 30px; transform: translateY(-50%); display: flex; flex-direction: column; gap: 20px; z-index: 100; }
        .read-sidebar-btn { width: 50px; height: 50px; border-radius: 50%; background: var(--read-btn-bg); border: 1px solid var(--read-border); display: flex; align-items: center; justify-content: center; font-size: 20px; cursor: pointer; transition: all 0.2s ease; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .read-sidebar-btn:hover { background: var(--read-btn-hover); transform: scale(1.05); }

        .drawer-mask { display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.3); z-index: 101; }
        .catalog-drawer, .setting-drawer { position: fixed; top: 0; left: -400px; width: 350px; height: 100vh; background: var(--read-drawer-bg); border-right: 1px solid var(--read-border); z-index: 102; transition: left 0.3s ease; display: flex; flex-direction: column; }
        .drawer-open { left: 0; }
        .drawer-header { display: flex; justify-content: space-between; align-items: center; padding: 25px 30px; border-bottom: 1px solid var(--read-border); }
        .drawer-header h3 { font-size: 24px; color: var(--read-text); letter-spacing: 2px; margin: 0; }
        .drawer-close { font-size: 28px; color: var(--read-secondary); cursor: pointer; line-height: 1; transition: color 0.2s ease; }
        .drawer-close:hover { color: var(--read-text); }
        .drawer-content { flex: 1; overflow-y: auto; padding: 20px 30px; }

        .catalog-select { width: 100%; padding: 10px 15px; background: var(--read-bg); border: 1px solid var(--read-border); border-radius: 5px; color: var(--read-text); font-size: 16px; margin-bottom: 20px; }
        .catalog-item { padding: 12px 15px; border-bottom: 1px solid var(--read-border); cursor: pointer; transition: all 0.2s ease; color: var(--read-text); font-size: 16px; border-radius: 5px; margin-bottom: 5px; }
        .catalog-item:hover, .catalog-item.active { background: var(--read-btn-hover); color: var(--read-text); font-weight: bold; }

        .setting-group { margin-bottom: 35px; }
        .setting-label { display: block; font-size: 16px; color: var(--read-text); margin-bottom: 15px; font-weight: bold; }
        .theme-list { display: flex; gap: 15px; }
        .theme-item { cursor: pointer; display: flex; flex-direction: column; align-items: center; gap: 8px; }
        .theme-color { width: 45px; height: 45px; border-radius: 50%; border: 2px solid transparent; transition: all 0.2s ease; }
        .theme-item.active .theme-color { border-color: var(--read-text); transform: scale(1.1); }
        .font-list { display: flex; gap: 10px; }
        .font-item { flex: 1; padding: 10px 0; background: var(--read-bg); border: 1px solid var(--read-border); border-radius: 5px; color: var(--read-text); font-size: 16px; cursor: pointer; transition: all 0.2s ease; }
        .font-item.active { background: var(--read-btn-hover); border-color: var(--read-text); font-weight: bold; }
        .size-control, .width-control { display: flex; align-items: center; gap: 15px; }
        .control-btn { width: 50px; height: 35px; background: var(--read-bg); border: 1px solid var(--read-border); border-radius: 5px; color: var(--read-text); cursor: pointer; transition: all 0.2s ease; }
        .control-btn:hover { background: var(--read-btn-hover); }
        .size-control input, .width-control input { flex: 1; cursor: pointer; }

        .read-main { width: 100%; max-width: 800px; margin: 0 auto; padding: 40px 20px 100px; height: 100vh; overflow-y: auto; transition: max-width 0.3s ease; }
        .read-book-title { text-align: center; font-size: 32px; color: var(--read-text); margin-bottom: 15px; letter-spacing: 5px; font-weight: bold; }
        .read-chapter-title { text-align: center; font-size: 24px; color: var(--read-text); margin-bottom: 40px; letter-spacing: 3px; font-weight: bold; }
        .read-content { font-size: 18px; line-height: 1.8; color: var(--read-text); font-family: "SimSun", serif; white-space: pre-wrap; word-break: break-word; margin-bottom: 60px; transition: all 0.2s ease; }
        .read-footer { display: flex; gap: 30px; justify-content: center; padding: 30px 0; border-top: 1px solid var(--read-border); }
        .footer-btn { padding: 12px 60px; background: var(--read-btn-bg); border: 1px solid var(--read-border); border-radius: 5px; color: var(--read-text); font-size: 18px; cursor: pointer; transition: all 0.2s ease; letter-spacing: 2px; }
        .footer-btn:hover { background: var(--read-btn-hover); transform: translateY(-2px); }

        /* 头像与用户卡片 */
        .avatar-wrap { display: flex; flex-direction: column; align-items: center; padding: 30px 0 20px; border-bottom: 1px solid rgba(201, 168, 102, 0.3); margin-bottom: 20px; }
        .avatar-box { width: 80px; height: 80px; border-radius: 50%; border: 3px solid var(--gold-mid); overflow: hidden; box-shadow: 0 0 20px rgba(201,168,102,0.5); margin-bottom: 10px; cursor: pointer; transition: all 0.3s ease; }
        .avatar-box:hover { transform: scale(1.05); box-shadow: 0 0 30px rgba(201,168,102,0.8); }
        .user-avatar { width: 100%; height: 100%; object-fit: cover; }
        .guest-avatar { filter: grayscale(0.7); opacity: 0.7; }
        .user-name { color: var(--text-primary); font-size: 20px; font-weight: bold; letter-spacing: 2px; margin-bottom: 5px; }
        .user-title { color: var(--gold-mid); font-size: 14px; letter-spacing: 1px; text-shadow: 0 0 10px rgba(201,168,102,0.5); }
        .user-tip { color: var(--text-tertiary); font-size: 14px; letter-spacing: 1px; }

        .user-card {
            position: fixed; top: 20px; left: 280px; width: 320px;
            background: linear-gradient(180deg, var(--bg-light) 0%, var(--bg-deepest) 100%);
            border: 3px solid var(--gold-mid); border-radius: 10px; box-shadow: 0 0 30px rgba(0,0,0,0.8);
            z-index: 99999; padding: 25px; opacity: 0; visibility: hidden; transform: translateX(-10px); transition: all 0.3s ease;
        }
        .card-show { opacity: 1; visibility: visible; transform: translateX(0); }
        .card-header { display: flex; gap: 15px; align-items: center; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 1px solid rgba(201,168,102,0.3); }
        .card-avatar { width: 60px; height: 60px; border-radius: 50%; border: 2px solid var(--gold-mid); object-fit: cover; }
        .card-user-info { flex: 1; }
        .card-username { color: var(--text-primary); font-size: 22px; font-weight: bold; letter-spacing: 2px; margin-bottom: 5px; }
        .card-title { color: var(--gold-mid); font-size: 14px; }
        .card-data { display: flex; justify-content: space-around; padding: 15px 0; border-bottom: 1px solid rgba(201,168,102,0.3); margin-bottom: 20px; }
        .data-item { display: flex; flex-direction: column; align-items: center; gap: 5px; }
        .data-num { color: var(--gold-light); font-size: 24px; font-weight: bold; text-shadow: 0 0 10px rgba(201,168,102,0.6); }
        .data-label { color: var(--text-secondary); font-size: 14px; }
        .card-btn-group { display: flex; gap: 10px; margin-bottom: 20px; }
        .card-btn {
            flex: 1; padding: 10px 0; background: linear-gradient(90deg, #173036, #244a52); border: 1px solid var(--gold-dark);
            border-radius: 5px; color: var(--text-primary); font-size: 14px; text-align: center; text-decoration: none;
            cursor: pointer; transition: all 0.3s ease; font-family: "SimSun", serif;
        }
        .card-btn:hover { background: linear-gradient(90deg, var(--gold-mid), var(--gold-light)); color: var(--bg-deepest); font-weight: bold; }
        .card-footer { border-top: 1px solid rgba(201,168,102,0.3); padding-top: 15px; text-align: center; }
        .logout-btn { color: var(--red); text-decoration: none; font-size: 16px; letter-spacing: 2px; transition: all 0.3s ease; }
        .logout-btn:hover { color: #ff6666; text-shadow: 0 0 10px rgba(255,102,102,0.6); }

        /* 藏经袋 */
        .cart-icon {
            position: fixed; top: 30px; right: 30px; width: 60px; height: 60px;
            background: linear-gradient(180deg, rgba(23,48,54,0.95) 0%, rgba(13,31,36,0.98) 100%);
            border: 2px solid #c9a866; border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-size: 28px; cursor: pointer; transition: all 0.3s ease; box-shadow: 0 0 15px rgba(201,168,102,0.2); z-index: 999;
        }
        .cart-icon:hover { transform: scale(1.05); box-shadow: 0 0 25px rgba(201,168,102,0.5); }
        .cart-badge {
            position: absolute; top: -5px; right: -5px; min-width: 22px; height: 22px;
            background: #ff4444; color: #fff; border-radius: 50%; font-size: 12px;
            display: flex; align-items: center; justify-content: center; font-weight: bold; box-shadow: 0 0 10px rgba(255,68,68,0.6);
        }
        .cart-modal {
            display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.7); z-index: 99999; justify-content: flex-end;
        }
        .cart-card {
            width: 500px; height: 100vh; background: linear-gradient(180deg, rgba(23,48,54,0.98) 0%, rgba(13,31,36,0.99) 100%);
            border-left: 3px solid #c9a866; box-shadow: -5px 0 30px rgba(0,0,0,0.8); display: flex; flex-direction: column;
        }
        .cart-header { display: flex; justify-content: space-between; align-items: center; padding: 30px; border-bottom: 1px solid rgba(201,168,102,0.3); }
        .cart-header h3 { font-size: 28px; color: #f0e2c0; letter-spacing: 5px; text-shadow: 0 0 15px #c9a866; margin: 0; }
        .cart-close { font-size: 36px; color: #c9a866; cursor: pointer; transition: all 0.3s ease; }
        .cart-close:hover { color: #fff; transform: rotate(90deg); }
        .cart-body { flex: 1; overflow-y: auto; padding: 20px 30px; }
        .cart-empty { text-align: center; padding: 80px 0; color: #d4c7b0; font-size: 18px; line-height: 2; }
        .cart-list { display: flex; flex-direction: column; }
        .cart-item { display: flex; align-items: center; gap: 15px; padding: 15px 0; border-bottom: 1px solid rgba(201,168,102,0.2); flex-wrap: wrap; }
        .cart-item-info { flex: 1; min-width: 200px; }
        .cart-item-title { font-size: 18px; color: #f0e2c0; margin-bottom: 5px; }
        .cart-item-author { font-size: 14px; color: #d4c7b0; margin-bottom: 8px; }
        .cart-item-price { color: #e6c888; font-size: 16px; font-weight: bold; }
        .cart-item-num { display: flex; align-items: center; gap: 10px; }
        .num-btn { width: 30px; height: 30px; background: rgba(201,168,102,0.2); border: 1px solid #c9a866; border-radius: 5px; color: #f0e2c0; cursor: pointer; }
        .num-btn:hover { background: #c9a866; color: #0d1f24; }
        .num-input { width: 50px; text-align: center; background: rgba(255,255,255,0.1); border: 1px solid #c9a866; border-radius: 5px; color: #f0e2c0; padding: 5px; }
        .cart-item-delete { color: #ff6666; cursor: pointer; font-size: 20px; transition: all 0.3s ease; margin-left: 10px; }
        .cart-item-delete:hover { transform: scale(1.2); text-shadow: 0 0 10px rgba(255,102,102,0.6); }
        .cart-footer { padding: 25px 30px; border-top: 1px solid rgba(201,168,102,0.3); }
        .cart-total { text-align: right; font-size: 20px; color: #f0e2c0; margin-bottom: 20px; }
        .cart-total span { color: #e6c888; font-weight: bold; font-size: 24px; }
        .cart-btn-group { display: flex; gap: 15px; justify-content: space-between; }
        .magic-btn-sm {
            padding: 8px 15px; font-size: 16px; background: linear-gradient(90deg, var(--bg-light), #244a52);
            color: var(--text-primary); border: 2px solid var(--gold-dark); border-radius: 5px;
            cursor: pointer; font-family: "SimSun", serif; transition: all 0.3s ease;
        }
        .magic-btn-sm:hover { background: linear-gradient(90deg, var(--gold-mid), var(--gold-light)); color: var(--bg-deepest); font-weight: bold; transform: translateY(-3px); }
        .magic-btn-sm.btn-danger { background: linear-gradient(90deg, #5a1a1a, #7a2a2a); border-color: #a83232; }
        .magic-btn-sm.btn-danger:hover { background: linear-gradient(90deg, #a83232, #c84242); color: #fff; }

        .add-cart-btn {
            background: linear-gradient(90deg, #244a52, #173036); border: 2px solid #c9a866; color: #f0e2c0;
            padding: 8px 15px; border-radius: 5px; font-family: "SimSun", serif; cursor: pointer;
            transition: all 0.3s ease; margin-right: 10px;
        }
        .add-cart-btn:hover { background: linear-gradient(90deg, #c9a866, #e6c888); color: #0d1f24; font-weight: bold; }

        /* 符文特效 */
        .sword-wave {
            position: fixed; width: 60px; height: 60px; border: 3px solid #c9a866; border-radius: 50%;
            pointer-events: none; z-index: 99998; box-shadow: 0 0 15px #c9a866, 0 0 30px rgba(201,168,102,0.6);
        }
        @keyframes waveExpand { 0% { opacity: 1; transform: translate(-50%, -50%) scale(0.5); } 100% { opacity: 0; transform: translate(-50%, -50%) scale(2.0); } }
        .wave-animate { animation: waveExpand 0.8s ease-out forwards; }
        .rune-text {
            position: fixed; font-family: "SimSun", "KaiTi", serif; font-size: 32px; font-weight: bold; color: #c9a866;
            text-shadow: 0 0 10px #c9a866, 0 0 20px rgba(201,168,102,0.8); pointer-events: none;
            z-index: 99999; user-select: none; white-space: nowrap;
        }
        @keyframes runeFloat { 0% { opacity: 1; transform: translateY(0) scale(1); } 100% { opacity: 0; transform: translateY(-120px) scale(1.2); } }
        .rune-animate { animation: runeFloat 0.9s ease-out forwards; }

        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: var(--bg-deepest); }
        ::-webkit-scrollbar-thumb { background: var(--gold-dark); border-radius: 4px; }
        ::-webkit-scrollbar-thumb:hover { background: var(--gold-mid); }
    </style>
</head>
<body>
<!-- 左侧导航栏 -->
<div class="nav-sidebar">
    <div class="avatar-wrap">
        <c:choose>
            <c:when test="${not empty sessionScope.loginUser}">
                <div class="avatar-box" id="loginAvatar">
                    <img src="${pageContext.request.contextPath}${sessionScope.loginUser.avatarPath}" alt="头像" class="user-avatar" id="avatarImg">
                </div>
                <div class="user-name">${sessionScope.loginUser.username}</div>
                <div class="user-title">${sessionScope.loginUser.userTitle}</div>
            </c:when>
            <c:otherwise>
                <div class="avatar-box" id="guestAvatar">
                    <img src="${pageContext.request.contextPath}/images/default-avatar.png" alt="默认头像" class="user-avatar guest-avatar">
                </div>
                <div class="user-tip" title="暂未登录，请登录后使用">暂未登录</div>
            </c:otherwise>
        </c:choose>
    </div>
    <div class="logo">📜 Online藏书阁</div>
    <a href="zongmen.jsp" class="nav-item">🏠 图书管理首页</a>
    <a href="login.jsp" class="nav-item">🔐 登录</a>
    <a href="register.jsp" class="nav-item">📝 注册成为藏书阁成员</a>
    <a href="tushuguan" class="nav-item active">📚 全本藏书</a>
    <a href="bookManage" class="nav-item">📋 典籍总录·管理</a>
    <a href="javascript:openAddForm()" class="nav-item">✍️ 新增典籍</a>
    <a href="${pageContext.request.contextPath}/chapterAdd" class="nav-item">📖 录入章节</a>
    <c:if test="${not empty sessionScope.loginUser}">
        <a href="${pageContext.request.contextPath}/orderList" class="nav-item">📜 我的道契中心</a>
        <a href="${pageContext.request.contextPath}/userBook" class="nav-item">📖 私人藏经阁</a>
    </c:if>
    <a href="usersList" class="nav-item">👥 人员注册名录</a>
    <div class="nav-group-title">典籍分类</div>
    <a href="tushuguan?typeId=1" class="nav-item">🎴 玄幻修真</a>
    <a href="tushuguan?typeId=2" class="nav-item">🔬 科幻科技</a>
    <a href="tushuguan?typeId=3" class="nav-item">⚔️ 历史武侠</a>
    <a href="tushuguan?typeId=4" class="nav-item">📜 经典文学</a>
</div>

<!-- 登录后悬浮卡片 -->
<div class="user-card" id="userCard">
    <c:if test="${not empty sessionScope.loginUser}">
        <div class="card-header">
            <img src="${pageContext.request.contextPath}${sessionScope.loginUser.avatarPath}" alt="头像" class="card-avatar">
            <div class="card-user-info">
                <div class="card-username">${sessionScope.loginUser.username}</div>
                <div class="card-title" id="cardTitle">${sessionScope.loginUser.userTitle}</div>
            </div>
        </div>
        <div class="card-data">
            <div class="data-item">
                <span class="data-num">${sessionScope.loginUser.readBookNum}</span>
                <span class="data-label">已阅典籍</span>
            </div>
            <div class="data-item">
                <span class="data-num">${sessionScope.loginUser.readChapterNum}</span>
                <span class="data-label">已读章节</span>
            </div>
        </div>
        <div class="card-btn-group">
            <button class="card-btn" id="editTitleBtn">✏️ 编辑头衔</button>
            <a href="${pageContext.request.contextPath}/usersList" class="card-btn">📋 人员名录</a>
        </div>
        <div class="card-footer">
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">退出登录</a>
        </div>
    </c:if>
</div>

<!-- 编辑头衔弹窗（仅登录用户渲染） -->
<c:if test="${not empty sessionScope.loginUser}">
    <div class="form-modal" id="titleModal">
        <div class="form-card add-card">
            <h3>编辑我的头衔</h3>
            <form id="titleForm">
                <div class="form-row">
                    <label>自定义头衔（最多10个字）</label>
                    <input type="text" name="newTitle" id="newTitleInput" maxlength="10" value="${sessionScope.loginUser.userTitle}" required>
                </div>
                <div class="form-btn-group">
                    <button type="submit" class="magic-btn">保存修改</button>
                    <button type="button" class="magic-btn" onclick="closeTitleModal()">取消</button>
                </div>
            </form>
        </div>
    </div>
</c:if>

<!-- 右侧主内容区 -->
<div class="content-wrap">
    <div class="cart-icon" id="cartIcon">
        🛒
        <span class="cart-badge" id="cartBadge">0</span>
    </div>

    <h1 class="page-title">Online藏书阁</h1>
    <div class="btn-group">
        <a href="tushuguan" class="magic-btn">查看全部典籍</a>
        <a href="javascript:openAddForm()" class="magic-btn">录入新典籍</a>
    </div>

    <!-- 典籍网格 -->
    <div class="book-grid">
        <c:forEach items="${bookList}" var="book">
            <div class="book-card"
                 data-book-id="${book.id}"
                 data-title="${book.bookTitle}"
                 data-author="${book.bookAuthor}"
                 data-summary="${book.bookSummary}"
                 data-type="${book.typeId}"
                 data-pubyear="${book.bookPubYear}"
                 data-times="${book.downloadTimes}"
                 data-format="${book.bookFormat}"
                 data-price="${book.price}"
                 data-cover="${book.bookCover}">
                <div class="card-cover-wrap">
                    <c:choose>
                        <c:when test="${not empty book.bookCover}">
                            <img src="${pageContext.request.contextPath}${book.bookCover}" class="card-cover-img" alt="${book.bookTitle}">
                        </c:when>
                        <c:otherwise>
                            <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='180' height='260' viewBox='0 0 180 260'%3E%3Crect width='180' height='260' fill='%233d5a5a'/%3E%3Ctext x='45' y='130' font-family='SimSun' font-size='18' fill='%23c9a866'%3E无封面%3C/text%3E%3C/svg%3E"
                                 class="card-cover-img" alt="默认封面">
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="card-content-wrap">
                    <h3>${book.bookTitle}</h3>
                    <p class="author">作者：${book.bookAuthor}</p>
                    <p class="summary">${book.bookSummary}</p>
                    <div class="info">
                        <p>出版年份：${book.bookPubYear}</p>
                        <p>传阅次数：<span class="hot-times">${book.downloadTimes}</span> 次</p>
                        <p>典籍格式：${book.bookFormat}</p>
                    </div>
                    <div class="card-btn-group">
                        <button class="magic-btn btn-sm" onclick="openDetailModal(this.closest('.book-card'))">查看详情</button>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<!-- 藏经袋弹窗 -->
<div class="cart-modal" id="cartModal">
    <div class="cart-card">
        <div class="cart-header">
            <h3>我的藏经袋</h3>
            <span class="cart-close" id="cartClose">×</span>
        </div>
        <div class="cart-body" id="cartBody">
            <div class="cart-empty" id="cartEmpty">
                <p>道友的藏经袋空空如也</p>
                <p>快去请购心仪的典籍吧</p>
            </div>
            <div class="cart-list" id="cartList"></div>
        </div>
        <div class="cart-footer" id="cartFooter">
            <div class="cart-total">
                合计香火：<span id="cartTotal">0.00</span> 灵石
            </div>
            <div class="cart-btn-group">
                <button class="magic-btn-sm btn-danger" id="clearCartBtn">清空藏经袋</button>
                <button class="magic-btn-sm" id="settleBtn">去结算</button>
            </div>
        </div>
    </div>
</div>

<!-- 新增典籍弹窗 -->
<div class="form-modal" id="addFormModal">
    <div class="form-card add-card">
        <h3>录入新典籍</h3>
        <form action="bookAdd" method="post">
            <div class="form-row"><label>典籍名称</label><input type="text" name="bookTitle" required></div>
            <div class="form-row"><label>典籍作者</label><input type="text" name="bookAuthor" required></div>
            <div class="form-row"><label>典籍简介</label><textarea name="bookSummary" required></textarea></div>
            <div class="form-row">
                <label>典籍分类</label>
                <select name="typeId" required>
                    <option value="1">玄幻修真</option><option value="2">科幻科技</option>
                    <option value="3">历史武侠</option><option value="4">经典文学</option>
                </select>
            </div>
            <div class="form-row"><label>传阅次数</label><input type="number" name="downloadTimes" value="0" required></div>
            <div class="form-row"><label>出版年份</label><input type="date" name="bookPubYear" required></div>
            <div class="form-row"><label>典籍文件路径</label><input type="text" name="bookFile" value="/files/default.pdf"></div>
            <div class="form-row"><label>典籍封面路径</label><input type="text" name="bookCover" value="/cover/default.jpg"></div>
            <div class="form-row">
                <label>典籍格式</label>
                <select name="bookFormat" required>
                    <option value="pdf">PDF</option><option value="epub">EPUB</option><option value="txt">TXT</option>
                </select>
            </div>
            <div class="form-btn-group">
                <button type="submit" class="magic-btn">录入典籍</button>
                <button type="button" class="magic-btn" onclick="closeAddForm()">取消</button>
            </div>
        </form>
    </div>
</div>

<!-- 典籍详情弹窗 -->
<div class="form-modal" id="detailModal">
    <div class="form-card detail-card">
        <span class="detail-close" onclick="closeDetailModal()" style="position: absolute; top: 20px; right: 30px; font-size: 40px; color: var(--gold-mid); cursor: pointer; line-height: 1; transition: all 0.3s ease;">×</span>
        <div class="detail-header" style="display: flex; gap: 40px; margin-bottom: 40px; padding-bottom: 30px; border-bottom: 1px solid rgba(201, 168, 102, 0.3);">
            <div class="detail-cover-wrap" style="width: 200px; height: 270px; flex-shrink: 0; border-radius: 10px; overflow: hidden; border: 2px solid var(--gold-dark); box-shadow: 0 8px 20px rgba(0,0,0,0.6);">
                <img id="detail-cover" src="" alt="典籍封面" style="width: 100%; height: 100%; object-fit: cover;">
            </div>
            <div class="detail-info-wrap" style="flex: 1; display: flex; flex-direction: column; gap: 15px;">
                <h2 id="detail-book-title" style="font-size: 36px; color: var(--text-primary); font-weight: bold; letter-spacing: 3px; text-shadow: 0 0 15px var(--gold-mid);"></h2>
                <div id="detail-author" style="font-size: 20px; color: var(--gold-mid);"></div>
                <div class="detail-meta" style="display: flex; flex-wrap: wrap; gap: 20px 30px; font-size: 16px; color: var(--text-secondary);" id="detail-meta"></div>
                <div class="detail-data" style="display: flex; gap: 40px; font-size: 24px; color: var(--gold-light); font-weight: bold; margin: 10px 0;" id="detail-data"></div>
                <div class="detail-btn-group" style="display: flex; gap: 15px; flex-wrap: wrap; margin-top: auto;">
                    <button class="magic-btn" id="detail-cart-btn" data-book-id="">请购入袋</button>
                    <button class="magic-btn btn-sm" onclick="openReadModalFromDetail()">开始阅读</button>
                    <a href="#" class="magic-btn btn-sm btn-danger" id="detail-del-btn" onclick="return confirm('确定要销毁这部典籍吗？此操作不可恢复！')">销毁典籍</a>
                </div>
            </div>
        </div>
        <div class="detail-summary-wrap">
            <h3 style="font-size: 28px; color: var(--text-primary); font-weight: bold; letter-spacing: 2px; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 2px solid rgba(201, 168, 102, 0.3);">作品简介</h3>
            <div id="detail-summary" style="font-size: 18px; line-height: 1.8; color: var(--text-secondary); background: rgba(0,0,0,0.2); padding: 25px; border-radius: 10px;"></div>
        </div>
    </div>
</div>

<!-- 沉浸式阅读界面 -->
<div id="readPage" class="read-page">
    <!-- 侧边栏、抽屉、正文等（原样保留） -->
    <div class="read-sidebar">
        <div class="read-sidebar-btn" id="catalogBtn" title="目录">📑</div>
        <div class="read-sidebar-btn" id="settingBtn" title="设置">⚙️</div>
        <div class="read-sidebar-btn" id="backTopBtn" title="回到顶部">⬆️</div>
        <div class="read-sidebar-btn" id="exitReadBtn" title="退出阅读">❌</div>
    </div>
    <div class="catalog-drawer" id="catalogDrawer">
        <div class="drawer-header"><h3>章节目录</h3><span class="drawer-close" id="catalogClose">×</span></div>
        <div class="drawer-content">
            <select id="chapterSelect" class="catalog-select" onchange="loadChapterContent()">
                <option value="">暂无章节</option>
            </select>
            <div class="catalog-list" id="catalogList"></div>
        </div>
    </div>
    <div class="setting-drawer" id="settingDrawer">
        <div class="drawer-header"><h3>阅读设置</h3><span class="drawer-close" id="settingClose">×</span></div>
        <div class="drawer-content">
            <div class="setting-group">
                <label class="setting-label">阅读主题</label>
                <div class="theme-list">
                    <div class="theme-item theme-default active" data-theme="default"><div class="theme-color" style="background: #f5f1e6;"></div></div>
                    <div class="theme-item theme-eye" data-theme="eye"><div class="theme-color" style="background: #e9f3e4;"></div></div>
                    <div class="theme-item theme-dark" data-theme="dark"><div class="theme-color" style="background: #1a1a1a;"></div></div>
                    <div class="theme-item theme-blue" data-theme="blue"><div class="theme-color" style="background: #e4edf5;"></div></div>
                    <div class="theme-item theme-zongmen" data-theme="zongmen"><div class="theme-color" style="background: #0f252b; border: 1px solid #a88a44;"></div></div>
                </div>
            </div>
            <div class="setting-group">
                <label class="setting-label">正文字体</label>
                <div class="font-list">
                    <button class="font-item active" data-font="SimSun">宋体</button>
                    <button class="font-item" data-font="Microsoft YaHei">黑体</button>
                    <button class="font-item" data-font="KaiTi">楷体</button>
                </div>
            </div>
            <div class="setting-group">
                <label class="setting-label">字体大小 <span id="fontSizeText">18px</span></label>
                <div class="size-control">
                    <button class="control-btn" id="fontMinus">A-</button>
                    <input type="range" id="fontSizeRange" min="14" max="28" value="18" step="1">
                    <button class="control-btn" id="fontPlus">A+</button>
                </div>
            </div>
            <div class="setting-group">
                <label class="setting-label">页面宽度 <span id="widthText">800px</span></label>
                <div class="width-control">
                    <button class="control-btn" id="widthMinus">窄</button>
                    <input type="range" id="widthRange" min="600" max="1200" value="800" step="50">
                    <button class="control-btn" id="widthPlus">宽</button>
                </div>
            </div>
            <div class="setting-group">
                <button class="magic-btn" style="width:100%;" onclick="editCurrentChapter()">编辑本章</button>
            </div>
        </div>
    </div>
    <div class="read-main">
        <div class="read-book-title" id="read-book-title">典籍阅读</div>
        <div class="read-chapter-title" id="read-chapter-title">请选择章节开始阅读</div>
        <div class="read-content" id="readContent">请先选择章节，开始阅读...</div>
        <div class="read-footer">
            <button class="footer-btn" onclick="openCatalog()">目录</button>
            <button class="footer-btn" onclick="nextChapter()">下一章</button>
        </div>
    </div>
    <div class="drawer-mask" id="drawerMask"></div>
</div>

<script>
    // ================== 全局变量 ==================
    var loginAvatar = document.getElementById('loginAvatar');
    var userCard = document.getElementById('userCard');
    var guestAvatar = document.getElementById('guestAvatar');
    var titleModal = document.getElementById('titleModal');
    var titleForm = document.getElementById('titleForm');
    var addFormModal = document.getElementById('addFormModal');
    var detailModal = document.getElementById('detailModal');
    var readPage = document.getElementById('readPage');
    var chapterSelect = document.getElementById('chapterSelect');
    var catalogList = document.getElementById('catalogList');
    var readContent = document.getElementById('readContent');
    var catalogDrawer = document.getElementById('catalogDrawer');
    var settingDrawer = document.getElementById('settingDrawer');
    var drawerMask = document.getElementById('drawerMask');
    var cartModal = document.getElementById('cartModal');
    var cartIcon = document.getElementById('cartIcon');
    var cartClose = document.getElementById('cartClose');
    var cartBadge = document.getElementById('cartBadge');
    var cartEmpty = document.getElementById('cartEmpty');
    var cartList = document.getElementById('cartList');
    var cartTotal = document.getElementById('cartTotal');
    var cartFooter = document.getElementById('cartFooter');
    var clearCartBtn = document.getElementById('clearCartBtn');
    var settleBtn = document.getElementById('settleBtn');

    var currentBookId = null;
    var currentDetailCard = null;
    var currentChapterList = [];
    var currentChapterIndex = 0;
    var isLogin = ${not empty sessionScope.loginUser};

    // ================== 头像与用户卡片交互 ==================
    if (loginAvatar) {
        loginAvatar.addEventListener('mouseenter', function() { userCard.classList.add('card-show'); });
        userCard.addEventListener('mouseleave', function() { userCard.classList.remove('card-show'); });
    }
    if (guestAvatar) {
        guestAvatar.addEventListener('click', function() { window.location.href = '${pageContext.request.contextPath}/login.jsp'; });
    }
    if (document.getElementById('editTitleBtn')) {
        document.getElementById('editTitleBtn').addEventListener('click', function() {
            userCard.classList.remove('card-show');
            titleModal.style.display = 'flex';
        });
    }
    function closeTitleModal() { if (titleModal) titleModal.style.display = 'none'; }
    if (titleModal) { titleModal.onclick = function(e) { if (e.target === this) closeTitleModal(); }; }
    if (titleForm) {
        titleForm.onsubmit = function(e) {
            e.preventDefault();
            var newTitle = document.getElementById('newTitleInput').value.trim();
            var xhr = new XMLHttpRequest();
            xhr.open('POST', '${pageContext.request.contextPath}/updateTitle', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        try {
                            var res = JSON.parse(xhr.responseText);
                            alert(res.msg);
                            if (res.code === 200) { closeTitleModal(); window.location.reload(); }
                        } catch (e) { alert('数据解析失败'); }
                    } else { alert('请求失败'); }
                }
            };
            xhr.send('newTitle=' + encodeURIComponent(newTitle));
        };
    }

    // ================== 新增典籍 ==================
    function openAddForm() { addFormModal.style.display = 'flex'; }
    function closeAddForm() { addFormModal.style.display = 'none'; }
    addFormModal.onclick = function(e) { if (e.target === this) closeAddForm(); };

    // ================== 详情弹窗 ==================
    function openDetailModal(card) {
        currentDetailCard = card;
        var ds = card.dataset;
        var typeMap = {'1':'玄幻修真','2':'科幻科技','3':'历史武侠','4':'经典文学'};

        var coverImg = document.getElementById('detail-cover');
        if (ds.cover) {
            coverImg.src = '${pageContext.request.contextPath}' + ds.cover;
        } else {
            coverImg.src = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='200' height='270' viewBox='0 0 200 270'%3E%3Crect width='200' height='270' fill='%233d5a5a'/%3E%3Ctext x='50' y='140' font-family='SimSun' font-size='18' fill='%23c9a866'%3E无封面%3C/text%3E%3C/svg%3E";
        }

        document.getElementById('detail-book-title').innerText = ds.title;
        document.getElementById('detail-author').innerText = '作者：' + ds.author;
        document.getElementById('detail-meta').innerHTML = '<span>' + (typeMap[ds.type] || '未分类') + '</span> | <span>出版：' + ds.pubyear + '</span> | <span>' + ds.format.toUpperCase() + '</span>';
        document.getElementById('detail-data').innerHTML =
            '<div style="display:flex;flex-direction:column;gap:5px;"><span style="font-size:14px;color:var(--text-tertiary);">价格</span><span>' + (ds.price || '0.00') + ' 灵石</span></div>' +
            '<div style="display:flex;flex-direction:column;gap:5px;"><span style="font-size:14px;color:var(--text-tertiary);">传阅次数</span><span>' + ds.times + '</span></div>';
        document.getElementById('detail-summary').innerText = ds.summary || '暂无简介';

        document.getElementById('detail-cart-btn').setAttribute('data-book-id', ds.bookId);
        document.getElementById('detail-del-btn').href = 'bookDelete?id=' + ds.bookId;

        detailModal.style.display = 'flex';
    }

    function openReadModalFromDetail() {
        if (currentDetailCard) {
            closeDetailModal();
            openReadModal(currentDetailCard);
        }
    }

    function closeDetailModal() { detailModal.style.display = 'none'; }
    detailModal.onclick = function(e) { if (e.target === detailModal) closeDetailModal(); };

    // ================== 沉浸式阅读 ==================
    function openReadModal(bookCard) {
        var bookId = bookCard.dataset.bookId;
        if (!bookId || isNaN(bookId)) {
            var urlParams = new URLSearchParams(window.location.search);
            bookId = urlParams.get('targetBookId');
        }
        if (!bookId || isNaN(bookId) || Number(bookId) <= 0) {
            alert("书籍ID无效");
            return;
        }
        currentBookId = Number(bookId);
        document.getElementById('read-book-title').innerText = bookCard.dataset.title;
        readPage.style.display = 'block';
        document.body.style.overflow = 'hidden';
        currentChapterList = [];
        renderChapterSelect();
        loadChapterList(currentBookId);
    }

    function loadChapterList(bookId) {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', '${pageContext.request.contextPath}/bookContent?action=list&bookId=' + bookId, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                try {
                    var res = JSON.parse(xhr.responseText);
                    if (res.code === 200) {
                        currentChapterList = res.data;
                        renderChapterSelect();
                        renderCatalogList();
                    } else {
                        alert(res.msg);
                        closeReadModal();
                    }
                } catch (e) {
                    alert("解析错误");
                    closeReadModal();
                }
            }
        };
        xhr.send();
    }

    function closeReadModal() {
        readPage.style.display = 'none';
        document.body.style.overflow = 'auto';
        closeAllDrawer();
        window.history.replaceState({}, document.title, window.location.pathname);
    }

    function renderChapterSelect() {
        var html = '';
        for (var i = 0; i < currentChapterList.length; i++) {
            var ch = currentChapterList[i];
            html += '<option value="' + ch.chapterNum + '">第' + ch.chapterNum + '章 ' + ch.chapterTitle + '</option>';
        }
        chapterSelect.innerHTML = html;
    }

    function renderCatalogList() {
        var html = '';
        for (var i = 0; i < currentChapterList.length; i++) {
            var ch = currentChapterList[i];
            html += '<div class="catalog-item" data-index="' + i + '" onclick="jumpToChapter(' + i + ')">第' + ch.chapterNum + '章 ' + ch.chapterTitle + '</div>';
        }
        catalogList.innerHTML = html;
    }

    function loadChapterContent() {
        var selectedChapterNum = chapterSelect.value;
        if (!selectedChapterNum) return;
        currentChapterIndex = chapterSelect.selectedIndex;
        readContent.innerText = '正在加载章节内容...';
        updateCatalogActive();
        var xhr = new XMLHttpRequest();
        xhr.open('GET', '${pageContext.request.contextPath}/bookContent?action=content&bookId=' + currentBookId + '&chapterNum=' + selectedChapterNum, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var res = JSON.parse(xhr.responseText);
                        if (res.code === 200) {
                            document.getElementById('read-chapter-title').innerText = '第' + res.data.chapterNum + '章 ' + res.data.chapterTitle;
                            readContent.innerText = res.data.chapterContent;
                        } else {
                            alert(res.msg);
                        }
                    } catch (e) {
                        alert('数据解析失败，请刷新页面重试');
                    }
                } else {
                    alert('请求失败，服务器错误：' + xhr.status);
                }
            }
        };
        xhr.send();
    }

    function jumpToChapter(index) {
        if (index < 0 || index >= currentChapterList.length) {
            alert('已无更多章节');
            return;
        }
        chapterSelect.selectedIndex = index;
        loadChapterContent();
        closeAllDrawer();
    }

    function preChapter() {
        if (currentChapterIndex > 0) jumpToChapter(currentChapterIndex - 1);
        else alert('已经是第一章了');
    }

    function nextChapter() {
        if (currentChapterIndex < currentChapterList.length - 1) jumpToChapter(currentChapterIndex + 1);
        else alert('已经是最后一章了');
    }

    function updateCatalogActive() {
        var items = document.querySelectorAll('.catalog-item');
        for (var i = 0; i < items.length; i++) items[i].classList.remove('active');
        var active = document.querySelector('.catalog-item[data-index="' + currentChapterIndex + '"]');
        if (active) active.classList.add('active');
    }

    function openCatalog() { catalogDrawer.classList.add('drawer-open'); drawerMask.style.display = 'block'; }
    function openSetting() { settingDrawer.classList.add('drawer-open'); drawerMask.style.display = 'block'; }
    function closeAllDrawer() { catalogDrawer.classList.remove('drawer-open'); settingDrawer.classList.remove('drawer-open'); drawerMask.style.display = 'none'; }
    function editCurrentChapter() {
        if (!currentChapterList.length) { alert('请先选择章节'); return; }
        var chapterId = currentChapterList[currentChapterIndex].id;
        window.open('${pageContext.request.contextPath}/chapterEdit?chapterId=' + chapterId, '_blank');
    }

    // 阅读设置事件绑定
    document.querySelectorAll('.theme-item').forEach(function(item) {
        item.addEventListener('click', function() {
            document.querySelectorAll('.theme-item').forEach(function(i) { i.classList.remove('active'); });
            this.classList.add('active');
            readPage.className = 'read-page theme-' + this.dataset.theme;
        });
    });
    document.querySelectorAll('.font-item').forEach(function(item) {
        item.addEventListener('click', function() {
            document.querySelectorAll('.font-item').forEach(function(i) { i.classList.remove('active'); });
            this.classList.add('active');
            readContent.style.fontFamily = this.dataset.font;
        });
    });
    document.getElementById('fontSizeRange').addEventListener('input', function() {
        readContent.style.fontSize = this.value + 'px';
        document.getElementById('fontSizeText').innerText = this.value + 'px';
    });
    document.getElementById('fontMinus').addEventListener('click', function() {
        var r = document.getElementById('fontSizeRange');
        r.value = Math.max(14, parseInt(r.value) - 1);
        r.dispatchEvent(new Event('input'));
    });
    document.getElementById('fontPlus').addEventListener('click', function() {
        var r = document.getElementById('fontSizeRange');
        r.value = Math.min(28, parseInt(r.value) + 1);
        r.dispatchEvent(new Event('input'));
    });
    document.getElementById('widthRange').addEventListener('input', function() {
        document.querySelector('.read-main').style.maxWidth = this.value + 'px';
        document.getElementById('widthText').innerText = this.value + 'px';
    });
    document.getElementById('widthMinus').addEventListener('click', function() {
        var r = document.getElementById('widthRange');
        r.value = Math.max(600, parseInt(r.value) - 50);
        r.dispatchEvent(new Event('input'));
    });
    document.getElementById('widthPlus').addEventListener('click', function() {
        var r = document.getElementById('widthRange');
        r.value = Math.min(1200, parseInt(r.value) + 50);
        r.dispatchEvent(new Event('input'));
    });
    document.getElementById('catalogBtn').addEventListener('click', openCatalog);
    document.getElementById('settingBtn').addEventListener('click', openSetting);
    document.getElementById('backTopBtn').addEventListener('click', function() {
        document.querySelector('.read-main').scrollTo({ top: 0, behavior: 'smooth' });
    });
    document.getElementById('exitReadBtn').addEventListener('click', closeReadModal);
    document.getElementById('drawerMask').addEventListener('click', closeAllDrawer);
    document.getElementById('catalogClose').addEventListener('click', closeAllDrawer);
    document.getElementById('settingClose').addEventListener('click', closeAllDrawer);

    // ================== 购物车功能 ==================
    function addToCart(bookId) {
        if (!isLogin) {
            alert('道友请先登录，方可请购典籍！');
            window.location.href = '${pageContext.request.contextPath}/login.jsp';
            return;
        }
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/cart', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 401) {
                    alert('请先登录');
                    window.location.href = '${pageContext.request.contextPath}/login.jsp';
                    return;
                }
                if (xhr.status === 200) {
                    try {
                        var res = JSON.parse(xhr.responseText);
                        alert(res.msg);
                        if (res.code === 200) loadCartList();
                    } catch (e) { alert('解析错误'); }
                } else { alert('请求失败'); }
            }
        };
        xhr.send('action=add&bookId=' + bookId + '&buyNum=1');
    }

    function loadCartList() {
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/cart', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                try {
                    var res = JSON.parse(xhr.responseText);
                    if (res.code === 200) renderCartList(res.data);
                    else alert(res.msg);
                } catch (e) { alert('解析错误'); }
            }
        };
        xhr.send('action=list');
    }

    function renderCartList(data) {
        if (!data || data.length === 0) {
            cartEmpty.style.display = 'block';
            cartList.style.display = 'none';
            cartFooter.style.display = 'none';
            cartBadge.innerText = '0';
            return;
        }
        cartEmpty.style.display = 'none';
        cartList.style.display = 'flex';
        cartFooter.style.display = 'block';
        var html = '', total = 0, totalNum = 0;
        for (var i = 0; i < data.length; i++) {
            var item = data[i];
            var sub = item.book.price * item.buyNum;
            total += sub;
            totalNum += item.buyNum;
            html += '<div class="cart-item">' +
                '<div class="cart-item-info"><div class="cart-item-title">' + item.book.bookTitle + '</div>' +
                '<div class="cart-item-author">作者：' + item.book.bookAuthor + '</div>' +
                '<div class="cart-item-price">单本香火：' + item.book.price.toFixed(2) + ' 灵石</div></div>' +
                '<div class="cart-item-num">' +
                '<button class="num-btn" onclick="updateNum(\'' + item.id + '\', ' + (item.buyNum - 1) + ')">-</button>' +
                '<input type="text" class="num-input" value="' + item.buyNum + '" readonly>' +
                '<button class="num-btn" onclick="updateNum(\'' + item.id + '\', ' + (item.buyNum + 1) + ')">+</button></div>' +
                '<div class="cart-item-delete" onclick="deleteCartItem(\'' + item.id + '\')">×</div></div>';
        }
        cartList.innerHTML = html;
        cartTotal.innerText = total.toFixed(2);
        cartBadge.innerText = totalNum;
    }

    function updateNum(cartId, newNum) {
        if (newNum < 1) { if (confirm("确定移出？")) deleteCartItem(cartId); return; }
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/cart', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                try {
                    var res = JSON.parse(xhr.responseText);
                    if (res.code === 200) loadCartList();
                    else alert(res.msg);
                } catch (e) { alert('解析错误'); }
            }
        };
        xhr.send('action=update&cartId=' + cartId + '&newBuyNum=' + newNum);
    }

    function deleteCartItem(cartId) {
        if (!confirm("确定移出？")) return;
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/cart', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                try {
                    var res = JSON.parse(xhr.responseText);
                    if (res.code === 200) loadCartList();
                    else alert(res.msg);
                } catch (e) { alert('解析错误'); }
            }
        };
        xhr.send('action=delete&cartId=' + cartId);
    }

    clearCartBtn.onclick = function() {
        if (!confirm("清空藏经袋？")) return;
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/cart', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                try {
                    var res = JSON.parse(xhr.responseText);
                    if (res.code === 200) loadCartList();
                    else alert(res.msg);
                } catch (e) { alert('解析错误'); }
            }
        };
        xhr.send('action=clear');
    };

    settleBtn.onclick = function() {
        if (!isLogin) { alert('请先登录'); window.location.href = '${pageContext.request.contextPath}/login.jsp'; return; }
        var total = parseFloat(cartTotal.innerText);
        if (total <= 0) { alert('藏经袋空空'); return; }
        window.location.href = '${pageContext.request.contextPath}/orderSettle';
    };

    cartIcon.onclick = function() { cartModal.style.display = 'flex'; loadCartList(); };
    cartClose.onclick = function() { cartModal.style.display = 'none'; };
    function closeCartModal() { cartModal.style.display = 'none'; }
    cartModal.onclick = function(e) { if (e.target === cartModal) closeCartModal(); };

    // 键盘事件
    document.onkeydown = function(e) {
        e = e || window.event;
        if (e.keyCode === 27) {
            closeTitleModal(); closeAddForm(); closeDetailModal(); closeReadModal(); closeCartModal(); closeAllDrawer();
        }
        if (readPage.style.display === 'block') {
            if (e.keyCode === 37) preChapter();
            if (e.keyCode === 39) nextChapter();
        }
    };

    // 符文特效（不拦截导航）
    var runeLibrary = ['临','兵','斗','者','皆','列','阵','在','前'];
    document.addEventListener('click', function(e) {
        if (e.target.closest('.nav-sidebar .nav-item')) return;
        var wave = document.createElement('div'); wave.className = 'sword-wave';
        wave.style.left = e.clientX + 'px'; wave.style.top = e.clientY + 'px';
        document.body.appendChild(wave);
        setTimeout(function() { wave.classList.add('wave-animate'); }, 10);
        wave.addEventListener('animationend', function() { this.remove(); });
        var rune = runeLibrary[Math.floor(Math.random() * runeLibrary.length)];
        var runeEl = document.createElement('div'); runeEl.className = 'rune-text'; runeEl.innerText = rune;
        runeEl.style.left = (e.clientX - 16) + 'px'; runeEl.style.top = (e.clientY - 20) + 'px';
        document.body.appendChild(runeEl);
        setTimeout(function() { runeEl.classList.add('rune-animate'); }, 10);
        runeEl.addEventListener('animationend', function() { this.remove(); });
    });

    // 自动打开私人藏经阁跳转
    document.addEventListener('DOMContentLoaded', function() {
        if (isLogin) loadCartList();
        var urlParams = new URLSearchParams(window.location.search);
        var targetBookId = urlParams.get('targetBookId');
        if (!targetBookId || isNaN(targetBookId)) return;
        var retry = 0;
        var interval = setInterval(function() {
            retry++;
            var card = document.querySelector('.book-card[data-book-id="' + targetBookId + '"]');
            if (card) {
                clearInterval(interval);
                card.scrollIntoView({ behavior: 'smooth', block: 'center' });
                setTimeout(function() { openReadModal(card); }, 300);
            }
            if (retry >= 30) clearInterval(interval);
        }, 100);
    });
</script>
</body>
</html>