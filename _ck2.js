(async function () {
    var out = [];
    function log(n, ok, extra) {
        out.push((ok ? 'PASS' : 'FAIL') + ' | ' + n + (extra ? ' | ' + extra : ''));
        var el = document.getElementById('OUT');
        if (el) el.textContent = out.join('\n');
    }
    function esperar(ms) { return new Promise(function (r) { setTimeout(r, ms); }); }
    try {
        localStorage.clear();
        var w = document.getElementById('cookieWidget');
        var b = document.getElementById('cookieBadge');
        var p = document.getElementById('cookiePopup');
        var link = document.getElementById('cookiePolicyLink');
        log('cookieWidget en DOM', !!w);
        log('cookieBadge en DOM', !!b);
        log('cookiePopup en DOM', !!p);
        log('enlace a cookies.html en DOM', !!link, link ? link.getAttribute('href') : 'n/a');
        log('enlace apunta a cookies.html', !!link && link.getAttribute('href') === 'cookies.html');
        // No aparece solo
        log('popup cerrado al cargar (no aparece solo)', !!p && !p.classList.contains('open'));
        await esperar(1500);
        log('popup sigue cerrado tras 1.5s', !!p && !p.classList.contains('open'));
        // Badge visible y discreto
        var bs = b ? getComputedStyle(b) : null;
        log('badge visible', !!bs && bs.display !== 'none' && bs.visibility !== 'hidden', bs ? bs.display : 'n/a');
        var r = b ? b.getBoundingClientRect() : null;
        log('badge pequeno (no intrusivo)', !!r && r.width < 120 && r.height < 120, r ? Math.round(r.width) + 'x' + Math.round(r.height) : 'n/a');
        // Abrir al clic
        if (b) { b.click(); await esperar(400); }
        log('popup se abre al pulsar el badge', !!p && p.classList.contains('open'));
        // Cerrar
        var cb = document.getElementById('cookieClose');
        log('boton cerrar en DOM', !!cb);
        if (cb) { cb.click(); await esperar(400); }
        log('popup se cierra con el boton cerrar', !!p && !p.classList.contains('open'));
        await esperar(2600);
        log('popup NO reaparece solo tras cerrar', !!p && !p.classList.contains('open'));
        // Reabrir con Enter (accesibilidad)
        if (b) {
            b.dispatchEvent(new KeyboardEvent('keydown', { key: 'Enter', bubbles: true }));
            await esperar(400);
        }
        log('popup se abre con tecla Enter', !!p && p.classList.contains('open'));
        // ESC cierra
        document.dispatchEvent(new KeyboardEvent('keydown', { key: 'Escape', bubbles: true }));
        await esperar(400);
        log('popup se cierra con ESC', !!p && !p.classList.contains('open'));
    } catch (e) {
        log('EXCEPCION', false, e && e.message ? e.message : String(e));
    }
    var el2 = document.getElementById('OUT');
    if (el2) el2.textContent = out.join('\n') + '\n<<<FIN>>>';
})();
