document.addEventListener("DOMContentLoaded", () => {

    window.addEventListener("message", (event) => {
        if (event.data.action === "open") {
            document.getElementById("cityMenu").classList.remove("hidden");
            showMainMenu();
        } else if (event.data.action === "showContent") {
            const mainHeader = document.getElementById("mainHeader");
            if (mainHeader) mainHeader.classList.add("hidden"); // hide header
            const mainOptions = document.getElementById("mainOptions");
            if (mainOptions) mainOptions.classList.add("hidden");
            const contentSection = document.getElementById("contentSection");
            if (contentSection) contentSection.classList.remove("hidden");
            const contentHeader = document.getElementById("contentHeader");
            const contentText = document.getElementById("contentText");
            if (contentHeader) contentHeader.innerText = event.data.header;
            if (contentText) contentText.innerText = event.data.content;
        }
    });

    function closeMenu() {
        document.getElementById("cityMenu").classList.add("hidden");
        fetch(`https://${GetParentResourceName()}/close`, { method: "POST" });
    }

    function selectOption(option) {
        fetch(`https://${GetParentResourceName()}/selectOption`, {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=UTF-8" },
            body: JSON.stringify({ option })
        });
    }

    function backToMenu() {
        const contentSection = document.getElementById("contentSection");
        if (contentSection) contentSection.classList.add("hidden");
        const mainHeader = document.getElementById("mainHeader");
        if (mainHeader) mainHeader.classList.remove("hidden"); // show header again
        showMainMenu();
    }

    function showMainMenu() {
        const mainOptions = document.getElementById("mainOptions");
        if (mainOptions) mainOptions.classList.remove("hidden");
    }

    // Expose functions to global scope for onclick
    window.closeMenu = closeMenu;
    window.selectOption = selectOption;
    window.backToMenu = backToMenu;

});
