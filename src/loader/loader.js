window.onload = function () {
    new QWebChannel(qt.webChannelTransport, (channel) => {
        var manager = channel.objects.manager;

        manager.serviceLoad.connect(function (serviceRaw) {
            let service = JSON.parse(serviceRaw);

            let img = createElement('img');
            if(service.logo) {   
                img.setAttribute('id', service.name);
                img.setAttribute('src', service.logo);
                img.setAttribute('alt', service.name);
            }

            // create loader element
            let loader = createElement('div', 'loader', {
                top: `${img.getBoundingClientRect().top}px`,
                left: `${img.getBoundingClientRect().left}px`
            });

            // create ripple element
            let ripple = createElement('div', 'ripple', {
                backgroundColor: service.color
            });

            // append ripple and img to loader
            loader.appendChild(ripple);
            loader.appendChild(img);

            document.body.replaceChild(loader, document.body.childNodes[0]);

            loader.style.top = '50%';
            loader.style.left = '50%';
            loader.style.transform = 'translate(-50%, -50%)';
        });
    });
}