document.addEventListener('DOMContentLoaded', function() {
    const images = document.querySelectorAll('.photo img');
    images.forEach(img => {
        img.addEventListener('click', function() {
            const lightbox = document.createElement('div');
            lightbox.style.position = 'fixed';
            lightbox.style.top = 0;
            lightbox.style.left = 0;
            lightbox.style.width = '100%';
            lightbox.style.height = '100%';
            lightbox.style.backgroundColor = 'rgba(0,0,0,0.8)';
            lightbox.style.display = 'flex';
            lightbox.style.alignItems = 'center';
            lightbox.style.justifyContent = 'center';
            lightbox.style.zIndex = 1000;
            const imgClone = img.cloneNode();
            imgClone.style.maxWidth = '90%';
            imgClone.style.maxHeight = '90%';
            lightbox.appendChild(imgClone);
            lightbox.addEventListener('click', function() {
                document.body.removeChild(lightbox);
            });
            document.body.appendChild(lightbox);
        });
    });
});