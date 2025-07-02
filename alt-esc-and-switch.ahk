~Alt Up::
if cycling
    forward := !forward
cycling := false
return

!Tab::Cycle(forward)
!+Tab::Cycle(!forward)

Cycle(direction)
{
    global cycling
    if direction
    {
        send !{Escape}
    }
    else
    {
        send !+{Escape}
    }
    cycling := true
}

!Escape::!Tab

