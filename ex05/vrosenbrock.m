function z = vrosenbrock(x,y)

FUN = 1;

if FUN == 1
    z = 0.5*(10*(y - x.^2)).^2 + 0.5*(1-x).^2 + 0.5*y.^2;
elseif FUN == 2
    z = (10*(y - x.^2)).^2 + (1-x).^2;
end

end