function chi = cost_fun(ref,def)
chi = sum((ref-def).^2);
end