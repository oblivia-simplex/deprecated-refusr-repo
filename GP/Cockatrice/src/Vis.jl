module Vis

using RecursiveArrayTools
using ImageView, Gtk.ShortNames, Images

function process_images(arr; color = nothing)
    m = maximum.(arr) |> maximum
    normed = m > 0.0 ? arr ./ m : arr
    finite = (A -> (a -> isfinite(a) ? Float64(a) : 0.0).(A)).(arr)
    @show typeof(finite)
    if color !== nothing
        finite .* color
    else
        finite
    end
end



function trace_video(evo; key = "fitness_1", color = colorant"green")
    trace = process_images(evo.trace[key], color = color)
    fvec = VectorOfArray(trace)
    video = convert(Array, fvec)
    AxisArray(video)
end


function display_images(images; dims = (300, 300), gui = nothing)
    rows, cols = size(images)
    show = ImageView.imshow!
    if gui ≡ nothing
        gui = imshow_gui(dims, (rows, cols))
        show = ImageView.imshow
    end
    canvases = gui["canvas"]

    for r = 1:rows
        for c = 1:cols
            i = r * c
            image = images[r, c]
            if image !== nothing
                show(canvases[r, c], images[r, c])
            end
        end
    end

    Gtk.showall(gui["window"])
    gui
end

end # module
