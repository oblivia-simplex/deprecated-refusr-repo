module ACE11

using SerialPorts

##
# Note: This library is largely a port of the ctvelocio script for communicating with
#       ACE11s logic controllers. I'm following ControlThings-io's choice of terminology.
#       As I understand it, what the author calls "output bits", here, are output from
#       a system (the computer, for example), /into/ the PLC. This is why we we have
#       r/w access to the "output bits", but read-only access to the input bits, where
#       we read the PLC's /output/.
##

export on, off

on = true
off = false


BAUDRATE = 9600
PORTNAME = "/dev/ttyACM0"
DELAY = 0.1

function set_delay(t)
    global DELAY
    DELAY = t
end

GAP = 0x00
PREFIX = [0x56, 0xff, 0xff, 0x00]

function mk_write_command(bits::String, on)
    if bits == "all"
        return mk_write_command(1:6, on)
    else
        error("$bits is not a valid value for bits")
    end
end


function mk_write_command(bits, on)
    @assert all(1 <= i <= 6 for i in bits)
    mask = sum(1 << (i - 1) for i in bits)
    cmd = [
        PREFIX...,
        0x15,
        0x11,
        0x01,
        0x00,
        0x01,
        0x00,
        0x00,
        0x09,
        0x01,
        0x00,
        0x00,
        0x01,
        0x00,
        GAP,
        0x00,
        0x00,
        GAP,
    ]
    cmd[18] = mask
    cmd[21] = UInt8(on)
    return cmd
end


function mk_read_command(bit, output = false)
    cmd = [PREFIX..., 0x08, 0x0a, GAP, 0x01]
    idx = output ? bit + 6 : bit
    cmd[8] = idx
    return cmd
end


CONTROL_COMMANDS =
    [
        # control instructions
        "pause" => [PREFIX..., 0x07, 0xf1, 0x02],
        "play" => [PREFIX..., 0x07, 0xf1, 0x01],
        "reset" => [PREFIX..., 0x07, 0xf1, 0x06],
        "step_into" => [PREFIX..., 0x07, 0xf1, 0x03],
        "step_out" => [PREFIX..., 0x07, 0xf1, 0x04],
        "step_over" => [PREFIX..., 0x07, 0xf1, 0x05],
        "enter_debug" => [PREFIX..., 0x07, 0xf0, 0x02],
        "exit_debug" => [PREFIX..., 0x07, 0xf0, 0x01],
    ] |> Dict


function mk_control_command(name)
    return CONTROL_COMMANDS[name]
end

function send_commands(commands; portname = PORTNAME, baudrate = BAUDRATE)

    rx = []

    # LibSerialPort.open(portname, baudrate) do sp
    sp = SerialPort(portname, baudrate)
    if (@show bytesavailable(sp)) > 0

        #flush(sp)
    end

    for command in String.(commands)
        @show command
        write(sp, command)
        sleep(DELAY)

        rx_raw = []
        while bytesavailable(sp) > 0
            push!(rx_raw, read(sp))
        end

        sleep(DELAY)

        @show rx_raw

        push!(rx, rx_raw)

    end
    close(sp)

    return rx
end


MOCKUP = nothing


function install_mockup(f)
    global MOCKUP = f
end


function uninstall_mockup()
    global MOCKUP = nothing
end


# This function lets us treat the device like a black boxed boolean function
# of up to 6 variables.
function call_boolean(
    args::Vector{Bool};
    ret_bits = [1],
    portname = PORTNAME,
    baudrate = BAUDRATE,
    mockup::Union{Nothing,Function} = MOCKUP,
)
    @assert length(args) <= 6
    if mockup !== nothing
        return mockup(args...)
    end
    bits = [i for (i, x) in enumerate(args) if x]
    write_cmds = [
        mk_write_command(1:6, false),  # set all the bits to the off position
        mk_write_command(bits, true),  # set the true bits to the on position
    ]
    read_cmds = [mk_read_command(i) for i in ret_bits]
    cmds = [
        CONTROL_COMMANDS["reset"],     # reset the routine to the beginning
        write_cmds...,
        CONTROL_COMMANDS["play"],      # start the routine at the current position
        read_cmds...,                  # Read the return value in designated pins
        CONTROL_COMMANDS["pause"],     # pause the routine at the current position
    ]
    @show received = send_commands(write_cmds)
    # Now we just need to decode the return message
    return false # FIXME
end









end # module
