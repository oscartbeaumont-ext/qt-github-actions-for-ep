function createElement(tag, initialClass = null, style = null) {
    let elem = document.createElement(tag);
    if (initialClass && initialClass.trim().length > 0)
        elem.classList.add(initialClass);
    if (style) {
        Object.keys(style).forEach(key => {
            elem.style[key] = style[key];
        });
    }
    return elem;
}