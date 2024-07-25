if (dir.exists("index__files"))
    unlink("index__files", recursive = T)

litedown::reactor(
    fig.width = 10,
    fig.height = 5.5,
    message = FALSE,
    warning = FALSE,
    # attr.plot = ".fullwidth",
    # dev = "svg",
    results = "hold",
    dev = svglite::svglite,
    dev.args = list(bg = "transparent"),
    # wd = here::here(),
    comment = ""
)
litedown::fuse("main.Rmd", output="index.html")
