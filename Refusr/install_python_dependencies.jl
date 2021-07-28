#! /usr/bin/env julia

using Pkg
Pkg.activate(".")

using PyCall
pip = pyimport("pip")
pip.main(["install", "-r", "requirements.txt"])
