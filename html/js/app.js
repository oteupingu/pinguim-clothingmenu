console.log('[MenuClothes NUI] app.js carregado');

// objeto que guarda estado dos itens
const itemStates = {};

// função para atualizar visual do item
function updateItemState(id, active) {
    const el = document.getElementById(id);
    if (el) {
        if (active) el.classList.add('active');
        else el.classList.remove('active');
    }
}

// listener NUI
window.addEventListener('message', function (event) {
    const item = event.data;

    switch (item.action) {
        case 'show':
            $('.container').fadeIn(500);

            // aplica estado salvo
            Object.keys(itemStates).forEach(id => updateItemState(id, itemStates[id]));
            break;

        case 'hide':
            $('.container').fadeOut(500);
            break;
    }
});

// clique nos itens
const items = document.querySelectorAll('.item');
items.forEach(item => {
    item.addEventListener('click', () => {
        const id = item.id;
        const active = !item.classList.contains('active');

        updateItemState(id, active);

        // salva estado
        itemStates[id] = active;

        // envia pro Lua
        $.post(`https://${GetParentResourceName()}/select`, JSON.stringify({ item: id }));
    });
});

// resetar itens
$('.reset').on('click', function () {
    Object.keys(itemStates).forEach(key => itemStates[key] = false);
    $('.item').removeClass('active');
    $.post(`https://${GetParentResourceName()}/reset`);
});

// fechar menu com ESC (27) ou Backspace (8)
document.onkeyup = function (e) {
    if (e.which === 27 || e.which === 8) {
        $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
    }
};
