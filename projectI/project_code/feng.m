function [B, z] = feng(A, y)

B = (orth(A'))';
if(nargout == 2)
    z = B * pinv(A) * y;
end

end