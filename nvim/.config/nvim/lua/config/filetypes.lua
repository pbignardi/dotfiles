-- go/template filetype
vim.filetype.add({
    extension = {
        gotmpl = 'gotmpl',
        tmpl = 'gotmpl',
    },
    pattern = {
        [".*/templates/.*%.tpl"] = "helm",
        [".*/templates/.*%.ya?ml"] = "helm",
        ["helmfile.*%.ya?ml"] = "helm",
    },
})

-- gams filetype
vim.filetype.add({
    extension = {
        gms = 'gams',
    }
})

