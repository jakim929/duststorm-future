pro compare1, h, i, j
j = fltarr(365)
for d = 1, 365 do begin
	j[d-1] = h[d-1] - i[d-1]
endfor
end