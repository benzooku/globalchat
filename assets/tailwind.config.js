// FILE ONLY FOR LSP, CHANGES DONT TAKE EFFECT ON TAILWIND!!!

module.exports = {
    content: [
        "../lib/**/*.{heex,eex,ex}", // Phoenix templates
        "./js/**/*.{js,ts,jsx,tsx}",
    ],
    theme: {
        extend: {},
    },
    plugins: [
        require("daisyui"), // only if you use DaisyUI
    ],
}

