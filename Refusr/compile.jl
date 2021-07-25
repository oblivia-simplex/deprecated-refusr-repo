using Pkg
Pkg.activate(".")
using PackageCompiler
using TOML

package_names = TOML.parse(read("Project.toml", String))["deps"] |> keys |> collect |> sort
packages = Symbol.(package_names)

@info "Compiling sysimage with the following packages:\n$(join(package_names, "\n"))"

@time PackageCompiler.create_sysimage(packages, sysimage_path="refusr.so")
