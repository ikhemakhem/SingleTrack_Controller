function x_new = discrete_singletrack(x_old, u, dt)
    x_new = x_old + singletrack(0, x_old)*dt;
end