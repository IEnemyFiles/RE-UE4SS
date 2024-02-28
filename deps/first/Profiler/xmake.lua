local projectName = "Profiler"

includes("deps/Tracy")

add_requires("Tracy", { optional = true })
add_requires("Superluminal", { system = true, optional = true })

option("profilerFlavor")
    set_default("Tracy")
    set_showmenu(true)
    set_values("Tracy", "Superluminal", "None")

target(projectName)
    set_kind("headeronly")
    add_options("profilerFlavor")
    set_languages("cxx20")
    set_exceptions("cxx")

    add_includedirs("include", { public = true })
    add_headerfiles("include/**.hpp")

    on_load(function (target)
        import("target_helpers", { rootdir = get_config("ue4ssRoot") })
        
        print("Project: " .. projectName .. " (HEADER-ONLY)")

        target:add("defines", target_helpers.project_name_to_exports_define(projectName))
        target:add("defines", target_helpers.project_name_to_build_static_define(projectName), { public = true })

        local flavor = get_config("profilerFlavor")

        if flavor == "Tracy" then
            target:add("packages", "Tracy", { public = true })
            target:add("defines", "IS_TRACY=1", "IS_SUPERLUMINAL=0", { public = true })
        elseif flavor == "Superluminal" then
            target:add("packages", "Superluminal", { public = true })
            target:add("defines", "IS_TRACY=0", "IS_SUPERLUMINAL=1", { public = true })
        elseif flavor == "None" then
            target:add("defines", "IS_TRACY=0", "IS_SUPERLUMINAL=0", "DISABLE_PROFILER", { public = true })
        end
    end)
    